package fr.cea.nabla.interpreter.nodes;

import com.oracle.truffle.api.dsl.TypeSystemReference;
import com.oracle.truffle.api.frame.VirtualFrame;
import com.oracle.truffle.api.nodes.ExplodeLoop;

import fr.cea.nabla.interpreter.NablaTypes;
import fr.cea.nabla.interpreter.NablaTypesGen;
import fr.cea.nabla.interpreter.nodes.expression.NablaExpressionNode;
import fr.cea.nabla.interpreter.nodes.instruction.NablaInstructionNode;
import fr.cea.nabla.interpreter.nodes.instruction.NablaWriteVariableNode;
import fr.cea.nabla.interpreter.runtime.NablaContext;
import fr.cea.nabla.interpreter.runtime.NablaNull;

@TypeSystemReference(NablaTypes.class)
public class NablaModulePrologNode extends NablaInstructionNode {

	@Children
	private NablaExpressionNode[] mandatoryVariables;
	@Children
	private NablaWriteVariableNode[] connectivityVariables;
	@Children
	private NablaWriteVariableNode[] variableDefinitions;
	@Children
	private NablaWriteVariableNode[] variableDeclarations;
	
	private final String pathToMeshLibrary;

	public NablaModulePrologNode(NablaExpressionNode[] mandatoryVariables,
			NablaWriteVariableNode[] connectivityVariables, NablaWriteVariableNode[] variableDeclarations,
			NablaWriteVariableNode[] variableDefinitions, String pathToMeshLibrary) {
		this.mandatoryVariables = mandatoryVariables;
		this.variableDeclarations = variableDeclarations;
		this.variableDefinitions = variableDefinitions;
		this.connectivityVariables = connectivityVariables;
		this.pathToMeshLibrary = pathToMeshLibrary;
	}

	@ExplodeLoop
	@Override
	public Object executeGeneric(VirtualFrame frame) {

		for (int i = 0; i < variableDefinitions.length; i++) {
			variableDefinitions[i].executeGeneric(frame);
		}

		if (mandatoryVariables.length == 4) {
			NablaContext.initializeMesh(//
					NablaTypesGen.asNV0Int(mandatoryVariables[0].executeGeneric(frame)).getData(),
					NablaTypesGen.asNV0Int(mandatoryVariables[1].executeGeneric(frame)).getData(),
					NablaTypesGen.asNV0Real(mandatoryVariables[2].executeGeneric(frame)).getData(),
					NablaTypesGen.asNV0Real(mandatoryVariables[3].executeGeneric(frame)).getData(),
					pathToMeshLibrary);
		}

		for (int i = 0; i < connectivityVariables.length; i++) {
			connectivityVariables[i].executeGeneric(frame);
		}

		for (int i = 0; i < variableDeclarations.length; i++) {
			variableDeclarations[i].executeGeneric(frame);
		}

		return NablaNull.SINGLETON;
	}
	
	@Override
	public boolean isInstrumentable() {
		return false;
	}

}
