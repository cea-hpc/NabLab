/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.Expression;
import fr.cea.nabla.ir.ir.ExtensionProvider;
import fr.cea.nabla.ir.ir.IrPackage;
import fr.cea.nabla.ir.ir.LinearAlgebraType;

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
 * An implementation of the model object '<em><b>Linear Algebra Type</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.LinearAlgebraTypeImpl#getSizes <em>Sizes</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.LinearAlgebraTypeImpl#getProvider <em>Provider</em>}</li>
 * </ul>
 *
 * @generated
 */
public class LinearAlgebraTypeImpl extends IrTypeImpl implements LinearAlgebraType {
	/**
	 * The cached value of the '{@link #getSizes() <em>Sizes</em>}' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getSizes()
	 * @generated
	 * @ordered
	 */
	protected EList<Expression> sizes;

	/**
	 * The cached value of the '{@link #getProvider() <em>Provider</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getProvider()
	 * @generated
	 * @ordered
	 */
	protected ExtensionProvider provider;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected LinearAlgebraTypeImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return IrPackage.Literals.LINEAR_ALGEBRA_TYPE;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public EList<Expression> getSizes() {
		if (sizes == null) {
			sizes = new EObjectContainmentEList.Resolving<Expression>(Expression.class, this, IrPackage.LINEAR_ALGEBRA_TYPE__SIZES);
		}
		return sizes;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public ExtensionProvider getProvider() {
		if (provider != null && provider.eIsProxy()) {
			InternalEObject oldProvider = (InternalEObject)provider;
			provider = (ExtensionProvider)eResolveProxy(oldProvider);
			if (provider != oldProvider) {
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.LINEAR_ALGEBRA_TYPE__PROVIDER, oldProvider, provider));
			}
		}
		return provider;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public ExtensionProvider basicGetProvider() {
		return provider;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setProvider(ExtensionProvider newProvider) {
		ExtensionProvider oldProvider = provider;
		provider = newProvider;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.LINEAR_ALGEBRA_TYPE__PROVIDER, oldProvider, provider));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public NotificationChain eInverseRemove(InternalEObject otherEnd, int featureID, NotificationChain msgs) {
		switch (featureID) {
			case IrPackage.LINEAR_ALGEBRA_TYPE__SIZES:
				return ((InternalEList<?>)getSizes()).basicRemove(otherEnd, msgs);
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
			case IrPackage.LINEAR_ALGEBRA_TYPE__SIZES:
				return getSizes();
			case IrPackage.LINEAR_ALGEBRA_TYPE__PROVIDER:
				if (resolve) return getProvider();
				return basicGetProvider();
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
			case IrPackage.LINEAR_ALGEBRA_TYPE__SIZES:
				getSizes().clear();
				getSizes().addAll((Collection<? extends Expression>)newValue);
				return;
			case IrPackage.LINEAR_ALGEBRA_TYPE__PROVIDER:
				setProvider((ExtensionProvider)newValue);
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
			case IrPackage.LINEAR_ALGEBRA_TYPE__SIZES:
				getSizes().clear();
				return;
			case IrPackage.LINEAR_ALGEBRA_TYPE__PROVIDER:
				setProvider((ExtensionProvider)null);
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
			case IrPackage.LINEAR_ALGEBRA_TYPE__SIZES:
				return sizes != null && !sizes.isEmpty();
			case IrPackage.LINEAR_ALGEBRA_TYPE__PROVIDER:
				return provider != null;
		}
		return super.eIsSet(featureID);
	}

} //LinearAlgebraTypeImpl
