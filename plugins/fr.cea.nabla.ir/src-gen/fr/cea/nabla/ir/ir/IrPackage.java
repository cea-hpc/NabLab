/**
 */
package fr.cea.nabla.ir.ir;

import org.eclipse.emf.ecore.EAttribute;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EEnum;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.emf.ecore.EReference;

/**
 * <!-- begin-user-doc -->
 * The <b>Package</b> for the model.
 * It contains accessors for the meta objects to represent
 * <ul>
 *   <li>each class,</li>
 *   <li>each feature of each class,</li>
 *   <li>each operation of each class,</li>
 *   <li>each enum,</li>
 *   <li>and each data type</li>
 * </ul>
 * <!-- end-user-doc -->
 * @see fr.cea.nabla.ir.ir.IrFactory
 * @model kind="package"
 * @generated
 */
public interface IrPackage extends EPackage {
	/**
	 * The package name.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	String eNAME = "ir";

	/**
	 * The package namespace URI.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	String eNS_URI = "http://www.cea.fr/nabla/ir";

	/**
	 * The package namespace name.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	String eNS_PREFIX = "ir";

	/**
	 * The singleton instance of the package.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	IrPackage eINSTANCE = fr.cea.nabla.ir.ir.impl.IrPackageImpl.init();

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.IrAnnotableImpl <em>Annotable</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.IrAnnotableImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getIrAnnotable()
	 * @generated
	 */
	int IR_ANNOTABLE = 0;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IR_ANNOTABLE__ANNOTATIONS = 0;

	/**
	 * The number of structural features of the '<em>Annotable</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IR_ANNOTABLE_FEATURE_COUNT = 1;

	/**
	 * The number of operations of the '<em>Annotable</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IR_ANNOTABLE_OPERATION_COUNT = 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.IrAnnotationImpl <em>Annotation</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.IrAnnotationImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getIrAnnotation()
	 * @generated
	 */
	int IR_ANNOTATION = 1;

	/**
	 * The feature id for the '<em><b>Source</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IR_ANNOTATION__SOURCE = 0;

	/**
	 * The feature id for the '<em><b>Details</b></em>' map.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IR_ANNOTATION__DETAILS = 1;

	/**
	 * The number of structural features of the '<em>Annotation</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IR_ANNOTATION_FEATURE_COUNT = 2;

	/**
	 * The number of operations of the '<em>Annotation</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IR_ANNOTATION_OPERATION_COUNT = 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.IrModuleImpl <em>Module</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.IrModuleImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getIrModule()
	 * @generated
	 */
	int IR_MODULE = 2;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IR_MODULE__ANNOTATIONS = IR_ANNOTABLE__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IR_MODULE__NAME = IR_ANNOTABLE_FEATURE_COUNT + 0;

	/**
	 * The feature id for the '<em><b>Imports</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IR_MODULE__IMPORTS = IR_ANNOTABLE_FEATURE_COUNT + 1;

	/**
	 * The feature id for the '<em><b>Items</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IR_MODULE__ITEMS = IR_ANNOTABLE_FEATURE_COUNT + 2;

	/**
	 * The feature id for the '<em><b>Functions</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IR_MODULE__FUNCTIONS = IR_ANNOTABLE_FEATURE_COUNT + 3;

	/**
	 * The feature id for the '<em><b>Reductions</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IR_MODULE__REDUCTIONS = IR_ANNOTABLE_FEATURE_COUNT + 4;

	/**
	 * The feature id for the '<em><b>Connectivities</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IR_MODULE__CONNECTIVITIES = IR_ANNOTABLE_FEATURE_COUNT + 5;

	/**
	 * The feature id for the '<em><b>Variables</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IR_MODULE__VARIABLES = IR_ANNOTABLE_FEATURE_COUNT + 6;

	/**
	 * The feature id for the '<em><b>Init Coord Variable</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IR_MODULE__INIT_COORD_VARIABLE = IR_ANNOTABLE_FEATURE_COUNT + 7;

	/**
	 * The feature id for the '<em><b>Jobs</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IR_MODULE__JOBS = IR_ANNOTABLE_FEATURE_COUNT + 8;

	/**
	 * The number of structural features of the '<em>Module</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IR_MODULE_FEATURE_COUNT = IR_ANNOTABLE_FEATURE_COUNT + 9;

	/**
	 * The number of operations of the '<em>Module</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IR_MODULE_OPERATION_COUNT = IR_ANNOTABLE_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.ImportImpl <em>Import</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.ImportImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getImport()
	 * @generated
	 */
	int IMPORT = 3;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IMPORT__ANNOTATIONS = IR_ANNOTABLE__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Imported Namespace</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IMPORT__IMPORTED_NAMESPACE = IR_ANNOTABLE_FEATURE_COUNT + 0;

	/**
	 * The number of structural features of the '<em>Import</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IMPORT_FEATURE_COUNT = IR_ANNOTABLE_FEATURE_COUNT + 1;

	/**
	 * The number of operations of the '<em>Import</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IMPORT_OPERATION_COUNT = IR_ANNOTABLE_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.ArgOrVarImpl <em>Arg Or Var</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.ArgOrVarImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getArgOrVar()
	 * @generated
	 */
	int ARG_OR_VAR = 4;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ARG_OR_VAR__ANNOTATIONS = IR_ANNOTABLE__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ARG_OR_VAR__NAME = IR_ANNOTABLE_FEATURE_COUNT + 0;

	/**
	 * The number of structural features of the '<em>Arg Or Var</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ARG_OR_VAR_FEATURE_COUNT = IR_ANNOTABLE_FEATURE_COUNT + 1;

	/**
	 * The number of operations of the '<em>Arg Or Var</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ARG_OR_VAR_OPERATION_COUNT = IR_ANNOTABLE_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.ArgImpl <em>Arg</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.ArgImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getArg()
	 * @generated
	 */
	int ARG = 5;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ARG__ANNOTATIONS = ARG_OR_VAR__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ARG__NAME = ARG_OR_VAR__NAME;

	/**
	 * The feature id for the '<em><b>Type</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ARG__TYPE = ARG_OR_VAR_FEATURE_COUNT + 0;

	/**
	 * The number of structural features of the '<em>Arg</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ARG_FEATURE_COUNT = ARG_OR_VAR_FEATURE_COUNT + 1;

	/**
	 * The number of operations of the '<em>Arg</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ARG_OPERATION_COUNT = ARG_OR_VAR_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.VariableImpl <em>Variable</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.VariableImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getVariable()
	 * @generated
	 */
	int VARIABLE = 6;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int VARIABLE__ANNOTATIONS = ARG_OR_VAR__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int VARIABLE__NAME = ARG_OR_VAR__NAME;

	/**
	 * The feature id for the '<em><b>Persistence Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int VARIABLE__PERSISTENCE_NAME = ARG_OR_VAR_FEATURE_COUNT + 0;

	/**
	 * The feature id for the '<em><b>Const</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int VARIABLE__CONST = ARG_OR_VAR_FEATURE_COUNT + 1;

	/**
	 * The number of structural features of the '<em>Variable</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int VARIABLE_FEATURE_COUNT = ARG_OR_VAR_FEATURE_COUNT + 2;

	/**
	 * The number of operations of the '<em>Variable</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int VARIABLE_OPERATION_COUNT = ARG_OR_VAR_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.SimpleVariableImpl <em>Simple Variable</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.SimpleVariableImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getSimpleVariable()
	 * @generated
	 */
	int SIMPLE_VARIABLE = 7;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SIMPLE_VARIABLE__ANNOTATIONS = VARIABLE__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SIMPLE_VARIABLE__NAME = VARIABLE__NAME;

	/**
	 * The feature id for the '<em><b>Persistence Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SIMPLE_VARIABLE__PERSISTENCE_NAME = VARIABLE__PERSISTENCE_NAME;

	/**
	 * The feature id for the '<em><b>Const</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SIMPLE_VARIABLE__CONST = VARIABLE__CONST;

	/**
	 * The feature id for the '<em><b>Type</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SIMPLE_VARIABLE__TYPE = VARIABLE_FEATURE_COUNT + 0;

	/**
	 * The feature id for the '<em><b>Default Value</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SIMPLE_VARIABLE__DEFAULT_VALUE = VARIABLE_FEATURE_COUNT + 1;

	/**
	 * The number of structural features of the '<em>Simple Variable</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SIMPLE_VARIABLE_FEATURE_COUNT = VARIABLE_FEATURE_COUNT + 2;

	/**
	 * The number of operations of the '<em>Simple Variable</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SIMPLE_VARIABLE_OPERATION_COUNT = VARIABLE_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.ConnectivityVariableImpl <em>Connectivity Variable</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.ConnectivityVariableImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getConnectivityVariable()
	 * @generated
	 */
	int CONNECTIVITY_VARIABLE = 8;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONNECTIVITY_VARIABLE__ANNOTATIONS = VARIABLE__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONNECTIVITY_VARIABLE__NAME = VARIABLE__NAME;

	/**
	 * The feature id for the '<em><b>Persistence Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONNECTIVITY_VARIABLE__PERSISTENCE_NAME = VARIABLE__PERSISTENCE_NAME;

	/**
	 * The feature id for the '<em><b>Const</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONNECTIVITY_VARIABLE__CONST = VARIABLE__CONST;

	/**
	 * The feature id for the '<em><b>Type</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONNECTIVITY_VARIABLE__TYPE = VARIABLE_FEATURE_COUNT + 0;

	/**
	 * The feature id for the '<em><b>Default Value</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONNECTIVITY_VARIABLE__DEFAULT_VALUE = VARIABLE_FEATURE_COUNT + 1;

	/**
	 * The number of structural features of the '<em>Connectivity Variable</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONNECTIVITY_VARIABLE_FEATURE_COUNT = VARIABLE_FEATURE_COUNT + 2;

	/**
	 * The number of operations of the '<em>Connectivity Variable</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONNECTIVITY_VARIABLE_OPERATION_COUNT = VARIABLE_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.FunctionImpl <em>Function</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.FunctionImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getFunction()
	 * @generated
	 */
	int FUNCTION = 9;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int FUNCTION__ANNOTATIONS = IR_ANNOTABLE__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Provider</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int FUNCTION__PROVIDER = IR_ANNOTABLE_FEATURE_COUNT + 0;

	/**
	 * The feature id for the '<em><b>Variables</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int FUNCTION__VARIABLES = IR_ANNOTABLE_FEATURE_COUNT + 1;

	/**
	 * The feature id for the '<em><b>Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int FUNCTION__NAME = IR_ANNOTABLE_FEATURE_COUNT + 2;

	/**
	 * The feature id for the '<em><b>In Args</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int FUNCTION__IN_ARGS = IR_ANNOTABLE_FEATURE_COUNT + 3;

	/**
	 * The feature id for the '<em><b>Return Type</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int FUNCTION__RETURN_TYPE = IR_ANNOTABLE_FEATURE_COUNT + 4;

	/**
	 * The feature id for the '<em><b>Body</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int FUNCTION__BODY = IR_ANNOTABLE_FEATURE_COUNT + 5;

	/**
	 * The number of structural features of the '<em>Function</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int FUNCTION_FEATURE_COUNT = IR_ANNOTABLE_FEATURE_COUNT + 6;

	/**
	 * The number of operations of the '<em>Function</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int FUNCTION_OPERATION_COUNT = IR_ANNOTABLE_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.ReductionImpl <em>Reduction</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.ReductionImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getReduction()
	 * @generated
	 */
	int REDUCTION = 10;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int REDUCTION__ANNOTATIONS = IR_ANNOTABLE__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Provider</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int REDUCTION__PROVIDER = IR_ANNOTABLE_FEATURE_COUNT + 0;

	/**
	 * The feature id for the '<em><b>Variables</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int REDUCTION__VARIABLES = IR_ANNOTABLE_FEATURE_COUNT + 1;

	/**
	 * The feature id for the '<em><b>Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int REDUCTION__NAME = IR_ANNOTABLE_FEATURE_COUNT + 2;

	/**
	 * The feature id for the '<em><b>Collection Type</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int REDUCTION__COLLECTION_TYPE = IR_ANNOTABLE_FEATURE_COUNT + 3;

	/**
	 * The feature id for the '<em><b>Return Type</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int REDUCTION__RETURN_TYPE = IR_ANNOTABLE_FEATURE_COUNT + 4;

	/**
	 * The feature id for the '<em><b>Operator</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int REDUCTION__OPERATOR = IR_ANNOTABLE_FEATURE_COUNT + 5;

	/**
	 * The number of structural features of the '<em>Reduction</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int REDUCTION_FEATURE_COUNT = IR_ANNOTABLE_FEATURE_COUNT + 6;

	/**
	 * The number of operations of the '<em>Reduction</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int REDUCTION_OPERATION_COUNT = IR_ANNOTABLE_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.ConnectivityImpl <em>Connectivity</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.ConnectivityImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getConnectivity()
	 * @generated
	 */
	int CONNECTIVITY = 11;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONNECTIVITY__ANNOTATIONS = IR_ANNOTABLE__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONNECTIVITY__NAME = IR_ANNOTABLE_FEATURE_COUNT + 0;

	/**
	 * The feature id for the '<em><b>In Types</b></em>' reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONNECTIVITY__IN_TYPES = IR_ANNOTABLE_FEATURE_COUNT + 1;

	/**
	 * The feature id for the '<em><b>Return Type</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONNECTIVITY__RETURN_TYPE = IR_ANNOTABLE_FEATURE_COUNT + 2;

	/**
	 * The feature id for the '<em><b>Index Equal Id</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONNECTIVITY__INDEX_EQUAL_ID = IR_ANNOTABLE_FEATURE_COUNT + 3;

	/**
	 * The number of structural features of the '<em>Connectivity</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONNECTIVITY_FEATURE_COUNT = IR_ANNOTABLE_FEATURE_COUNT + 4;

	/**
	 * The number of operations of the '<em>Connectivity</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONNECTIVITY_OPERATION_COUNT = IR_ANNOTABLE_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.ItemArgTypeImpl <em>Item Arg Type</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.ItemArgTypeImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getItemArgType()
	 * @generated
	 */
	int ITEM_ARG_TYPE = 12;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITEM_ARG_TYPE__ANNOTATIONS = IR_ANNOTABLE__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Multiple</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITEM_ARG_TYPE__MULTIPLE = IR_ANNOTABLE_FEATURE_COUNT + 0;

	/**
	 * The feature id for the '<em><b>Type</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITEM_ARG_TYPE__TYPE = IR_ANNOTABLE_FEATURE_COUNT + 1;

	/**
	 * The number of structural features of the '<em>Item Arg Type</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITEM_ARG_TYPE_FEATURE_COUNT = IR_ANNOTABLE_FEATURE_COUNT + 2;

	/**
	 * The number of operations of the '<em>Item Arg Type</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITEM_ARG_TYPE_OPERATION_COUNT = IR_ANNOTABLE_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.JobImpl <em>Job</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.JobImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getJob()
	 * @generated
	 */
	int JOB = 13;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int JOB__ANNOTATIONS = IR_ANNOTABLE__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int JOB__NAME = IR_ANNOTABLE_FEATURE_COUNT + 0;

	/**
	 * The feature id for the '<em><b>At</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int JOB__AT = IR_ANNOTABLE_FEATURE_COUNT + 1;

	/**
	 * The feature id for the '<em><b>On Cycle</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int JOB__ON_CYCLE = IR_ANNOTABLE_FEATURE_COUNT + 2;

	/**
	 * The number of structural features of the '<em>Job</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int JOB_FEATURE_COUNT = IR_ANNOTABLE_FEATURE_COUNT + 3;

	/**
	 * The number of operations of the '<em>Job</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int JOB_OPERATION_COUNT = IR_ANNOTABLE_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.InstructionJobImpl <em>Instruction Job</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.InstructionJobImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getInstructionJob()
	 * @generated
	 */
	int INSTRUCTION_JOB = 14;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int INSTRUCTION_JOB__ANNOTATIONS = JOB__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int INSTRUCTION_JOB__NAME = JOB__NAME;

	/**
	 * The feature id for the '<em><b>At</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int INSTRUCTION_JOB__AT = JOB__AT;

	/**
	 * The feature id for the '<em><b>On Cycle</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int INSTRUCTION_JOB__ON_CYCLE = JOB__ON_CYCLE;

	/**
	 * The feature id for the '<em><b>Instruction</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int INSTRUCTION_JOB__INSTRUCTION = JOB_FEATURE_COUNT + 0;

	/**
	 * The number of structural features of the '<em>Instruction Job</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int INSTRUCTION_JOB_FEATURE_COUNT = JOB_FEATURE_COUNT + 1;

	/**
	 * The number of operations of the '<em>Instruction Job</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int INSTRUCTION_JOB_OPERATION_COUNT = JOB_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.InSituJobImpl <em>In Situ Job</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.InSituJobImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getInSituJob()
	 * @generated
	 */
	int IN_SITU_JOB = 15;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IN_SITU_JOB__ANNOTATIONS = JOB__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IN_SITU_JOB__NAME = JOB__NAME;

	/**
	 * The feature id for the '<em><b>At</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IN_SITU_JOB__AT = JOB__AT;

	/**
	 * The feature id for the '<em><b>On Cycle</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IN_SITU_JOB__ON_CYCLE = JOB__ON_CYCLE;

	/**
	 * The feature id for the '<em><b>Variables</b></em>' reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IN_SITU_JOB__VARIABLES = JOB_FEATURE_COUNT + 0;

	/**
	 * The feature id for the '<em><b>Iteration Period</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IN_SITU_JOB__ITERATION_PERIOD = JOB_FEATURE_COUNT + 1;

	/**
	 * The feature id for the '<em><b>Time Step</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IN_SITU_JOB__TIME_STEP = JOB_FEATURE_COUNT + 2;

	/**
	 * The number of structural features of the '<em>In Situ Job</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IN_SITU_JOB_FEATURE_COUNT = JOB_FEATURE_COUNT + 3;

	/**
	 * The number of operations of the '<em>In Situ Job</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IN_SITU_JOB_OPERATION_COUNT = JOB_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.TimeIterationCopyJobImpl <em>Time Iteration Copy Job</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.TimeIterationCopyJobImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getTimeIterationCopyJob()
	 * @generated
	 */
	int TIME_ITERATION_COPY_JOB = 16;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int TIME_ITERATION_COPY_JOB__ANNOTATIONS = JOB__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int TIME_ITERATION_COPY_JOB__NAME = JOB__NAME;

