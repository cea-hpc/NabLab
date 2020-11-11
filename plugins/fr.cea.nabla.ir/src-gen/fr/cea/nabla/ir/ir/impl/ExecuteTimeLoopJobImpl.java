/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.ExecuteTimeLoopJob;
import fr.cea.nabla.ir.ir.Expression;
import fr.cea.nabla.ir.ir.IrPackage;
import fr.cea.nabla.ir.ir.Job;
import fr.cea.nabla.ir.ir.JobCaller;
import fr.cea.nabla.ir.ir.SimpleVariable;
import java.util.Collection;
import org.eclipse.emf.common.notify.Notification;
import org.eclipse.emf.common.notify.NotificationChain;

import org.eclipse.emf.common.util.EList;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;
import org.eclipse.emf.ecore.impl.ENotificationImpl;
import org.eclipse.emf.ecore.util.EObjectWithInverseResolvingEList;
import org.eclipse.emf.ecore.util.InternalEList;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Execute Time Loop Job</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.ExecuteTimeLoopJobImpl#getCalls <em>Calls</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.ExecuteTimeLoopJobImpl#getWhileCondition <em>While Condition</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.ExecuteTimeLoopJobImpl#getIterationCounter <em>Iteration Counter</em>}</li>
 * </ul>
 *
 * @generated
 */
