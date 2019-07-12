/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.*;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EDataType;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EPackage;

import org.eclipse.emf.ecore.impl.EFactoryImpl;

import org.eclipse.emf.ecore.plugin.EcorePlugin;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model <b>Factory</b>.
 * <!-- end-user-doc -->
 * @generated
 */
public class IrFactoryImpl extends EFactoryImpl implements IrFactory {
	/**
	 * Creates the default factory implementation.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public static IrFactory init() {
		try {
			IrFactory theIrFactory = (IrFactory)EPackage.Registry.INSTANCE.getEFactory(IrPackage.eNS_URI);
			if (theIrFactory != null) {
				return theIrFactory;
			}
		}
		catch (Exception exception) {
			EcorePlugin.INSTANCE.log(exception);
		}
		return new IrFactoryImpl();
	}

	/**
	 * Creates an instance of the factory.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public IrFactoryImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public EObject create(EClass eClass) {
		switch (eClass.getClassifierID()) {
			case IrPackage.IR_ANNOTATION: return createIrAnnotation();
			case IrPackage.IR_MODULE: return createIrModule();
			case IrPackage.IMPORT: return createImport();
			case IrPackage.SIMPLE_VARIABLE: return createSimpleVariable();
			case IrPackage.CONNECTIVITY_VARIABLE: return createConnectivityVariable();
			case IrPackage.FUNCTION: return createFunction();
			case IrPackage.REDUCTION: return createReduction();
			case IrPackage.CONNECTIVITY: return createConnectivity();
			case IrPackage.ITEM_ARG_TYPE: return createItemArgType();
			case IrPackage.INSTRUCTION_JOB: return createInstructionJob();
			case IrPackage.END_OF_TIME_LOOP_JOB: return createEndOfTimeLoopJob();
			case IrPackage.END_OF_INIT_JOB: return createEndOfInitJob();
			case IrPackage.VAR_DEFINITION: return createVarDefinition();
			case IrPackage.INSTRUCTION_BLOCK: return createInstructionBlock();
			case IrPackage.AFFECTATION: return createAffectation();
			case IrPackage.REDUCTION_INSTRUCTION: return createReductionInstruction();
			case IrPackage.LOOP: return createLoop();
			case IrPackage.IF: return createIf();
			case IrPackage.CONTRACTED_IF: return createContractedIf();
			case IrPackage.BINARY_EXPRESSION: return createBinaryExpression();
			case IrPackage.UNARY_EXPRESSION: return createUnaryExpression();
			case IrPackage.PARENTHESIS: return createParenthesis();
			case IrPackage.CONSTANT: return createConstant();
			case IrPackage.MIN_CONSTANT: return createMinConstant();
			case IrPackage.MAX_CONSTANT: return createMaxConstant();
			case IrPackage.BASE_TYPE_CONSTANT: return createBaseTypeConstant();
			case IrPackage.REAL_VECTOR_CONSTANT: return createRealVectorConstant();
			case IrPackage.REAL_MATRIX_CONSTANT: return createRealMatrixConstant();
			case IrPackage.FUNCTION_CALL: return createFunctionCall();
			case IrPackage.VAR_REF: return createVarRef();
			case IrPackage.ITERATOR: return createIterator();
			case IrPackage.CONNECTIVITY_CALL: return createConnectivityCall();
			case IrPackage.CONNECTIVITY_CALL_ITERATOR_REF: return createConnectivityCallIteratorRef();
			case IrPackage.VAR_REF_ITERATOR_REF: return createVarRefIteratorRef();
			case IrPackage.ITEM_TYPE: return createItemType();
			case IrPackage.BASE_TYPE: return createBaseType();
			case IrPackage.EXPRESSION_TYPE: return createExpressionType();
			case IrPackage.ARG_TYPE: return createArgType();
			default:
				throw new IllegalArgumentException("The class '" + eClass.getName() + "' is not a valid classifier");
		}
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Object createFromString(EDataType eDataType, String initialValue) {
		switch (eDataType.getClassifierID()) {
			case IrPackage.PRIMITIVE_TYPE:
				return createPrimitiveTypeFromString(eDataType, initialValue);
			default:
				throw new IllegalArgumentException("The datatype '" + eDataType.getName() + "' is not a valid classifier");
		}
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public String convertToString(EDataType eDataType, Object instanceValue) {
		switch (eDataType.getClassifierID()) {
			case IrPackage.PRIMITIVE_TYPE:
				return convertPrimitiveTypeToString(eDataType, instanceValue);
			default:
				throw new IllegalArgumentException("The datatype '" + eDataType.getName() + "' is not a valid classifier");
		}
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public IrAnnotation createIrAnnotation() {
		IrAnnotationImpl irAnnotation = new IrAnnotationImpl();
		return irAnnotation;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public IrModule createIrModule() {
		IrModuleImpl irModule = new IrModuleImpl();
		return irModule;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Import createImport() {
		ImportImpl import_ = new ImportImpl();
		return import_;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public SimpleVariable createSimpleVariable() {
		SimpleVariableImpl simpleVariable = new SimpleVariableImpl();
		return simpleVariable;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public ConnectivityVariable createConnectivityVariable() {
		ConnectivityVariableImpl connectivityVariable = new ConnectivityVariableImpl();
		return connectivityVariable;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Function createFunction() {
		FunctionImpl function = new FunctionImpl();
		return function;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Reduction createReduction() {
		ReductionImpl reduction = new ReductionImpl();
		return reduction;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Connectivity createConnectivity() {
		ConnectivityImpl connectivity = new ConnectivityImpl();
		return connectivity;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public ItemArgType createItemArgType() {
		ItemArgTypeImpl itemArgType = new ItemArgTypeImpl();
		return itemArgType;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public InstructionJob createInstructionJob() {
		InstructionJobImpl instructionJob = new InstructionJobImpl();
		return instructionJob;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EndOfTimeLoopJob createEndOfTimeLoopJob() {
		EndOfTimeLoopJobImpl endOfTimeLoopJob = new EndOfTimeLoopJobImpl();
		return endOfTimeLoopJob;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EndOfInitJob createEndOfInitJob() {
		EndOfInitJobImpl endOfInitJob = new EndOfInitJobImpl();
		return endOfInitJob;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public VarDefinition createVarDefinition() {
		VarDefinitionImpl varDefinition = new VarDefinitionImpl();
		return varDefinition;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public InstructionBlock createInstructionBlock() {
		InstructionBlockImpl instructionBlock = new InstructionBlockImpl();
		return instructionBlock;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Affectation createAffectation() {
		AffectationImpl affectation = new AffectationImpl();
		return affectation;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public ReductionInstruction createReductionInstruction() {
		ReductionInstructionImpl reductionInstruction = new ReductionInstructionImpl();
		return reductionInstruction;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Loop createLoop() {
		LoopImpl loop = new LoopImpl();
		return loop;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public If createIf() {
		IfImpl if_ = new IfImpl();
		return if_;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public ContractedIf createContractedIf() {
		ContractedIfImpl contractedIf = new ContractedIfImpl();
		return contractedIf;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public BinaryExpression createBinaryExpression() {
		BinaryExpressionImpl binaryExpression = new BinaryExpressionImpl();
		return binaryExpression;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public UnaryExpression createUnaryExpression() {
		UnaryExpressionImpl unaryExpression = new UnaryExpressionImpl();
		return unaryExpression;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Parenthesis createParenthesis() {
		ParenthesisImpl parenthesis = new ParenthesisImpl();
		return parenthesis;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Constant createConstant() {
		ConstantImpl constant = new ConstantImpl();
		return constant;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public MaxConstant createMaxConstant() {
		MaxConstantImpl maxConstant = new MaxConstantImpl();
		return maxConstant;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public BaseTypeConstant createBaseTypeConstant() {
		BaseTypeConstantImpl baseTypeConstant = new BaseTypeConstantImpl();
		return baseTypeConstant;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public RealVectorConstant createRealVectorConstant() {
		RealVectorConstantImpl realVectorConstant = new RealVectorConstantImpl();
		return realVectorConstant;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public RealMatrixConstant createRealMatrixConstant() {
		RealMatrixConstantImpl realMatrixConstant = new RealMatrixConstantImpl();
		return realMatrixConstant;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public MinConstant createMinConstant() {
		MinConstantImpl minConstant = new MinConstantImpl();
		return minConstant;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public FunctionCall createFunctionCall() {
		FunctionCallImpl functionCall = new FunctionCallImpl();
		return functionCall;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public VarRef createVarRef() {
		VarRefImpl varRef = new VarRefImpl();
		return varRef;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Iterator createIterator() {
		IteratorImpl iterator = new IteratorImpl();
		return iterator;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public ConnectivityCall createConnectivityCall() {
		ConnectivityCallImpl connectivityCall = new ConnectivityCallImpl();
		return connectivityCall;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public ConnectivityCallIteratorRef createConnectivityCallIteratorRef() {
		ConnectivityCallIteratorRefImpl connectivityCallIteratorRef = new ConnectivityCallIteratorRefImpl();
		return connectivityCallIteratorRef;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public VarRefIteratorRef createVarRefIteratorRef() {
		VarRefIteratorRefImpl varRefIteratorRef = new VarRefIteratorRefImpl();
		return varRefIteratorRef;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public ItemType createItemType() {
		ItemTypeImpl itemType = new ItemTypeImpl();
		return itemType;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public BaseType createBaseType() {
		BaseTypeImpl baseType = new BaseTypeImpl();
		return baseType;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public ExpressionType createExpressionType() {
		ExpressionTypeImpl expressionType = new ExpressionTypeImpl();
		return expressionType;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public ArgType createArgType() {
		ArgTypeImpl argType = new ArgTypeImpl();
		return argType;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public PrimitiveType createPrimitiveTypeFromString(EDataType eDataType, String initialValue) {
		PrimitiveType result = PrimitiveType.get(initialValue);
		if (result == null) throw new IllegalArgumentException("The value '" + initialValue + "' is not a valid enumerator of '" + eDataType.getName() + "'");
		return result;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public String convertPrimitiveTypeToString(EDataType eDataType, Object instanceValue) {
		return instanceValue == null ? null : instanceValue.toString();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public IrPackage getIrPackage() {
		return (IrPackage)getEPackage();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @deprecated
	 * @generated
	 */
	@Deprecated
	public static IrPackage getPackage() {
		return IrPackage.eINSTANCE;
	}

} //IrFactoryImpl
