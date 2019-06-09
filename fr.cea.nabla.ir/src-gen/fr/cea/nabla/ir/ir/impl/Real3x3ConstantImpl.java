/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.IrPackage;
import fr.cea.nabla.ir.ir.Real3Constant;
import fr.cea.nabla.ir.ir.Real3x3Constant;

import org.eclipse.emf.common.notify.Notification;
import org.eclipse.emf.common.notify.NotificationChain;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;

import org.eclipse.emf.ecore.impl.ENotificationImpl;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Real3x3 Constant</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.Real3x3ConstantImpl#getX <em>X</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.Real3x3ConstantImpl#getY <em>Y</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.Real3x3ConstantImpl#getZ <em>Z</em>}</li>
 * </ul>
 *
 * @generated
 */
public class Real3x3ConstantImpl extends ExpressionImpl implements Real3x3Constant {
	/**
	 * The cached value of the '{@link #getX() <em>X</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getX()
	 * @generated
	 * @ordered
	 */
	protected Real3Constant x;

	/**
	 * The cached value of the '{@link #getY() <em>Y</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getY()
	 * @generated
	 * @ordered
	 */
	protected Real3Constant y;

	/**
	 * The cached value of the '{@link #getZ() <em>Z</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getZ()
	 * @generated
	 * @ordered
	 */
	protected Real3Constant z;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected Real3x3ConstantImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return IrPackage.Literals.REAL3X3_CONSTANT;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Real3Constant getX() {
		return x;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetX(Real3Constant newX, NotificationChain msgs) {
		Real3Constant oldX = x;
		x = newX;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.REAL3X3_CONSTANT__X, oldX, newX);
			if (msgs == null) msgs = notification; else msgs.add(notification);
		}
		return msgs;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setX(Real3Constant newX) {
		if (newX != x) {
			NotificationChain msgs = null;
			if (x != null)
				msgs = ((InternalEObject)x).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.REAL3X3_CONSTANT__X, null, msgs);
			if (newX != null)
				msgs = ((InternalEObject)newX).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.REAL3X3_CONSTANT__X, null, msgs);
			msgs = basicSetX(newX, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.REAL3X3_CONSTANT__X, newX, newX));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Real3Constant getY() {
		return y;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetY(Real3Constant newY, NotificationChain msgs) {
		Real3Constant oldY = y;
		y = newY;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.REAL3X3_CONSTANT__Y, oldY, newY);
			if (msgs == null) msgs = notification; else msgs.add(notification);
		}
		return msgs;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setY(Real3Constant newY) {
		if (newY != y) {
			NotificationChain msgs = null;
			if (y != null)
				msgs = ((InternalEObject)y).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.REAL3X3_CONSTANT__Y, null, msgs);
			if (newY != null)
				msgs = ((InternalEObject)newY).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.REAL3X3_CONSTANT__Y, null, msgs);
			msgs = basicSetY(newY, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.REAL3X3_CONSTANT__Y, newY, newY));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Real3Constant getZ() {
		return z;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetZ(Real3Constant newZ, NotificationChain msgs) {
		Real3Constant oldZ = z;
		z = newZ;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.REAL3X3_CONSTANT__Z, oldZ, newZ);
			if (msgs == null) msgs = notification; else msgs.add(notification);
		}
		return msgs;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setZ(Real3Constant newZ) {
		if (newZ != z) {
			NotificationChain msgs = null;
			if (z != null)
				msgs = ((InternalEObject)z).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.REAL3X3_CONSTANT__Z, null, msgs);
			if (newZ != null)
				msgs = ((InternalEObject)newZ).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.REAL3X3_CONSTANT__Z, null, msgs);
			msgs = basicSetZ(newZ, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.REAL3X3_CONSTANT__Z, newZ, newZ));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public NotificationChain eInverseRemove(InternalEObject otherEnd, int featureID, NotificationChain msgs) {
		switch (featureID) {
			case IrPackage.REAL3X3_CONSTANT__X:
				return basicSetX(null, msgs);
			case IrPackage.REAL3X3_CONSTANT__Y:
				return basicSetY(null, msgs);
			case IrPackage.REAL3X3_CONSTANT__Z:
				return basicSetZ(null, msgs);
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
			case IrPackage.REAL3X3_CONSTANT__X:
				return getX();
			case IrPackage.REAL3X3_CONSTANT__Y:
				return getY();
			case IrPackage.REAL3X3_CONSTANT__Z:
				return getZ();
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
			case IrPackage.REAL3X3_CONSTANT__X:
				setX((Real3Constant)newValue);
				return;
			case IrPackage.REAL3X3_CONSTANT__Y:
				setY((Real3Constant)newValue);
				return;
			case IrPackage.REAL3X3_CONSTANT__Z:
				setZ((Real3Constant)newValue);
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
			case IrPackage.REAL3X3_CONSTANT__X:
				setX((Real3Constant)null);
				return;
			case IrPackage.REAL3X3_CONSTANT__Y:
				setY((Real3Constant)null);
				return;
			case IrPackage.REAL3X3_CONSTANT__Z:
				setZ((Real3Constant)null);
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
			case IrPackage.REAL3X3_CONSTANT__X:
				return x != null;
			case IrPackage.REAL3X3_CONSTANT__Y:
				return y != null;
			case IrPackage.REAL3X3_CONSTANT__Z:
				return z != null;
		}
		return super.eIsSet(featureID);
	}

} //Real3x3ConstantImpl
