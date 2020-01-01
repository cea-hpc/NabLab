/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.IrPackage;
import fr.cea.nabla.ir.ir.Job;
import fr.cea.nabla.ir.ir.TimeLoop;
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
 *   <li>{@link fr.cea.nabla.ir.ir.impl.TimeLoopJobImpl#getTimeLoop <em>Time Loop</em>}</li>
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
	 * The cached value of the '{@link #getTimeLoop() <em>Time Loop</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getTimeLoop()
	 * @generated
	 * @ordered
	 */
	protected TimeLoop timeLoop;
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
			jobs = new EObjectWithInverseResolvingEList<Job>(Job.class, this, IrPackage.TIME_LOOP_JOB__JOBS, IrPackage.JOB__JOB_CONTAINER);
		}
		return jobs;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public TimeLoop getTimeLoop() {
		if (timeLoop != null && timeLoop.eIsProxy()) {
			InternalEObject oldTimeLoop = (InternalEObject)timeLoop;
			timeLoop = (TimeLoop)eResolveProxy(oldTimeLoop);
			if (timeLoop != oldTimeLoop) {
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.TIME_LOOP_JOB__TIME_LOOP, oldTimeLoop, timeLoop));
			}
		}
		return timeLoop;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public TimeLoop basicGetTimeLoop() {
		return timeLoop;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetTimeLoop(TimeLoop newTimeLoop, NotificationChain msgs) {
		TimeLoop oldTimeLoop = timeLoop;
		timeLoop = newTimeLoop;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.TIME_LOOP_JOB__TIME_LOOP, oldTimeLoop, newTimeLoop);
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
	public void setTimeLoop(TimeLoop newTimeLoop) {
		if (newTimeLoop != timeLoop) {
			NotificationChain msgs = null;
			if (timeLoop != null)
				msgs = ((InternalEObject)timeLoop).eInverseRemove(this, IrPackage.TIME_LOOP__ASSOCIATED_JOB, TimeLoop.class, msgs);
			if (newTimeLoop != null)
				msgs = ((InternalEObject)newTimeLoop).eInverseAdd(this, IrPackage.TIME_LOOP__ASSOCIATED_JOB, TimeLoop.class, msgs);
			msgs = basicSetTimeLoop(newTimeLoop, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.TIME_LOOP_JOB__TIME_LOOP, newTimeLoop, newTimeLoop));
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
			case IrPackage.TIME_LOOP_JOB__TIME_LOOP:
				if (timeLoop != null)
					msgs = ((InternalEObject)timeLoop).eInverseRemove(this, IrPackage.TIME_LOOP__ASSOCIATED_JOB, TimeLoop.class, msgs);
				return basicSetTimeLoop((TimeLoop)otherEnd, msgs);
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
			case IrPackage.TIME_LOOP_JOB__TIME_LOOP:
				return basicSetTimeLoop(null, msgs);
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
			case IrPackage.TIME_LOOP_JOB__TIME_LOOP:
				if (resolve) return getTimeLoop();
				return basicGetTimeLoop();
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
			case IrPackage.TIME_LOOP_JOB__TIME_LOOP:
				setTimeLoop((TimeLoop)newValue);
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
			case IrPackage.TIME_LOOP_JOB__TIME_LOOP:
				setTimeLoop((TimeLoop)null);
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
			case IrPackage.TIME_LOOP_JOB__TIME_LOOP:
				return timeLoop != null;
		}
		return super.eIsSet(featureID);
	}

} //TimeLoopJobImpl
