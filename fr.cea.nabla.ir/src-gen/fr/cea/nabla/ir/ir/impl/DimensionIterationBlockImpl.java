/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.Dimension;
import fr.cea.nabla.ir.ir.DimensionIterationBlock;
import fr.cea.nabla.ir.ir.DimensionSymbol;
import fr.cea.nabla.ir.ir.IrPackage;

import org.eclipse.emf.common.notify.Notification;
import org.eclipse.emf.common.notify.NotificationChain;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;

import org.eclipse.emf.ecore.impl.ENotificationImpl;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Dimension Iteration Block</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.DimensionIterationBlockImpl#getIndex <em>Index</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.DimensionIterationBlockImpl#getFrom <em>From</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.DimensionIterationBlockImpl#getTo <em>To</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.DimensionIterationBlockImpl#isToIncluded <em>To Included</em>}</li>
 * </ul>
 *
 * @generated
 */
public class DimensionIterationBlockImpl extends IterationBlockImpl implements DimensionIterationBlock {
	/**
	 * The cached value of the '{@link #getIndex() <em>Index</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getIndex()
	 * @generated
	 * @ordered
	 */
	protected DimensionSymbol index;

	/**
	 * The cached value of the '{@link #getFrom() <em>From</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getFrom()
	 * @generated
	 * @ordered
	 */
	protected Dimension from;
	/**
	 * The cached value of the '{@link #getTo() <em>To</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getTo()
	 * @generated
	 * @ordered
	 */
	protected Dimension to;
	/**
	 * The default value of the '{@link #isToIncluded() <em>To Included</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #isToIncluded()
	 * @generated
	 * @ordered
	 */
	protected static final boolean TO_INCLUDED_EDEFAULT = false;
	/**
	 * The cached value of the '{@link #isToIncluded() <em>To Included</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #isToIncluded()
	 * @generated
	 * @ordered
	 */
	protected boolean toIncluded = TO_INCLUDED_EDEFAULT;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected DimensionIterationBlockImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return IrPackage.Literals.DIMENSION_ITERATION_BLOCK;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public DimensionSymbol getIndex() {
		if (index != null && index.eIsProxy()) {
			InternalEObject oldIndex = (InternalEObject)index;
			index = (DimensionSymbol)eResolveProxy(oldIndex);
			if (index != oldIndex) {
				InternalEObject newIndex = (InternalEObject)index;
				NotificationChain msgs = oldIndex.eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.DIMENSION_ITERATION_BLOCK__INDEX, null, null);
				if (newIndex.eInternalContainer() == null) {
					msgs = newIndex.eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.DIMENSION_ITERATION_BLOCK__INDEX, null, msgs);
				}
				if (msgs != null) msgs.dispatch();
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.DIMENSION_ITERATION_BLOCK__INDEX, oldIndex, index));
			}
		}
		return index;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public DimensionSymbol basicGetIndex() {
		return index;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetIndex(DimensionSymbol newIndex, NotificationChain msgs) {
		DimensionSymbol oldIndex = index;
		index = newIndex;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.DIMENSION_ITERATION_BLOCK__INDEX, oldIndex, newIndex);
			if (msgs == null) msgs = notification; else msgs.add(notification);
		}
		return msgs;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setIndex(DimensionSymbol newIndex) {
		if (newIndex != index) {
			NotificationChain msgs = null;
			if (index != null)
				msgs = ((InternalEObject)index).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.DIMENSION_ITERATION_BLOCK__INDEX, null, msgs);
			if (newIndex != null)
				msgs = ((InternalEObject)newIndex).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.DIMENSION_ITERATION_BLOCK__INDEX, null, msgs);
			msgs = basicSetIndex(newIndex, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.DIMENSION_ITERATION_BLOCK__INDEX, newIndex, newIndex));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Dimension getFrom() {
		if (from != null && from.eIsProxy()) {
			InternalEObject oldFrom = (InternalEObject)from;
			from = (Dimension)eResolveProxy(oldFrom);
			if (from != oldFrom) {
				InternalEObject newFrom = (InternalEObject)from;
				NotificationChain msgs = oldFrom.eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.DIMENSION_ITERATION_BLOCK__FROM, null, null);
				if (newFrom.eInternalContainer() == null) {
					msgs = newFrom.eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.DIMENSION_ITERATION_BLOCK__FROM, null, msgs);
				}
				if (msgs != null) msgs.dispatch();
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.DIMENSION_ITERATION_BLOCK__FROM, oldFrom, from));
			}
		}
		return from;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Dimension basicGetFrom() {
		return from;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetFrom(Dimension newFrom, NotificationChain msgs) {
		Dimension oldFrom = from;
		from = newFrom;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.DIMENSION_ITERATION_BLOCK__FROM, oldFrom, newFrom);
			if (msgs == null) msgs = notification; else msgs.add(notification);
		}
		return msgs;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setFrom(Dimension newFrom) {
		if (newFrom != from) {
			NotificationChain msgs = null;
			if (from != null)
				msgs = ((InternalEObject)from).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.DIMENSION_ITERATION_BLOCK__FROM, null, msgs);
			if (newFrom != null)
				msgs = ((InternalEObject)newFrom).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.DIMENSION_ITERATION_BLOCK__FROM, null, msgs);
			msgs = basicSetFrom(newFrom, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.DIMENSION_ITERATION_BLOCK__FROM, newFrom, newFrom));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Dimension getTo() {
		if (to != null && to.eIsProxy()) {
			InternalEObject oldTo = (InternalEObject)to;
			to = (Dimension)eResolveProxy(oldTo);
			if (to != oldTo) {
				InternalEObject newTo = (InternalEObject)to;
				NotificationChain msgs = oldTo.eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.DIMENSION_ITERATION_BLOCK__TO, null, null);
				if (newTo.eInternalContainer() == null) {
					msgs = newTo.eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.DIMENSION_ITERATION_BLOCK__TO, null, msgs);
				}
				if (msgs != null) msgs.dispatch();
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.DIMENSION_ITERATION_BLOCK__TO, oldTo, to));
			}
		}
		return to;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Dimension basicGetTo() {
		return to;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetTo(Dimension newTo, NotificationChain msgs) {
		Dimension oldTo = to;
		to = newTo;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.DIMENSION_ITERATION_BLOCK__TO, oldTo, newTo);
			if (msgs == null) msgs = notification; else msgs.add(notification);
		}
		return msgs;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setTo(Dimension newTo) {
		if (newTo != to) {
			NotificationChain msgs = null;
			if (to != null)
				msgs = ((InternalEObject)to).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.DIMENSION_ITERATION_BLOCK__TO, null, msgs);
			if (newTo != null)
				msgs = ((InternalEObject)newTo).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.DIMENSION_ITERATION_BLOCK__TO, null, msgs);
			msgs = basicSetTo(newTo, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.DIMENSION_ITERATION_BLOCK__TO, newTo, newTo));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public boolean isToIncluded() {
		return toIncluded;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setToIncluded(boolean newToIncluded) {
		boolean oldToIncluded = toIncluded;
		toIncluded = newToIncluded;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.DIMENSION_ITERATION_BLOCK__TO_INCLUDED, oldToIncluded, toIncluded));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public NotificationChain eInverseRemove(InternalEObject otherEnd, int featureID, NotificationChain msgs) {
		switch (featureID) {
			case IrPackage.DIMENSION_ITERATION_BLOCK__INDEX:
				return basicSetIndex(null, msgs);
			case IrPackage.DIMENSION_ITERATION_BLOCK__FROM:
				return basicSetFrom(null, msgs);
			case IrPackage.DIMENSION_ITERATION_BLOCK__TO:
				return basicSetTo(null, msgs);
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
			case IrPackage.DIMENSION_ITERATION_BLOCK__INDEX:
				if (resolve) return getIndex();
				return basicGetIndex();
			case IrPackage.DIMENSION_ITERATION_BLOCK__FROM:
				if (resolve) return getFrom();
				return basicGetFrom();
			case IrPackage.DIMENSION_ITERATION_BLOCK__TO:
				if (resolve) return getTo();
				return basicGetTo();
			case IrPackage.DIMENSION_ITERATION_BLOCK__TO_INCLUDED:
				return isToIncluded();
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
			case IrPackage.DIMENSION_ITERATION_BLOCK__INDEX:
				setIndex((DimensionSymbol)newValue);
				return;
			case IrPackage.DIMENSION_ITERATION_BLOCK__FROM:
				setFrom((Dimension)newValue);
				return;
			case IrPackage.DIMENSION_ITERATION_BLOCK__TO:
				setTo((Dimension)newValue);
				return;
			case IrPackage.DIMENSION_ITERATION_BLOCK__TO_INCLUDED:
				setToIncluded((Boolean)newValue);
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
			case IrPackage.DIMENSION_ITERATION_BLOCK__INDEX:
				setIndex((DimensionSymbol)null);
				return;
			case IrPackage.DIMENSION_ITERATION_BLOCK__FROM:
				setFrom((Dimension)null);
				return;
			case IrPackage.DIMENSION_ITERATION_BLOCK__TO:
				setTo((Dimension)null);
				return;
			case IrPackage.DIMENSION_ITERATION_BLOCK__TO_INCLUDED:
				setToIncluded(TO_INCLUDED_EDEFAULT);
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
			case IrPackage.DIMENSION_ITERATION_BLOCK__INDEX:
				return index != null;
			case IrPackage.DIMENSION_ITERATION_BLOCK__FROM:
				return from != null;
			case IrPackage.DIMENSION_ITERATION_BLOCK__TO:
				return to != null;
			case IrPackage.DIMENSION_ITERATION_BLOCK__TO_INCLUDED:
				return toIncluded != TO_INCLUDED_EDEFAULT;
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
		result.append(" (toIncluded: ");
		result.append(toIncluded);
		result.append(')');
		return result.toString();
	}

} //DimensionIterationBlockImpl
