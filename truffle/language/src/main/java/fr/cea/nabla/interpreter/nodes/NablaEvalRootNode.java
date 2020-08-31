package fr.cea.nabla.interpreter.nodes;

import com.oracle.truffle.api.RootCallTarget;
import com.oracle.truffle.api.frame.VirtualFrame;
import com.oracle.truffle.api.nodes.DirectCallNode;
import com.oracle.truffle.api.nodes.RootNode;

import fr.cea.nabla.interpreter.NablaLanguage;
import fr.cea.nabla.interpreter.runtime.NablaContext;
import fr.cea.nabla.interpreter.runtime.NablaNull;

public final class NablaEvalRootNode extends RootNode {

    @Child
    private DirectCallNode mainCallNode;

    public NablaEvalRootNode(NablaLanguage language, RootCallTarget rootFunction) {
        super(language);
        this.mainCallNode = rootFunction != null ? DirectCallNode.create(rootFunction) : null;
    }

    @Override
    protected boolean isInstrumentable() {
        return true;
    }

    @Override
    public String getName() {
        return "root eval";
    }

    @Override
    public String toString() {
        return getName();
    }

    @Override
    public Object execute(VirtualFrame frame) {
        if (mainCallNode == null) {
            return NablaNull.SINGLETON;
        } else {
            Object[] arguments = frame.getArguments();
            for (int i = 0; i < arguments.length; i++) {
                arguments[i] = NablaContext.fromForeignValue(arguments[i]);
            }
            return mainCallNode.call(arguments);
        }
    }
}
