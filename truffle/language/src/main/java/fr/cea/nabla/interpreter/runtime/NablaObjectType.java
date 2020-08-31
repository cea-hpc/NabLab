package fr.cea.nabla.interpreter.runtime;

import com.oracle.truffle.api.CompilerAsserts;
import com.oracle.truffle.api.CompilerDirectives;
import com.oracle.truffle.api.CompilerDirectives.TruffleBoundary;
import com.oracle.truffle.api.dsl.Cached;
import com.oracle.truffle.api.dsl.GenerateUncached;
import com.oracle.truffle.api.dsl.Specialization;
import com.oracle.truffle.api.interop.InteropLibrary;
import com.oracle.truffle.api.interop.InvalidArrayIndexException;
import com.oracle.truffle.api.interop.TruffleObject;
import com.oracle.truffle.api.interop.UnknownIdentifierException;
import com.oracle.truffle.api.library.CachedLibrary;
import com.oracle.truffle.api.library.ExportLibrary;
import com.oracle.truffle.api.library.ExportMessage;
import com.oracle.truffle.api.object.DynamicObject;
import com.oracle.truffle.api.object.FinalLocationException;
import com.oracle.truffle.api.object.IncompatibleLocationException;
import com.oracle.truffle.api.object.Location;
import com.oracle.truffle.api.object.ObjectType;
import com.oracle.truffle.api.object.Property;
import com.oracle.truffle.api.object.Shape;

@ExportLibrary(value = InteropLibrary.class, receiverType = DynamicObject.class)
public final class NablaObjectType extends ObjectType {

    protected static final int CACHE_LIMIT = 3;
    public static final ObjectType SINGLETON = new NablaObjectType();

    private NablaObjectType() {
    }

    @Override
    public Class<?> dispatch() {
        return NablaObjectType.class;
    }

    @ExportMessage
    @SuppressWarnings("unused")
    static boolean hasMembers(DynamicObject receiver) {
        return true;
    }

    @ExportMessage
    static boolean removeMember(DynamicObject receiver, String member) throws UnknownIdentifierException {
        if (receiver.containsKey(member)) {
            return receiver.delete(member);
        } else {
            throw UnknownIdentifierException.create(member);
        }
    }

    @ExportMessage
    @SuppressWarnings("unused")
    static class GetMembers {

        @Specialization(guards = "receiver.getShape() == cachedShape")
        static Keys doCached(DynamicObject receiver, boolean includeInternal, //
                        @Cached("receiver.getShape()") Shape cachedShape, //
                        @Cached(value = "doGeneric(receiver, includeInternal)", allowUncached = true) Keys cachedKeys) {
            return cachedKeys;
        }

        @Specialization(replaces = "doCached")
        @TruffleBoundary
        static Keys doGeneric(DynamicObject receiver, boolean includeInternal) {
            return new Keys(receiver.getShape().getKeyList().toArray());
        }
    }

    @ExportMessage(name = "isMemberReadable")
    @ExportMessage(name = "isMemberModifiable")
    @ExportMessage(name = "isMemberRemovable")
    @SuppressWarnings("unused")
    static class ExistsMember {

        @Specialization(guards = {"receiver.getShape() == cachedShape", "cachedMember.equals(member)"})
        static boolean doCached(DynamicObject receiver, String member,
                        @Cached("receiver.getShape()") Shape cachedShape,
                        @Cached("member") String cachedMember,
                        @Cached("doGeneric(receiver, member)") boolean cachedResult) {
            assert cachedResult == doGeneric(receiver, member);
            return cachedResult;
        }

        @Specialization(replaces = "doCached")
        @TruffleBoundary
        static boolean doGeneric(DynamicObject receiver, String member) {
            return receiver.getShape().getProperty(member) != null;
        }
    }

    @ExportMessage
    @SuppressWarnings("unused")
    static boolean isMemberInsertable(DynamicObject receiver, String member,
                    @CachedLibrary("receiver") InteropLibrary receivers) {
        return !receivers.isMemberExisting(receiver, member);
    }

    static boolean shapeCheck(Shape shape, DynamicObject receiver) {
        return shape != null && shape.check(receiver);
    }

    @ExportLibrary(InteropLibrary.class)
    static final class Keys implements TruffleObject {

        private final Object[] keys;

        Keys(Object[] keys) {
            this.keys = keys;
        }

        @ExportMessage
        Object readArrayElement(long index) throws InvalidArrayIndexException {
            if (!isArrayElementReadable(index)) {
                throw InvalidArrayIndexException.create(index);
            }
            return keys[(int) index];
        }

        @SuppressWarnings("static-method")
        @ExportMessage
        boolean hasArrayElements() {
            return true;
        }

        @ExportMessage
        long getArraySize() {
            return keys.length;
        }

        @ExportMessage
        boolean isArrayElementReadable(long index) {
            return index >= 0 && index < keys.length;
        }
    }

    @GenerateUncached
    @ExportMessage
    abstract static class ReadMember {

        /**
         * Polymorphic inline cache for a limited number of distinct property names and shapes.
         */
        @Specialization(limit = "CACHE_LIMIT", //
                        guards = {
                                        "receiver.getShape() == cachedShape",
                                        "cachedName.equals(name)"
                        }, //
                        assumptions = "cachedShape.getValidAssumption()")
        static Object readCached(DynamicObject receiver, @SuppressWarnings("unused") String name,
                        @SuppressWarnings("unused") @Cached("name") String cachedName,
                        @Cached("receiver.getShape()") Shape cachedShape,
                        @Cached("lookupLocation(cachedShape, name)") Location location) {
            return location.get(receiver, cachedShape);
        }

