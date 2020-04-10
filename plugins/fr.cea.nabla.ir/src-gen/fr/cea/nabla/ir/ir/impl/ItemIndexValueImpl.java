/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.ConnectivityCall;
import fr.cea.nabla.ir.ir.IrPackage;
import fr.cea.nabla.ir.ir.ItemId;
import fr.cea.nabla.ir.ir.ItemIndexValue;

import org.eclipse.emf.common.notify.Notification;
import org.eclipse.emf.common.notify.NotificationChain;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;
import org.eclipse.emf.ecore.impl.ENotificationImpl;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Item Index Value</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.ItemIndexValueImpl#getId <em>Id</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.ItemIndexValueImpl#getContainer <em>Container</em>}</li>
 * </ul>
 *
 * @generated
 */
public class ItemIndexValueImpl extends IrAnnotableImpl implements ItemIndexValue {
	/**
	 * The cached value of the '{@link #getId() <em>Id</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getId()
	 * @generated
	 * @ordered
	 */
	protected ItemId id;
	/**
	 * The cached value of the '{@link #getContainer() <em>Container</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getContainer()
	 * @generated
	 * @ordered
	 */
	protected ConnectivityCall container;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected ItemIndexValueImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return IrPackage.Literals.ITEM_INDEX_VALUE;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public ItemId getId() {
		if (id != null && id.eIsProxy()) {
			InternalEObject oldId = (InternalEObject)id;
			id = (ItemId)eResolveProxy(oldId);
			if (id != oldId) {
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.ITEM_INDEX_VALUE__ID, oldId, id));
			}
		}
		return id;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public ItemId basicGetId() {
		return id;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setId(ItemId newId) {
		ItemId oldId = id;
		id = newId;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.ITEM_INDEX_VALUE__ID, oldId, id));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public ConnectivityCall getContainer() {
		if (container != null && container.eIsProxy()) {
			InternalEObject oldContainer = (InternalEObject)container;
			container = (ConnectivityCall)eResolveProxy(oldContainer);
			if (container != oldContainer) {
				InternalEObject newContainer = (InternalEObject)container;
				NotificationChain msgs = oldContainer.eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.ITEM_INDEX_VALUE__CONTAINER, null, null);
				if (newContainer.eInternalContainer() == null) {
					msgs = newContainer.eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.ITEM_INDEX_VALUE__CONTAINER, null, msgs);
				}
				if (msgs != null) msgs.dispatch();
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.ITEM_INDEX_VALUE__CONTAINER, oldContainer, container));
			}
		}
		return container;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public ConnectivityCall basicGetContainer() {
		return container;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetContainer(ConnectivityCall newContainer, NotificationChain msgs) {
		ConnectivityCall oldContainer = container;
		container = newContainer;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.ITEM_INDEX_VALUE__CONTAINER, oldContainer, newContainer);
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
	public void setContainer(ConnectivityCall newContainer) {
		if (newContainer != container) {
			NotificationChain msgs = null;
			if (container != null)
				msgs = ((InternalEObject)container).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.ITEM_INDEX_VALUE__CONTAINER, null, msgs);
			if (newContainer != null)
				msgs = ((InternalEObject)newContainer).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.ITEM_INDEX_VALUE__CONTAINER, null, msgs);
			msgs = basicSetContainer(newContainer, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.ITEM_INDEX_VALUE__CONTAINER, newContainer, newContainer));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public NotificationChain eInverseRemove(InternalEObject otherEnd, int featureID, NotificationChain msgs) {
		switch (featureID) {
			case IrPackage.ITEM_INDEX_VALUE__CONTAINER:
				return basicSetContainer(null, msgs);
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
			case IrPackage.ITEM_INDEX_VALUE__ID:
				if (resolve) return getId();
				return basicGetId();
			case IrPackage.ITEM_INDEX_VALUE__CONTAINER:
				if (resolve) return getContainer();
				return basicGetContainer();
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
			case IrPackage.ITEM_INDEX_VALUE__ID:
				setId((ItemId)newValue);
				return;
			case IrPackage.ITEM_INDEX_VALUE__CONTAINER:
				setContainer((ConnectivityCall)newValue);
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
			case IrPackage.ITEM_INDEX_VALUE__ID:
				setId((ItemId)null);
				return;
			case IrPackage.ITEM_INDEX_VALUE__CONTAINER:
				setContainer((ConnectivityCall)null);
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
			case IrPackage.ITEM_INDEX_VALUE__ID:
				return id != null;
			case IrPackage.ITEM_INDEX_VALUE__CONTAINER:
				return container != null;
		}
		return super.eIsSet(featureID);
	}

} //ItemIndexValueImpl
