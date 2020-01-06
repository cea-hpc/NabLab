/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.Expression;
import fr.cea.nabla.ir.ir.IrPackage;
import fr.cea.nabla.ir.ir.SimpleVariable;
import fr.cea.nabla.ir.ir.TimeLoop;
import fr.cea.nabla.ir.ir.TimeLoopJob;
import fr.cea.nabla.ir.ir.TimeLoopVariable;

import java.util.Collection;

import org.eclipse.emf.common.notify.Notification;
import org.eclipse.emf.common.notify.NotificationChain;

import org.eclipse.emf.common.util.EList;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;

import org.eclipse.emf.ecore.impl.ENotificationImpl;

import org.eclipse.emf.ecore.util.EObjectContainmentEList;
import org.eclipse.emf.ecore.util.EcoreUtil;
import org.eclipse.emf.ecore.util.InternalEList;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Time Loop</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.TimeLoopImpl#getName <em>Name</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.TimeLoopImpl#getInnerTimeLoop <em>Inner Time Loop</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.TimeLoopImpl#getOuterTimeLoop <em>Outer Time Loop</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.TimeLoopImpl#getVariables <em>Variables</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.TimeLoopImpl#getWhileCondition <em>While Condition</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.TimeLoopImpl#getAssociatedJob <em>Associated Job</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.TimeLoopImpl#getCounter <em>Counter</em>}</li>
 * </ul>
 *
 * @generated
 */
public class TimeLoopImpl extends IrAnnotableImpl implements TimeLoop {
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
	 * The cached value of the '{@link #getInnerTimeLoop() <em>Inner Time Loop</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getInnerTimeLoop()
	 * @generated
	 * @ordered
	 */
	protected TimeLoop innerTimeLoop;

	/**
	 * The cached value of the '{@link #getVariables() <em>Variables</em>}' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getVariables()
	 * @generated
	 * @ordered
	 */
	protected EList<TimeLoopVariable> variables;

	/**
	 * The cached value of the '{@link #getWhileCondition() <em>While Condition</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getWhileCondition()
	 * @generated
	 * @ordered
	 */
	protected Expression whileCondition;

	/**
	 * The cached value of the '{@link #getAssociatedJob() <em>Associated Job</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getAssociatedJob()
	 * @generated
	 * @ordered
	 */
	protected TimeLoopJob associatedJob;