	/**
	 * The feature id for the '<em><b>At</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int TIME_ITERATION_COPY_JOB__AT = JOB__AT;

	/**
	 * The feature id for the '<em><b>On Cycle</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int TIME_ITERATION_COPY_JOB__ON_CYCLE = JOB__ON_CYCLE;

	/**
	 * The feature id for the '<em><b>Left</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int TIME_ITERATION_COPY_JOB__LEFT = JOB_FEATURE_COUNT + 0;

	/**
	 * The feature id for the '<em><b>Right</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int TIME_ITERATION_COPY_JOB__RIGHT = JOB_FEATURE_COUNT + 1;

	/**
	 * The feature id for the '<em><b>Time Iterator Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int TIME_ITERATION_COPY_JOB__TIME_ITERATOR_NAME = JOB_FEATURE_COUNT + 2;

	/**
	 * The number of structural features of the '<em>Time Iteration Copy Job</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int TIME_ITERATION_COPY_JOB_FEATURE_COUNT = JOB_FEATURE_COUNT + 3;

	/**
	 * The number of operations of the '<em>Time Iteration Copy Job</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int TIME_ITERATION_COPY_JOB_OPERATION_COUNT = JOB_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.EndOfTimeLoopJobImpl <em>End Of Time Loop Job</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.EndOfTimeLoopJobImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getEndOfTimeLoopJob()
	 * @generated
	 */
	int END_OF_TIME_LOOP_JOB = 17;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int END_OF_TIME_LOOP_JOB__ANNOTATIONS = TIME_ITERATION_COPY_JOB__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int END_OF_TIME_LOOP_JOB__NAME = TIME_ITERATION_COPY_JOB__NAME;

	/**
	 * The feature id for the '<em><b>At</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int END_OF_TIME_LOOP_JOB__AT = TIME_ITERATION_COPY_JOB__AT;

	/**
	 * The feature id for the '<em><b>On Cycle</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int END_OF_TIME_LOOP_JOB__ON_CYCLE = TIME_ITERATION_COPY_JOB__ON_CYCLE;

	/**
	 * The feature id for the '<em><b>Left</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int END_OF_TIME_LOOP_JOB__LEFT = TIME_ITERATION_COPY_JOB__LEFT;

	/**
	 * The feature id for the '<em><b>Right</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int END_OF_TIME_LOOP_JOB__RIGHT = TIME_ITERATION_COPY_JOB__RIGHT;

	/**
	 * The feature id for the '<em><b>Time Iterator Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int END_OF_TIME_LOOP_JOB__TIME_ITERATOR_NAME = TIME_ITERATION_COPY_JOB__TIME_ITERATOR_NAME;

	/**
	 * The number of structural features of the '<em>End Of Time Loop Job</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int END_OF_TIME_LOOP_JOB_FEATURE_COUNT = TIME_ITERATION_COPY_JOB_FEATURE_COUNT + 0;

	/**
	 * The number of operations of the '<em>End Of Time Loop Job</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int END_OF_TIME_LOOP_JOB_OPERATION_COUNT = TIME_ITERATION_COPY_JOB_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.EndOfInitJobImpl <em>End Of Init Job</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.EndOfInitJobImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getEndOfInitJob()
	 * @generated
	 */
	int END_OF_INIT_JOB = 18;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int END_OF_INIT_JOB__ANNOTATIONS = TIME_ITERATION_COPY_JOB__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int END_OF_INIT_JOB__NAME = TIME_ITERATION_COPY_JOB__NAME;

	/**
	 * The feature id for the '<em><b>At</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int END_OF_INIT_JOB__AT = TIME_ITERATION_COPY_JOB__AT;

	/**
	 * The feature id for the '<em><b>On Cycle</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int END_OF_INIT_JOB__ON_CYCLE = TIME_ITERATION_COPY_JOB__ON_CYCLE;

	/**
	 * The feature id for the '<em><b>Left</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int END_OF_INIT_JOB__LEFT = TIME_ITERATION_COPY_JOB__LEFT;

	/**
	 * The feature id for the '<em><b>Right</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int END_OF_INIT_JOB__RIGHT = TIME_ITERATION_COPY_JOB__RIGHT;

	/**
	 * The feature id for the '<em><b>Time Iterator Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int END_OF_INIT_JOB__TIME_ITERATOR_NAME = TIME_ITERATION_COPY_JOB__TIME_ITERATOR_NAME;

	/**
	 * The number of structural features of the '<em>End Of Init Job</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int END_OF_INIT_JOB_FEATURE_COUNT = TIME_ITERATION_COPY_JOB_FEATURE_COUNT + 0;

	/**
	 * The number of operations of the '<em>End Of Init Job</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int END_OF_INIT_JOB_OPERATION_COUNT = TIME_ITERATION_COPY_JOB_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.InstructionImpl <em>Instruction</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.InstructionImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getInstruction()
	 * @generated
	 */
	int INSTRUCTION = 19;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int INSTRUCTION__ANNOTATIONS = IR_ANNOTABLE__ANNOTATIONS;

	/**
	 * The number of structural features of the '<em>Instruction</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int INSTRUCTION_FEATURE_COUNT = IR_ANNOTABLE_FEATURE_COUNT + 0;

	/**
	 * The number of operations of the '<em>Instruction</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int INSTRUCTION_OPERATION_COUNT = IR_ANNOTABLE_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.VarDefinitionImpl <em>Var Definition</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.VarDefinitionImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getVarDefinition()
	 * @generated
	 */
	int VAR_DEFINITION = 20;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int VAR_DEFINITION__ANNOTATIONS = INSTRUCTION__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Variables</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int VAR_DEFINITION__VARIABLES = INSTRUCTION_FEATURE_COUNT + 0;

	/**
	 * The number of structural features of the '<em>Var Definition</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int VAR_DEFINITION_FEATURE_COUNT = INSTRUCTION_FEATURE_COUNT + 1;

	/**
	 * The number of operations of the '<em>Var Definition</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int VAR_DEFINITION_OPERATION_COUNT = INSTRUCTION_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.InstructionBlockImpl <em>Instruction Block</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.InstructionBlockImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getInstructionBlock()
	 * @generated
	 */
	int INSTRUCTION_BLOCK = 21;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int INSTRUCTION_BLOCK__ANNOTATIONS = INSTRUCTION__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Instructions</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int INSTRUCTION_BLOCK__INSTRUCTIONS = INSTRUCTION_FEATURE_COUNT + 0;

	/**
	 * The number of structural features of the '<em>Instruction Block</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int INSTRUCTION_BLOCK_FEATURE_COUNT = INSTRUCTION_FEATURE_COUNT + 1;

	/**
	 * The number of operations of the '<em>Instruction Block</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int INSTRUCTION_BLOCK_OPERATION_COUNT = INSTRUCTION_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.AffectationImpl <em>Affectation</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.AffectationImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getAffectation()
	 * @generated
	 */
	int AFFECTATION = 22;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int AFFECTATION__ANNOTATIONS = INSTRUCTION__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Left</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int AFFECTATION__LEFT = INSTRUCTION_FEATURE_COUNT + 0;

	/**
	 * The feature id for the '<em><b>Right</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int AFFECTATION__RIGHT = INSTRUCTION_FEATURE_COUNT + 1;

	/**
	 * The number of structural features of the '<em>Affectation</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int AFFECTATION_FEATURE_COUNT = INSTRUCTION_FEATURE_COUNT + 2;

	/**
	 * The number of operations of the '<em>Affectation</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int AFFECTATION_OPERATION_COUNT = INSTRUCTION_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.IterableInstructionImpl <em>Iterable Instruction</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.IterableInstructionImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getIterableInstruction()
	 * @generated
	 */
	int ITERABLE_INSTRUCTION = 23;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITERABLE_INSTRUCTION__ANNOTATIONS = INSTRUCTION__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Iteration Block</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITERABLE_INSTRUCTION__ITERATION_BLOCK = INSTRUCTION_FEATURE_COUNT + 0;

	/**
	 * The number of structural features of the '<em>Iterable Instruction</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITERABLE_INSTRUCTION_FEATURE_COUNT = INSTRUCTION_FEATURE_COUNT + 1;

	/**
	 * The number of operations of the '<em>Iterable Instruction</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITERABLE_INSTRUCTION_OPERATION_COUNT = INSTRUCTION_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.IterationBlockImpl <em>Iteration Block</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.IterationBlockImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getIterationBlock()
	 * @generated
	 */
	int ITERATION_BLOCK = 24;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITERATION_BLOCK__ANNOTATIONS = IR_ANNOTABLE__ANNOTATIONS;

	/**
	 * The number of structural features of the '<em>Iteration Block</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITERATION_BLOCK_FEATURE_COUNT = IR_ANNOTABLE_FEATURE_COUNT + 0;

	/**
	 * The number of operations of the '<em>Iteration Block</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITERATION_BLOCK_OPERATION_COUNT = IR_ANNOTABLE_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.SpaceIterationBlockImpl <em>Space Iteration Block</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.SpaceIterationBlockImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getSpaceIterationBlock()
	 * @generated
	 */
	int SPACE_ITERATION_BLOCK = 25;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SPACE_ITERATION_BLOCK__ANNOTATIONS = ITERATION_BLOCK__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Range</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SPACE_ITERATION_BLOCK__RANGE = ITERATION_BLOCK_FEATURE_COUNT + 0;

	/**
	 * The feature id for the '<em><b>Singletons</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SPACE_ITERATION_BLOCK__SINGLETONS = ITERATION_BLOCK_FEATURE_COUNT + 1;

	/**
	 * The number of structural features of the '<em>Space Iteration Block</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SPACE_ITERATION_BLOCK_FEATURE_COUNT = ITERATION_BLOCK_FEATURE_COUNT + 2;

	/**
	 * The number of operations of the '<em>Space Iteration Block</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SPACE_ITERATION_BLOCK_OPERATION_COUNT = ITERATION_BLOCK_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.IntervalIterationBlockImpl <em>Interval Iteration Block</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.IntervalIterationBlockImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getIntervalIterationBlock()
	 * @generated
	 */
	int INTERVAL_ITERATION_BLOCK = 26;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int INTERVAL_ITERATION_BLOCK__ANNOTATIONS = ITERATION_BLOCK__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Index</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int INTERVAL_ITERATION_BLOCK__INDEX = ITERATION_BLOCK_FEATURE_COUNT + 0;

	/**
	 * The feature id for the '<em><b>From</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int INTERVAL_ITERATION_BLOCK__FROM = ITERATION_BLOCK_FEATURE_COUNT + 1;

	/**
	 * The feature id for the '<em><b>To</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int INTERVAL_ITERATION_BLOCK__TO = ITERATION_BLOCK_FEATURE_COUNT + 2;

	/**
	 * The feature id for the '<em><b>To Included</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int INTERVAL_ITERATION_BLOCK__TO_INCLUDED = ITERATION_BLOCK_FEATURE_COUNT + 3;

	/**
	 * The number of structural features of the '<em>Interval Iteration Block</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int INTERVAL_ITERATION_BLOCK_FEATURE_COUNT = ITERATION_BLOCK_FEATURE_COUNT + 4;

	/**
	 * The number of operations of the '<em>Interval Iteration Block</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int INTERVAL_ITERATION_BLOCK_OPERATION_COUNT = ITERATION_BLOCK_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.SizeTypeSymbolImpl <em>Size Type Symbol</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.SizeTypeSymbolImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getSizeTypeSymbol()
	 * @generated
	 */
	int SIZE_TYPE_SYMBOL = 27;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SIZE_TYPE_SYMBOL__ANNOTATIONS = IR_ANNOTABLE__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SIZE_TYPE_SYMBOL__NAME = IR_ANNOTABLE_FEATURE_COUNT + 0;

	/**
	 * The number of structural features of the '<em>Size Type Symbol</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SIZE_TYPE_SYMBOL_FEATURE_COUNT = IR_ANNOTABLE_FEATURE_COUNT + 1;

	/**
	 * The number of operations of the '<em>Size Type Symbol</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SIZE_TYPE_SYMBOL_OPERATION_COUNT = IR_ANNOTABLE_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.SizeTypeImpl <em>Size Type</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.SizeTypeImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getSizeType()
	 * @generated
	 */
	int SIZE_TYPE = 28;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SIZE_TYPE__ANNOTATIONS = IR_ANNOTABLE__ANNOTATIONS;

	/**
	 * The number of structural features of the '<em>Size Type</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SIZE_TYPE_FEATURE_COUNT = IR_ANNOTABLE_FEATURE_COUNT + 0;

	/**
	 * The number of operations of the '<em>Size Type</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SIZE_TYPE_OPERATION_COUNT = IR_ANNOTABLE_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.SizeTypeIntImpl <em>Size Type Int</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.SizeTypeIntImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getSizeTypeInt()
	 * @generated
	 */
	int SIZE_TYPE_INT = 29;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SIZE_TYPE_INT__ANNOTATIONS = SIZE_TYPE__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Value</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SIZE_TYPE_INT__VALUE = SIZE_TYPE_FEATURE_COUNT + 0;

	/**
	 * The number of structural features of the '<em>Size Type Int</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SIZE_TYPE_INT_FEATURE_COUNT = SIZE_TYPE_FEATURE_COUNT + 1;

	/**
	 * The number of operations of the '<em>Size Type Int</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SIZE_TYPE_INT_OPERATION_COUNT = SIZE_TYPE_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.SizeTypeOperationImpl <em>Size Type Operation</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.SizeTypeOperationImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getSizeTypeOperation()
	 * @generated
	 */
	int SIZE_TYPE_OPERATION = 30;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SIZE_TYPE_OPERATION__ANNOTATIONS = SIZE_TYPE__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Left</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SIZE_TYPE_OPERATION__LEFT = SIZE_TYPE_FEATURE_COUNT + 0;

	/**
	 * The feature id for the '<em><b>Right</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SIZE_TYPE_OPERATION__RIGHT = SIZE_TYPE_FEATURE_COUNT + 1;

	/**
	 * The feature id for the '<em><b>Operator</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SIZE_TYPE_OPERATION__OPERATOR = SIZE_TYPE_FEATURE_COUNT + 2;

	/**
	 * The number of structural features of the '<em>Size Type Operation</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SIZE_TYPE_OPERATION_FEATURE_COUNT = SIZE_TYPE_FEATURE_COUNT + 3;

	/**
	 * The number of operations of the '<em>Size Type Operation</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SIZE_TYPE_OPERATION_OPERATION_COUNT = SIZE_TYPE_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.SizeTypeSymbolRefImpl <em>Size Type Symbol Ref</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.SizeTypeSymbolRefImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getSizeTypeSymbolRef()
	 * @generated
	 */
	int SIZE_TYPE_SYMBOL_REF = 31;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SIZE_TYPE_SYMBOL_REF__ANNOTATIONS = SIZE_TYPE__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Target</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SIZE_TYPE_SYMBOL_REF__TARGET = SIZE_TYPE_FEATURE_COUNT + 0;

	/**
	 * The number of structural features of the '<em>Size Type Symbol Ref</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SIZE_TYPE_SYMBOL_REF_FEATURE_COUNT = SIZE_TYPE_FEATURE_COUNT + 1;

	/**
	 * The number of operations of the '<em>Size Type Symbol Ref</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SIZE_TYPE_SYMBOL_REF_OPERATION_COUNT = SIZE_TYPE_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.ReductionInstructionImpl <em>Reduction Instruction</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.ReductionInstructionImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getReductionInstruction()
	 * @generated
	 */
	int REDUCTION_INSTRUCTION = 32;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int REDUCTION_INSTRUCTION__ANNOTATIONS = ITERABLE_INSTRUCTION__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Iteration Block</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int REDUCTION_INSTRUCTION__ITERATION_BLOCK = ITERABLE_INSTRUCTION__ITERATION_BLOCK;

	/**
	 * The feature id for the '<em><b>Inner Reductions</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int REDUCTION_INSTRUCTION__INNER_REDUCTIONS = ITERABLE_INSTRUCTION_FEATURE_COUNT + 0;

	/**
	 * The feature id for the '<em><b>Reduction</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int REDUCTION_INSTRUCTION__REDUCTION = ITERABLE_INSTRUCTION_FEATURE_COUNT + 1;

	/**
	 * The feature id for the '<em><b>Arg</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int REDUCTION_INSTRUCTION__ARG = ITERABLE_INSTRUCTION_FEATURE_COUNT + 2;

	/**
	 * The feature id for the '<em><b>Result</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int REDUCTION_INSTRUCTION__RESULT = ITERABLE_INSTRUCTION_FEATURE_COUNT + 3;

	/**
	 * The number of structural features of the '<em>Reduction Instruction</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int REDUCTION_INSTRUCTION_FEATURE_COUNT = ITERABLE_INSTRUCTION_FEATURE_COUNT + 4;

	/**
	 * The number of operations of the '<em>Reduction Instruction</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int REDUCTION_INSTRUCTION_OPERATION_COUNT = ITERABLE_INSTRUCTION_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.LoopImpl <em>Loop</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.LoopImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getLoop()
	 * @generated
	 */
	int LOOP = 33;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int LOOP__ANNOTATIONS = ITERABLE_INSTRUCTION__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Iteration Block</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int LOOP__ITERATION_BLOCK = ITERABLE_INSTRUCTION__ITERATION_BLOCK;

