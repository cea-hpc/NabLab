/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.Instruction;
import fr.cea.nabla.ir.ir.IrPackage;
import fr.cea.nabla.ir.ir.Job;
import fr.cea.nabla.ir.ir.JobCaller;
import java.util.Collection;
import org.eclipse.emf.common.notify.Notification;
import org.eclipse.emf.common.notify.NotificationChain;

import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;

import org.eclipse.emf.ecore.impl.ENotificationImpl;
import org.eclipse.emf.ecore.util.EObjectResolvingEList;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Job</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.JobImpl#getName <em>Name</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.JobImpl#getAt <em>At</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.JobImpl#isOnCycle <em>On Cycle</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.JobImpl#getCaller <em>Caller</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.JobImpl#getPreviousJobsWithSameCaller <em>Previous Jobs With Same Caller</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.JobImpl#getNextJobsWithSameCaller <em>Next Jobs With Same Caller</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.JobImpl#getInstruction <em>Instruction</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.JobImpl#isTimeLoopJob <em>Time Loop Job</em>}</li>
 * </ul>
 *
 * @generated
 */
public class JobImpl extends IrAnnotableImpl implements Job {
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
	 * The default value of the '{@link #getAt() <em>At</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getAt()
	 * @generated
	 * @ordered
	 */
	protected static final double AT_EDEFAULT = 0.0;

	/**
	 * The cached value of the '{@link #getAt() <em>At</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getAt()
	 * @generated
	 * @ordered
	 */
	protected double at = AT_EDEFAULT;

	/**
	 * The default value of the '{@link #isOnCycle() <em>On Cycle</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #isOnCycle()
	 * @generated
	 * @ordered
	 */
	protected static final boolean ON_CYCLE_EDEFAULT = false;

	/**
	 * The cached value of the '{@link #isOnCycle() <em>On Cycle</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #isOnCycle()
	 * @generated
	 * @ordered
	 */
	protected boolean onCycle = ON_CYCLE_EDEFAULT;

	/**
	 * The cached value of the '{@link #getCaller() <em>Caller</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getCaller()
	 * @generated
	 * @ordered
	 */
	protected JobCaller caller;

	/**
	 * The cached value of the '{@link #getPreviousJobsWithSameCaller() <em>Previous Jobs With Same Caller</em>}' reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getPreviousJobsWithSameCaller()
	 * @generated
	 * @ordered
	 */
	protected EList<Job> previousJobsWithSameCaller;

	/**
	 * The cached value of the '{@link #getNextJobsWithSameCaller() <em>Next Jobs With Same Caller</em>}' reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getNextJobsWithSameCaller()
	 * @generated
	 * @ordered
	 */
	protected EList<Job> nextJobsWithSameCaller;

	/**
	 * The cached value of the '{@link #getInstruction() <em>Instruction</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getInstruction()
	 * @generated
	 * @ordered
	 */
	protected Instruction instruction;

	/**
	 * The default value of the '{@link #isTimeLoopJob() <em>Time Loop Job</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #isTimeLoopJob()
	 * @generated
	 * @ordered
	 */
	protected static final boolean TIME_LOOP_JOB_EDEFAULT = false;

