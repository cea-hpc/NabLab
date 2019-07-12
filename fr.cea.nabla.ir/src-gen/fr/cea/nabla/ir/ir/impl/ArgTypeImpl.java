/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.ArgType;
import fr.cea.nabla.ir.ir.IrPackage;
import fr.cea.nabla.ir.ir.PrimitiveType;

import org.eclipse.emf.common.notify.Notification;

import org.eclipse.emf.ecore.EClass;

import org.eclipse.emf.ecore.impl.ENotificationImpl;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Arg Type</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.ArgTypeImpl#getRoot <em>Root</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.ArgTypeImpl#getArrayDimension <em>Array Dimension</em>}</li>
 * </ul>
 *
 * @generated
 */
public class ArgTypeImpl extends IrAnnotableImpl implements ArgType {
	/**
	 * The default value of the '{@link #getRoot() <em>Root</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getRoot()
	 * @generated
	 * @ordered
	 */
	protected static final PrimitiveType ROOT_EDEFAULT = PrimitiveType.VOID;

	/**
	 * The cached value of the '{@link #getRoot() <em>Root</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getRoot()
	 * @generated
	 * @ordered
	 */
	protected PrimitiveType root = ROOT_EDEFAULT;

	/**
	 * The default value of the '{@link #getArrayDimension() <em>Array Dimension</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getArrayDimension()
	 * @generated
	 * @ordered
	 */
	protected static final int ARRAY_DIMENSION_EDEFAULT = 0;

	/**
	 * The cached value of the '{@link #getArrayDimension() <em>Array Dimension</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getArrayDimension()
	 * @generated
	 * @ordered
	 */
	protected int arrayDimension = ARRAY_DIMENSION_EDEFAULT;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected ArgTypeImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return IrPackage.Literals.ARG_TYPE;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public PrimitiveType getRoot() {
		return root;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setRoot(PrimitiveType newRoot) {
		PrimitiveType oldRoot = root;
		root = newRoot == null ? ROOT_EDEFAULT : newRoot;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.ARG_TYPE__ROOT, oldRoot, root));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public int getArrayDimension() {
		return arrayDimension;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setArrayDimension(int newArrayDimension) {
		int oldArrayDimension = arrayDimension;
		arrayDimension = newArrayDimension;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.ARG_TYPE__ARRAY_DIMENSION, oldArrayDimension, arrayDimension));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Object eGet(int featureID, boolean resolve, boolean coreType) {
		switch (featureID) {
			case IrPackage.ARG_TYPE__ROOT:
				return getRoot();
			case IrPackage.ARG_TYPE__ARRAY_DIMENSION:
				return getArrayDimension();
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
			case IrPackage.ARG_TYPE__ROOT:
				setRoot((PrimitiveType)newValue);
				return;
			case IrPackage.ARG_TYPE__ARRAY_DIMENSION:
				setArrayDimension((Integer)newValue);
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
			case IrPackage.ARG_TYPE__ROOT:
				setRoot(ROOT_EDEFAULT);
				return;
			case IrPackage.ARG_TYPE__ARRAY_DIMENSION:
				setArrayDimension(ARRAY_DIMENSION_EDEFAULT);
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
			case IrPackage.ARG_TYPE__ROOT:
				return root != ROOT_EDEFAULT;
			case IrPackage.ARG_TYPE__ARRAY_DIMENSION:
				return arrayDimension != ARRAY_DIMENSION_EDEFAULT;
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
		result.append(" (root: ");
		result.append(root);
		result.append(", arrayDimension: ");
		result.append(arrayDimension);
		result.append(')');
		return result.toString();
	}

} //ArgTypeImpl
