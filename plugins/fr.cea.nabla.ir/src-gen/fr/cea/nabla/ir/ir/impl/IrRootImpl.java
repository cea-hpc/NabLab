/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.ExtensionProvider;
import fr.cea.nabla.ir.ir.IrModule;
import fr.cea.nabla.ir.ir.IrPackage;
import fr.cea.nabla.ir.ir.IrRoot;
import fr.cea.nabla.ir.ir.Job;
import fr.cea.nabla.ir.ir.JobCaller;
import fr.cea.nabla.ir.ir.PostProcessing;
import fr.cea.nabla.ir.ir.TimeIterator;
import fr.cea.nabla.ir.ir.Variable;

import java.util.Collection;

import org.eclipse.emf.common.notify.Notification;
import org.eclipse.emf.common.notify.NotificationChain;

import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;

import org.eclipse.emf.ecore.impl.ENotificationImpl;
import org.eclipse.emf.ecore.util.EObjectContainmentEList;
import org.eclipse.emf.ecore.util.EObjectEList;
import org.eclipse.emf.ecore.util.InternalEList;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Root</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IrRootImpl#getName <em>Name</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IrRootImpl#getVariables <em>Variables</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IrRootImpl#getJobs <em>Jobs</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IrRootImpl#getMain <em>Main</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IrRootImpl#getModules <em>Modules</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IrRootImpl#getInitNodeCoordVariable <em>Init Node Coord Variable</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IrRootImpl#getNodeCoordVariable <em>Node Coord Variable</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IrRootImpl#getCurrentTimeVariable <em>Current Time Variable</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IrRootImpl#getNextTimeVariable <em>Next Time Variable</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IrRootImpl#getTimeStepVariable <em>Time Step Variable</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IrRootImpl#getPostProcessing <em>Post Processing</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IrRootImpl#getProviders <em>Providers</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IrRootImpl#getTimeIterators <em>Time Iterators</em>}</li>
 * </ul>
 *
 * @generated
 */
public class IrRootImpl extends IrAnnotableImpl implements IrRoot {
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
	 * The cached value of the '{@link #getVariables() <em>Variables</em>}' reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getVariables()
	 * @generated
	 * @ordered
	 */
	protected EList<Variable> variables;

	/**
	 * The cached value of the '{@link #getJobs() <em>Jobs</em>}' reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getJobs()
	 * @generated
	 * @ordered
	 */
	protected EList<Job> jobs;

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
	 * The cached value of the '{@link #getModules() <em>Modules</em>}' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getModules()
	 * @generated
	 * @ordered
	 */
	protected EList<IrModule> modules;

	/**
	 * The cached value of the '{@link #getInitNodeCoordVariable() <em>Init Node Coord Variable</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getInitNodeCoordVariable()
	 * @generated
	 * @ordered
	 */
	protected Variable initNodeCoordVariable;

	/**
	 * The cached value of the '{@link #getNodeCoordVariable() <em>Node Coord Variable</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getNodeCoordVariable()
	 * @generated
	 * @ordered
	 */
	protected Variable nodeCoordVariable;

	/**
	 * The cached value of the '{@link #getCurrentTimeVariable() <em>Current Time Variable</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getCurrentTimeVariable()
	 * @generated
	 * @ordered
	 */
	protected Variable currentTimeVariable;

	/**
	 * The cached value of the '{@link #getNextTimeVariable() <em>Next Time Variable</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getNextTimeVariable()
	 * @generated
	 * @ordered
	 */
	protected Variable nextTimeVariable;

	/**
	 * The cached value of the '{@link #getTimeStepVariable() <em>Time Step Variable</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getTimeStepVariable()
	 * @generated
	 * @ordered
	 */
	protected Variable timeStepVariable;

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
	 * The cached value of the '{@link #getProviders() <em>Providers</em>}' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getProviders()
	 * @generated
	 * @ordered
	 */
	protected EList<ExtensionProvider> providers;

