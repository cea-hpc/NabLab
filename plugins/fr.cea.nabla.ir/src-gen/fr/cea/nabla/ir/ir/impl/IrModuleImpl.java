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
import fr.cea.nabla.ir.ir.PostProcessingInfo;
import fr.cea.nabla.ir.ir.SimpleVariable;
import fr.cea.nabla.ir.ir.TimeLoop;
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
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IrModuleImpl#getDeltatVariable <em>Deltat Variable</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IrModuleImpl#getJobs <em>Jobs</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IrModuleImpl#getMainTimeLoop <em>Main Time Loop</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IrModuleImpl#getPostProcessingInfo <em>Post Processing Info</em>}</li>
 * </ul>
 *
 * @generated
 */
public class IrModuleImpl extends JobContainerImpl implements IrModule {
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
	 * The cached value of the '{@link #getDeltatVariable() <em>Deltat Variable</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getDeltatVariable()
	 * @generated
	 * @ordered
	 */
	protected SimpleVariable deltatVariable;

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
	 * The cached value of the '{@link #getMainTimeLoop() <em>Main Time Loop</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getMainTimeLoop()
	 * @generated
	 * @ordered
	 */
	protected TimeLoop mainTimeLoop;

	/**
	 * The cached value of the '{@link #getPostProcessingInfo() <em>Post Processing Info</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getPostProcessingInfo()
	 * @generated
	 * @ordered
	 */
	protected PostProcessingInfo postProcessingInfo;

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
	public SimpleVariable getDeltatVariable() {
		if (deltatVariable != null && deltatVariable.eIsProxy()) {
			InternalEObject oldDeltatVariable = (InternalEObject)deltatVariable;
			deltatVariable = (SimpleVariable)eResolveProxy(oldDeltatVariable);
			if (deltatVariable != oldDeltatVariable) {
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.IR_MODULE__DELTAT_VARIABLE, oldDeltatVariable, deltatVariable));
			}
		}
		return deltatVariable;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public SimpleVariable basicGetDeltatVariable() {
		return deltatVariable;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setDeltatVariable(SimpleVariable newDeltatVariable) {
		SimpleVariable oldDeltatVariable = deltatVariable;
		deltatVariable = newDeltatVariable;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.IR_MODULE__DELTAT_VARIABLE, oldDeltatVariable, deltatVariable));
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
	public TimeLoop getMainTimeLoop() {
		if (mainTimeLoop != null && mainTimeLoop.eIsProxy()) {
			InternalEObject oldMainTimeLoop = (InternalEObject)mainTimeLoop;
			mainTimeLoop = (TimeLoop)eResolveProxy(oldMainTimeLoop);
			if (mainTimeLoop != oldMainTimeLoop) {
				InternalEObject newMainTimeLoop = (InternalEObject)mainTimeLoop;
				NotificationChain msgs = oldMainTimeLoop.eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.IR_MODULE__MAIN_TIME_LOOP, null, null);
				if (newMainTimeLoop.eInternalContainer() == null) {
					msgs = newMainTimeLoop.eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.IR_MODULE__MAIN_TIME_LOOP, null, msgs);
				}
				if (msgs != null) msgs.dispatch();
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.IR_MODULE__MAIN_TIME_LOOP, oldMainTimeLoop, mainTimeLoop));
			}
		}
		return mainTimeLoop;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public TimeLoop basicGetMainTimeLoop() {
		return mainTimeLoop;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetMainTimeLoop(TimeLoop newMainTimeLoop, NotificationChain msgs) {
		TimeLoop oldMainTimeLoop = mainTimeLoop;
		mainTimeLoop = newMainTimeLoop;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.IR_MODULE__MAIN_TIME_LOOP, oldMainTimeLoop, newMainTimeLoop);
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
	public void setMainTimeLoop(TimeLoop newMainTimeLoop) {
		if (newMainTimeLoop != mainTimeLoop) {
			NotificationChain msgs = null;
			if (mainTimeLoop != null)
				msgs = ((InternalEObject)mainTimeLoop).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.IR_MODULE__MAIN_TIME_LOOP, null, msgs);
			if (newMainTimeLoop != null)
				msgs = ((InternalEObject)newMainTimeLoop).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.IR_MODULE__MAIN_TIME_LOOP, null, msgs);
			msgs = basicSetMainTimeLoop(newMainTimeLoop, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.IR_MODULE__MAIN_TIME_LOOP, newMainTimeLoop, newMainTimeLoop));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public PostProcessingInfo getPostProcessingInfo() {
		if (postProcessingInfo != null && postProcessingInfo.eIsProxy()) {
			InternalEObject oldPostProcessingInfo = (InternalEObject)postProcessingInfo;
			postProcessingInfo = (PostProcessingInfo)eResolveProxy(oldPostProcessingInfo);
			if (postProcessingInfo != oldPostProcessingInfo) {
				InternalEObject newPostProcessingInfo = (InternalEObject)postProcessingInfo;
				NotificationChain msgs = oldPostProcessingInfo.eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.IR_MODULE__POST_PROCESSING_INFO, null, null);
				if (newPostProcessingInfo.eInternalContainer() == null) {
					msgs = newPostProcessingInfo.eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.IR_MODULE__POST_PROCESSING_INFO, null, msgs);
				}
				if (msgs != null) msgs.dispatch();
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.IR_MODULE__POST_PROCESSING_INFO, oldPostProcessingInfo, postProcessingInfo));
			}
		}
		return postProcessingInfo;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public PostProcessingInfo basicGetPostProcessingInfo() {
		return postProcessingInfo;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetPostProcessingInfo(PostProcessingInfo newPostProcessingInfo, NotificationChain msgs) {
		PostProcessingInfo oldPostProcessingInfo = postProcessingInfo;
		postProcessingInfo = newPostProcessingInfo;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.IR_MODULE__POST_PROCESSING_INFO, oldPostProcessingInfo, newPostProcessingInfo);
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
	public void setPostProcessingInfo(PostProcessingInfo newPostProcessingInfo) {
		if (newPostProcessingInfo != postProcessingInfo) {
			NotificationChain msgs = null;
			if (postProcessingInfo != null)
				msgs = ((InternalEObject)postProcessingInfo).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.IR_MODULE__POST_PROCESSING_INFO, null, msgs);
			if (newPostProcessingInfo != null)
				msgs = ((InternalEObject)newPostProcessingInfo).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.IR_MODULE__POST_PROCESSING_INFO, null, msgs);
			msgs = basicSetPostProcessingInfo(newPostProcessingInfo, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.IR_MODULE__POST_PROCESSING_INFO, newPostProcessingInfo, newPostProcessingInfo));
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
			case IrPackage.IR_MODULE__MAIN_TIME_LOOP:
				return basicSetMainTimeLoop(null, msgs);
			case IrPackage.IR_MODULE__POST_PROCESSING_INFO:
				return basicSetPostProcessingInfo(null, msgs);
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
			case IrPackage.IR_MODULE__DELTAT_VARIABLE:
				if (resolve) return getDeltatVariable();
				return basicGetDeltatVariable();
			case IrPackage.IR_MODULE__JOBS:
				return getJobs();
			case IrPackage.IR_MODULE__MAIN_TIME_LOOP:
				if (resolve) return getMainTimeLoop();
				return basicGetMainTimeLoop();
			case IrPackage.IR_MODULE__POST_PROCESSING_INFO:
				if (resolve) return getPostProcessingInfo();
				return basicGetPostProcessingInfo();
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
			case IrPackage.IR_MODULE__DELTAT_VARIABLE:
				setDeltatVariable((SimpleVariable)newValue);
				return;
			case IrPackage.IR_MODULE__JOBS:
				getJobs().clear();
				getJobs().addAll((Collection<? extends Job>)newValue);
				return;
			case IrPackage.IR_MODULE__MAIN_TIME_LOOP:
				setMainTimeLoop((TimeLoop)newValue);
				return;
			case IrPackage.IR_MODULE__POST_PROCESSING_INFO:
				setPostProcessingInfo((PostProcessingInfo)newValue);
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
			case IrPackage.IR_MODULE__DELTAT_VARIABLE:
				setDeltatVariable((SimpleVariable)null);
				return;
			case IrPackage.IR_MODULE__JOBS:
				getJobs().clear();
				return;
			case IrPackage.IR_MODULE__MAIN_TIME_LOOP:
				setMainTimeLoop((TimeLoop)null);
				return;
			case IrPackage.IR_MODULE__POST_PROCESSING_INFO:
				setPostProcessingInfo((PostProcessingInfo)null);
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
			case IrPackage.IR_MODULE__DELTAT_VARIABLE:
				return deltatVariable != null;
			case IrPackage.IR_MODULE__JOBS:
				return jobs != null && !jobs.isEmpty();
			case IrPackage.IR_MODULE__MAIN_TIME_LOOP:
				return mainTimeLoop != null;
			case IrPackage.IR_MODULE__POST_PROCESSING_INFO:
				return postProcessingInfo != null;
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