        static Location lookupLocation(Shape shape, String name) throws UnknownIdentifierException {
            /* Initialization of cached values always happens in a slow path. */
            CompilerAsserts.neverPartOfCompilation();

            Property property = shape.getProperty(name);
            if (property == null) {
                /* Property does not exist. */
                throw UnknownIdentifierException.create(name);
            }

            return property.getLocation();
        }

        /**
         * The generic case is used if the number of shapes accessed overflows the limit of the
         * polymorphic inline cache.
         */
        @TruffleBoundary
        @Specialization(replaces = {"readCached"}, guards = "receiver.getShape().isValid()")
        static Object readUncached(DynamicObject receiver, String name) throws UnknownIdentifierException {
            Object result = receiver.get(name);
            if (result == null) {
                /* Property does not exist. */
                throw UnknownIdentifierException.create(name);
            }
            return result;
        }

        @Specialization(guards = "!receiver.getShape().isValid()")
        static Object updateShape(DynamicObject receiver, String name) throws UnknownIdentifierException {
            CompilerDirectives.transferToInterpreter();
            receiver.updateShape();
            return readUncached(receiver, name);
        }
    }

    @GenerateUncached
    @ExportMessage
    abstract static class WriteMember {

        /**
         * Polymorphic inline cache for writing a property that already exists (no shape change is
         * necessary).
         */
        @Specialization(limit = "CACHE_LIMIT", //
                        guards = {
                                        "cachedName.equals(name)",
                                        "shapeCheck(shape, receiver)",
                                        "location != null",
                                        "canSet(location, value)"
                        }, //
                        assumptions = {
                                        "shape.getValidAssumption()"
                        })
        static void writeExistingPropertyCached(DynamicObject receiver, @SuppressWarnings("unused") String name, Object value,
                        @SuppressWarnings("unused") @Cached("name") String cachedName,
                        @Cached("receiver.getShape()") Shape shape,
                        @Cached("lookupLocation(shape, name, value)") Location location) {
            try {
                location.set(receiver, value, shape);

            } catch (IncompatibleLocationException | FinalLocationException ex) {
                /* Our guards ensure that the value can be stored, so this cannot happen. */
                throw new IllegalStateException(ex);
            }
        }

        /**
         * Polymorphic inline cache for writing a property that does not exist yet (shape change is
         * necessary).
         */
        @Specialization(limit = "CACHE_LIMIT", //
                        guards = {
                                        "cachedName.equals(name)",
                                        "receiver.getShape() == oldShape",
                                        "oldLocation == null",
                                        "canStore(newLocation, value)"
                        }, //
                        assumptions = {
                                        "oldShape.getValidAssumption()",
                                        "newShape.getValidAssumption()"
                        })
        @SuppressWarnings("unused")
        static void writeNewPropertyCached(DynamicObject receiver, String name, Object value,
                        @Cached("name") Object cachedName,
                        @Cached("receiver.getShape()") Shape oldShape,
                        @Cached("lookupLocation(oldShape, name, value)") Location oldLocation,
                        @Cached("defineProperty(oldShape, name, value)") Shape newShape,
                        @Cached("lookupLocation(newShape, name)") Location newLocation) {
            try {
                newLocation.set(receiver, value, oldShape, newShape);

            } catch (IncompatibleLocationException ex) {
                /* Our guards ensure that the value can be stored, so this cannot happen. */
                throw new IllegalStateException(ex);
            }
        }

        /** Try to find the given property in the shape. */
        static Location lookupLocation(Shape shape, String name) {
            CompilerAsserts.neverPartOfCompilation();

            Property property = shape.getProperty(name);
            if (property == null) {
                /* Property does not exist yet, so a shape change is necessary. */
                return null;
            }

            return property.getLocation();
        }

        /**
         * Try to find the given property in the shape. Also returns null when the value cannot be
         * store into the location.
         */
        static Location lookupLocation(Shape shape, String name, Object value) {
            Location location = lookupLocation(shape, name);
            if (location == null || !location.canSet(value)) {
                /* Existing property has an incompatible type, so a shape change is necessary. */
                return null;
            }

            return location;
        }

        static Shape defineProperty(Shape oldShape, String name, Object value) {
            return oldShape.defineProperty(name, value, 0);
        }

        static boolean canSet(Location location, Object value) {
            return location.canSet(value);
        }

        static boolean canStore(Location location, Object value) {
            return location.canStore(value);
        }

        /**
         * The generic case is used if the number of shapes accessed overflows the limit of the
         * polymorphic inline cache.
         */
        @TruffleBoundary
        @Specialization(replaces = {"writeExistingPropertyCached", "writeNewPropertyCached"}, guards = {"receiver.getShape().isValid()"})
        static void writeUncached(DynamicObject receiver, String name, Object value) {
            receiver.define(name, value);
        }

        @TruffleBoundary
        @Specialization(guards = {"!receiver.getShape().isValid()"})
        static void updateShape(DynamicObject receiver, String name, Object value) {
            /*
             * Slow path that we do not handle in compiled code. But no need to invalidate compiled
             * code.
             */
            CompilerDirectives.transferToInterpreter();
            receiver.updateShape();
            writeUncached(receiver, name, value);
        }

    }

}
