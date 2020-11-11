/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.Connectivity;
import fr.cea.nabla.ir.ir.ConnectivityVariable;
import fr.cea.nabla.ir.ir.Function;
import fr.cea.nabla.ir.ir.Import;
import fr.cea.nabla.ir.ir.IrModule;
import fr.cea.nabla.ir.ir.IrPackage;
import fr.cea.nabla.ir.ir.ItemType;
import fr.cea.nabla.ir.ir.Job;
import fr.cea.nabla.ir.ir.JobCaller;
import fr.cea.nabla.ir.ir.PostProcessing;
import fr.cea.nabla.ir.ir.SimpleVariable;
import fr.cea.nabla.ir.ir.Variable;

import java.util.Collection;

import org.eclipse.emf.common.notify.Notification;
import org.eclipse.emf.common.notify.NotificationChain;

import org.eclipse.emf.common.util.EList;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;

import org.eclipse.emf.ecore.impl.ENotificationImpl;

import org.eclipse.emf.ecore.util.EObjectContainmentEList;
import org.eclipse.emf.ecore.util.InternalEList;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Module</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IrModuleImpl#getName <em>Name</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IrModuleImpl#getImports <em>Imports</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IrModuleImpl#getItemTypes <em>Item Types</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IrModuleImpl#getFunctions <em>Functions</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IrModuleImpl#getConnectivities <em>Connectivities</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IrModuleImpl#getOptions <em>Options</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IrModuleImpl#getVariables <em>Variables</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IrModuleImpl#getMeshClassName <em>Mesh Class Name</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IrModuleImpl#getInitNodeCoordVariable <em>Init Node Coord Variable</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IrModuleImpl#getNodeCoordVariable <em>Node Coord Variable</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IrModuleImpl#getTimeVariable <em>Time Variable</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IrModuleImpl#getTimeStepVariable <em>Time Step Variable</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IrModuleImpl#getJobs <em>Jobs</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IrModuleImpl#getPostProcessing <em>Post Processing</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IrModuleImpl#getMain <em>Main</em>}</li>
 * </ul>
 *
 * @generated
 */
public class IrModuleImpl extends IrAnnotableImpl implements IrModule {
	/**
	 * The default value of the '{@link #getName() <em>Name</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getName()
	 * @generated
	 * @ordered
	 */
	protected static final String NAME_EDEFAULT = null;

	/**
	 * The cached value of the '{@link #getName() <em>Name</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getName()
	 * @generated
	 * @ordered
	 */
	protected String name = NAME_EDEFAULT;

	/**
	 * The cached value of the '{@link #getImports() <em>Imports</em>}' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getImports()
	 * @generated
	 * @ordered
	 */
	protected EList<Import> imports;

	/**
	 * The cached value of the '{@link #getItemTypes() <em>Item Types</em>}' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getItemTypes()
	 * @generated
	 * @ordered
	 */
	protected EList<ItemType> itemTypes;

	/**
	 * The cached value of the '{@link #getFunctions() <em>Functions</em>}' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getFunctions()
	 * @generated
	 * @ordered
	 */
	protected EList<Function> functions;

	/**
	 * The cached value of the '{@link #getConnectivities() <em>Connectivities</em>}' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getConnectivities()
	 * @generated
	 * @ordered
	 */
	protected EList<Connectivity> connectivities;

	/**
	 * The cached value of the '{@link #getOptions() <em>Options</em>}' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getOptions()
	 * @generated
	 * @ordered
	 */
	protected EList<SimpleVariable> options;

	/**
	 * The cached value of the '{@link #getVariables() <em>Variables</em>}' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getVariables()
	 * @generated
	 * @ordered
	 */
	protected EList<Variable> variables;

	/**
	 * The default value of the '{@link #getMeshClassName() <em>Mesh Class Name</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getMeshClassName()
	 * @generated
	 * @ordered
	 */
	protected static final String MESH_CLASS_NAME_EDEFAULT = null;

	/**
	 * The cached value of the '{@link #getMeshClassName() <em>Mesh Class Name</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getMeshClassName()
	 * @generated
	 * @ordered
	 */
	protected String meshClassName = MESH_CLASS_NAME_EDEFAULT;

