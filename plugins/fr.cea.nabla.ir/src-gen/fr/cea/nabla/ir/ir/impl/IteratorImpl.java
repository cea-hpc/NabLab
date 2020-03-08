/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.ConnectivityCall;
import fr.cea.nabla.ir.ir.IrIndex;
import fr.cea.nabla.ir.ir.IrPackage;
import fr.cea.nabla.ir.ir.IrUniqueId;
import fr.cea.nabla.ir.ir.Iterator;
import fr.cea.nabla.ir.ir.IteratorRef;

import java.util.Collection;

import org.eclipse.emf.common.notify.Notification;
import org.eclipse.emf.common.notify.NotificationChain;

import org.eclipse.emf.common.util.EList;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;

import org.eclipse.emf.ecore.impl.ENotificationImpl;
import org.eclipse.emf.ecore.util.EObjectContainmentEList;
import org.eclipse.emf.ecore.util.EObjectWithInverseResolvingEList;
import org.eclipse.emf.ecore.util.InternalEList;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Iterator</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IteratorImpl#getName <em>Name</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IteratorImpl#getContainer <em>Container</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IteratorImpl#isSingleton <em>Singleton</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IteratorImpl#getReferencers <em>Referencers</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IteratorImpl#getAssociatedIndex <em>Associated Index</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IteratorImpl#getNeededIds <em>Needed Ids</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IteratorImpl#getNeededIndices <em>Needed Indices</em>}</li>
 * </ul>
 *
 * @generated
 */
public class IteratorImpl extends IrAnnotableImpl implements Iterator {
	/**
	 * The default value of the '{@link #getName() <em>Name</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getName()
	 * @generated
	 * @ordered
	 */
	protected static final String NAME_EDEFAULT = null;

	/**
	 * The cached value of the '{@link #getName() <em>Name</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getName()
	 * @generated
	 * @ordered
	 */
	protected String name = NAME_EDEFAULT;

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
	 * The default value of the '{@link #isSingleton() <em>Singleton</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #isSingleton()
	 * @generated
	 * @ordered
	 */
	protected static final boolean SINGLETON_EDEFAULT = false;

	/**
	 * The cached value of the '{@link #isSingleton() <em>Singleton</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #isSingleton()
	 * @generated
	 * @ordered
	 */
	protected boolean singleton = SINGLETON_EDEFAULT;

	/**
	 * The cached value of the '{@link #getReferencers() <em>Referencers</em>}' reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getReferencers()
	 * @generated
	 * @ordered
	 */
	protected EList<IteratorRef> referencers;

	/**
	 * The cached value of the '{@link #getAssociatedIndex() <em>Associated Index</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getAssociatedIndex()
	 * @generated
	 * @ordered
	 */
	protected IrIndex associatedIndex;

	/**
	 * The cached value of the '{@link #getNeededIds() <em>Needed Ids</em>}' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getNeededIds()
	 * @generated
	 * @ordered
	 */
	protected EList<IrUniqueId> neededIds;

