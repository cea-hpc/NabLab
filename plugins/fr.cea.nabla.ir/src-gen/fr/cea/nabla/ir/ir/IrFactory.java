/**
 */
package fr.cea.nabla.ir.ir;

import org.eclipse.emf.ecore.EFactory;

/**
 * <!-- begin-user-doc -->
 * The <b>Factory</b> for the model.
 * It provides a create method for each non-abstract class of the model.
 * <!-- end-user-doc -->
 * @see fr.cea.nabla.ir.ir.IrPackage
 * @generated
 */
public interface IrFactory extends EFactory {
	/**
	 * The singleton instance of the factory.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	IrFactory eINSTANCE = fr.cea.nabla.ir.ir.impl.IrFactoryImpl.init();

	/**
	 * Returns a new object of class '<em>Annotation</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>Annotation</em>'.
	 * @generated
	 */
	IrAnnotation createIrAnnotation();

	/**
	 * Returns a new object of class '<em>Root</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>Root</em>'.
	 * @generated
	 */
	IrRoot createIrRoot();

	/**
	 * Returns a new object of class '<em>Module</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>Module</em>'.
	 * @generated
	 */
	IrModule createIrModule();

	/**
	 * Returns a new object of class '<em>Time Iterator</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>Time Iterator</em>'.
	 * @generated
	 */
	TimeIterator createTimeIterator();

	/**
	 * Returns a new object of class '<em>Post Processing</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>Post Processing</em>'.
	 * @generated
	 */
	PostProcessing createPostProcessing();

	/**
	 * Returns a new object of class '<em>Post Processed Variable</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>Post Processed Variable</em>'.
	 * @generated
	 */
	PostProcessedVariable createPostProcessedVariable();

	/**
	 * Returns a new object of class '<em>Default Extension Provider</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>Default Extension Provider</em>'.
	 * @generated
	 */
	DefaultExtensionProvider createDefaultExtensionProvider();

	/**
	 * Returns a new object of class '<em>Mesh Extension Provider</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>Mesh Extension Provider</em>'.
	 * @generated
	 */
	MeshExtensionProvider createMeshExtensionProvider();

	/**
	 * Returns a new object of class '<em>Arg</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>Arg</em>'.
	 * @generated
	 */
	Arg createArg();

	/**
	 * Returns a new object of class '<em>Variable</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>Variable</em>'.
	 * @generated
	 */
	Variable createVariable();

	/**
	 * Returns a new object of class '<em>Time Variable</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>Time Variable</em>'.
	 * @generated
	 */
	TimeVariable createTimeVariable();

	/**
	 * Returns a new object of class '<em>Intern Function</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>Intern Function</em>'.
	 * @generated
	 */
	InternFunction createInternFunction();

	/**
	 * Returns a new object of class '<em>Extern Function</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>Extern Function</em>'.
	 * @generated
	 */
	ExternFunction createExternFunction();

	/**
	 * Returns a new object of class '<em>Connectivity</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>Connectivity</em>'.
	 * @generated
	 */
	Connectivity createConnectivity();

	/**
	 * Returns a new object of class '<em>Job Caller</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>Job Caller</em>'.
	 * @generated
	 */
	JobCaller createJobCaller();

	/**
	 * Returns a new object of class '<em>Job</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>Job</em>'.
	 * @generated
	 */
	Job createJob();

	/**
	 * Returns a new object of class '<em>Execute Time Loop Job</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>Execute Time Loop Job</em>'.
	 * @generated
	 */
	ExecuteTimeLoopJob createExecuteTimeLoopJob();

	/**
	 * Returns a new object of class '<em>Instruction Block</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>Instruction Block</em>'.
	 * @generated
	 */
	InstructionBlock createInstructionBlock();

	/**
	 * Returns a new object of class '<em>Variable Declaration</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>Variable Declaration</em>'.
	 * @generated
	 */
	VariableDeclaration createVariableDeclaration();

	/**
	 * Returns a new object of class '<em>Affectation</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>Affectation</em>'.
	 * @generated
	 */
	Affectation createAffectation();

	/**
	 * Returns a new object of class '<em>Reduction Instruction</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>Reduction Instruction</em>'.
	 * @generated
	 */
	ReductionInstruction createReductionInstruction();

	/**
	 * Returns a new object of class '<em>Loop</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>Loop</em>'.
	 * @generated
	 */
	Loop createLoop();

	/**
	 * Returns a new object of class '<em>Item Index Definition</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>Item Index Definition</em>'.
	 * @generated
	 */
	ItemIndexDefinition createItemIndexDefinition();

	/**
	 * Returns a new object of class '<em>Item Id Definition</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>Item Id Definition</em>'.
	 * @generated
	 */
	ItemIdDefinition createItemIdDefinition();

	/**
	 * Returns a new object of class '<em>Set Definition</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>Set Definition</em>'.
	 * @generated
	 */
	SetDefinition createSetDefinition();

	/**
	 * Returns a new object of class '<em>If</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>If</em>'.
	 * @generated
	 */
	If createIf();

	/**
	 * Returns a new object of class '<em>While</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>While</em>'.
	 * @generated
	 */
	While createWhile();

	/**
	 * Returns a new object of class '<em>Return</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>Return</em>'.
	 * @generated
	 */
	Return createReturn();

