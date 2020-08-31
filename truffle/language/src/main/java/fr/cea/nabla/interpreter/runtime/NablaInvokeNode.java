package fr.cea.nabla.interpreter.runtime;

import com.oracle.truffle.api.dsl.Specialization;
import com.oracle.truffle.api.interop.InteropException;
import com.oracle.truffle.api.interop.InteropLibrary;
import com.oracle.truffle.api.library.CachedLibrary;
import com.oracle.truffle.api.nodes.Node;

public abstract class NablaInvokeNode extends Node {

	public abstract Object execute(Object receiver, String methodName, Object[] arguments);

	@Specialization(guards = "objLibrary.isMemberInvocable(receiver, methodName)", limit = "3")
	public Object doDefault(Object receiver, String methodName, Object[] arguments,
			@CachedLibrary("receiver") InteropLibrary objLibrary) {
		try {
			return objLibrary.invokeMember(receiver, methodName, arguments);
		} catch (InteropException e) {
			e.printStackTrace();
		}
		return null;
	}
}