	/**
	 * The feature id for the '<em><b>Body</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int LOOP__BODY = ITERABLE_INSTRUCTION_FEATURE_COUNT + 0;

	/**
	 * The number of structural features of the '<em>Loop</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int LOOP_FEATURE_COUNT = ITERABLE_INSTRUCTION_FEATURE_COUNT + 1;

	/**
	 * The number of operations of the '<em>Loop</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int LOOP_OPERATION_COUNT = ITERABLE_INSTRUCTION_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.IfImpl <em>If</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.IfImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getIf()
	 * @generated
	 */
	int IF = 34;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IF__ANNOTATIONS = INSTRUCTION__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Condition</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IF__CONDITION = INSTRUCTION_FEATURE_COUNT + 0;

	/**
	 * The feature id for the '<em><b>Then Instruction</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IF__THEN_INSTRUCTION = INSTRUCTION_FEATURE_COUNT + 1;

	/**
	 * The feature id for the '<em><b>Else Instruction</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IF__ELSE_INSTRUCTION = INSTRUCTION_FEATURE_COUNT + 2;

	/**
	 * The number of structural features of the '<em>If</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IF_FEATURE_COUNT = INSTRUCTION_FEATURE_COUNT + 3;

	/**
	 * The number of operations of the '<em>If</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IF_OPERATION_COUNT = INSTRUCTION_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.ReturnImpl <em>Return</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.ReturnImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getReturn()
	 * @generated
	 */
	int RETURN = 35;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int RETURN__ANNOTATIONS = INSTRUCTION__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Expression</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int RETURN__EXPRESSION = INSTRUCTION_FEATURE_COUNT + 0;

	/**
	 * The number of structural features of the '<em>Return</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int RETURN_FEATURE_COUNT = INSTRUCTION_FEATURE_COUNT + 1;

	/**
	 * The number of operations of the '<em>Return</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int RETURN_OPERATION_COUNT = INSTRUCTION_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.ExpressionImpl <em>Expression</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.ExpressionImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getExpression()
	 * @generated
	 */
	int EXPRESSION = 36;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int EXPRESSION__ANNOTATIONS = IR_ANNOTABLE__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Type</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int EXPRESSION__TYPE = IR_ANNOTABLE_FEATURE_COUNT + 0;

	/**
	 * The number of structural features of the '<em>Expression</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int EXPRESSION_FEATURE_COUNT = IR_ANNOTABLE_FEATURE_COUNT + 1;

	/**
	 * The number of operations of the '<em>Expression</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int EXPRESSION_OPERATION_COUNT = IR_ANNOTABLE_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.ContractedIfImpl <em>Contracted If</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.ContractedIfImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getContractedIf()
	 * @generated
	 */
	int CONTRACTED_IF = 37;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONTRACTED_IF__ANNOTATIONS = EXPRESSION__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Type</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONTRACTED_IF__TYPE = EXPRESSION__TYPE;

	/**
	 * The feature id for the '<em><b>Condition</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONTRACTED_IF__CONDITION = EXPRESSION_FEATURE_COUNT + 0;

	/**
	 * The feature id for the '<em><b>Then Expression</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONTRACTED_IF__THEN_EXPRESSION = EXPRESSION_FEATURE_COUNT + 1;

	/**
	 * The feature id for the '<em><b>Else Expression</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONTRACTED_IF__ELSE_EXPRESSION = EXPRESSION_FEATURE_COUNT + 2;

	/**
	 * The number of structural features of the '<em>Contracted If</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONTRACTED_IF_FEATURE_COUNT = EXPRESSION_FEATURE_COUNT + 3;

	/**
	 * The number of operations of the '<em>Contracted If</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONTRACTED_IF_OPERATION_COUNT = EXPRESSION_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.BinaryExpressionImpl <em>Binary Expression</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.BinaryExpressionImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getBinaryExpression()
	 * @generated
	 */
	int BINARY_EXPRESSION = 38;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int BINARY_EXPRESSION__ANNOTATIONS = EXPRESSION__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Type</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int BINARY_EXPRESSION__TYPE = EXPRESSION__TYPE;

	/**
	 * The feature id for the '<em><b>Operator</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int BINARY_EXPRESSION__OPERATOR = EXPRESSION_FEATURE_COUNT + 0;

	/**
	 * The feature id for the '<em><b>Left</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int BINARY_EXPRESSION__LEFT = EXPRESSION_FEATURE_COUNT + 1;

	/**
	 * The feature id for the '<em><b>Right</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int BINARY_EXPRESSION__RIGHT = EXPRESSION_FEATURE_COUNT + 2;

	/**
	 * The number of structural features of the '<em>Binary Expression</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int BINARY_EXPRESSION_FEATURE_COUNT = EXPRESSION_FEATURE_COUNT + 3;

	/**
	 * The number of operations of the '<em>Binary Expression</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int BINARY_EXPRESSION_OPERATION_COUNT = EXPRESSION_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.UnaryExpressionImpl <em>Unary Expression</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.UnaryExpressionImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getUnaryExpression()
	 * @generated
	 */
	int UNARY_EXPRESSION = 39;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int UNARY_EXPRESSION__ANNOTATIONS = EXPRESSION__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Type</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int UNARY_EXPRESSION__TYPE = EXPRESSION__TYPE;

	/**
	 * The feature id for the '<em><b>Operator</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int UNARY_EXPRESSION__OPERATOR = EXPRESSION_FEATURE_COUNT + 0;

	/**
	 * The feature id for the '<em><b>Expression</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int UNARY_EXPRESSION__EXPRESSION = EXPRESSION_FEATURE_COUNT + 1;

	/**
	 * The number of structural features of the '<em>Unary Expression</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int UNARY_EXPRESSION_FEATURE_COUNT = EXPRESSION_FEATURE_COUNT + 2;

	/**
	 * The number of operations of the '<em>Unary Expression</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int UNARY_EXPRESSION_OPERATION_COUNT = EXPRESSION_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.ParenthesisImpl <em>Parenthesis</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.ParenthesisImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getParenthesis()
	 * @generated
	 */
	int PARENTHESIS = 40;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int PARENTHESIS__ANNOTATIONS = EXPRESSION__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Type</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int PARENTHESIS__TYPE = EXPRESSION__TYPE;

	/**
	 * The feature id for the '<em><b>Expression</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int PARENTHESIS__EXPRESSION = EXPRESSION_FEATURE_COUNT + 0;

	/**
	 * The number of structural features of the '<em>Parenthesis</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int PARENTHESIS_FEATURE_COUNT = EXPRESSION_FEATURE_COUNT + 1;

	/**
	 * The number of operations of the '<em>Parenthesis</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int PARENTHESIS_OPERATION_COUNT = EXPRESSION_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.IntConstantImpl <em>Int Constant</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.IntConstantImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getIntConstant()
	 * @generated
	 */
	int INT_CONSTANT = 41;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int INT_CONSTANT__ANNOTATIONS = EXPRESSION__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Type</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int INT_CONSTANT__TYPE = EXPRESSION__TYPE;

	/**
	 * The feature id for the '<em><b>Value</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int INT_CONSTANT__VALUE = EXPRESSION_FEATURE_COUNT + 0;

	/**
	 * The number of structural features of the '<em>Int Constant</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int INT_CONSTANT_FEATURE_COUNT = EXPRESSION_FEATURE_COUNT + 1;

	/**
	 * The number of operations of the '<em>Int Constant</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int INT_CONSTANT_OPERATION_COUNT = EXPRESSION_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.RealConstantImpl <em>Real Constant</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.RealConstantImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getRealConstant()
	 * @generated
	 */
	int REAL_CONSTANT = 42;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int REAL_CONSTANT__ANNOTATIONS = EXPRESSION__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Type</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int REAL_CONSTANT__TYPE = EXPRESSION__TYPE;

	/**
	 * The feature id for the '<em><b>Value</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int REAL_CONSTANT__VALUE = EXPRESSION_FEATURE_COUNT + 0;

	/**
	 * The number of structural features of the '<em>Real Constant</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int REAL_CONSTANT_FEATURE_COUNT = EXPRESSION_FEATURE_COUNT + 1;

	/**
	 * The number of operations of the '<em>Real Constant</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int REAL_CONSTANT_OPERATION_COUNT = EXPRESSION_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.BoolConstantImpl <em>Bool Constant</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.BoolConstantImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getBoolConstant()
	 * @generated
	 */
	int BOOL_CONSTANT = 43;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int BOOL_CONSTANT__ANNOTATIONS = EXPRESSION__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Type</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int BOOL_CONSTANT__TYPE = EXPRESSION__TYPE;

	/**
	 * The feature id for the '<em><b>Value</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int BOOL_CONSTANT__VALUE = EXPRESSION_FEATURE_COUNT + 0;

	/**
	 * The number of structural features of the '<em>Bool Constant</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int BOOL_CONSTANT_FEATURE_COUNT = EXPRESSION_FEATURE_COUNT + 1;

	/**
	 * The number of operations of the '<em>Bool Constant</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int BOOL_CONSTANT_OPERATION_COUNT = EXPRESSION_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.MinConstantImpl <em>Min Constant</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.MinConstantImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getMinConstant()
	 * @generated
	 */
	int MIN_CONSTANT = 44;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int MIN_CONSTANT__ANNOTATIONS = EXPRESSION__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Type</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int MIN_CONSTANT__TYPE = EXPRESSION__TYPE;

	/**
	 * The number of structural features of the '<em>Min Constant</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int MIN_CONSTANT_FEATURE_COUNT = EXPRESSION_FEATURE_COUNT + 0;

	/**
	 * The number of operations of the '<em>Min Constant</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int MIN_CONSTANT_OPERATION_COUNT = EXPRESSION_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.MaxConstantImpl <em>Max Constant</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.MaxConstantImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getMaxConstant()
	 * @generated
	 */
	int MAX_CONSTANT = 45;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int MAX_CONSTANT__ANNOTATIONS = EXPRESSION__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Type</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int MAX_CONSTANT__TYPE = EXPRESSION__TYPE;

	/**
	 * The number of structural features of the '<em>Max Constant</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int MAX_CONSTANT_FEATURE_COUNT = EXPRESSION_FEATURE_COUNT + 0;

	/**
	 * The number of operations of the '<em>Max Constant</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int MAX_CONSTANT_OPERATION_COUNT = EXPRESSION_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.BaseTypeConstantImpl <em>Base Type Constant</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.BaseTypeConstantImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getBaseTypeConstant()
	 * @generated
	 */
	int BASE_TYPE_CONSTANT = 46;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int BASE_TYPE_CONSTANT__ANNOTATIONS = EXPRESSION__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Type</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int BASE_TYPE_CONSTANT__TYPE = EXPRESSION__TYPE;

	/**
	 * The feature id for the '<em><b>Value</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int BASE_TYPE_CONSTANT__VALUE = EXPRESSION_FEATURE_COUNT + 0;

	/**
	 * The number of structural features of the '<em>Base Type Constant</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int BASE_TYPE_CONSTANT_FEATURE_COUNT = EXPRESSION_FEATURE_COUNT + 1;

	/**
	 * The number of operations of the '<em>Base Type Constant</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int BASE_TYPE_CONSTANT_OPERATION_COUNT = EXPRESSION_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.VectorConstantImpl <em>Vector Constant</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.VectorConstantImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getVectorConstant()
	 * @generated
	 */
	int VECTOR_CONSTANT = 47;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int VECTOR_CONSTANT__ANNOTATIONS = EXPRESSION__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Type</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int VECTOR_CONSTANT__TYPE = EXPRESSION__TYPE;

	/**
	 * The feature id for the '<em><b>Values</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int VECTOR_CONSTANT__VALUES = EXPRESSION_FEATURE_COUNT + 0;

	/**
	 * The number of structural features of the '<em>Vector Constant</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int VECTOR_CONSTANT_FEATURE_COUNT = EXPRESSION_FEATURE_COUNT + 1;

	/**
	 * The number of operations of the '<em>Vector Constant</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int VECTOR_CONSTANT_OPERATION_COUNT = EXPRESSION_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.FunctionCallImpl <em>Function Call</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.FunctionCallImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getFunctionCall()
	 * @generated
	 */
	int FUNCTION_CALL = 48;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int FUNCTION_CALL__ANNOTATIONS = EXPRESSION__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Type</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int FUNCTION_CALL__TYPE = EXPRESSION__TYPE;

	/**
	 * The feature id for the '<em><b>Function</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int FUNCTION_CALL__FUNCTION = EXPRESSION_FEATURE_COUNT + 0;

	/**
	 * The feature id for the '<em><b>Args</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int FUNCTION_CALL__ARGS = EXPRESSION_FEATURE_COUNT + 1;

	/**
	 * The number of structural features of the '<em>Function Call</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int FUNCTION_CALL_FEATURE_COUNT = EXPRESSION_FEATURE_COUNT + 2;

	/**
	 * The number of operations of the '<em>Function Call</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int FUNCTION_CALL_OPERATION_COUNT = EXPRESSION_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.ArgOrVarRefImpl <em>Arg Or Var Ref</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.ArgOrVarRefImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getArgOrVarRef()
	 * @generated
	 */
	int ARG_OR_VAR_REF = 49;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ARG_OR_VAR_REF__ANNOTATIONS = EXPRESSION__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Type</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ARG_OR_VAR_REF__TYPE = EXPRESSION__TYPE;

	/**
	 * The feature id for the '<em><b>Target</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ARG_OR_VAR_REF__TARGET = EXPRESSION_FEATURE_COUNT + 0;

	/**
	 * The feature id for the '<em><b>Iterators</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ARG_OR_VAR_REF__ITERATORS = EXPRESSION_FEATURE_COUNT + 1;

	/**
	 * The feature id for the '<em><b>Indices</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ARG_OR_VAR_REF__INDICES = EXPRESSION_FEATURE_COUNT + 2;

	/**
	 * The number of structural features of the '<em>Arg Or Var Ref</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ARG_OR_VAR_REF_FEATURE_COUNT = EXPRESSION_FEATURE_COUNT + 3;

	/**
	 * The number of operations of the '<em>Arg Or Var Ref</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ARG_OR_VAR_REF_OPERATION_COUNT = EXPRESSION_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.IteratorImpl <em>Iterator</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.IteratorImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getIterator()
	 * @generated
	 */
	int ITERATOR = 50;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITERATOR__ANNOTATIONS = IR_ANNOTABLE__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITERATOR__NAME = IR_ANNOTABLE_FEATURE_COUNT + 0;

	/**
	 * The feature id for the '<em><b>Container</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITERATOR__CONTAINER = IR_ANNOTABLE_FEATURE_COUNT + 1;

	/**
	 * The feature id for the '<em><b>Singleton</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITERATOR__SINGLETON = IR_ANNOTABLE_FEATURE_COUNT + 2;

	/**
	 * The feature id for the '<em><b>Referencers</b></em>' reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITERATOR__REFERENCERS = IR_ANNOTABLE_FEATURE_COUNT + 3;

	/**
	 * The number of structural features of the '<em>Iterator</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITERATOR_FEATURE_COUNT = IR_ANNOTABLE_FEATURE_COUNT + 4;

	/**
	 * The number of operations of the '<em>Iterator</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITERATOR_OPERATION_COUNT = IR_ANNOTABLE_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.ConnectivityCallImpl <em>Connectivity Call</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.ConnectivityCallImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getConnectivityCall()
	 * @generated
	 */
	int CONNECTIVITY_CALL = 51;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONNECTIVITY_CALL__ANNOTATIONS = IR_ANNOTABLE__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Connectivity</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONNECTIVITY_CALL__CONNECTIVITY = IR_ANNOTABLE_FEATURE_COUNT + 0;

	/**
	 * The feature id for the '<em><b>Args</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONNECTIVITY_CALL__ARGS = IR_ANNOTABLE_FEATURE_COUNT + 1;

	/**
	 * The number of structural features of the '<em>Connectivity Call</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONNECTIVITY_CALL_FEATURE_COUNT = IR_ANNOTABLE_FEATURE_COUNT + 2;

	/**
	 * The number of operations of the '<em>Connectivity Call</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONNECTIVITY_CALL_OPERATION_COUNT = IR_ANNOTABLE_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.IteratorRefImpl <em>Iterator Ref</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.IteratorRefImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getIteratorRef()
	 * @generated
	 */
	int ITERATOR_REF = 52;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITERATOR_REF__ANNOTATIONS = IR_ANNOTABLE__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Target</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITERATOR_REF__TARGET = IR_ANNOTABLE_FEATURE_COUNT + 0;

	/**
	 * The feature id for the '<em><b>Shift</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITERATOR_REF__SHIFT = IR_ANNOTABLE_FEATURE_COUNT + 1;

	/**
	 * The feature id for the '<em><b>Index In Referencer List</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITERATOR_REF__INDEX_IN_REFERENCER_LIST = IR_ANNOTABLE_FEATURE_COUNT + 2;

	/**
	 * The number of structural features of the '<em>Iterator Ref</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITERATOR_REF_FEATURE_COUNT = IR_ANNOTABLE_FEATURE_COUNT + 3;

	/**
	 * The number of operations of the '<em>Iterator Ref</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITERATOR_REF_OPERATION_COUNT = IR_ANNOTABLE_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.ConnectivityCallIteratorRefImpl <em>Connectivity Call Iterator Ref</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.ConnectivityCallIteratorRefImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getConnectivityCallIteratorRef()
	 * @generated
	 */
	int CONNECTIVITY_CALL_ITERATOR_REF = 53;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONNECTIVITY_CALL_ITERATOR_REF__ANNOTATIONS = ITERATOR_REF__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Target</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONNECTIVITY_CALL_ITERATOR_REF__TARGET = ITERATOR_REF__TARGET;