	/**
	 * Returns a new object of class '<em>Exit</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>Exit</em>'.
	 * @generated
	 */
	Exit createExit();

	/**
	 * Returns a new object of class '<em>Synchronize</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>Synchronize</em>'.
	 * @generated
	 */
	Synchronize createSynchronize();

	/**
	 * Returns a new object of class '<em>MESSAGE</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>MESSAGE</em>'.
	 * @generated
	 */
	MESSAGE createMESSAGE();

	/**
	 * Returns a new object of class '<em>Iterator</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>Iterator</em>'.
	 * @generated
	 */
	Iterator createIterator();

	/**
	 * Returns a new object of class '<em>Interval</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>Interval</em>'.
	 * @generated
	 */
	Interval createInterval();

	/**
	 * Returns a new object of class '<em>Contracted If</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>Contracted If</em>'.
	 * @generated
	 */
	ContractedIf createContractedIf();

	/**
	 * Returns a new object of class '<em>Binary Expression</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>Binary Expression</em>'.
	 * @generated
	 */
	BinaryExpression createBinaryExpression();

	/**
	 * Returns a new object of class '<em>Unary Expression</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>Unary Expression</em>'.
	 * @generated
	 */
	UnaryExpression createUnaryExpression();

	/**
	 * Returns a new object of class '<em>Parenthesis</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>Parenthesis</em>'.
	 * @generated
	 */
	Parenthesis createParenthesis();

	/**
	 * Returns a new object of class '<em>Int Constant</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>Int Constant</em>'.
	 * @generated
	 */
	IntConstant createIntConstant();

	/**
	 * Returns a new object of class '<em>Real Constant</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>Real Constant</em>'.
	 * @generated
	 */
	RealConstant createRealConstant();

	/**
	 * Returns a new object of class '<em>Bool Constant</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>Bool Constant</em>'.
	 * @generated
	 */
	BoolConstant createBoolConstant();

	/**
	 * Returns a new object of class '<em>Min Constant</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>Min Constant</em>'.
	 * @generated
	 */
	MinConstant createMinConstant();

	/**
	 * Returns a new object of class '<em>Max Constant</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>Max Constant</em>'.
	 * @generated
	 */
	MaxConstant createMaxConstant();

	/**
	 * Returns a new object of class '<em>Function Call</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>Function Call</em>'.
	 * @generated
	 */
	FunctionCall createFunctionCall();

	/**
	 * Returns a new object of class '<em>Base Type Constant</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>Base Type Constant</em>'.
	 * @generated
	 */
	BaseTypeConstant createBaseTypeConstant();

	/**
	 * Returns a new object of class '<em>Vector Constant</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>Vector Constant</em>'.
	 * @generated
	 */
	VectorConstant createVectorConstant();

	/**
	 * Returns a new object of class '<em>Cardinality</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>Cardinality</em>'.
	 * @generated
	 */
	Cardinality createCardinality();

	/**
	 * Returns a new object of class '<em>Arg Or Var Ref</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>Arg Or Var Ref</em>'.
	 * @generated
	 */
	ArgOrVarRef createArgOrVarRef();

	/**
	 * Returns a new object of class '<em>Item Type</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>Item Type</em>'.
	 * @generated
	 */
	ItemType createItemType();

	/**
	 * Returns a new object of class '<em>Type</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>Type</em>'.
	 * @generated
	 */
	IrType createIrType();

	/**
	 * Returns a new object of class '<em>Base Type</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>Base Type</em>'.
	 * @generated
	 */
	BaseType createBaseType();

	/**
	 * Returns a new object of class '<em>Connectivity Type</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>Connectivity Type</em>'.
	 * @generated
	 */
	ConnectivityType createConnectivityType();

	/**
	 * Returns a new object of class '<em>Linear Algebra Type</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>Linear Algebra Type</em>'.
	 * @generated
	 */
	LinearAlgebraType createLinearAlgebraType();

	/**
	 * Returns a new object of class '<em>Connectivity Call</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>Connectivity Call</em>'.
	 * @generated
	 */
	ConnectivityCall createConnectivityCall();

	/**
	 * Returns a new object of class '<em>Set Ref</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>Set Ref</em>'.
	 * @generated
	 */
	SetRef createSetRef();

	/**
	 * Returns a new object of class '<em>Item Id</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>Item Id</em>'.
	 * @generated
	 */
	ItemId createItemId();

	/**
	 * Returns a new object of class '<em>Item Id Value Iterator</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>Item Id Value Iterator</em>'.
	 * @generated
	 */
	ItemIdValueIterator createItemIdValueIterator();

	/**
	 * Returns a new object of class '<em>Item Id Value Container</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>Item Id Value Container</em>'.
	 * @generated
	 */
	ItemIdValueContainer createItemIdValueContainer();

	/**
	 * Returns a new object of class '<em>Item Index</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>Item Index</em>'.
	 * @generated
	 */
	ItemIndex createItemIndex();

	/**
	 * Returns a new object of class '<em>Item Index Value</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>Item Index Value</em>'.
	 * @generated
	 */
	ItemIndexValue createItemIndexValue();

	/**
	 * Returns the package supported by this factory.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the package supported by this factory.
	 * @generated
	 */
	IrPackage getIrPackage();

} //IrFactory
