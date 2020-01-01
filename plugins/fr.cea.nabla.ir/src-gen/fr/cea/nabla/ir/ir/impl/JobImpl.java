/**
 */
package fr.cea.nabla.ir.ir.impl;

import org.eclipse.emf.common.notify.Notification;
import org.eclipse.emf.common.notify.NotificationChain;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;
import org.eclipse.emf.ecore.impl.ENotificationImpl;

import fr.cea.nabla.ir.ir.IrPackage;
import fr.cea.nabla.ir.ir.Job;
import fr.cea.nabla.ir.ir.TimeLoopJob;

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
 *   <li>{@link fr.cea.nabla.ir.ir.impl.JobImpl#getJobContainer <em>Job Container</em>}</li>
 * </ul>
 *
 * @generated
 */
public abstract class JobImpl extends IrAnnotableImpl implements Job {
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
	 * The cached value of the '{@link #getJobContainer() <em>Job Container</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getJobContainer()
	 * @generated
	 * @ordered
	 */
	protected TimeLoopJob jobContainer;

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
	public TimeLoopJob getJobContainer() {
		if (jobContainer != null && jobContainer.eIsProxy()) {
			InternalEObject oldJobContainer = (InternalEObject)jobContainer;
			jobContainer = (TimeLoopJob)eResolveProxy(oldJobContainer);
			if (jobContainer != oldJobContainer) {
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.JOB__JOB_CONTAINER, oldJobContainer, jobContainer));
			}
		}
		return jobContainer;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public TimeLoopJob basicGetJobContainer() {
		return jobContainer;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetJobContainer(TimeLoopJob newJobContainer, NotificationChain msgs) {
		TimeLoopJob oldJobContainer = jobContainer;
		jobContainer = newJobContainer;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.JOB__JOB_CONTAINER, oldJobContainer, newJobContainer);
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
	public void setJobContainer(TimeLoopJob newJobContainer) {
		if (newJobContainer != jobContainer) {
			NotificationChain msgs = null;
			if (jobContainer != null)
				msgs = ((InternalEObject)jobContainer).eInverseRemove(this, IrPackage.TIME_LOOP_JOB__JOBS, TimeLoopJob.class, msgs);
			if (newJobContainer != null)
				msgs = ((InternalEObject)newJobContainer).eInverseAdd(this, IrPackage.TIME_LOOP_JOB__JOBS, TimeLoopJob.class, msgs);
			msgs = basicSetJobContainer(newJobContainer, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.JOB__JOB_CONTAINER, newJobContainer, newJobContainer));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public NotificationChain eInverseAdd(InternalEObject otherEnd, int featureID, NotificationChain msgs) {
		switch (featureID) {
			case IrPackage.JOB__JOB_CONTAINER:
				if (jobContainer != null)
					msgs = ((InternalEObject)jobContainer).eInverseRemove(this, IrPackage.TIME_LOOP_JOB__JOBS, TimeLoopJob.class, msgs);
				return basicSetJobContainer((TimeLoopJob)otherEnd, msgs);
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
			case IrPackage.JOB__JOB_CONTAINER:
				return basicSetJobContainer(null, msgs);
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
			case IrPackage.JOB__JOB_CONTAINER:
				if (resolve) return getJobContainer();
				return basicGetJobContainer();
		}
		return super.eGet(featureID, resolve, coreType);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
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
			case IrPackage.JOB__JOB_CONTAINER:
				setJobContainer((TimeLoopJob)newValue);
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
			case IrPackage.JOB__JOB_CONTAINER:
				setJobContainer((TimeLoopJob)null);
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
			case IrPackage.JOB__JOB_CONTAINER:
				return jobContainer != null;
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
		result.append(')');
		return result.toString();
	}

} //JobImpl