	/**
	 * The cached value of the '{@link #getInitNodeCoordVariable() <em>Init Node Coord Variable</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getInitNodeCoordVariable()
	 * @generated
	 * @ordered
	 */
	protected ConnectivityVariable initNodeCoordVariable;

	/**
	 * The cached value of the '{@link #getNodeCoordVariable() <em>Node Coord Variable</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getNodeCoordVariable()
	 * @generated
	 * @ordered
	 */
	protected ConnectivityVariable nodeCoordVariable;

	/**
	 * The cached value of the '{@link #getTimeVariable() <em>Time Variable</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getTimeVariable()
	 * @generated
	 * @ordered
	 */
	protected SimpleVariable timeVariable;

	/**
	 * The cached value of the '{@link #getTimeStepVariable() <em>Time Step Variable</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getTimeStepVariable()
	 * @generated
	 * @ordered
	 */
	protected SimpleVariable timeStepVariable;

	/**
	 * The cached value of the '{@link #getJobs() <em>Jobs</em>}' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getJobs()
	 * @generated
	 * @ordered
	 */
	protected EList<Job> jobs;

	/**
	 * The cached value of the '{@link #getPostProcessing() <em>Post Processing</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getPostProcessing()
	 * @generated
	 * @ordered
	 */
	protected PostProcessing postProcessing;

