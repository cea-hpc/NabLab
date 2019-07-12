/**
 */
package fr.cea.nabla.ir.ir.impl;

import java.util.Collection;

import org.eclipse.emf.common.notify.Notification;
import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.impl.ENotificationImpl;
import org.eclipse.emf.ecore.util.EDataTypeEList;
import fr.cea.nabla.ir.ir.BaseType;
import fr.cea.nabla.ir.ir.IrPackage;
import fr.cea.nabla.ir.ir.PrimitiveType;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Base Type</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.BaseTypeImpl#getRoot <em>Root</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.BaseTypeImpl#getSizes <em>Sizes</em>}</li>
 * </ul>
 *
 * @generated
 */
public class BaseTypeImpl extends IrAnnotableImpl implements BaseType {
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
	 * The cached value of the '{@link #getSizes() <em>Sizes</em>}' attribute list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getSizes()
	 * @generated
	 * @ordered
	 */
	protected EList<Integer> sizes;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected BaseTypeImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return IrPackage.Literals.BASE_TYPE;
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
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.BASE_TYPE__ROOT, oldRoot, root));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EList<Integer> getSizes() {
		if (sizes == null) {
			sizes = new EDataTypeEList<Integer>(Integer.class, this, IrPackage.BASE_TYPE__SIZES);
		}
		return sizes;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Object eGet(int featureID, boolean resolve, boolean coreType) {
		switch (featureID) {
			case IrPackage.BASE_TYPE__ROOT:
				return getRoot();
			case IrPackage.BASE_TYPE__SIZES:
				return getSizes();
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
			case IrPackage.BASE_TYPE__ROOT:
				setRoot((PrimitiveType)newValue);
				return;
			case IrPackage.BASE_TYPE__SIZES:
				getSizes().clear();
				getSizes().addAll((Collection<? extends Integer>)newValue);
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
			case IrPackage.BASE_TYPE__ROOT:
				setRoot(ROOT_EDEFAULT);
				return;
			case IrPackage.BASE_TYPE__SIZES:
				getSizes().clear();
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
			case IrPackage.BASE_TYPE__ROOT:
				return root != ROOT_EDEFAULT;
			case IrPackage.BASE_TYPE__SIZES:
				return sizes != null && !sizes.isEmpty();
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
		result.append(", sizes: ");
		result.append(sizes);
		result.append(')');
		return result.toString();
	}
} //BaseTypeImpl