	/**
	 * The cached value of the '{@link #getTimeIterators() <em>Time Iterators</em>}' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getTimeIterators()
	 * @generated
	 * @ordered
	 */
	protected EList<TimeIterator> timeIterators;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected IrRootImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return IrPackage.Literals.IR_ROOT;
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
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.IR_ROOT__NAME, oldName, name));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public EList<Variable> getVariables() {
		if (variables == null) {
			variables = new EObjectEList<Variable>(Variable.class, this, IrPackage.IR_ROOT__VARIABLES);
		}
		return variables;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public EList<Job> getJobs() {
		if (jobs == null) {
			jobs = new EObjectEList<Job>(Job.class, this, IrPackage.IR_ROOT__JOBS);
		}
		return jobs;
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
				NotificationChain msgs = oldMain.eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.IR_ROOT__MAIN, null, null);
				if (newMain.eInternalContainer() == null) {
					msgs = newMain.eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.IR_ROOT__MAIN, null, msgs);
				}
				if (msgs != null) msgs.dispatch();
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.IR_ROOT__MAIN, oldMain, main));
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
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.IR_ROOT__MAIN, oldMain, newMain);
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
				msgs = ((InternalEObject)main).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.IR_ROOT__MAIN, null, msgs);
			if (newMain != null)
				msgs = ((InternalEObject)newMain).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.IR_ROOT__MAIN, null, msgs);
			msgs = basicSetMain(newMain, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.IR_ROOT__MAIN, newMain, newMain));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public EList<IrModule> getModules() {
		if (modules == null) {
			modules = new EObjectContainmentEList.Resolving<IrModule>(IrModule.class, this, IrPackage.IR_ROOT__MODULES);
		}
		return modules;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Variable getInitNodeCoordVariable() {
		if (initNodeCoordVariable != null && initNodeCoordVariable.eIsProxy()) {
			InternalEObject oldInitNodeCoordVariable = (InternalEObject)initNodeCoordVariable;
			initNodeCoordVariable = (Variable)eResolveProxy(oldInitNodeCoordVariable);
			if (initNodeCoordVariable != oldInitNodeCoordVariable) {
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.IR_ROOT__INIT_NODE_COORD_VARIABLE, oldInitNodeCoordVariable, initNodeCoordVariable));
			}
		}
		return initNodeCoordVariable;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Variable basicGetInitNodeCoordVariable() {
		return initNodeCoordVariable;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setInitNodeCoordVariable(Variable newInitNodeCoordVariable) {
		Variable oldInitNodeCoordVariable = initNodeCoordVariable;
		initNodeCoordVariable = newInitNodeCoordVariable;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.IR_ROOT__INIT_NODE_COORD_VARIABLE, oldInitNodeCoordVariable, initNodeCoordVariable));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Variable getNodeCoordVariable() {
		if (nodeCoordVariable != null && nodeCoordVariable.eIsProxy()) {
			InternalEObject oldNodeCoordVariable = (InternalEObject)nodeCoordVariable;
			nodeCoordVariable = (Variable)eResolveProxy(oldNodeCoordVariable);
			if (nodeCoordVariable != oldNodeCoordVariable) {
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.IR_ROOT__NODE_COORD_VARIABLE, oldNodeCoordVariable, nodeCoordVariable));
			}
		}
		return nodeCoordVariable;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Variable basicGetNodeCoordVariable() {
		return nodeCoordVariable;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setNodeCoordVariable(Variable newNodeCoordVariable) {
		Variable oldNodeCoordVariable = nodeCoordVariable;
		nodeCoordVariable = newNodeCoordVariable;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.IR_ROOT__NODE_COORD_VARIABLE, oldNodeCoordVariable, nodeCoordVariable));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Variable getCurrentTimeVariable() {
		if (currentTimeVariable != null && currentTimeVariable.eIsProxy()) {
			InternalEObject oldCurrentTimeVariable = (InternalEObject)currentTimeVariable;
			currentTimeVariable = (Variable)eResolveProxy(oldCurrentTimeVariable);
			if (currentTimeVariable != oldCurrentTimeVariable) {
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.IR_ROOT__CURRENT_TIME_VARIABLE, oldCurrentTimeVariable, currentTimeVariable));
			}
		}
		return currentTimeVariable;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Variable basicGetCurrentTimeVariable() {
		return currentTimeVariable;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setCurrentTimeVariable(Variable newCurrentTimeVariable) {
		Variable oldCurrentTimeVariable = currentTimeVariable;
		currentTimeVariable = newCurrentTimeVariable;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.IR_ROOT__CURRENT_TIME_VARIABLE, oldCurrentTimeVariable, currentTimeVariable));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Variable getNextTimeVariable() {
		if (nextTimeVariable != null && nextTimeVariable.eIsProxy()) {
			InternalEObject oldNextTimeVariable = (InternalEObject)nextTimeVariable;
			nextTimeVariable = (Variable)eResolveProxy(oldNextTimeVariable);
			if (nextTimeVariable != oldNextTimeVariable) {
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.IR_ROOT__NEXT_TIME_VARIABLE, oldNextTimeVariable, nextTimeVariable));
			}
		}
		return nextTimeVariable;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Variable basicGetNextTimeVariable() {
		return nextTimeVariable;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setNextTimeVariable(Variable newNextTimeVariable) {
		Variable oldNextTimeVariable = nextTimeVariable;
		nextTimeVariable = newNextTimeVariable;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.IR_ROOT__NEXT_TIME_VARIABLE, oldNextTimeVariable, nextTimeVariable));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Variable getTimeStepVariable() {
		if (timeStepVariable != null && timeStepVariable.eIsProxy()) {
			InternalEObject oldTimeStepVariable = (InternalEObject)timeStepVariable;
			timeStepVariable = (Variable)eResolveProxy(oldTimeStepVariable);
			if (timeStepVariable != oldTimeStepVariable) {
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.IR_ROOT__TIME_STEP_VARIABLE, oldTimeStepVariable, timeStepVariable));
			}
		}
		return timeStepVariable;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Variable basicGetTimeStepVariable() {
		return timeStepVariable;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setTimeStepVariable(Variable newTimeStepVariable) {
		Variable oldTimeStepVariable = timeStepVariable;
		timeStepVariable = newTimeStepVariable;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.IR_ROOT__TIME_STEP_VARIABLE, oldTimeStepVariable, timeStepVariable));
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
				NotificationChain msgs = oldPostProcessing.eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.IR_ROOT__POST_PROCESSING, null, null);
				if (newPostProcessing.eInternalContainer() == null) {
					msgs = newPostProcessing.eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.IR_ROOT__POST_PROCESSING, null, msgs);
				}
				if (msgs != null) msgs.dispatch();
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.IR_ROOT__POST_PROCESSING, oldPostProcessing, postProcessing));
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
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.IR_ROOT__POST_PROCESSING, oldPostProcessing, newPostProcessing);
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
				msgs = ((InternalEObject)postProcessing).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.IR_ROOT__POST_PROCESSING, null, msgs);
			if (newPostProcessing != null)
				msgs = ((InternalEObject)newPostProcessing).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.IR_ROOT__POST_PROCESSING, null, msgs);
			msgs = basicSetPostProcessing(newPostProcessing, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.IR_ROOT__POST_PROCESSING, newPostProcessing, newPostProcessing));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public EList<ExtensionProvider> getProviders() {
		if (providers == null) {
			providers = new EObjectContainmentEList.Resolving<ExtensionProvider>(ExtensionProvider.class, this, IrPackage.IR_ROOT__PROVIDERS);
		}
		return providers;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public EList<TimeIterator> getTimeIterators() {
		if (timeIterators == null) {
			timeIterators = new EObjectContainmentEList.Resolving<TimeIterator>(TimeIterator.class, this, IrPackage.IR_ROOT__TIME_ITERATORS);
		}
		return timeIterators;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public NotificationChain eInverseRemove(InternalEObject otherEnd, int featureID, NotificationChain msgs) {
		switch (featureID) {
			case IrPackage.IR_ROOT__MAIN:
				return basicSetMain(null, msgs);
			case IrPackage.IR_ROOT__MODULES:
				return ((InternalEList<?>)getModules()).basicRemove(otherEnd, msgs);
			case IrPackage.IR_ROOT__POST_PROCESSING:
				return basicSetPostProcessing(null, msgs);
			case IrPackage.IR_ROOT__PROVIDERS:
				return ((InternalEList<?>)getProviders()).basicRemove(otherEnd, msgs);
			case IrPackage.IR_ROOT__TIME_ITERATORS:
				return ((InternalEList<?>)getTimeIterators()).basicRemove(otherEnd, msgs);
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
			case IrPackage.IR_ROOT__NAME:
				return getName();
			case IrPackage.IR_ROOT__VARIABLES:
				return getVariables();
			case IrPackage.IR_ROOT__JOBS:
				return getJobs();
			case IrPackage.IR_ROOT__MAIN:
				if (resolve) return getMain();
				return basicGetMain();
			case IrPackage.IR_ROOT__MODULES:
				return getModules();
			case IrPackage.IR_ROOT__INIT_NODE_COORD_VARIABLE:
				if (resolve) return getInitNodeCoordVariable();
				return basicGetInitNodeCoordVariable();
			case IrPackage.IR_ROOT__NODE_COORD_VARIABLE:
				if (resolve) return getNodeCoordVariable();
				return basicGetNodeCoordVariable();
			case IrPackage.IR_ROOT__CURRENT_TIME_VARIABLE:
				if (resolve) return getCurrentTimeVariable();
				return basicGetCurrentTimeVariable();
			case IrPackage.IR_ROOT__NEXT_TIME_VARIABLE:
				if (resolve) return getNextTimeVariable();
				return basicGetNextTimeVariable();
			case IrPackage.IR_ROOT__TIME_STEP_VARIABLE:
				if (resolve) return getTimeStepVariable();
				return basicGetTimeStepVariable();
			case IrPackage.IR_ROOT__POST_PROCESSING:
				if (resolve) return getPostProcessing();
				return basicGetPostProcessing();
			case IrPackage.IR_ROOT__PROVIDERS:
				return getProviders();
			case IrPackage.IR_ROOT__TIME_ITERATORS:
				return getTimeIterators();
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
			case IrPackage.IR_ROOT__NAME:
				setName((String)newValue);
				return;
			case IrPackage.IR_ROOT__VARIABLES:
				getVariables().clear();
				getVariables().addAll((Collection<? extends Variable>)newValue);
				return;
			case IrPackage.IR_ROOT__JOBS:
				getJobs().clear();
				getJobs().addAll((Collection<? extends Job>)newValue);
				return;
			case IrPackage.IR_ROOT__MAIN:
				setMain((JobCaller)newValue);
				return;
			case IrPackage.IR_ROOT__MODULES:
				getModules().clear();
				getModules().addAll((Collection<? extends IrModule>)newValue);
				return;
			case IrPackage.IR_ROOT__INIT_NODE_COORD_VARIABLE:
				setInitNodeCoordVariable((Variable)newValue);
				return;
			case IrPackage.IR_ROOT__NODE_COORD_VARIABLE:
				setNodeCoordVariable((Variable)newValue);
				return;
			case IrPackage.IR_ROOT__CURRENT_TIME_VARIABLE:
				setCurrentTimeVariable((Variable)newValue);
				return;
			case IrPackage.IR_ROOT__NEXT_TIME_VARIABLE:
				setNextTimeVariable((Variable)newValue);
				return;
			case IrPackage.IR_ROOT__TIME_STEP_VARIABLE:
				setTimeStepVariable((Variable)newValue);
				return;
			case IrPackage.IR_ROOT__POST_PROCESSING:
				setPostProcessing((PostProcessing)newValue);
				return;
			case IrPackage.IR_ROOT__PROVIDERS:
				getProviders().clear();
				getProviders().addAll((Collection<? extends ExtensionProvider>)newValue);
				return;
			case IrPackage.IR_ROOT__TIME_ITERATORS:
				getTimeIterators().clear();
				getTimeIterators().addAll((Collection<? extends TimeIterator>)newValue);
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
			case IrPackage.IR_ROOT__NAME:
				setName(NAME_EDEFAULT);
				return;
			case IrPackage.IR_ROOT__VARIABLES:
				getVariables().clear();
				return;
			case IrPackage.IR_ROOT__JOBS:
				getJobs().clear();
				return;
			case IrPackage.IR_ROOT__MAIN:
				setMain((JobCaller)null);
				return;
			case IrPackage.IR_ROOT__MODULES:
				getModules().clear();
				return;
			case IrPackage.IR_ROOT__INIT_NODE_COORD_VARIABLE:
				setInitNodeCoordVariable((Variable)null);
				return;
			case IrPackage.IR_ROOT__NODE_COORD_VARIABLE:
				setNodeCoordVariable((Variable)null);
				return;
			case IrPackage.IR_ROOT__CURRENT_TIME_VARIABLE:
				setCurrentTimeVariable((Variable)null);
				return;
			case IrPackage.IR_ROOT__NEXT_TIME_VARIABLE:
				setNextTimeVariable((Variable)null);
				return;
			case IrPackage.IR_ROOT__TIME_STEP_VARIABLE:
				setTimeStepVariable((Variable)null);
				return;
			case IrPackage.IR_ROOT__POST_PROCESSING:
				setPostProcessing((PostProcessing)null);
				return;
			case IrPackage.IR_ROOT__PROVIDERS:
				getProviders().clear();
				return;
			case IrPackage.IR_ROOT__TIME_ITERATORS:
				getTimeIterators().clear();
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
			case IrPackage.IR_ROOT__NAME:
				return NAME_EDEFAULT == null ? name != null : !NAME_EDEFAULT.equals(name);
			case IrPackage.IR_ROOT__VARIABLES:
				return variables != null && !variables.isEmpty();
			case IrPackage.IR_ROOT__JOBS:
				return jobs != null && !jobs.isEmpty();
			case IrPackage.IR_ROOT__MAIN:
				return main != null;
			case IrPackage.IR_ROOT__MODULES:
				return modules != null && !modules.isEmpty();
			case IrPackage.IR_ROOT__INIT_NODE_COORD_VARIABLE:
				return initNodeCoordVariable != null;
			case IrPackage.IR_ROOT__NODE_COORD_VARIABLE:
				return nodeCoordVariable != null;
			case IrPackage.IR_ROOT__CURRENT_TIME_VARIABLE:
				return currentTimeVariable != null;
			case IrPackage.IR_ROOT__NEXT_TIME_VARIABLE:
				return nextTimeVariable != null;
			case IrPackage.IR_ROOT__TIME_STEP_VARIABLE:
				return timeStepVariable != null;
			case IrPackage.IR_ROOT__POST_PROCESSING:
				return postProcessing != null;
			case IrPackage.IR_ROOT__PROVIDERS:
				return providers != null && !providers.isEmpty();
			case IrPackage.IR_ROOT__TIME_ITERATORS:
				return timeIterators != null && !timeIterators.isEmpty();
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
		result.append(')');
		return result.toString();
	}

} //IrRootImpl