	/**
	 * The feature id for the '<em><b>Shift</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONNECTIVITY_CALL_ITERATOR_REF__SHIFT = ITERATOR_REF__SHIFT;

	/**
	 * The feature id for the '<em><b>Index In Referencer List</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONNECTIVITY_CALL_ITERATOR_REF__INDEX_IN_REFERENCER_LIST = ITERATOR_REF__INDEX_IN_REFERENCER_LIST;

	/**
	 * The feature id for the '<em><b>Referenced By</b></em>' container reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONNECTIVITY_CALL_ITERATOR_REF__REFERENCED_BY = ITERATOR_REF_FEATURE_COUNT + 0;

	/**
	 * The number of structural features of the '<em>Connectivity Call Iterator Ref</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONNECTIVITY_CALL_ITERATOR_REF_FEATURE_COUNT = ITERATOR_REF_FEATURE_COUNT + 1;

	/**
	 * The number of operations of the '<em>Connectivity Call Iterator Ref</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONNECTIVITY_CALL_ITERATOR_REF_OPERATION_COUNT = ITERATOR_REF_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.ArgOrVarRefIteratorRefImpl <em>Arg Or Var Ref Iterator Ref</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.ArgOrVarRefIteratorRefImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getArgOrVarRefIteratorRef()
	 * @generated
	 */
	int ARG_OR_VAR_REF_ITERATOR_REF = 54;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ARG_OR_VAR_REF_ITERATOR_REF__ANNOTATIONS = ITERATOR_REF__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Target</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ARG_OR_VAR_REF_ITERATOR_REF__TARGET = ITERATOR_REF__TARGET;

	/**
	 * The feature id for the '<em><b>Shift</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ARG_OR_VAR_REF_ITERATOR_REF__SHIFT = ITERATOR_REF__SHIFT;

	/**
	 * The feature id for the '<em><b>Index In Referencer List</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ARG_OR_VAR_REF_ITERATOR_REF__INDEX_IN_REFERENCER_LIST = ITERATOR_REF__INDEX_IN_REFERENCER_LIST;

	/**
	 * The feature id for the '<em><b>Referenced By</b></em>' container reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ARG_OR_VAR_REF_ITERATOR_REF__REFERENCED_BY = ITERATOR_REF_FEATURE_COUNT + 0;

	/**
	 * The number of structural features of the '<em>Arg Or Var Ref Iterator Ref</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ARG_OR_VAR_REF_ITERATOR_REF_FEATURE_COUNT = ITERATOR_REF_FEATURE_COUNT + 1;

	/**
	 * The number of operations of the '<em>Arg Or Var Ref Iterator Ref</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ARG_OR_VAR_REF_ITERATOR_REF_OPERATION_COUNT = ITERATOR_REF_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.ItemTypeImpl <em>Item Type</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.ItemTypeImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getItemType()
	 * @generated
	 */
	int ITEM_TYPE = 55;

	/**
	 * The feature id for the '<em><b>Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITEM_TYPE__NAME = 0;

	/**
	 * The number of structural features of the '<em>Item Type</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITEM_TYPE_FEATURE_COUNT = 1;

	/**
	 * The number of operations of the '<em>Item Type</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITEM_TYPE_OPERATION_COUNT = 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.IrTypeImpl <em>Type</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.IrTypeImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getIrType()
	 * @generated
	 */
	int IR_TYPE = 56;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IR_TYPE__ANNOTATIONS = IR_ANNOTABLE__ANNOTATIONS;

	/**
	 * The number of structural features of the '<em>Type</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IR_TYPE_FEATURE_COUNT = IR_ANNOTABLE_FEATURE_COUNT + 0;

	/**
	 * The number of operations of the '<em>Type</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IR_TYPE_OPERATION_COUNT = IR_ANNOTABLE_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.BaseTypeImpl <em>Base Type</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.BaseTypeImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getBaseType()
	 * @generated
	 */
	int BASE_TYPE = 57;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int BASE_TYPE__ANNOTATIONS = IR_TYPE__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Primitive</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int BASE_TYPE__PRIMITIVE = IR_TYPE_FEATURE_COUNT + 0;

	/**
	 * The feature id for the '<em><b>Sizes</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int BASE_TYPE__SIZES = IR_TYPE_FEATURE_COUNT + 1;

	/**
	 * The number of structural features of the '<em>Base Type</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int BASE_TYPE_FEATURE_COUNT = IR_TYPE_FEATURE_COUNT + 2;

	/**
	 * The number of operations of the '<em>Base Type</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int BASE_TYPE_OPERATION_COUNT = IR_TYPE_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.ConnectivityTypeImpl <em>Connectivity Type</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.ConnectivityTypeImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getConnectivityType()
	 * @generated
	 */
	int CONNECTIVITY_TYPE = 58;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONNECTIVITY_TYPE__ANNOTATIONS = IR_TYPE__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Connectivities</b></em>' reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONNECTIVITY_TYPE__CONNECTIVITIES = IR_TYPE_FEATURE_COUNT + 0;

	/**
	 * The feature id for the '<em><b>Base</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONNECTIVITY_TYPE__BASE = IR_TYPE_FEATURE_COUNT + 1;

	/**
	 * The number of structural features of the '<em>Connectivity Type</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONNECTIVITY_TYPE_FEATURE_COUNT = IR_TYPE_FEATURE_COUNT + 2;

	/**
	 * The number of operations of the '<em>Connectivity Type</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONNECTIVITY_TYPE_OPERATION_COUNT = IR_TYPE_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.PrimitiveType <em>Primitive Type</em>}' enum.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.PrimitiveType
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getPrimitiveType()
	 * @generated
	 */
	int PRIMITIVE_TYPE = 59;


	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.IrAnnotable <em>Annotable</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Annotable</em>'.
	 * @see fr.cea.nabla.ir.ir.IrAnnotable
	 * @generated
	 */
	EClass getIrAnnotable();

	/**
	 * Returns the meta object for the containment reference list '{@link fr.cea.nabla.ir.ir.IrAnnotable#getAnnotations <em>Annotations</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference list '<em>Annotations</em>'.
	 * @see fr.cea.nabla.ir.ir.IrAnnotable#getAnnotations()
	 * @see #getIrAnnotable()
	 * @generated
	 */
	EReference getIrAnnotable_Annotations();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.IrAnnotation <em>Annotation</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Annotation</em>'.
	 * @see fr.cea.nabla.ir.ir.IrAnnotation
	 * @generated
	 */
	EClass getIrAnnotation();

	/**
	 * Returns the meta object for the attribute '{@link fr.cea.nabla.ir.ir.IrAnnotation#getSource <em>Source</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Source</em>'.
	 * @see fr.cea.nabla.ir.ir.IrAnnotation#getSource()
	 * @see #getIrAnnotation()
	 * @generated
	 */
	EAttribute getIrAnnotation_Source();

	/**
	 * Returns the meta object for the map '{@link fr.cea.nabla.ir.ir.IrAnnotation#getDetails <em>Details</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the map '<em>Details</em>'.
	 * @see fr.cea.nabla.ir.ir.IrAnnotation#getDetails()
	 * @see #getIrAnnotation()
	 * @generated
	 */
	EReference getIrAnnotation_Details();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.IrModule <em>Module</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Module</em>'.
	 * @see fr.cea.nabla.ir.ir.IrModule
	 * @generated
	 */
	EClass getIrModule();

	/**
	 * Returns the meta object for the attribute '{@link fr.cea.nabla.ir.ir.IrModule#getName <em>Name</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Name</em>'.
	 * @see fr.cea.nabla.ir.ir.IrModule#getName()
	 * @see #getIrModule()
	 * @generated
	 */
	EAttribute getIrModule_Name();

	/**
	 * Returns the meta object for the containment reference list '{@link fr.cea.nabla.ir.ir.IrModule#getImports <em>Imports</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference list '<em>Imports</em>'.
	 * @see fr.cea.nabla.ir.ir.IrModule#getImports()
	 * @see #getIrModule()
	 * @generated
	 */
	EReference getIrModule_Imports();

	/**
	 * Returns the meta object for the containment reference list '{@link fr.cea.nabla.ir.ir.IrModule#getItems <em>Items</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference list '<em>Items</em>'.
	 * @see fr.cea.nabla.ir.ir.IrModule#getItems()
	 * @see #getIrModule()
	 * @generated
	 */
	EReference getIrModule_Items();

	/**
	 * Returns the meta object for the containment reference list '{@link fr.cea.nabla.ir.ir.IrModule#getFunctions <em>Functions</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference list '<em>Functions</em>'.
	 * @see fr.cea.nabla.ir.ir.IrModule#getFunctions()
	 * @see #getIrModule()
	 * @generated
	 */
	EReference getIrModule_Functions();

	/**
	 * Returns the meta object for the containment reference list '{@link fr.cea.nabla.ir.ir.IrModule#getReductions <em>Reductions</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference list '<em>Reductions</em>'.
	 * @see fr.cea.nabla.ir.ir.IrModule#getReductions()
	 * @see #getIrModule()
	 * @generated
	 */
	EReference getIrModule_Reductions();

	/**
	 * Returns the meta object for the containment reference list '{@link fr.cea.nabla.ir.ir.IrModule#getConnectivities <em>Connectivities</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference list '<em>Connectivities</em>'.
	 * @see fr.cea.nabla.ir.ir.IrModule#getConnectivities()
	 * @see #getIrModule()
	 * @generated
	 */
	EReference getIrModule_Connectivities();

	/**
	 * Returns the meta object for the containment reference list '{@link fr.cea.nabla.ir.ir.IrModule#getVariables <em>Variables</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference list '<em>Variables</em>'.
	 * @see fr.cea.nabla.ir.ir.IrModule#getVariables()
	 * @see #getIrModule()
	 * @generated
	 */
	EReference getIrModule_Variables();

	/**
	 * Returns the meta object for the reference '{@link fr.cea.nabla.ir.ir.IrModule#getInitCoordVariable <em>Init Coord Variable</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the reference '<em>Init Coord Variable</em>'.
	 * @see fr.cea.nabla.ir.ir.IrModule#getInitCoordVariable()
	 * @see #getIrModule()
	 * @generated
	 */
	EReference getIrModule_InitCoordVariable();

	/**
	 * Returns the meta object for the containment reference list '{@link fr.cea.nabla.ir.ir.IrModule#getJobs <em>Jobs</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference list '<em>Jobs</em>'.
	 * @see fr.cea.nabla.ir.ir.IrModule#getJobs()
	 * @see #getIrModule()
	 * @generated
	 */
	EReference getIrModule_Jobs();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.Import <em>Import</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Import</em>'.
	 * @see fr.cea.nabla.ir.ir.Import
	 * @generated
	 */
	EClass getImport();

	/**
	 * Returns the meta object for the attribute '{@link fr.cea.nabla.ir.ir.Import#getImportedNamespace <em>Imported Namespace</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Imported Namespace</em>'.
	 * @see fr.cea.nabla.ir.ir.Import#getImportedNamespace()
	 * @see #getImport()
	 * @generated
	 */
	EAttribute getImport_ImportedNamespace();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.ArgOrVar <em>Arg Or Var</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Arg Or Var</em>'.
	 * @see fr.cea.nabla.ir.ir.ArgOrVar
	 * @generated
	 */
	EClass getArgOrVar();

	/**
	 * Returns the meta object for the attribute '{@link fr.cea.nabla.ir.ir.ArgOrVar#getName <em>Name</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Name</em>'.
	 * @see fr.cea.nabla.ir.ir.ArgOrVar#getName()
	 * @see #getArgOrVar()
	 * @generated
	 */
	EAttribute getArgOrVar_Name();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.Arg <em>Arg</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Arg</em>'.
	 * @see fr.cea.nabla.ir.ir.Arg
	 * @generated
	 */
	EClass getArg();

	/**
	 * Returns the meta object for the containment reference '{@link fr.cea.nabla.ir.ir.Arg#getType <em>Type</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>Type</em>'.
	 * @see fr.cea.nabla.ir.ir.Arg#getType()
	 * @see #getArg()
	 * @generated
	 */
	EReference getArg_Type();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.Variable <em>Variable</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Variable</em>'.
	 * @see fr.cea.nabla.ir.ir.Variable
	 * @generated
	 */
	EClass getVariable();

	/**
	 * Returns the meta object for the attribute '{@link fr.cea.nabla.ir.ir.Variable#getPersistenceName <em>Persistence Name</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Persistence Name</em>'.
	 * @see fr.cea.nabla.ir.ir.Variable#getPersistenceName()
	 * @see #getVariable()
	 * @generated
	 */
	EAttribute getVariable_PersistenceName();

	/**
	 * Returns the meta object for the attribute '{@link fr.cea.nabla.ir.ir.Variable#isConst <em>Const</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Const</em>'.
	 * @see fr.cea.nabla.ir.ir.Variable#isConst()
	 * @see #getVariable()
	 * @generated
	 */
	EAttribute getVariable_Const();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.SimpleVariable <em>Simple Variable</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Simple Variable</em>'.
	 * @see fr.cea.nabla.ir.ir.SimpleVariable
	 * @generated
	 */
	EClass getSimpleVariable();

	/**
	 * Returns the meta object for the containment reference '{@link fr.cea.nabla.ir.ir.SimpleVariable#getType <em>Type</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>Type</em>'.
	 * @see fr.cea.nabla.ir.ir.SimpleVariable#getType()
	 * @see #getSimpleVariable()
	 * @generated
	 */
	EReference getSimpleVariable_Type();

	/**
	 * Returns the meta object for the containment reference '{@link fr.cea.nabla.ir.ir.SimpleVariable#getDefaultValue <em>Default Value</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>Default Value</em>'.
	 * @see fr.cea.nabla.ir.ir.SimpleVariable#getDefaultValue()
	 * @see #getSimpleVariable()
	 * @generated
	 */
	EReference getSimpleVariable_DefaultValue();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.ConnectivityVariable <em>Connectivity Variable</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Connectivity Variable</em>'.
	 * @see fr.cea.nabla.ir.ir.ConnectivityVariable
	 * @generated
	 */
	EClass getConnectivityVariable();

	/**
	 * Returns the meta object for the containment reference '{@link fr.cea.nabla.ir.ir.ConnectivityVariable#getType <em>Type</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>Type</em>'.
	 * @see fr.cea.nabla.ir.ir.ConnectivityVariable#getType()
	 * @see #getConnectivityVariable()
	 * @generated
	 */
	EReference getConnectivityVariable_Type();

	/**
	 * Returns the meta object for the containment reference '{@link fr.cea.nabla.ir.ir.ConnectivityVariable#getDefaultValue <em>Default Value</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>Default Value</em>'.
	 * @see fr.cea.nabla.ir.ir.ConnectivityVariable#getDefaultValue()
	 * @see #getConnectivityVariable()
	 * @generated
	 */
	EReference getConnectivityVariable_DefaultValue();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.Function <em>Function</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Function</em>'.
	 * @see fr.cea.nabla.ir.ir.Function
	 * @generated
	 */
	EClass getFunction();

	/**
	 * Returns the meta object for the attribute '{@link fr.cea.nabla.ir.ir.Function#getProvider <em>Provider</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Provider</em>'.
	 * @see fr.cea.nabla.ir.ir.Function#getProvider()
	 * @see #getFunction()
	 * @generated
	 */
	EAttribute getFunction_Provider();

	/**
	 * Returns the meta object for the containment reference list '{@link fr.cea.nabla.ir.ir.Function#getVariables <em>Variables</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference list '<em>Variables</em>'.
	 * @see fr.cea.nabla.ir.ir.Function#getVariables()
	 * @see #getFunction()
	 * @generated
	 */
	EReference getFunction_Variables();

	/**
	 * Returns the meta object for the attribute '{@link fr.cea.nabla.ir.ir.Function#getName <em>Name</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Name</em>'.
	 * @see fr.cea.nabla.ir.ir.Function#getName()
	 * @see #getFunction()
	 * @generated
	 */
	EAttribute getFunction_Name();

	/**
	 * Returns the meta object for the containment reference list '{@link fr.cea.nabla.ir.ir.Function#getInArgs <em>In Args</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference list '<em>In Args</em>'.
	 * @see fr.cea.nabla.ir.ir.Function#getInArgs()
	 * @see #getFunction()
	 * @generated
	 */
	EReference getFunction_InArgs();

	/**
	 * Returns the meta object for the containment reference '{@link fr.cea.nabla.ir.ir.Function#getReturnType <em>Return Type</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>Return Type</em>'.
	 * @see fr.cea.nabla.ir.ir.Function#getReturnType()
	 * @see #getFunction()
	 * @generated
	 */
	EReference getFunction_ReturnType();

	/**
	 * Returns the meta object for the containment reference '{@link fr.cea.nabla.ir.ir.Function#getBody <em>Body</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>Body</em>'.
	 * @see fr.cea.nabla.ir.ir.Function#getBody()
	 * @see #getFunction()
	 * @generated
	 */
	EReference getFunction_Body();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.Reduction <em>Reduction</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Reduction</em>'.
	 * @see fr.cea.nabla.ir.ir.Reduction
	 * @generated
	 */
	EClass getReduction();

	/**
	 * Returns the meta object for the attribute '{@link fr.cea.nabla.ir.ir.Reduction#getProvider <em>Provider</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Provider</em>'.
	 * @see fr.cea.nabla.ir.ir.Reduction#getProvider()
	 * @see #getReduction()
	 * @generated
	 */
	EAttribute getReduction_Provider();

	/**
	 * Returns the meta object for the containment reference list '{@link fr.cea.nabla.ir.ir.Reduction#getVariables <em>Variables</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference list '<em>Variables</em>'.
	 * @see fr.cea.nabla.ir.ir.Reduction#getVariables()
	 * @see #getReduction()
	 * @generated
	 */
	EReference getReduction_Variables();

	/**
	 * Returns the meta object for the attribute '{@link fr.cea.nabla.ir.ir.Reduction#getName <em>Name</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Name</em>'.
	 * @see fr.cea.nabla.ir.ir.Reduction#getName()
	 * @see #getReduction()
	 * @generated
	 */
	EAttribute getReduction_Name();

	/**
	 * Returns the meta object for the containment reference '{@link fr.cea.nabla.ir.ir.Reduction#getCollectionType <em>Collection Type</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>Collection Type</em>'.
	 * @see fr.cea.nabla.ir.ir.Reduction#getCollectionType()
	 * @see #getReduction()
	 * @generated
	 */
	EReference getReduction_CollectionType();

