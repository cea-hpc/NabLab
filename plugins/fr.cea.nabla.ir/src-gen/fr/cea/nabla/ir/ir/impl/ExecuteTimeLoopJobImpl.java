/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.ExecuteTimeLoopJob;
import fr.cea.nabla.ir.ir.Expression;
import fr.cea.nabla.ir.ir.Instruction;
import fr.cea.nabla.ir.ir.IrPackage;
import fr.cea.nabla.ir.ir.Job;
import fr.cea.nabla.ir.ir.JobCaller;
import fr.cea.nabla.ir.ir.Variable;
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
 * An implementation of the model object '<em><b>Execute Time Loop Job</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.ExecuteTimeLoopJobImpl#getName <em>Name</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.ExecuteTimeLoopJobImpl#getAt <em>At</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.ExecuteTimeLoopJobImpl#isOnCycle <em>On Cycle</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.ExecuteTimeLoopJobImpl#getCaller <em>Caller</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.ExecuteTimeLoopJobImpl#getPreviousJobsWithSameCaller <em>Previous Jobs With Same Caller</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.ExecuteTimeLoopJobImpl#getNextJobsWithSameCaller <em>Next Jobs With Same Caller</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.ExecuteTimeLoopJobImpl#getInstruction <em>Instruction</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.ExecuteTimeLoopJobImpl#isTimeLoopJob <em>Time Loop Job</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.ExecuteTimeLoopJobImpl#getWhileCondition <em>While Condition</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.ExecuteTimeLoopJobImpl#getIterationCounter <em>Iteration Counter</em>}</li>
 * </ul>
 *
 * @generated
 */
