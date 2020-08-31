package fr.cea.nabla.interpreter.nodes.expression;

import com.oracle.truffle.api.frame.VirtualFrame;
import com.oracle.truffle.api.instrumentation.StandardTags;
import com.oracle.truffle.api.instrumentation.Tag;
import com.oracle.truffle.api.nodes.ExplodeLoop;

import fr.cea.nabla.interpreter.runtime.NablaContext;
import fr.cea.nabla.interpreter.runtime.NablaInvokeNode;
import fr.cea.nabla.interpreter.runtime.NablaInvokeNodeGen;
import fr.cea.nabla.interpreter.values.BoxValueNode;
import fr.cea.nabla.interpreter.values.BoxValueNodeGen;
import fr.cea.nabla.interpreter.values.CreateNablaValueNode;
import fr.cea.nabla.interpreter.values.CreateNablaValueNodeGen;
import fr.cea.nabla.interpreter.values.UnboxValueNode;
import fr.cea.nabla.interpreter.values.UnboxValueNodeGen;

public class NablaExternalMethodCallNode extends NablaExpressionNode {

	@Children
	private UnboxValueNode[] unboxArgNodes;
	@Child
	private NablaInvokeNode invokeNode;
	@Child
	private BoxValueNode unboxNode;
	@Child
	private CreateNablaValueNode createNablaValueNode;
	private final String methodName;
	private final Object receiverObject;

	public NablaExternalMethodCallNode(String receiverClass, String methodName, Class<?> returnType,
			NablaExpressionNode[] argumentNodes) {
		this.unboxArgNodes = new UnboxValueNode[argumentNodes.length];
		for (int i = 0; i < unboxArgNodes.length; i++) {
			this.unboxArgNodes[i] = UnboxValueNodeGen.create(argumentNodes[i]);
		}
		this.methodName = methodName;
		this.receiverObject = NablaContext.getCurrent().getEnv().lookupHostSymbol(receiverClass);
		this.invokeNode = NablaInvokeNodeGen.create();
		this.unboxNode = BoxValueNodeGen.create(returnType);
		this.createNablaValueNode = CreateNablaValueNodeGen.create();
	}

	@Override
	@ExplodeLoop
	public Object executeGeneric(VirtualFrame frame) {
		final Object[] argumentValues = new Object[unboxArgNodes.length];
		for (int i = 0; i < unboxArgNodes.length; i++) {
			argumentValues[i] = unboxArgNodes[i].execute(frame);
		}

		final Object invokeResult = invokeNode.execute(receiverObject, methodName, argumentValues);
		return createNablaValueNode.execute(unboxNode.execute(invokeResult));
	}

	@Override
	public boolean hasTag(Class<? extends Tag> tag) {
		if (tag == StandardTags.CallTag.class) {
			return true;
		}
		return super.hasTag(tag);
	}
}
