/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.IrPackage;
import fr.cea.nabla.ir.ir.SizeType;
import fr.cea.nabla.ir.ir.SizeTypeOperation;

import org.eclipse.emf.common.notify.Notification;
import org.eclipse.emf.common.notify.NotificationChain;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;

import org.eclipse.emf.ecore.impl.ENotificationImpl;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Size Type Operation</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.SizeTypeOperationImpl#getLeft <em>Left</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.SizeTypeOperationImpl#getRight <em>Right</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.SizeTypeOperationImpl#getOperator <em>Operator</em>}</li>
 * </ul>
 *
 * @generated
 */
public class SizeTypeOperationImpl extends SizeTypeImpl implements SizeTypeOperation {
	/**
	 * The cached value of the '{@link #getLeft() <em>Left</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getLeft()
	 * @generated
	 * @ordered
	 */
	protected SizeType left;

	/**
	 * The cached value of the '{@link #getRight() <em>Right</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getRight()
	 * @generated
	 * @ordered
	 */
	protected SizeType right;

	/**
	 * The default value of the '{@link #getOperator() <em>Operator</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getOperator()
	 * @generated
	 * @ordered
	 */
	protected static final String OPERATOR_EDEFAULT = null;

	/**
	 * The cached value of the '{@link #getOperator() <em>Operator</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getOperator()
	 * @generated
	 * @ordered
	 */
	protected String operator = OPERATOR_EDEFAULT;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected SizeTypeOperationImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return IrPackage.Literals.SIZE_TYPE_OPERATION;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public SizeType getLeft() {
		if (left != null && left.eIsProxy()) {
			InternalEObject oldLeft = (InternalEObject)left;
			left = (SizeType)eResolveProxy(oldLeft);
			if (left != oldLeft) {
				InternalEObject newLeft = (InternalEObject)left;
				NotificationChain msgs = oldLeft.eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.SIZE_TYPE_OPERATION__LEFT, null, null);
				if (newLeft.eInternalContainer() == null) {
					msgs = newLeft.eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.SIZE_TYPE_OPERATION__LEFT, null, msgs);
				}
				if (msgs != null) msgs.dispatch();
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.SIZE_TYPE_OPERATION__LEFT, oldLeft, left));
			}
		}
		return left;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public SizeType basicGetLeft() {
		return left;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetLeft(SizeType newLeft, NotificationChain msgs) {
		SizeType oldLeft = left;
		left = newLeft;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.SIZE_TYPE_OPERATION__LEFT, oldLeft, newLeft);
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
	public void setLeft(SizeType newLeft) {
		if (newLeft != left) {
			NotificationChain msgs = null;
			if (left != null)
				msgs = ((InternalEObject)left).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.SIZE_TYPE_OPERATION__LEFT, null, msgs);
			if (newLeft != null)
				msgs = ((InternalEObject)newLeft).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.SIZE_TYPE_OPERATION__LEFT, null, msgs);
			msgs = basicSetLeft(newLeft, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.SIZE_TYPE_OPERATION__LEFT, newLeft, newLeft));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public SizeType getRight() {
		if (right != null && right.eIsProxy()) {
			InternalEObject oldRight = (InternalEObject)right;
			right = (SizeType)eResolveProxy(oldRight);
			if (right != oldRight) {
				InternalEObject newRight = (InternalEObject)right;
				NotificationChain msgs = oldRight.eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.SIZE_TYPE_OPERATION__RIGHT, null, null);
				if (newRight.eInternalContainer() == null) {
					msgs = newRight.eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.SIZE_TYPE_OPERATION__RIGHT, null, msgs);
				}
				if (msgs != null) msgs.dispatch();
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.SIZE_TYPE_OPERATION__RIGHT, oldRight, right));
			}
		}
		return right;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public SizeType basicGetRight() {
		return right;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetRight(SizeType newRight, NotificationChain msgs) {
		SizeType oldRight = right;
		right = newRight;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.SIZE_TYPE_OPERATION__RIGHT, oldRight, newRight);
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
	public void setRight(SizeType newRight) {
		if (newRight != right) {
			NotificationChain msgs = null;
			if (right != null)
				msgs = ((InternalEObject)right).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.SIZE_TYPE_OPERATION__RIGHT, null, msgs);
			if (newRight != null)
				msgs = ((InternalEObject)newRight).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.SIZE_TYPE_OPERATION__RIGHT, null, msgs);
			msgs = basicSetRight(newRight, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.SIZE_TYPE_OPERATION__RIGHT, newRight, newRight));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public String getOperator() {
		return operator;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setOperator(String newOperator) {
		String oldOperator = operator;
		operator = newOperator;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.SIZE_TYPE_OPERATION__OPERATOR, oldOperator, operator));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public NotificationChain eInverseRemove(InternalEObject otherEnd, int featureID, NotificationChain msgs) {
		switch (featureID) {
			case IrPackage.SIZE_TYPE_OPERATION__LEFT:
				return basicSetLeft(null, msgs);
			case IrPackage.SIZE_TYPE_OPERATION__RIGHT:
				return basicSetRight(null, msgs);
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
			case IrPackage.SIZE_TYPE_OPERATION__LEFT:
				if (resolve) return getLeft();
				return basicGetLeft();
			case IrPackage.SIZE_TYPE_OPERATION__RIGHT:
				if (resolve) return getRight();
				return basicGetRight();
			case IrPackage.SIZE_TYPE_OPERATION__OPERATOR:
				return getOperator();
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
			case IrPackage.SIZE_TYPE_OPERATION__LEFT:
				setLeft((SizeType)newValue);
				return;
			case IrPackage.SIZE_TYPE_OPERATION__RIGHT:
				setRight((SizeType)newValue);
				return;
			case IrPackage.SIZE_TYPE_OPERATION__OPERATOR:
				setOperator((String)newValue);
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
			case IrPackage.SIZE_TYPE_OPERATION__LEFT:
				setLeft((SizeType)null);
				return;
			case IrPackage.SIZE_TYPE_OPERATION__RIGHT:
				setRight((SizeType)null);
				return;
			case IrPackage.SIZE_TYPE_OPERATION__OPERATOR:
				setOperator(OPERATOR_EDEFAULT);
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
			case IrPackage.SIZE_TYPE_OPERATION__LEFT:
				return left != null;
			case IrPackage.SIZE_TYPE_OPERATION__RIGHT:
				return right != null;
			case IrPackage.SIZE_TYPE_OPERATION__OPERATOR:
				return OPERATOR_EDEFAULT == null ? operator != null : !OPERATOR_EDEFAULT.equals(operator);
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
		result.append(" (operator: ");
		result.append(operator);
		result.append(')');
		return result.toString();
	}

} //SizeTypeOperationImpl