	/**
	 * The cached value of the '{@link #getCounter() <em>Counter</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getCounter()
	 * @generated
	 * @ordered
	 */
	protected SimpleVariable counter;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected TimeLoopImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return IrPackage.Literals.TIME_LOOP;
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
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.TIME_LOOP__NAME, oldName, name));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public TimeLoop getInnerTimeLoop() {
		if (innerTimeLoop != null && innerTimeLoop.eIsProxy()) {
			InternalEObject oldInnerTimeLoop = (InternalEObject)innerTimeLoop;
			innerTimeLoop = (TimeLoop)eResolveProxy(oldInnerTimeLoop);
			if (innerTimeLoop != oldInnerTimeLoop) {
				InternalEObject newInnerTimeLoop = (InternalEObject)innerTimeLoop;
				NotificationChain msgs =  oldInnerTimeLoop.eInverseRemove(this, IrPackage.TIME_LOOP__OUTER_TIME_LOOP, TimeLoop.class, null);
				if (newInnerTimeLoop.eInternalContainer() == null) {
					msgs =  newInnerTimeLoop.eInverseAdd(this, IrPackage.TIME_LOOP__OUTER_TIME_LOOP, TimeLoop.class, msgs);
				}
				if (msgs != null) msgs.dispatch();
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.TIME_LOOP__INNER_TIME_LOOP, oldInnerTimeLoop, innerTimeLoop));
			}
		}
		return innerTimeLoop;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public TimeLoop basicGetInnerTimeLoop() {
		return innerTimeLoop;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetInnerTimeLoop(TimeLoop newInnerTimeLoop, NotificationChain msgs) {
		TimeLoop oldInnerTimeLoop = innerTimeLoop;
		innerTimeLoop = newInnerTimeLoop;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.TIME_LOOP__INNER_TIME_LOOP, oldInnerTimeLoop, newInnerTimeLoop);
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
	public void setInnerTimeLoop(TimeLoop newInnerTimeLoop) {
		if (newInnerTimeLoop != innerTimeLoop) {
			NotificationChain msgs = null;
			if (innerTimeLoop != null)
				msgs = ((InternalEObject)innerTimeLoop).eInverseRemove(this, IrPackage.TIME_LOOP__OUTER_TIME_LOOP, TimeLoop.class, msgs);
			if (newInnerTimeLoop != null)
				msgs = ((InternalEObject)newInnerTimeLoop).eInverseAdd(this, IrPackage.TIME_LOOP__OUTER_TIME_LOOP, TimeLoop.class, msgs);
			msgs = basicSetInnerTimeLoop(newInnerTimeLoop, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.TIME_LOOP__INNER_TIME_LOOP, newInnerTimeLoop, newInnerTimeLoop));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public TimeLoop getOuterTimeLoop() {
		if (eContainerFeatureID() != IrPackage.TIME_LOOP__OUTER_TIME_LOOP) return null;
		return (TimeLoop)eContainer();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public TimeLoop basicGetOuterTimeLoop() {
		if (eContainerFeatureID() != IrPackage.TIME_LOOP__OUTER_TIME_LOOP) return null;
		return (TimeLoop)eInternalContainer();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetOuterTimeLoop(TimeLoop newOuterTimeLoop, NotificationChain msgs) {
		msgs = eBasicSetContainer((InternalEObject)newOuterTimeLoop, IrPackage.TIME_LOOP__OUTER_TIME_LOOP, msgs);
		return msgs;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setOuterTimeLoop(TimeLoop newOuterTimeLoop) {
		if (newOuterTimeLoop != eInternalContainer() || (eContainerFeatureID() != IrPackage.TIME_LOOP__OUTER_TIME_LOOP && newOuterTimeLoop != null)) {
			if (EcoreUtil.isAncestor(this, newOuterTimeLoop))
				throw new IllegalArgumentException("Recursive containment not allowed for " + toString());
			NotificationChain msgs = null;
			if (eInternalContainer() != null)
				msgs = eBasicRemoveFromContainer(msgs);
			if (newOuterTimeLoop != null)
				msgs = ((InternalEObject)newOuterTimeLoop).eInverseAdd(this, IrPackage.TIME_LOOP__INNER_TIME_LOOP, TimeLoop.class, msgs);
			msgs = basicSetOuterTimeLoop(newOuterTimeLoop, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.TIME_LOOP__OUTER_TIME_LOOP, newOuterTimeLoop, newOuterTimeLoop));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public EList<TimeLoopVariable> getVariables() {
		if (variables == null) {
			variables = new EObjectContainmentEList.Resolving<TimeLoopVariable>(TimeLoopVariable.class, this, IrPackage.TIME_LOOP__VARIABLES);
		}
		return variables;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Expression getWhileCondition() {
		if (whileCondition != null && whileCondition.eIsProxy()) {
			InternalEObject oldWhileCondition = (InternalEObject)whileCondition;
			whileCondition = (Expression)eResolveProxy(oldWhileCondition);
			if (whileCondition != oldWhileCondition) {
				InternalEObject newWhileCondition = (InternalEObject)whileCondition;
				NotificationChain msgs = oldWhileCondition.eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.TIME_LOOP__WHILE_CONDITION, null, null);
				if (newWhileCondition.eInternalContainer() == null) {
					msgs = newWhileCondition.eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.TIME_LOOP__WHILE_CONDITION, null, msgs);
				}
				if (msgs != null) msgs.dispatch();
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.TIME_LOOP__WHILE_CONDITION, oldWhileCondition, whileCondition));
			}
		}
		return whileCondition;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Expression basicGetWhileCondition() {
		return whileCondition;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetWhileCondition(Expression newWhileCondition, NotificationChain msgs) {
		Expression oldWhileCondition = whileCondition;
		whileCondition = newWhileCondition;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.TIME_LOOP__WHILE_CONDITION, oldWhileCondition, newWhileCondition);
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
	public void setWhileCondition(Expression newWhileCondition) {
		if (newWhileCondition != whileCondition) {
			NotificationChain msgs = null;
			if (whileCondition != null)
				msgs = ((InternalEObject)whileCondition).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.TIME_LOOP__WHILE_CONDITION, null, msgs);
			if (newWhileCondition != null)
				msgs = ((InternalEObject)newWhileCondition).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.TIME_LOOP__WHILE_CONDITION, null, msgs);
			msgs = basicSetWhileCondition(newWhileCondition, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.TIME_LOOP__WHILE_CONDITION, newWhileCondition, newWhileCondition));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public TimeLoopJob getAssociatedJob() {
		if (associatedJob != null && associatedJob.eIsProxy()) {
			InternalEObject oldAssociatedJob = (InternalEObject)associatedJob;
			associatedJob = (TimeLoopJob)eResolveProxy(oldAssociatedJob);
			if (associatedJob != oldAssociatedJob) {
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.TIME_LOOP__ASSOCIATED_JOB, oldAssociatedJob, associatedJob));
			}
		}
		return associatedJob;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public TimeLoopJob basicGetAssociatedJob() {
		return associatedJob;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setAssociatedJob(TimeLoopJob newAssociatedJob) {
		TimeLoopJob oldAssociatedJob = associatedJob;
		associatedJob = newAssociatedJob;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.TIME_LOOP__ASSOCIATED_JOB, oldAssociatedJob, associatedJob));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public SimpleVariable getCounter() {
		if (counter != null && counter.eIsProxy()) {
			InternalEObject oldCounter = (InternalEObject)counter;
			counter = (SimpleVariable)eResolveProxy(oldCounter);
			if (counter != oldCounter) {
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.TIME_LOOP__COUNTER, oldCounter, counter));
			}
		}
		return counter;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public SimpleVariable basicGetCounter() {
		return counter;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setCounter(SimpleVariable newCounter) {
		SimpleVariable oldCounter = counter;
		counter = newCounter;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.TIME_LOOP__COUNTER, oldCounter, counter));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public NotificationChain eInverseAdd(InternalEObject otherEnd, int featureID, NotificationChain msgs) {
		switch (featureID) {
			case IrPackage.TIME_LOOP__INNER_TIME_LOOP:
				if (innerTimeLoop != null)
					msgs = ((InternalEObject)innerTimeLoop).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.TIME_LOOP__INNER_TIME_LOOP, null, msgs);
				return basicSetInnerTimeLoop((TimeLoop)otherEnd, msgs);
			case IrPackage.TIME_LOOP__OUTER_TIME_LOOP:
				if (eInternalContainer() != null)
					msgs = eBasicRemoveFromContainer(msgs);
				return basicSetOuterTimeLoop((TimeLoop)otherEnd, msgs);
		}
		return super.eInverseAdd(otherEnd, featureID, msgs);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public NotificationChain eInverseRemove(InternalEObject otherEnd, int featureID, NotificationChain msgs) {
		switch (featureID) {
			case IrPackage.TIME_LOOP__INNER_TIME_LOOP:
				return basicSetInnerTimeLoop(null, msgs);
			case IrPackage.TIME_LOOP__OUTER_TIME_LOOP:
				return basicSetOuterTimeLoop(null, msgs);
			case IrPackage.TIME_LOOP__VARIABLES:
				return ((InternalEList<?>)getVariables()).basicRemove(otherEnd, msgs);
			case IrPackage.TIME_LOOP__WHILE_CONDITION:
				return basicSetWhileCondition(null, msgs);
		}
		return super.eInverseRemove(otherEnd, featureID, msgs);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public NotificationChain eBasicRemoveFromContainerFeature(NotificationChain msgs) {
		switch (eContainerFeatureID()) {
			case IrPackage.TIME_LOOP__OUTER_TIME_LOOP:
				return eInternalContainer().eInverseRemove(this, IrPackage.TIME_LOOP__INNER_TIME_LOOP, TimeLoop.class, msgs);
		}
		return super.eBasicRemoveFromContainerFeature(msgs);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Object eGet(int featureID, boolean resolve, boolean coreType) {
		switch (featureID) {
			case IrPackage.TIME_LOOP__NAME:
				return getName();
			case IrPackage.TIME_LOOP__INNER_TIME_LOOP:
				if (resolve) return getInnerTimeLoop();
				return basicGetInnerTimeLoop();
			case IrPackage.TIME_LOOP__OUTER_TIME_LOOP:
				if (resolve) return getOuterTimeLoop();
				return basicGetOuterTimeLoop();
			case IrPackage.TIME_LOOP__VARIABLES:
				return getVariables();
			case IrPackage.TIME_LOOP__WHILE_CONDITION:
				if (resolve) return getWhileCondition();
				return basicGetWhileCondition();
			case IrPackage.TIME_LOOP__ASSOCIATED_JOB:
				if (resolve) return getAssociatedJob();
				return basicGetAssociatedJob();
			case IrPackage.TIME_LOOP__COUNTER:
				if (resolve) return getCounter();
				return basicGetCounter();
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
			case IrPackage.TIME_LOOP__NAME:
				setName((String)newValue);
				return;
			case IrPackage.TIME_LOOP__INNER_TIME_LOOP:
				setInnerTimeLoop((TimeLoop)newValue);
				return;
			case IrPackage.TIME_LOOP__OUTER_TIME_LOOP:
				setOuterTimeLoop((TimeLoop)newValue);
				return;
			case IrPackage.TIME_LOOP__VARIABLES:
				getVariables().clear();
				getVariables().addAll((Collection<? extends TimeLoopVariable>)newValue);
				return;
			case IrPackage.TIME_LOOP__WHILE_CONDITION:
				setWhileCondition((Expression)newValue);
				return;
			case IrPackage.TIME_LOOP__ASSOCIATED_JOB:
				setAssociatedJob((TimeLoopJob)newValue);
				return;
			case IrPackage.TIME_LOOP__COUNTER:
				setCounter((SimpleVariable)newValue);
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
			case IrPackage.TIME_LOOP__NAME:
				setName(NAME_EDEFAULT);
				return;
			case IrPackage.TIME_LOOP__INNER_TIME_LOOP:
				setInnerTimeLoop((TimeLoop)null);
				return;
			case IrPackage.TIME_LOOP__OUTER_TIME_LOOP:
				setOuterTimeLoop((TimeLoop)null);
				return;
			case IrPackage.TIME_LOOP__VARIABLES:
				getVariables().clear();
				return;
			case IrPackage.TIME_LOOP__WHILE_CONDITION:
				setWhileCondition((Expression)null);
				return;
			case IrPackage.TIME_LOOP__ASSOCIATED_JOB:
				setAssociatedJob((TimeLoopJob)null);
				return;
			case IrPackage.TIME_LOOP__COUNTER:
				setCounter((SimpleVariable)null);
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
			case IrPackage.TIME_LOOP__NAME:
				return NAME_EDEFAULT == null ? name != null : !NAME_EDEFAULT.equals(name);
			case IrPackage.TIME_LOOP__INNER_TIME_LOOP:
				return innerTimeLoop != null;
			case IrPackage.TIME_LOOP__OUTER_TIME_LOOP:
				return basicGetOuterTimeLoop() != null;
			case IrPackage.TIME_LOOP__VARIABLES:
				return variables != null && !variables.isEmpty();
			case IrPackage.TIME_LOOP__WHILE_CONDITION:
				return whileCondition != null;
			case IrPackage.TIME_LOOP__ASSOCIATED_JOB:
				return associatedJob != null;
			case IrPackage.TIME_LOOP__COUNTER:
				return counter != null;
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

} //TimeLoopImpl
