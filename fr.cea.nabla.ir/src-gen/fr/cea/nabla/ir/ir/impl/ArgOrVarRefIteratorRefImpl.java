/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.ArgOrVarRef;
import fr.cea.nabla.ir.ir.ArgOrVarRefIteratorRef;
import fr.cea.nabla.ir.ir.IrPackage;

import org.eclipse.emf.common.notify.Notification;
import org.eclipse.emf.common.notify.NotificationChain;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;

import org.eclipse.emf.ecore.impl.ENotificationImpl;

import org.eclipse.emf.ecore.util.EcoreUtil;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Arg Or Var Ref Iterator Ref</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.ArgOrVarRefIteratorRefImpl#getReferencedBy <em>Referenced By</em>}</li>
 * </ul>
 *
 * @generated
 */
public class ArgOrVarRefIteratorRefImpl extends IteratorRefImpl implements ArgOrVarRefIteratorRef {
	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected ArgOrVarRefIteratorRefImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return IrPackage.Literals.ARG_OR_VAR_REF_ITERATOR_REF;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public ArgOrVarRef getReferencedBy() {
		if (eContainerFeatureID() != IrPackage.ARG_OR_VAR_REF_ITERATOR_REF__REFERENCED_BY) return null;
		return (ArgOrVarRef)eContainer();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public ArgOrVarRef basicGetReferencedBy() {
		if (eContainerFeatureID() != IrPackage.ARG_OR_VAR_REF_ITERATOR_REF__REFERENCED_BY) return null;
		return (ArgOrVarRef)eInternalContainer();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetReferencedBy(ArgOrVarRef newReferencedBy, NotificationChain msgs) {
		msgs = eBasicSetContainer((InternalEObject)newReferencedBy, IrPackage.ARG_OR_VAR_REF_ITERATOR_REF__REFERENCED_BY, msgs);
		return msgs;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setReferencedBy(ArgOrVarRef newReferencedBy) {
		if (newReferencedBy != eInternalContainer() || (eContainerFeatureID() != IrPackage.ARG_OR_VAR_REF_ITERATOR_REF__REFERENCED_BY && newReferencedBy != null)) {
			if (EcoreUtil.isAncestor(this, newReferencedBy))
				throw new IllegalArgumentException("Recursive containment not allowed for " + toString());
			NotificationChain msgs = null;
			if (eInternalContainer() != null)
				msgs = eBasicRemoveFromContainer(msgs);
			if (newReferencedBy != null)
				msgs = ((InternalEObject)newReferencedBy).eInverseAdd(this, IrPackage.ARG_OR_VAR_REF__ITERATORS, ArgOrVarRef.class, msgs);
			msgs = basicSetReferencedBy(newReferencedBy, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.ARG_OR_VAR_REF_ITERATOR_REF__REFERENCED_BY, newReferencedBy, newReferencedBy));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public NotificationChain eInverseAdd(InternalEObject otherEnd, int featureID, NotificationChain msgs) {
		switch (featureID) {
			case IrPackage.ARG_OR_VAR_REF_ITERATOR_REF__REFERENCED_BY:
				if (eInternalContainer() != null)
					msgs = eBasicRemoveFromContainer(msgs);
				return basicSetReferencedBy((ArgOrVarRef)otherEnd, msgs);
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
			case IrPackage.ARG_OR_VAR_REF_ITERATOR_REF__REFERENCED_BY:
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
			case IrPackage.ARG_OR_VAR_REF_ITERATOR_REF__REFERENCED_BY:
				return eInternalContainer().eInverseRemove(this, IrPackage.ARG_OR_VAR_REF__ITERATORS, ArgOrVarRef.class, msgs);
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
			case IrPackage.ARG_OR_VAR_REF_ITERATOR_REF__REFERENCED_BY:
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
			case IrPackage.ARG_OR_VAR_REF_ITERATOR_REF__REFERENCED_BY:
				setReferencedBy((ArgOrVarRef)newValue);
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
			case IrPackage.ARG_OR_VAR_REF_ITERATOR_REF__REFERENCED_BY:
				setReferencedBy((ArgOrVarRef)null);
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
			case IrPackage.ARG_OR_VAR_REF_ITERATOR_REF__REFERENCED_BY:
				return basicGetReferencedBy() != null;
		}
		return super.eIsSet(featureID);
	}

} //ArgOrVarRefIteratorRefImpl
