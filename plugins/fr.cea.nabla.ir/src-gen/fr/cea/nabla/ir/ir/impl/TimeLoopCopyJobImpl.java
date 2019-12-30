/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.IrPackage;
import fr.cea.nabla.ir.ir.TimeLoopCopy;
import fr.cea.nabla.ir.ir.TimeLoopCopyJob;

import fr.cea.nabla.ir.ir.TimeLoopJob;
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
 *   <li>{@link fr.cea.nabla.ir.ir.impl.TimeLoopCopyJobImpl#getAssociatedTimeLoop <em>Associated Time Loop</em>}</li>
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
	 * The cached value of the '{@link #getAssociatedTimeLoop() <em>Associated Time Loop</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getAssociatedTimeLoop()
	 * @generated
	 * @ordered
	 */
	protected TimeLoopJob associatedTimeLoop;

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
	public TimeLoopJob getAssociatedTimeLoop() {
		if (associatedTimeLoop != null && associatedTimeLoop.eIsProxy()) {
			InternalEObject oldAssociatedTimeLoop = (InternalEObject)associatedTimeLoop;
			associatedTimeLoop = (TimeLoopJob)eResolveProxy(oldAssociatedTimeLoop);
			if (associatedTimeLoop != oldAssociatedTimeLoop) {
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.TIME_LOOP_COPY_JOB__ASSOCIATED_TIME_LOOP, oldAssociatedTimeLoop, associatedTimeLoop));
			}
		}
		return associatedTimeLoop;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public TimeLoopJob basicGetAssociatedTimeLoop() {
		return associatedTimeLoop;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setAssociatedTimeLoop(TimeLoopJob newAssociatedTimeLoop) {
		TimeLoopJob oldAssociatedTimeLoop = associatedTimeLoop;
		associatedTimeLoop = newAssociatedTimeLoop;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.TIME_LOOP_COPY_JOB__ASSOCIATED_TIME_LOOP, oldAssociatedTimeLoop, associatedTimeLoop));
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
			case IrPackage.TIME_LOOP_COPY_JOB__ASSOCIATED_TIME_LOOP:
				if (resolve) return getAssociatedTimeLoop();
				return basicGetAssociatedTimeLoop();
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
			case IrPackage.TIME_LOOP_COPY_JOB__ASSOCIATED_TIME_LOOP:
				setAssociatedTimeLoop((TimeLoopJob)newValue);
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
			case IrPackage.TIME_LOOP_COPY_JOB__ASSOCIATED_TIME_LOOP:
				setAssociatedTimeLoop((TimeLoopJob)null);
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
			case IrPackage.TIME_LOOP_COPY_JOB__ASSOCIATED_TIME_LOOP:
				return associatedTimeLoop != null;
		}
		return super.eIsSet(featureID);
	}

} //TimeLoopCopyJobImpl
