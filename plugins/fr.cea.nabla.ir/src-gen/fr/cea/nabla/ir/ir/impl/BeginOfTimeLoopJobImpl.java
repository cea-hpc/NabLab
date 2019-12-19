/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.BeginOfTimeLoopJob;
import fr.cea.nabla.ir.ir.EndOfTimeLoopJob;
import fr.cea.nabla.ir.ir.IrPackage;

import fr.cea.nabla.ir.ir.TimeLoopCopy;
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
 * An implementation of the model object '<em><b>Begin Of Time Loop Job</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.BeginOfTimeLoopJobImpl#getEnd <em>End</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.BeginOfTimeLoopJobImpl#getInitializations <em>Initializations</em>}</li>
 * </ul>
 *
 * @generated
 */
public class BeginOfTimeLoopJobImpl extends JobImpl implements BeginOfTimeLoopJob {
	/**
	 * The cached value of the '{@link #getEnd() <em>End</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getEnd()
	 * @generated
	 * @ordered
	 */
	protected EndOfTimeLoopJob end;

	/**
	 * The cached value of the '{@link #getInitializations() <em>Initializations</em>}' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getInitializations()
	 * @generated
	 * @ordered
	 */
	protected EList<TimeLoopCopy> initializations;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected BeginOfTimeLoopJobImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return IrPackage.Literals.BEGIN_OF_TIME_LOOP_JOB;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public EndOfTimeLoopJob getEnd() {
		if (end != null && end.eIsProxy()) {
			InternalEObject oldEnd = (InternalEObject)end;
			end = (EndOfTimeLoopJob)eResolveProxy(oldEnd);
			if (end != oldEnd) {
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.BEGIN_OF_TIME_LOOP_JOB__END, oldEnd, end));
			}
		}
		return end;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EndOfTimeLoopJob basicGetEnd() {
		return end;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetEnd(EndOfTimeLoopJob newEnd, NotificationChain msgs) {
		EndOfTimeLoopJob oldEnd = end;
		end = newEnd;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.BEGIN_OF_TIME_LOOP_JOB__END, oldEnd, newEnd);
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
	public void setEnd(EndOfTimeLoopJob newEnd) {
		if (newEnd != end) {
			NotificationChain msgs = null;
			if (end != null)
				msgs = ((InternalEObject)end).eInverseRemove(this, IrPackage.END_OF_TIME_LOOP_JOB__BEGIN, EndOfTimeLoopJob.class, msgs);
			if (newEnd != null)
				msgs = ((InternalEObject)newEnd).eInverseAdd(this, IrPackage.END_OF_TIME_LOOP_JOB__BEGIN, EndOfTimeLoopJob.class, msgs);
			msgs = basicSetEnd(newEnd, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.BEGIN_OF_TIME_LOOP_JOB__END, newEnd, newEnd));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public EList<TimeLoopCopy> getInitializations() {
		if (initializations == null) {
			initializations = new EObjectContainmentEList.Resolving<TimeLoopCopy>(TimeLoopCopy.class, this, IrPackage.BEGIN_OF_TIME_LOOP_JOB__INITIALIZATIONS);
		}
		return initializations;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public NotificationChain eInverseAdd(InternalEObject otherEnd, int featureID, NotificationChain msgs) {
		switch (featureID) {
			case IrPackage.BEGIN_OF_TIME_LOOP_JOB__END:
				if (end != null)
					msgs = ((InternalEObject)end).eInverseRemove(this, IrPackage.END_OF_TIME_LOOP_JOB__BEGIN, EndOfTimeLoopJob.class, msgs);
				return basicSetEnd((EndOfTimeLoopJob)otherEnd, msgs);
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
			case IrPackage.BEGIN_OF_TIME_LOOP_JOB__END:
				return basicSetEnd(null, msgs);
			case IrPackage.BEGIN_OF_TIME_LOOP_JOB__INITIALIZATIONS:
				return ((InternalEList<?>)getInitializations()).basicRemove(otherEnd, msgs);
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
			case IrPackage.BEGIN_OF_TIME_LOOP_JOB__END:
				if (resolve) return getEnd();
				return basicGetEnd();
			case IrPackage.BEGIN_OF_TIME_LOOP_JOB__INITIALIZATIONS:
				return getInitializations();
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
			case IrPackage.BEGIN_OF_TIME_LOOP_JOB__END:
				setEnd((EndOfTimeLoopJob)newValue);
				return;
			case IrPackage.BEGIN_OF_TIME_LOOP_JOB__INITIALIZATIONS:
				getInitializations().clear();
				getInitializations().addAll((Collection<? extends TimeLoopCopy>)newValue);
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
			case IrPackage.BEGIN_OF_TIME_LOOP_JOB__END:
				setEnd((EndOfTimeLoopJob)null);
				return;
			case IrPackage.BEGIN_OF_TIME_LOOP_JOB__INITIALIZATIONS:
				getInitializations().clear();
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
			case IrPackage.BEGIN_OF_TIME_LOOP_JOB__END:
				return end != null;
			case IrPackage.BEGIN_OF_TIME_LOOP_JOB__INITIALIZATIONS:
				return initializations != null && !initializations.isEmpty();
		}
		return super.eIsSet(featureID);
	}

} //BeginOfTimeLoopJobImpl
