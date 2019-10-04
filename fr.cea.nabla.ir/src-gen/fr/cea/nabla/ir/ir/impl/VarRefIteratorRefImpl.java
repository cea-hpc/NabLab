/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.IrPackage;
import fr.cea.nabla.ir.ir.VarRef;
import fr.cea.nabla.ir.ir.VarRefIteratorRef;

import org.eclipse.emf.common.notify.Notification;
import org.eclipse.emf.common.notify.NotificationChain;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;

import org.eclipse.emf.ecore.impl.ENotificationImpl;

import org.eclipse.emf.ecore.util.EcoreUtil;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Var Ref Iterator Ref</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.VarRefIteratorRefImpl#getReferencedBy <em>Referenced By</em>}</li>
 * </ul>
 *
 * @generated
 */
public class VarRefIteratorRefImpl extends IteratorRefImpl implements VarRefIteratorRef {
	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected VarRefIteratorRefImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return IrPackage.Literals.VAR_REF_ITERATOR_REF;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public VarRef getReferencedBy() {
		if (eContainerFeatureID() != IrPackage.VAR_REF_ITERATOR_REF__REFERENCED_BY) return null;
		return (VarRef)eContainer();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public VarRef basicGetReferencedBy() {
		if (eContainerFeatureID() != IrPackage.VAR_REF_ITERATOR_REF__REFERENCED_BY) return null;
		return (VarRef)eInternalContainer();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetReferencedBy(VarRef newReferencedBy, NotificationChain msgs) {
		msgs = eBasicSetContainer((InternalEObject)newReferencedBy, IrPackage.VAR_REF_ITERATOR_REF__REFERENCED_BY, msgs);
		return msgs;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setReferencedBy(VarRef newReferencedBy) {
		if (newReferencedBy != eInternalContainer() || (eContainerFeatureID() != IrPackage.VAR_REF_ITERATOR_REF__REFERENCED_BY && newReferencedBy != null)) {
			if (EcoreUtil.isAncestor(this, newReferencedBy))
				throw new IllegalArgumentException("Recursive containment not allowed for " + toString());
			NotificationChain msgs = null;
			if (eInternalContainer() != null)
				msgs = eBasicRemoveFromContainer(msgs);
			if (newReferencedBy != null)
				msgs = ((InternalEObject)newReferencedBy).eInverseAdd(this, IrPackage.VAR_REF__ITERATORS, VarRef.class, msgs);
			msgs = basicSetReferencedBy(newReferencedBy, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.VAR_REF_ITERATOR_REF__REFERENCED_BY, newReferencedBy, newReferencedBy));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public NotificationChain eInverseAdd(InternalEObject otherEnd, int featureID, NotificationChain msgs) {
		switch (featureID) {
			case IrPackage.VAR_REF_ITERATOR_REF__REFERENCED_BY:
				if (eInternalContainer() != null)
					msgs = eBasicRemoveFromContainer(msgs);
				return basicSetReferencedBy((VarRef)otherEnd, msgs);
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
			case IrPackage.VAR_REF_ITERATOR_REF__REFERENCED_BY:
				return basicSetReferencedBy(null, msgs);
		}
		return super.eInverseRemove(otherEnd, featureID, msgs);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public NotificationChain eBasicRemoveFromContainerFeature(NotificationChain msgs) {
		switch (eContainerFeatureID()) {
			case IrPackage.VAR_REF_ITERATOR_REF__REFERENCED_BY:
				return eInternalContainer().eInverseRemove(this, IrPackage.VAR_REF__ITERATORS, VarRef.class, msgs);
		}
		return super.eBasicRemoveFromContainerFeature(msgs);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Object eGet(int featureID, boolean resolve, boolean coreType) {
		switch (featureID) {
			case IrPackage.VAR_REF_ITERATOR_REF__REFERENCED_BY:
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
			case IrPackage.VAR_REF_ITERATOR_REF__REFERENCED_BY:
				setReferencedBy((VarRef)newValue);
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
			case IrPackage.VAR_REF_ITERATOR_REF__REFERENCED_BY:
				setReferencedBy((VarRef)null);
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
			case IrPackage.VAR_REF_ITERATOR_REF__REFERENCED_BY:
				return basicGetReferencedBy() != null;
		}
		return super.eIsSet(featureID);
	}

} //VarRefIteratorRefImpl
