/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.IrPackage;
import fr.cea.nabla.ir.ir.ItemIndex;
import fr.cea.nabla.ir.ir.Iterator;
import fr.cea.nabla.ir.ir.SimpleVariable;

import org.eclipse.emf.common.notify.Notification;
import org.eclipse.emf.common.notify.NotificationChain;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;

import org.eclipse.emf.ecore.impl.ENotificationImpl;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Iterator</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IteratorImpl#getIndex <em>Index</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IteratorImpl#getContainer <em>Container</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IteratorImpl#getCounter <em>Counter</em>}</li>
 * </ul>
 *
 * @generated
 */
public class IteratorImpl extends IterationBlockImpl implements Iterator {
	/**
	 * The cached value of the '{@link #getIndex() <em>Index</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getIndex()
	 * @generated
	 * @ordered
	 */
	protected ItemIndex index;

	/**
	 * The cached value of the '{@link #getContainer() <em>Container</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getContainer()
	 * @generated
	 * @ordered
	 */
	protected fr.cea.nabla.ir.ir.Container container;

	/**
	 * The cached value of the '{@link #getCounter() <em>Counter</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getCounter()
	 * @generated
	 * @ordered
	 */
	protected SimpleVariable counter;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected IteratorImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return IrPackage.Literals.ITERATOR;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public ItemIndex getIndex() {
		if (index != null && index.eIsProxy()) {
			InternalEObject oldIndex = (InternalEObject)index;
			index = (ItemIndex)eResolveProxy(oldIndex);
			if (index != oldIndex) {
				InternalEObject newIndex = (InternalEObject)index;
				NotificationChain msgs = oldIndex.eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.ITERATOR__INDEX, null, null);
				if (newIndex.eInternalContainer() == null) {
					msgs = newIndex.eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.ITERATOR__INDEX, null, msgs);
				}
				if (msgs != null) msgs.dispatch();
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.ITERATOR__INDEX, oldIndex, index));
			}
		}
		return index;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public ItemIndex basicGetIndex() {
		return index;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetIndex(ItemIndex newIndex, NotificationChain msgs) {
		ItemIndex oldIndex = index;
		index = newIndex;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.ITERATOR__INDEX, oldIndex, newIndex);
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
	public void setIndex(ItemIndex newIndex) {
		if (newIndex != index) {
			NotificationChain msgs = null;
			if (index != null)
				msgs = ((InternalEObject)index).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.ITERATOR__INDEX, null, msgs);
			if (newIndex != null)
				msgs = ((InternalEObject)newIndex).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.ITERATOR__INDEX, null, msgs);
			msgs = basicSetIndex(newIndex, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.ITERATOR__INDEX, newIndex, newIndex));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public fr.cea.nabla.ir.ir.Container getContainer() {
		if (container != null && container.eIsProxy()) {
			InternalEObject oldContainer = (InternalEObject)container;
			container = (fr.cea.nabla.ir.ir.Container)eResolveProxy(oldContainer);
			if (container != oldContainer) {
				InternalEObject newContainer = (InternalEObject)container;
				NotificationChain msgs = oldContainer.eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.ITERATOR__CONTAINER, null, null);
				if (newContainer.eInternalContainer() == null) {
					msgs = newContainer.eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.ITERATOR__CONTAINER, null, msgs);
				}
				if (msgs != null) msgs.dispatch();
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.ITERATOR__CONTAINER, oldContainer, container));
			}
		}
		return container;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public fr.cea.nabla.ir.ir.Container basicGetContainer() {
		return container;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetContainer(fr.cea.nabla.ir.ir.Container newContainer, NotificationChain msgs) {
		fr.cea.nabla.ir.ir.Container oldContainer = container;
		container = newContainer;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.ITERATOR__CONTAINER, oldContainer, newContainer);
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
	public void setContainer(fr.cea.nabla.ir.ir.Container newContainer) {
		if (newContainer != container) {
			NotificationChain msgs = null;
			if (container != null)
				msgs = ((InternalEObject)container).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.ITERATOR__CONTAINER, null, msgs);
			if (newContainer != null)
				msgs = ((InternalEObject)newContainer).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.ITERATOR__CONTAINER, null, msgs);
			msgs = basicSetContainer(newContainer, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.ITERATOR__CONTAINER, newContainer, newContainer));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public SimpleVariable getCounter() {
		if (counter != null && counter.eIsProxy()) {
			InternalEObject oldCounter = (InternalEObject)counter;
			counter = (SimpleVariable)eResolveProxy(oldCounter);
			if (counter != oldCounter) {
				InternalEObject newCounter = (InternalEObject)counter;
				NotificationChain msgs = oldCounter.eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.ITERATOR__COUNTER, null, null);
				if (newCounter.eInternalContainer() == null) {
					msgs = newCounter.eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.ITERATOR__COUNTER, null, msgs);
				}
				if (msgs != null) msgs.dispatch();
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.ITERATOR__COUNTER, oldCounter, counter));
			}
		}
		return counter;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public SimpleVariable basicGetCounter() {
		return counter;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetCounter(SimpleVariable newCounter, NotificationChain msgs) {
		SimpleVariable oldCounter = counter;
		counter = newCounter;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.ITERATOR__COUNTER, oldCounter, newCounter);
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
	public void setCounter(SimpleVariable newCounter) {
		if (newCounter != counter) {
			NotificationChain msgs = null;
			if (counter != null)
				msgs = ((InternalEObject)counter).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.ITERATOR__COUNTER, null, msgs);
			if (newCounter != null)
				msgs = ((InternalEObject)newCounter).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.ITERATOR__COUNTER, null, msgs);
			msgs = basicSetCounter(newCounter, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.ITERATOR__COUNTER, newCounter, newCounter));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public NotificationChain eInverseRemove(InternalEObject otherEnd, int featureID, NotificationChain msgs) {
		switch (featureID) {
			case IrPackage.ITERATOR__INDEX:
				return basicSetIndex(null, msgs);
			case IrPackage.ITERATOR__CONTAINER:
				return basicSetContainer(null, msgs);
			case IrPackage.ITERATOR__COUNTER:
				return basicSetCounter(null, msgs);
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
			case IrPackage.ITERATOR__INDEX:
				if (resolve) return getIndex();
				return basicGetIndex();
			case IrPackage.ITERATOR__CONTAINER:
				if (resolve) return getContainer();
				return basicGetContainer();
			case IrPackage.ITERATOR__COUNTER:
				if (resolve) return getCounter();
				return basicGetCounter();
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
			case IrPackage.ITERATOR__INDEX:
				setIndex((ItemIndex)newValue);
				return;
			case IrPackage.ITERATOR__CONTAINER:
				setContainer((fr.cea.nabla.ir.ir.Container)newValue);
				return;
			case IrPackage.ITERATOR__COUNTER:
				setCounter((SimpleVariable)newValue);
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
			case IrPackage.ITERATOR__INDEX:
				setIndex((ItemIndex)null);
				return;
			case IrPackage.ITERATOR__CONTAINER:
				setContainer((fr.cea.nabla.ir.ir.Container)null);
				return;
			case IrPackage.ITERATOR__COUNTER:
				setCounter((SimpleVariable)null);
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
			case IrPackage.ITERATOR__INDEX:
				return index != null;
			case IrPackage.ITERATOR__CONTAINER:
				return container != null;
			case IrPackage.ITERATOR__COUNTER:
				return counter != null;
		}
		return super.eIsSet(featureID);
	}

} //IteratorImpl
