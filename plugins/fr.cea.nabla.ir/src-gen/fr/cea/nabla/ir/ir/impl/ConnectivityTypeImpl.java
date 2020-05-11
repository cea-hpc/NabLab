/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.BaseType;
import fr.cea.nabla.ir.ir.Connectivity;
import fr.cea.nabla.ir.ir.ConnectivityType;
import fr.cea.nabla.ir.ir.IrPackage;

import java.util.Collection;

import org.eclipse.emf.common.notify.Notification;
import org.eclipse.emf.common.notify.NotificationChain;

import org.eclipse.emf.common.util.EList;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;

import org.eclipse.emf.ecore.impl.ENotificationImpl;

import org.eclipse.emf.ecore.util.EObjectResolvingEList;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Connectivity Type</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.ConnectivityTypeImpl#getConnectivities <em>Connectivities</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.ConnectivityTypeImpl#getBase <em>Base</em>}</li>
 * </ul>
 *
 * @generated
 */
public class ConnectivityTypeImpl extends IrTypeImpl implements ConnectivityType {
	/**
	 * The cached value of the '{@link #getConnectivities() <em>Connectivities</em>}' reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getConnectivities()
	 * @generated
	 * @ordered
	 */
	protected EList<Connectivity> connectivities;

	/**
	 * The cached value of the '{@link #getBase() <em>Base</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getBase()
	 * @generated
	 * @ordered
	 */
	protected BaseType base;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected ConnectivityTypeImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return IrPackage.Literals.CONNECTIVITY_TYPE;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated NOT 
	 * FIXME workaround BUG 89325
	 */
	@SuppressWarnings("serial")
	public EList<Connectivity> getConnectivities() {
		if (connectivities == null) {
			connectivities = new EObjectResolvingEList<Connectivity>(Connectivity.class, this, IrPackage.CONNECTIVITY_TYPE__CONNECTIVITIES) {
				@Override
			protected boolean isUnique() { return false; }
			};
		}
		return connectivities;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public BaseType getBase() {
		if (base != null && base.eIsProxy()) {
			InternalEObject oldBase = (InternalEObject)base;
			base = (BaseType)eResolveProxy(oldBase);
			if (base != oldBase) {
				InternalEObject newBase = (InternalEObject)base;
				NotificationChain msgs = oldBase.eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.CONNECTIVITY_TYPE__BASE, null, null);
				if (newBase.eInternalContainer() == null) {
					msgs = newBase.eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.CONNECTIVITY_TYPE__BASE, null, msgs);
				}
				if (msgs != null) msgs.dispatch();
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.CONNECTIVITY_TYPE__BASE, oldBase, base));
			}
		}
		return base;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public BaseType basicGetBase() {
		return base;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetBase(BaseType newBase, NotificationChain msgs) {
		BaseType oldBase = base;
		base = newBase;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.CONNECTIVITY_TYPE__BASE, oldBase, newBase);
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
	public void setBase(BaseType newBase) {
		if (newBase != base) {
			NotificationChain msgs = null;
			if (base != null)
				msgs = ((InternalEObject)base).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.CONNECTIVITY_TYPE__BASE, null, msgs);
			if (newBase != null)
				msgs = ((InternalEObject)newBase).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.CONNECTIVITY_TYPE__BASE, null, msgs);
			msgs = basicSetBase(newBase, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.CONNECTIVITY_TYPE__BASE, newBase, newBase));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public NotificationChain eInverseRemove(InternalEObject otherEnd, int featureID, NotificationChain msgs) {
		switch (featureID) {
			case IrPackage.CONNECTIVITY_TYPE__BASE:
				return basicSetBase(null, msgs);
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
			case IrPackage.CONNECTIVITY_TYPE__CONNECTIVITIES:
				return getConnectivities();
			case IrPackage.CONNECTIVITY_TYPE__BASE:
				if (resolve) return getBase();
				return basicGetBase();
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
			case IrPackage.CONNECTIVITY_TYPE__CONNECTIVITIES:
				getConnectivities().clear();
				getConnectivities().addAll((Collection<? extends Connectivity>)newValue);
				return;
			case IrPackage.CONNECTIVITY_TYPE__BASE:
				setBase((BaseType)newValue);
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
			case IrPackage.CONNECTIVITY_TYPE__CONNECTIVITIES:
				getConnectivities().clear();
				return;
			case IrPackage.CONNECTIVITY_TYPE__BASE:
				setBase((BaseType)null);
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
			case IrPackage.CONNECTIVITY_TYPE__CONNECTIVITIES:
				return connectivities != null && !connectivities.isEmpty();
			case IrPackage.CONNECTIVITY_TYPE__BASE:
				return base != null;
		}
		return super.eIsSet(featureID);
	}

} //ConnectivityTypeImpl