	/**
	 * Returns the meta object for the containment reference '{@link fr.cea.nabla.ir.ir.Reduction#getReturnType <em>Return Type</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>Return Type</em>'.
	 * @see fr.cea.nabla.ir.ir.Reduction#getReturnType()
	 * @see #getReduction()
	 * @generated
	 */
	EReference getReduction_ReturnType();

	/**
	 * Returns the meta object for the attribute '{@link fr.cea.nabla.ir.ir.Reduction#isOperator <em>Operator</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Operator</em>'.
	 * @see fr.cea.nabla.ir.ir.Reduction#isOperator()
	 * @see #getReduction()
	 * @generated
	 */
	EAttribute getReduction_Operator();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.Connectivity <em>Connectivity</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Connectivity</em>'.
	 * @see fr.cea.nabla.ir.ir.Connectivity
	 * @generated
	 */
	EClass getConnectivity();

	/**
	 * Returns the meta object for the attribute '{@link fr.cea.nabla.ir.ir.Connectivity#getName <em>Name</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Name</em>'.
	 * @see fr.cea.nabla.ir.ir.Connectivity#getName()
	 * @see #getConnectivity()
	 * @generated
	 */
	EAttribute getConnectivity_Name();

	/**
	 * Returns the meta object for the reference list '{@link fr.cea.nabla.ir.ir.Connectivity#getInTypes <em>In Types</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the reference list '<em>In Types</em>'.
	 * @see fr.cea.nabla.ir.ir.Connectivity#getInTypes()
	 * @see #getConnectivity()
	 * @generated
	 */
	EReference getConnectivity_InTypes();

	/**
	 * Returns the meta object for the containment reference '{@link fr.cea.nabla.ir.ir.Connectivity#getReturnType <em>Return Type</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>Return Type</em>'.
	 * @see fr.cea.nabla.ir.ir.Connectivity#getReturnType()
	 * @see #getConnectivity()
	 * @generated
	 */
	EReference getConnectivity_ReturnType();

	/**
	 * Returns the meta object for the attribute '{@link fr.cea.nabla.ir.ir.Connectivity#isIndexEqualId <em>Index Equal Id</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Index Equal Id</em>'.
	 * @see fr.cea.nabla.ir.ir.Connectivity#isIndexEqualId()
	 * @see #getConnectivity()
	 * @generated
	 */
	EAttribute getConnectivity_IndexEqualId();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.ItemArgType <em>Item Arg Type</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Item Arg Type</em>'.
	 * @see fr.cea.nabla.ir.ir.ItemArgType
	 * @generated
	 */
	EClass getItemArgType();

	/**
	 * Returns the meta object for the attribute '{@link fr.cea.nabla.ir.ir.ItemArgType#isMultiple <em>Multiple</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Multiple</em>'.
	 * @see fr.cea.nabla.ir.ir.ItemArgType#isMultiple()
	 * @see #getItemArgType()
	 * @generated
	 */
	EAttribute getItemArgType_Multiple();

	/**
	 * Returns the meta object for the reference '{@link fr.cea.nabla.ir.ir.ItemArgType#getType <em>Type</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the reference '<em>Type</em>'.
	 * @see fr.cea.nabla.ir.ir.ItemArgType#getType()
	 * @see #getItemArgType()
	 * @generated
	 */
	EReference getItemArgType_Type();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.Job <em>Job</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Job</em>'.
	 * @see fr.cea.nabla.ir.ir.Job
	 * @generated
	 */
	EClass getJob();

	/**
	 * Returns the meta object for the attribute '{@link fr.cea.nabla.ir.ir.Job#getName <em>Name</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Name</em>'.
	 * @see fr.cea.nabla.ir.ir.Job#getName()
	 * @see #getJob()
	 * @generated
	 */
	EAttribute getJob_Name();

	/**
	 * Returns the meta object for the attribute '{@link fr.cea.nabla.ir.ir.Job#getAt <em>At</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>At</em>'.
	 * @see fr.cea.nabla.ir.ir.Job#getAt()
	 * @see #getJob()
	 * @generated
	 */
	EAttribute getJob_At();

	/**
	 * Returns the meta object for the attribute '{@link fr.cea.nabla.ir.ir.Job#isOnCycle <em>On Cycle</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>On Cycle</em>'.
	 * @see fr.cea.nabla.ir.ir.Job#isOnCycle()
	 * @see #getJob()
	 * @generated
	 */
	EAttribute getJob_OnCycle();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.InstructionJob <em>Instruction Job</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Instruction Job</em>'.
	 * @see fr.cea.nabla.ir.ir.InstructionJob
	 * @generated
	 */
	EClass getInstructionJob();

	/**
	 * Returns the meta object for the containment reference '{@link fr.cea.nabla.ir.ir.InstructionJob#getInstruction <em>Instruction</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>Instruction</em>'.
	 * @see fr.cea.nabla.ir.ir.InstructionJob#getInstruction()
	 * @see #getInstructionJob()
	 * @generated
	 */
	EReference getInstructionJob_Instruction();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.InSituJob <em>In Situ Job</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>In Situ Job</em>'.
	 * @see fr.cea.nabla.ir.ir.InSituJob
	 * @generated
	 */
	EClass getInSituJob();

	/**
	 * Returns the meta object for the reference list '{@link fr.cea.nabla.ir.ir.InSituJob#getVariables <em>Variables</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the reference list '<em>Variables</em>'.
	 * @see fr.cea.nabla.ir.ir.InSituJob#getVariables()
	 * @see #getInSituJob()
	 * @generated
	 */
	EReference getInSituJob_Variables();

	/**
	 * Returns the meta object for the attribute '{@link fr.cea.nabla.ir.ir.InSituJob#getIterationPeriod <em>Iteration Period</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Iteration Period</em>'.
	 * @see fr.cea.nabla.ir.ir.InSituJob#getIterationPeriod()
	 * @see #getInSituJob()
	 * @generated
	 */
	EAttribute getInSituJob_IterationPeriod();

	/**
	 * Returns the meta object for the attribute '{@link fr.cea.nabla.ir.ir.InSituJob#getTimeStep <em>Time Step</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Time Step</em>'.
	 * @see fr.cea.nabla.ir.ir.InSituJob#getTimeStep()
	 * @see #getInSituJob()
	 * @generated
	 */
	EAttribute getInSituJob_TimeStep();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.TimeIterationCopyJob <em>Time Iteration Copy Job</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Time Iteration Copy Job</em>'.
	 * @see fr.cea.nabla.ir.ir.TimeIterationCopyJob
	 * @generated
	 */
	EClass getTimeIterationCopyJob();

	/**
	 * Returns the meta object for the reference '{@link fr.cea.nabla.ir.ir.TimeIterationCopyJob#getLeft <em>Left</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the reference '<em>Left</em>'.
	 * @see fr.cea.nabla.ir.ir.TimeIterationCopyJob#getLeft()
	 * @see #getTimeIterationCopyJob()
	 * @generated
	 */
	EReference getTimeIterationCopyJob_Left();

	/**
	 * Returns the meta object for the reference '{@link fr.cea.nabla.ir.ir.TimeIterationCopyJob#getRight <em>Right</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the reference '<em>Right</em>'.
	 * @see fr.cea.nabla.ir.ir.TimeIterationCopyJob#getRight()
	 * @see #getTimeIterationCopyJob()
	 * @generated
	 */
	EReference getTimeIterationCopyJob_Right();

	/**
	 * Returns the meta object for the attribute '{@link fr.cea.nabla.ir.ir.TimeIterationCopyJob#getTimeIteratorName <em>Time Iterator Name</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Time Iterator Name</em>'.
	 * @see fr.cea.nabla.ir.ir.TimeIterationCopyJob#getTimeIteratorName()
	 * @see #getTimeIterationCopyJob()
	 * @generated
	 */
	EAttribute getTimeIterationCopyJob_TimeIteratorName();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.EndOfTimeLoopJob <em>End Of Time Loop Job</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>End Of Time Loop Job</em>'.
	 * @see fr.cea.nabla.ir.ir.EndOfTimeLoopJob
	 * @generated
	 */
	EClass getEndOfTimeLoopJob();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.EndOfInitJob <em>End Of Init Job</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>End Of Init Job</em>'.
	 * @see fr.cea.nabla.ir.ir.EndOfInitJob
	 * @generated
	 */
	EClass getEndOfInitJob();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.Instruction <em>Instruction</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Instruction</em>'.
	 * @see fr.cea.nabla.ir.ir.Instruction
	 * @generated
	 */
	EClass getInstruction();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.VarDefinition <em>Var Definition</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Var Definition</em>'.
	 * @see fr.cea.nabla.ir.ir.VarDefinition
	 * @generated
	 */
	EClass getVarDefinition();

	/**
	 * Returns the meta object for the containment reference list '{@link fr.cea.nabla.ir.ir.VarDefinition#getVariables <em>Variables</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference list '<em>Variables</em>'.
	 * @see fr.cea.nabla.ir.ir.VarDefinition#getVariables()
	 * @see #getVarDefinition()
	 * @generated
	 */
	EReference getVarDefinition_Variables();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.InstructionBlock <em>Instruction Block</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Instruction Block</em>'.
	 * @see fr.cea.nabla.ir.ir.InstructionBlock
	 * @generated
	 */
	EClass getInstructionBlock();

	/**
	 * Returns the meta object for the containment reference list '{@link fr.cea.nabla.ir.ir.InstructionBlock#getInstructions <em>Instructions</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference list '<em>Instructions</em>'.
	 * @see fr.cea.nabla.ir.ir.InstructionBlock#getInstructions()
	 * @see #getInstructionBlock()
	 * @generated
	 */
	EReference getInstructionBlock_Instructions();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.Affectation <em>Affectation</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Affectation</em>'.
	 * @see fr.cea.nabla.ir.ir.Affectation
	 * @generated
	 */
	EClass getAffectation();

	/**
	 * Returns the meta object for the containment reference '{@link fr.cea.nabla.ir.ir.Affectation#getLeft <em>Left</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>Left</em>'.
	 * @see fr.cea.nabla.ir.ir.Affectation#getLeft()
	 * @see #getAffectation()
	 * @generated
	 */
	EReference getAffectation_Left();

	/**
	 * Returns the meta object for the containment reference '{@link fr.cea.nabla.ir.ir.Affectation#getRight <em>Right</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>Right</em>'.
	 * @see fr.cea.nabla.ir.ir.Affectation#getRight()
	 * @see #getAffectation()
	 * @generated
	 */
	EReference getAffectation_Right();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.IterableInstruction <em>Iterable Instruction</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Iterable Instruction</em>'.
	 * @see fr.cea.nabla.ir.ir.IterableInstruction
	 * @generated
	 */
	EClass getIterableInstruction();

	/**
	 * Returns the meta object for the containment reference '{@link fr.cea.nabla.ir.ir.IterableInstruction#getIterationBlock <em>Iteration Block</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>Iteration Block</em>'.
	 * @see fr.cea.nabla.ir.ir.IterableInstruction#getIterationBlock()
	 * @see #getIterableInstruction()
	 * @generated
	 */
	EReference getIterableInstruction_IterationBlock();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.IterationBlock <em>Iteration Block</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Iteration Block</em>'.
	 * @see fr.cea.nabla.ir.ir.IterationBlock
	 * @generated
	 */
	EClass getIterationBlock();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.SpaceIterationBlock <em>Space Iteration Block</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Space Iteration Block</em>'.
	 * @see fr.cea.nabla.ir.ir.SpaceIterationBlock
	 * @generated
	 */
	EClass getSpaceIterationBlock();

	/**
	 * Returns the meta object for the containment reference '{@link fr.cea.nabla.ir.ir.SpaceIterationBlock#getRange <em>Range</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>Range</em>'.
	 * @see fr.cea.nabla.ir.ir.SpaceIterationBlock#getRange()
	 * @see #getSpaceIterationBlock()
	 * @generated
	 */
	EReference getSpaceIterationBlock_Range();

	/**
	 * Returns the meta object for the containment reference list '{@link fr.cea.nabla.ir.ir.SpaceIterationBlock#getSingletons <em>Singletons</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference list '<em>Singletons</em>'.
	 * @see fr.cea.nabla.ir.ir.SpaceIterationBlock#getSingletons()
	 * @see #getSpaceIterationBlock()
	 * @generated
	 */
	EReference getSpaceIterationBlock_Singletons();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.IntervalIterationBlock <em>Interval Iteration Block</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Interval Iteration Block</em>'.
	 * @see fr.cea.nabla.ir.ir.IntervalIterationBlock
	 * @generated
	 */
	EClass getIntervalIterationBlock();

	/**
	 * Returns the meta object for the containment reference '{@link fr.cea.nabla.ir.ir.IntervalIterationBlock#getIndex <em>Index</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>Index</em>'.
	 * @see fr.cea.nabla.ir.ir.IntervalIterationBlock#getIndex()
	 * @see #getIntervalIterationBlock()
	 * @generated
	 */
	EReference getIntervalIterationBlock_Index();

	/**
	 * Returns the meta object for the containment reference '{@link fr.cea.nabla.ir.ir.IntervalIterationBlock#getFrom <em>From</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>From</em>'.
	 * @see fr.cea.nabla.ir.ir.IntervalIterationBlock#getFrom()
	 * @see #getIntervalIterationBlock()
	 * @generated
	 */
	EReference getIntervalIterationBlock_From();

	/**
	 * Returns the meta object for the containment reference '{@link fr.cea.nabla.ir.ir.IntervalIterationBlock#getTo <em>To</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>To</em>'.
	 * @see fr.cea.nabla.ir.ir.IntervalIterationBlock#getTo()
	 * @see #getIntervalIterationBlock()
	 * @generated
	 */
	EReference getIntervalIterationBlock_To();

	/**
	 * Returns the meta object for the attribute '{@link fr.cea.nabla.ir.ir.IntervalIterationBlock#isToIncluded <em>To Included</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>To Included</em>'.
	 * @see fr.cea.nabla.ir.ir.IntervalIterationBlock#isToIncluded()
	 * @see #getIntervalIterationBlock()
	 * @generated
	 */
	EAttribute getIntervalIterationBlock_ToIncluded();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.SizeTypeSymbol <em>Size Type Symbol</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Size Type Symbol</em>'.
	 * @see fr.cea.nabla.ir.ir.SizeTypeSymbol
	 * @generated
	 */
	EClass getSizeTypeSymbol();

	/**
	 * Returns the meta object for the attribute '{@link fr.cea.nabla.ir.ir.SizeTypeSymbol#getName <em>Name</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Name</em>'.
	 * @see fr.cea.nabla.ir.ir.SizeTypeSymbol#getName()
	 * @see #getSizeTypeSymbol()
	 * @generated
	 */
	EAttribute getSizeTypeSymbol_Name();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.SizeType <em>Size Type</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Size Type</em>'.
	 * @see fr.cea.nabla.ir.ir.SizeType
	 * @generated
	 */
	EClass getSizeType();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.SizeTypeInt <em>Size Type Int</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Size Type Int</em>'.
	 * @see fr.cea.nabla.ir.ir.SizeTypeInt
	 * @generated
	 */
	EClass getSizeTypeInt();

	/**
	 * Returns the meta object for the attribute '{@link fr.cea.nabla.ir.ir.SizeTypeInt#getValue <em>Value</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Value</em>'.
	 * @see fr.cea.nabla.ir.ir.SizeTypeInt#getValue()
	 * @see #getSizeTypeInt()
	 * @generated
	 */
	EAttribute getSizeTypeInt_Value();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.SizeTypeOperation <em>Size Type Operation</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Size Type Operation</em>'.
	 * @see fr.cea.nabla.ir.ir.SizeTypeOperation
	 * @generated
	 */
	EClass getSizeTypeOperation();

	/**
	 * Returns the meta object for the containment reference '{@link fr.cea.nabla.ir.ir.SizeTypeOperation#getLeft <em>Left</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>Left</em>'.
	 * @see fr.cea.nabla.ir.ir.SizeTypeOperation#getLeft()
	 * @see #getSizeTypeOperation()
	 * @generated
	 */
	EReference getSizeTypeOperation_Left();

	/**
	 * Returns the meta object for the containment reference '{@link fr.cea.nabla.ir.ir.SizeTypeOperation#getRight <em>Right</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>Right</em>'.
	 * @see fr.cea.nabla.ir.ir.SizeTypeOperation#getRight()
	 * @see #getSizeTypeOperation()
	 * @generated
	 */
	EReference getSizeTypeOperation_Right();

	/**
	 * Returns the meta object for the attribute '{@link fr.cea.nabla.ir.ir.SizeTypeOperation#getOperator <em>Operator</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Operator</em>'.
	 * @see fr.cea.nabla.ir.ir.SizeTypeOperation#getOperator()
	 * @see #getSizeTypeOperation()
	 * @generated
	 */
	EAttribute getSizeTypeOperation_Operator();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.SizeTypeSymbolRef <em>Size Type Symbol Ref</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Size Type Symbol Ref</em>'.
	 * @see fr.cea.nabla.ir.ir.SizeTypeSymbolRef
	 * @generated
	 */
	EClass getSizeTypeSymbolRef();

	/**
	 * Returns the meta object for the reference '{@link fr.cea.nabla.ir.ir.SizeTypeSymbolRef#getTarget <em>Target</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the reference '<em>Target</em>'.
	 * @see fr.cea.nabla.ir.ir.SizeTypeSymbolRef#getTarget()
	 * @see #getSizeTypeSymbolRef()
	 * @generated
	 */
	EReference getSizeTypeSymbolRef_Target();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.ReductionInstruction <em>Reduction Instruction</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Reduction Instruction</em>'.
	 * @see fr.cea.nabla.ir.ir.ReductionInstruction
	 * @generated
	 */
	EClass getReductionInstruction();

	/**
	 * Returns the meta object for the containment reference list '{@link fr.cea.nabla.ir.ir.ReductionInstruction#getInnerReductions <em>Inner Reductions</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference list '<em>Inner Reductions</em>'.
	 * @see fr.cea.nabla.ir.ir.ReductionInstruction#getInnerReductions()
	 * @see #getReductionInstruction()
	 * @generated
	 */
	EReference getReductionInstruction_InnerReductions();

