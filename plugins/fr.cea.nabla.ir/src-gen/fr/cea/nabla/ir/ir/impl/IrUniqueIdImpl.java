/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.IrIndex;
import fr.cea.nabla.ir.ir.IrPackage;
import fr.cea.nabla.ir.ir.IrUniqueId;

import fr.cea.nabla.ir.ir.Iterator;
import org.eclipse.emf.common.notify.Notification;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;

import org.eclipse.emf.ecore.impl.ENotificationImpl;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Unique Id</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IrUniqueIdImpl#getName <em>Name</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IrUniqueIdImpl#getDefaultValueIndex <em>Default Value Index</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IrUniqueIdImpl#getShift <em>Shift</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IrUniqueIdImpl#getIterator <em>Iterator</em>}</li>
 * </ul>
 *
 * @generated
 */
public class IrUniqueIdImpl extends IrAnnotableImpl implements IrUniqueId {
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
	 * The cached value of the '{@link #getDefaultValueIndex() <em>Default Value Index</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getDefaultValueIndex()
	 * @generated
	 * @ordered
	 */
	protected IrIndex defaultValueIndex;

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
	 * The cached value of the '{@link #getIterator() <em>Iterator</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getIterator()
	 * @generated
	 * @ordered
	 */
	protected Iterator iterator;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected IrUniqueIdImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return IrPackage.Literals.IR_UNIQUE_ID;
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
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.IR_UNIQUE_ID__NAME, oldName, name));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public IrIndex getDefaultValueIndex() {
		if (defaultValueIndex != null && defaultValueIndex.eIsProxy()) {
			InternalEObject oldDefaultValueIndex = (InternalEObject)defaultValueIndex;
			defaultValueIndex = (IrIndex)eResolveProxy(oldDefaultValueIndex);
			if (defaultValueIndex != oldDefaultValueIndex) {
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.IR_UNIQUE_ID__DEFAULT_VALUE_INDEX, oldDefaultValueIndex, defaultValueIndex));
			}
		}
		return defaultValueIndex;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public IrIndex basicGetDefaultValueIndex() {
		return defaultValueIndex;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setDefaultValueIndex(IrIndex newDefaultValueIndex) {
		IrIndex oldDefaultValueIndex = defaultValueIndex;
		defaultValueIndex = newDefaultValueIndex;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.IR_UNIQUE_ID__DEFAULT_VALUE_INDEX, oldDefaultValueIndex, defaultValueIndex));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public int getShift() {
		return shift;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setShift(int newShift) {
		int oldShift = shift;
		shift = newShift;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.IR_UNIQUE_ID__SHIFT, oldShift, shift));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Iterator getIterator() {
		if (iterator != null && iterator.eIsProxy()) {
			InternalEObject oldIterator = (InternalEObject)iterator;
			iterator = (Iterator)eResolveProxy(oldIterator);
			if (iterator != oldIterator) {
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.IR_UNIQUE_ID__ITERATOR, oldIterator, iterator));
			}
		}
		return iterator;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Iterator basicGetIterator() {
		return iterator;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setIterator(Iterator newIterator) {
		Iterator oldIterator = iterator;
		iterator = newIterator;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.IR_UNIQUE_ID__ITERATOR, oldIterator, iterator));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Object eGet(int featureID, boolean resolve, boolean coreType) {
		switch (featureID) {
			case IrPackage.IR_UNIQUE_ID__NAME:
				return getName();
			case IrPackage.IR_UNIQUE_ID__DEFAULT_VALUE_INDEX:
				if (resolve) return getDefaultValueIndex();
				return basicGetDefaultValueIndex();
			case IrPackage.IR_UNIQUE_ID__SHIFT:
				return getShift();
			case IrPackage.IR_UNIQUE_ID__ITERATOR:
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
			case IrPackage.IR_UNIQUE_ID__NAME:
				setName((String)newValue);
				return;
			case IrPackage.IR_UNIQUE_ID__DEFAULT_VALUE_INDEX:
				setDefaultValueIndex((IrIndex)newValue);
				return;
			case IrPackage.IR_UNIQUE_ID__SHIFT:
				setShift((Integer)newValue);
				return;
			case IrPackage.IR_UNIQUE_ID__ITERATOR:
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
			case IrPackage.IR_UNIQUE_ID__NAME:
				setName(NAME_EDEFAULT);
				return;
			case IrPackage.IR_UNIQUE_ID__DEFAULT_VALUE_INDEX:
				setDefaultValueIndex((IrIndex)null);
				return;
			case IrPackage.IR_UNIQUE_ID__SHIFT:
				setShift(SHIFT_EDEFAULT);
				return;
			case IrPackage.IR_UNIQUE_ID__ITERATOR:
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
			case IrPackage.IR_UNIQUE_ID__NAME:
				return NAME_EDEFAULT == null ? name != null : !NAME_EDEFAULT.equals(name);
			case IrPackage.IR_UNIQUE_ID__DEFAULT_VALUE_INDEX:
				return defaultValueIndex != null;
			case IrPackage.IR_UNIQUE_ID__SHIFT:
				return shift != SHIFT_EDEFAULT;
			case IrPackage.IR_UNIQUE_ID__ITERATOR:
				return iterator != null;
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
		result.append(", shift: ");
		result.append(shift);
		result.append(')');
		return result.toString();
	}

} //IrUniqueIdImpl
