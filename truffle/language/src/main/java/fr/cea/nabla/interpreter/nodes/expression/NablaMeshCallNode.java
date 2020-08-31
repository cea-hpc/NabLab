package fr.cea.nabla.interpreter.nodes.expression;

import org.graalvm.polyglot.Value;

import com.oracle.truffle.api.CompilerDirectives.CompilationFinal;
import com.oracle.truffle.api.dsl.Cached;
import com.oracle.truffle.api.dsl.Specialization;
import com.oracle.truffle.api.frame.VirtualFrame;
import com.oracle.truffle.api.instrumentation.StandardTags;
import com.oracle.truffle.api.instrumentation.Tag;
import com.oracle.truffle.api.nodes.ExplodeLoop;

import fr.cea.nabla.interpreter.runtime.NablaContext;
import fr.cea.nabla.interpreter.runtime.NablaInvokeNode;
import fr.cea.nabla.interpreter.runtime.NablaInvokeNodeGen;
import fr.cea.nabla.interpreter.values.BoxMeshCallResultNode;
import fr.cea.nabla.interpreter.values.BoxMeshCallResultNodeGen;
import fr.cea.nabla.interpreter.values.CreateNablaValueNode;
import fr.cea.nabla.interpreter.values.CreateNablaValueNodeGen;
import fr.cea.nabla.interpreter.values.UnboxValueNode;
import fr.cea.nabla.interpreter.values.UnboxValueNodeGen;
import fr.cea.nabla.javalib.mesh.CartesianMesh2D;

public abstract class NablaMeshCallNode extends NablaExpressionNode {

	@Children
	private UnboxValueNode[] unboxArgNodes;
	@Child
	private NablaInvokeNode invokeNode;
	@Child
	private BoxMeshCallResultNode boxNode;
	@Child
	private CreateNablaValueNode createNablaValueNode;
	protected final String connectivityName;
	@CompilationFinal
	protected boolean isStatic = false;

	protected NablaMeshCallNode(String connectivityName, NablaExpressionNode[] argumentNodes) {
		this.unboxArgNodes = new UnboxValueNode[argumentNodes.length];
		for (int i = 0; i < unboxArgNodes.length; i++) {
			this.unboxArgNodes[i] = UnboxValueNodeGen.create(argumentNodes[i]);
		}
		switch (connectivityName) {
		case "getNodes":
			this.connectivityName = "getNbNodes";
			break;
		case "getCells":
			this.connectivityName = "getNbCells";
			break;
		default:
			if (connectivityName.startsWith("getMax")) {
				isStatic = true;
			}
			this.connectivityName = connectivityName;
		}
		this.invokeNode = NablaInvokeNodeGen.create();
		this.createNablaValueNode = CreateNablaValueNodeGen.create();
		this.boxNode = BoxMeshCallResultNodeGen.create();
	}

	@ExplodeLoop
	@Specialization(guards = "!isStatic")
	protected Object call(VirtualFrame frame, @Cached("getMesh()") Value mesh,
			@Cached("mesh.getMember(connectivityName)") Value value) {
		final Object[] argumentValues = new Object[unboxArgNodes.length];
		for (int i = 0; i < unboxArgNodes.length; i++) {
			argumentValues[i] = unboxArgNodes[i].execute(frame);
		}
		final Object result;
		if (value.canExecute()) {
			result = value.execute(argumentValues);
		} else {
			result = value;
		}
		return createNablaValueNode.execute(boxNode.execute(result));
	}
	
	@Specialization(guards = "isStatic")
	protected Object call(VirtualFrame frame,//
			@Cached("getMaxNbElems(connectivityName)") Value value) {
		return createNablaValueNode.execute(boxNode.execute(value));
	}
	
	public Value getMaxNbElems(final String connectivityName) {
		switch (connectivityName) {
		case "getMaxNbNodesOfCell":
			return Value.asValue(CartesianMesh2D.MaxNbNodesOfCell);
		case "getMaxNbNodesOfFace":
			return Value.asValue(CartesianMesh2D.MaxNbNodesOfFace);
		case "getMaxNbCellsOfNode":
			return Value.asValue(CartesianMesh2D.MaxNbCellsOfNode);
		case "getMaxNbCellsOfFace":
			return Value.asValue(CartesianMesh2D.MaxNbCellsOfFace);
		case "getMaxNbNeighbourCells":
			return Value.asValue(CartesianMesh2D.MaxNbNeighbourCells);
		case "getMaxNbFacesOfCell":
			return Value.asValue(CartesianMesh2D.MaxNbFacesOfCell);
		default:
			throw new RuntimeException("Not implemented yet");
		}
	}
	
	protected Value getMesh() {
		return NablaContext.getCartesianMesh();
	}
	
//	@Specialization
//	@ExplodeLoop
//	protected Object call(VirtualFrame frame, //
//			@Cached("getMeshWrapper()") Value meshWrapper,
//			@Cached("getMeshInstance()") Value meshInstance,
//			@Cached("meshWrapper.getMember(connectivityName)") Value connectivity) {
//		final Object[] argumentValues = new Object[unboxArgNodes.length+1];
//		argumentValues[0] = meshInstance;
//		for (int i = 0; i < unboxArgNodes.length; i++) {
//			argumentValues[i+1] = unboxArgNodes[i].execute(frame);
//		}
//		final Value result = connectivity.execute(argumentValues);
//		return createNablaValueNode.execute(boxNode.execute(result));
//	}

//	protected Value getMeshWrapper() {
//		return NablaContext.getMeshWrapper();
//	}

//	protected Value getMeshInstance() {
//		return NablaContext.getMeshInstance();
//	}

	@Override
	public boolean hasTag(Class<? extends Tag> tag) {
		if (tag == StandardTags.CallTag.class) {
			return true;
		}
		return super.hasTag(tag);
	}
}
