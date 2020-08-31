package fr.cea.nabla.interpreter;

import com.oracle.truffle.api.CompilerDirectives.TruffleBoundary;
import com.oracle.truffle.api.TruffleException;
import com.oracle.truffle.api.interop.InteropLibrary;
import com.oracle.truffle.api.nodes.Node;
import com.oracle.truffle.api.nodes.NodeInfo;
import com.oracle.truffle.api.source.SourceSection;

import fr.cea.nabla.interpreter.runtime.NablaContext;

public class NablaException extends RuntimeException implements TruffleException {

	private static final long serialVersionUID = 2669879981236062957L;
	private final Node location;

    @TruffleBoundary
    public NablaException(String message, Node location) {
        super(message);
        this.location = location;
    }

    @SuppressWarnings("sync-override")
    @Override
    public final Throwable fillInStackTrace() {
        return this;
    }

    public Node getLocation() {
        return location;
    }
    
    @TruffleBoundary
    public static NablaException functionCallError(Node operation, Object... values) {
    	StringBuilder result = new StringBuilder();
        result.append("Function call error");
        
        if (operation != null) {
            SourceSection ss = operation.getEncapsulatingSourceSection();
            if (ss != null && ss.isAvailable()) {
                result.append(" at ").append(ss.getSource().getName()).append(" line ").append(ss.getStartLine()).append(" col ").append(ss.getStartColumn());
            }
        }
        
        result.append(": operation");
        if (operation != null) {
            NodeInfo nodeInfo = NablaContext.lookupNodeInfo(operation.getClass());
            if (nodeInfo != null) {
                result.append(" \"").append(nodeInfo.shortName()).append("\"");
            }
        }
        
        return new NablaException(result.toString(), operation);
    }
    
    @TruffleBoundary
    public static NablaException typeError(Node operation, Object... values) {
        StringBuilder result = new StringBuilder();
        result.append("Type error");

        if (operation != null) {
            SourceSection ss = operation.getEncapsulatingSourceSection();
            if (ss != null && ss.isAvailable()) {
                result.append(" at ").append(ss.getSource().getName()).append(" line ").append(ss.getStartLine()).append(" col ").append(ss.getStartColumn());
            }
        }

        result.append(": operation");
        if (operation != null) {
            NodeInfo nodeInfo = NablaContext.lookupNodeInfo(operation.getClass());
            if (nodeInfo != null) {
                result.append(" \"").append(nodeInfo.shortName()).append("\"");
            }
        }

        result.append(" not defined for");

        String sep = " ";
        for (int i = 0; i < values.length; i++) {
            Object value = values[i];
            result.append(sep);
            sep = ", ";
            if (value == null || InteropLibrary.getFactory().getUncached().isNull(value)) {
                result.append(NablaLanguage.toString(value));
            } else {
                result.append(NablaLanguage.toString(value));
                if (InteropLibrary.getFactory().getUncached().isString(value)) {
                    result.append("\"");
                }
            }
        }
        return new NablaException(result.toString(), operation);
    }

}