	/**
	 * Returns the meta object for the reference '{@link fr.cea.nabla.ir.ir.ReductionInstruction#getReduction <em>Reduction</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the reference '<em>Reduction</em>'.
	 * @see fr.cea.nabla.ir.ir.ReductionInstruction#getReduction()
	 * @see #getReductionInstruction()
	 * @generated
	 */
	EReference getReductionInstruction_Reduction();

	/**
	 * Returns the meta object for the containment reference '{@link fr.cea.nabla.ir.ir.ReductionInstruction#getArg <em>Arg</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>Arg</em>'.
	 * @see fr.cea.nabla.ir.ir.ReductionInstruction#getArg()
	 * @see #getReductionInstruction()
	 * @generated
	 */
	EReference getReductionInstruction_Arg();

	/**
	 * Returns the meta object for the containment reference '{@link fr.cea.nabla.ir.ir.ReductionInstruction#getResult <em>Result</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>Result</em>'.
	 * @see fr.cea.nabla.ir.ir.ReductionInstruction#getResult()
	 * @see #getReductionInstruction()
	 * @generated
	 */
	EReference getReductionInstruction_Result();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.Loop <em>Loop</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Loop</em>'.
	 * @see fr.cea.nabla.ir.ir.Loop
	 * @generated
	 */
	EClass getLoop();

	/**
	 * Returns the meta object for the containment reference '{@link fr.cea.nabla.ir.ir.Loop#getBody <em>Body</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>Body</em>'.
	 * @see fr.cea.nabla.ir.ir.Loop#getBody()
	 * @see #getLoop()
	 * @generated
	 */
	EReference getLoop_Body();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.If <em>If</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>If</em>'.
	 * @see fr.cea.nabla.ir.ir.If
	 * @generated
	 */
	EClass getIf();

	/**
	 * Returns the meta object for the containment reference '{@link fr.cea.nabla.ir.ir.If#getCondition <em>Condition</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>Condition</em>'.
	 * @see fr.cea.nabla.ir.ir.If#getCondition()
	 * @see #getIf()
	 * @generated
	 */
	EReference getIf_Condition();

	/**
	 * Returns the meta object for the containment reference '{@link fr.cea.nabla.ir.ir.If#getThenInstruction <em>Then Instruction</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>Then Instruction</em>'.
	 * @see fr.cea.nabla.ir.ir.If#getThenInstruction()
	 * @see #getIf()
	 * @generated
	 */
	EReference getIf_ThenInstruction();

	/**
	 * Returns the meta object for the containment reference '{@link fr.cea.nabla.ir.ir.If#getElseInstruction <em>Else Instruction</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>Else Instruction</em>'.
	 * @see fr.cea.nabla.ir.ir.If#getElseInstruction()
	 * @see #getIf()
	 * @generated
	 */
	EReference getIf_ElseInstruction();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.Return <em>Return</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Return</em>'.
	 * @see fr.cea.nabla.ir.ir.Return
	 * @generated
	 */
	EClass getReturn();

	/**
	 * Returns the meta object for the containment reference '{@link fr.cea.nabla.ir.ir.Return#getExpression <em>Expression</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>Expression</em>'.
	 * @see fr.cea.nabla.ir.ir.Return#getExpression()
	 * @see #getReturn()
	 * @generated
	 */
	EReference getReturn_Expression();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.Expression <em>Expression</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Expression</em>'.
	 * @see fr.cea.nabla.ir.ir.Expression
	 * @generated
	 */
	EClass getExpression();

	/**
	 * Returns the meta object for the containment reference '{@link fr.cea.nabla.ir.ir.Expression#getType <em>Type</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>Type</em>'.
	 * @see fr.cea.nabla.ir.ir.Expression#getType()
	 * @see #getExpression()
	 * @generated
	 */
	EReference getExpression_Type();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.ContractedIf <em>Contracted If</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Contracted If</em>'.
	 * @see fr.cea.nabla.ir.ir.ContractedIf
	 * @generated
	 */
	EClass getContractedIf();

	/**
	 * Returns the meta object for the containment reference '{@link fr.cea.nabla.ir.ir.ContractedIf#getCondition <em>Condition</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>Condition</em>'.
	 * @see fr.cea.nabla.ir.ir.ContractedIf#getCondition()
	 * @see #getContractedIf()
	 * @generated
	 */
	EReference getContractedIf_Condition();

	/**
	 * Returns the meta object for the containment reference '{@link fr.cea.nabla.ir.ir.ContractedIf#getThenExpression <em>Then Expression</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>Then Expression</em>'.
	 * @see fr.cea.nabla.ir.ir.ContractedIf#getThenExpression()
	 * @see #getContractedIf()
	 * @generated
	 */
	EReference getContractedIf_ThenExpression();

	/**
	 * Returns the meta object for the containment reference '{@link fr.cea.nabla.ir.ir.ContractedIf#getElseExpression <em>Else Expression</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>Else Expression</em>'.
	 * @see fr.cea.nabla.ir.ir.ContractedIf#getElseExpression()
	 * @see #getContractedIf()
	 * @generated
	 */
	EReference getContractedIf_ElseExpression();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.BinaryExpression <em>Binary Expression</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Binary Expression</em>'.
	 * @see fr.cea.nabla.ir.ir.BinaryExpression
	 * @generated
	 */
	EClass getBinaryExpression();

	/**
	 * Returns the meta object for the attribute '{@link fr.cea.nabla.ir.ir.BinaryExpression#getOperator <em>Operator</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Operator</em>'.
	 * @see fr.cea.nabla.ir.ir.BinaryExpression#getOperator()
	 * @see #getBinaryExpression()
	 * @generated
	 */
	EAttribute getBinaryExpression_Operator();

	/**
	 * Returns the meta object for the containment reference '{@link fr.cea.nabla.ir.ir.BinaryExpression#getLeft <em>Left</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>Left</em>'.
	 * @see fr.cea.nabla.ir.ir.BinaryExpression#getLeft()
	 * @see #getBinaryExpression()
	 * @generated
	 */
	EReference getBinaryExpression_Left();

	/**
	 * Returns the meta object for the containment reference '{@link fr.cea.nabla.ir.ir.BinaryExpression#getRight <em>Right</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>Right</em>'.
	 * @see fr.cea.nabla.ir.ir.BinaryExpression#getRight()
	 * @see #getBinaryExpression()
	 * @generated
	 */
	EReference getBinaryExpression_Right();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.UnaryExpression <em>Unary Expression</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Unary Expression</em>'.
	 * @see fr.cea.nabla.ir.ir.UnaryExpression
	 * @generated
	 */
	EClass getUnaryExpression();

	/**
	 * Returns the meta object for the attribute '{@link fr.cea.nabla.ir.ir.UnaryExpression#getOperator <em>Operator</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Operator</em>'.
	 * @see fr.cea.nabla.ir.ir.UnaryExpression#getOperator()
	 * @see #getUnaryExpression()
	 * @generated
	 */
	EAttribute getUnaryExpression_Operator();

	/**
	 * Returns the meta object for the containment reference '{@link fr.cea.nabla.ir.ir.UnaryExpression#getExpression <em>Expression</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>Expression</em>'.
	 * @see fr.cea.nabla.ir.ir.UnaryExpression#getExpression()
	 * @see #getUnaryExpression()
	 * @generated
	 */
	EReference getUnaryExpression_Expression();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.Parenthesis <em>Parenthesis</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Parenthesis</em>'.
	 * @see fr.cea.nabla.ir.ir.Parenthesis
	 * @generated
	 */
	EClass getParenthesis();

	/**
	 * Returns the meta object for the containment reference '{@link fr.cea.nabla.ir.ir.Parenthesis#getExpression <em>Expression</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>Expression</em>'.
	 * @see fr.cea.nabla.ir.ir.Parenthesis#getExpression()
	 * @see #getParenthesis()
	 * @generated
	 */
	EReference getParenthesis_Expression();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.IntConstant <em>Int Constant</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Int Constant</em>'.
	 * @see fr.cea.nabla.ir.ir.IntConstant
	 * @generated
	 */
	EClass getIntConstant();

	/**
	 * Returns the meta object for the attribute '{@link fr.cea.nabla.ir.ir.IntConstant#getValue <em>Value</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Value</em>'.
	 * @see fr.cea.nabla.ir.ir.IntConstant#getValue()
	 * @see #getIntConstant()
	 * @generated
	 */
	EAttribute getIntConstant_Value();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.RealConstant <em>Real Constant</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Real Constant</em>'.
	 * @see fr.cea.nabla.ir.ir.RealConstant
	 * @generated
	 */
	EClass getRealConstant();

	/**
	 * Returns the meta object for the attribute '{@link fr.cea.nabla.ir.ir.RealConstant#getValue <em>Value</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Value</em>'.
	 * @see fr.cea.nabla.ir.ir.RealConstant#getValue()
	 * @see #getRealConstant()
	 * @generated
	 */
	EAttribute getRealConstant_Value();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.BoolConstant <em>Bool Constant</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Bool Constant</em>'.
	 * @see fr.cea.nabla.ir.ir.BoolConstant
	 * @generated
	 */
	EClass getBoolConstant();

	/**
	 * Returns the meta object for the attribute '{@link fr.cea.nabla.ir.ir.BoolConstant#isValue <em>Value</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Value</em>'.
	 * @see fr.cea.nabla.ir.ir.BoolConstant#isValue()
	 * @see #getBoolConstant()
	 * @generated
	 */
	EAttribute getBoolConstant_Value();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.MinConstant <em>Min Constant</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Min Constant</em>'.
	 * @see fr.cea.nabla.ir.ir.MinConstant
	 * @generated
	 */
	EClass getMinConstant();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.MaxConstant <em>Max Constant</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Max Constant</em>'.
	 * @see fr.cea.nabla.ir.ir.MaxConstant
	 * @generated
	 */
	EClass getMaxConstant();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.BaseTypeConstant <em>Base Type Constant</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Base Type Constant</em>'.
	 * @see fr.cea.nabla.ir.ir.BaseTypeConstant
	 * @generated
	 */
	EClass getBaseTypeConstant();

	/**
	 * Returns the meta object for the containment reference '{@link fr.cea.nabla.ir.ir.BaseTypeConstant#getValue <em>Value</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>Value</em>'.
	 * @see fr.cea.nabla.ir.ir.BaseTypeConstant#getValue()
	 * @see #getBaseTypeConstant()
	 * @generated
	 */
	EReference getBaseTypeConstant_Value();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.VectorConstant <em>Vector Constant</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Vector Constant</em>'.
	 * @see fr.cea.nabla.ir.ir.VectorConstant
	 * @generated
	 */
	EClass getVectorConstant();

	/**
	 * Returns the meta object for the containment reference list '{@link fr.cea.nabla.ir.ir.VectorConstant#getValues <em>Values</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference list '<em>Values</em>'.
	 * @see fr.cea.nabla.ir.ir.VectorConstant#getValues()
	 * @see #getVectorConstant()
	 * @generated
	 */
	EReference getVectorConstant_Values();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.FunctionCall <em>Function Call</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Function Call</em>'.
	 * @see fr.cea.nabla.ir.ir.FunctionCall
	 * @generated
	 */
	EClass getFunctionCall();

	/**
	 * Returns the meta object for the reference '{@link fr.cea.nabla.ir.ir.FunctionCall#getFunction <em>Function</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the reference '<em>Function</em>'.
	 * @see fr.cea.nabla.ir.ir.FunctionCall#getFunction()
	 * @see #getFunctionCall()
	 * @generated
	 */
	EReference getFunctionCall_Function();

	/**
	 * Returns the meta object for the containment reference list '{@link fr.cea.nabla.ir.ir.FunctionCall#getArgs <em>Args</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference list '<em>Args</em>'.
	 * @see fr.cea.nabla.ir.ir.FunctionCall#getArgs()
	 * @see #getFunctionCall()
	 * @generated
	 */
	EReference getFunctionCall_Args();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.ArgOrVarRef <em>Arg Or Var Ref</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Arg Or Var Ref</em>'.
	 * @see fr.cea.nabla.ir.ir.ArgOrVarRef
	 * @generated
	 */
	EClass getArgOrVarRef();

	/**
	 * Returns the meta object for the reference '{@link fr.cea.nabla.ir.ir.ArgOrVarRef#getTarget <em>Target</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the reference '<em>Target</em>'.
	 * @see fr.cea.nabla.ir.ir.ArgOrVarRef#getTarget()
	 * @see #getArgOrVarRef()
	 * @generated
	 */
	EReference getArgOrVarRef_Target();

	/**
	 * Returns the meta object for the containment reference list '{@link fr.cea.nabla.ir.ir.ArgOrVarRef#getIterators <em>Iterators</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference list '<em>Iterators</em>'.
	 * @see fr.cea.nabla.ir.ir.ArgOrVarRef#getIterators()
	 * @see #getArgOrVarRef()
	 * @generated
	 */
	EReference getArgOrVarRef_Iterators();

	/**
	 * Returns the meta object for the containment reference list '{@link fr.cea.nabla.ir.ir.ArgOrVarRef#getIndices <em>Indices</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference list '<em>Indices</em>'.
	 * @see fr.cea.nabla.ir.ir.ArgOrVarRef#getIndices()
	 * @see #getArgOrVarRef()
	 * @generated
	 */
	EReference getArgOrVarRef_Indices();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.Iterator <em>Iterator</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Iterator</em>'.
	 * @see fr.cea.nabla.ir.ir.Iterator
	 * @generated
	 */
	EClass getIterator();

	/**
	 * Returns the meta object for the attribute '{@link fr.cea.nabla.ir.ir.Iterator#getName <em>Name</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Name</em>'.
	 * @see fr.cea.nabla.ir.ir.Iterator#getName()
	 * @see #getIterator()
	 * @generated
	 */
	EAttribute getIterator_Name();

	/**
	 * Returns the meta object for the containment reference '{@link fr.cea.nabla.ir.ir.Iterator#getContainer <em>Container</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>Container</em>'.
	 * @see fr.cea.nabla.ir.ir.Iterator#getContainer()
	 * @see #getIterator()
	 * @generated
	 */
	EReference getIterator_Container();

	/**
	 * Returns the meta object for the attribute '{@link fr.cea.nabla.ir.ir.Iterator#isSingleton <em>Singleton</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Singleton</em>'.
	 * @see fr.cea.nabla.ir.ir.Iterator#isSingleton()
	 * @see #getIterator()
	 * @generated
	 */
	EAttribute getIterator_Singleton();

	/**
	 * Returns the meta object for the reference list '{@link fr.cea.nabla.ir.ir.Iterator#getReferencers <em>Referencers</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the reference list '<em>Referencers</em>'.
	 * @see fr.cea.nabla.ir.ir.Iterator#getReferencers()
	 * @see #getIterator()
	 * @generated
	 */
	EReference getIterator_Referencers();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.ConnectivityCall <em>Connectivity Call</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Connectivity Call</em>'.
	 * @see fr.cea.nabla.ir.ir.ConnectivityCall
	 * @generated
	 */
	EClass getConnectivityCall();

	/**
	 * Returns the meta object for the reference '{@link fr.cea.nabla.ir.ir.ConnectivityCall#getConnectivity <em>Connectivity</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the reference '<em>Connectivity</em>'.
	 * @see fr.cea.nabla.ir.ir.ConnectivityCall#getConnectivity()
	 * @see #getConnectivityCall()
	 * @generated
	 */
	EReference getConnectivityCall_Connectivity();

	/**
	 * Returns the meta object for the containment reference list '{@link fr.cea.nabla.ir.ir.ConnectivityCall#getArgs <em>Args</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference list '<em>Args</em>'.
	 * @see fr.cea.nabla.ir.ir.ConnectivityCall#getArgs()
	 * @see #getConnectivityCall()
	 * @generated
	 */
	EReference getConnectivityCall_Args();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.IteratorRef <em>Iterator Ref</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Iterator Ref</em>'.
	 * @see fr.cea.nabla.ir.ir.IteratorRef
	 * @generated
	 */
	EClass getIteratorRef();

	/**
	 * Returns the meta object for the reference '{@link fr.cea.nabla.ir.ir.IteratorRef#getTarget <em>Target</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the reference '<em>Target</em>'.
	 * @see fr.cea.nabla.ir.ir.IteratorRef#getTarget()
	 * @see #getIteratorRef()
	 * @generated
	 */
	EReference getIteratorRef_Target();

	/**
	 * Returns the meta object for the attribute '{@link fr.cea.nabla.ir.ir.IteratorRef#getShift <em>Shift</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Shift</em>'.
	 * @see fr.cea.nabla.ir.ir.IteratorRef#getShift()
	 * @see #getIteratorRef()
	 * @generated
	 */
	EAttribute getIteratorRef_Shift();

	/**
	 * Returns the meta object for the attribute '{@link fr.cea.nabla.ir.ir.IteratorRef#getIndexInReferencerList <em>Index In Referencer List</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Index In Referencer List</em>'.
	 * @see fr.cea.nabla.ir.ir.IteratorRef#getIndexInReferencerList()
	 * @see #getIteratorRef()
	 * @generated
	 */
	EAttribute getIteratorRef_IndexInReferencerList();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.ConnectivityCallIteratorRef <em>Connectivity Call Iterator Ref</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Connectivity Call Iterator Ref</em>'.
	 * @see fr.cea.nabla.ir.ir.ConnectivityCallIteratorRef
	 * @generated
	 */
	EClass getConnectivityCallIteratorRef();

	/**
	 * Returns the meta object for the container reference '{@link fr.cea.nabla.ir.ir.ConnectivityCallIteratorRef#getReferencedBy <em>Referenced By</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the container reference '<em>Referenced By</em>'.
	 * @see fr.cea.nabla.ir.ir.ConnectivityCallIteratorRef#getReferencedBy()
	 * @see #getConnectivityCallIteratorRef()
	 * @generated
	 */
	EReference getConnectivityCallIteratorRef_ReferencedBy();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.ArgOrVarRefIteratorRef <em>Arg Or Var Ref Iterator Ref</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Arg Or Var Ref Iterator Ref</em>'.
	 * @see fr.cea.nabla.ir.ir.ArgOrVarRefIteratorRef
	 * @generated
	 */
	EClass getArgOrVarRefIteratorRef();

