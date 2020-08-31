package fr.cea.nabla.interpreter.runtime;

import com.oracle.truffle.api.CompilerAsserts;
import com.oracle.truffle.api.CompilerDirectives.CompilationFinal;
import com.oracle.truffle.api.CompilerDirectives.TruffleBoundary;
import com.oracle.truffle.api.TruffleLanguage;
import com.oracle.truffle.api.dsl.Cached;
import com.oracle.truffle.api.dsl.Specialization;
import com.oracle.truffle.api.interop.InteropLibrary;
import com.oracle.truffle.api.interop.TruffleObject;
import com.oracle.truffle.api.library.CachedLibrary;
import com.oracle.truffle.api.library.ExportLibrary;
import com.oracle.truffle.api.library.ExportMessage;

import fr.cea.nabla.interpreter.NablaLanguage;

@ExportLibrary(InteropLibrary.class)
@SuppressWarnings("static-method")
public final class NablaType implements TruffleObject {

    public static final NablaType NUMBER = new NablaType("Number", (l, v) -> l.fitsInLong(v) || l.fitsInDouble(v));
    public static final NablaType BOOLEAN = new NablaType("Boolean", (l, v) -> l.isBoolean(v));
    public static final NablaType ARRAY = new NablaType("Array", (l, v) -> l.hasArrayElements(v));

    @CompilationFinal(dimensions = 1) public static final NablaType[] PRECEDENCE = new NablaType[]{NUMBER, BOOLEAN, ARRAY};

    private final String name;
    private final TypeCheck isInstance;

    private NablaType(String name, TypeCheck isInstance) {
        this.name = name;
        this.isInstance = isInstance;
    }

    /**
     * Checks whether this type is of a certain instance. If used on fast-paths it is required to
     * cast {@link NablaType} to a constant.
     */
    public boolean isInstance(Object value, InteropLibrary interop) {
        CompilerAsserts.partialEvaluationConstant(this);
        return isInstance.check(interop, value);
    }

    @ExportMessage
    boolean hasLanguage() {
        return true;
    }

    @ExportMessage
    Class<? extends TruffleLanguage<?>> getLanguage() {
        return NablaLanguage.class;
    }

    @ExportMessage
    boolean isMetaObject() {
        return true;
    }

    @ExportMessage(name = "getMetaQualifiedName")
    @ExportMessage(name = "getMetaSimpleName")
    public Object getName() {
        return name;
    }

    @ExportMessage(name = "toDisplayString")
    Object toDisplayString(@SuppressWarnings("unused") boolean allowSideEffects) {
        return name;
    }

    @Override
    public String toString() {
        return "NablaType[" + name + "]";
    }

    @ExportMessage
    static class IsMetaInstance {

        @Specialization(guards = "type == cachedType", limit = "3")
        static boolean doCached(@SuppressWarnings("unused") NablaType type, Object value,
                        @Cached("type") NablaType cachedType,
                        @CachedLibrary("value") InteropLibrary valueLib) {
            return cachedType.isInstance.check(valueLib, value);
        }

        @TruffleBoundary
        @Specialization(replaces = "doCached")
        static boolean doGeneric(NablaType type, Object value) {
            return type.isInstance.check(InteropLibrary.getFactory().getUncached(), value);
        }
    }

    @FunctionalInterface
    interface TypeCheck {

        boolean check(InteropLibrary lib, Object value);

    }

}
