/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.IrPackage;
import fr.cea.nabla.ir.ir.TimeIterationCopyJob;
import fr.cea.nabla.ir.ir.Variable;

import org.eclipse.emf.common.notify.Notification;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;

import org.eclipse.emf.ecore.impl.ENotificationImpl;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Time Iteration Copy Job</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.TimeIterationCopyJobImpl#getLeft <em>Left</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.TimeIterationCopyJobImpl#getRight <em>Right</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.TimeIterationCopyJobImpl#getTimeIteratorName <em>Time Iterator Name</em>}</li>
 * </ul>
 *
 * @generated
 */
public abstract class TimeIterationCopyJobImpl extends JobImpl implements TimeIterationCopyJob {
	/**
	 * The cached value of the '{@link #getLeft() <em>Left</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getLeft()
	 * @generated
	 * @ordered
	 */
	protected Variable left;

	/**
	 * The cached value of the '{@link #getRight() <em>Right</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getRight()
	 * @generated
	 * @ordered
	 */
	protected Variable right;

	/**
	 * The default value of the '{@link #getTimeIteratorName() <em>Time Iterator Name</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getTimeIteratorName()
	 * @generated
	 * @ordered
	 */
	protected static final String TIME_ITERATOR_NAME_EDEFAULT = null;

	/**
	 * The cached value of the '{@link #getTimeIteratorName() <em>Time Iterator Name</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getTimeIteratorName()
	 * @generated
	 * @ordered
	 */
	protected String timeIteratorName = TIME_ITERATOR_NAME_EDEFAULT;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected TimeIterationCopyJobImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return IrPackage.Literals.TIME_ITERATION_COPY_JOB;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Variable getLeft() {
		if (left != null && left.eIsProxy()) {
			InternalEObject oldLeft = (InternalEObject)left;
			left = (Variable)eResolveProxy(oldLeft);
			if (left != oldLeft) {
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.TIME_ITERATION_COPY_JOB__LEFT, oldLeft, left));
			}
		}
		return left;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Variable basicGetLeft() {
		return left;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setLeft(Variable newLeft) {
		Variable oldLeft = left;
		left = newLeft;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.TIME_ITERATION_COPY_JOB__LEFT, oldLeft, left));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Variable getRight() {
		if (right != null && right.eIsProxy()) {
			InternalEObject oldRight = (InternalEObject)right;
			right = (Variable)eResolveProxy(oldRight);
			if (right != oldRight) {
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.TIME_ITERATION_COPY_JOB__RIGHT, oldRight, right));
			}
		}
		return right;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Variable basicGetRight() {
		return right;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setRight(Variable newRight) {
		Variable oldRight = right;
		right = newRight;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.TIME_ITERATION_COPY_JOB__RIGHT, oldRight, right));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public String getTimeIteratorName() {
		return timeIteratorName;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setTimeIteratorName(String newTimeIteratorName) {
		String oldTimeIteratorName = timeIteratorName;
		timeIteratorName = newTimeIteratorName;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.TIME_ITERATION_COPY_JOB__TIME_ITERATOR_NAME, oldTimeIteratorName, timeIteratorName));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Object eGet(int featureID, boolean resolve, boolean coreType) {
		switch (featureID) {
			case IrPackage.TIME_ITERATION_COPY_JOB__LEFT:
				if (resolve) return getLeft();
				return basicGetLeft();
			case IrPackage.TIME_ITERATION_COPY_JOB__RIGHT:
				if (resolve) return getRight();
				return basicGetRight();
			case IrPackage.TIME_ITERATION_COPY_JOB__TIME_ITERATOR_NAME:
				return getTimeIteratorName();
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
			case IrPackage.TIME_ITERATION_COPY_JOB__LEFT:
				setLeft((Variable)newValue);
				return;
			case IrPackage.TIME_ITERATION_COPY_JOB__RIGHT:
				setRight((Variable)newValue);
				return;
			case IrPackage.TIME_ITERATION_COPY_JOB__TIME_ITERATOR_NAME:
				setTimeIteratorName((String)newValue);
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
			case IrPackage.TIME_ITERATION_COPY_JOB__LEFT:
				setLeft((Variable)null);
				return;
			case IrPackage.TIME_ITERATION_COPY_JOB__RIGHT:
				setRight((Variable)null);
				return;
			case IrPackage.TIME_ITERATION_COPY_JOB__TIME_ITERATOR_NAME:
				setTimeIteratorName(TIME_ITERATOR_NAME_EDEFAULT);
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
			case IrPackage.TIME_ITERATION_COPY_JOB__LEFT:
				return left != null;
			case IrPackage.TIME_ITERATION_COPY_JOB__RIGHT:
				return right != null;
			case IrPackage.TIME_ITERATION_COPY_JOB__TIME_ITERATOR_NAME:
				return TIME_ITERATOR_NAME_EDEFAULT == null ? timeIteratorName != null : !TIME_ITERATOR_NAME_EDEFAULT.equals(timeIteratorName);
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
		result.append(" (timeIteratorName: ");
		result.append(timeIteratorName);
		result.append(')');
		return result.toString();
	}

} //TimeIterationCopyJobImpl
