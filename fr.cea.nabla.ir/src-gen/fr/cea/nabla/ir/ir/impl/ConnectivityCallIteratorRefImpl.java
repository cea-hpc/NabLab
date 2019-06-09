/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.ConnectivityCall;
import fr.cea.nabla.ir.ir.ConnectivityCallIteratorRef;
import fr.cea.nabla.ir.ir.IrPackage;

import org.eclipse.emf.common.notify.Notification;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;

import org.eclipse.emf.ecore.impl.ENotificationImpl;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Connectivity Call Iterator Ref</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.ConnectivityCallIteratorRefImpl#getReferencedBy <em>Referenced By</em>}</li>
 * </ul>
 *
 * @generated
 */
public class ConnectivityCallIteratorRefImpl extends IteratorRefImpl implements ConnectivityCallIteratorRef {
	/**
	 * The cached value of the '{@link #getReferencedBy() <em>Referenced By</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getReferencedBy()
	 * @generated
	 * @ordered
	 */
	protected ConnectivityCall referencedBy;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected ConnectivityCallIteratorRefImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return IrPackage.Literals.CONNECTIVITY_CALL_ITERATOR_REF;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public ConnectivityCall getReferencedBy() {
		if (referencedBy != null && referencedBy.eIsProxy()) {
			InternalEObject oldReferencedBy = (InternalEObject)referencedBy;
			referencedBy = (ConnectivityCall)eResolveProxy(oldReferencedBy);
			if (referencedBy != oldReferencedBy) {
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.CONNECTIVITY_CALL_ITERATOR_REF__REFERENCED_BY, oldReferencedBy, referencedBy));
			}
		}
		return referencedBy;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public ConnectivityCall basicGetReferencedBy() {
		return referencedBy;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setReferencedBy(ConnectivityCall newReferencedBy) {
		ConnectivityCall oldReferencedBy = referencedBy;
		referencedBy = newReferencedBy;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.CONNECTIVITY_CALL_ITERATOR_REF__REFERENCED_BY, oldReferencedBy, referencedBy));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Object eGet(int featureID, boolean resolve, boolean coreType) {
		switch (featureID) {
			case IrPackage.CONNECTIVITY_CALL_ITERATOR_REF__REFERENCED_BY:
				if (resolve) return getReferencedBy();
				return basicGetReferencedBy();
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
			case IrPackage.CONNECTIVITY_CALL_ITERATOR_REF__REFERENCED_BY:
				setReferencedBy((ConnectivityCall)newValue);
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
			case IrPackage.CONNECTIVITY_CALL_ITERATOR_REF__REFERENCED_BY:
				setReferencedBy((ConnectivityCall)null);
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
			case IrPackage.CONNECTIVITY_CALL_ITERATOR_REF__REFERENCED_BY:
				return referencedBy != null;
		}
		return super.eIsSet(featureID);
	}

} //ConnectivityCallIteratorRefImpl
