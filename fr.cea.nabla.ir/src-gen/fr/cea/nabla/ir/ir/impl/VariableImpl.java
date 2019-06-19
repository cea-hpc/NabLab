/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.BaseType;
import fr.cea.nabla.ir.ir.IrPackage;
import fr.cea.nabla.ir.ir.Variable;

import org.eclipse.emf.common.notify.Notification;

import org.eclipse.emf.common.notify.NotificationChain;
import org.eclipse.emf.ecore.EClass;

import org.eclipse.emf.ecore.InternalEObject;
import org.eclipse.emf.ecore.impl.ENotificationImpl;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Variable</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.VariableImpl#getName <em>Name</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.VariableImpl#getType <em>Type</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.VariableImpl#isPersist <em>Persist</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.VariableImpl#getPersistenceName <em>Persistence Name</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.VariableImpl#isConst <em>Const</em>}</li>
 * </ul>
 *
 * @generated
 */
public abstract class VariableImpl extends IrAnnotableImpl implements Variable {
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
	 * The cached value of the '{@link #getType() <em>Type</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getType()
	 * @generated
	 * @ordered
	 */
	protected BaseType type;

	/**
	 * The default value of the '{@link #isPersist() <em>Persist</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #isPersist()
	 * @generated
	 * @ordered
	 */
	protected static final boolean PERSIST_EDEFAULT = false;

	/**
	 * The cached value of the '{@link #isPersist() <em>Persist</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #isPersist()
	 * @generated
	 * @ordered
	 */
	protected boolean persist = PERSIST_EDEFAULT;

	/**
	 * The default value of the '{@link #getPersistenceName() <em>Persistence Name</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getPersistenceName()
	 * @generated
	 * @ordered
	 */
	protected static final String PERSISTENCE_NAME_EDEFAULT = null;

	/**
	 * The cached value of the '{@link #getPersistenceName() <em>Persistence Name</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getPersistenceName()
	 * @generated
	 * @ordered
	 */
	protected String persistenceName = PERSISTENCE_NAME_EDEFAULT;

	/**
	 * The default value of the '{@link #isConst() <em>Const</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #isConst()
	 * @generated
	 * @ordered
	 */
	protected static final boolean CONST_EDEFAULT = false;

	/**
	 * The cached value of the '{@link #isConst() <em>Const</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #isConst()
	 * @generated
	 * @ordered
	 */
	protected boolean const_ = CONST_EDEFAULT;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected VariableImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return IrPackage.Literals.VARIABLE;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public String getName() {
		return name;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setName(String newName) {
		String oldName = name;
		name = newName;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.VARIABLE__NAME, oldName, name));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public BaseType getType() {
		if (type != null && type.eIsProxy()) {
			InternalEObject oldType = (InternalEObject)type;
			type = (BaseType)eResolveProxy(oldType);
			if (type != oldType) {
				InternalEObject newType = (InternalEObject)type;
				NotificationChain msgs = oldType.eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.VARIABLE__TYPE, null, null);
				if (newType.eInternalContainer() == null) {
					msgs = newType.eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.VARIABLE__TYPE, null, msgs);
				}
				if (msgs != null) msgs.dispatch();
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.VARIABLE__TYPE, oldType, type));
			}
		}
		return type;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public BaseType basicGetType() {
		return type;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetType(BaseType newType, NotificationChain msgs) {
		BaseType oldType = type;
		type = newType;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.VARIABLE__TYPE, oldType, newType);
			if (msgs == null) msgs = notification; else msgs.add(notification);
		}
		return msgs;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setType(BaseType newType) {
		if (newType != type) {
			NotificationChain msgs = null;
			if (type != null)
				msgs = ((InternalEObject)type).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.VARIABLE__TYPE, null, msgs);
			if (newType != null)
				msgs = ((InternalEObject)newType).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.VARIABLE__TYPE, null, msgs);
			msgs = basicSetType(newType, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.VARIABLE__TYPE, newType, newType));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public boolean isPersist() {
		return persist;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setPersist(boolean newPersist) {
		boolean oldPersist = persist;
		persist = newPersist;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.VARIABLE__PERSIST, oldPersist, persist));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public String getPersistenceName() {
		return persistenceName;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setPersistenceName(String newPersistenceName) {
		String oldPersistenceName = persistenceName;
		persistenceName = newPersistenceName;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.VARIABLE__PERSISTENCE_NAME, oldPersistenceName, persistenceName));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public boolean isConst() {
		return const_;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setConst(boolean newConst) {
		boolean oldConst = const_;
		const_ = newConst;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.VARIABLE__CONST, oldConst, const_));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public NotificationChain eInverseRemove(InternalEObject otherEnd, int featureID, NotificationChain msgs) {
		switch (featureID) {
			case IrPackage.VARIABLE__TYPE:
				return basicSetType(null, msgs);
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
			case IrPackage.VARIABLE__NAME:
				return getName();
			case IrPackage.VARIABLE__TYPE:
				if (resolve) return getType();
				return basicGetType();
			case IrPackage.VARIABLE__PERSIST:
				return isPersist();
			case IrPackage.VARIABLE__PERSISTENCE_NAME:
				return getPersistenceName();
			case IrPackage.VARIABLE__CONST:
				return isConst();
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
			case IrPackage.VARIABLE__NAME:
				setName((String)newValue);
				return;
			case IrPackage.VARIABLE__TYPE:
				setType((BaseType)newValue);
				return;
			case IrPackage.VARIABLE__PERSIST:
				setPersist((Boolean)newValue);
				return;
			case IrPackage.VARIABLE__PERSISTENCE_NAME:
				setPersistenceName((String)newValue);
				return;
			case IrPackage.VARIABLE__CONST:
				setConst((Boolean)newValue);
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
			case IrPackage.VARIABLE__NAME:
				setName(NAME_EDEFAULT);
				return;
			case IrPackage.VARIABLE__TYPE:
				setType((BaseType)null);
				return;
			case IrPackage.VARIABLE__PERSIST:
				setPersist(PERSIST_EDEFAULT);
				return;
			case IrPackage.VARIABLE__PERSISTENCE_NAME:
				setPersistenceName(PERSISTENCE_NAME_EDEFAULT);
				return;
			case IrPackage.VARIABLE__CONST:
				setConst(CONST_EDEFAULT);
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
			case IrPackage.VARIABLE__NAME:
				return NAME_EDEFAULT == null ? name != null : !NAME_EDEFAULT.equals(name);
			case IrPackage.VARIABLE__TYPE:
				return type != null;
			case IrPackage.VARIABLE__PERSIST:
				return persist != PERSIST_EDEFAULT;
			case IrPackage.VARIABLE__PERSISTENCE_NAME:
				return PERSISTENCE_NAME_EDEFAULT == null ? persistenceName != null : !PERSISTENCE_NAME_EDEFAULT.equals(persistenceName);
			case IrPackage.VARIABLE__CONST:
				return const_ != CONST_EDEFAULT;
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
		result.append(", persist: ");
		result.append(persist);
		result.append(", persistenceName: ");
		result.append(persistenceName);
		result.append(", const: ");
		result.append(const_);
		result.append(')');
		return result.toString();
	}

} //VariableImpl