public class ExecuteTimeLoopJobImpl extends TimeLoopJobImpl implements ExecuteTimeLoopJob {
	/**
	 * The cached value of the '{@link #getCalls() <em>Calls</em>}' reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getCalls()
	 * @generated
	 * @ordered
	 */
	protected EList<Job> calls;

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
	 * The cached value of the '{@link #getIterationCounter() <em>Iteration Counter</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getIterationCounter()
	 * @generated
	 * @ordered
	 */
	protected SimpleVariable iterationCounter;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected ExecuteTimeLoopJobImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return IrPackage.Literals.EXECUTE_TIME_LOOP_JOB;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public EList<Job> getCalls() {
		if (calls == null) {
			calls = new EObjectWithInverseResolvingEList<Job>(Job.class, this, IrPackage.EXECUTE_TIME_LOOP_JOB__CALLS, IrPackage.JOB__CALLER);
		}
		return calls;
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
				NotificationChain msgs = oldWhileCondition.eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.EXECUTE_TIME_LOOP_JOB__WHILE_CONDITION, null, null);
				if (newWhileCondition.eInternalContainer() == null) {
					msgs = newWhileCondition.eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.EXECUTE_TIME_LOOP_JOB__WHILE_CONDITION, null, msgs);
				}
				if (msgs != null) msgs.dispatch();
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.EXECUTE_TIME_LOOP_JOB__WHILE_CONDITION, oldWhileCondition, whileCondition));
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
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.EXECUTE_TIME_LOOP_JOB__WHILE_CONDITION, oldWhileCondition, newWhileCondition);
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
				msgs = ((InternalEObject)whileCondition).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.EXECUTE_TIME_LOOP_JOB__WHILE_CONDITION, null, msgs);
			if (newWhileCondition != null)
				msgs = ((InternalEObject)newWhileCondition).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.EXECUTE_TIME_LOOP_JOB__WHILE_CONDITION, null, msgs);
			msgs = basicSetWhileCondition(newWhileCondition, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.EXECUTE_TIME_LOOP_JOB__WHILE_CONDITION, newWhileCondition, newWhileCondition));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public SimpleVariable getIterationCounter() {
		if (iterationCounter != null && iterationCounter.eIsProxy()) {
			InternalEObject oldIterationCounter = (InternalEObject)iterationCounter;
			iterationCounter = (SimpleVariable)eResolveProxy(oldIterationCounter);
			if (iterationCounter != oldIterationCounter) {
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.EXECUTE_TIME_LOOP_JOB__ITERATION_COUNTER, oldIterationCounter, iterationCounter));
			}
		}
		return iterationCounter;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public SimpleVariable basicGetIterationCounter() {
		return iterationCounter;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setIterationCounter(SimpleVariable newIterationCounter) {
		SimpleVariable oldIterationCounter = iterationCounter;
		iterationCounter = newIterationCounter;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.EXECUTE_TIME_LOOP_JOB__ITERATION_COUNTER, oldIterationCounter, iterationCounter));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@SuppressWarnings("unchecked")
	@Override
	public NotificationChain eInverseAdd(InternalEObject otherEnd, int featureID, NotificationChain msgs) {
		switch (featureID) {
			case IrPackage.EXECUTE_TIME_LOOP_JOB__CALLS:
				return ((InternalEList<InternalEObject>)(InternalEList<?>)getCalls()).basicAdd(otherEnd, msgs);
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
			case IrPackage.EXECUTE_TIME_LOOP_JOB__CALLS:
				return ((InternalEList<?>)getCalls()).basicRemove(otherEnd, msgs);
			case IrPackage.EXECUTE_TIME_LOOP_JOB__WHILE_CONDITION:
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
	public Object eGet(int featureID, boolean resolve, boolean coreType) {
		switch (featureID) {
			case IrPackage.EXECUTE_TIME_LOOP_JOB__CALLS:
				return getCalls();
			case IrPackage.EXECUTE_TIME_LOOP_JOB__WHILE_CONDITION:
				if (resolve) return getWhileCondition();
				return basicGetWhileCondition();
			case IrPackage.EXECUTE_TIME_LOOP_JOB__ITERATION_COUNTER:
				if (resolve) return getIterationCounter();
				return basicGetIterationCounter();
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
			case IrPackage.EXECUTE_TIME_LOOP_JOB__CALLS:
				getCalls().clear();
				getCalls().addAll((Collection<? extends Job>)newValue);
				return;
			case IrPackage.EXECUTE_TIME_LOOP_JOB__WHILE_CONDITION:
				setWhileCondition((Expression)newValue);
				return;
			case IrPackage.EXECUTE_TIME_LOOP_JOB__ITERATION_COUNTER:
				setIterationCounter((SimpleVariable)newValue);
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
			case IrPackage.EXECUTE_TIME_LOOP_JOB__CALLS:
				getCalls().clear();
				return;
			case IrPackage.EXECUTE_TIME_LOOP_JOB__WHILE_CONDITION:
				setWhileCondition((Expression)null);
				return;
			case IrPackage.EXECUTE_TIME_LOOP_JOB__ITERATION_COUNTER:
				setIterationCounter((SimpleVariable)null);
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
			case IrPackage.EXECUTE_TIME_LOOP_JOB__CALLS:
				return calls != null && !calls.isEmpty();
			case IrPackage.EXECUTE_TIME_LOOP_JOB__WHILE_CONDITION:
				return whileCondition != null;
			case IrPackage.EXECUTE_TIME_LOOP_JOB__ITERATION_COUNTER:
				return iterationCounter != null;
		}
		return super.eIsSet(featureID);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public int eBaseStructuralFeatureID(int derivedFeatureID, Class<?> baseClass) {
		if (baseClass == JobCaller.class) {
			switch (derivedFeatureID) {
				case IrPackage.EXECUTE_TIME_LOOP_JOB__CALLS: return IrPackage.JOB_CALLER__CALLS;
				default: return -1;
			}
		}
		return super.eBaseStructuralFeatureID(derivedFeatureID, baseClass);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public int eDerivedStructuralFeatureID(int baseFeatureID, Class<?> baseClass) {
		if (baseClass == JobCaller.class) {
			switch (baseFeatureID) {
				case IrPackage.JOB_CALLER__CALLS: return IrPackage.EXECUTE_TIME_LOOP_JOB__CALLS;
				default: return -1;
			}
		}
		return super.eDerivedStructuralFeatureID(baseFeatureID, baseClass);
	}

} //ExecuteTimeLoopJobImpl