	/**
	 * The cached value of the '{@link #isTimeLoopJob() <em>Time Loop Job</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #isTimeLoopJob()
	 * @generated
	 * @ordered
	 */
	protected boolean timeLoopJob = TIME_LOOP_JOB_EDEFAULT;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected JobImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return IrPackage.Literals.JOB;
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
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.JOB__NAME, oldName, name));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public double getAt() {
		return at;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setAt(double newAt) {
		double oldAt = at;
		at = newAt;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.JOB__AT, oldAt, at));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public boolean isOnCycle() {
		return onCycle;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setOnCycle(boolean newOnCycle) {
		boolean oldOnCycle = onCycle;
		onCycle = newOnCycle;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.JOB__ON_CYCLE, oldOnCycle, onCycle));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public JobCaller getCaller() {
		if (caller != null && caller.eIsProxy()) {
			InternalEObject oldCaller = (InternalEObject)caller;
			caller = (JobCaller)eResolveProxy(oldCaller);
			if (caller != oldCaller) {
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.JOB__CALLER, oldCaller, caller));
			}
		}
		return caller;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public JobCaller basicGetCaller() {
		return caller;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetCaller(JobCaller newCaller, NotificationChain msgs) {
		JobCaller oldCaller = caller;
		caller = newCaller;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.JOB__CALLER, oldCaller, newCaller);
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
	public void setCaller(JobCaller newCaller) {
		if (newCaller != caller) {
			NotificationChain msgs = null;
			if (caller != null)
				msgs = ((InternalEObject)caller).eInverseRemove(this, IrPackage.JOB_CALLER__CALLS, JobCaller.class, msgs);
			if (newCaller != null)
				msgs = ((InternalEObject)newCaller).eInverseAdd(this, IrPackage.JOB_CALLER__CALLS, JobCaller.class, msgs);
			msgs = basicSetCaller(newCaller, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.JOB__CALLER, newCaller, newCaller));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public EList<Job> getPreviousJobsWithSameCaller() {
		if (previousJobsWithSameCaller == null) {
			previousJobsWithSameCaller = new EObjectResolvingEList<Job>(Job.class, this, IrPackage.JOB__PREVIOUS_JOBS_WITH_SAME_CALLER);
		}
		return previousJobsWithSameCaller;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public EList<Job> getNextJobsWithSameCaller() {
		if (nextJobsWithSameCaller == null) {
			nextJobsWithSameCaller = new EObjectResolvingEList<Job>(Job.class, this, IrPackage.JOB__NEXT_JOBS_WITH_SAME_CALLER);
		}
		return nextJobsWithSameCaller;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Instruction getInstruction() {
		return instruction;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetInstruction(Instruction newInstruction, NotificationChain msgs) {
		Instruction oldInstruction = instruction;
		instruction = newInstruction;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.JOB__INSTRUCTION, oldInstruction, newInstruction);
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
	public void setInstruction(Instruction newInstruction) {
		if (newInstruction != instruction) {
			NotificationChain msgs = null;
			if (instruction != null)
				msgs = ((InternalEObject)instruction).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.JOB__INSTRUCTION, null, msgs);
			if (newInstruction != null)
				msgs = ((InternalEObject)newInstruction).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.JOB__INSTRUCTION, null, msgs);
			msgs = basicSetInstruction(newInstruction, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.JOB__INSTRUCTION, newInstruction, newInstruction));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public boolean isTimeLoopJob() {
		return timeLoopJob;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setTimeLoopJob(boolean newTimeLoopJob) {
		boolean oldTimeLoopJob = timeLoopJob;
		timeLoopJob = newTimeLoopJob;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.JOB__TIME_LOOP_JOB, oldTimeLoopJob, timeLoopJob));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public NotificationChain eInverseAdd(InternalEObject otherEnd, int featureID, NotificationChain msgs) {
		switch (featureID) {
			case IrPackage.JOB__CALLER:
				if (caller != null)
					msgs = ((InternalEObject)caller).eInverseRemove(this, IrPackage.JOB_CALLER__CALLS, JobCaller.class, msgs);
				return basicSetCaller((JobCaller)otherEnd, msgs);
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
			case IrPackage.JOB__CALLER:
				return basicSetCaller(null, msgs);
			case IrPackage.JOB__INSTRUCTION:
				return basicSetInstruction(null, msgs);
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
			case IrPackage.JOB__NAME:
				return getName();
			case IrPackage.JOB__AT:
				return getAt();
			case IrPackage.JOB__ON_CYCLE:
				return isOnCycle();
			case IrPackage.JOB__CALLER:
				if (resolve) return getCaller();
				return basicGetCaller();
			case IrPackage.JOB__PREVIOUS_JOBS_WITH_SAME_CALLER:
				return getPreviousJobsWithSameCaller();
			case IrPackage.JOB__NEXT_JOBS_WITH_SAME_CALLER:
				return getNextJobsWithSameCaller();
			case IrPackage.JOB__INSTRUCTION:
				return getInstruction();
			case IrPackage.JOB__TIME_LOOP_JOB:
				return isTimeLoopJob();
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
			case IrPackage.JOB__NAME:
				setName((String)newValue);
				return;
			case IrPackage.JOB__AT:
				setAt((Double)newValue);
				return;
			case IrPackage.JOB__ON_CYCLE:
				setOnCycle((Boolean)newValue);
				return;
			case IrPackage.JOB__CALLER:
				setCaller((JobCaller)newValue);
				return;
			case IrPackage.JOB__PREVIOUS_JOBS_WITH_SAME_CALLER:
				getPreviousJobsWithSameCaller().clear();
				getPreviousJobsWithSameCaller().addAll((Collection<? extends Job>)newValue);
				return;
			case IrPackage.JOB__NEXT_JOBS_WITH_SAME_CALLER:
				getNextJobsWithSameCaller().clear();
				getNextJobsWithSameCaller().addAll((Collection<? extends Job>)newValue);
				return;
			case IrPackage.JOB__INSTRUCTION:
				setInstruction((Instruction)newValue);
				return;
			case IrPackage.JOB__TIME_LOOP_JOB:
				setTimeLoopJob((Boolean)newValue);
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
			case IrPackage.JOB__NAME:
				setName(NAME_EDEFAULT);
				return;
			case IrPackage.JOB__AT:
				setAt(AT_EDEFAULT);
				return;
			case IrPackage.JOB__ON_CYCLE:
				setOnCycle(ON_CYCLE_EDEFAULT);
				return;
			case IrPackage.JOB__CALLER:
				setCaller((JobCaller)null);
				return;
			case IrPackage.JOB__PREVIOUS_JOBS_WITH_SAME_CALLER:
				getPreviousJobsWithSameCaller().clear();
				return;
			case IrPackage.JOB__NEXT_JOBS_WITH_SAME_CALLER:
				getNextJobsWithSameCaller().clear();
				return;
			case IrPackage.JOB__INSTRUCTION:
				setInstruction((Instruction)null);
				return;
			case IrPackage.JOB__TIME_LOOP_JOB:
				setTimeLoopJob(TIME_LOOP_JOB_EDEFAULT);
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
			case IrPackage.JOB__NAME:
				return NAME_EDEFAULT == null ? name != null : !NAME_EDEFAULT.equals(name);
			case IrPackage.JOB__AT:
				return at != AT_EDEFAULT;
			case IrPackage.JOB__ON_CYCLE:
				return onCycle != ON_CYCLE_EDEFAULT;
			case IrPackage.JOB__CALLER:
				return caller != null;
			case IrPackage.JOB__PREVIOUS_JOBS_WITH_SAME_CALLER:
				return previousJobsWithSameCaller != null && !previousJobsWithSameCaller.isEmpty();
			case IrPackage.JOB__NEXT_JOBS_WITH_SAME_CALLER:
				return nextJobsWithSameCaller != null && !nextJobsWithSameCaller.isEmpty();
			case IrPackage.JOB__INSTRUCTION:
				return instruction != null;
			case IrPackage.JOB__TIME_LOOP_JOB:
				return timeLoopJob != TIME_LOOP_JOB_EDEFAULT;
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
		result.append(", at: ");
		result.append(at);
		result.append(", onCycle: ");
		result.append(onCycle);
		result.append(", timeLoopJob: ");
		result.append(timeLoopJob);
		result.append(')');
		return result.toString();
	}

} //JobImpl