public class ExecuteTimeLoopJobImpl extends JobCallerImpl implements ExecuteTimeLoopJob {
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
	protected Variable iterationCounter;

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
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.EXECUTE_TIME_LOOP_JOB__NAME, oldName, name));
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
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.EXECUTE_TIME_LOOP_JOB__AT, oldAt, at));
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
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.EXECUTE_TIME_LOOP_JOB__ON_CYCLE, oldOnCycle, onCycle));
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
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.EXECUTE_TIME_LOOP_JOB__CALLER, oldCaller, caller));
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
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.EXECUTE_TIME_LOOP_JOB__CALLER, oldCaller, newCaller);
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
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.EXECUTE_TIME_LOOP_JOB__CALLER, newCaller, newCaller));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public EList<Job> getPreviousJobsWithSameCaller() {
		if (previousJobsWithSameCaller == null) {
			previousJobsWithSameCaller = new EObjectResolvingEList<Job>(Job.class, this, IrPackage.EXECUTE_TIME_LOOP_JOB__PREVIOUS_JOBS_WITH_SAME_CALLER);
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
			nextJobsWithSameCaller = new EObjectResolvingEList<Job>(Job.class, this, IrPackage.EXECUTE_TIME_LOOP_JOB__NEXT_JOBS_WITH_SAME_CALLER);
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
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.EXECUTE_TIME_LOOP_JOB__INSTRUCTION, oldInstruction, newInstruction);
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
				msgs = ((InternalEObject)instruction).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.EXECUTE_TIME_LOOP_JOB__INSTRUCTION, null, msgs);
			if (newInstruction != null)
				msgs = ((InternalEObject)newInstruction).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.EXECUTE_TIME_LOOP_JOB__INSTRUCTION, null, msgs);
			msgs = basicSetInstruction(newInstruction, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.EXECUTE_TIME_LOOP_JOB__INSTRUCTION, newInstruction, newInstruction));
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
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.EXECUTE_TIME_LOOP_JOB__TIME_LOOP_JOB, oldTimeLoopJob, timeLoopJob));
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
	public Variable getIterationCounter() {
		if (iterationCounter != null && iterationCounter.eIsProxy()) {
			InternalEObject oldIterationCounter = (InternalEObject)iterationCounter;
			iterationCounter = (Variable)eResolveProxy(oldIterationCounter);
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
	public Variable basicGetIterationCounter() {
		return iterationCounter;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setIterationCounter(Variable newIterationCounter) {
		Variable oldIterationCounter = iterationCounter;
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
			case IrPackage.EXECUTE_TIME_LOOP_JOB__CALLER:
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
			case IrPackage.EXECUTE_TIME_LOOP_JOB__CALLER:
				return basicSetCaller(null, msgs);
			case IrPackage.EXECUTE_TIME_LOOP_JOB__INSTRUCTION:
				return basicSetInstruction(null, msgs);
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
			case IrPackage.EXECUTE_TIME_LOOP_JOB__NAME:
				return getName();
			case IrPackage.EXECUTE_TIME_LOOP_JOB__AT:
				return getAt();
			case IrPackage.EXECUTE_TIME_LOOP_JOB__ON_CYCLE:
				return isOnCycle();
			case IrPackage.EXECUTE_TIME_LOOP_JOB__CALLER:
				if (resolve) return getCaller();
				return basicGetCaller();
			case IrPackage.EXECUTE_TIME_LOOP_JOB__PREVIOUS_JOBS_WITH_SAME_CALLER:
				return getPreviousJobsWithSameCaller();
			case IrPackage.EXECUTE_TIME_LOOP_JOB__NEXT_JOBS_WITH_SAME_CALLER:
				return getNextJobsWithSameCaller();
			case IrPackage.EXECUTE_TIME_LOOP_JOB__INSTRUCTION:
				return getInstruction();
			case IrPackage.EXECUTE_TIME_LOOP_JOB__TIME_LOOP_JOB:
				return isTimeLoopJob();
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
			case IrPackage.EXECUTE_TIME_LOOP_JOB__NAME:
				setName((String)newValue);
				return;
			case IrPackage.EXECUTE_TIME_LOOP_JOB__AT:
				setAt((Double)newValue);
				return;
			case IrPackage.EXECUTE_TIME_LOOP_JOB__ON_CYCLE:
				setOnCycle((Boolean)newValue);
				return;
			case IrPackage.EXECUTE_TIME_LOOP_JOB__CALLER:
				setCaller((JobCaller)newValue);
				return;
			case IrPackage.EXECUTE_TIME_LOOP_JOB__PREVIOUS_JOBS_WITH_SAME_CALLER:
				getPreviousJobsWithSameCaller().clear();
				getPreviousJobsWithSameCaller().addAll((Collection<? extends Job>)newValue);
				return;
			case IrPackage.EXECUTE_TIME_LOOP_JOB__NEXT_JOBS_WITH_SAME_CALLER:
				getNextJobsWithSameCaller().clear();
				getNextJobsWithSameCaller().addAll((Collection<? extends Job>)newValue);
				return;
			case IrPackage.EXECUTE_TIME_LOOP_JOB__INSTRUCTION:
				setInstruction((Instruction)newValue);
				return;
			case IrPackage.EXECUTE_TIME_LOOP_JOB__TIME_LOOP_JOB:
				setTimeLoopJob((Boolean)newValue);
				return;
			case IrPackage.EXECUTE_TIME_LOOP_JOB__WHILE_CONDITION:
				setWhileCondition((Expression)newValue);
				return;
			case IrPackage.EXECUTE_TIME_LOOP_JOB__ITERATION_COUNTER:
				setIterationCounter((Variable)newValue);
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
			case IrPackage.EXECUTE_TIME_LOOP_JOB__NAME:
				setName(NAME_EDEFAULT);
				return;
			case IrPackage.EXECUTE_TIME_LOOP_JOB__AT:
				setAt(AT_EDEFAULT);
				return;
			case IrPackage.EXECUTE_TIME_LOOP_JOB__ON_CYCLE:
				setOnCycle(ON_CYCLE_EDEFAULT);
				return;
			case IrPackage.EXECUTE_TIME_LOOP_JOB__CALLER:
				setCaller((JobCaller)null);
				return;
			case IrPackage.EXECUTE_TIME_LOOP_JOB__PREVIOUS_JOBS_WITH_SAME_CALLER:
				getPreviousJobsWithSameCaller().clear();
				return;
			case IrPackage.EXECUTE_TIME_LOOP_JOB__NEXT_JOBS_WITH_SAME_CALLER:
				getNextJobsWithSameCaller().clear();
				return;
			case IrPackage.EXECUTE_TIME_LOOP_JOB__INSTRUCTION:
				setInstruction((Instruction)null);
				return;
			case IrPackage.EXECUTE_TIME_LOOP_JOB__TIME_LOOP_JOB:
				setTimeLoopJob(TIME_LOOP_JOB_EDEFAULT);
				return;
			case IrPackage.EXECUTE_TIME_LOOP_JOB__WHILE_CONDITION:
				setWhileCondition((Expression)null);
				return;
			case IrPackage.EXECUTE_TIME_LOOP_JOB__ITERATION_COUNTER:
				setIterationCounter((Variable)null);
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
			case IrPackage.EXECUTE_TIME_LOOP_JOB__NAME:
				return NAME_EDEFAULT == null ? name != null : !NAME_EDEFAULT.equals(name);
			case IrPackage.EXECUTE_TIME_LOOP_JOB__AT:
				return at != AT_EDEFAULT;
			case IrPackage.EXECUTE_TIME_LOOP_JOB__ON_CYCLE:
				return onCycle != ON_CYCLE_EDEFAULT;
			case IrPackage.EXECUTE_TIME_LOOP_JOB__CALLER:
				return caller != null;
			case IrPackage.EXECUTE_TIME_LOOP_JOB__PREVIOUS_JOBS_WITH_SAME_CALLER:
				return previousJobsWithSameCaller != null && !previousJobsWithSameCaller.isEmpty();
			case IrPackage.EXECUTE_TIME_LOOP_JOB__NEXT_JOBS_WITH_SAME_CALLER:
				return nextJobsWithSameCaller != null && !nextJobsWithSameCaller.isEmpty();
			case IrPackage.EXECUTE_TIME_LOOP_JOB__INSTRUCTION:
				return instruction != null;
			case IrPackage.EXECUTE_TIME_LOOP_JOB__TIME_LOOP_JOB:
				return timeLoopJob != TIME_LOOP_JOB_EDEFAULT;
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
		if (baseClass == Job.class) {
			switch (derivedFeatureID) {
				case IrPackage.EXECUTE_TIME_LOOP_JOB__NAME: return IrPackage.JOB__NAME;
				case IrPackage.EXECUTE_TIME_LOOP_JOB__AT: return IrPackage.JOB__AT;
				case IrPackage.EXECUTE_TIME_LOOP_JOB__ON_CYCLE: return IrPackage.JOB__ON_CYCLE;
				case IrPackage.EXECUTE_TIME_LOOP_JOB__CALLER: return IrPackage.JOB__CALLER;
				case IrPackage.EXECUTE_TIME_LOOP_JOB__PREVIOUS_JOBS_WITH_SAME_CALLER: return IrPackage.JOB__PREVIOUS_JOBS_WITH_SAME_CALLER;
				case IrPackage.EXECUTE_TIME_LOOP_JOB__NEXT_JOBS_WITH_SAME_CALLER: return IrPackage.JOB__NEXT_JOBS_WITH_SAME_CALLER;
				case IrPackage.EXECUTE_TIME_LOOP_JOB__INSTRUCTION: return IrPackage.JOB__INSTRUCTION;
				case IrPackage.EXECUTE_TIME_LOOP_JOB__TIME_LOOP_JOB: return IrPackage.JOB__TIME_LOOP_JOB;
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
		if (baseClass == Job.class) {
			switch (baseFeatureID) {
				case IrPackage.JOB__NAME: return IrPackage.EXECUTE_TIME_LOOP_JOB__NAME;
				case IrPackage.JOB__AT: return IrPackage.EXECUTE_TIME_LOOP_JOB__AT;
				case IrPackage.JOB__ON_CYCLE: return IrPackage.EXECUTE_TIME_LOOP_JOB__ON_CYCLE;
				case IrPackage.JOB__CALLER: return IrPackage.EXECUTE_TIME_LOOP_JOB__CALLER;
				case IrPackage.JOB__PREVIOUS_JOBS_WITH_SAME_CALLER: return IrPackage.EXECUTE_TIME_LOOP_JOB__PREVIOUS_JOBS_WITH_SAME_CALLER;
				case IrPackage.JOB__NEXT_JOBS_WITH_SAME_CALLER: return IrPackage.EXECUTE_TIME_LOOP_JOB__NEXT_JOBS_WITH_SAME_CALLER;
				case IrPackage.JOB__INSTRUCTION: return IrPackage.EXECUTE_TIME_LOOP_JOB__INSTRUCTION;
				case IrPackage.JOB__TIME_LOOP_JOB: return IrPackage.EXECUTE_TIME_LOOP_JOB__TIME_LOOP_JOB;
				default: return -1;
			}
		}
		return super.eDerivedStructuralFeatureID(baseFeatureID, baseClass);
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

} //ExecuteTimeLoopJobImpl
