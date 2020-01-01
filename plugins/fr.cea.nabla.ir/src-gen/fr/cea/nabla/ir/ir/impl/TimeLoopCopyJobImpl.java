/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.IrPackage;
import fr.cea.nabla.ir.ir.TimeLoop;
import fr.cea.nabla.ir.ir.TimeLoopCopy;
import fr.cea.nabla.ir.ir.TimeLoopCopyJob;
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
 * An implementation of the model object '<em><b>Time Loop Copy Job</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.TimeLoopCopyJobImpl#getCopies <em>Copies</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.TimeLoopCopyJobImpl#getTimeLoop <em>Time Loop</em>}</li>
 * </ul>
 *
 * @generated
 */
public abstract class TimeLoopCopyJobImpl extends JobImpl implements TimeLoopCopyJob {
	/**
	 * The cached value of the '{@link #getCopies() <em>Copies</em>}' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getCopies()
	 * @generated
	 * @ordered
	 */
	protected EList<TimeLoopCopy> copies;

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
	protected TimeLoopCopyJobImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return IrPackage.Literals.TIME_LOOP_COPY_JOB;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public EList<TimeLoopCopy> getCopies() {
		if (copies == null) {
			copies = new EObjectContainmentEList.Resolving<TimeLoopCopy>(TimeLoopCopy.class, this, IrPackage.TIME_LOOP_COPY_JOB__COPIES);
		}
		return copies;
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
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.TIME_LOOP_COPY_JOB__TIME_LOOP, oldTimeLoop, timeLoop));
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
	@Override
	public void setTimeLoop(TimeLoop newTimeLoop) {
		TimeLoop oldTimeLoop = timeLoop;
		timeLoop = newTimeLoop;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.TIME_LOOP_COPY_JOB__TIME_LOOP, oldTimeLoop, timeLoop));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public NotificationChain eInverseRemove(InternalEObject otherEnd, int featureID, NotificationChain msgs) {
		switch (featureID) {
			case IrPackage.TIME_LOOP_COPY_JOB__COPIES:
				return ((InternalEList<?>)getCopies()).basicRemove(otherEnd, msgs);
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
			case IrPackage.TIME_LOOP_COPY_JOB__COPIES:
				return getCopies();
			case IrPackage.TIME_LOOP_COPY_JOB__TIME_LOOP:
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
			case IrPackage.TIME_LOOP_COPY_JOB__COPIES:
				getCopies().clear();
				getCopies().addAll((Collection<? extends TimeLoopCopy>)newValue);
				return;
			case IrPackage.TIME_LOOP_COPY_JOB__TIME_LOOP:
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
			case IrPackage.TIME_LOOP_COPY_JOB__COPIES:
				getCopies().clear();
				return;
			case IrPackage.TIME_LOOP_COPY_JOB__TIME_LOOP:
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
			case IrPackage.TIME_LOOP_COPY_JOB__COPIES:
				return copies != null && !copies.isEmpty();
			case IrPackage.TIME_LOOP_COPY_JOB__TIME_LOOP:
				return timeLoop != null;
		}
		return super.eIsSet(featureID);
	}

} //TimeLoopCopyJobImpl
