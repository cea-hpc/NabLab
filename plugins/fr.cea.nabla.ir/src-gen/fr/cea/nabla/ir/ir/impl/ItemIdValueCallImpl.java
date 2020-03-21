/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.ConnectivityCall;
import fr.cea.nabla.ir.ir.IrPackage;
import fr.cea.nabla.ir.ir.ItemIdValueCall;

import org.eclipse.emf.common.notify.Notification;
import org.eclipse.emf.common.notify.NotificationChain;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;

import org.eclipse.emf.ecore.impl.ENotificationImpl;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Item Id Value Call</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.ItemIdValueCallImpl#getCall <em>Call</em>}</li>
 * </ul>
 *
 * @generated
 */
public class ItemIdValueCallImpl extends ItemIdValueImpl implements ItemIdValueCall {
	/**
	 * The cached value of the '{@link #getCall() <em>Call</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getCall()
	 * @generated
	 * @ordered
	 */
	protected ConnectivityCall call;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected ItemIdValueCallImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return IrPackage.Literals.ITEM_ID_VALUE_CALL;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public ConnectivityCall getCall() {
		if (call != null && call.eIsProxy()) {
			InternalEObject oldCall = (InternalEObject)call;
			call = (ConnectivityCall)eResolveProxy(oldCall);
			if (call != oldCall) {
				InternalEObject newCall = (InternalEObject)call;
				NotificationChain msgs = oldCall.eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.ITEM_ID_VALUE_CALL__CALL, null, null);
				if (newCall.eInternalContainer() == null) {
					msgs = newCall.eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.ITEM_ID_VALUE_CALL__CALL, null, msgs);
				}
				if (msgs != null) msgs.dispatch();
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.ITEM_ID_VALUE_CALL__CALL, oldCall, call));
			}
		}
		return call;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public ConnectivityCall basicGetCall() {
		return call;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetCall(ConnectivityCall newCall, NotificationChain msgs) {
		ConnectivityCall oldCall = call;
		call = newCall;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.ITEM_ID_VALUE_CALL__CALL, oldCall, newCall);
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
	public void setCall(ConnectivityCall newCall) {
		if (newCall != call) {
			NotificationChain msgs = null;
			if (call != null)
				msgs = ((InternalEObject)call).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.ITEM_ID_VALUE_CALL__CALL, null, msgs);
			if (newCall != null)
				msgs = ((InternalEObject)newCall).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.ITEM_ID_VALUE_CALL__CALL, null, msgs);
			msgs = basicSetCall(newCall, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.ITEM_ID_VALUE_CALL__CALL, newCall, newCall));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public NotificationChain eInverseRemove(InternalEObject otherEnd, int featureID, NotificationChain msgs) {
		switch (featureID) {
			case IrPackage.ITEM_ID_VALUE_CALL__CALL:
				return basicSetCall(null, msgs);
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
			case IrPackage.ITEM_ID_VALUE_CALL__CALL:
				if (resolve) return getCall();
				return basicGetCall();
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
			case IrPackage.ITEM_ID_VALUE_CALL__CALL:
				setCall((ConnectivityCall)newValue);
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
			case IrPackage.ITEM_ID_VALUE_CALL__CALL:
				setCall((ConnectivityCall)null);
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
			case IrPackage.ITEM_ID_VALUE_CALL__CALL:
				return call != null;
		}
		return super.eIsSet(featureID);
	}

} //ItemIdValueCallImpl
