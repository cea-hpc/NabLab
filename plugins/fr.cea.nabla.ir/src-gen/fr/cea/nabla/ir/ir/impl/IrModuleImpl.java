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
import fr.cea.nabla.ir.ir.Reduction;
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
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IrModuleImpl#getItems <em>Items</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IrModuleImpl#getFunctions <em>Functions</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IrModuleImpl#getReductions <em>Reductions</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IrModuleImpl#getConnectivities <em>Connectivities</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IrModuleImpl#getVariables <em>Variables</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IrModuleImpl#getInitNodeCoordVariable <em>Init Node Coord Variable</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IrModuleImpl#getNodeCoordVariable <em>Node Coord Variable</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IrModuleImpl#getTimeVariable <em>Time Variable</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IrModuleImpl#getJobs <em>Jobs</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IrModuleImpl#getMainTimeLoop <em>Main Time Loop</em>}</li>
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
	 * The cached value of the '{@link #getItems() <em>Items</em>}' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getItems()
	 * @generated
	 * @ordered
	 */
	protected EList<ItemType> items;

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
	 * The cached value of the '{@link #getReductions() <em>Reductions</em>}' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getReductions()
	 * @generated
	 * @ordered
	 */
	protected EList<Reduction> reductions;

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
	 * The cached value of the '{@link #getVariables() <em>Variables</em>}' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getVariables()
	 * @generated
	 * @ordered
	 */
	protected EList<Variable> variables;

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
	public EList<ItemType> getItems() {
		if (items == null) {
			items = new EObjectContainmentEList.Resolving<ItemType>(ItemType.class, this, IrPackage.IR_MODULE__ITEMS);
		}
		return items;
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
	public EList<Reduction> getReductions() {
		if (reductions == null) {
			reductions = new EObjectContainmentEList<Reduction>(Reduction.class, this, IrPackage.IR_MODULE__REDUCTIONS);
		}
		return reductions;
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
	public NotificationChain eInverseRemove(InternalEObject otherEnd, int featureID, NotificationChain msgs) {
		switch (featureID) {
			case IrPackage.IR_MODULE__IMPORTS:
				return ((InternalEList<?>)getImports()).basicRemove(otherEnd, msgs);
			case IrPackage.IR_MODULE__ITEMS:
				return ((InternalEList<?>)getItems()).basicRemove(otherEnd, msgs);
			case IrPackage.IR_MODULE__FUNCTIONS:
				return ((InternalEList<?>)getFunctions()).basicRemove(otherEnd, msgs);
			case IrPackage.IR_MODULE__REDUCTIONS:
				return ((InternalEList<?>)getReductions()).basicRemove(otherEnd, msgs);
			case IrPackage.IR_MODULE__CONNECTIVITIES:
				return ((InternalEList<?>)getConnectivities()).basicRemove(otherEnd, msgs);
			case IrPackage.IR_MODULE__VARIABLES:
				return ((InternalEList<?>)getVariables()).basicRemove(otherEnd, msgs);
			case IrPackage.IR_MODULE__JOBS:
				return ((InternalEList<?>)getJobs()).basicRemove(otherEnd, msgs);
			case IrPackage.IR_MODULE__MAIN_TIME_LOOP:
				return basicSetMainTimeLoop(null, msgs);
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
			case IrPackage.IR_MODULE__ITEMS:
				return getItems();
			case IrPackage.IR_MODULE__FUNCTIONS:
				return getFunctions();
			case IrPackage.IR_MODULE__REDUCTIONS:
				return getReductions();
			case IrPackage.IR_MODULE__CONNECTIVITIES:
				return getConnectivities();
			case IrPackage.IR_MODULE__VARIABLES:
				return getVariables();
			case IrPackage.IR_MODULE__INIT_NODE_COORD_VARIABLE:
				if (resolve) return getInitNodeCoordVariable();
				return basicGetInitNodeCoordVariable();
			case IrPackage.IR_MODULE__NODE_COORD_VARIABLE:
				if (resolve) return getNodeCoordVariable();
				return basicGetNodeCoordVariable();
			case IrPackage.IR_MODULE__TIME_VARIABLE:
				if (resolve) return getTimeVariable();
				return basicGetTimeVariable();
			case IrPackage.IR_MODULE__JOBS:
				return getJobs();
			case IrPackage.IR_MODULE__MAIN_TIME_LOOP:
				if (resolve) return getMainTimeLoop();
				return basicGetMainTimeLoop();
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
			case IrPackage.IR_MODULE__ITEMS:
				getItems().clear();
				getItems().addAll((Collection<? extends ItemType>)newValue);
				return;
			case IrPackage.IR_MODULE__FUNCTIONS:
				getFunctions().clear();
				getFunctions().addAll((Collection<? extends Function>)newValue);
				return;
			case IrPackage.IR_MODULE__REDUCTIONS:
				getReductions().clear();
				getReductions().addAll((Collection<? extends Reduction>)newValue);
				return;
			case IrPackage.IR_MODULE__CONNECTIVITIES:
				getConnectivities().clear();
				getConnectivities().addAll((Collection<? extends Connectivity>)newValue);
				return;
			case IrPackage.IR_MODULE__VARIABLES:
				getVariables().clear();
				getVariables().addAll((Collection<? extends Variable>)newValue);
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
			case IrPackage.IR_MODULE__JOBS:
				getJobs().clear();
				getJobs().addAll((Collection<? extends Job>)newValue);
				return;
			case IrPackage.IR_MODULE__MAIN_TIME_LOOP:
				setMainTimeLoop((TimeLoop)newValue);
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
			case IrPackage.IR_MODULE__ITEMS:
				getItems().clear();
				return;
			case IrPackage.IR_MODULE__FUNCTIONS:
				getFunctions().clear();
				return;
			case IrPackage.IR_MODULE__REDUCTIONS:
				getReductions().clear();
				return;
			case IrPackage.IR_MODULE__CONNECTIVITIES:
				getConnectivities().clear();
				return;
			case IrPackage.IR_MODULE__VARIABLES:
				getVariables().clear();
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
			case IrPackage.IR_MODULE__JOBS:
				getJobs().clear();
				return;
			case IrPackage.IR_MODULE__MAIN_TIME_LOOP:
				setMainTimeLoop((TimeLoop)null);
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
			case IrPackage.IR_MODULE__ITEMS:
				return items != null && !items.isEmpty();
			case IrPackage.IR_MODULE__FUNCTIONS:
				return functions != null && !functions.isEmpty();
			case IrPackage.IR_MODULE__REDUCTIONS:
				return reductions != null && !reductions.isEmpty();
			case IrPackage.IR_MODULE__CONNECTIVITIES:
				return connectivities != null && !connectivities.isEmpty();
			case IrPackage.IR_MODULE__VARIABLES:
				return variables != null && !variables.isEmpty();
			case IrPackage.IR_MODULE__INIT_NODE_COORD_VARIABLE:
				return initNodeCoordVariable != null;
			case IrPackage.IR_MODULE__NODE_COORD_VARIABLE:
				return nodeCoordVariable != null;
			case IrPackage.IR_MODULE__TIME_VARIABLE:
				return timeVariable != null;
			case IrPackage.IR_MODULE__JOBS:
				return jobs != null && !jobs.isEmpty();
			case IrPackage.IR_MODULE__MAIN_TIME_LOOP:
				return mainTimeLoop != null;
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

} //IrModuleImpl
