package fr.cea.nabla.interpreter.nodes;

import com.oracle.truffle.api.frame.VirtualFrame;
import com.oracle.truffle.api.nodes.RootNode;

import fr.cea.nabla.interpreter.NablaLanguage;
import fr.cea.nabla.interpreter.runtime.NablaUndefinedNameException;

/**
 * The initial {@link RootNode} of {@link SLFunction functions} when they are created, i.e., when
 * they are still undefined. Executing it throws an
 * {@link NablaUndefinedNameException#undefinedFunction exception}.
 */
public class NablaUndefinedFunctionRootNode extends NablaRootNode {
    public NablaUndefinedFunctionRootNode(NablaLanguage language, String name) {
        super(language, null, null, null, name);
    }

    @Override
	public final Object execute(VirtualFrame frame) {
		throw NablaUndefinedNameException.undefinedFunction(null, getName());
    }
}
