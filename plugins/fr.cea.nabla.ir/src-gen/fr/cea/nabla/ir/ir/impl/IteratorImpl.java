/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.IrIndex;
import fr.cea.nabla.ir.ir.IrPackage;
import fr.cea.nabla.ir.ir.IrUniqueId;
import fr.cea.nabla.ir.ir.Iterator;
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
 * An implementation of the model object '<em><b>Iterator</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IteratorImpl#getName <em>Name</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IteratorImpl#isSingleton <em>Singleton</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IteratorImpl#getIndex <em>Index</em>}</li>
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
	 * The cached value of the '{@link #getIndex() <em>Index</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getIndex()
	 * @generated
	 * @ordered
	 */
	protected IrIndex index;

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
	public IrIndex getIndex() {
		if (index != null && index.eIsProxy()) {
			InternalEObject oldIndex = (InternalEObject)index;
			index = (IrIndex)eResolveProxy(oldIndex);
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
	public IrIndex basicGetIndex() {
		return index;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetIndex(IrIndex newIndex, NotificationChain msgs) {
		IrIndex oldIndex = index;
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
	public void setIndex(IrIndex newIndex) {
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
	@Override
	public NotificationChain eInverseRemove(InternalEObject otherEnd, int featureID, NotificationChain msgs) {
		switch (featureID) {
			case IrPackage.ITERATOR__INDEX:
				return basicSetIndex(null, msgs);
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
			case IrPackage.ITERATOR__SINGLETON:
				return isSingleton();
			case IrPackage.ITERATOR__INDEX:
				if (resolve) return getIndex();
				return basicGetIndex();
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
			case IrPackage.ITERATOR__SINGLETON:
				setSingleton((Boolean)newValue);
				return;
			case IrPackage.ITERATOR__INDEX:
				setIndex((IrIndex)newValue);
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
			case IrPackage.ITERATOR__SINGLETON:
				setSingleton(SINGLETON_EDEFAULT);
				return;
			case IrPackage.ITERATOR__INDEX:
				setIndex((IrIndex)null);
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
			case IrPackage.ITERATOR__SINGLETON:
				return singleton != SINGLETON_EDEFAULT;
			case IrPackage.ITERATOR__INDEX:
				return index != null;
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
