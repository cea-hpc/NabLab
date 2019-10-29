/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.Affectation;
import fr.cea.nabla.ir.ir.Arg;
import fr.cea.nabla.ir.ir.Array1D;
import fr.cea.nabla.ir.ir.Array2D;
import fr.cea.nabla.ir.ir.BaseType;
import fr.cea.nabla.ir.ir.BaseTypeConstant;
import fr.cea.nabla.ir.ir.BinaryExpression;
import fr.cea.nabla.ir.ir.Connectivity;
import fr.cea.nabla.ir.ir.ConnectivityCall;
import fr.cea.nabla.ir.ir.ConnectivityCallIteratorRef;
import fr.cea.nabla.ir.ir.ConnectivityType;
import fr.cea.nabla.ir.ir.ConnectivityVariable;
import fr.cea.nabla.ir.ir.Constant;
import fr.cea.nabla.ir.ir.ContractedIf;
import fr.cea.nabla.ir.ir.EndOfInitJob;
import fr.cea.nabla.ir.ir.EndOfTimeLoopJob;
import fr.cea.nabla.ir.ir.Expression;
import fr.cea.nabla.ir.ir.Function;
import fr.cea.nabla.ir.ir.FunctionCall;
import fr.cea.nabla.ir.ir.If;
import fr.cea.nabla.ir.ir.Import;
import fr.cea.nabla.ir.ir.InSituJob;
import fr.cea.nabla.ir.ir.Instruction;
import fr.cea.nabla.ir.ir.InstructionBlock;
import fr.cea.nabla.ir.ir.InstructionJob;
import fr.cea.nabla.ir.ir.IntMatrixConstant;
import fr.cea.nabla.ir.ir.IntVectorConstant;
import fr.cea.nabla.ir.ir.IrAnnotable;
import fr.cea.nabla.ir.ir.IrAnnotation;
import fr.cea.nabla.ir.ir.IrFactory;
import fr.cea.nabla.ir.ir.IrModule;
import fr.cea.nabla.ir.ir.IrPackage;
import fr.cea.nabla.ir.ir.IrType;
import fr.cea.nabla.ir.ir.ItemArgType;
import fr.cea.nabla.ir.ir.ItemType;
import fr.cea.nabla.ir.ir.IterableInstruction;
import fr.cea.nabla.ir.ir.Iterator;
import fr.cea.nabla.ir.ir.IteratorRef;
import fr.cea.nabla.ir.ir.Job;
import fr.cea.nabla.ir.ir.Loop;
import fr.cea.nabla.ir.ir.MaxConstant;
import fr.cea.nabla.ir.ir.MinConstant;
import fr.cea.nabla.ir.ir.Parenthesis;
import fr.cea.nabla.ir.ir.PrimitiveType;
import fr.cea.nabla.ir.ir.RealMatrixConstant;
import fr.cea.nabla.ir.ir.RealVectorConstant;
import fr.cea.nabla.ir.ir.Reduction;
import fr.cea.nabla.ir.ir.ReductionInstruction;
import fr.cea.nabla.ir.ir.Scalar;
import fr.cea.nabla.ir.ir.SimpleVariable;
import fr.cea.nabla.ir.ir.TimeIterationCopyJob;
import fr.cea.nabla.ir.ir.UnaryExpression;
import fr.cea.nabla.ir.ir.VarDefinition;
import fr.cea.nabla.ir.ir.VarRef;
import fr.cea.nabla.ir.ir.VarRefIteratorRef;
import fr.cea.nabla.ir.ir.Variable;

import org.eclipse.emf.ecore.EAttribute;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EEnum;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.emf.ecore.EReference;

import org.eclipse.emf.ecore.impl.EPackageImpl;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model <b>Package</b>.
 * <!-- end-user-doc -->
 * @generated
 */
public class IrPackageImpl extends EPackageImpl implements IrPackage {
	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private EClass irAnnotableEClass = null;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private EClass irAnnotationEClass = null;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private EClass irModuleEClass = null;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private EClass importEClass = null;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private EClass variableEClass = null;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private EClass simpleVariableEClass = null;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private EClass connectivityVariableEClass = null;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private EClass functionEClass = null;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private EClass reductionEClass = null;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private EClass argEClass = null;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private EClass connectivityEClass = null;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private EClass itemArgTypeEClass = null;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private EClass jobEClass = null;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private EClass instructionJobEClass = null;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private EClass inSituJobEClass = null;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private EClass timeIterationCopyJobEClass = null;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private EClass endOfTimeLoopJobEClass = null;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private EClass endOfInitJobEClass = null;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private EClass instructionEClass = null;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private EClass varDefinitionEClass = null;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private EClass instructionBlockEClass = null;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private EClass affectationEClass = null;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private EClass iterableInstructionEClass = null;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private EClass reductionInstructionEClass = null;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private EClass loopEClass = null;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private EClass ifEClass = null;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private EClass expressionEClass = null;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private EClass contractedIfEClass = null;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private EClass binaryExpressionEClass = null;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private EClass unaryExpressionEClass = null;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private EClass parenthesisEClass = null;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private EClass constantEClass = null;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private EClass maxConstantEClass = null;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private EClass baseTypeConstantEClass = null;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private EClass intVectorConstantEClass = null;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private EClass intMatrixConstantEClass = null;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private EClass realVectorConstantEClass = null;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private EClass realMatrixConstantEClass = null;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private EClass minConstantEClass = null;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private EClass functionCallEClass = null;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private EClass varRefEClass = null;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private EClass iteratorEClass = null;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private EClass connectivityCallEClass = null;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private EClass iteratorRefEClass = null;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private EClass connectivityCallIteratorRefEClass = null;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private EClass varRefIteratorRefEClass = null;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private EClass itemTypeEClass = null;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private EClass baseTypeEClass = null;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private EClass scalarEClass = null;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private EClass array1DEClass = null;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private EClass array2DEClass = null;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private EClass irTypeEClass = null;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private EClass connectivityTypeEClass = null;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private EEnum primitiveTypeEEnum = null;

