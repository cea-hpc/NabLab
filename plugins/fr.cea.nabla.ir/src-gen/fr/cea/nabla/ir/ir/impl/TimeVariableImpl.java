/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.IrPackage;
import fr.cea.nabla.ir.ir.TimeIterator;
import fr.cea.nabla.ir.ir.TimeVariable;

import org.eclipse.emf.common.notify.Notification;
import org.eclipse.emf.common.notify.NotificationChain;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;

import org.eclipse.emf.ecore.impl.ENotificationImpl;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Time Variable</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.TimeVariableImpl#getOriginName <em>Origin Name</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.TimeVariableImpl#getTimeIterator <em>Time Iterator</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.TimeVariableImpl#getTimeIteratorIndex <em>Time Iterator Index</em>}</li>
 * </ul>
 *
 * @generated
 */
public class TimeVariableImpl extends VariableImpl implements TimeVariable {
	/**
	 * The default value of the '{@link #getOriginName() <em>Origin Name</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getOriginName()
	 * @generated
	 * @ordered
	 */
	protected static final String ORIGIN_NAME_EDEFAULT = null;

	/**
	 * The cached value of the '{@link #getOriginName() <em>Origin Name</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getOriginName()
	 * @generated
	 * @ordered
	 */
	protected String originName = ORIGIN_NAME_EDEFAULT;

	/**
	 * The cached value of the '{@link #getTimeIterator() <em>Time Iterator</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getTimeIterator()
	 * @generated
	 * @ordered
	 */
	protected TimeIterator timeIterator;

	/**
	 * The default value of the '{@link #getTimeIteratorIndex() <em>Time Iterator Index</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getTimeIteratorIndex()
	 * @generated
	 * @ordered
	 */
	protected static final int TIME_ITERATOR_INDEX_EDEFAULT = 0;

	/**
	 * The cached value of the '{@link #getTimeIteratorIndex() <em>Time Iterator Index</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getTimeIteratorIndex()
	 * @generated
	 * @ordered
	 */
	protected int timeIteratorIndex = TIME_ITERATOR_INDEX_EDEFAULT;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected TimeVariableImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return IrPackage.Literals.TIME_VARIABLE;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public String getOriginName() {
		return originName;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setOriginName(String newOriginName) {
		String oldOriginName = originName;
		originName = newOriginName;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.TIME_VARIABLE__ORIGIN_NAME, oldOriginName, originName));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public TimeIterator getTimeIterator() {
		if (timeIterator != null && timeIterator.eIsProxy()) {
			InternalEObject oldTimeIterator = (InternalEObject)timeIterator;
			timeIterator = (TimeIterator)eResolveProxy(oldTimeIterator);
			if (timeIterator != oldTimeIterator) {
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.TIME_VARIABLE__TIME_ITERATOR, oldTimeIterator, timeIterator));
			}
		}
		return timeIterator;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public TimeIterator basicGetTimeIterator() {
		return timeIterator;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetTimeIterator(TimeIterator newTimeIterator, NotificationChain msgs) {
		TimeIterator oldTimeIterator = timeIterator;
		timeIterator = newTimeIterator;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.TIME_VARIABLE__TIME_ITERATOR, oldTimeIterator, newTimeIterator);
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
	public void setTimeIterator(TimeIterator newTimeIterator) {
		if (newTimeIterator != timeIterator) {
			NotificationChain msgs = null;
			if (timeIterator != null)
				msgs = ((InternalEObject)timeIterator).eInverseRemove(this, IrPackage.TIME_ITERATOR__VARIABLES, TimeIterator.class, msgs);
			if (newTimeIterator != null)
				msgs = ((InternalEObject)newTimeIterator).eInverseAdd(this, IrPackage.TIME_ITERATOR__VARIABLES, TimeIterator.class, msgs);
			msgs = basicSetTimeIterator(newTimeIterator, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.TIME_VARIABLE__TIME_ITERATOR, newTimeIterator, newTimeIterator));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public int getTimeIteratorIndex() {
		return timeIteratorIndex;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setTimeIteratorIndex(int newTimeIteratorIndex) {
		int oldTimeIteratorIndex = timeIteratorIndex;
		timeIteratorIndex = newTimeIteratorIndex;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.TIME_VARIABLE__TIME_ITERATOR_INDEX, oldTimeIteratorIndex, timeIteratorIndex));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public NotificationChain eInverseAdd(InternalEObject otherEnd, int featureID, NotificationChain msgs) {
		switch (featureID) {
			case IrPackage.TIME_VARIABLE__TIME_ITERATOR:
				if (timeIterator != null)
					msgs = ((InternalEObject)timeIterator).eInverseRemove(this, IrPackage.TIME_ITERATOR__VARIABLES, TimeIterator.class, msgs);
				return basicSetTimeIterator((TimeIterator)otherEnd, msgs);
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
			case IrPackage.TIME_VARIABLE__TIME_ITERATOR:
				return basicSetTimeIterator(null, msgs);
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
			case IrPackage.TIME_VARIABLE__ORIGIN_NAME:
				return getOriginName();
			case IrPackage.TIME_VARIABLE__TIME_ITERATOR:
				if (resolve) return getTimeIterator();
				return basicGetTimeIterator();
			case IrPackage.TIME_VARIABLE__TIME_ITERATOR_INDEX:
				return getTimeIteratorIndex();
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
			case IrPackage.TIME_VARIABLE__ORIGIN_NAME:
				setOriginName((String)newValue);
				return;
			case IrPackage.TIME_VARIABLE__TIME_ITERATOR:
				setTimeIterator((TimeIterator)newValue);
				return;
			case IrPackage.TIME_VARIABLE__TIME_ITERATOR_INDEX:
				setTimeIteratorIndex((Integer)newValue);
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
			case IrPackage.TIME_VARIABLE__ORIGIN_NAME:
				setOriginName(ORIGIN_NAME_EDEFAULT);
				return;
			case IrPackage.TIME_VARIABLE__TIME_ITERATOR:
				setTimeIterator((TimeIterator)null);
				return;
			case IrPackage.TIME_VARIABLE__TIME_ITERATOR_INDEX:
				setTimeIteratorIndex(TIME_ITERATOR_INDEX_EDEFAULT);
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
			case IrPackage.TIME_VARIABLE__ORIGIN_NAME:
				return ORIGIN_NAME_EDEFAULT == null ? originName != null : !ORIGIN_NAME_EDEFAULT.equals(originName);
			case IrPackage.TIME_VARIABLE__TIME_ITERATOR:
				return timeIterator != null;
			case IrPackage.TIME_VARIABLE__TIME_ITERATOR_INDEX:
				return timeIteratorIndex != TIME_ITERATOR_INDEX_EDEFAULT;
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
		result.append(" (originName: ");
		result.append(originName);
		result.append(", timeIteratorIndex: ");
		result.append(timeIteratorIndex);
		result.append(')');
		return result.toString();
	}

} //TimeVariableImpl