	/**
	 * The cached value of the '{@link #getNeededIndices() <em>Needed Indices</em>}' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getNeededIndices()
	 * @generated
	 * @ordered
	 */
	protected EList<IrIndex> neededIndices;

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
	public String getName() {
		return name;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setName(String newName) {
		String oldName = name;
		name = newName;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.ITERATOR__NAME, oldName, name));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public ConnectivityCall getContainer() {
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
	public void setContainer(ConnectivityCall newContainer) {
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
	public boolean isSingleton() {
		return singleton;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setSingleton(boolean newSingleton) {
		boolean oldSingleton = singleton;
		singleton = newSingleton;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.ITERATOR__SINGLETON, oldSingleton, singleton));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public EList<IteratorRef> getReferencers() {
		if (referencers == null) {
			referencers = new EObjectWithInverseResolvingEList<IteratorRef>(IteratorRef.class, this, IrPackage.ITERATOR__REFERENCERS, IrPackage.ITERATOR_REF__TARGET);
		}
		return referencers;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public IrIndex getAssociatedIndex() {
		if (associatedIndex != null && associatedIndex.eIsProxy()) {
			InternalEObject oldAssociatedIndex = (InternalEObject)associatedIndex;
			associatedIndex = (IrIndex)eResolveProxy(oldAssociatedIndex);
			if (associatedIndex != oldAssociatedIndex) {
				InternalEObject newAssociatedIndex = (InternalEObject)associatedIndex;
				NotificationChain msgs = oldAssociatedIndex.eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.ITERATOR__ASSOCIATED_INDEX, null, null);
				if (newAssociatedIndex.eInternalContainer() == null) {
					msgs = newAssociatedIndex.eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.ITERATOR__ASSOCIATED_INDEX, null, msgs);
				}
				if (msgs != null) msgs.dispatch();
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.ITERATOR__ASSOCIATED_INDEX, oldAssociatedIndex, associatedIndex));
			}
		}
		return associatedIndex;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public IrIndex basicGetAssociatedIndex() {
		return associatedIndex;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetAssociatedIndex(IrIndex newAssociatedIndex, NotificationChain msgs) {
		IrIndex oldAssociatedIndex = associatedIndex;
		associatedIndex = newAssociatedIndex;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.ITERATOR__ASSOCIATED_INDEX, oldAssociatedIndex, newAssociatedIndex);
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
	public void setAssociatedIndex(IrIndex newAssociatedIndex) {
		if (newAssociatedIndex != associatedIndex) {
			NotificationChain msgs = null;
			if (associatedIndex != null)
				msgs = ((InternalEObject)associatedIndex).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.ITERATOR__ASSOCIATED_INDEX, null, msgs);
			if (newAssociatedIndex != null)
				msgs = ((InternalEObject)newAssociatedIndex).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.ITERATOR__ASSOCIATED_INDEX, null, msgs);
			msgs = basicSetAssociatedIndex(newAssociatedIndex, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.ITERATOR__ASSOCIATED_INDEX, newAssociatedIndex, newAssociatedIndex));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public EList<IrUniqueId> getNeededIds() {
		if (neededIds == null) {
			neededIds = new EObjectContainmentEList.Resolving<IrUniqueId>(IrUniqueId.class, this, IrPackage.ITERATOR__NEEDED_IDS);
		}
		return neededIds;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public EList<IrIndex> getNeededIndices() {
		if (neededIndices == null) {
			neededIndices = new EObjectContainmentEList.Resolving<IrIndex>(IrIndex.class, this, IrPackage.ITERATOR__NEEDED_INDICES);
		}
		return neededIndices;
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
			case IrPackage.ITERATOR__REFERENCERS:
				return ((InternalEList<InternalEObject>)(InternalEList<?>)getReferencers()).basicAdd(otherEnd, msgs);
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
			case IrPackage.ITERATOR__CONTAINER:
				return basicSetContainer(null, msgs);
			case IrPackage.ITERATOR__REFERENCERS:
				return ((InternalEList<?>)getReferencers()).basicRemove(otherEnd, msgs);
			case IrPackage.ITERATOR__ASSOCIATED_INDEX:
				return basicSetAssociatedIndex(null, msgs);
			case IrPackage.ITERATOR__NEEDED_IDS:
				return ((InternalEList<?>)getNeededIds()).basicRemove(otherEnd, msgs);
			case IrPackage.ITERATOR__NEEDED_INDICES:
				return ((InternalEList<?>)getNeededIndices()).basicRemove(otherEnd, msgs);
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
			case IrPackage.ITERATOR__NAME:
				return getName();
			case IrPackage.ITERATOR__CONTAINER:
				return getContainer();
			case IrPackage.ITERATOR__SINGLETON:
				return isSingleton();
			case IrPackage.ITERATOR__REFERENCERS:
				return getReferencers();
			case IrPackage.ITERATOR__ASSOCIATED_INDEX:
				if (resolve) return getAssociatedIndex();
				return basicGetAssociatedIndex();
			case IrPackage.ITERATOR__NEEDED_IDS:
				return getNeededIds();
			case IrPackage.ITERATOR__NEEDED_INDICES:
				return getNeededIndices();
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
			case IrPackage.ITERATOR__NAME:
				setName((String)newValue);
				return;
			case IrPackage.ITERATOR__CONTAINER:
				setContainer((ConnectivityCall)newValue);
				return;
			case IrPackage.ITERATOR__SINGLETON:
				setSingleton((Boolean)newValue);
				return;
			case IrPackage.ITERATOR__REFERENCERS:
				getReferencers().clear();
				getReferencers().addAll((Collection<? extends IteratorRef>)newValue);
				return;
			case IrPackage.ITERATOR__ASSOCIATED_INDEX:
				setAssociatedIndex((IrIndex)newValue);
				return;
			case IrPackage.ITERATOR__NEEDED_IDS:
				getNeededIds().clear();
				getNeededIds().addAll((Collection<? extends IrUniqueId>)newValue);
				return;
			case IrPackage.ITERATOR__NEEDED_INDICES:
				getNeededIndices().clear();
				getNeededIndices().addAll((Collection<? extends IrIndex>)newValue);
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
			case IrPackage.ITERATOR__NAME:
				setName(NAME_EDEFAULT);
				return;
			case IrPackage.ITERATOR__CONTAINER:
				setContainer((ConnectivityCall)null);
				return;
			case IrPackage.ITERATOR__SINGLETON:
				setSingleton(SINGLETON_EDEFAULT);
				return;
			case IrPackage.ITERATOR__REFERENCERS:
				getReferencers().clear();
				return;
			case IrPackage.ITERATOR__ASSOCIATED_INDEX:
				setAssociatedIndex((IrIndex)null);
				return;
			case IrPackage.ITERATOR__NEEDED_IDS:
				getNeededIds().clear();
				return;
			case IrPackage.ITERATOR__NEEDED_INDICES:
				getNeededIndices().clear();
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
			case IrPackage.ITERATOR__NAME:
				return NAME_EDEFAULT == null ? name != null : !NAME_EDEFAULT.equals(name);
			case IrPackage.ITERATOR__CONTAINER:
				return container != null;
			case IrPackage.ITERATOR__SINGLETON:
				return singleton != SINGLETON_EDEFAULT;
			case IrPackage.ITERATOR__REFERENCERS:
				return referencers != null && !referencers.isEmpty();
			case IrPackage.ITERATOR__ASSOCIATED_INDEX:
				return associatedIndex != null;
			case IrPackage.ITERATOR__NEEDED_IDS:
				return neededIds != null && !neededIds.isEmpty();
			case IrPackage.ITERATOR__NEEDED_INDICES:
				return neededIndices != null && !neededIndices.isEmpty();
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
		result.append(" (name: ");
		result.append(name);
		result.append(", singleton: ");
		result.append(singleton);
		result.append(')');
		return result.toString();
	}

} //IteratorImpl
