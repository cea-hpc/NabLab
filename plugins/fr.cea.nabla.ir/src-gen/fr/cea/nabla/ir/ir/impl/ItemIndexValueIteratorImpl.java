/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.IrPackage;
import fr.cea.nabla.ir.ir.ItemIndexValueIterator;
import fr.cea.nabla.ir.ir.Iterator;

import org.eclipse.emf.common.notify.Notification;
import org.eclipse.emf.common.notify.NotificationChain;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;

import org.eclipse.emf.ecore.impl.ENotificationImpl;

import org.eclipse.emf.ecore.util.EcoreUtil;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Item Index Value Iterator</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.ItemIndexValueIteratorImpl#getIterator <em>Iterator</em>}</li>
 * </ul>
 *
 * @generated
 */
public class ItemIndexValueIteratorImpl extends ItemIndexValueImpl implements ItemIndexValueIterator {
	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected ItemIndexValueIteratorImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return IrPackage.Literals.ITEM_INDEX_VALUE_ITERATOR;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Iterator getIterator() {
		if (eContainerFeatureID() != IrPackage.ITEM_INDEX_VALUE_ITERATOR__ITERATOR) return null;
		return (Iterator)eContainer();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Iterator basicGetIterator() {
		if (eContainerFeatureID() != IrPackage.ITEM_INDEX_VALUE_ITERATOR__ITERATOR) return null;
		return (Iterator)eInternalContainer();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetIterator(Iterator newIterator, NotificationChain msgs) {
		msgs = eBasicSetContainer((InternalEObject)newIterator, IrPackage.ITEM_INDEX_VALUE_ITERATOR__ITERATOR, msgs);
		return msgs;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setIterator(Iterator newIterator) {
		if (newIterator != eInternalContainer() || (eContainerFeatureID() != IrPackage.ITEM_INDEX_VALUE_ITERATOR__ITERATOR && newIterator != null)) {
			if (EcoreUtil.isAncestor(this, newIterator))
				throw new IllegalArgumentException("Recursive containment not allowed for " + toString());
			NotificationChain msgs = null;
			if (eInternalContainer() != null)
				msgs = eBasicRemoveFromContainer(msgs);
			if (newIterator != null)
				msgs = ((InternalEObject)newIterator).eInverseAdd(this, IrPackage.ITERATOR__INDEX_VALUE, Iterator.class, msgs);
			msgs = basicSetIterator(newIterator, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.ITEM_INDEX_VALUE_ITERATOR__ITERATOR, newIterator, newIterator));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public NotificationChain eInverseAdd(InternalEObject otherEnd, int featureID, NotificationChain msgs) {
		switch (featureID) {
			case IrPackage.ITEM_INDEX_VALUE_ITERATOR__ITERATOR:
				if (eInternalContainer() != null)
					msgs = eBasicRemoveFromContainer(msgs);
				return basicSetIterator((Iterator)otherEnd, msgs);
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
			case IrPackage.ITEM_INDEX_VALUE_ITERATOR__ITERATOR:
				return basicSetIterator(null, msgs);
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
			case IrPackage.ITEM_INDEX_VALUE_ITERATOR__ITERATOR:
				return eInternalContainer().eInverseRemove(this, IrPackage.ITERATOR__INDEX_VALUE, Iterator.class, msgs);
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
			case IrPackage.ITEM_INDEX_VALUE_ITERATOR__ITERATOR:
				if (resolve) return getIterator();
				return basicGetIterator();
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
			case IrPackage.ITEM_INDEX_VALUE_ITERATOR__ITERATOR:
				setIterator((Iterator)newValue);
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
			case IrPackage.ITEM_INDEX_VALUE_ITERATOR__ITERATOR:
				setIterator((Iterator)null);
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
			case IrPackage.ITEM_INDEX_VALUE_ITERATOR__ITERATOR:
				return basicGetIterator() != null;
		}
		return super.eIsSet(featureID);
	}

} //ItemIndexValueIteratorImpl