	/**
	 * Returns the meta object for the container reference '{@link fr.cea.nabla.ir.ir.ArgOrVarRefIteratorRef#getReferencedBy <em>Referenced By</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the container reference '<em>Referenced By</em>'.
	 * @see fr.cea.nabla.ir.ir.ArgOrVarRefIteratorRef#getReferencedBy()
	 * @see #getArgOrVarRefIteratorRef()
	 * @generated
	 */
	EReference getArgOrVarRefIteratorRef_ReferencedBy();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.ItemType <em>Item Type</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Item Type</em>'.
	 * @see fr.cea.nabla.ir.ir.ItemType
	 * @generated
	 */
	EClass getItemType();

	/**
	 * Returns the meta object for the attribute '{@link fr.cea.nabla.ir.ir.ItemType#getName <em>Name</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Name</em>'.
	 * @see fr.cea.nabla.ir.ir.ItemType#getName()
	 * @see #getItemType()
	 * @generated
	 */
	EAttribute getItemType_Name();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.IrType <em>Type</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Type</em>'.
	 * @see fr.cea.nabla.ir.ir.IrType
	 * @generated
	 */
	EClass getIrType();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.BaseType <em>Base Type</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Base Type</em>'.
	 * @see fr.cea.nabla.ir.ir.BaseType
	 * @generated
	 */
	EClass getBaseType();

	/**
	 * Returns the meta object for the attribute '{@link fr.cea.nabla.ir.ir.BaseType#getPrimitive <em>Primitive</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Primitive</em>'.
	 * @see fr.cea.nabla.ir.ir.BaseType#getPrimitive()
	 * @see #getBaseType()
	 * @generated
	 */
	EAttribute getBaseType_Primitive();

	/**
	 * Returns the meta object for the containment reference list '{@link fr.cea.nabla.ir.ir.BaseType#getSizes <em>Sizes</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference list '<em>Sizes</em>'.
	 * @see fr.cea.nabla.ir.ir.BaseType#getSizes()
	 * @see #getBaseType()
	 * @generated
	 */
	EReference getBaseType_Sizes();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.ConnectivityType <em>Connectivity Type</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Connectivity Type</em>'.
	 * @see fr.cea.nabla.ir.ir.ConnectivityType
	 * @generated
	 */
	EClass getConnectivityType();

	/**
	 * Returns the meta object for the reference list '{@link fr.cea.nabla.ir.ir.ConnectivityType#getConnectivities <em>Connectivities</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the reference list '<em>Connectivities</em>'.
	 * @see fr.cea.nabla.ir.ir.ConnectivityType#getConnectivities()
	 * @see #getConnectivityType()
	 * @generated
	 */
	EReference getConnectivityType_Connectivities();

	/**
	 * Returns the meta object for the containment reference '{@link fr.cea.nabla.ir.ir.ConnectivityType#getBase <em>Base</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>Base</em>'.
	 * @see fr.cea.nabla.ir.ir.ConnectivityType#getBase()
	 * @see #getConnectivityType()
	 * @generated
	 */
	EReference getConnectivityType_Base();

	/**
	 * Returns the meta object for enum '{@link fr.cea.nabla.ir.ir.PrimitiveType <em>Primitive Type</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for enum '<em>Primitive Type</em>'.
	 * @see fr.cea.nabla.ir.ir.PrimitiveType
	 * @generated
	 */
	EEnum getPrimitiveType();

	/**
	 * Returns the factory that creates the instances of the model.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the factory that creates the instances of the model.
	 * @generated
	 */
	IrFactory getIrFactory();

	/**
	 * <!-- begin-user-doc -->
	 * Defines literals for the meta objects that represent
	 * <ul>
	 *   <li>each class,</li>
	 *   <li>each feature of each class,</li>
	 *   <li>each operation of each class,</li>
	 *   <li>each enum,</li>
	 *   <li>and each data type</li>
	 * </ul>
	 * <!-- end-user-doc -->
	 * @generated
	 */
	interface Literals {
		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.IrAnnotableImpl <em>Annotable</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.IrAnnotableImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getIrAnnotable()
		 * @generated
		 */
		EClass IR_ANNOTABLE = eINSTANCE.getIrAnnotable();

		/**
		 * The meta object literal for the '<em><b>Annotations</b></em>' containment reference list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference IR_ANNOTABLE__ANNOTATIONS = eINSTANCE.getIrAnnotable_Annotations();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.IrAnnotationImpl <em>Annotation</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.IrAnnotationImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getIrAnnotation()
		 * @generated
		 */
		EClass IR_ANNOTATION = eINSTANCE.getIrAnnotation();

		/**
		 * The meta object literal for the '<em><b>Source</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute IR_ANNOTATION__SOURCE = eINSTANCE.getIrAnnotation_Source();

		/**
		 * The meta object literal for the '<em><b>Details</b></em>' map feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference IR_ANNOTATION__DETAILS = eINSTANCE.getIrAnnotation_Details();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.IrModuleImpl <em>Module</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.IrModuleImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getIrModule()
		 * @generated
		 */
		EClass IR_MODULE = eINSTANCE.getIrModule();

		/**
		 * The meta object literal for the '<em><b>Name</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute IR_MODULE__NAME = eINSTANCE.getIrModule_Name();

		/**
		 * The meta object literal for the '<em><b>Imports</b></em>' containment reference list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference IR_MODULE__IMPORTS = eINSTANCE.getIrModule_Imports();

		/**
		 * The meta object literal for the '<em><b>Items</b></em>' containment reference list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference IR_MODULE__ITEMS = eINSTANCE.getIrModule_Items();

		/**
		 * The meta object literal for the '<em><b>Functions</b></em>' containment reference list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference IR_MODULE__FUNCTIONS = eINSTANCE.getIrModule_Functions();

		/**
		 * The meta object literal for the '<em><b>Reductions</b></em>' containment reference list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference IR_MODULE__REDUCTIONS = eINSTANCE.getIrModule_Reductions();

		/**
		 * The meta object literal for the '<em><b>Connectivities</b></em>' containment reference list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference IR_MODULE__CONNECTIVITIES = eINSTANCE.getIrModule_Connectivities();

		/**
		 * The meta object literal for the '<em><b>Variables</b></em>' containment reference list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference IR_MODULE__VARIABLES = eINSTANCE.getIrModule_Variables();

		/**
		 * The meta object literal for the '<em><b>Init Coord Variable</b></em>' reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference IR_MODULE__INIT_COORD_VARIABLE = eINSTANCE.getIrModule_InitCoordVariable();

		/**
		 * The meta object literal for the '<em><b>Jobs</b></em>' containment reference list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference IR_MODULE__JOBS = eINSTANCE.getIrModule_Jobs();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.ImportImpl <em>Import</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.ImportImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getImport()
		 * @generated
		 */
		EClass IMPORT = eINSTANCE.getImport();

		/**
		 * The meta object literal for the '<em><b>Imported Namespace</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute IMPORT__IMPORTED_NAMESPACE = eINSTANCE.getImport_ImportedNamespace();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.ArgOrVarImpl <em>Arg Or Var</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.ArgOrVarImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getArgOrVar()
		 * @generated
		 */
		EClass ARG_OR_VAR = eINSTANCE.getArgOrVar();

		/**
		 * The meta object literal for the '<em><b>Name</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute ARG_OR_VAR__NAME = eINSTANCE.getArgOrVar_Name();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.ArgImpl <em>Arg</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.ArgImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getArg()
		 * @generated
		 */
		EClass ARG = eINSTANCE.getArg();

		/**
		 * The meta object literal for the '<em><b>Type</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference ARG__TYPE = eINSTANCE.getArg_Type();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.VariableImpl <em>Variable</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.VariableImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getVariable()
		 * @generated
		 */
		EClass VARIABLE = eINSTANCE.getVariable();

		/**
		 * The meta object literal for the '<em><b>Persistence Name</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute VARIABLE__PERSISTENCE_NAME = eINSTANCE.getVariable_PersistenceName();

		/**
		 * The meta object literal for the '<em><b>Const</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute VARIABLE__CONST = eINSTANCE.getVariable_Const();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.SimpleVariableImpl <em>Simple Variable</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.SimpleVariableImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getSimpleVariable()
		 * @generated
		 */
		EClass SIMPLE_VARIABLE = eINSTANCE.getSimpleVariable();

		/**
		 * The meta object literal for the '<em><b>Type</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference SIMPLE_VARIABLE__TYPE = eINSTANCE.getSimpleVariable_Type();

		/**
		 * The meta object literal for the '<em><b>Default Value</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference SIMPLE_VARIABLE__DEFAULT_VALUE = eINSTANCE.getSimpleVariable_DefaultValue();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.ConnectivityVariableImpl <em>Connectivity Variable</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.ConnectivityVariableImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getConnectivityVariable()
		 * @generated
		 */
		EClass CONNECTIVITY_VARIABLE = eINSTANCE.getConnectivityVariable();

		/**
		 * The meta object literal for the '<em><b>Type</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference CONNECTIVITY_VARIABLE__TYPE = eINSTANCE.getConnectivityVariable_Type();

		/**
		 * The meta object literal for the '<em><b>Default Value</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference CONNECTIVITY_VARIABLE__DEFAULT_VALUE = eINSTANCE.getConnectivityVariable_DefaultValue();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.FunctionImpl <em>Function</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.FunctionImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getFunction()
		 * @generated
		 */
		EClass FUNCTION = eINSTANCE.getFunction();

		/**
		 * The meta object literal for the '<em><b>Provider</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute FUNCTION__PROVIDER = eINSTANCE.getFunction_Provider();

		/**
		 * The meta object literal for the '<em><b>Variables</b></em>' containment reference list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference FUNCTION__VARIABLES = eINSTANCE.getFunction_Variables();

		/**
		 * The meta object literal for the '<em><b>Name</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute FUNCTION__NAME = eINSTANCE.getFunction_Name();

		/**
		 * The meta object literal for the '<em><b>In Args</b></em>' containment reference list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference FUNCTION__IN_ARGS = eINSTANCE.getFunction_InArgs();

		/**
		 * The meta object literal for the '<em><b>Return Type</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference FUNCTION__RETURN_TYPE = eINSTANCE.getFunction_ReturnType();

		/**
		 * The meta object literal for the '<em><b>Body</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference FUNCTION__BODY = eINSTANCE.getFunction_Body();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.ReductionImpl <em>Reduction</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.ReductionImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getReduction()
		 * @generated
		 */
		EClass REDUCTION = eINSTANCE.getReduction();

		/**
		 * The meta object literal for the '<em><b>Provider</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute REDUCTION__PROVIDER = eINSTANCE.getReduction_Provider();

		/**
		 * The meta object literal for the '<em><b>Variables</b></em>' containment reference list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference REDUCTION__VARIABLES = eINSTANCE.getReduction_Variables();

		/**
		 * The meta object literal for the '<em><b>Name</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute REDUCTION__NAME = eINSTANCE.getReduction_Name();

		/**
		 * The meta object literal for the '<em><b>Collection Type</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference REDUCTION__COLLECTION_TYPE = eINSTANCE.getReduction_CollectionType();

		/**
		 * The meta object literal for the '<em><b>Return Type</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference REDUCTION__RETURN_TYPE = eINSTANCE.getReduction_ReturnType();

		/**
		 * The meta object literal for the '<em><b>Operator</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute REDUCTION__OPERATOR = eINSTANCE.getReduction_Operator();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.ConnectivityImpl <em>Connectivity</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.ConnectivityImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getConnectivity()
		 * @generated
		 */
		EClass CONNECTIVITY = eINSTANCE.getConnectivity();

		/**
		 * The meta object literal for the '<em><b>Name</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute CONNECTIVITY__NAME = eINSTANCE.getConnectivity_Name();

		/**
		 * The meta object literal for the '<em><b>In Types</b></em>' reference list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference CONNECTIVITY__IN_TYPES = eINSTANCE.getConnectivity_InTypes();

		/**
		 * The meta object literal for the '<em><b>Return Type</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference CONNECTIVITY__RETURN_TYPE = eINSTANCE.getConnectivity_ReturnType();

		/**
		 * The meta object literal for the '<em><b>Index Equal Id</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute CONNECTIVITY__INDEX_EQUAL_ID = eINSTANCE.getConnectivity_IndexEqualId();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.ItemArgTypeImpl <em>Item Arg Type</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.ItemArgTypeImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getItemArgType()
		 * @generated
		 */
		EClass ITEM_ARG_TYPE = eINSTANCE.getItemArgType();

		/**
		 * The meta object literal for the '<em><b>Multiple</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute ITEM_ARG_TYPE__MULTIPLE = eINSTANCE.getItemArgType_Multiple();

		/**
		 * The meta object literal for the '<em><b>Type</b></em>' reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference ITEM_ARG_TYPE__TYPE = eINSTANCE.getItemArgType_Type();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.JobImpl <em>Job</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.JobImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getJob()
		 * @generated
		 */
		EClass JOB = eINSTANCE.getJob();

		/**
		 * The meta object literal for the '<em><b>Name</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute JOB__NAME = eINSTANCE.getJob_Name();

		/**
		 * The meta object literal for the '<em><b>At</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute JOB__AT = eINSTANCE.getJob_At();

		/**
		 * The meta object literal for the '<em><b>On Cycle</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute JOB__ON_CYCLE = eINSTANCE.getJob_OnCycle();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.InstructionJobImpl <em>Instruction Job</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.InstructionJobImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getInstructionJob()
		 * @generated
		 */
		EClass INSTRUCTION_JOB = eINSTANCE.getInstructionJob();

		/**
		 * The meta object literal for the '<em><b>Instruction</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference INSTRUCTION_JOB__INSTRUCTION = eINSTANCE.getInstructionJob_Instruction();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.InSituJobImpl <em>In Situ Job</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.InSituJobImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getInSituJob()
		 * @generated
		 */
		EClass IN_SITU_JOB = eINSTANCE.getInSituJob();

		/**
		 * The meta object literal for the '<em><b>Variables</b></em>' reference list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference IN_SITU_JOB__VARIABLES = eINSTANCE.getInSituJob_Variables();

		/**
		 * The meta object literal for the '<em><b>Iteration Period</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute IN_SITU_JOB__ITERATION_PERIOD = eINSTANCE.getInSituJob_IterationPeriod();

		/**
		 * The meta object literal for the '<em><b>Time Step</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute IN_SITU_JOB__TIME_STEP = eINSTANCE.getInSituJob_TimeStep();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.TimeIterationCopyJobImpl <em>Time Iteration Copy Job</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.TimeIterationCopyJobImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getTimeIterationCopyJob()
		 * @generated
		 */
		EClass TIME_ITERATION_COPY_JOB = eINSTANCE.getTimeIterationCopyJob();

		/**
		 * The meta object literal for the '<em><b>Left</b></em>' reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference TIME_ITERATION_COPY_JOB__LEFT = eINSTANCE.getTimeIterationCopyJob_Left();

		/**
		 * The meta object literal for the '<em><b>Right</b></em>' reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference TIME_ITERATION_COPY_JOB__RIGHT = eINSTANCE.getTimeIterationCopyJob_Right();

		/**
		 * The meta object literal for the '<em><b>Time Iterator Name</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute TIME_ITERATION_COPY_JOB__TIME_ITERATOR_NAME = eINSTANCE.getTimeIterationCopyJob_TimeIteratorName();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.EndOfTimeLoopJobImpl <em>End Of Time Loop Job</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.EndOfTimeLoopJobImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getEndOfTimeLoopJob()
		 * @generated
		 */
		EClass END_OF_TIME_LOOP_JOB = eINSTANCE.getEndOfTimeLoopJob();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.EndOfInitJobImpl <em>End Of Init Job</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.EndOfInitJobImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getEndOfInitJob()
		 * @generated
		 */
		EClass END_OF_INIT_JOB = eINSTANCE.getEndOfInitJob();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.InstructionImpl <em>Instruction</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.InstructionImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getInstruction()
		 * @generated
		 */
		EClass INSTRUCTION = eINSTANCE.getInstruction();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.VarDefinitionImpl <em>Var Definition</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.VarDefinitionImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getVarDefinition()
		 * @generated
		 */
		EClass VAR_DEFINITION = eINSTANCE.getVarDefinition();

		/**
		 * The meta object literal for the '<em><b>Variables</b></em>' containment reference list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference VAR_DEFINITION__VARIABLES = eINSTANCE.getVarDefinition_Variables();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.InstructionBlockImpl <em>Instruction Block</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.InstructionBlockImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getInstructionBlock()
		 * @generated
		 */
		EClass INSTRUCTION_BLOCK = eINSTANCE.getInstructionBlock();

		/**
		 * The meta object literal for the '<em><b>Instructions</b></em>' containment reference list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference INSTRUCTION_BLOCK__INSTRUCTIONS = eINSTANCE.getInstructionBlock_Instructions();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.AffectationImpl <em>Affectation</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.AffectationImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getAffectation()
		 * @generated
		 */
		EClass AFFECTATION = eINSTANCE.getAffectation();

		/**
		 * The meta object literal for the '<em><b>Left</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference AFFECTATION__LEFT = eINSTANCE.getAffectation_Left();

		/**
		 * The meta object literal for the '<em><b>Right</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference AFFECTATION__RIGHT = eINSTANCE.getAffectation_Right();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.IterableInstructionImpl <em>Iterable Instruction</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.IterableInstructionImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getIterableInstruction()
		 * @generated
		 */
		EClass ITERABLE_INSTRUCTION = eINSTANCE.getIterableInstruction();