	/**
	 * The cached value of the '{@link #getMain() <em>Main</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getMain()
	 * @generated
	 * @ordered
	 */
	protected JobCaller main;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected IrModuleImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return IrPackage.Literals.IR_MODULE;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public String getName() {
		return name;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setName(String newName) {
		String oldName = name;
		name = newName;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.IR_MODULE__NAME, oldName, name));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public EList<Import> getImports() {
		if (imports == null) {
			imports = new EObjectContainmentEList<Import>(Import.class, this, IrPackage.IR_MODULE__IMPORTS);
		}
		return imports;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public EList<ItemType> getItemTypes() {
		if (itemTypes == null) {
			itemTypes = new EObjectContainmentEList.Resolving<ItemType>(ItemType.class, this, IrPackage.IR_MODULE__ITEM_TYPES);
		}
		return itemTypes;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public EList<Function> getFunctions() {
		if (functions == null) {
			functions = new EObjectContainmentEList<Function>(Function.class, this, IrPackage.IR_MODULE__FUNCTIONS);
		}
		return functions;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public EList<Connectivity> getConnectivities() {
		if (connectivities == null) {
			connectivities = new EObjectContainmentEList<Connectivity>(Connectivity.class, this, IrPackage.IR_MODULE__CONNECTIVITIES);
		}
		return connectivities;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public EList<SimpleVariable> getOptions() {
		if (options == null) {
			options = new EObjectContainmentEList.Resolving<SimpleVariable>(SimpleVariable.class, this, IrPackage.IR_MODULE__OPTIONS);
		}
		return options;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public EList<Variable> getVariables() {
		if (variables == null) {
			variables = new EObjectContainmentEList<Variable>(Variable.class, this, IrPackage.IR_MODULE__VARIABLES);
		}
		return variables;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public String getMeshClassName() {
		return meshClassName;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setMeshClassName(String newMeshClassName) {
		String oldMeshClassName = meshClassName;
		meshClassName = newMeshClassName;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.IR_MODULE__MESH_CLASS_NAME, oldMeshClassName, meshClassName));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public ConnectivityVariable getInitNodeCoordVariable() {
		if (initNodeCoordVariable != null && initNodeCoordVariable.eIsProxy()) {
			InternalEObject oldInitNodeCoordVariable = (InternalEObject)initNodeCoordVariable;
			initNodeCoordVariable = (ConnectivityVariable)eResolveProxy(oldInitNodeCoordVariable);
			if (initNodeCoordVariable != oldInitNodeCoordVariable) {
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.IR_MODULE__INIT_NODE_COORD_VARIABLE, oldInitNodeCoordVariable, initNodeCoordVariable));
			}
		}
		return initNodeCoordVariable;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public ConnectivityVariable basicGetInitNodeCoordVariable() {
		return initNodeCoordVariable;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setInitNodeCoordVariable(ConnectivityVariable newInitNodeCoordVariable) {
		ConnectivityVariable oldInitNodeCoordVariable = initNodeCoordVariable;
		initNodeCoordVariable = newInitNodeCoordVariable;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.IR_MODULE__INIT_NODE_COORD_VARIABLE, oldInitNodeCoordVariable, initNodeCoordVariable));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public ConnectivityVariable getNodeCoordVariable() {
		if (nodeCoordVariable != null && nodeCoordVariable.eIsProxy()) {
			InternalEObject oldNodeCoordVariable = (InternalEObject)nodeCoordVariable;
			nodeCoordVariable = (ConnectivityVariable)eResolveProxy(oldNodeCoordVariable);
			if (nodeCoordVariable != oldNodeCoordVariable) {
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.IR_MODULE__NODE_COORD_VARIABLE, oldNodeCoordVariable, nodeCoordVariable));
			}
		}
		return nodeCoordVariable;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public ConnectivityVariable basicGetNodeCoordVariable() {
		return nodeCoordVariable;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setNodeCoordVariable(ConnectivityVariable newNodeCoordVariable) {
		ConnectivityVariable oldNodeCoordVariable = nodeCoordVariable;
		nodeCoordVariable = newNodeCoordVariable;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.IR_MODULE__NODE_COORD_VARIABLE, oldNodeCoordVariable, nodeCoordVariable));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public SimpleVariable getTimeVariable() {
		if (timeVariable != null && timeVariable.eIsProxy()) {
			InternalEObject oldTimeVariable = (InternalEObject)timeVariable;
			timeVariable = (SimpleVariable)eResolveProxy(oldTimeVariable);
			if (timeVariable != oldTimeVariable) {
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.IR_MODULE__TIME_VARIABLE, oldTimeVariable, timeVariable));
			}
		}
		return timeVariable;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public SimpleVariable basicGetTimeVariable() {
		return timeVariable;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setTimeVariable(SimpleVariable newTimeVariable) {
		SimpleVariable oldTimeVariable = timeVariable;
		timeVariable = newTimeVariable;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.IR_MODULE__TIME_VARIABLE, oldTimeVariable, timeVariable));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public SimpleVariable getTimeStepVariable() {
		if (timeStepVariable != null && timeStepVariable.eIsProxy()) {
			InternalEObject oldTimeStepVariable = (InternalEObject)timeStepVariable;
			timeStepVariable = (SimpleVariable)eResolveProxy(oldTimeStepVariable);
			if (timeStepVariable != oldTimeStepVariable) {
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.IR_MODULE__TIME_STEP_VARIABLE, oldTimeStepVariable, timeStepVariable));
			}
		}
		return timeStepVariable;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public SimpleVariable basicGetTimeStepVariable() {
		return timeStepVariable;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setTimeStepVariable(SimpleVariable newTimeStepVariable) {
		SimpleVariable oldTimeStepVariable = timeStepVariable;
		timeStepVariable = newTimeStepVariable;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.IR_MODULE__TIME_STEP_VARIABLE, oldTimeStepVariable, timeStepVariable));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public EList<Job> getJobs() {
		if (jobs == null) {
			jobs = new EObjectContainmentEList<Job>(Job.class, this, IrPackage.IR_MODULE__JOBS);
		}
		return jobs;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public PostProcessing getPostProcessing() {
		if (postProcessing != null && postProcessing.eIsProxy()) {
			InternalEObject oldPostProcessing = (InternalEObject)postProcessing;
			postProcessing = (PostProcessing)eResolveProxy(oldPostProcessing);
			if (postProcessing != oldPostProcessing) {
				InternalEObject newPostProcessing = (InternalEObject)postProcessing;
				NotificationChain msgs = oldPostProcessing.eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.IR_MODULE__POST_PROCESSING, null, null);
				if (newPostProcessing.eInternalContainer() == null) {
					msgs = newPostProcessing.eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.IR_MODULE__POST_PROCESSING, null, msgs);
				}
				if (msgs != null) msgs.dispatch();
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.IR_MODULE__POST_PROCESSING, oldPostProcessing, postProcessing));
			}
		}
		return postProcessing;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public PostProcessing basicGetPostProcessing() {
		return postProcessing;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetPostProcessing(PostProcessing newPostProcessing, NotificationChain msgs) {
		PostProcessing oldPostProcessing = postProcessing;
		postProcessing = newPostProcessing;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.IR_MODULE__POST_PROCESSING, oldPostProcessing, newPostProcessing);
			if (msgs == null) msgs = notification; else msgs.add(notification);
		}
		return msgs;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setPostProcessing(PostProcessing newPostProcessing) {
		if (newPostProcessing != postProcessing) {
			NotificationChain msgs = null;
			if (postProcessing != null)
				msgs = ((InternalEObject)postProcessing).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.IR_MODULE__POST_PROCESSING, null, msgs);
			if (newPostProcessing != null)
				msgs = ((InternalEObject)newPostProcessing).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.IR_MODULE__POST_PROCESSING, null, msgs);
			msgs = basicSetPostProcessing(newPostProcessing, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.IR_MODULE__POST_PROCESSING, newPostProcessing, newPostProcessing));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public JobCaller getMain() {
		if (main != null && main.eIsProxy()) {
			InternalEObject oldMain = (InternalEObject)main;
			main = (JobCaller)eResolveProxy(oldMain);
			if (main != oldMain) {
				InternalEObject newMain = (InternalEObject)main;
				NotificationChain msgs = oldMain.eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.IR_MODULE__MAIN, null, null);
				if (newMain.eInternalContainer() == null) {
					msgs = newMain.eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.IR_MODULE__MAIN, null, msgs);
				}
				if (msgs != null) msgs.dispatch();
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.IR_MODULE__MAIN, oldMain, main));
			}
		}
		return main;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public JobCaller basicGetMain() {
		return main;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetMain(JobCaller newMain, NotificationChain msgs) {
		JobCaller oldMain = main;
		main = newMain;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.IR_MODULE__MAIN, oldMain, newMain);
			if (msgs == null) msgs = notification; else msgs.add(notification);
		}
		return msgs;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setMain(JobCaller newMain) {
		if (newMain != main) {
			NotificationChain msgs = null;
			if (main != null)
				msgs = ((InternalEObject)main).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.IR_MODULE__MAIN, null, msgs);
			if (newMain != null)
				msgs = ((InternalEObject)newMain).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.IR_MODULE__MAIN, null, msgs);
			msgs = basicSetMain(newMain, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.IR_MODULE__MAIN, newMain, newMain));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public NotificationChain eInverseRemove(InternalEObject otherEnd, int featureID, NotificationChain msgs) {
		switch (featureID) {
			case IrPackage.IR_MODULE__IMPORTS:
				return ((InternalEList<?>)getImports()).basicRemove(otherEnd, msgs);
			case IrPackage.IR_MODULE__ITEM_TYPES:
				return ((InternalEList<?>)getItemTypes()).basicRemove(otherEnd, msgs);
			case IrPackage.IR_MODULE__FUNCTIONS:
				return ((InternalEList<?>)getFunctions()).basicRemove(otherEnd, msgs);
			case IrPackage.IR_MODULE__CONNECTIVITIES:
				return ((InternalEList<?>)getConnectivities()).basicRemove(otherEnd, msgs);
			case IrPackage.IR_MODULE__OPTIONS:
				return ((InternalEList<?>)getOptions()).basicRemove(otherEnd, msgs);
			case IrPackage.IR_MODULE__VARIABLES:
				return ((InternalEList<?>)getVariables()).basicRemove(otherEnd, msgs);
			case IrPackage.IR_MODULE__JOBS:
				return ((InternalEList<?>)getJobs()).basicRemove(otherEnd, msgs);
			case IrPackage.IR_MODULE__POST_PROCESSING:
				return basicSetPostProcessing(null, msgs);
			case IrPackage.IR_MODULE__MAIN:
				return basicSetMain(null, msgs);
		}
		return super.eInverseRemove(otherEnd, featureID, msgs);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Object eGet(int featureID, boolean resolve, boolean coreType) {
		switch (featureID) {
			case IrPackage.IR_MODULE__NAME:
				return getName();
			case IrPackage.IR_MODULE__IMPORTS:
				return getImports();
			case IrPackage.IR_MODULE__ITEM_TYPES:
				return getItemTypes();
			case IrPackage.IR_MODULE__FUNCTIONS:
				return getFunctions();
			case IrPackage.IR_MODULE__CONNECTIVITIES:
				return getConnectivities();
			case IrPackage.IR_MODULE__OPTIONS:
				return getOptions();
			case IrPackage.IR_MODULE__VARIABLES:
				return getVariables();
			case IrPackage.IR_MODULE__MESH_CLASS_NAME:
				return getMeshClassName();
			case IrPackage.IR_MODULE__INIT_NODE_COORD_VARIABLE:
				if (resolve) return getInitNodeCoordVariable();
				return basicGetInitNodeCoordVariable();
			case IrPackage.IR_MODULE__NODE_COORD_VARIABLE:
				if (resolve) return getNodeCoordVariable();
				return basicGetNodeCoordVariable();
			case IrPackage.IR_MODULE__TIME_VARIABLE:
				if (resolve) return getTimeVariable();
				return basicGetTimeVariable();
			case IrPackage.IR_MODULE__TIME_STEP_VARIABLE:
				if (resolve) return getTimeStepVariable();
				return basicGetTimeStepVariable();
			case IrPackage.IR_MODULE__JOBS:
				return getJobs();
			case IrPackage.IR_MODULE__POST_PROCESSING:
				if (resolve) return getPostProcessing();
				return basicGetPostProcessing();
			case IrPackage.IR_MODULE__MAIN:
				if (resolve) return getMain();
				return basicGetMain();
		}
		return super.eGet(featureID, resolve, coreType);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void eSet(int featureID, Object newValue) {
		switch (featureID) {
			case IrPackage.IR_MODULE__NAME:
				setName((String)newValue);
				return;
			case IrPackage.IR_MODULE__IMPORTS:
				getImports().clear();
				getImports().addAll((Collection<? extends Import>)newValue);
				return;
			case IrPackage.IR_MODULE__ITEM_TYPES:
				getItemTypes().clear();
				getItemTypes().addAll((Collection<? extends ItemType>)newValue);
				return;
			case IrPackage.IR_MODULE__FUNCTIONS:
				getFunctions().clear();
				getFunctions().addAll((Collection<? extends Function>)newValue);
				return;
			case IrPackage.IR_MODULE__CONNECTIVITIES:
				getConnectivities().clear();
				getConnectivities().addAll((Collection<? extends Connectivity>)newValue);
				return;
			case IrPackage.IR_MODULE__OPTIONS:
				getOptions().clear();
				getOptions().addAll((Collection<? extends SimpleVariable>)newValue);
				return;
			case IrPackage.IR_MODULE__VARIABLES:
				getVariables().clear();
				getVariables().addAll((Collection<? extends Variable>)newValue);
				return;
			case IrPackage.IR_MODULE__MESH_CLASS_NAME:
				setMeshClassName((String)newValue);
				return;
			case IrPackage.IR_MODULE__INIT_NODE_COORD_VARIABLE:
				setInitNodeCoordVariable((ConnectivityVariable)newValue);
				return;
			case IrPackage.IR_MODULE__NODE_COORD_VARIABLE:
				setNodeCoordVariable((ConnectivityVariable)newValue);
				return;
			case IrPackage.IR_MODULE__TIME_VARIABLE:
				setTimeVariable((SimpleVariable)newValue);
				return;
			case IrPackage.IR_MODULE__TIME_STEP_VARIABLE:
				setTimeStepVariable((SimpleVariable)newValue);
				return;
			case IrPackage.IR_MODULE__JOBS:
				getJobs().clear();
				getJobs().addAll((Collection<? extends Job>)newValue);
				return;
			case IrPackage.IR_MODULE__POST_PROCESSING:
				setPostProcessing((PostProcessing)newValue);
				return;
			case IrPackage.IR_MODULE__MAIN:
				setMain((JobCaller)newValue);
				return;
		}
		super.eSet(featureID, newValue);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void eUnset(int featureID) {
		switch (featureID) {
			case IrPackage.IR_MODULE__NAME:
				setName(NAME_EDEFAULT);
				return;
			case IrPackage.IR_MODULE__IMPORTS:
				getImports().clear();
				return;
			case IrPackage.IR_MODULE__ITEM_TYPES:
				getItemTypes().clear();
				return;
			case IrPackage.IR_MODULE__FUNCTIONS:
				getFunctions().clear();
				return;
			case IrPackage.IR_MODULE__CONNECTIVITIES:
				getConnectivities().clear();
				return;
			case IrPackage.IR_MODULE__OPTIONS:
				getOptions().clear();
				return;
			case IrPackage.IR_MODULE__VARIABLES:
				getVariables().clear();
				return;
			case IrPackage.IR_MODULE__MESH_CLASS_NAME:
				setMeshClassName(MESH_CLASS_NAME_EDEFAULT);
				return;
			case IrPackage.IR_MODULE__INIT_NODE_COORD_VARIABLE:
				setInitNodeCoordVariable((ConnectivityVariable)null);
				return;
			case IrPackage.IR_MODULE__NODE_COORD_VARIABLE:
				setNodeCoordVariable((ConnectivityVariable)null);
				return;
			case IrPackage.IR_MODULE__TIME_VARIABLE:
				setTimeVariable((SimpleVariable)null);
				return;
			case IrPackage.IR_MODULE__TIME_STEP_VARIABLE:
				setTimeStepVariable((SimpleVariable)null);
				return;
			case IrPackage.IR_MODULE__JOBS:
				getJobs().clear();
				return;
			case IrPackage.IR_MODULE__POST_PROCESSING:
				setPostProcessing((PostProcessing)null);
				return;
			case IrPackage.IR_MODULE__MAIN:
				setMain((JobCaller)null);
				return;
		}
		super.eUnset(featureID);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public boolean eIsSet(int featureID) {
		switch (featureID) {
			case IrPackage.IR_MODULE__NAME:
				return NAME_EDEFAULT == null ? name != null : !NAME_EDEFAULT.equals(name);
			case IrPackage.IR_MODULE__IMPORTS:
				return imports != null && !imports.isEmpty();
			case IrPackage.IR_MODULE__ITEM_TYPES:
				return itemTypes != null && !itemTypes.isEmpty();
			case IrPackage.IR_MODULE__FUNCTIONS:
				return functions != null && !functions.isEmpty();
			case IrPackage.IR_MODULE__CONNECTIVITIES:
				return connectivities != null && !connectivities.isEmpty();
			case IrPackage.IR_MODULE__OPTIONS:
				return options != null && !options.isEmpty();
			case IrPackage.IR_MODULE__VARIABLES:
				return variables != null && !variables.isEmpty();
			case IrPackage.IR_MODULE__MESH_CLASS_NAME:
				return MESH_CLASS_NAME_EDEFAULT == null ? meshClassName != null : !MESH_CLASS_NAME_EDEFAULT.equals(meshClassName);
			case IrPackage.IR_MODULE__INIT_NODE_COORD_VARIABLE:
				return initNodeCoordVariable != null;
			case IrPackage.IR_MODULE__NODE_COORD_VARIABLE:
				return nodeCoordVariable != null;
			case IrPackage.IR_MODULE__TIME_VARIABLE:
				return timeVariable != null;
			case IrPackage.IR_MODULE__TIME_STEP_VARIABLE:
				return timeStepVariable != null;
			case IrPackage.IR_MODULE__JOBS:
				return jobs != null && !jobs.isEmpty();
			case IrPackage.IR_MODULE__POST_PROCESSING:
				return postProcessing != null;
			case IrPackage.IR_MODULE__MAIN:
				return main != null;
		}
		return super.eIsSet(featureID);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public String toString() {
		if (eIsProxy()) return super.toString();

		StringBuilder result = new StringBuilder(super.toString());
		result.append(" (name: ");
		result.append(name);
		result.append(", meshClassName: ");
		result.append(meshClassName);
		result.append(')');
		return result.toString();
	}

} //IrModuleImpl
