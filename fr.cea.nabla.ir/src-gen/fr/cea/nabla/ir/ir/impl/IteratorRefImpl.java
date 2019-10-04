/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.IrPackage;
import fr.cea.nabla.ir.ir.Iterator;
import fr.cea.nabla.ir.ir.IteratorRef;

import org.eclipse.emf.common.notify.Notification;
import org.eclipse.emf.common.notify.NotificationChain;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;

import org.eclipse.emf.ecore.impl.ENotificationImpl;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Iterator Ref</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IteratorRefImpl#getTarget <em>Target</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IteratorRefImpl#getShift <em>Shift</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IteratorRefImpl#getIndexInReferencerList <em>Index In Referencer List</em>}</li>
 * </ul>
 *
 * @generated
 */
public abstract class IteratorRefImpl extends IrAnnotableImpl implements IteratorRef {
	/**
	 * The cached value of the '{@link #getTarget() <em>Target</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getTarget()
	 * @generated
	 * @ordered
	 */
	protected Iterator target;

	/**
	 * The default value of the '{@link #getShift() <em>Shift</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getShift()
	 * @generated
	 * @ordered
	 */
	protected static final int SHIFT_EDEFAULT = 0;

	/**
	 * The cached value of the '{@link #getShift() <em>Shift</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getShift()
	 * @generated
	 * @ordered
	 */
	protected int shift = SHIFT_EDEFAULT;

	/**
	 * The default value of the '{@link #getIndexInReferencerList() <em>Index In Referencer List</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getIndexInReferencerList()
	 * @generated
	 * @ordered
	 */
	protected static final int INDEX_IN_REFERENCER_LIST_EDEFAULT = 0;

	/**
	 * The cached value of the '{@link #getIndexInReferencerList() <em>Index In Referencer List</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getIndexInReferencerList()
	 * @generated
	 * @ordered
	 */
	protected int indexInReferencerList = INDEX_IN_REFERENCER_LIST_EDEFAULT;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected IteratorRefImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return IrPackage.Literals.ITERATOR_REF;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Iterator getTarget() {
		if (target != null && target.eIsProxy()) {
			InternalEObject oldTarget = (InternalEObject)target;
			target = (Iterator)eResolveProxy(oldTarget);
			if (target != oldTarget) {
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.ITERATOR_REF__TARGET, oldTarget, target));
			}
		}
		return target;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Iterator basicGetTarget() {
		return target;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetTarget(Iterator newTarget, NotificationChain msgs) {
		Iterator oldTarget = target;
		target = newTarget;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.ITERATOR_REF__TARGET, oldTarget, newTarget);
			if (msgs == null) msgs = notification; else msgs.add(notification);
		}
		return msgs;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setTarget(Iterator newTarget) {
		if (newTarget != target) {
			NotificationChain msgs = null;
			if (target != null)
				msgs = ((InternalEObject)target).eInverseRemove(this, IrPackage.ITERATOR__REFERENCERS, Iterator.class, msgs);
			if (newTarget != null)
				msgs = ((InternalEObject)newTarget).eInverseAdd(this, IrPackage.ITERATOR__REFERENCERS, Iterator.class, msgs);
			msgs = basicSetTarget(newTarget, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.ITERATOR_REF__TARGET, newTarget, newTarget));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public int getShift() {
		return shift;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setShift(int newShift) {
		int oldShift = shift;
		shift = newShift;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.ITERATOR_REF__SHIFT, oldShift, shift));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public int getIndexInReferencerList() {
		return indexInReferencerList;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setIndexInReferencerList(int newIndexInReferencerList) {
		int oldIndexInReferencerList = indexInReferencerList;
		indexInReferencerList = newIndexInReferencerList;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.ITERATOR_REF__INDEX_IN_REFERENCER_LIST, oldIndexInReferencerList, indexInReferencerList));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public NotificationChain eInverseAdd(InternalEObject otherEnd, int featureID, NotificationChain msgs) {
		switch (featureID) {
			case IrPackage.ITERATOR_REF__TARGET:
				if (target != null)
					msgs = ((InternalEObject)target).eInverseRemove(this, IrPackage.ITERATOR__REFERENCERS, Iterator.class, msgs);
				return basicSetTarget((Iterator)otherEnd, msgs);
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
			case IrPackage.ITERATOR_REF__TARGET:
				return basicSetTarget(null, msgs);
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
			case IrPackage.ITERATOR_REF__TARGET:
				if (resolve) return getTarget();
				return basicGetTarget();
			case IrPackage.ITERATOR_REF__SHIFT:
				return getShift();
			case IrPackage.ITERATOR_REF__INDEX_IN_REFERENCER_LIST:
				return getIndexInReferencerList();
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
			case IrPackage.ITERATOR_REF__TARGET:
				setTarget((Iterator)newValue);
				return;
			case IrPackage.ITERATOR_REF__SHIFT:
				setShift((Integer)newValue);
				return;
			case IrPackage.ITERATOR_REF__INDEX_IN_REFERENCER_LIST:
				setIndexInReferencerList((Integer)newValue);
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
			case IrPackage.ITERATOR_REF__TARGET:
				setTarget((Iterator)null);
				return;
			case IrPackage.ITERATOR_REF__SHIFT:
				setShift(SHIFT_EDEFAULT);
				return;
			case IrPackage.ITERATOR_REF__INDEX_IN_REFERENCER_LIST:
				setIndexInReferencerList(INDEX_IN_REFERENCER_LIST_EDEFAULT);
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
			case IrPackage.ITERATOR_REF__TARGET:
				return target != null;
			case IrPackage.ITERATOR_REF__SHIFT:
				return shift != SHIFT_EDEFAULT;
			case IrPackage.ITERATOR_REF__INDEX_IN_REFERENCER_LIST:
				return indexInReferencerList != INDEX_IN_REFERENCER_LIST_EDEFAULT;
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
		result.append(" (shift: ");
		result.append(shift);
		result.append(", indexInReferencerList: ");
		result.append(indexInReferencerList);
		result.append(')');
		return result.toString();
	}

} //IteratorRefImpl