		/**
		 * The meta object literal for the '<em><b>Iteration Block</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference ITERABLE_INSTRUCTION__ITERATION_BLOCK = eINSTANCE.getIterableInstruction_IterationBlock();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.IterationBlockImpl <em>Iteration Block</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.IterationBlockImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getIterationBlock()
		 * @generated
		 */
		EClass ITERATION_BLOCK = eINSTANCE.getIterationBlock();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.SpaceIterationBlockImpl <em>Space Iteration Block</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.SpaceIterationBlockImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getSpaceIterationBlock()
		 * @generated
		 */
		EClass SPACE_ITERATION_BLOCK = eINSTANCE.getSpaceIterationBlock();

		/**
		 * The meta object literal for the '<em><b>Range</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference SPACE_ITERATION_BLOCK__RANGE = eINSTANCE.getSpaceIterationBlock_Range();

		/**
		 * The meta object literal for the '<em><b>Singletons</b></em>' containment reference list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference SPACE_ITERATION_BLOCK__SINGLETONS = eINSTANCE.getSpaceIterationBlock_Singletons();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.IntervalIterationBlockImpl <em>Interval Iteration Block</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.IntervalIterationBlockImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getIntervalIterationBlock()
		 * @generated
		 */
		EClass INTERVAL_ITERATION_BLOCK = eINSTANCE.getIntervalIterationBlock();

		/**
		 * The meta object literal for the '<em><b>Index</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference INTERVAL_ITERATION_BLOCK__INDEX = eINSTANCE.getIntervalIterationBlock_Index();

		/**
		 * The meta object literal for the '<em><b>From</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference INTERVAL_ITERATION_BLOCK__FROM = eINSTANCE.getIntervalIterationBlock_From();

		/**
		 * The meta object literal for the '<em><b>To</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference INTERVAL_ITERATION_BLOCK__TO = eINSTANCE.getIntervalIterationBlock_To();

		/**
		 * The meta object literal for the '<em><b>To Included</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute INTERVAL_ITERATION_BLOCK__TO_INCLUDED = eINSTANCE.getIntervalIterationBlock_ToIncluded();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.SizeTypeSymbolImpl <em>Size Type Symbol</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.SizeTypeSymbolImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getSizeTypeSymbol()
		 * @generated
		 */
		EClass SIZE_TYPE_SYMBOL = eINSTANCE.getSizeTypeSymbol();

		/**
		 * The meta object literal for the '<em><b>Name</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute SIZE_TYPE_SYMBOL__NAME = eINSTANCE.getSizeTypeSymbol_Name();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.SizeTypeImpl <em>Size Type</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.SizeTypeImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getSizeType()
		 * @generated
		 */
		EClass SIZE_TYPE = eINSTANCE.getSizeType();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.SizeTypeIntImpl <em>Size Type Int</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.SizeTypeIntImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getSizeTypeInt()
		 * @generated
		 */
		EClass SIZE_TYPE_INT = eINSTANCE.getSizeTypeInt();

		/**
		 * The meta object literal for the '<em><b>Value</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute SIZE_TYPE_INT__VALUE = eINSTANCE.getSizeTypeInt_Value();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.SizeTypeOperationImpl <em>Size Type Operation</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.SizeTypeOperationImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getSizeTypeOperation()
		 * @generated
		 */
		EClass SIZE_TYPE_OPERATION = eINSTANCE.getSizeTypeOperation();

		/**
		 * The meta object literal for the '<em><b>Left</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference SIZE_TYPE_OPERATION__LEFT = eINSTANCE.getSizeTypeOperation_Left();

		/**
		 * The meta object literal for the '<em><b>Right</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference SIZE_TYPE_OPERATION__RIGHT = eINSTANCE.getSizeTypeOperation_Right();

		/**
		 * The meta object literal for the '<em><b>Operator</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute SIZE_TYPE_OPERATION__OPERATOR = eINSTANCE.getSizeTypeOperation_Operator();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.SizeTypeSymbolRefImpl <em>Size Type Symbol Ref</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.SizeTypeSymbolRefImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getSizeTypeSymbolRef()
		 * @generated
		 */
		EClass SIZE_TYPE_SYMBOL_REF = eINSTANCE.getSizeTypeSymbolRef();

		/**
		 * The meta object literal for the '<em><b>Target</b></em>' reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference SIZE_TYPE_SYMBOL_REF__TARGET = eINSTANCE.getSizeTypeSymbolRef_Target();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.ReductionInstructionImpl <em>Reduction Instruction</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.ReductionInstructionImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getReductionInstruction()
		 * @generated
		 */
		EClass REDUCTION_INSTRUCTION = eINSTANCE.getReductionInstruction();

		/**
		 * The meta object literal for the '<em><b>Inner Reductions</b></em>' containment reference list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference REDUCTION_INSTRUCTION__INNER_REDUCTIONS = eINSTANCE.getReductionInstruction_InnerReductions();

		/**
		 * The meta object literal for the '<em><b>Reduction</b></em>' reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference REDUCTION_INSTRUCTION__REDUCTION = eINSTANCE.getReductionInstruction_Reduction();

		/**
		 * The meta object literal for the '<em><b>Arg</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference REDUCTION_INSTRUCTION__ARG = eINSTANCE.getReductionInstruction_Arg();

		/**
		 * The meta object literal for the '<em><b>Result</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference REDUCTION_INSTRUCTION__RESULT = eINSTANCE.getReductionInstruction_Result();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.LoopImpl <em>Loop</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.LoopImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getLoop()
		 * @generated
		 */
		EClass LOOP = eINSTANCE.getLoop();

		/**
		 * The meta object literal for the '<em><b>Body</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference LOOP__BODY = eINSTANCE.getLoop_Body();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.IfImpl <em>If</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.IfImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getIf()
		 * @generated
		 */
		EClass IF = eINSTANCE.getIf();

		/**
		 * The meta object literal for the '<em><b>Condition</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference IF__CONDITION = eINSTANCE.getIf_Condition();

		/**
		 * The meta object literal for the '<em><b>Then Instruction</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference IF__THEN_INSTRUCTION = eINSTANCE.getIf_ThenInstruction();

		/**
		 * The meta object literal for the '<em><b>Else Instruction</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference IF__ELSE_INSTRUCTION = eINSTANCE.getIf_ElseInstruction();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.ReturnImpl <em>Return</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.ReturnImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getReturn()
		 * @generated
		 */
		EClass RETURN = eINSTANCE.getReturn();

		/**
		 * The meta object literal for the '<em><b>Expression</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference RETURN__EXPRESSION = eINSTANCE.getReturn_Expression();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.ExpressionImpl <em>Expression</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.ExpressionImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getExpression()
		 * @generated
		 */
		EClass EXPRESSION = eINSTANCE.getExpression();

		/**
		 * The meta object literal for the '<em><b>Type</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference EXPRESSION__TYPE = eINSTANCE.getExpression_Type();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.ContractedIfImpl <em>Contracted If</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.ContractedIfImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getContractedIf()
		 * @generated
		 */
		EClass CONTRACTED_IF = eINSTANCE.getContractedIf();

		/**
		 * The meta object literal for the '<em><b>Condition</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference CONTRACTED_IF__CONDITION = eINSTANCE.getContractedIf_Condition();

		/**
		 * The meta object literal for the '<em><b>Then Expression</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference CONTRACTED_IF__THEN_EXPRESSION = eINSTANCE.getContractedIf_ThenExpression();

		/**
		 * The meta object literal for the '<em><b>Else Expression</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference CONTRACTED_IF__ELSE_EXPRESSION = eINSTANCE.getContractedIf_ElseExpression();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.BinaryExpressionImpl <em>Binary Expression</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.BinaryExpressionImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getBinaryExpression()
		 * @generated
		 */
		EClass BINARY_EXPRESSION = eINSTANCE.getBinaryExpression();

		/**
		 * The meta object literal for the '<em><b>Operator</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute BINARY_EXPRESSION__OPERATOR = eINSTANCE.getBinaryExpression_Operator();

		/**
		 * The meta object literal for the '<em><b>Left</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference BINARY_EXPRESSION__LEFT = eINSTANCE.getBinaryExpression_Left();

		/**
		 * The meta object literal for the '<em><b>Right</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference BINARY_EXPRESSION__RIGHT = eINSTANCE.getBinaryExpression_Right();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.UnaryExpressionImpl <em>Unary Expression</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.UnaryExpressionImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getUnaryExpression()
		 * @generated
		 */
		EClass UNARY_EXPRESSION = eINSTANCE.getUnaryExpression();

		/**
		 * The meta object literal for the '<em><b>Operator</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute UNARY_EXPRESSION__OPERATOR = eINSTANCE.getUnaryExpression_Operator();

		/**
		 * The meta object literal for the '<em><b>Expression</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference UNARY_EXPRESSION__EXPRESSION = eINSTANCE.getUnaryExpression_Expression();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.ParenthesisImpl <em>Parenthesis</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.ParenthesisImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getParenthesis()
		 * @generated
		 */
		EClass PARENTHESIS = eINSTANCE.getParenthesis();

		/**
		 * The meta object literal for the '<em><b>Expression</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference PARENTHESIS__EXPRESSION = eINSTANCE.getParenthesis_Expression();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.IntConstantImpl <em>Int Constant</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.IntConstantImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getIntConstant()
		 * @generated
		 */
		EClass INT_CONSTANT = eINSTANCE.getIntConstant();

		/**
		 * The meta object literal for the '<em><b>Value</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute INT_CONSTANT__VALUE = eINSTANCE.getIntConstant_Value();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.RealConstantImpl <em>Real Constant</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.RealConstantImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getRealConstant()
		 * @generated
		 */
		EClass REAL_CONSTANT = eINSTANCE.getRealConstant();

		/**
		 * The meta object literal for the '<em><b>Value</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute REAL_CONSTANT__VALUE = eINSTANCE.getRealConstant_Value();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.BoolConstantImpl <em>Bool Constant</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.BoolConstantImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getBoolConstant()
		 * @generated
		 */
		EClass BOOL_CONSTANT = eINSTANCE.getBoolConstant();

		/**
		 * The meta object literal for the '<em><b>Value</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute BOOL_CONSTANT__VALUE = eINSTANCE.getBoolConstant_Value();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.MinConstantImpl <em>Min Constant</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.MinConstantImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getMinConstant()
		 * @generated
		 */
		EClass MIN_CONSTANT = eINSTANCE.getMinConstant();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.MaxConstantImpl <em>Max Constant</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.MaxConstantImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getMaxConstant()
		 * @generated
		 */
		EClass MAX_CONSTANT = eINSTANCE.getMaxConstant();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.BaseTypeConstantImpl <em>Base Type Constant</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.BaseTypeConstantImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getBaseTypeConstant()
		 * @generated
		 */
		EClass BASE_TYPE_CONSTANT = eINSTANCE.getBaseTypeConstant();

		/**
		 * The meta object literal for the '<em><b>Value</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference BASE_TYPE_CONSTANT__VALUE = eINSTANCE.getBaseTypeConstant_Value();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.VectorConstantImpl <em>Vector Constant</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.VectorConstantImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getVectorConstant()
		 * @generated
		 */
		EClass VECTOR_CONSTANT = eINSTANCE.getVectorConstant();

		/**
		 * The meta object literal for the '<em><b>Values</b></em>' containment reference list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference VECTOR_CONSTANT__VALUES = eINSTANCE.getVectorConstant_Values();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.FunctionCallImpl <em>Function Call</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.FunctionCallImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getFunctionCall()
		 * @generated
		 */
		EClass FUNCTION_CALL = eINSTANCE.getFunctionCall();

		/**
		 * The meta object literal for the '<em><b>Function</b></em>' reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference FUNCTION_CALL__FUNCTION = eINSTANCE.getFunctionCall_Function();

		/**
		 * The meta object literal for the '<em><b>Args</b></em>' containment reference list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference FUNCTION_CALL__ARGS = eINSTANCE.getFunctionCall_Args();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.ArgOrVarRefImpl <em>Arg Or Var Ref</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.ArgOrVarRefImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getArgOrVarRef()
		 * @generated
		 */
		EClass ARG_OR_VAR_REF = eINSTANCE.getArgOrVarRef();

		/**
		 * The meta object literal for the '<em><b>Target</b></em>' reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference ARG_OR_VAR_REF__TARGET = eINSTANCE.getArgOrVarRef_Target();

		/**
		 * The meta object literal for the '<em><b>Iterators</b></em>' containment reference list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference ARG_OR_VAR_REF__ITERATORS = eINSTANCE.getArgOrVarRef_Iterators();

		/**
		 * The meta object literal for the '<em><b>Indices</b></em>' containment reference list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference ARG_OR_VAR_REF__INDICES = eINSTANCE.getArgOrVarRef_Indices();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.IteratorImpl <em>Iterator</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.IteratorImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getIterator()
		 * @generated
		 */
		EClass ITERATOR = eINSTANCE.getIterator();

		/**
		 * The meta object literal for the '<em><b>Name</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute ITERATOR__NAME = eINSTANCE.getIterator_Name();

		/**
		 * The meta object literal for the '<em><b>Container</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference ITERATOR__CONTAINER = eINSTANCE.getIterator_Container();

		/**
		 * The meta object literal for the '<em><b>Singleton</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute ITERATOR__SINGLETON = eINSTANCE.getIterator_Singleton();

		/**
		 * The meta object literal for the '<em><b>Referencers</b></em>' reference list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference ITERATOR__REFERENCERS = eINSTANCE.getIterator_Referencers();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.ConnectivityCallImpl <em>Connectivity Call</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.ConnectivityCallImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getConnectivityCall()
		 * @generated
		 */
		EClass CONNECTIVITY_CALL = eINSTANCE.getConnectivityCall();

		/**
		 * The meta object literal for the '<em><b>Connectivity</b></em>' reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference CONNECTIVITY_CALL__CONNECTIVITY = eINSTANCE.getConnectivityCall_Connectivity();

		/**
		 * The meta object literal for the '<em><b>Args</b></em>' containment reference list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference CONNECTIVITY_CALL__ARGS = eINSTANCE.getConnectivityCall_Args();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.IteratorRefImpl <em>Iterator Ref</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.IteratorRefImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getIteratorRef()
		 * @generated
		 */
		EClass ITERATOR_REF = eINSTANCE.getIteratorRef();

		/**
		 * The meta object literal for the '<em><b>Target</b></em>' reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference ITERATOR_REF__TARGET = eINSTANCE.getIteratorRef_Target();

		/**
		 * The meta object literal for the '<em><b>Shift</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute ITERATOR_REF__SHIFT = eINSTANCE.getIteratorRef_Shift();

		/**
		 * The meta object literal for the '<em><b>Index In Referencer List</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute ITERATOR_REF__INDEX_IN_REFERENCER_LIST = eINSTANCE.getIteratorRef_IndexInReferencerList();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.ConnectivityCallIteratorRefImpl <em>Connectivity Call Iterator Ref</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.ConnectivityCallIteratorRefImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getConnectivityCallIteratorRef()
		 * @generated
		 */
		EClass CONNECTIVITY_CALL_ITERATOR_REF = eINSTANCE.getConnectivityCallIteratorRef();

		/**
		 * The meta object literal for the '<em><b>Referenced By</b></em>' container reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference CONNECTIVITY_CALL_ITERATOR_REF__REFERENCED_BY = eINSTANCE.getConnectivityCallIteratorRef_ReferencedBy();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.ArgOrVarRefIteratorRefImpl <em>Arg Or Var Ref Iterator Ref</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.ArgOrVarRefIteratorRefImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getArgOrVarRefIteratorRef()
		 * @generated
		 */
		EClass ARG_OR_VAR_REF_ITERATOR_REF = eINSTANCE.getArgOrVarRefIteratorRef();

		/**
		 * The meta object literal for the '<em><b>Referenced By</b></em>' container reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference ARG_OR_VAR_REF_ITERATOR_REF__REFERENCED_BY = eINSTANCE.getArgOrVarRefIteratorRef_ReferencedBy();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.ItemTypeImpl <em>Item Type</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.ItemTypeImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getItemType()
		 * @generated
		 */
		EClass ITEM_TYPE = eINSTANCE.getItemType();

		/**
		 * The meta object literal for the '<em><b>Name</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute ITEM_TYPE__NAME = eINSTANCE.getItemType_Name();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.IrTypeImpl <em>Type</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.IrTypeImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getIrType()
		 * @generated
		 */
		EClass IR_TYPE = eINSTANCE.getIrType();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.BaseTypeImpl <em>Base Type</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.BaseTypeImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getBaseType()
		 * @generated
		 */
		EClass BASE_TYPE = eINSTANCE.getBaseType();

		/**
		 * The meta object literal for the '<em><b>Primitive</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute BASE_TYPE__PRIMITIVE = eINSTANCE.getBaseType_Primitive();

		/**
		 * The meta object literal for the '<em><b>Sizes</b></em>' containment reference list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference BASE_TYPE__SIZES = eINSTANCE.getBaseType_Sizes();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.ConnectivityTypeImpl <em>Connectivity Type</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.ConnectivityTypeImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getConnectivityType()
		 * @generated
		 */
		EClass CONNECTIVITY_TYPE = eINSTANCE.getConnectivityType();

		/**
		 * The meta object literal for the '<em><b>Connectivities</b></em>' reference list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference CONNECTIVITY_TYPE__CONNECTIVITIES = eINSTANCE.getConnectivityType_Connectivities();

		/**
		 * The meta object literal for the '<em><b>Base</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference CONNECTIVITY_TYPE__BASE = eINSTANCE.getConnectivityType_Base();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.PrimitiveType <em>Primitive Type</em>}' enum.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.PrimitiveType
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getPrimitiveType()
		 * @generated
		 */
		EEnum PRIMITIVE_TYPE = eINSTANCE.getPrimitiveType();

	}

} //IrPackage