	/**
	 * Creates an instance of the model <b>Package</b>, registered with
	 * {@link org.eclipse.emf.ecore.EPackage.Registry EPackage.Registry} by the package
	 * package URI value.
	 * <p>Note: the correct way to create the package is via the static
	 * factory method {@link #init init()}, which also performs
	 * initialization of the package, or returns the registered package,
	 * if one already exists.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see org.eclipse.emf.ecore.EPackage.Registry
	 * @see fr.cea.nabla.ir.ir.IrPackage#eNS_URI
	 * @see #init()
	 * @generated
	 */
	private IrPackageImpl() {
		super(eNS_URI, IrFactory.eINSTANCE);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private static boolean isInited = false;

	/**
	 * Creates, registers, and initializes the <b>Package</b> for this model, and for any others upon which it depends.
	 *
	 * <p>This method is used to initialize {@link IrPackage#eINSTANCE} when that field is accessed.
	 * Clients should not invoke it directly. Instead, they should simply access that field to obtain the package.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #eNS_URI
	 * @see #createPackageContents()
	 * @see #initializePackageContents()
	 * @generated
	 */
	public static IrPackage init() {
		if (isInited) return (IrPackage)EPackage.Registry.INSTANCE.getEPackage(IrPackage.eNS_URI);

		// Obtain or create and register package
		Object registeredIrPackage = EPackage.Registry.INSTANCE.get(eNS_URI);
		IrPackageImpl theIrPackage = registeredIrPackage instanceof IrPackageImpl ? (IrPackageImpl)registeredIrPackage : new IrPackageImpl();

		isInited = true;

		// Create package meta-data objects
		theIrPackage.createPackageContents();

		// Initialize created meta-data
		theIrPackage.initializePackageContents();

		// Mark meta-data to indicate it can't be changed
		theIrPackage.freeze();

		// Update the registry and return the package
		EPackage.Registry.INSTANCE.put(IrPackage.eNS_URI, theIrPackage);
		return theIrPackage;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EClass getIrAnnotable() {
		return irAnnotableEClass;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getIrAnnotable_Annotations() {
		return (EReference)irAnnotableEClass.getEStructuralFeatures().get(0);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EClass getIrAnnotation() {
		return irAnnotationEClass;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EAttribute getIrAnnotation_Source() {
		return (EAttribute)irAnnotationEClass.getEStructuralFeatures().get(0);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getIrAnnotation_Details() {
		return (EReference)irAnnotationEClass.getEStructuralFeatures().get(1);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EClass getIrModule() {
		return irModuleEClass;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EAttribute getIrModule_Name() {
		return (EAttribute)irModuleEClass.getEStructuralFeatures().get(0);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getIrModule_Imports() {
		return (EReference)irModuleEClass.getEStructuralFeatures().get(1);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getIrModule_Items() {
		return (EReference)irModuleEClass.getEStructuralFeatures().get(2);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getIrModule_Functions() {
		return (EReference)irModuleEClass.getEStructuralFeatures().get(3);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getIrModule_Reductions() {
		return (EReference)irModuleEClass.getEStructuralFeatures().get(4);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getIrModule_Connectivities() {
		return (EReference)irModuleEClass.getEStructuralFeatures().get(5);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getIrModule_Variables() {
		return (EReference)irModuleEClass.getEStructuralFeatures().get(6);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getIrModule_InitCoordVariable() {
		return (EReference)irModuleEClass.getEStructuralFeatures().get(7);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getIrModule_Jobs() {
		return (EReference)irModuleEClass.getEStructuralFeatures().get(8);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EClass getImport() {
		return importEClass;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EAttribute getImport_ImportedNamespace() {
		return (EAttribute)importEClass.getEStructuralFeatures().get(0);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EClass getVariable() {
		return variableEClass;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EAttribute getVariable_Name() {
		return (EAttribute)variableEClass.getEStructuralFeatures().get(0);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EAttribute getVariable_PersistenceName() {
		return (EAttribute)variableEClass.getEStructuralFeatures().get(1);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EAttribute getVariable_Const() {
		return (EAttribute)variableEClass.getEStructuralFeatures().get(2);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EClass getSimpleVariable() {
		return simpleVariableEClass;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getSimpleVariable_Type() {
		return (EReference)simpleVariableEClass.getEStructuralFeatures().get(0);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getSimpleVariable_DefaultValue() {
		return (EReference)simpleVariableEClass.getEStructuralFeatures().get(1);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EClass getConnectivityVariable() {
		return connectivityVariableEClass;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getConnectivityVariable_Type() {
		return (EReference)connectivityVariableEClass.getEStructuralFeatures().get(0);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getConnectivityVariable_DefaultValue() {
		return (EReference)connectivityVariableEClass.getEStructuralFeatures().get(1);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EClass getFunction() {
		return functionEClass;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EAttribute getFunction_Name() {
		return (EAttribute)functionEClass.getEStructuralFeatures().get(0);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getFunction_InArgs() {
		return (EReference)functionEClass.getEStructuralFeatures().get(1);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getFunction_ReturnType() {
		return (EReference)functionEClass.getEStructuralFeatures().get(2);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EAttribute getFunction_Provider() {
		return (EAttribute)functionEClass.getEStructuralFeatures().get(3);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EClass getReduction() {
		return reductionEClass;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EAttribute getReduction_Name() {
		return (EAttribute)reductionEClass.getEStructuralFeatures().get(0);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getReduction_CollectionType() {
		return (EReference)reductionEClass.getEStructuralFeatures().get(1);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getReduction_ReturnType() {
		return (EReference)reductionEClass.getEStructuralFeatures().get(2);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EAttribute getReduction_Provider() {
		return (EAttribute)reductionEClass.getEStructuralFeatures().get(3);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EAttribute getReduction_Operator() {
		return (EAttribute)reductionEClass.getEStructuralFeatures().get(4);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EClass getArg() {
		return argEClass;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EAttribute getArg_Name() {
		return (EAttribute)argEClass.getEStructuralFeatures().get(0);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getArg_Type() {
		return (EReference)argEClass.getEStructuralFeatures().get(1);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EClass getConnectivity() {
		return connectivityEClass;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EAttribute getConnectivity_Name() {
		return (EAttribute)connectivityEClass.getEStructuralFeatures().get(0);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getConnectivity_InTypes() {
		return (EReference)connectivityEClass.getEStructuralFeatures().get(1);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getConnectivity_ReturnType() {
		return (EReference)connectivityEClass.getEStructuralFeatures().get(2);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EAttribute getConnectivity_IndexEqualId() {
		return (EAttribute)connectivityEClass.getEStructuralFeatures().get(3);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EClass getItemArgType() {
		return itemArgTypeEClass;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EAttribute getItemArgType_Multiple() {
		return (EAttribute)itemArgTypeEClass.getEStructuralFeatures().get(0);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getItemArgType_Type() {
		return (EReference)itemArgTypeEClass.getEStructuralFeatures().get(1);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EClass getJob() {
		return jobEClass;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EAttribute getJob_Name() {
		return (EAttribute)jobEClass.getEStructuralFeatures().get(0);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EAttribute getJob_At() {
		return (EAttribute)jobEClass.getEStructuralFeatures().get(1);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EAttribute getJob_OnCycle() {
		return (EAttribute)jobEClass.getEStructuralFeatures().get(2);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EClass getInstructionJob() {
		return instructionJobEClass;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getInstructionJob_Instruction() {
		return (EReference)instructionJobEClass.getEStructuralFeatures().get(0);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EClass getInSituJob() {
		return inSituJobEClass;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getInSituJob_Variables() {
		return (EReference)inSituJobEClass.getEStructuralFeatures().get(0);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EAttribute getInSituJob_IterationPeriod() {
		return (EAttribute)inSituJobEClass.getEStructuralFeatures().get(1);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EAttribute getInSituJob_TimeStep() {
		return (EAttribute)inSituJobEClass.getEStructuralFeatures().get(2);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EClass getTimeIterationCopyJob() {
		return timeIterationCopyJobEClass;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getTimeIterationCopyJob_Left() {
		return (EReference)timeIterationCopyJobEClass.getEStructuralFeatures().get(0);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getTimeIterationCopyJob_Right() {
		return (EReference)timeIterationCopyJobEClass.getEStructuralFeatures().get(1);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EAttribute getTimeIterationCopyJob_TimeIteratorName() {
		return (EAttribute)timeIterationCopyJobEClass.getEStructuralFeatures().get(2);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EClass getEndOfTimeLoopJob() {
		return endOfTimeLoopJobEClass;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EClass getEndOfInitJob() {
		return endOfInitJobEClass;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EClass getInstruction() {
		return instructionEClass;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EClass getVarDefinition() {
		return varDefinitionEClass;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getVarDefinition_Variables() {
		return (EReference)varDefinitionEClass.getEStructuralFeatures().get(0);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EClass getInstructionBlock() {
		return instructionBlockEClass;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getInstructionBlock_Instructions() {
		return (EReference)instructionBlockEClass.getEStructuralFeatures().get(0);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EClass getAffectation() {
		return affectationEClass;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getAffectation_Left() {
		return (EReference)affectationEClass.getEStructuralFeatures().get(0);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getAffectation_Right() {
		return (EReference)affectationEClass.getEStructuralFeatures().get(1);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EClass getIterableInstruction() {
		return iterableInstructionEClass;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getIterableInstruction_Range() {
		return (EReference)iterableInstructionEClass.getEStructuralFeatures().get(0);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getIterableInstruction_Singletons() {
		return (EReference)iterableInstructionEClass.getEStructuralFeatures().get(1);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EClass getReductionInstruction() {
		return reductionInstructionEClass;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getReductionInstruction_InnerReductions() {
		return (EReference)reductionInstructionEClass.getEStructuralFeatures().get(0);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getReductionInstruction_Reduction() {
		return (EReference)reductionInstructionEClass.getEStructuralFeatures().get(1);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getReductionInstruction_Arg() {
		return (EReference)reductionInstructionEClass.getEStructuralFeatures().get(2);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getReductionInstruction_Result() {
		return (EReference)reductionInstructionEClass.getEStructuralFeatures().get(3);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EClass getLoop() {
		return loopEClass;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getLoop_Body() {
		return (EReference)loopEClass.getEStructuralFeatures().get(0);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EClass getIf() {
		return ifEClass;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getIf_Condition() {
		return (EReference)ifEClass.getEStructuralFeatures().get(0);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getIf_ThenInstruction() {
		return (EReference)ifEClass.getEStructuralFeatures().get(1);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getIf_ElseInstruction() {
		return (EReference)ifEClass.getEStructuralFeatures().get(2);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EClass getExpression() {
		return expressionEClass;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getExpression_Type() {
		return (EReference)expressionEClass.getEStructuralFeatures().get(0);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EClass getContractedIf() {
		return contractedIfEClass;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getContractedIf_Condition() {
		return (EReference)contractedIfEClass.getEStructuralFeatures().get(0);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getContractedIf_ThenExpression() {
		return (EReference)contractedIfEClass.getEStructuralFeatures().get(1);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getContractedIf_ElseExpression() {
		return (EReference)contractedIfEClass.getEStructuralFeatures().get(2);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EClass getBinaryExpression() {
		return binaryExpressionEClass;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EAttribute getBinaryExpression_Operator() {
		return (EAttribute)binaryExpressionEClass.getEStructuralFeatures().get(0);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getBinaryExpression_Left() {
		return (EReference)binaryExpressionEClass.getEStructuralFeatures().get(1);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getBinaryExpression_Right() {
		return (EReference)binaryExpressionEClass.getEStructuralFeatures().get(2);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EClass getUnaryExpression() {
		return unaryExpressionEClass;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EAttribute getUnaryExpression_Operator() {
		return (EAttribute)unaryExpressionEClass.getEStructuralFeatures().get(0);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getUnaryExpression_Expression() {
		return (EReference)unaryExpressionEClass.getEStructuralFeatures().get(1);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EClass getParenthesis() {
		return parenthesisEClass;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getParenthesis_Expression() {
		return (EReference)parenthesisEClass.getEStructuralFeatures().get(0);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EClass getConstant() {
		return constantEClass;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EAttribute getConstant_Value() {
		return (EAttribute)constantEClass.getEStructuralFeatures().get(0);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EClass getMaxConstant() {
		return maxConstantEClass;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EClass getBaseTypeConstant() {
		return baseTypeConstantEClass;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getBaseTypeConstant_Value() {
		return (EReference)baseTypeConstantEClass.getEStructuralFeatures().get(0);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EClass getIntVectorConstant() {
		return intVectorConstantEClass;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EAttribute getIntVectorConstant_Values() {
		return (EAttribute)intVectorConstantEClass.getEStructuralFeatures().get(0);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EClass getIntMatrixConstant() {
		return intMatrixConstantEClass;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getIntMatrixConstant_Values() {
		return (EReference)intMatrixConstantEClass.getEStructuralFeatures().get(0);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EClass getRealVectorConstant() {
		return realVectorConstantEClass;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EAttribute getRealVectorConstant_Values() {
		return (EAttribute)realVectorConstantEClass.getEStructuralFeatures().get(0);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EClass getRealMatrixConstant() {
		return realMatrixConstantEClass;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getRealMatrixConstant_Values() {
		return (EReference)realMatrixConstantEClass.getEStructuralFeatures().get(0);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EClass getMinConstant() {
		return minConstantEClass;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EClass getFunctionCall() {
		return functionCallEClass;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getFunctionCall_Function() {
		return (EReference)functionCallEClass.getEStructuralFeatures().get(0);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getFunctionCall_Args() {
		return (EReference)functionCallEClass.getEStructuralFeatures().get(1);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EClass getVarRef() {
		return varRefEClass;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getVarRef_Variable() {
		return (EReference)varRefEClass.getEStructuralFeatures().get(0);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getVarRef_Iterators() {
		return (EReference)varRefEClass.getEStructuralFeatures().get(1);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EAttribute getVarRef_Indices() {
		return (EAttribute)varRefEClass.getEStructuralFeatures().get(2);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EClass getIterator() {
		return iteratorEClass;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EAttribute getIterator_Name() {
		return (EAttribute)iteratorEClass.getEStructuralFeatures().get(0);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getIterator_Container() {
		return (EReference)iteratorEClass.getEStructuralFeatures().get(1);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EAttribute getIterator_Singleton() {
		return (EAttribute)iteratorEClass.getEStructuralFeatures().get(2);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getIterator_Referencers() {
		return (EReference)iteratorEClass.getEStructuralFeatures().get(3);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EClass getConnectivityCall() {
		return connectivityCallEClass;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getConnectivityCall_Connectivity() {
		return (EReference)connectivityCallEClass.getEStructuralFeatures().get(0);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getConnectivityCall_Args() {
		return (EReference)connectivityCallEClass.getEStructuralFeatures().get(1);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EClass getIteratorRef() {
		return iteratorRefEClass;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getIteratorRef_Target() {
		return (EReference)iteratorRefEClass.getEStructuralFeatures().get(0);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EAttribute getIteratorRef_Shift() {
		return (EAttribute)iteratorRefEClass.getEStructuralFeatures().get(1);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EAttribute getIteratorRef_IndexInReferencerList() {
		return (EAttribute)iteratorRefEClass.getEStructuralFeatures().get(2);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EClass getConnectivityCallIteratorRef() {
		return connectivityCallIteratorRefEClass;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getConnectivityCallIteratorRef_ReferencedBy() {
		return (EReference)connectivityCallIteratorRefEClass.getEStructuralFeatures().get(0);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EClass getVarRefIteratorRef() {
		return varRefIteratorRefEClass;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getVarRefIteratorRef_ReferencedBy() {
		return (EReference)varRefIteratorRefEClass.getEStructuralFeatures().get(0);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EClass getItemType() {
		return itemTypeEClass;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EAttribute getItemType_Name() {
		return (EAttribute)itemTypeEClass.getEStructuralFeatures().get(0);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EClass getBaseType() {
		return baseTypeEClass;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EAttribute getBaseType_Primitive() {
		return (EAttribute)baseTypeEClass.getEStructuralFeatures().get(0);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EClass getScalar() {
		return scalarEClass;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EClass getArray1D() {
		return array1DEClass;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EAttribute getArray1D_Size() {
		return (EAttribute)array1DEClass.getEStructuralFeatures().get(0);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EClass getArray2D() {
		return array2DEClass;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EAttribute getArray2D_NbRows() {
		return (EAttribute)array2DEClass.getEStructuralFeatures().get(0);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EAttribute getArray2D_NbCols() {
		return (EAttribute)array2DEClass.getEStructuralFeatures().get(1);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EClass getIrType() {
		return irTypeEClass;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EClass getConnectivityType() {
		return connectivityTypeEClass;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getConnectivityType_Connectivities() {
		return (EReference)connectivityTypeEClass.getEStructuralFeatures().get(0);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getConnectivityType_Base() {
		return (EReference)connectivityTypeEClass.getEStructuralFeatures().get(1);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EEnum getPrimitiveType() {
		return primitiveTypeEEnum;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public IrFactory getIrFactory() {
		return (IrFactory)getEFactoryInstance();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private boolean isCreated = false;

	/**
	 * Creates the meta-model objects for the package.  This method is
	 * guarded to have no affect on any invocation but its first.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void createPackageContents() {
		if (isCreated) return;
		isCreated = true;

		// Create classes and their features
		irAnnotableEClass = createEClass(IR_ANNOTABLE);
		createEReference(irAnnotableEClass, IR_ANNOTABLE__ANNOTATIONS);

		irAnnotationEClass = createEClass(IR_ANNOTATION);
		createEAttribute(irAnnotationEClass, IR_ANNOTATION__SOURCE);
		createEReference(irAnnotationEClass, IR_ANNOTATION__DETAILS);

		irModuleEClass = createEClass(IR_MODULE);
		createEAttribute(irModuleEClass, IR_MODULE__NAME);
		createEReference(irModuleEClass, IR_MODULE__IMPORTS);
		createEReference(irModuleEClass, IR_MODULE__ITEMS);
		createEReference(irModuleEClass, IR_MODULE__FUNCTIONS);
		createEReference(irModuleEClass, IR_MODULE__REDUCTIONS);
		createEReference(irModuleEClass, IR_MODULE__CONNECTIVITIES);
		createEReference(irModuleEClass, IR_MODULE__VARIABLES);
		createEReference(irModuleEClass, IR_MODULE__INIT_COORD_VARIABLE);
		createEReference(irModuleEClass, IR_MODULE__JOBS);

		importEClass = createEClass(IMPORT);
		createEAttribute(importEClass, IMPORT__IMPORTED_NAMESPACE);

		variableEClass = createEClass(VARIABLE);
		createEAttribute(variableEClass, VARIABLE__NAME);
		createEAttribute(variableEClass, VARIABLE__PERSISTENCE_NAME);
		createEAttribute(variableEClass, VARIABLE__CONST);

		simpleVariableEClass = createEClass(SIMPLE_VARIABLE);
		createEReference(simpleVariableEClass, SIMPLE_VARIABLE__TYPE);
		createEReference(simpleVariableEClass, SIMPLE_VARIABLE__DEFAULT_VALUE);

		connectivityVariableEClass = createEClass(CONNECTIVITY_VARIABLE);
		createEReference(connectivityVariableEClass, CONNECTIVITY_VARIABLE__TYPE);
		createEReference(connectivityVariableEClass, CONNECTIVITY_VARIABLE__DEFAULT_VALUE);

		functionEClass = createEClass(FUNCTION);
		createEAttribute(functionEClass, FUNCTION__NAME);
		createEReference(functionEClass, FUNCTION__IN_ARGS);
		createEReference(functionEClass, FUNCTION__RETURN_TYPE);
		createEAttribute(functionEClass, FUNCTION__PROVIDER);

		reductionEClass = createEClass(REDUCTION);
		createEAttribute(reductionEClass, REDUCTION__NAME);
		createEReference(reductionEClass, REDUCTION__COLLECTION_TYPE);
		createEReference(reductionEClass, REDUCTION__RETURN_TYPE);
		createEAttribute(reductionEClass, REDUCTION__PROVIDER);
		createEAttribute(reductionEClass, REDUCTION__OPERATOR);

		argEClass = createEClass(ARG);
		createEAttribute(argEClass, ARG__NAME);
		createEReference(argEClass, ARG__TYPE);

		connectivityEClass = createEClass(CONNECTIVITY);
		createEAttribute(connectivityEClass, CONNECTIVITY__NAME);
		createEReference(connectivityEClass, CONNECTIVITY__IN_TYPES);
		createEReference(connectivityEClass, CONNECTIVITY__RETURN_TYPE);
		createEAttribute(connectivityEClass, CONNECTIVITY__INDEX_EQUAL_ID);

		itemArgTypeEClass = createEClass(ITEM_ARG_TYPE);
		createEAttribute(itemArgTypeEClass, ITEM_ARG_TYPE__MULTIPLE);
		createEReference(itemArgTypeEClass, ITEM_ARG_TYPE__TYPE);

		jobEClass = createEClass(JOB);
		createEAttribute(jobEClass, JOB__NAME);
		createEAttribute(jobEClass, JOB__AT);
		createEAttribute(jobEClass, JOB__ON_CYCLE);

		instructionJobEClass = createEClass(INSTRUCTION_JOB);
		createEReference(instructionJobEClass, INSTRUCTION_JOB__INSTRUCTION);

		inSituJobEClass = createEClass(IN_SITU_JOB);
		createEReference(inSituJobEClass, IN_SITU_JOB__VARIABLES);
		createEAttribute(inSituJobEClass, IN_SITU_JOB__ITERATION_PERIOD);
		createEAttribute(inSituJobEClass, IN_SITU_JOB__TIME_STEP);

		timeIterationCopyJobEClass = createEClass(TIME_ITERATION_COPY_JOB);
		createEReference(timeIterationCopyJobEClass, TIME_ITERATION_COPY_JOB__LEFT);
		createEReference(timeIterationCopyJobEClass, TIME_ITERATION_COPY_JOB__RIGHT);
		createEAttribute(timeIterationCopyJobEClass, TIME_ITERATION_COPY_JOB__TIME_ITERATOR_NAME);

		endOfTimeLoopJobEClass = createEClass(END_OF_TIME_LOOP_JOB);

		endOfInitJobEClass = createEClass(END_OF_INIT_JOB);

		instructionEClass = createEClass(INSTRUCTION);

		varDefinitionEClass = createEClass(VAR_DEFINITION);
		createEReference(varDefinitionEClass, VAR_DEFINITION__VARIABLES);

		instructionBlockEClass = createEClass(INSTRUCTION_BLOCK);
		createEReference(instructionBlockEClass, INSTRUCTION_BLOCK__INSTRUCTIONS);

		affectationEClass = createEClass(AFFECTATION);
		createEReference(affectationEClass, AFFECTATION__LEFT);
		createEReference(affectationEClass, AFFECTATION__RIGHT);

		iterableInstructionEClass = createEClass(ITERABLE_INSTRUCTION);
		createEReference(iterableInstructionEClass, ITERABLE_INSTRUCTION__RANGE);
		createEReference(iterableInstructionEClass, ITERABLE_INSTRUCTION__SINGLETONS);

		reductionInstructionEClass = createEClass(REDUCTION_INSTRUCTION);
		createEReference(reductionInstructionEClass, REDUCTION_INSTRUCTION__INNER_REDUCTIONS);
		createEReference(reductionInstructionEClass, REDUCTION_INSTRUCTION__REDUCTION);
		createEReference(reductionInstructionEClass, REDUCTION_INSTRUCTION__ARG);
		createEReference(reductionInstructionEClass, REDUCTION_INSTRUCTION__RESULT);

		loopEClass = createEClass(LOOP);
		createEReference(loopEClass, LOOP__BODY);

		ifEClass = createEClass(IF);
		createEReference(ifEClass, IF__CONDITION);
		createEReference(ifEClass, IF__THEN_INSTRUCTION);
		createEReference(ifEClass, IF__ELSE_INSTRUCTION);

		expressionEClass = createEClass(EXPRESSION);
		createEReference(expressionEClass, EXPRESSION__TYPE);

		contractedIfEClass = createEClass(CONTRACTED_IF);
		createEReference(contractedIfEClass, CONTRACTED_IF__CONDITION);
		createEReference(contractedIfEClass, CONTRACTED_IF__THEN_EXPRESSION);
		createEReference(contractedIfEClass, CONTRACTED_IF__ELSE_EXPRESSION);

		binaryExpressionEClass = createEClass(BINARY_EXPRESSION);
		createEAttribute(binaryExpressionEClass, BINARY_EXPRESSION__OPERATOR);
		createEReference(binaryExpressionEClass, BINARY_EXPRESSION__LEFT);
		createEReference(binaryExpressionEClass, BINARY_EXPRESSION__RIGHT);

		unaryExpressionEClass = createEClass(UNARY_EXPRESSION);
		createEAttribute(unaryExpressionEClass, UNARY_EXPRESSION__OPERATOR);
		createEReference(unaryExpressionEClass, UNARY_EXPRESSION__EXPRESSION);

		parenthesisEClass = createEClass(PARENTHESIS);
		createEReference(parenthesisEClass, PARENTHESIS__EXPRESSION);

		constantEClass = createEClass(CONSTANT);
		createEAttribute(constantEClass, CONSTANT__VALUE);

		minConstantEClass = createEClass(MIN_CONSTANT);

		maxConstantEClass = createEClass(MAX_CONSTANT);

		baseTypeConstantEClass = createEClass(BASE_TYPE_CONSTANT);
		createEReference(baseTypeConstantEClass, BASE_TYPE_CONSTANT__VALUE);

		intVectorConstantEClass = createEClass(INT_VECTOR_CONSTANT);
		createEAttribute(intVectorConstantEClass, INT_VECTOR_CONSTANT__VALUES);

		intMatrixConstantEClass = createEClass(INT_MATRIX_CONSTANT);
		createEReference(intMatrixConstantEClass, INT_MATRIX_CONSTANT__VALUES);

		realVectorConstantEClass = createEClass(REAL_VECTOR_CONSTANT);
		createEAttribute(realVectorConstantEClass, REAL_VECTOR_CONSTANT__VALUES);

		realMatrixConstantEClass = createEClass(REAL_MATRIX_CONSTANT);
		createEReference(realMatrixConstantEClass, REAL_MATRIX_CONSTANT__VALUES);

		functionCallEClass = createEClass(FUNCTION_CALL);
		createEReference(functionCallEClass, FUNCTION_CALL__FUNCTION);
		createEReference(functionCallEClass, FUNCTION_CALL__ARGS);

		varRefEClass = createEClass(VAR_REF);
		createEReference(varRefEClass, VAR_REF__VARIABLE);
		createEReference(varRefEClass, VAR_REF__ITERATORS);
		createEAttribute(varRefEClass, VAR_REF__INDICES);

		iteratorEClass = createEClass(ITERATOR);
		createEAttribute(iteratorEClass, ITERATOR__NAME);
		createEReference(iteratorEClass, ITERATOR__CONTAINER);
		createEAttribute(iteratorEClass, ITERATOR__SINGLETON);
		createEReference(iteratorEClass, ITERATOR__REFERENCERS);

		connectivityCallEClass = createEClass(CONNECTIVITY_CALL);
		createEReference(connectivityCallEClass, CONNECTIVITY_CALL__CONNECTIVITY);
		createEReference(connectivityCallEClass, CONNECTIVITY_CALL__ARGS);

		iteratorRefEClass = createEClass(ITERATOR_REF);
		createEReference(iteratorRefEClass, ITERATOR_REF__TARGET);
		createEAttribute(iteratorRefEClass, ITERATOR_REF__SHIFT);
		createEAttribute(iteratorRefEClass, ITERATOR_REF__INDEX_IN_REFERENCER_LIST);

		connectivityCallIteratorRefEClass = createEClass(CONNECTIVITY_CALL_ITERATOR_REF);
		createEReference(connectivityCallIteratorRefEClass, CONNECTIVITY_CALL_ITERATOR_REF__REFERENCED_BY);

		varRefIteratorRefEClass = createEClass(VAR_REF_ITERATOR_REF);
		createEReference(varRefIteratorRefEClass, VAR_REF_ITERATOR_REF__REFERENCED_BY);

		itemTypeEClass = createEClass(ITEM_TYPE);
		createEAttribute(itemTypeEClass, ITEM_TYPE__NAME);

		baseTypeEClass = createEClass(BASE_TYPE);
		createEAttribute(baseTypeEClass, BASE_TYPE__PRIMITIVE);

		scalarEClass = createEClass(SCALAR);

		array1DEClass = createEClass(ARRAY1_D);
		createEAttribute(array1DEClass, ARRAY1_D__SIZE);

		array2DEClass = createEClass(ARRAY2_D);
		createEAttribute(array2DEClass, ARRAY2_D__NB_ROWS);
		createEAttribute(array2DEClass, ARRAY2_D__NB_COLS);

		irTypeEClass = createEClass(IR_TYPE);

		connectivityTypeEClass = createEClass(CONNECTIVITY_TYPE);
		createEReference(connectivityTypeEClass, CONNECTIVITY_TYPE__CONNECTIVITIES);
		createEReference(connectivityTypeEClass, CONNECTIVITY_TYPE__BASE);

		// Create enums
		primitiveTypeEEnum = createEEnum(PRIMITIVE_TYPE);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private boolean isInitialized = false;

	/**
	 * Complete the initialization of the package and its meta-model.  This
	 * method is guarded to have no affect on any invocation but its first.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void initializePackageContents() {
		if (isInitialized) return;
		isInitialized = true;

		// Initialize package
		setName(eNAME);
		setNsPrefix(eNS_PREFIX);
		setNsURI(eNS_URI);

		// Create type parameters

		// Set bounds for type parameters

		// Add supertypes to classes
		irModuleEClass.getESuperTypes().add(this.getIrAnnotable());
		importEClass.getESuperTypes().add(this.getIrAnnotable());
		variableEClass.getESuperTypes().add(this.getIrAnnotable());
		simpleVariableEClass.getESuperTypes().add(this.getVariable());
		connectivityVariableEClass.getESuperTypes().add(this.getVariable());
		functionEClass.getESuperTypes().add(this.getIrAnnotable());
		reductionEClass.getESuperTypes().add(this.getIrAnnotable());
		argEClass.getESuperTypes().add(this.getIrAnnotable());
		connectivityEClass.getESuperTypes().add(this.getIrAnnotable());
		itemArgTypeEClass.getESuperTypes().add(this.getIrAnnotable());
		jobEClass.getESuperTypes().add(this.getIrAnnotable());
		instructionJobEClass.getESuperTypes().add(this.getJob());
		inSituJobEClass.getESuperTypes().add(this.getJob());
		timeIterationCopyJobEClass.getESuperTypes().add(this.getJob());
		endOfTimeLoopJobEClass.getESuperTypes().add(this.getTimeIterationCopyJob());
		endOfInitJobEClass.getESuperTypes().add(this.getTimeIterationCopyJob());
		instructionEClass.getESuperTypes().add(this.getIrAnnotable());
		varDefinitionEClass.getESuperTypes().add(this.getInstruction());
		instructionBlockEClass.getESuperTypes().add(this.getInstruction());
		affectationEClass.getESuperTypes().add(this.getInstruction());
		iterableInstructionEClass.getESuperTypes().add(this.getInstruction());
		reductionInstructionEClass.getESuperTypes().add(this.getIterableInstruction());
		loopEClass.getESuperTypes().add(this.getIterableInstruction());
		ifEClass.getESuperTypes().add(this.getInstruction());
		expressionEClass.getESuperTypes().add(this.getIrAnnotable());
		contractedIfEClass.getESuperTypes().add(this.getExpression());
		binaryExpressionEClass.getESuperTypes().add(this.getExpression());
		unaryExpressionEClass.getESuperTypes().add(this.getExpression());
		parenthesisEClass.getESuperTypes().add(this.getExpression());
		constantEClass.getESuperTypes().add(this.getExpression());
		minConstantEClass.getESuperTypes().add(this.getExpression());
		maxConstantEClass.getESuperTypes().add(this.getExpression());
		baseTypeConstantEClass.getESuperTypes().add(this.getExpression());
		intVectorConstantEClass.getESuperTypes().add(this.getExpression());
		intMatrixConstantEClass.getESuperTypes().add(this.getExpression());
		realVectorConstantEClass.getESuperTypes().add(this.getExpression());
		realMatrixConstantEClass.getESuperTypes().add(this.getExpression());
		functionCallEClass.getESuperTypes().add(this.getExpression());
		varRefEClass.getESuperTypes().add(this.getExpression());
		iteratorEClass.getESuperTypes().add(this.getIrAnnotable());
		connectivityCallEClass.getESuperTypes().add(this.getIrAnnotable());
		iteratorRefEClass.getESuperTypes().add(this.getIrAnnotable());
		connectivityCallIteratorRefEClass.getESuperTypes().add(this.getIteratorRef());
		varRefIteratorRefEClass.getESuperTypes().add(this.getIteratorRef());
		baseTypeEClass.getESuperTypes().add(this.getIrType());
		scalarEClass.getESuperTypes().add(this.getBaseType());
		array1DEClass.getESuperTypes().add(this.getBaseType());
		array2DEClass.getESuperTypes().add(this.getBaseType());
		irTypeEClass.getESuperTypes().add(this.getIrAnnotable());
		connectivityTypeEClass.getESuperTypes().add(this.getIrType());

		// Initialize classes, features, and operations; add parameters
		initEClass(irAnnotableEClass, IrAnnotable.class, "IrAnnotable", IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
		initEReference(getIrAnnotable_Annotations(), this.getIrAnnotation(), null, "annotations", null, 0, -1, IrAnnotable.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, !IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

		initEClass(irAnnotationEClass, IrAnnotation.class, "IrAnnotation", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
		initEAttribute(getIrAnnotation_Source(), ecorePackage.getEString(), "source", null, 0, 1, IrAnnotation.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_UNSETTABLE, !IS_ID, !IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
		initEReference(getIrAnnotation_Details(), ecorePackage.getEStringToStringMapEntry(), null, "details", null, 0, -1, IrAnnotation.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, !IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

		initEClass(irModuleEClass, IrModule.class, "IrModule", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
		initEAttribute(getIrModule_Name(), ecorePackage.getEString(), "name", null, 1, 1, IrModule.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_UNSETTABLE, !IS_ID, !IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
		initEReference(getIrModule_Imports(), this.getImport(), null, "imports", null, 0, -1, IrModule.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, !IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
		initEReference(getIrModule_Items(), this.getItemType(), null, "items", null, 0, -1, IrModule.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
		initEReference(getIrModule_Functions(), this.getFunction(), null, "functions", null, 0, -1, IrModule.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, !IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
		initEReference(getIrModule_Reductions(), this.getReduction(), null, "reductions", null, 0, -1, IrModule.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, !IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
		initEReference(getIrModule_Connectivities(), this.getConnectivity(), null, "connectivities", null, 0, -1, IrModule.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, !IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
		initEReference(getIrModule_Variables(), this.getVariable(), null, "variables", null, 0, -1, IrModule.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, !IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
		initEReference(getIrModule_InitCoordVariable(), this.getVariable(), null, "initCoordVariable", null, 1, 1, IrModule.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_COMPOSITE, IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
		initEReference(getIrModule_Jobs(), this.getJob(), null, "jobs", null, 0, -1, IrModule.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, !IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

		initEClass(importEClass, Import.class, "Import", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
		initEAttribute(getImport_ImportedNamespace(), ecorePackage.getEString(), "importedNamespace", null, 1, 1, Import.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_UNSETTABLE, !IS_ID, !IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

		initEClass(variableEClass, Variable.class, "Variable", IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
		initEAttribute(getVariable_Name(), ecorePackage.getEString(), "name", null, 1, 1, Variable.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_UNSETTABLE, !IS_ID, !IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
		initEAttribute(getVariable_PersistenceName(), ecorePackage.getEString(), "persistenceName", null, 0, 1, Variable.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_UNSETTABLE, !IS_ID, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
		initEAttribute(getVariable_Const(), ecorePackage.getEBoolean(), "const", "false", 1, 1, Variable.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_UNSETTABLE, !IS_ID, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

		initEClass(simpleVariableEClass, SimpleVariable.class, "SimpleVariable", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
		initEReference(getSimpleVariable_Type(), this.getBaseType(), null, "type", null, 1, 1, SimpleVariable.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
		initEReference(getSimpleVariable_DefaultValue(), this.getExpression(), null, "defaultValue", null, 0, 1, SimpleVariable.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, !IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

		initEClass(connectivityVariableEClass, ConnectivityVariable.class, "ConnectivityVariable", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
		initEReference(getConnectivityVariable_Type(), this.getConnectivityType(), null, "type", null, 1, 1, ConnectivityVariable.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
		initEReference(getConnectivityVariable_DefaultValue(), this.getVarRef(), null, "defaultValue", null, 0, 1, ConnectivityVariable.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

		initEClass(functionEClass, Function.class, "Function", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
		initEAttribute(getFunction_Name(), ecorePackage.getEString(), "name", null, 1, 1, Function.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_UNSETTABLE, !IS_ID, !IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
		initEReference(getFunction_InArgs(), this.getArg(), null, "inArgs", null, 0, -1, Function.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
		initEReference(getFunction_ReturnType(), this.getBaseType(), null, "returnType", null, 0, 1, Function.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
		initEAttribute(getFunction_Provider(), ecorePackage.getEString(), "provider", null, 1, 1, Function.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_UNSETTABLE, !IS_ID, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

		initEClass(reductionEClass, Reduction.class, "Reduction", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
		initEAttribute(getReduction_Name(), ecorePackage.getEString(), "name", null, 0, 1, Reduction.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_UNSETTABLE, !IS_ID, !IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
		initEReference(getReduction_CollectionType(), this.getBaseType(), null, "collectionType", null, 1, 1, Reduction.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
		initEReference(getReduction_ReturnType(), this.getBaseType(), null, "returnType", null, 1, 1, Reduction.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
		initEAttribute(getReduction_Provider(), ecorePackage.getEString(), "provider", null, 1, 1, Reduction.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_UNSETTABLE, !IS_ID, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
		initEAttribute(getReduction_Operator(), ecorePackage.getEBoolean(), "operator", "false", 1, 1, Reduction.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_UNSETTABLE, !IS_ID, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

		initEClass(argEClass, Arg.class, "Arg", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
		initEAttribute(getArg_Name(), ecorePackage.getEString(), "name", null, 1, 1, Arg.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_UNSETTABLE, !IS_ID, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
		initEReference(getArg_Type(), this.getBaseType(), null, "type", null, 1, 1, Arg.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

		initEClass(connectivityEClass, Connectivity.class, "Connectivity", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
		initEAttribute(getConnectivity_Name(), ecorePackage.getEString(), "name", null, 0, 1, Connectivity.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_UNSETTABLE, !IS_ID, !IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
		initEReference(getConnectivity_InTypes(), this.getItemType(), null, "inTypes", null, 0, -1, Connectivity.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_COMPOSITE, IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
		initEReference(getConnectivity_ReturnType(), this.getItemArgType(), null, "returnType", null, 0, 1, Connectivity.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, !IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
		initEAttribute(getConnectivity_IndexEqualId(), ecorePackage.getEBoolean(), "indexEqualId", "false", 1, 1, Connectivity.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_UNSETTABLE, !IS_ID, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

		initEClass(itemArgTypeEClass, ItemArgType.class, "ItemArgType", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
		initEAttribute(getItemArgType_Multiple(), ecorePackage.getEBoolean(), "multiple", null, 1, 1, ItemArgType.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_UNSETTABLE, !IS_ID, !IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
		initEReference(getItemArgType_Type(), this.getItemType(), null, "type", null, 1, 1, ItemArgType.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_COMPOSITE, IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

		initEClass(jobEClass, Job.class, "Job", IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
		initEAttribute(getJob_Name(), ecorePackage.getEString(), "name", null, 1, 1, Job.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_UNSETTABLE, !IS_ID, !IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
		initEAttribute(getJob_At(), ecorePackage.getEDouble(), "at", null, 1, 1, Job.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_UNSETTABLE, !IS_ID, !IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
		initEAttribute(getJob_OnCycle(), ecorePackage.getEBoolean(), "onCycle", null, 1, 1, Job.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_UNSETTABLE, !IS_ID, !IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

		initEClass(instructionJobEClass, InstructionJob.class, "InstructionJob", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
		initEReference(getInstructionJob_Instruction(), this.getInstruction(), null, "instruction", null, 1, 1, InstructionJob.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, !IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

		initEClass(inSituJobEClass, InSituJob.class, "InSituJob", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
		initEReference(getInSituJob_Variables(), this.getVariable(), null, "variables", null, 0, -1, InSituJob.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_COMPOSITE, IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
		initEAttribute(getInSituJob_IterationPeriod(), ecorePackage.getEInt(), "iterationPeriod", "-1", 1, 1, InSituJob.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_UNSETTABLE, !IS_ID, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
		initEAttribute(getInSituJob_TimeStep(), ecorePackage.getEDouble(), "timeStep", "-1.0", 1, 1, InSituJob.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_UNSETTABLE, !IS_ID, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

		initEClass(timeIterationCopyJobEClass, TimeIterationCopyJob.class, "TimeIterationCopyJob", IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
		initEReference(getTimeIterationCopyJob_Left(), this.getVariable(), null, "left", null, 1, 1, TimeIterationCopyJob.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_COMPOSITE, IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
		initEReference(getTimeIterationCopyJob_Right(), this.getVariable(), null, "right", null, 1, 1, TimeIterationCopyJob.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_COMPOSITE, IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
		initEAttribute(getTimeIterationCopyJob_TimeIteratorName(), ecorePackage.getEString(), "timeIteratorName", null, 1, 1, TimeIterationCopyJob.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_UNSETTABLE, !IS_ID, !IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

		initEClass(endOfTimeLoopJobEClass, EndOfTimeLoopJob.class, "EndOfTimeLoopJob", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);

		initEClass(endOfInitJobEClass, EndOfInitJob.class, "EndOfInitJob", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);

		initEClass(instructionEClass, Instruction.class, "Instruction", IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);

		initEClass(varDefinitionEClass, VarDefinition.class, "VarDefinition", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
		initEReference(getVarDefinition_Variables(), this.getVariable(), null, "variables", null, 1, -1, VarDefinition.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, !IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

		initEClass(instructionBlockEClass, InstructionBlock.class, "InstructionBlock", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
		initEReference(getInstructionBlock_Instructions(), this.getInstruction(), null, "instructions", null, 1, -1, InstructionBlock.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, !IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

		initEClass(affectationEClass, Affectation.class, "Affectation", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
		initEReference(getAffectation_Left(), this.getVarRef(), null, "left", null, 1, 1, Affectation.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, !IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
		initEReference(getAffectation_Right(), this.getExpression(), null, "right", null, 1, 1, Affectation.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, !IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

		initEClass(iterableInstructionEClass, IterableInstruction.class, "IterableInstruction", IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
		initEReference(getIterableInstruction_Range(), this.getIterator(), null, "range", null, 1, 1, IterableInstruction.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, !IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
		initEReference(getIterableInstruction_Singletons(), this.getIterator(), null, "singletons", null, 0, -1, IterableInstruction.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

		initEClass(reductionInstructionEClass, ReductionInstruction.class, "ReductionInstruction", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
		initEReference(getReductionInstruction_InnerReductions(), this.getInstruction(), null, "innerReductions", null, 0, -1, ReductionInstruction.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
		initEReference(getReductionInstruction_Reduction(), this.getReduction(), null, "reduction", null, 1, 1, ReductionInstruction.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_COMPOSITE, IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
		initEReference(getReductionInstruction_Arg(), this.getExpression(), null, "arg", null, 1, 1, ReductionInstruction.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, !IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
		initEReference(getReductionInstruction_Result(), this.getSimpleVariable(), null, "result", null, 1, 1, ReductionInstruction.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, !IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

		initEClass(loopEClass, Loop.class, "Loop", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
		initEReference(getLoop_Body(), this.getInstruction(), null, "body", null, 1, 1, Loop.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, !IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

		initEClass(ifEClass, If.class, "If", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
		initEReference(getIf_Condition(), this.getExpression(), null, "condition", null, 1, 1, If.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, !IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
		initEReference(getIf_ThenInstruction(), this.getInstruction(), null, "thenInstruction", null, 1, 1, If.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, !IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
		initEReference(getIf_ElseInstruction(), this.getInstruction(), null, "elseInstruction", null, 0, 1, If.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, !IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

		initEClass(expressionEClass, Expression.class, "Expression", IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
		initEReference(getExpression_Type(), this.getIrType(), null, "type", null, 1, 1, Expression.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, !IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

		initEClass(contractedIfEClass, ContractedIf.class, "ContractedIf", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
		initEReference(getContractedIf_Condition(), this.getExpression(), null, "condition", null, 1, 1, ContractedIf.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
		initEReference(getContractedIf_ThenExpression(), this.getExpression(), null, "thenExpression", null, 1, 1, ContractedIf.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
		initEReference(getContractedIf_ElseExpression(), this.getExpression(), null, "elseExpression", null, 1, 1, ContractedIf.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

		initEClass(binaryExpressionEClass, BinaryExpression.class, "BinaryExpression", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
		initEAttribute(getBinaryExpression_Operator(), ecorePackage.getEString(), "operator", null, 1, 1, BinaryExpression.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_UNSETTABLE, !IS_ID, !IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
		initEReference(getBinaryExpression_Left(), this.getExpression(), null, "left", null, 1, 1, BinaryExpression.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, !IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
		initEReference(getBinaryExpression_Right(), this.getExpression(), null, "right", null, 1, 1, BinaryExpression.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, !IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

		initEClass(unaryExpressionEClass, UnaryExpression.class, "UnaryExpression", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
		initEAttribute(getUnaryExpression_Operator(), ecorePackage.getEString(), "operator", null, 1, 1, UnaryExpression.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_UNSETTABLE, !IS_ID, !IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
		initEReference(getUnaryExpression_Expression(), this.getExpression(), null, "expression", null, 1, 1, UnaryExpression.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, !IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

		initEClass(parenthesisEClass, Parenthesis.class, "Parenthesis", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
		initEReference(getParenthesis_Expression(), this.getExpression(), null, "expression", null, 1, 1, Parenthesis.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, !IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

		initEClass(constantEClass, Constant.class, "Constant", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
		initEAttribute(getConstant_Value(), ecorePackage.getEString(), "value", null, 1, 1, Constant.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_UNSETTABLE, !IS_ID, !IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

		initEClass(minConstantEClass, MinConstant.class, "MinConstant", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);

		initEClass(maxConstantEClass, MaxConstant.class, "MaxConstant", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);

		initEClass(baseTypeConstantEClass, BaseTypeConstant.class, "BaseTypeConstant", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
		initEReference(getBaseTypeConstant_Value(), this.getExpression(), null, "value", null, 1, 1, BaseTypeConstant.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

		initEClass(intVectorConstantEClass, IntVectorConstant.class, "IntVectorConstant", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
		initEAttribute(getIntVectorConstant_Values(), ecorePackage.getEInt(), "values", null, 0, -1, IntVectorConstant.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_UNSETTABLE, !IS_ID, !IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

		initEClass(intMatrixConstantEClass, IntMatrixConstant.class, "IntMatrixConstant", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
		initEReference(getIntMatrixConstant_Values(), this.getIntVectorConstant(), null, "values", null, 0, -1, IntMatrixConstant.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

		initEClass(realVectorConstantEClass, RealVectorConstant.class, "RealVectorConstant", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
		initEAttribute(getRealVectorConstant_Values(), ecorePackage.getEDouble(), "values", null, 0, -1, RealVectorConstant.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_UNSETTABLE, !IS_ID, !IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

		initEClass(realMatrixConstantEClass, RealMatrixConstant.class, "RealMatrixConstant", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
		initEReference(getRealMatrixConstant_Values(), this.getRealVectorConstant(), null, "values", null, 0, -1, RealMatrixConstant.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

		initEClass(functionCallEClass, FunctionCall.class, "FunctionCall", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
		initEReference(getFunctionCall_Function(), this.getFunction(), null, "function", null, 1, 1, FunctionCall.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_COMPOSITE, IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
		initEReference(getFunctionCall_Args(), this.getExpression(), null, "args", null, 0, -1, FunctionCall.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, !IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

		initEClass(varRefEClass, VarRef.class, "VarRef", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
		initEReference(getVarRef_Variable(), this.getVariable(), null, "variable", null, 1, 1, VarRef.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_COMPOSITE, IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
		initEReference(getVarRef_Iterators(), this.getVarRefIteratorRef(), this.getVarRefIteratorRef_ReferencedBy(), "iterators", null, 0, -1, VarRef.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, !IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
		initEAttribute(getVarRef_Indices(), ecorePackage.getEInt(), "indices", null, 0, -1, VarRef.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_UNSETTABLE, !IS_ID, !IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

		initEClass(iteratorEClass, Iterator.class, "Iterator", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
		initEAttribute(getIterator_Name(), ecorePackage.getEString(), "name", null, 1, 1, Iterator.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_UNSETTABLE, !IS_ID, !IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
		initEReference(getIterator_Container(), this.getConnectivityCall(), null, "container", null, 1, 1, Iterator.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, !IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
		initEAttribute(getIterator_Singleton(), ecorePackage.getEBoolean(), "singleton", "false", 1, 1, Iterator.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_UNSETTABLE, !IS_ID, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
		initEReference(getIterator_Referencers(), this.getIteratorRef(), this.getIteratorRef_Target(), "referencers", null, 0, -1, Iterator.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_COMPOSITE, IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

		initEClass(connectivityCallEClass, ConnectivityCall.class, "ConnectivityCall", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
		initEReference(getConnectivityCall_Connectivity(), this.getConnectivity(), null, "connectivity", null, 1, 1, ConnectivityCall.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_COMPOSITE, IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
		initEReference(getConnectivityCall_Args(), this.getConnectivityCallIteratorRef(), this.getConnectivityCallIteratorRef_ReferencedBy(), "args", null, 0, -1, ConnectivityCall.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, !IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

		initEClass(iteratorRefEClass, IteratorRef.class, "IteratorRef", IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
		initEReference(getIteratorRef_Target(), this.getIterator(), this.getIterator_Referencers(), "target", null, 1, 1, IteratorRef.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_COMPOSITE, IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
		initEAttribute(getIteratorRef_Shift(), ecorePackage.getEInt(), "shift", "0", 1, 1, IteratorRef.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_UNSETTABLE, !IS_ID, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
		initEAttribute(getIteratorRef_IndexInReferencerList(), ecorePackage.getEInt(), "indexInReferencerList", null, 1, 1, IteratorRef.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_UNSETTABLE, !IS_ID, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

		initEClass(connectivityCallIteratorRefEClass, ConnectivityCallIteratorRef.class, "ConnectivityCallIteratorRef", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
		initEReference(getConnectivityCallIteratorRef_ReferencedBy(), this.getConnectivityCall(), this.getConnectivityCall_Args(), "referencedBy", null, 1, 1, ConnectivityCallIteratorRef.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_COMPOSITE, IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

		initEClass(varRefIteratorRefEClass, VarRefIteratorRef.class, "VarRefIteratorRef", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
		initEReference(getVarRefIteratorRef_ReferencedBy(), this.getVarRef(), this.getVarRef_Iterators(), "referencedBy", null, 1, 1, VarRefIteratorRef.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_COMPOSITE, IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

		initEClass(itemTypeEClass, ItemType.class, "ItemType", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
		initEAttribute(getItemType_Name(), ecorePackage.getEString(), "name", null, 1, 1, ItemType.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_UNSETTABLE, !IS_ID, !IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

		initEClass(baseTypeEClass, BaseType.class, "BaseType", IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
		initEAttribute(getBaseType_Primitive(), this.getPrimitiveType(), "primitive", null, 1, 1, BaseType.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_UNSETTABLE, !IS_ID, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

		initEClass(scalarEClass, Scalar.class, "Scalar", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);

		initEClass(array1DEClass, Array1D.class, "Array1D", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
		initEAttribute(getArray1D_Size(), ecorePackage.getEInt(), "size", null, 1, 1, Array1D.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_UNSETTABLE, !IS_ID, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

		initEClass(array2DEClass, Array2D.class, "Array2D", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
		initEAttribute(getArray2D_NbRows(), ecorePackage.getEInt(), "nbRows", null, 1, 1, Array2D.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_UNSETTABLE, !IS_ID, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
		initEAttribute(getArray2D_NbCols(), ecorePackage.getEInt(), "nbCols", null, 1, 1, Array2D.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_UNSETTABLE, !IS_ID, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

		initEClass(irTypeEClass, IrType.class, "IrType", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);

		initEClass(connectivityTypeEClass, ConnectivityType.class, "ConnectivityType", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
		initEReference(getConnectivityType_Connectivities(), this.getConnectivity(), null, "connectivities", null, 0, -1, ConnectivityType.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_COMPOSITE, IS_RESOLVE_PROXIES, !IS_UNSETTABLE, !IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
		initEReference(getConnectivityType_Base(), this.getBaseType(), null, "base", null, 1, 1, ConnectivityType.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

		// Initialize enums and add enum literals
		initEEnum(primitiveTypeEEnum, PrimitiveType.class, "PrimitiveType");
		addEEnumLiteral(primitiveTypeEEnum, PrimitiveType.INT);
		addEEnumLiteral(primitiveTypeEEnum, PrimitiveType.REAL);
		addEEnumLiteral(primitiveTypeEEnum, PrimitiveType.BOOL);

		// Create resource
		createResource(eNS_URI);
	}

} //IrPackageImpl
