/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.Expression;
import fr.cea.nabla.ir.ir.IrPackage;
import fr.cea.nabla.ir.ir.Job;
import fr.cea.nabla.ir.ir.TimeLoopJob;

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
 * An implementation of the model object '<em><b>Time Loop Job</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.TimeLoopJobImpl#getJobs <em>Jobs</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.TimeLoopJobImpl#getWhileCondition <em>While Condition</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.TimeLoopJobImpl#getOuterTimeLoop <em>Outer Time Loop</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.TimeLoopJobImpl#getInnerTimeLoop <em>Inner Time Loop</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.TimeLoopJobImpl#getTimeLoopName <em>Time Loop Name</em>}</li>
 * </ul>
 *
 * @generated
 */
public class TimeLoopJobImpl extends JobImpl implements TimeLoopJob {
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
	 * The cached value of the '{@link #getWhileCondition() <em>While Condition</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getWhileCondition()
	 * @generated
	 * @ordered
	 */
	protected Expression whileCondition;
	/**
	 * The cached value of the '{@link #getOuterTimeLoop() <em>Outer Time Loop</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getOuterTimeLoop()
	 * @generated
	 * @ordered
	 */
	protected TimeLoopJob outerTimeLoop;
	/**
	 * The cached value of the '{@link #getInnerTimeLoop() <em>Inner Time Loop</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getInnerTimeLoop()
	 * @generated
	 * @ordered
	 */
	protected TimeLoopJob innerTimeLoop;
	/**
	 * The default value of the '{@link #getTimeLoopName() <em>Time Loop Name</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getTimeLoopName()
	 * @generated
	 * @ordered
	 */
	protected static final String TIME_LOOP_NAME_EDEFAULT = null;
	/**
	 * The cached value of the '{@link #getTimeLoopName() <em>Time Loop Name</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getTimeLoopName()
	 * @generated
	 * @ordered
	 */
	protected String timeLoopName = TIME_LOOP_NAME_EDEFAULT;
	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected TimeLoopJobImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return IrPackage.Literals.TIME_LOOP_JOB;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public EList<Job> getJobs() {
		if (jobs == null) {
			jobs = new EObjectWithInverseResolvingEList<Job>(Job.class, this, IrPackage.TIME_LOOP_JOB__JOBS, IrPackage.JOB__TIME_LOOP_CONTAINER);
		}
		return jobs;
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
				NotificationChain msgs = oldWhileCondition.eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.TIME_LOOP_JOB__WHILE_CONDITION, null, null);
				if (newWhileCondition.eInternalContainer() == null) {
					msgs = newWhileCondition.eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.TIME_LOOP_JOB__WHILE_CONDITION, null, msgs);
				}
				if (msgs != null) msgs.dispatch();
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.TIME_LOOP_JOB__WHILE_CONDITION, oldWhileCondition, whileCondition));
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
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.TIME_LOOP_JOB__WHILE_CONDITION, oldWhileCondition, newWhileCondition);
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
				msgs = ((InternalEObject)whileCondition).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.TIME_LOOP_JOB__WHILE_CONDITION, null, msgs);
			if (newWhileCondition != null)
				msgs = ((InternalEObject)newWhileCondition).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.TIME_LOOP_JOB__WHILE_CONDITION, null, msgs);
			msgs = basicSetWhileCondition(newWhileCondition, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.TIME_LOOP_JOB__WHILE_CONDITION, newWhileCondition, newWhileCondition));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public TimeLoopJob getOuterTimeLoop() {
		if (outerTimeLoop != null && outerTimeLoop.eIsProxy()) {
			InternalEObject oldOuterTimeLoop = (InternalEObject)outerTimeLoop;
			outerTimeLoop = (TimeLoopJob)eResolveProxy(oldOuterTimeLoop);
			if (outerTimeLoop != oldOuterTimeLoop) {
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.TIME_LOOP_JOB__OUTER_TIME_LOOP, oldOuterTimeLoop, outerTimeLoop));
			}
		}
		return outerTimeLoop;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public TimeLoopJob basicGetOuterTimeLoop() {
		return outerTimeLoop;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetOuterTimeLoop(TimeLoopJob newOuterTimeLoop, NotificationChain msgs) {
		TimeLoopJob oldOuterTimeLoop = outerTimeLoop;
		outerTimeLoop = newOuterTimeLoop;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.TIME_LOOP_JOB__OUTER_TIME_LOOP, oldOuterTimeLoop, newOuterTimeLoop);
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
	public void setOuterTimeLoop(TimeLoopJob newOuterTimeLoop) {
		if (newOuterTimeLoop != outerTimeLoop) {
			NotificationChain msgs = null;
			if (outerTimeLoop != null)
				msgs = ((InternalEObject)outerTimeLoop).eInverseRemove(this, IrPackage.TIME_LOOP_JOB__INNER_TIME_LOOP, TimeLoopJob.class, msgs);
			if (newOuterTimeLoop != null)
				msgs = ((InternalEObject)newOuterTimeLoop).eInverseAdd(this, IrPackage.TIME_LOOP_JOB__INNER_TIME_LOOP, TimeLoopJob.class, msgs);
			msgs = basicSetOuterTimeLoop(newOuterTimeLoop, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.TIME_LOOP_JOB__OUTER_TIME_LOOP, newOuterTimeLoop, newOuterTimeLoop));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public TimeLoopJob getInnerTimeLoop() {
		if (innerTimeLoop != null && innerTimeLoop.eIsProxy()) {
			InternalEObject oldInnerTimeLoop = (InternalEObject)innerTimeLoop;
			innerTimeLoop = (TimeLoopJob)eResolveProxy(oldInnerTimeLoop);
			if (innerTimeLoop != oldInnerTimeLoop) {
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.TIME_LOOP_JOB__INNER_TIME_LOOP, oldInnerTimeLoop, innerTimeLoop));
			}
		}
		return innerTimeLoop;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public TimeLoopJob basicGetInnerTimeLoop() {
		return innerTimeLoop;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetInnerTimeLoop(TimeLoopJob newInnerTimeLoop, NotificationChain msgs) {
		TimeLoopJob oldInnerTimeLoop = innerTimeLoop;
		innerTimeLoop = newInnerTimeLoop;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.TIME_LOOP_JOB__INNER_TIME_LOOP, oldInnerTimeLoop, newInnerTimeLoop);
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
	public void setInnerTimeLoop(TimeLoopJob newInnerTimeLoop) {
		if (newInnerTimeLoop != innerTimeLoop) {
			NotificationChain msgs = null;
			if (innerTimeLoop != null)
				msgs = ((InternalEObject)innerTimeLoop).eInverseRemove(this, IrPackage.TIME_LOOP_JOB__OUTER_TIME_LOOP, TimeLoopJob.class, msgs);
			if (newInnerTimeLoop != null)
				msgs = ((InternalEObject)newInnerTimeLoop).eInverseAdd(this, IrPackage.TIME_LOOP_JOB__OUTER_TIME_LOOP, TimeLoopJob.class, msgs);
			msgs = basicSetInnerTimeLoop(newInnerTimeLoop, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.TIME_LOOP_JOB__INNER_TIME_LOOP, newInnerTimeLoop, newInnerTimeLoop));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public String getTimeLoopName() {
		return timeLoopName;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setTimeLoopName(String newTimeLoopName) {
		String oldTimeLoopName = timeLoopName;
		timeLoopName = newTimeLoopName;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.TIME_LOOP_JOB__TIME_LOOP_NAME, oldTimeLoopName, timeLoopName));
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
			case IrPackage.TIME_LOOP_JOB__JOBS:
				return ((InternalEList<InternalEObject>)(InternalEList<?>)getJobs()).basicAdd(otherEnd, msgs);
			case IrPackage.TIME_LOOP_JOB__OUTER_TIME_LOOP:
				if (outerTimeLoop != null)
					msgs = ((InternalEObject)outerTimeLoop).eInverseRemove(this, IrPackage.TIME_LOOP_JOB__INNER_TIME_LOOP, TimeLoopJob.class, msgs);
				return basicSetOuterTimeLoop((TimeLoopJob)otherEnd, msgs);
			case IrPackage.TIME_LOOP_JOB__INNER_TIME_LOOP:
				if (innerTimeLoop != null)
					msgs = ((InternalEObject)innerTimeLoop).eInverseRemove(this, IrPackage.TIME_LOOP_JOB__OUTER_TIME_LOOP, TimeLoopJob.class, msgs);
				return basicSetInnerTimeLoop((TimeLoopJob)otherEnd, msgs);
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
			case IrPackage.TIME_LOOP_JOB__JOBS:
				return ((InternalEList<?>)getJobs()).basicRemove(otherEnd, msgs);
			case IrPackage.TIME_LOOP_JOB__WHILE_CONDITION:
				return basicSetWhileCondition(null, msgs);
			case IrPackage.TIME_LOOP_JOB__OUTER_TIME_LOOP:
				return basicSetOuterTimeLoop(null, msgs);
			case IrPackage.TIME_LOOP_JOB__INNER_TIME_LOOP:
				return basicSetInnerTimeLoop(null, msgs);
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
			case IrPackage.TIME_LOOP_JOB__JOBS:
				return getJobs();
			case IrPackage.TIME_LOOP_JOB__WHILE_CONDITION:
				if (resolve) return getWhileCondition();
				return basicGetWhileCondition();
			case IrPackage.TIME_LOOP_JOB__OUTER_TIME_LOOP:
				if (resolve) return getOuterTimeLoop();
				return basicGetOuterTimeLoop();
			case IrPackage.TIME_LOOP_JOB__INNER_TIME_LOOP:
				if (resolve) return getInnerTimeLoop();
				return basicGetInnerTimeLoop();
			case IrPackage.TIME_LOOP_JOB__TIME_LOOP_NAME:
				return getTimeLoopName();
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
			case IrPackage.TIME_LOOP_JOB__JOBS:
				getJobs().clear();
				getJobs().addAll((Collection<? extends Job>)newValue);
				return;
			case IrPackage.TIME_LOOP_JOB__WHILE_CONDITION:
				setWhileCondition((Expression)newValue);
				return;
			case IrPackage.TIME_LOOP_JOB__OUTER_TIME_LOOP:
				setOuterTimeLoop((TimeLoopJob)newValue);
				return;
			case IrPackage.TIME_LOOP_JOB__INNER_TIME_LOOP:
				setInnerTimeLoop((TimeLoopJob)newValue);
				return;
			case IrPackage.TIME_LOOP_JOB__TIME_LOOP_NAME:
				setTimeLoopName((String)newValue);
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
			case IrPackage.TIME_LOOP_JOB__JOBS:
				getJobs().clear();
				return;
			case IrPackage.TIME_LOOP_JOB__WHILE_CONDITION:
				setWhileCondition((Expression)null);
				return;
			case IrPackage.TIME_LOOP_JOB__OUTER_TIME_LOOP:
				setOuterTimeLoop((TimeLoopJob)null);
				return;
			case IrPackage.TIME_LOOP_JOB__INNER_TIME_LOOP:
				setInnerTimeLoop((TimeLoopJob)null);
				return;
			case IrPackage.TIME_LOOP_JOB__TIME_LOOP_NAME:
				setTimeLoopName(TIME_LOOP_NAME_EDEFAULT);
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
			case IrPackage.TIME_LOOP_JOB__JOBS:
				return jobs != null && !jobs.isEmpty();
			case IrPackage.TIME_LOOP_JOB__WHILE_CONDITION:
				return whileCondition != null;
			case IrPackage.TIME_LOOP_JOB__OUTER_TIME_LOOP:
				return outerTimeLoop != null;
			case IrPackage.TIME_LOOP_JOB__INNER_TIME_LOOP:
				return innerTimeLoop != null;
			case IrPackage.TIME_LOOP_JOB__TIME_LOOP_NAME:
				return TIME_LOOP_NAME_EDEFAULT == null ? timeLoopName != null : !TIME_LOOP_NAME_EDEFAULT.equals(timeLoopName);
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
		result.append(" (timeLoopName: ");
		result.append(timeLoopName);
		result.append(')');
		return result.toString();
	}

} //TimeLoopJobImpl
