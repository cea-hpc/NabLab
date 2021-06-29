/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.DefaultExtensionProvider;
import fr.cea.nabla.ir.ir.ExternFunction;
import fr.cea.nabla.ir.ir.IrPackage;

import java.util.Collection;

import org.eclipse.emf.common.notify.Notification;
import org.eclipse.emf.common.notify.NotificationChain;

import org.eclipse.emf.common.util.EList;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;

import org.eclipse.emf.ecore.impl.ENotificationImpl;

import org.eclipse.emf.ecore.util.EObjectContainmentWithInverseEList;
import org.eclipse.emf.ecore.util.InternalEList;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Default Extension Provider</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.DefaultExtensionProviderImpl#getFunctions <em>Functions</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.DefaultExtensionProviderImpl#isLinearAlgebra <em>Linear Algebra</em>}</li>
 * </ul>
 *
 * @generated
 */
public class DefaultExtensionProviderImpl extends ExtensionProviderImpl implements DefaultExtensionProvider {
	/**
	 * The cached value of the '{@link #getFunctions() <em>Functions</em>}' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getFunctions()
	 * @generated
	 * @ordered
	 */
	protected EList<ExternFunction> functions;

	/**
	 * The default value of the '{@link #isLinearAlgebra() <em>Linear Algebra</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #isLinearAlgebra()
	 * @generated
	 * @ordered
	 */
	protected static final boolean LINEAR_ALGEBRA_EDEFAULT = false;

	/**
	 * The cached value of the '{@link #isLinearAlgebra() <em>Linear Algebra</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #isLinearAlgebra()
	 * @generated
	 * @ordered
	 */
	protected boolean linearAlgebra = LINEAR_ALGEBRA_EDEFAULT;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected DefaultExtensionProviderImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return IrPackage.Literals.DEFAULT_EXTENSION_PROVIDER;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public EList<ExternFunction> getFunctions() {
		if (functions == null) {
			functions = new EObjectContainmentWithInverseEList<ExternFunction>(ExternFunction.class, this, IrPackage.DEFAULT_EXTENSION_PROVIDER__FUNCTIONS, IrPackage.EXTERN_FUNCTION__PROVIDER);
		}
		return functions;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public boolean isLinearAlgebra() {
		return linearAlgebra;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setLinearAlgebra(boolean newLinearAlgebra) {
		boolean oldLinearAlgebra = linearAlgebra;
		linearAlgebra = newLinearAlgebra;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.DEFAULT_EXTENSION_PROVIDER__LINEAR_ALGEBRA, oldLinearAlgebra, linearAlgebra));
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
			case IrPackage.DEFAULT_EXTENSION_PROVIDER__FUNCTIONS:
				return ((InternalEList<InternalEObject>)(InternalEList<?>)getFunctions()).basicAdd(otherEnd, msgs);
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
			case IrPackage.DEFAULT_EXTENSION_PROVIDER__FUNCTIONS:
				return ((InternalEList<?>)getFunctions()).basicRemove(otherEnd, msgs);
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
			case IrPackage.DEFAULT_EXTENSION_PROVIDER__FUNCTIONS:
				return getFunctions();
			case IrPackage.DEFAULT_EXTENSION_PROVIDER__LINEAR_ALGEBRA:
				return isLinearAlgebra();
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
			case IrPackage.DEFAULT_EXTENSION_PROVIDER__FUNCTIONS:
				getFunctions().clear();
				getFunctions().addAll((Collection<? extends ExternFunction>)newValue);
				return;
			case IrPackage.DEFAULT_EXTENSION_PROVIDER__LINEAR_ALGEBRA:
				setLinearAlgebra((Boolean)newValue);
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
			case IrPackage.DEFAULT_EXTENSION_PROVIDER__FUNCTIONS:
				getFunctions().clear();
				return;
			case IrPackage.DEFAULT_EXTENSION_PROVIDER__LINEAR_ALGEBRA:
				setLinearAlgebra(LINEAR_ALGEBRA_EDEFAULT);
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
			case IrPackage.DEFAULT_EXTENSION_PROVIDER__FUNCTIONS:
				return functions != null && !functions.isEmpty();
			case IrPackage.DEFAULT_EXTENSION_PROVIDER__LINEAR_ALGEBRA:
				return linearAlgebra != LINEAR_ALGEBRA_EDEFAULT;
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
		result.append(" (linearAlgebra: ");
		result.append(linearAlgebra);
		result.append(')');
		return result.toString();
	}

} //DefaultExtensionProviderImpl
