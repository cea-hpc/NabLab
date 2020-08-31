package fr.cea.nabla.interpreter.nodes.interop;

import com.oracle.truffle.api.CompilerDirectives;
import com.oracle.truffle.api.instrumentation.StandardTags;
import com.oracle.truffle.api.interop.InteropLibrary;
import com.oracle.truffle.api.interop.TruffleObject;
import com.oracle.truffle.api.interop.UnknownIdentifierException;
import com.oracle.truffle.api.library.ExportLibrary;
import com.oracle.truffle.api.library.ExportMessage;

public abstract class NodeObjectDescriptor implements TruffleObject {

    private final String name;

    private NodeObjectDescriptor(String name) {
        assert name != null;
        this.name = name;
    }

    public static NodeObjectDescriptor readVariable(String name) {
        return new ReadDescriptor(name);
    }

    public static NodeObjectDescriptor writeVariable(String name) {
        return new WriteDescriptor(name);
    }

    Object readMember(String member) throws UnknownIdentifierException {
        if (isMemberReadable(member)) {
            return name;
        } else {
            CompilerDirectives.transferToInterpreter();
            throw UnknownIdentifierException.create(member);
        }
    }

    abstract boolean isMemberReadable(String member);

    @ExportLibrary(InteropLibrary.class)
    static final class ReadDescriptor extends NodeObjectDescriptor {

        private static final TruffleObject KEYS_READ = new NodeObjectDescriptorKeys(StandardTags.ReadVariableTag.NAME);

        ReadDescriptor(String name) {
            super(name);
        }

        @ExportMessage
        @SuppressWarnings("static-method")
        boolean hasMembers() {
            return true;
        }

        @Override
        @ExportMessage
        boolean isMemberReadable(String member) {
            return StandardTags.ReadVariableTag.NAME.equals(member);
        }

        @ExportMessage
        @SuppressWarnings("static-method")
        Object getMembers(@SuppressWarnings("unused") boolean includeInternal) {
            return KEYS_READ;
        }

        @Override
        @ExportMessage
        Object readMember(String member) throws UnknownIdentifierException {
            return super.readMember(member);
        }
    }

    @ExportLibrary(InteropLibrary.class)
    static final class WriteDescriptor extends NodeObjectDescriptor {

        private static final TruffleObject KEYS_WRITE = new NodeObjectDescriptorKeys(StandardTags.WriteVariableTag.NAME);

        WriteDescriptor(String name) {
            super(name);
        }

        @ExportMessage
        @SuppressWarnings("static-method")
        boolean hasMembers() {
            return true;
        }

        @Override
        @ExportMessage
        boolean isMemberReadable(String member) {
            return StandardTags.WriteVariableTag.NAME.equals(member);
        }

        @ExportMessage
        @SuppressWarnings("static-method")
        Object getMembers(@SuppressWarnings("unused") boolean includeInternal) {
            return KEYS_WRITE;
        }

        @Override
        @ExportMessage
        Object readMember(String member) throws UnknownIdentifierException {
            return super.readMember(member);
        }
    }
}
