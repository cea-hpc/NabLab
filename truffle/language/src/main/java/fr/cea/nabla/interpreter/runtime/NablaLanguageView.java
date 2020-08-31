package fr.cea.nabla.interpreter.runtime;

import com.oracle.truffle.api.CompilerDirectives;
import com.oracle.truffle.api.CompilerDirectives.TruffleBoundary;
import com.oracle.truffle.api.TruffleLanguage;
import com.oracle.truffle.api.interop.InteropLibrary;
import com.oracle.truffle.api.interop.TruffleObject;
import com.oracle.truffle.api.interop.UnsupportedMessageException;
import com.oracle.truffle.api.library.CachedLibrary;
import com.oracle.truffle.api.library.ExportLibrary;
import com.oracle.truffle.api.library.ExportMessage;
import com.oracle.truffle.api.nodes.ExplodeLoop;

import fr.cea.nabla.interpreter.NablaLanguage;

@ExportLibrary(value = InteropLibrary.class, delegateTo = "delegate")
@SuppressWarnings("static-method")
public final class NablaLanguageView implements TruffleObject {

    final Object delegate;

    NablaLanguageView(Object delegate) {
        this.delegate = delegate;
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
    @ExplodeLoop
    boolean hasMetaObject(@CachedLibrary("this.delegate") InteropLibrary interop) {
        for (NablaType type : NablaType.PRECEDENCE) {
            if (type.isInstance(delegate, interop)) {
                return true;
            }
        }
        return false;
    }

    @ExportMessage
    @ExplodeLoop
    Object getMetaObject(@CachedLibrary("this.delegate") InteropLibrary interop) throws UnsupportedMessageException {
        for (NablaType type : NablaType.PRECEDENCE) {
            if (type.isInstance(delegate, interop)) {
                return type;
            }
        }
        throw UnsupportedMessageException.create();
    }

    @ExportMessage
    @ExplodeLoop
    Object toDisplayString(@SuppressWarnings("unused") boolean allowSideEffects, @CachedLibrary("this.delegate") InteropLibrary interop) {
        for (NablaType type : NablaType.PRECEDENCE) {
            if (type.isInstance(this.delegate, interop)) {
                try {
                    if (type == NablaType.NUMBER) {
                        return longToString(interop.asLong(delegate));
                    } else if (type == NablaType.BOOLEAN) {
                        return Boolean.toString(interop.asBoolean(delegate));
                    } else {
                        return type.getName();
                    }
                } catch (UnsupportedMessageException e) {
                    CompilerDirectives.transferToInterpreter();
                    throw new AssertionError();
                }
            }
        }
        return "Unsupported";
    }

    @TruffleBoundary
    private static String longToString(long l) {
        return Long.toString(l);
    }

    public static Object create(Object value) {
        assert isPrimitiveOrFromOtherLanguage(value);
        return new NablaLanguageView(value);
    }

    private static boolean isPrimitiveOrFromOtherLanguage(Object value) {
        InteropLibrary interop = InteropLibrary.getFactory().getUncached(value);
        try {
            return !interop.hasLanguage(value) || interop.getLanguage(value) != NablaLanguage.class;
        } catch (UnsupportedMessageException e) {
            CompilerDirectives.transferToInterpreter();
            throw new AssertionError(e);
        }
    }

    @TruffleBoundary
    public static Object forValue(Object value) {
        if (value == null) {
            return null;
        }
        InteropLibrary lib = InteropLibrary.getFactory().getUncached(value);
        try {
            if (lib.hasLanguage(value) && lib.getLanguage(value) == NablaLanguage.class) {
                return value;
            } else {
                return create(value);
            }
        } catch (UnsupportedMessageException e) {
            CompilerDirectives.transferToInterpreter();
            throw new AssertionError(e);
        }
    }

}
