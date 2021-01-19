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
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.IrRootImpl <em>Root</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.IrRootImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getIrRoot()
	 * @generated
	 */
	int IR_ROOT = 2;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IR_ROOT__ANNOTATIONS = IR_ANNOTABLE__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IR_ROOT__NAME = IR_ANNOTABLE_FEATURE_COUNT + 0;

	/**
	 * The feature id for the '<em><b>Item Types</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IR_ROOT__ITEM_TYPES = IR_ANNOTABLE_FEATURE_COUNT + 1;

	/**
	 * The feature id for the '<em><b>Connectivities</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IR_ROOT__CONNECTIVITIES = IR_ANNOTABLE_FEATURE_COUNT + 2;

	/**
	 * The feature id for the '<em><b>Functions</b></em>' reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IR_ROOT__FUNCTIONS = IR_ANNOTABLE_FEATURE_COUNT + 3;

	/**
	 * The feature id for the '<em><b>Variables</b></em>' reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IR_ROOT__VARIABLES = IR_ANNOTABLE_FEATURE_COUNT + 4;

	/**
	 * The feature id for the '<em><b>Jobs</b></em>' reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IR_ROOT__JOBS = IR_ANNOTABLE_FEATURE_COUNT + 5;

	/**
	 * The feature id for the '<em><b>Main</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IR_ROOT__MAIN = IR_ANNOTABLE_FEATURE_COUNT + 6;

	/**
	 * The feature id for the '<em><b>Modules</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IR_ROOT__MODULES = IR_ANNOTABLE_FEATURE_COUNT + 7;

	/**
	 * The feature id for the '<em><b>Mesh Class Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IR_ROOT__MESH_CLASS_NAME = IR_ANNOTABLE_FEATURE_COUNT + 8;

	/**
	 * The feature id for the '<em><b>Init Node Coord Variable</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IR_ROOT__INIT_NODE_COORD_VARIABLE = IR_ANNOTABLE_FEATURE_COUNT + 9;

	/**
	 * The feature id for the '<em><b>Node Coord Variable</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IR_ROOT__NODE_COORD_VARIABLE = IR_ANNOTABLE_FEATURE_COUNT + 10;

	/**
	 * The feature id for the '<em><b>Time Variable</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IR_ROOT__TIME_VARIABLE = IR_ANNOTABLE_FEATURE_COUNT + 11;

	/**
	 * The feature id for the '<em><b>Time Step Variable</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IR_ROOT__TIME_STEP_VARIABLE = IR_ANNOTABLE_FEATURE_COUNT + 12;

	/**
	 * The feature id for the '<em><b>Post Processing</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IR_ROOT__POST_PROCESSING = IR_ANNOTABLE_FEATURE_COUNT + 13;

	/**
	 * The feature id for the '<em><b>Providers</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IR_ROOT__PROVIDERS = IR_ANNOTABLE_FEATURE_COUNT + 14;

	/**
	 * The number of structural features of the '<em>Root</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IR_ROOT_FEATURE_COUNT = IR_ANNOTABLE_FEATURE_COUNT + 15;

	/**
	 * The number of operations of the '<em>Root</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IR_ROOT_OPERATION_COUNT = IR_ANNOTABLE_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.IrModuleImpl <em>Module</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.IrModuleImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getIrModule()
	 * @generated
	 */
	int IR_MODULE = 3;

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
	 * The feature id for the '<em><b>Main</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IR_MODULE__MAIN = IR_ANNOTABLE_FEATURE_COUNT + 1;

	/**
	 * The feature id for the '<em><b>Functions</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IR_MODULE__FUNCTIONS = IR_ANNOTABLE_FEATURE_COUNT + 2;

	/**
	 * The feature id for the '<em><b>Variables</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IR_MODULE__VARIABLES = IR_ANNOTABLE_FEATURE_COUNT + 3;

	/**
	 * The feature id for the '<em><b>Jobs</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IR_MODULE__JOBS = IR_ANNOTABLE_FEATURE_COUNT + 4;

	/**
	 * The number of structural features of the '<em>Module</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IR_MODULE_FEATURE_COUNT = IR_ANNOTABLE_FEATURE_COUNT + 5;

	/**
	 * The number of operations of the '<em>Module</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int IR_MODULE_OPERATION_COUNT = IR_ANNOTABLE_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.PostProcessingImpl <em>Post Processing</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.PostProcessingImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getPostProcessing()
	 * @generated
	 */
	int POST_PROCESSING = 4;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int POST_PROCESSING__ANNOTATIONS = IR_ANNOTABLE__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Output Variables</b></em>' reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int POST_PROCESSING__OUTPUT_VARIABLES = IR_ANNOTABLE_FEATURE_COUNT + 0;

	/**
	 * The feature id for the '<em><b>Period Reference</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int POST_PROCESSING__PERIOD_REFERENCE = IR_ANNOTABLE_FEATURE_COUNT + 1;

	/**
	 * The feature id for the '<em><b>Period Value</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int POST_PROCESSING__PERIOD_VALUE = IR_ANNOTABLE_FEATURE_COUNT + 2;

	/**
	 * The feature id for the '<em><b>Last Dump Variable</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int POST_PROCESSING__LAST_DUMP_VARIABLE = IR_ANNOTABLE_FEATURE_COUNT + 3;

	/**
	 * The number of structural features of the '<em>Post Processing</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int POST_PROCESSING_FEATURE_COUNT = IR_ANNOTABLE_FEATURE_COUNT + 4;

	/**
	 * The number of operations of the '<em>Post Processing</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int POST_PROCESSING_OPERATION_COUNT = IR_ANNOTABLE_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.ExtensionProviderImpl <em>Extension Provider</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.ExtensionProviderImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getExtensionProvider()
	 * @generated
	 */
	int EXTENSION_PROVIDER = 5;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int EXTENSION_PROVIDER__ANNOTATIONS = IR_ANNOTABLE__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Extension Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int EXTENSION_PROVIDER__EXTENSION_NAME = IR_ANNOTABLE_FEATURE_COUNT + 0;

	/**
	 * The feature id for the '<em><b>Provider Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int EXTENSION_PROVIDER__PROVIDER_NAME = IR_ANNOTABLE_FEATURE_COUNT + 1;

	/**
	 * The feature id for the '<em><b>Project Dir</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int EXTENSION_PROVIDER__PROJECT_DIR = IR_ANNOTABLE_FEATURE_COUNT + 2;

	/**
	 * The feature id for the '<em><b>Install Dir</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int EXTENSION_PROVIDER__INSTALL_DIR = IR_ANNOTABLE_FEATURE_COUNT + 3;

	/**
	 * The number of structural features of the '<em>Extension Provider</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int EXTENSION_PROVIDER_FEATURE_COUNT = IR_ANNOTABLE_FEATURE_COUNT + 4;

	/**
	 * The number of operations of the '<em>Extension Provider</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int EXTENSION_PROVIDER_OPERATION_COUNT = IR_ANNOTABLE_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.ArgOrVarImpl <em>Arg Or Var</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.ArgOrVarImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getArgOrVar()
	 * @generated
	 */
	int ARG_OR_VAR = 6;

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
	int ARG = 7;

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
	int VARIABLE = 8;

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
	 * The feature id for the '<em><b>Output Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int VARIABLE__OUTPUT_NAME = ARG_OR_VAR_FEATURE_COUNT + 0;

	/**
	 * The number of structural features of the '<em>Variable</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int VARIABLE_FEATURE_COUNT = ARG_OR_VAR_FEATURE_COUNT + 1;

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
	int SIMPLE_VARIABLE = 9;

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
	 * The feature id for the '<em><b>Output Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SIMPLE_VARIABLE__OUTPUT_NAME = VARIABLE__OUTPUT_NAME;

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
	 * The feature id for the '<em><b>Const</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SIMPLE_VARIABLE__CONST = VARIABLE_FEATURE_COUNT + 2;

	/**
	 * The feature id for the '<em><b>Const Expr</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SIMPLE_VARIABLE__CONST_EXPR = VARIABLE_FEATURE_COUNT + 3;

	/**
	 * The feature id for the '<em><b>Option</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SIMPLE_VARIABLE__OPTION = VARIABLE_FEATURE_COUNT + 4;

	/**
	 * The number of structural features of the '<em>Simple Variable</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SIMPLE_VARIABLE_FEATURE_COUNT = VARIABLE_FEATURE_COUNT + 5;

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
	int CONNECTIVITY_VARIABLE = 10;

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
	 * The feature id for the '<em><b>Output Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONNECTIVITY_VARIABLE__OUTPUT_NAME = VARIABLE__OUTPUT_NAME;

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
	 * The feature id for the '<em><b>Linear Algebra</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONNECTIVITY_VARIABLE__LINEAR_ALGEBRA = VARIABLE_FEATURE_COUNT + 2;

	/**
	 * The number of structural features of the '<em>Connectivity Variable</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONNECTIVITY_VARIABLE_FEATURE_COUNT = VARIABLE_FEATURE_COUNT + 3;

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
	int FUNCTION = 11;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int FUNCTION__ANNOTATIONS = IR_ANNOTABLE__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int FUNCTION__NAME = IR_ANNOTABLE_FEATURE_COUNT + 0;

	/**
	 * The feature id for the '<em><b>Return Type</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int FUNCTION__RETURN_TYPE = IR_ANNOTABLE_FEATURE_COUNT + 1;

	/**
	 * The feature id for the '<em><b>Variables</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int FUNCTION__VARIABLES = IR_ANNOTABLE_FEATURE_COUNT + 2;

	/**
	 * The feature id for the '<em><b>In Args</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int FUNCTION__IN_ARGS = IR_ANNOTABLE_FEATURE_COUNT + 3;

	/**
	 * The feature id for the '<em><b>Body</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int FUNCTION__BODY = IR_ANNOTABLE_FEATURE_COUNT + 4;

	/**
	 * The feature id for the '<em><b>Provider</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int FUNCTION__PROVIDER = IR_ANNOTABLE_FEATURE_COUNT + 5;

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
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.ConnectivityImpl <em>Connectivity</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.ConnectivityImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getConnectivity()
	 * @generated
	 */
	int CONNECTIVITY = 12;

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
	 * The feature id for the '<em><b>Return Type</b></em>' reference.
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
	 * The feature id for the '<em><b>Multiple</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONNECTIVITY__MULTIPLE = IR_ANNOTABLE_FEATURE_COUNT + 4;

	/**
	 * The number of structural features of the '<em>Connectivity</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONNECTIVITY_FEATURE_COUNT = IR_ANNOTABLE_FEATURE_COUNT + 5;

	/**
	 * The number of operations of the '<em>Connectivity</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONNECTIVITY_OPERATION_COUNT = IR_ANNOTABLE_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.JobCallerImpl <em>Job Caller</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.JobCallerImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getJobCaller()
	 * @generated
	 */
	int JOB_CALLER = 13;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int JOB_CALLER__ANNOTATIONS = IR_ANNOTABLE__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Calls</b></em>' reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int JOB_CALLER__CALLS = IR_ANNOTABLE_FEATURE_COUNT + 0;

	/**
	 * The number of structural features of the '<em>Job Caller</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int JOB_CALLER_FEATURE_COUNT = IR_ANNOTABLE_FEATURE_COUNT + 1;

	/**
	 * The number of operations of the '<em>Job Caller</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int JOB_CALLER_OPERATION_COUNT = IR_ANNOTABLE_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.JobImpl <em>Job</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.JobImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getJob()
	 * @generated
	 */
	int JOB = 14;

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
	 * The feature id for the '<em><b>Caller</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int JOB__CALLER = IR_ANNOTABLE_FEATURE_COUNT + 3;

	/**
	 * The feature id for the '<em><b>Previous Jobs With Same Caller</b></em>' reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int JOB__PREVIOUS_JOBS_WITH_SAME_CALLER = IR_ANNOTABLE_FEATURE_COUNT + 4;

	/**
	 * The feature id for the '<em><b>Next Jobs With Same Caller</b></em>' reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int JOB__NEXT_JOBS_WITH_SAME_CALLER = IR_ANNOTABLE_FEATURE_COUNT + 5;

	/**
	 * The number of structural features of the '<em>Job</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int JOB_FEATURE_COUNT = IR_ANNOTABLE_FEATURE_COUNT + 6;

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
	int INSTRUCTION_JOB = 15;

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
	 * The feature id for the '<em><b>Caller</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int INSTRUCTION_JOB__CALLER = JOB__CALLER;

	/**
	 * The feature id for the '<em><b>Previous Jobs With Same Caller</b></em>' reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int INSTRUCTION_JOB__PREVIOUS_JOBS_WITH_SAME_CALLER = JOB__PREVIOUS_JOBS_WITH_SAME_CALLER;

	/**
	 * The feature id for the '<em><b>Next Jobs With Same Caller</b></em>' reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int INSTRUCTION_JOB__NEXT_JOBS_WITH_SAME_CALLER = JOB__NEXT_JOBS_WITH_SAME_CALLER;

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
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.TimeLoopJobImpl <em>Time Loop Job</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.TimeLoopJobImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getTimeLoopJob()
	 * @generated
	 */
	int TIME_LOOP_JOB = 16;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int TIME_LOOP_JOB__ANNOTATIONS = JOB__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int TIME_LOOP_JOB__NAME = JOB__NAME;

	/**
	 * The feature id for the '<em><b>At</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int TIME_LOOP_JOB__AT = JOB__AT;

	/**
	 * The feature id for the '<em><b>On Cycle</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int TIME_LOOP_JOB__ON_CYCLE = JOB__ON_CYCLE;

	/**
	 * The feature id for the '<em><b>Caller</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int TIME_LOOP_JOB__CALLER = JOB__CALLER;

	/**
	 * The feature id for the '<em><b>Previous Jobs With Same Caller</b></em>' reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int TIME_LOOP_JOB__PREVIOUS_JOBS_WITH_SAME_CALLER = JOB__PREVIOUS_JOBS_WITH_SAME_CALLER;

	/**
	 * The feature id for the '<em><b>Next Jobs With Same Caller</b></em>' reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int TIME_LOOP_JOB__NEXT_JOBS_WITH_SAME_CALLER = JOB__NEXT_JOBS_WITH_SAME_CALLER;

	/**
	 * The feature id for the '<em><b>Copies</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int TIME_LOOP_JOB__COPIES = JOB_FEATURE_COUNT + 0;

	/**
	 * The number of structural features of the '<em>Time Loop Job</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int TIME_LOOP_JOB_FEATURE_COUNT = JOB_FEATURE_COUNT + 1;

	/**
	 * The number of operations of the '<em>Time Loop Job</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int TIME_LOOP_JOB_OPERATION_COUNT = JOB_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.ExecuteTimeLoopJobImpl <em>Execute Time Loop Job</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.ExecuteTimeLoopJobImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getExecuteTimeLoopJob()
	 * @generated
	 */
	int EXECUTE_TIME_LOOP_JOB = 17;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int EXECUTE_TIME_LOOP_JOB__ANNOTATIONS = TIME_LOOP_JOB__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int EXECUTE_TIME_LOOP_JOB__NAME = TIME_LOOP_JOB__NAME;

	/**
	 * The feature id for the '<em><b>At</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int EXECUTE_TIME_LOOP_JOB__AT = TIME_LOOP_JOB__AT;

	/**
	 * The feature id for the '<em><b>On Cycle</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int EXECUTE_TIME_LOOP_JOB__ON_CYCLE = TIME_LOOP_JOB__ON_CYCLE;

	/**
	 * The feature id for the '<em><b>Caller</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int EXECUTE_TIME_LOOP_JOB__CALLER = TIME_LOOP_JOB__CALLER;

	/**
	 * The feature id for the '<em><b>Previous Jobs With Same Caller</b></em>' reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int EXECUTE_TIME_LOOP_JOB__PREVIOUS_JOBS_WITH_SAME_CALLER = TIME_LOOP_JOB__PREVIOUS_JOBS_WITH_SAME_CALLER;

	/**
	 * The feature id for the '<em><b>Next Jobs With Same Caller</b></em>' reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int EXECUTE_TIME_LOOP_JOB__NEXT_JOBS_WITH_SAME_CALLER = TIME_LOOP_JOB__NEXT_JOBS_WITH_SAME_CALLER;

	/**
	 * The feature id for the '<em><b>Copies</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int EXECUTE_TIME_LOOP_JOB__COPIES = TIME_LOOP_JOB__COPIES;

	/**
	 * The feature id for the '<em><b>Calls</b></em>' reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int EXECUTE_TIME_LOOP_JOB__CALLS = TIME_LOOP_JOB_FEATURE_COUNT + 0;

	/**
	 * The feature id for the '<em><b>While Condition</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int EXECUTE_TIME_LOOP_JOB__WHILE_CONDITION = TIME_LOOP_JOB_FEATURE_COUNT + 1;

	/**
	 * The feature id for the '<em><b>Iteration Counter</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int EXECUTE_TIME_LOOP_JOB__ITERATION_COUNTER = TIME_LOOP_JOB_FEATURE_COUNT + 2;

	/**
	 * The number of structural features of the '<em>Execute Time Loop Job</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int EXECUTE_TIME_LOOP_JOB_FEATURE_COUNT = TIME_LOOP_JOB_FEATURE_COUNT + 3;

	/**
	 * The number of operations of the '<em>Execute Time Loop Job</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int EXECUTE_TIME_LOOP_JOB_OPERATION_COUNT = TIME_LOOP_JOB_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.SetUpTimeLoopJobImpl <em>Set Up Time Loop Job</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.SetUpTimeLoopJobImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getSetUpTimeLoopJob()
	 * @generated
	 */
	int SET_UP_TIME_LOOP_JOB = 18;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SET_UP_TIME_LOOP_JOB__ANNOTATIONS = TIME_LOOP_JOB__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SET_UP_TIME_LOOP_JOB__NAME = TIME_LOOP_JOB__NAME;

	/**
	 * The feature id for the '<em><b>At</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SET_UP_TIME_LOOP_JOB__AT = TIME_LOOP_JOB__AT;

	/**
	 * The feature id for the '<em><b>On Cycle</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SET_UP_TIME_LOOP_JOB__ON_CYCLE = TIME_LOOP_JOB__ON_CYCLE;

	/**
	 * The feature id for the '<em><b>Caller</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SET_UP_TIME_LOOP_JOB__CALLER = TIME_LOOP_JOB__CALLER;

	/**
	 * The feature id for the '<em><b>Previous Jobs With Same Caller</b></em>' reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SET_UP_TIME_LOOP_JOB__PREVIOUS_JOBS_WITH_SAME_CALLER = TIME_LOOP_JOB__PREVIOUS_JOBS_WITH_SAME_CALLER;

	/**
	 * The feature id for the '<em><b>Next Jobs With Same Caller</b></em>' reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SET_UP_TIME_LOOP_JOB__NEXT_JOBS_WITH_SAME_CALLER = TIME_LOOP_JOB__NEXT_JOBS_WITH_SAME_CALLER;

	/**
	 * The feature id for the '<em><b>Copies</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SET_UP_TIME_LOOP_JOB__COPIES = TIME_LOOP_JOB__COPIES;

	/**
	 * The number of structural features of the '<em>Set Up Time Loop Job</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SET_UP_TIME_LOOP_JOB_FEATURE_COUNT = TIME_LOOP_JOB_FEATURE_COUNT + 0;

	/**
	 * The number of operations of the '<em>Set Up Time Loop Job</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SET_UP_TIME_LOOP_JOB_OPERATION_COUNT = TIME_LOOP_JOB_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.TearDownTimeLoopJobImpl <em>Tear Down Time Loop Job</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.TearDownTimeLoopJobImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getTearDownTimeLoopJob()
	 * @generated
	 */
	int TEAR_DOWN_TIME_LOOP_JOB = 19;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int TEAR_DOWN_TIME_LOOP_JOB__ANNOTATIONS = TIME_LOOP_JOB__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int TEAR_DOWN_TIME_LOOP_JOB__NAME = TIME_LOOP_JOB__NAME;

	/**
	 * The feature id for the '<em><b>At</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int TEAR_DOWN_TIME_LOOP_JOB__AT = TIME_LOOP_JOB__AT;

	/**
	 * The feature id for the '<em><b>On Cycle</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int TEAR_DOWN_TIME_LOOP_JOB__ON_CYCLE = TIME_LOOP_JOB__ON_CYCLE;

	/**
	 * The feature id for the '<em><b>Caller</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int TEAR_DOWN_TIME_LOOP_JOB__CALLER = TIME_LOOP_JOB__CALLER;

	/**
	 * The feature id for the '<em><b>Previous Jobs With Same Caller</b></em>' reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int TEAR_DOWN_TIME_LOOP_JOB__PREVIOUS_JOBS_WITH_SAME_CALLER = TIME_LOOP_JOB__PREVIOUS_JOBS_WITH_SAME_CALLER;

	/**
	 * The feature id for the '<em><b>Next Jobs With Same Caller</b></em>' reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int TEAR_DOWN_TIME_LOOP_JOB__NEXT_JOBS_WITH_SAME_CALLER = TIME_LOOP_JOB__NEXT_JOBS_WITH_SAME_CALLER;

	/**
	 * The feature id for the '<em><b>Copies</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int TEAR_DOWN_TIME_LOOP_JOB__COPIES = TIME_LOOP_JOB__COPIES;

	/**
	 * The number of structural features of the '<em>Tear Down Time Loop Job</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int TEAR_DOWN_TIME_LOOP_JOB_FEATURE_COUNT = TIME_LOOP_JOB_FEATURE_COUNT + 0;

	/**
	 * The number of operations of the '<em>Tear Down Time Loop Job</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int TEAR_DOWN_TIME_LOOP_JOB_OPERATION_COUNT = TIME_LOOP_JOB_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.TimeLoopCopyImpl <em>Time Loop Copy</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.TimeLoopCopyImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getTimeLoopCopy()
	 * @generated
	 */
	int TIME_LOOP_COPY = 20;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int TIME_LOOP_COPY__ANNOTATIONS = IR_ANNOTABLE__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Destination</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int TIME_LOOP_COPY__DESTINATION = IR_ANNOTABLE_FEATURE_COUNT + 0;

	/**
	 * The feature id for the '<em><b>Source</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int TIME_LOOP_COPY__SOURCE = IR_ANNOTABLE_FEATURE_COUNT + 1;

	/**
	 * The number of structural features of the '<em>Time Loop Copy</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int TIME_LOOP_COPY_FEATURE_COUNT = IR_ANNOTABLE_FEATURE_COUNT + 2;

	/**
	 * The number of operations of the '<em>Time Loop Copy</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int TIME_LOOP_COPY_OPERATION_COUNT = IR_ANNOTABLE_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.InstructionImpl <em>Instruction</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.InstructionImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getInstruction()
	 * @generated
	 */
	int INSTRUCTION = 21;

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
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.InstructionBlockImpl <em>Instruction Block</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.InstructionBlockImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getInstructionBlock()
	 * @generated
	 */
	int INSTRUCTION_BLOCK = 22;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int INSTRUCTION_BLOCK__ANNOTATIONS = INSTRUCTION__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Variables</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int INSTRUCTION_BLOCK__VARIABLES = INSTRUCTION_FEATURE_COUNT + 0;

	/**
	 * The feature id for the '<em><b>Instructions</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int INSTRUCTION_BLOCK__INSTRUCTIONS = INSTRUCTION_FEATURE_COUNT + 1;

	/**
	 * The number of structural features of the '<em>Instruction Block</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int INSTRUCTION_BLOCK_FEATURE_COUNT = INSTRUCTION_FEATURE_COUNT + 2;

	/**
	 * The number of operations of the '<em>Instruction Block</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int INSTRUCTION_BLOCK_OPERATION_COUNT = INSTRUCTION_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.VariableDeclarationImpl <em>Variable Declaration</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.VariableDeclarationImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getVariableDeclaration()
	 * @generated
	 */
	int VARIABLE_DECLARATION = 23;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int VARIABLE_DECLARATION__ANNOTATIONS = INSTRUCTION__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Variable</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int VARIABLE_DECLARATION__VARIABLE = INSTRUCTION_FEATURE_COUNT + 0;

	/**
	 * The number of structural features of the '<em>Variable Declaration</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int VARIABLE_DECLARATION_FEATURE_COUNT = INSTRUCTION_FEATURE_COUNT + 1;

	/**
	 * The number of operations of the '<em>Variable Declaration</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int VARIABLE_DECLARATION_OPERATION_COUNT = INSTRUCTION_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.AffectationImpl <em>Affectation</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.AffectationImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getAffectation()
	 * @generated
	 */
	int AFFECTATION = 24;

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
	int ITERABLE_INSTRUCTION = 25;

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
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.ReductionInstructionImpl <em>Reduction Instruction</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.ReductionInstructionImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getReductionInstruction()
	 * @generated
	 */
	int REDUCTION_INSTRUCTION = 26;

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
	 * The feature id for the '<em><b>Inner Instructions</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int REDUCTION_INSTRUCTION__INNER_INSTRUCTIONS = ITERABLE_INSTRUCTION_FEATURE_COUNT + 0;

	/**
	 * The feature id for the '<em><b>Binary Function</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int REDUCTION_INSTRUCTION__BINARY_FUNCTION = ITERABLE_INSTRUCTION_FEATURE_COUNT + 1;

	/**
	 * The feature id for the '<em><b>Lambda</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int REDUCTION_INSTRUCTION__LAMBDA = ITERABLE_INSTRUCTION_FEATURE_COUNT + 2;

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
	int LOOP = 27;

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
	 * The feature id for the '<em><b>Multithreadable</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int LOOP__MULTITHREADABLE = ITERABLE_INSTRUCTION_FEATURE_COUNT + 1;

	/**
	 * The number of structural features of the '<em>Loop</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int LOOP_FEATURE_COUNT = ITERABLE_INSTRUCTION_FEATURE_COUNT + 2;

	/**
	 * The number of operations of the '<em>Loop</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int LOOP_OPERATION_COUNT = ITERABLE_INSTRUCTION_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.ItemIndexDefinitionImpl <em>Item Index Definition</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.ItemIndexDefinitionImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getItemIndexDefinition()
	 * @generated
	 */
	int ITEM_INDEX_DEFINITION = 28;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITEM_INDEX_DEFINITION__ANNOTATIONS = INSTRUCTION__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Index</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITEM_INDEX_DEFINITION__INDEX = INSTRUCTION_FEATURE_COUNT + 0;

	/**
	 * The feature id for the '<em><b>Value</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITEM_INDEX_DEFINITION__VALUE = INSTRUCTION_FEATURE_COUNT + 1;

	/**
	 * The number of structural features of the '<em>Item Index Definition</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITEM_INDEX_DEFINITION_FEATURE_COUNT = INSTRUCTION_FEATURE_COUNT + 2;

	/**
	 * The number of operations of the '<em>Item Index Definition</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITEM_INDEX_DEFINITION_OPERATION_COUNT = INSTRUCTION_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.ItemIdDefinitionImpl <em>Item Id Definition</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.ItemIdDefinitionImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getItemIdDefinition()
	 * @generated
	 */
	int ITEM_ID_DEFINITION = 29;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITEM_ID_DEFINITION__ANNOTATIONS = INSTRUCTION__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Id</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITEM_ID_DEFINITION__ID = INSTRUCTION_FEATURE_COUNT + 0;

	/**
	 * The feature id for the '<em><b>Value</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITEM_ID_DEFINITION__VALUE = INSTRUCTION_FEATURE_COUNT + 1;

	/**
	 * The number of structural features of the '<em>Item Id Definition</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITEM_ID_DEFINITION_FEATURE_COUNT = INSTRUCTION_FEATURE_COUNT + 2;

	/**
	 * The number of operations of the '<em>Item Id Definition</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITEM_ID_DEFINITION_OPERATION_COUNT = INSTRUCTION_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.SetDefinitionImpl <em>Set Definition</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.SetDefinitionImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getSetDefinition()
	 * @generated
	 */
	int SET_DEFINITION = 30;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SET_DEFINITION__ANNOTATIONS = INSTRUCTION__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SET_DEFINITION__NAME = INSTRUCTION_FEATURE_COUNT + 0;

	/**
	 * The feature id for the '<em><b>Value</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SET_DEFINITION__VALUE = INSTRUCTION_FEATURE_COUNT + 1;

	/**
	 * The number of structural features of the '<em>Set Definition</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SET_DEFINITION_FEATURE_COUNT = INSTRUCTION_FEATURE_COUNT + 2;

	/**
	 * The number of operations of the '<em>Set Definition</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SET_DEFINITION_OPERATION_COUNT = INSTRUCTION_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.IfImpl <em>If</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.IfImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getIf()
	 * @generated
	 */
	int IF = 31;

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
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.WhileImpl <em>While</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.WhileImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getWhile()
	 * @generated
	 */
	int WHILE = 32;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int WHILE__ANNOTATIONS = INSTRUCTION__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Condition</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int WHILE__CONDITION = INSTRUCTION_FEATURE_COUNT + 0;

	/**
	 * The feature id for the '<em><b>Instruction</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int WHILE__INSTRUCTION = INSTRUCTION_FEATURE_COUNT + 1;

	/**
	 * The number of structural features of the '<em>While</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int WHILE_FEATURE_COUNT = INSTRUCTION_FEATURE_COUNT + 2;

	/**
	 * The number of operations of the '<em>While</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int WHILE_OPERATION_COUNT = INSTRUCTION_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.ReturnImpl <em>Return</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.ReturnImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getReturn()
	 * @generated
	 */
	int RETURN = 33;

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
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.ExitImpl <em>Exit</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.ExitImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getExit()
	 * @generated
	 */
	int EXIT = 34;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int EXIT__ANNOTATIONS = INSTRUCTION__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Message</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int EXIT__MESSAGE = INSTRUCTION_FEATURE_COUNT + 0;

	/**
	 * The number of structural features of the '<em>Exit</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int EXIT_FEATURE_COUNT = INSTRUCTION_FEATURE_COUNT + 1;

	/**
	 * The number of operations of the '<em>Exit</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int EXIT_OPERATION_COUNT = INSTRUCTION_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.IterationBlockImpl <em>Iteration Block</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.IterationBlockImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getIterationBlock()
	 * @generated
	 */
	int ITERATION_BLOCK = 35;

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
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.IteratorImpl <em>Iterator</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.IteratorImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getIterator()
	 * @generated
	 */
	int ITERATOR = 36;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITERATOR__ANNOTATIONS = ITERATION_BLOCK__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Index</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITERATOR__INDEX = ITERATION_BLOCK_FEATURE_COUNT + 0;

	/**
	 * The feature id for the '<em><b>Container</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITERATOR__CONTAINER = ITERATION_BLOCK_FEATURE_COUNT + 1;

	/**
	 * The feature id for the '<em><b>Counter</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITERATOR__COUNTER = ITERATION_BLOCK_FEATURE_COUNT + 2;

	/**
	 * The number of structural features of the '<em>Iterator</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITERATOR_FEATURE_COUNT = ITERATION_BLOCK_FEATURE_COUNT + 3;

	/**
	 * The number of operations of the '<em>Iterator</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITERATOR_OPERATION_COUNT = ITERATION_BLOCK_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.IntervalImpl <em>Interval</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.IntervalImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getInterval()
	 * @generated
	 */
	int INTERVAL = 37;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int INTERVAL__ANNOTATIONS = ITERATION_BLOCK__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Index</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int INTERVAL__INDEX = ITERATION_BLOCK_FEATURE_COUNT + 0;

	/**
	 * The feature id for the '<em><b>Nb Elems</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int INTERVAL__NB_ELEMS = ITERATION_BLOCK_FEATURE_COUNT + 1;

	/**
	 * The number of structural features of the '<em>Interval</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int INTERVAL_FEATURE_COUNT = ITERATION_BLOCK_FEATURE_COUNT + 2;

	/**
	 * The number of operations of the '<em>Interval</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int INTERVAL_OPERATION_COUNT = ITERATION_BLOCK_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.ExpressionImpl <em>Expression</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.ExpressionImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getExpression()
	 * @generated
	 */
	int EXPRESSION = 38;

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
	 * The feature id for the '<em><b>Const Expr</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int EXPRESSION__CONST_EXPR = IR_ANNOTABLE_FEATURE_COUNT + 1;

	/**
	 * The number of structural features of the '<em>Expression</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int EXPRESSION_FEATURE_COUNT = IR_ANNOTABLE_FEATURE_COUNT + 2;

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
	int CONTRACTED_IF = 39;

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
	 * The feature id for the '<em><b>Const Expr</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONTRACTED_IF__CONST_EXPR = EXPRESSION__CONST_EXPR;

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
	int BINARY_EXPRESSION = 40;

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
	 * The feature id for the '<em><b>Const Expr</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int BINARY_EXPRESSION__CONST_EXPR = EXPRESSION__CONST_EXPR;

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
	int UNARY_EXPRESSION = 41;

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
	 * The feature id for the '<em><b>Const Expr</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int UNARY_EXPRESSION__CONST_EXPR = EXPRESSION__CONST_EXPR;

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
	int PARENTHESIS = 42;

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
	 * The feature id for the '<em><b>Const Expr</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int PARENTHESIS__CONST_EXPR = EXPRESSION__CONST_EXPR;

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
	int INT_CONSTANT = 43;

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
	 * The feature id for the '<em><b>Const Expr</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int INT_CONSTANT__CONST_EXPR = EXPRESSION__CONST_EXPR;

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
	int REAL_CONSTANT = 44;

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
	 * The feature id for the '<em><b>Const Expr</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int REAL_CONSTANT__CONST_EXPR = EXPRESSION__CONST_EXPR;

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
	int BOOL_CONSTANT = 45;

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
	 * The feature id for the '<em><b>Const Expr</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int BOOL_CONSTANT__CONST_EXPR = EXPRESSION__CONST_EXPR;

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
	int MIN_CONSTANT = 46;

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
	 * The feature id for the '<em><b>Const Expr</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int MIN_CONSTANT__CONST_EXPR = EXPRESSION__CONST_EXPR;

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
	int MAX_CONSTANT = 47;

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
	 * The feature id for the '<em><b>Const Expr</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int MAX_CONSTANT__CONST_EXPR = EXPRESSION__CONST_EXPR;

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
	 * The feature id for the '<em><b>Const Expr</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int FUNCTION_CALL__CONST_EXPR = EXPRESSION__CONST_EXPR;

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
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.BaseTypeConstantImpl <em>Base Type Constant</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.BaseTypeConstantImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getBaseTypeConstant()
	 * @generated
	 */
	int BASE_TYPE_CONSTANT = 49;

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
	 * The feature id for the '<em><b>Const Expr</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int BASE_TYPE_CONSTANT__CONST_EXPR = EXPRESSION__CONST_EXPR;

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
	int VECTOR_CONSTANT = 50;

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
	 * The feature id for the '<em><b>Const Expr</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int VECTOR_CONSTANT__CONST_EXPR = EXPRESSION__CONST_EXPR;

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
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.CardinalityImpl <em>Cardinality</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.CardinalityImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getCardinality()
	 * @generated
	 */
	int CARDINALITY = 51;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CARDINALITY__ANNOTATIONS = EXPRESSION__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Type</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CARDINALITY__TYPE = EXPRESSION__TYPE;

	/**
	 * The feature id for the '<em><b>Const Expr</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CARDINALITY__CONST_EXPR = EXPRESSION__CONST_EXPR;

	/**
	 * The feature id for the '<em><b>Container</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CARDINALITY__CONTAINER = EXPRESSION_FEATURE_COUNT + 0;

	/**
	 * The number of structural features of the '<em>Cardinality</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CARDINALITY_FEATURE_COUNT = EXPRESSION_FEATURE_COUNT + 1;

	/**
	 * The number of operations of the '<em>Cardinality</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CARDINALITY_OPERATION_COUNT = EXPRESSION_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.ArgOrVarRefImpl <em>Arg Or Var Ref</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.ArgOrVarRefImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getArgOrVarRef()
	 * @generated
	 */
	int ARG_OR_VAR_REF = 52;

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
	 * The feature id for the '<em><b>Const Expr</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ARG_OR_VAR_REF__CONST_EXPR = EXPRESSION__CONST_EXPR;

	/**
	 * The feature id for the '<em><b>Target</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ARG_OR_VAR_REF__TARGET = EXPRESSION_FEATURE_COUNT + 0;

	/**
	 * The feature id for the '<em><b>Iterators</b></em>' reference list.
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
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.ItemTypeImpl <em>Item Type</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.ItemTypeImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getItemType()
	 * @generated
	 */
	int ITEM_TYPE = 53;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITEM_TYPE__ANNOTATIONS = IR_ANNOTABLE__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITEM_TYPE__NAME = IR_ANNOTABLE_FEATURE_COUNT + 0;

	/**
	 * The number of structural features of the '<em>Item Type</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITEM_TYPE_FEATURE_COUNT = IR_ANNOTABLE_FEATURE_COUNT + 1;

	/**
	 * The number of operations of the '<em>Item Type</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITEM_TYPE_OPERATION_COUNT = IR_ANNOTABLE_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.IrTypeImpl <em>Type</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.IrTypeImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getIrType()
	 * @generated
	 */
	int IR_TYPE = 54;

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
	int BASE_TYPE = 55;

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
	int CONNECTIVITY_TYPE = 56;

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
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.ContainerImpl <em>Container</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.ContainerImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getContainer()
	 * @generated
	 */
	int CONTAINER = 57;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONTAINER__ANNOTATIONS = IR_ANNOTABLE__ANNOTATIONS;

	/**
	 * The number of structural features of the '<em>Container</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONTAINER_FEATURE_COUNT = IR_ANNOTABLE_FEATURE_COUNT + 0;

	/**
	 * The number of operations of the '<em>Container</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONTAINER_OPERATION_COUNT = IR_ANNOTABLE_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.ConnectivityCallImpl <em>Connectivity Call</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.ConnectivityCallImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getConnectivityCall()
	 * @generated
	 */
	int CONNECTIVITY_CALL = 58;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONNECTIVITY_CALL__ANNOTATIONS = CONTAINER__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Connectivity</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONNECTIVITY_CALL__CONNECTIVITY = CONTAINER_FEATURE_COUNT + 0;

	/**
	 * The feature id for the '<em><b>Args</b></em>' reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONNECTIVITY_CALL__ARGS = CONTAINER_FEATURE_COUNT + 1;

	/**
	 * The number of structural features of the '<em>Connectivity Call</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONNECTIVITY_CALL_FEATURE_COUNT = CONTAINER_FEATURE_COUNT + 2;

	/**
	 * The number of operations of the '<em>Connectivity Call</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONNECTIVITY_CALL_OPERATION_COUNT = CONTAINER_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.SetRefImpl <em>Set Ref</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.SetRefImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getSetRef()
	 * @generated
	 */
	int SET_REF = 59;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SET_REF__ANNOTATIONS = CONTAINER__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Target</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SET_REF__TARGET = CONTAINER_FEATURE_COUNT + 0;

	/**
	 * The number of structural features of the '<em>Set Ref</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SET_REF_FEATURE_COUNT = CONTAINER_FEATURE_COUNT + 1;

	/**
	 * The number of operations of the '<em>Set Ref</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SET_REF_OPERATION_COUNT = CONTAINER_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.ItemIdImpl <em>Item Id</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.ItemIdImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getItemId()
	 * @generated
	 */
	int ITEM_ID = 60;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITEM_ID__ANNOTATIONS = IR_ANNOTABLE__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITEM_ID__NAME = IR_ANNOTABLE_FEATURE_COUNT + 0;

	/**
	 * The feature id for the '<em><b>Item Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITEM_ID__ITEM_NAME = IR_ANNOTABLE_FEATURE_COUNT + 1;

	/**
	 * The number of structural features of the '<em>Item Id</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITEM_ID_FEATURE_COUNT = IR_ANNOTABLE_FEATURE_COUNT + 2;

	/**
	 * The number of operations of the '<em>Item Id</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITEM_ID_OPERATION_COUNT = IR_ANNOTABLE_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.ItemIdValueImpl <em>Item Id Value</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.ItemIdValueImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getItemIdValue()
	 * @generated
	 */
	int ITEM_ID_VALUE = 61;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITEM_ID_VALUE__ANNOTATIONS = IR_ANNOTABLE__ANNOTATIONS;

	/**
	 * The number of structural features of the '<em>Item Id Value</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITEM_ID_VALUE_FEATURE_COUNT = IR_ANNOTABLE_FEATURE_COUNT + 0;

	/**
	 * The number of operations of the '<em>Item Id Value</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITEM_ID_VALUE_OPERATION_COUNT = IR_ANNOTABLE_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.ItemIdValueIteratorImpl <em>Item Id Value Iterator</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.ItemIdValueIteratorImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getItemIdValueIterator()
	 * @generated
	 */
	int ITEM_ID_VALUE_ITERATOR = 62;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITEM_ID_VALUE_ITERATOR__ANNOTATIONS = ITEM_ID_VALUE__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Iterator</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITEM_ID_VALUE_ITERATOR__ITERATOR = ITEM_ID_VALUE_FEATURE_COUNT + 0;

	/**
	 * The feature id for the '<em><b>Shift</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITEM_ID_VALUE_ITERATOR__SHIFT = ITEM_ID_VALUE_FEATURE_COUNT + 1;

	/**
	 * The number of structural features of the '<em>Item Id Value Iterator</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITEM_ID_VALUE_ITERATOR_FEATURE_COUNT = ITEM_ID_VALUE_FEATURE_COUNT + 2;

	/**
	 * The number of operations of the '<em>Item Id Value Iterator</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITEM_ID_VALUE_ITERATOR_OPERATION_COUNT = ITEM_ID_VALUE_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.ItemIdValueContainerImpl <em>Item Id Value Container</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.ItemIdValueContainerImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getItemIdValueContainer()
	 * @generated
	 */
	int ITEM_ID_VALUE_CONTAINER = 63;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITEM_ID_VALUE_CONTAINER__ANNOTATIONS = ITEM_ID_VALUE__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Container</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITEM_ID_VALUE_CONTAINER__CONTAINER = ITEM_ID_VALUE_FEATURE_COUNT + 0;

	/**
	 * The number of structural features of the '<em>Item Id Value Container</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITEM_ID_VALUE_CONTAINER_FEATURE_COUNT = ITEM_ID_VALUE_FEATURE_COUNT + 1;

	/**
	 * The number of operations of the '<em>Item Id Value Container</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITEM_ID_VALUE_CONTAINER_OPERATION_COUNT = ITEM_ID_VALUE_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.ItemIndexImpl <em>Item Index</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.ItemIndexImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getItemIndex()
	 * @generated
	 */
	int ITEM_INDEX = 64;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITEM_INDEX__ANNOTATIONS = IR_ANNOTABLE__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITEM_INDEX__NAME = IR_ANNOTABLE_FEATURE_COUNT + 0;

	/**
	 * The feature id for the '<em><b>Item Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITEM_INDEX__ITEM_NAME = IR_ANNOTABLE_FEATURE_COUNT + 1;

	/**
	 * The number of structural features of the '<em>Item Index</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITEM_INDEX_FEATURE_COUNT = IR_ANNOTABLE_FEATURE_COUNT + 2;

	/**
	 * The number of operations of the '<em>Item Index</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITEM_INDEX_OPERATION_COUNT = IR_ANNOTABLE_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.impl.ItemIndexValueImpl <em>Item Index Value</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.impl.ItemIndexValueImpl
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getItemIndexValue()
	 * @generated
	 */
	int ITEM_INDEX_VALUE = 65;

	/**
	 * The feature id for the '<em><b>Annotations</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITEM_INDEX_VALUE__ANNOTATIONS = IR_ANNOTABLE__ANNOTATIONS;

	/**
	 * The feature id for the '<em><b>Id</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITEM_INDEX_VALUE__ID = IR_ANNOTABLE_FEATURE_COUNT + 0;

	/**
	 * The feature id for the '<em><b>Container</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITEM_INDEX_VALUE__CONTAINER = IR_ANNOTABLE_FEATURE_COUNT + 1;

	/**
	 * The number of structural features of the '<em>Item Index Value</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITEM_INDEX_VALUE_FEATURE_COUNT = IR_ANNOTABLE_FEATURE_COUNT + 2;

	/**
	 * The number of operations of the '<em>Item Index Value</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int ITEM_INDEX_VALUE_OPERATION_COUNT = IR_ANNOTABLE_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link fr.cea.nabla.ir.ir.PrimitiveType <em>Primitive Type</em>}' enum.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see fr.cea.nabla.ir.ir.PrimitiveType
	 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getPrimitiveType()
	 * @generated
	 */
	int PRIMITIVE_TYPE = 66;


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
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.IrRoot <em>Root</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Root</em>'.
	 * @see fr.cea.nabla.ir.ir.IrRoot
	 * @generated
	 */
	EClass getIrRoot();

	/**
	 * Returns the meta object for the attribute '{@link fr.cea.nabla.ir.ir.IrRoot#getName <em>Name</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Name</em>'.
	 * @see fr.cea.nabla.ir.ir.IrRoot#getName()
	 * @see #getIrRoot()
	 * @generated
	 */
	EAttribute getIrRoot_Name();

	/**
	 * Returns the meta object for the containment reference list '{@link fr.cea.nabla.ir.ir.IrRoot#getItemTypes <em>Item Types</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference list '<em>Item Types</em>'.
	 * @see fr.cea.nabla.ir.ir.IrRoot#getItemTypes()
	 * @see #getIrRoot()
	 * @generated
	 */
	EReference getIrRoot_ItemTypes();

	/**
	 * Returns the meta object for the containment reference list '{@link fr.cea.nabla.ir.ir.IrRoot#getConnectivities <em>Connectivities</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference list '<em>Connectivities</em>'.
	 * @see fr.cea.nabla.ir.ir.IrRoot#getConnectivities()
	 * @see #getIrRoot()
	 * @generated
	 */
	EReference getIrRoot_Connectivities();

	/**
	 * Returns the meta object for the reference list '{@link fr.cea.nabla.ir.ir.IrRoot#getFunctions <em>Functions</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the reference list '<em>Functions</em>'.
	 * @see fr.cea.nabla.ir.ir.IrRoot#getFunctions()
	 * @see #getIrRoot()
	 * @generated
	 */
	EReference getIrRoot_Functions();

	/**
	 * Returns the meta object for the reference list '{@link fr.cea.nabla.ir.ir.IrRoot#getVariables <em>Variables</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the reference list '<em>Variables</em>'.
	 * @see fr.cea.nabla.ir.ir.IrRoot#getVariables()
	 * @see #getIrRoot()
	 * @generated
	 */
	EReference getIrRoot_Variables();

	/**
	 * Returns the meta object for the reference list '{@link fr.cea.nabla.ir.ir.IrRoot#getJobs <em>Jobs</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the reference list '<em>Jobs</em>'.
	 * @see fr.cea.nabla.ir.ir.IrRoot#getJobs()
	 * @see #getIrRoot()
	 * @generated
	 */
	EReference getIrRoot_Jobs();

	/**
	 * Returns the meta object for the containment reference '{@link fr.cea.nabla.ir.ir.IrRoot#getMain <em>Main</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>Main</em>'.
	 * @see fr.cea.nabla.ir.ir.IrRoot#getMain()
	 * @see #getIrRoot()
	 * @generated
	 */
	EReference getIrRoot_Main();

	/**
	 * Returns the meta object for the containment reference list '{@link fr.cea.nabla.ir.ir.IrRoot#getModules <em>Modules</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference list '<em>Modules</em>'.
	 * @see fr.cea.nabla.ir.ir.IrRoot#getModules()
	 * @see #getIrRoot()
	 * @generated
	 */
	EReference getIrRoot_Modules();

	/**
	 * Returns the meta object for the attribute '{@link fr.cea.nabla.ir.ir.IrRoot#getMeshClassName <em>Mesh Class Name</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Mesh Class Name</em>'.
	 * @see fr.cea.nabla.ir.ir.IrRoot#getMeshClassName()
	 * @see #getIrRoot()
	 * @generated
	 */
	EAttribute getIrRoot_MeshClassName();

	/**
	 * Returns the meta object for the reference '{@link fr.cea.nabla.ir.ir.IrRoot#getInitNodeCoordVariable <em>Init Node Coord Variable</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the reference '<em>Init Node Coord Variable</em>'.
	 * @see fr.cea.nabla.ir.ir.IrRoot#getInitNodeCoordVariable()
	 * @see #getIrRoot()
	 * @generated
	 */
	EReference getIrRoot_InitNodeCoordVariable();

	/**
	 * Returns the meta object for the reference '{@link fr.cea.nabla.ir.ir.IrRoot#getNodeCoordVariable <em>Node Coord Variable</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the reference '<em>Node Coord Variable</em>'.
	 * @see fr.cea.nabla.ir.ir.IrRoot#getNodeCoordVariable()
	 * @see #getIrRoot()
	 * @generated
	 */
	EReference getIrRoot_NodeCoordVariable();

	/**
	 * Returns the meta object for the reference '{@link fr.cea.nabla.ir.ir.IrRoot#getTimeVariable <em>Time Variable</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the reference '<em>Time Variable</em>'.
	 * @see fr.cea.nabla.ir.ir.IrRoot#getTimeVariable()
	 * @see #getIrRoot()
	 * @generated
	 */
	EReference getIrRoot_TimeVariable();

	/**
	 * Returns the meta object for the reference '{@link fr.cea.nabla.ir.ir.IrRoot#getTimeStepVariable <em>Time Step Variable</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the reference '<em>Time Step Variable</em>'.
	 * @see fr.cea.nabla.ir.ir.IrRoot#getTimeStepVariable()
	 * @see #getIrRoot()
	 * @generated
	 */
	EReference getIrRoot_TimeStepVariable();

	/**
	 * Returns the meta object for the containment reference '{@link fr.cea.nabla.ir.ir.IrRoot#getPostProcessing <em>Post Processing</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>Post Processing</em>'.
	 * @see fr.cea.nabla.ir.ir.IrRoot#getPostProcessing()
	 * @see #getIrRoot()
	 * @generated
	 */
	EReference getIrRoot_PostProcessing();

	/**
	 * Returns the meta object for the containment reference list '{@link fr.cea.nabla.ir.ir.IrRoot#getProviders <em>Providers</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference list '<em>Providers</em>'.
	 * @see fr.cea.nabla.ir.ir.IrRoot#getProviders()
	 * @see #getIrRoot()
	 * @generated
	 */
	EReference getIrRoot_Providers();

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
	 * Returns the meta object for the attribute '{@link fr.cea.nabla.ir.ir.IrModule#isMain <em>Main</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Main</em>'.
	 * @see fr.cea.nabla.ir.ir.IrModule#isMain()
	 * @see #getIrModule()
	 * @generated
	 */
	EAttribute getIrModule_Main();

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
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.PostProcessing <em>Post Processing</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Post Processing</em>'.
	 * @see fr.cea.nabla.ir.ir.PostProcessing
	 * @generated
	 */
	EClass getPostProcessing();

	/**
	 * Returns the meta object for the reference list '{@link fr.cea.nabla.ir.ir.PostProcessing#getOutputVariables <em>Output Variables</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the reference list '<em>Output Variables</em>'.
	 * @see fr.cea.nabla.ir.ir.PostProcessing#getOutputVariables()
	 * @see #getPostProcessing()
	 * @generated
	 */
	EReference getPostProcessing_OutputVariables();

	/**
	 * Returns the meta object for the reference '{@link fr.cea.nabla.ir.ir.PostProcessing#getPeriodReference <em>Period Reference</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the reference '<em>Period Reference</em>'.
	 * @see fr.cea.nabla.ir.ir.PostProcessing#getPeriodReference()
	 * @see #getPostProcessing()
	 * @generated
	 */
	EReference getPostProcessing_PeriodReference();

	/**
	 * Returns the meta object for the reference '{@link fr.cea.nabla.ir.ir.PostProcessing#getPeriodValue <em>Period Value</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the reference '<em>Period Value</em>'.
	 * @see fr.cea.nabla.ir.ir.PostProcessing#getPeriodValue()
	 * @see #getPostProcessing()
	 * @generated
	 */
	EReference getPostProcessing_PeriodValue();

	/**
	 * Returns the meta object for the reference '{@link fr.cea.nabla.ir.ir.PostProcessing#getLastDumpVariable <em>Last Dump Variable</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the reference '<em>Last Dump Variable</em>'.
	 * @see fr.cea.nabla.ir.ir.PostProcessing#getLastDumpVariable()
	 * @see #getPostProcessing()
	 * @generated
	 */
	EReference getPostProcessing_LastDumpVariable();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.ExtensionProvider <em>Extension Provider</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Extension Provider</em>'.
	 * @see fr.cea.nabla.ir.ir.ExtensionProvider
	 * @generated
	 */
	EClass getExtensionProvider();

	/**
	 * Returns the meta object for the attribute '{@link fr.cea.nabla.ir.ir.ExtensionProvider#getExtensionName <em>Extension Name</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Extension Name</em>'.
	 * @see fr.cea.nabla.ir.ir.ExtensionProvider#getExtensionName()
	 * @see #getExtensionProvider()
	 * @generated
	 */
	EAttribute getExtensionProvider_ExtensionName();

	/**
	 * Returns the meta object for the attribute '{@link fr.cea.nabla.ir.ir.ExtensionProvider#getProviderName <em>Provider Name</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Provider Name</em>'.
	 * @see fr.cea.nabla.ir.ir.ExtensionProvider#getProviderName()
	 * @see #getExtensionProvider()
	 * @generated
	 */
	EAttribute getExtensionProvider_ProviderName();

	/**
	 * Returns the meta object for the attribute '{@link fr.cea.nabla.ir.ir.ExtensionProvider#getProjectDir <em>Project Dir</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Project Dir</em>'.
	 * @see fr.cea.nabla.ir.ir.ExtensionProvider#getProjectDir()
	 * @see #getExtensionProvider()
	 * @generated
	 */
	EAttribute getExtensionProvider_ProjectDir();

	/**
	 * Returns the meta object for the attribute '{@link fr.cea.nabla.ir.ir.ExtensionProvider#getInstallDir <em>Install Dir</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Install Dir</em>'.
	 * @see fr.cea.nabla.ir.ir.ExtensionProvider#getInstallDir()
	 * @see #getExtensionProvider()
	 * @generated
	 */
	EAttribute getExtensionProvider_InstallDir();

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
	 * Returns the meta object for the attribute '{@link fr.cea.nabla.ir.ir.Variable#getOutputName <em>Output Name</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Output Name</em>'.
	 * @see fr.cea.nabla.ir.ir.Variable#getOutputName()
	 * @see #getVariable()
	 * @generated
	 */
	EAttribute getVariable_OutputName();

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
	 * Returns the meta object for the attribute '{@link fr.cea.nabla.ir.ir.SimpleVariable#isConst <em>Const</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Const</em>'.
	 * @see fr.cea.nabla.ir.ir.SimpleVariable#isConst()
	 * @see #getSimpleVariable()
	 * @generated
	 */
	EAttribute getSimpleVariable_Const();

	/**
	 * Returns the meta object for the attribute '{@link fr.cea.nabla.ir.ir.SimpleVariable#isConstExpr <em>Const Expr</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Const Expr</em>'.
	 * @see fr.cea.nabla.ir.ir.SimpleVariable#isConstExpr()
	 * @see #getSimpleVariable()
	 * @generated
	 */
	EAttribute getSimpleVariable_ConstExpr();

	/**
	 * Returns the meta object for the attribute '{@link fr.cea.nabla.ir.ir.SimpleVariable#isOption <em>Option</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Option</em>'.
	 * @see fr.cea.nabla.ir.ir.SimpleVariable#isOption()
	 * @see #getSimpleVariable()
	 * @generated
	 */
	EAttribute getSimpleVariable_Option();

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
	 * Returns the meta object for the attribute '{@link fr.cea.nabla.ir.ir.ConnectivityVariable#isLinearAlgebra <em>Linear Algebra</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Linear Algebra</em>'.
	 * @see fr.cea.nabla.ir.ir.ConnectivityVariable#isLinearAlgebra()
	 * @see #getConnectivityVariable()
	 * @generated
	 */
	EAttribute getConnectivityVariable_LinearAlgebra();

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
	 * Returns the meta object for the reference '{@link fr.cea.nabla.ir.ir.Function#getProvider <em>Provider</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the reference '<em>Provider</em>'.
	 * @see fr.cea.nabla.ir.ir.Function#getProvider()
	 * @see #getFunction()
	 * @generated
	 */
	EReference getFunction_Provider();

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
	 * Returns the meta object for the reference '{@link fr.cea.nabla.ir.ir.Connectivity#getReturnType <em>Return Type</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the reference '<em>Return Type</em>'.
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
	 * Returns the meta object for the attribute '{@link fr.cea.nabla.ir.ir.Connectivity#isMultiple <em>Multiple</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Multiple</em>'.
	 * @see fr.cea.nabla.ir.ir.Connectivity#isMultiple()
	 * @see #getConnectivity()
	 * @generated
	 */
	EAttribute getConnectivity_Multiple();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.JobCaller <em>Job Caller</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Job Caller</em>'.
	 * @see fr.cea.nabla.ir.ir.JobCaller
	 * @generated
	 */
	EClass getJobCaller();

	/**
	 * Returns the meta object for the reference list '{@link fr.cea.nabla.ir.ir.JobCaller#getCalls <em>Calls</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the reference list '<em>Calls</em>'.
	 * @see fr.cea.nabla.ir.ir.JobCaller#getCalls()
	 * @see #getJobCaller()
	 * @generated
	 */
	EReference getJobCaller_Calls();

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
	 * Returns the meta object for the reference '{@link fr.cea.nabla.ir.ir.Job#getCaller <em>Caller</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the reference '<em>Caller</em>'.
	 * @see fr.cea.nabla.ir.ir.Job#getCaller()
	 * @see #getJob()
	 * @generated
	 */
	EReference getJob_Caller();

	/**
	 * Returns the meta object for the reference list '{@link fr.cea.nabla.ir.ir.Job#getPreviousJobsWithSameCaller <em>Previous Jobs With Same Caller</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the reference list '<em>Previous Jobs With Same Caller</em>'.
	 * @see fr.cea.nabla.ir.ir.Job#getPreviousJobsWithSameCaller()
	 * @see #getJob()
	 * @generated
	 */
	EReference getJob_PreviousJobsWithSameCaller();

	/**
	 * Returns the meta object for the reference list '{@link fr.cea.nabla.ir.ir.Job#getNextJobsWithSameCaller <em>Next Jobs With Same Caller</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the reference list '<em>Next Jobs With Same Caller</em>'.
	 * @see fr.cea.nabla.ir.ir.Job#getNextJobsWithSameCaller()
	 * @see #getJob()
	 * @generated
	 */
	EReference getJob_NextJobsWithSameCaller();

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
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.TimeLoopJob <em>Time Loop Job</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Time Loop Job</em>'.
	 * @see fr.cea.nabla.ir.ir.TimeLoopJob
	 * @generated
	 */
	EClass getTimeLoopJob();

	/**
	 * Returns the meta object for the containment reference list '{@link fr.cea.nabla.ir.ir.TimeLoopJob#getCopies <em>Copies</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference list '<em>Copies</em>'.
	 * @see fr.cea.nabla.ir.ir.TimeLoopJob#getCopies()
	 * @see #getTimeLoopJob()
	 * @generated
	 */
	EReference getTimeLoopJob_Copies();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.ExecuteTimeLoopJob <em>Execute Time Loop Job</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Execute Time Loop Job</em>'.
	 * @see fr.cea.nabla.ir.ir.ExecuteTimeLoopJob
	 * @generated
	 */
	EClass getExecuteTimeLoopJob();

	/**
	 * Returns the meta object for the containment reference '{@link fr.cea.nabla.ir.ir.ExecuteTimeLoopJob#getWhileCondition <em>While Condition</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>While Condition</em>'.
	 * @see fr.cea.nabla.ir.ir.ExecuteTimeLoopJob#getWhileCondition()
	 * @see #getExecuteTimeLoopJob()
	 * @generated
	 */
	EReference getExecuteTimeLoopJob_WhileCondition();

	/**
	 * Returns the meta object for the reference '{@link fr.cea.nabla.ir.ir.ExecuteTimeLoopJob#getIterationCounter <em>Iteration Counter</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the reference '<em>Iteration Counter</em>'.
	 * @see fr.cea.nabla.ir.ir.ExecuteTimeLoopJob#getIterationCounter()
	 * @see #getExecuteTimeLoopJob()
	 * @generated
	 */
	EReference getExecuteTimeLoopJob_IterationCounter();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.SetUpTimeLoopJob <em>Set Up Time Loop Job</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Set Up Time Loop Job</em>'.
	 * @see fr.cea.nabla.ir.ir.SetUpTimeLoopJob
	 * @generated
	 */
	EClass getSetUpTimeLoopJob();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.TearDownTimeLoopJob <em>Tear Down Time Loop Job</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Tear Down Time Loop Job</em>'.
	 * @see fr.cea.nabla.ir.ir.TearDownTimeLoopJob
	 * @generated
	 */
	EClass getTearDownTimeLoopJob();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.TimeLoopCopy <em>Time Loop Copy</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Time Loop Copy</em>'.
	 * @see fr.cea.nabla.ir.ir.TimeLoopCopy
	 * @generated
	 */
	EClass getTimeLoopCopy();

	/**
	 * Returns the meta object for the reference '{@link fr.cea.nabla.ir.ir.TimeLoopCopy#getDestination <em>Destination</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the reference '<em>Destination</em>'.
	 * @see fr.cea.nabla.ir.ir.TimeLoopCopy#getDestination()
	 * @see #getTimeLoopCopy()
	 * @generated
	 */
	EReference getTimeLoopCopy_Destination();

	/**
	 * Returns the meta object for the reference '{@link fr.cea.nabla.ir.ir.TimeLoopCopy#getSource <em>Source</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the reference '<em>Source</em>'.
	 * @see fr.cea.nabla.ir.ir.TimeLoopCopy#getSource()
	 * @see #getTimeLoopCopy()
	 * @generated
	 */
	EReference getTimeLoopCopy_Source();

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
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.InstructionBlock <em>Instruction Block</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Instruction Block</em>'.
	 * @see fr.cea.nabla.ir.ir.InstructionBlock
	 * @generated
	 */
	EClass getInstructionBlock();

	/**
	 * Returns the meta object for the containment reference list '{@link fr.cea.nabla.ir.ir.InstructionBlock#getVariables <em>Variables</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference list '<em>Variables</em>'.
	 * @see fr.cea.nabla.ir.ir.InstructionBlock#getVariables()
	 * @see #getInstructionBlock()
	 * @generated
	 */
	EReference getInstructionBlock_Variables();

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
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.VariableDeclaration <em>Variable Declaration</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Variable Declaration</em>'.
	 * @see fr.cea.nabla.ir.ir.VariableDeclaration
	 * @generated
	 */
	EClass getVariableDeclaration();

	/**
	 * Returns the meta object for the containment reference '{@link fr.cea.nabla.ir.ir.VariableDeclaration#getVariable <em>Variable</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>Variable</em>'.
	 * @see fr.cea.nabla.ir.ir.VariableDeclaration#getVariable()
	 * @see #getVariableDeclaration()
	 * @generated
	 */
	EReference getVariableDeclaration_Variable();

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
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.ReductionInstruction <em>Reduction Instruction</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Reduction Instruction</em>'.
	 * @see fr.cea.nabla.ir.ir.ReductionInstruction
	 * @generated
	 */
	EClass getReductionInstruction();

	/**
	 * Returns the meta object for the containment reference list '{@link fr.cea.nabla.ir.ir.ReductionInstruction#getInnerInstructions <em>Inner Instructions</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference list '<em>Inner Instructions</em>'.
	 * @see fr.cea.nabla.ir.ir.ReductionInstruction#getInnerInstructions()
	 * @see #getReductionInstruction()
	 * @generated
	 */
	EReference getReductionInstruction_InnerInstructions();

	/**
	 * Returns the meta object for the reference '{@link fr.cea.nabla.ir.ir.ReductionInstruction#getBinaryFunction <em>Binary Function</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the reference '<em>Binary Function</em>'.
	 * @see fr.cea.nabla.ir.ir.ReductionInstruction#getBinaryFunction()
	 * @see #getReductionInstruction()
	 * @generated
	 */
	EReference getReductionInstruction_BinaryFunction();

	/**
	 * Returns the meta object for the containment reference '{@link fr.cea.nabla.ir.ir.ReductionInstruction#getLambda <em>Lambda</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>Lambda</em>'.
	 * @see fr.cea.nabla.ir.ir.ReductionInstruction#getLambda()
	 * @see #getReductionInstruction()
	 * @generated
	 */
	EReference getReductionInstruction_Lambda();

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
	 * Returns the meta object for the attribute '{@link fr.cea.nabla.ir.ir.Loop#isMultithreadable <em>Multithreadable</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Multithreadable</em>'.
	 * @see fr.cea.nabla.ir.ir.Loop#isMultithreadable()
	 * @see #getLoop()
	 * @generated
	 */
	EAttribute getLoop_Multithreadable();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.ItemIndexDefinition <em>Item Index Definition</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Item Index Definition</em>'.
	 * @see fr.cea.nabla.ir.ir.ItemIndexDefinition
	 * @generated
	 */
	EClass getItemIndexDefinition();

	/**
	 * Returns the meta object for the containment reference '{@link fr.cea.nabla.ir.ir.ItemIndexDefinition#getIndex <em>Index</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>Index</em>'.
	 * @see fr.cea.nabla.ir.ir.ItemIndexDefinition#getIndex()
	 * @see #getItemIndexDefinition()
	 * @generated
	 */
	EReference getItemIndexDefinition_Index();

	/**
	 * Returns the meta object for the containment reference '{@link fr.cea.nabla.ir.ir.ItemIndexDefinition#getValue <em>Value</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>Value</em>'.
	 * @see fr.cea.nabla.ir.ir.ItemIndexDefinition#getValue()
	 * @see #getItemIndexDefinition()
	 * @generated
	 */
	EReference getItemIndexDefinition_Value();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.ItemIdDefinition <em>Item Id Definition</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Item Id Definition</em>'.
	 * @see fr.cea.nabla.ir.ir.ItemIdDefinition
	 * @generated
	 */
	EClass getItemIdDefinition();

	/**
	 * Returns the meta object for the containment reference '{@link fr.cea.nabla.ir.ir.ItemIdDefinition#getId <em>Id</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>Id</em>'.
	 * @see fr.cea.nabla.ir.ir.ItemIdDefinition#getId()
	 * @see #getItemIdDefinition()
	 * @generated
	 */
	EReference getItemIdDefinition_Id();

	/**
	 * Returns the meta object for the containment reference '{@link fr.cea.nabla.ir.ir.ItemIdDefinition#getValue <em>Value</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>Value</em>'.
	 * @see fr.cea.nabla.ir.ir.ItemIdDefinition#getValue()
	 * @see #getItemIdDefinition()
	 * @generated
	 */
	EReference getItemIdDefinition_Value();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.SetDefinition <em>Set Definition</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Set Definition</em>'.
	 * @see fr.cea.nabla.ir.ir.SetDefinition
	 * @generated
	 */
	EClass getSetDefinition();

	/**
	 * Returns the meta object for the attribute '{@link fr.cea.nabla.ir.ir.SetDefinition#getName <em>Name</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Name</em>'.
	 * @see fr.cea.nabla.ir.ir.SetDefinition#getName()
	 * @see #getSetDefinition()
	 * @generated
	 */
	EAttribute getSetDefinition_Name();

	/**
	 * Returns the meta object for the containment reference '{@link fr.cea.nabla.ir.ir.SetDefinition#getValue <em>Value</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>Value</em>'.
	 * @see fr.cea.nabla.ir.ir.SetDefinition#getValue()
	 * @see #getSetDefinition()
	 * @generated
	 */
	EReference getSetDefinition_Value();

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
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.While <em>While</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>While</em>'.
	 * @see fr.cea.nabla.ir.ir.While
	 * @generated
	 */
	EClass getWhile();

	/**
	 * Returns the meta object for the containment reference '{@link fr.cea.nabla.ir.ir.While#getCondition <em>Condition</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>Condition</em>'.
	 * @see fr.cea.nabla.ir.ir.While#getCondition()
	 * @see #getWhile()
	 * @generated
	 */
	EReference getWhile_Condition();

	/**
	 * Returns the meta object for the containment reference '{@link fr.cea.nabla.ir.ir.While#getInstruction <em>Instruction</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>Instruction</em>'.
	 * @see fr.cea.nabla.ir.ir.While#getInstruction()
	 * @see #getWhile()
	 * @generated
	 */
	EReference getWhile_Instruction();

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
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.Exit <em>Exit</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Exit</em>'.
	 * @see fr.cea.nabla.ir.ir.Exit
	 * @generated
	 */
	EClass getExit();

	/**
	 * Returns the meta object for the attribute '{@link fr.cea.nabla.ir.ir.Exit#getMessage <em>Message</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Message</em>'.
	 * @see fr.cea.nabla.ir.ir.Exit#getMessage()
	 * @see #getExit()
	 * @generated
	 */
	EAttribute getExit_Message();

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
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.Iterator <em>Iterator</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Iterator</em>'.
	 * @see fr.cea.nabla.ir.ir.Iterator
	 * @generated
	 */
	EClass getIterator();

	/**
	 * Returns the meta object for the containment reference '{@link fr.cea.nabla.ir.ir.Iterator#getIndex <em>Index</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>Index</em>'.
	 * @see fr.cea.nabla.ir.ir.Iterator#getIndex()
	 * @see #getIterator()
	 * @generated
	 */
	EReference getIterator_Index();

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
	 * Returns the meta object for the containment reference '{@link fr.cea.nabla.ir.ir.Iterator#getCounter <em>Counter</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>Counter</em>'.
	 * @see fr.cea.nabla.ir.ir.Iterator#getCounter()
	 * @see #getIterator()
	 * @generated
	 */
	EReference getIterator_Counter();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.Interval <em>Interval</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Interval</em>'.
	 * @see fr.cea.nabla.ir.ir.Interval
	 * @generated
	 */
	EClass getInterval();

	/**
	 * Returns the meta object for the containment reference '{@link fr.cea.nabla.ir.ir.Interval#getIndex <em>Index</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>Index</em>'.
	 * @see fr.cea.nabla.ir.ir.Interval#getIndex()
	 * @see #getInterval()
	 * @generated
	 */
	EReference getInterval_Index();

	/**
	 * Returns the meta object for the containment reference '{@link fr.cea.nabla.ir.ir.Interval#getNbElems <em>Nb Elems</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>Nb Elems</em>'.
	 * @see fr.cea.nabla.ir.ir.Interval#getNbElems()
	 * @see #getInterval()
	 * @generated
	 */
	EReference getInterval_NbElems();

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
	 * Returns the meta object for the attribute '{@link fr.cea.nabla.ir.ir.Expression#isConstExpr <em>Const Expr</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Const Expr</em>'.
	 * @see fr.cea.nabla.ir.ir.Expression#isConstExpr()
	 * @see #getExpression()
	 * @generated
	 */
	EAttribute getExpression_ConstExpr();

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
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.Cardinality <em>Cardinality</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Cardinality</em>'.
	 * @see fr.cea.nabla.ir.ir.Cardinality
	 * @generated
	 */
	EClass getCardinality();

	/**
	 * Returns the meta object for the containment reference '{@link fr.cea.nabla.ir.ir.Cardinality#getContainer <em>Container</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>Container</em>'.
	 * @see fr.cea.nabla.ir.ir.Cardinality#getContainer()
	 * @see #getCardinality()
	 * @generated
	 */
	EReference getCardinality_Container();

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
	 * Returns the meta object for the reference list '{@link fr.cea.nabla.ir.ir.ArgOrVarRef#getIterators <em>Iterators</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the reference list '<em>Iterators</em>'.
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
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.Container <em>Container</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Container</em>'.
	 * @see fr.cea.nabla.ir.ir.Container
	 * @generated
	 */
	EClass getContainer();

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
	 * Returns the meta object for the reference list '{@link fr.cea.nabla.ir.ir.ConnectivityCall#getArgs <em>Args</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the reference list '<em>Args</em>'.
	 * @see fr.cea.nabla.ir.ir.ConnectivityCall#getArgs()
	 * @see #getConnectivityCall()
	 * @generated
	 */
	EReference getConnectivityCall_Args();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.SetRef <em>Set Ref</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Set Ref</em>'.
	 * @see fr.cea.nabla.ir.ir.SetRef
	 * @generated
	 */
	EClass getSetRef();

	/**
	 * Returns the meta object for the reference '{@link fr.cea.nabla.ir.ir.SetRef#getTarget <em>Target</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the reference '<em>Target</em>'.
	 * @see fr.cea.nabla.ir.ir.SetRef#getTarget()
	 * @see #getSetRef()
	 * @generated
	 */
	EReference getSetRef_Target();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.ItemId <em>Item Id</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Item Id</em>'.
	 * @see fr.cea.nabla.ir.ir.ItemId
	 * @generated
	 */
	EClass getItemId();

	/**
	 * Returns the meta object for the attribute '{@link fr.cea.nabla.ir.ir.ItemId#getName <em>Name</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Name</em>'.
	 * @see fr.cea.nabla.ir.ir.ItemId#getName()
	 * @see #getItemId()
	 * @generated
	 */
	EAttribute getItemId_Name();

	/**
	 * Returns the meta object for the attribute '{@link fr.cea.nabla.ir.ir.ItemId#getItemName <em>Item Name</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Item Name</em>'.
	 * @see fr.cea.nabla.ir.ir.ItemId#getItemName()
	 * @see #getItemId()
	 * @generated
	 */
	EAttribute getItemId_ItemName();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.ItemIdValue <em>Item Id Value</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Item Id Value</em>'.
	 * @see fr.cea.nabla.ir.ir.ItemIdValue
	 * @generated
	 */
	EClass getItemIdValue();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.ItemIdValueIterator <em>Item Id Value Iterator</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Item Id Value Iterator</em>'.
	 * @see fr.cea.nabla.ir.ir.ItemIdValueIterator
	 * @generated
	 */
	EClass getItemIdValueIterator();

	/**
	 * Returns the meta object for the reference '{@link fr.cea.nabla.ir.ir.ItemIdValueIterator#getIterator <em>Iterator</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the reference '<em>Iterator</em>'.
	 * @see fr.cea.nabla.ir.ir.ItemIdValueIterator#getIterator()
	 * @see #getItemIdValueIterator()
	 * @generated
	 */
	EReference getItemIdValueIterator_Iterator();

	/**
	 * Returns the meta object for the attribute '{@link fr.cea.nabla.ir.ir.ItemIdValueIterator#getShift <em>Shift</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Shift</em>'.
	 * @see fr.cea.nabla.ir.ir.ItemIdValueIterator#getShift()
	 * @see #getItemIdValueIterator()
	 * @generated
	 */
	EAttribute getItemIdValueIterator_Shift();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.ItemIdValueContainer <em>Item Id Value Container</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Item Id Value Container</em>'.
	 * @see fr.cea.nabla.ir.ir.ItemIdValueContainer
	 * @generated
	 */
	EClass getItemIdValueContainer();

	/**
	 * Returns the meta object for the containment reference '{@link fr.cea.nabla.ir.ir.ItemIdValueContainer#getContainer <em>Container</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>Container</em>'.
	 * @see fr.cea.nabla.ir.ir.ItemIdValueContainer#getContainer()
	 * @see #getItemIdValueContainer()
	 * @generated
	 */
	EReference getItemIdValueContainer_Container();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.ItemIndex <em>Item Index</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Item Index</em>'.
	 * @see fr.cea.nabla.ir.ir.ItemIndex
	 * @generated
	 */
	EClass getItemIndex();

	/**
	 * Returns the meta object for the attribute '{@link fr.cea.nabla.ir.ir.ItemIndex#getName <em>Name</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Name</em>'.
	 * @see fr.cea.nabla.ir.ir.ItemIndex#getName()
	 * @see #getItemIndex()
	 * @generated
	 */
	EAttribute getItemIndex_Name();

	/**
	 * Returns the meta object for the attribute '{@link fr.cea.nabla.ir.ir.ItemIndex#getItemName <em>Item Name</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Item Name</em>'.
	 * @see fr.cea.nabla.ir.ir.ItemIndex#getItemName()
	 * @see #getItemIndex()
	 * @generated
	 */
	EAttribute getItemIndex_ItemName();

	/**
	 * Returns the meta object for class '{@link fr.cea.nabla.ir.ir.ItemIndexValue <em>Item Index Value</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Item Index Value</em>'.
	 * @see fr.cea.nabla.ir.ir.ItemIndexValue
	 * @generated
	 */
	EClass getItemIndexValue();

	/**
	 * Returns the meta object for the reference '{@link fr.cea.nabla.ir.ir.ItemIndexValue#getId <em>Id</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the reference '<em>Id</em>'.
	 * @see fr.cea.nabla.ir.ir.ItemIndexValue#getId()
	 * @see #getItemIndexValue()
	 * @generated
	 */
	EReference getItemIndexValue_Id();

	/**
	 * Returns the meta object for the containment reference '{@link fr.cea.nabla.ir.ir.ItemIndexValue#getContainer <em>Container</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>Container</em>'.
	 * @see fr.cea.nabla.ir.ir.ItemIndexValue#getContainer()
	 * @see #getItemIndexValue()
	 * @generated
	 */
	EReference getItemIndexValue_Container();

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
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.IrRootImpl <em>Root</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.IrRootImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getIrRoot()
		 * @generated
		 */
		EClass IR_ROOT = eINSTANCE.getIrRoot();

		/**
		 * The meta object literal for the '<em><b>Name</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute IR_ROOT__NAME = eINSTANCE.getIrRoot_Name();

		/**
		 * The meta object literal for the '<em><b>Item Types</b></em>' containment reference list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference IR_ROOT__ITEM_TYPES = eINSTANCE.getIrRoot_ItemTypes();

		/**
		 * The meta object literal for the '<em><b>Connectivities</b></em>' containment reference list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference IR_ROOT__CONNECTIVITIES = eINSTANCE.getIrRoot_Connectivities();

		/**
		 * The meta object literal for the '<em><b>Functions</b></em>' reference list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference IR_ROOT__FUNCTIONS = eINSTANCE.getIrRoot_Functions();

		/**
		 * The meta object literal for the '<em><b>Variables</b></em>' reference list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference IR_ROOT__VARIABLES = eINSTANCE.getIrRoot_Variables();

		/**
		 * The meta object literal for the '<em><b>Jobs</b></em>' reference list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference IR_ROOT__JOBS = eINSTANCE.getIrRoot_Jobs();

		/**
		 * The meta object literal for the '<em><b>Main</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference IR_ROOT__MAIN = eINSTANCE.getIrRoot_Main();

		/**
		 * The meta object literal for the '<em><b>Modules</b></em>' containment reference list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference IR_ROOT__MODULES = eINSTANCE.getIrRoot_Modules();

		/**
		 * The meta object literal for the '<em><b>Mesh Class Name</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute IR_ROOT__MESH_CLASS_NAME = eINSTANCE.getIrRoot_MeshClassName();

		/**
		 * The meta object literal for the '<em><b>Init Node Coord Variable</b></em>' reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference IR_ROOT__INIT_NODE_COORD_VARIABLE = eINSTANCE.getIrRoot_InitNodeCoordVariable();

		/**
		 * The meta object literal for the '<em><b>Node Coord Variable</b></em>' reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference IR_ROOT__NODE_COORD_VARIABLE = eINSTANCE.getIrRoot_NodeCoordVariable();

		/**
		 * The meta object literal for the '<em><b>Time Variable</b></em>' reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference IR_ROOT__TIME_VARIABLE = eINSTANCE.getIrRoot_TimeVariable();

		/**
		 * The meta object literal for the '<em><b>Time Step Variable</b></em>' reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference IR_ROOT__TIME_STEP_VARIABLE = eINSTANCE.getIrRoot_TimeStepVariable();

		/**
		 * The meta object literal for the '<em><b>Post Processing</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference IR_ROOT__POST_PROCESSING = eINSTANCE.getIrRoot_PostProcessing();

		/**
		 * The meta object literal for the '<em><b>Providers</b></em>' containment reference list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference IR_ROOT__PROVIDERS = eINSTANCE.getIrRoot_Providers();

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
		 * The meta object literal for the '<em><b>Main</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute IR_MODULE__MAIN = eINSTANCE.getIrModule_Main();

		/**
		 * The meta object literal for the '<em><b>Functions</b></em>' containment reference list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference IR_MODULE__FUNCTIONS = eINSTANCE.getIrModule_Functions();

		/**
		 * The meta object literal for the '<em><b>Variables</b></em>' containment reference list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference IR_MODULE__VARIABLES = eINSTANCE.getIrModule_Variables();

		/**
		 * The meta object literal for the '<em><b>Jobs</b></em>' containment reference list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference IR_MODULE__JOBS = eINSTANCE.getIrModule_Jobs();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.PostProcessingImpl <em>Post Processing</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.PostProcessingImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getPostProcessing()
		 * @generated
		 */
		EClass POST_PROCESSING = eINSTANCE.getPostProcessing();

		/**
		 * The meta object literal for the '<em><b>Output Variables</b></em>' reference list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference POST_PROCESSING__OUTPUT_VARIABLES = eINSTANCE.getPostProcessing_OutputVariables();

		/**
		 * The meta object literal for the '<em><b>Period Reference</b></em>' reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference POST_PROCESSING__PERIOD_REFERENCE = eINSTANCE.getPostProcessing_PeriodReference();

		/**
		 * The meta object literal for the '<em><b>Period Value</b></em>' reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference POST_PROCESSING__PERIOD_VALUE = eINSTANCE.getPostProcessing_PeriodValue();

		/**
		 * The meta object literal for the '<em><b>Last Dump Variable</b></em>' reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference POST_PROCESSING__LAST_DUMP_VARIABLE = eINSTANCE.getPostProcessing_LastDumpVariable();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.ExtensionProviderImpl <em>Extension Provider</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.ExtensionProviderImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getExtensionProvider()
		 * @generated
		 */
		EClass EXTENSION_PROVIDER = eINSTANCE.getExtensionProvider();

		/**
		 * The meta object literal for the '<em><b>Extension Name</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute EXTENSION_PROVIDER__EXTENSION_NAME = eINSTANCE.getExtensionProvider_ExtensionName();

		/**
		 * The meta object literal for the '<em><b>Provider Name</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute EXTENSION_PROVIDER__PROVIDER_NAME = eINSTANCE.getExtensionProvider_ProviderName();

		/**
		 * The meta object literal for the '<em><b>Project Dir</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute EXTENSION_PROVIDER__PROJECT_DIR = eINSTANCE.getExtensionProvider_ProjectDir();

		/**
		 * The meta object literal for the '<em><b>Install Dir</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute EXTENSION_PROVIDER__INSTALL_DIR = eINSTANCE.getExtensionProvider_InstallDir();

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
		 * The meta object literal for the '<em><b>Output Name</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute VARIABLE__OUTPUT_NAME = eINSTANCE.getVariable_OutputName();

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
		 * The meta object literal for the '<em><b>Const</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute SIMPLE_VARIABLE__CONST = eINSTANCE.getSimpleVariable_Const();

		/**
		 * The meta object literal for the '<em><b>Const Expr</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute SIMPLE_VARIABLE__CONST_EXPR = eINSTANCE.getSimpleVariable_ConstExpr();

		/**
		 * The meta object literal for the '<em><b>Option</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute SIMPLE_VARIABLE__OPTION = eINSTANCE.getSimpleVariable_Option();

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
		 * The meta object literal for the '<em><b>Linear Algebra</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute CONNECTIVITY_VARIABLE__LINEAR_ALGEBRA = eINSTANCE.getConnectivityVariable_LinearAlgebra();

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
		 * The meta object literal for the '<em><b>Name</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute FUNCTION__NAME = eINSTANCE.getFunction_Name();

		/**
		 * The meta object literal for the '<em><b>Return Type</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference FUNCTION__RETURN_TYPE = eINSTANCE.getFunction_ReturnType();

		/**
		 * The meta object literal for the '<em><b>Variables</b></em>' containment reference list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference FUNCTION__VARIABLES = eINSTANCE.getFunction_Variables();

		/**
		 * The meta object literal for the '<em><b>In Args</b></em>' containment reference list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference FUNCTION__IN_ARGS = eINSTANCE.getFunction_InArgs();

		/**
		 * The meta object literal for the '<em><b>Body</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference FUNCTION__BODY = eINSTANCE.getFunction_Body();

		/**
		 * The meta object literal for the '<em><b>Provider</b></em>' reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference FUNCTION__PROVIDER = eINSTANCE.getFunction_Provider();

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
		 * The meta object literal for the '<em><b>Return Type</b></em>' reference feature.
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
		 * The meta object literal for the '<em><b>Multiple</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute CONNECTIVITY__MULTIPLE = eINSTANCE.getConnectivity_Multiple();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.JobCallerImpl <em>Job Caller</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.JobCallerImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getJobCaller()
		 * @generated
		 */
		EClass JOB_CALLER = eINSTANCE.getJobCaller();

		/**
		 * The meta object literal for the '<em><b>Calls</b></em>' reference list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference JOB_CALLER__CALLS = eINSTANCE.getJobCaller_Calls();

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
		 * The meta object literal for the '<em><b>Caller</b></em>' reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference JOB__CALLER = eINSTANCE.getJob_Caller();

		/**
		 * The meta object literal for the '<em><b>Previous Jobs With Same Caller</b></em>' reference list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference JOB__PREVIOUS_JOBS_WITH_SAME_CALLER = eINSTANCE.getJob_PreviousJobsWithSameCaller();

		/**
		 * The meta object literal for the '<em><b>Next Jobs With Same Caller</b></em>' reference list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference JOB__NEXT_JOBS_WITH_SAME_CALLER = eINSTANCE.getJob_NextJobsWithSameCaller();

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
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.TimeLoopJobImpl <em>Time Loop Job</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.TimeLoopJobImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getTimeLoopJob()
		 * @generated
		 */
		EClass TIME_LOOP_JOB = eINSTANCE.getTimeLoopJob();

		/**
		 * The meta object literal for the '<em><b>Copies</b></em>' containment reference list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference TIME_LOOP_JOB__COPIES = eINSTANCE.getTimeLoopJob_Copies();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.ExecuteTimeLoopJobImpl <em>Execute Time Loop Job</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.ExecuteTimeLoopJobImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getExecuteTimeLoopJob()
		 * @generated
		 */
		EClass EXECUTE_TIME_LOOP_JOB = eINSTANCE.getExecuteTimeLoopJob();

		/**
		 * The meta object literal for the '<em><b>While Condition</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference EXECUTE_TIME_LOOP_JOB__WHILE_CONDITION = eINSTANCE.getExecuteTimeLoopJob_WhileCondition();

		/**
		 * The meta object literal for the '<em><b>Iteration Counter</b></em>' reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference EXECUTE_TIME_LOOP_JOB__ITERATION_COUNTER = eINSTANCE.getExecuteTimeLoopJob_IterationCounter();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.SetUpTimeLoopJobImpl <em>Set Up Time Loop Job</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.SetUpTimeLoopJobImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getSetUpTimeLoopJob()
		 * @generated
		 */
		EClass SET_UP_TIME_LOOP_JOB = eINSTANCE.getSetUpTimeLoopJob();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.TearDownTimeLoopJobImpl <em>Tear Down Time Loop Job</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.TearDownTimeLoopJobImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getTearDownTimeLoopJob()
		 * @generated
		 */
		EClass TEAR_DOWN_TIME_LOOP_JOB = eINSTANCE.getTearDownTimeLoopJob();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.TimeLoopCopyImpl <em>Time Loop Copy</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.TimeLoopCopyImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getTimeLoopCopy()
		 * @generated
		 */
		EClass TIME_LOOP_COPY = eINSTANCE.getTimeLoopCopy();

		/**
		 * The meta object literal for the '<em><b>Destination</b></em>' reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference TIME_LOOP_COPY__DESTINATION = eINSTANCE.getTimeLoopCopy_Destination();

		/**
		 * The meta object literal for the '<em><b>Source</b></em>' reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference TIME_LOOP_COPY__SOURCE = eINSTANCE.getTimeLoopCopy_Source();

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
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.InstructionBlockImpl <em>Instruction Block</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.InstructionBlockImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getInstructionBlock()
		 * @generated
		 */
		EClass INSTRUCTION_BLOCK = eINSTANCE.getInstructionBlock();

		/**
		 * The meta object literal for the '<em><b>Variables</b></em>' containment reference list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference INSTRUCTION_BLOCK__VARIABLES = eINSTANCE.getInstructionBlock_Variables();

		/**
		 * The meta object literal for the '<em><b>Instructions</b></em>' containment reference list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference INSTRUCTION_BLOCK__INSTRUCTIONS = eINSTANCE.getInstructionBlock_Instructions();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.VariableDeclarationImpl <em>Variable Declaration</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.VariableDeclarationImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getVariableDeclaration()
		 * @generated
		 */
		EClass VARIABLE_DECLARATION = eINSTANCE.getVariableDeclaration();

		/**
		 * The meta object literal for the '<em><b>Variable</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference VARIABLE_DECLARATION__VARIABLE = eINSTANCE.getVariableDeclaration_Variable();

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
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.ReductionInstructionImpl <em>Reduction Instruction</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.ReductionInstructionImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getReductionInstruction()
		 * @generated
		 */
		EClass REDUCTION_INSTRUCTION = eINSTANCE.getReductionInstruction();

		/**
		 * The meta object literal for the '<em><b>Inner Instructions</b></em>' containment reference list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference REDUCTION_INSTRUCTION__INNER_INSTRUCTIONS = eINSTANCE.getReductionInstruction_InnerInstructions();

		/**
		 * The meta object literal for the '<em><b>Binary Function</b></em>' reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference REDUCTION_INSTRUCTION__BINARY_FUNCTION = eINSTANCE.getReductionInstruction_BinaryFunction();

		/**
		 * The meta object literal for the '<em><b>Lambda</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference REDUCTION_INSTRUCTION__LAMBDA = eINSTANCE.getReductionInstruction_Lambda();

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
		 * The meta object literal for the '<em><b>Multithreadable</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute LOOP__MULTITHREADABLE = eINSTANCE.getLoop_Multithreadable();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.ItemIndexDefinitionImpl <em>Item Index Definition</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.ItemIndexDefinitionImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getItemIndexDefinition()
		 * @generated
		 */
		EClass ITEM_INDEX_DEFINITION = eINSTANCE.getItemIndexDefinition();

		/**
		 * The meta object literal for the '<em><b>Index</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference ITEM_INDEX_DEFINITION__INDEX = eINSTANCE.getItemIndexDefinition_Index();

		/**
		 * The meta object literal for the '<em><b>Value</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference ITEM_INDEX_DEFINITION__VALUE = eINSTANCE.getItemIndexDefinition_Value();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.ItemIdDefinitionImpl <em>Item Id Definition</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.ItemIdDefinitionImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getItemIdDefinition()
		 * @generated
		 */
		EClass ITEM_ID_DEFINITION = eINSTANCE.getItemIdDefinition();

		/**
		 * The meta object literal for the '<em><b>Id</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference ITEM_ID_DEFINITION__ID = eINSTANCE.getItemIdDefinition_Id();

		/**
		 * The meta object literal for the '<em><b>Value</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference ITEM_ID_DEFINITION__VALUE = eINSTANCE.getItemIdDefinition_Value();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.SetDefinitionImpl <em>Set Definition</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.SetDefinitionImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getSetDefinition()
		 * @generated
		 */
		EClass SET_DEFINITION = eINSTANCE.getSetDefinition();

		/**
		 * The meta object literal for the '<em><b>Name</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute SET_DEFINITION__NAME = eINSTANCE.getSetDefinition_Name();

		/**
		 * The meta object literal for the '<em><b>Value</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference SET_DEFINITION__VALUE = eINSTANCE.getSetDefinition_Value();

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
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.WhileImpl <em>While</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.WhileImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getWhile()
		 * @generated
		 */
		EClass WHILE = eINSTANCE.getWhile();

		/**
		 * The meta object literal for the '<em><b>Condition</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference WHILE__CONDITION = eINSTANCE.getWhile_Condition();

		/**
		 * The meta object literal for the '<em><b>Instruction</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference WHILE__INSTRUCTION = eINSTANCE.getWhile_Instruction();

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
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.ExitImpl <em>Exit</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.ExitImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getExit()
		 * @generated
		 */
		EClass EXIT = eINSTANCE.getExit();

		/**
		 * The meta object literal for the '<em><b>Message</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute EXIT__MESSAGE = eINSTANCE.getExit_Message();

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
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.IteratorImpl <em>Iterator</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.IteratorImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getIterator()
		 * @generated
		 */
		EClass ITERATOR = eINSTANCE.getIterator();

		/**
		 * The meta object literal for the '<em><b>Index</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference ITERATOR__INDEX = eINSTANCE.getIterator_Index();

		/**
		 * The meta object literal for the '<em><b>Container</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference ITERATOR__CONTAINER = eINSTANCE.getIterator_Container();

		/**
		 * The meta object literal for the '<em><b>Counter</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference ITERATOR__COUNTER = eINSTANCE.getIterator_Counter();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.IntervalImpl <em>Interval</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.IntervalImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getInterval()
		 * @generated
		 */
		EClass INTERVAL = eINSTANCE.getInterval();

		/**
		 * The meta object literal for the '<em><b>Index</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference INTERVAL__INDEX = eINSTANCE.getInterval_Index();

		/**
		 * The meta object literal for the '<em><b>Nb Elems</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference INTERVAL__NB_ELEMS = eINSTANCE.getInterval_NbElems();

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
		 * The meta object literal for the '<em><b>Const Expr</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute EXPRESSION__CONST_EXPR = eINSTANCE.getExpression_ConstExpr();

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
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.CardinalityImpl <em>Cardinality</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.CardinalityImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getCardinality()
		 * @generated
		 */
		EClass CARDINALITY = eINSTANCE.getCardinality();

		/**
		 * The meta object literal for the '<em><b>Container</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference CARDINALITY__CONTAINER = eINSTANCE.getCardinality_Container();

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
		 * The meta object literal for the '<em><b>Iterators</b></em>' reference list feature.
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
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.ContainerImpl <em>Container</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.ContainerImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getContainer()
		 * @generated
		 */
		EClass CONTAINER = eINSTANCE.getContainer();

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
		 * The meta object literal for the '<em><b>Args</b></em>' reference list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference CONNECTIVITY_CALL__ARGS = eINSTANCE.getConnectivityCall_Args();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.SetRefImpl <em>Set Ref</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.SetRefImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getSetRef()
		 * @generated
		 */
		EClass SET_REF = eINSTANCE.getSetRef();

		/**
		 * The meta object literal for the '<em><b>Target</b></em>' reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference SET_REF__TARGET = eINSTANCE.getSetRef_Target();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.ItemIdImpl <em>Item Id</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.ItemIdImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getItemId()
		 * @generated
		 */
		EClass ITEM_ID = eINSTANCE.getItemId();

		/**
		 * The meta object literal for the '<em><b>Name</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute ITEM_ID__NAME = eINSTANCE.getItemId_Name();

		/**
		 * The meta object literal for the '<em><b>Item Name</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute ITEM_ID__ITEM_NAME = eINSTANCE.getItemId_ItemName();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.ItemIdValueImpl <em>Item Id Value</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.ItemIdValueImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getItemIdValue()
		 * @generated
		 */
		EClass ITEM_ID_VALUE = eINSTANCE.getItemIdValue();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.ItemIdValueIteratorImpl <em>Item Id Value Iterator</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.ItemIdValueIteratorImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getItemIdValueIterator()
		 * @generated
		 */
		EClass ITEM_ID_VALUE_ITERATOR = eINSTANCE.getItemIdValueIterator();

		/**
		 * The meta object literal for the '<em><b>Iterator</b></em>' reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference ITEM_ID_VALUE_ITERATOR__ITERATOR = eINSTANCE.getItemIdValueIterator_Iterator();

		/**
		 * The meta object literal for the '<em><b>Shift</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute ITEM_ID_VALUE_ITERATOR__SHIFT = eINSTANCE.getItemIdValueIterator_Shift();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.ItemIdValueContainerImpl <em>Item Id Value Container</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.ItemIdValueContainerImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getItemIdValueContainer()
		 * @generated
		 */
		EClass ITEM_ID_VALUE_CONTAINER = eINSTANCE.getItemIdValueContainer();

		/**
		 * The meta object literal for the '<em><b>Container</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference ITEM_ID_VALUE_CONTAINER__CONTAINER = eINSTANCE.getItemIdValueContainer_Container();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.ItemIndexImpl <em>Item Index</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.ItemIndexImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getItemIndex()
		 * @generated
		 */
		EClass ITEM_INDEX = eINSTANCE.getItemIndex();

		/**
		 * The meta object literal for the '<em><b>Name</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute ITEM_INDEX__NAME = eINSTANCE.getItemIndex_Name();

		/**
		 * The meta object literal for the '<em><b>Item Name</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute ITEM_INDEX__ITEM_NAME = eINSTANCE.getItemIndex_ItemName();

		/**
		 * The meta object literal for the '{@link fr.cea.nabla.ir.ir.impl.ItemIndexValueImpl <em>Item Index Value</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see fr.cea.nabla.ir.ir.impl.ItemIndexValueImpl
		 * @see fr.cea.nabla.ir.ir.impl.IrPackageImpl#getItemIndexValue()
		 * @generated
		 */
		EClass ITEM_INDEX_VALUE = eINSTANCE.getItemIndexValue();

		/**
		 * The meta object literal for the '<em><b>Id</b></em>' reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference ITEM_INDEX_VALUE__ID = eINSTANCE.getItemIndexValue_Id();

		/**
		 * The meta object literal for the '<em><b>Container</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference ITEM_INDEX_VALUE__CONTAINER = eINSTANCE.getItemIndexValue_Container();

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
