package fr.cea.nabla.interpreter.nodes.interop;

import com.oracle.truffle.api.dsl.Cached;
import com.oracle.truffle.api.interop.InteropLibrary;
import com.oracle.truffle.api.interop.InvalidArrayIndexException;
import com.oracle.truffle.api.interop.TruffleObject;
import com.oracle.truffle.api.library.ExportLibrary;
import com.oracle.truffle.api.library.ExportMessage;
import com.oracle.truffle.api.profiles.BranchProfile;

@ExportLibrary(InteropLibrary.class)
public final class NodeObjectDescriptorKeys implements TruffleObject {

    private final String keyName;

    NodeObjectDescriptorKeys(String keyName) {
        this.keyName = keyName;
    }

    @ExportMessage
    @SuppressWarnings("static-method")
    boolean hasArrayElements() {
        return true;
    }

    @ExportMessage
    @SuppressWarnings("static-method")
    boolean isArrayElementReadable(long index) {
        return index >= 0 && index < 1;
    }

    @ExportMessage
    @SuppressWarnings("static-method")
    long getArraySize() {
        return 1;
    }

    @ExportMessage
    Object readArrayElement(long index, @Cached BranchProfile exception) throws InvalidArrayIndexException {
        if (!isArrayElementReadable(index)) {
            exception.enter();
            throw InvalidArrayIndexException.create(index);
        }
        return keyName;
    }

}
