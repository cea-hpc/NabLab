/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.BaseType;
import fr.cea.nabla.ir.ir.Expression;
import fr.cea.nabla.ir.ir.IrPackage;
import fr.cea.nabla.ir.ir.SimpleVariable;

import org.eclipse.emf.common.notify.Notification;
import org.eclipse.emf.common.notify.NotificationChain;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;

import org.eclipse.emf.ecore.impl.ENotificationImpl;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Simple Variable</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.SimpleVariableImpl#getType <em>Type</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.SimpleVariableImpl#getDefaultValue <em>Default Value</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.SimpleVariableImpl#isOption <em>Option</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.SimpleVariableImpl#isConstExpr <em>Const Expr</em>}</li>
 * </ul>
 *
 * @generated
 */
public class SimpleVariableImpl extends VariableImpl implements SimpleVariable {
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
	 * The cached value of the '{@link #getDefaultValue() <em>Default Value</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getDefaultValue()
	 * @generated
	 * @ordered
	 */
	protected Expression defaultValue;

	/**
	 * The default value of the '{@link #isOption() <em>Option</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #isOption()
	 * @generated
	 * @ordered
	 */
	protected static final boolean OPTION_EDEFAULT = false;

	/**
	 * The cached value of the '{@link #isOption() <em>Option</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #isOption()
	 * @generated
	 * @ordered
	 */
	protected boolean option = OPTION_EDEFAULT;

	/**
	 * The default value of the '{@link #isConstExpr() <em>Const Expr</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #isConstExpr()
	 * @generated
	 * @ordered
	 */
	protected static final boolean CONST_EXPR_EDEFAULT = false;

	/**
	 * The cached value of the '{@link #isConstExpr() <em>Const Expr</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #isConstExpr()
	 * @generated
	 * @ordered
	 */
	protected boolean constExpr = CONST_EXPR_EDEFAULT;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected SimpleVariableImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return IrPackage.Literals.SIMPLE_VARIABLE;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public BaseType getType() {
		if (type != null && type.eIsProxy()) {
			InternalEObject oldType = (InternalEObject)type;
			type = (BaseType)eResolveProxy(oldType);
			if (type != oldType) {
				InternalEObject newType = (InternalEObject)type;
				NotificationChain msgs = oldType.eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.SIMPLE_VARIABLE__TYPE, null, null);
				if (newType.eInternalContainer() == null) {
					msgs = newType.eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.SIMPLE_VARIABLE__TYPE, null, msgs);
				}
				if (msgs != null) msgs.dispatch();
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.SIMPLE_VARIABLE__TYPE, oldType, type));
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
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.SIMPLE_VARIABLE__TYPE, oldType, newType);
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
	public void setType(BaseType newType) {
		if (newType != type) {
			NotificationChain msgs = null;
			if (type != null)
				msgs = ((InternalEObject)type).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.SIMPLE_VARIABLE__TYPE, null, msgs);
			if (newType != null)
				msgs = ((InternalEObject)newType).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.SIMPLE_VARIABLE__TYPE, null, msgs);
			msgs = basicSetType(newType, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.SIMPLE_VARIABLE__TYPE, newType, newType));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Expression getDefaultValue() {
		return defaultValue;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetDefaultValue(Expression newDefaultValue, NotificationChain msgs) {
		Expression oldDefaultValue = defaultValue;
		defaultValue = newDefaultValue;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.SIMPLE_VARIABLE__DEFAULT_VALUE, oldDefaultValue, newDefaultValue);
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
	public void setDefaultValue(Expression newDefaultValue) {
		if (newDefaultValue != defaultValue) {
			NotificationChain msgs = null;
			if (defaultValue != null)
				msgs = ((InternalEObject)defaultValue).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.SIMPLE_VARIABLE__DEFAULT_VALUE, null, msgs);
			if (newDefaultValue != null)
				msgs = ((InternalEObject)newDefaultValue).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.SIMPLE_VARIABLE__DEFAULT_VALUE, null, msgs);
			msgs = basicSetDefaultValue(newDefaultValue, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.SIMPLE_VARIABLE__DEFAULT_VALUE, newDefaultValue, newDefaultValue));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public boolean isOption() {
		return option;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setOption(boolean newOption) {
		boolean oldOption = option;
		option = newOption;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.SIMPLE_VARIABLE__OPTION, oldOption, option));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public boolean isConstExpr() {
		return constExpr;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setConstExpr(boolean newConstExpr) {
		boolean oldConstExpr = constExpr;
		constExpr = newConstExpr;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.SIMPLE_VARIABLE__CONST_EXPR, oldConstExpr, constExpr));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public NotificationChain eInverseRemove(InternalEObject otherEnd, int featureID, NotificationChain msgs) {
		switch (featureID) {
			case IrPackage.SIMPLE_VARIABLE__TYPE:
				return basicSetType(null, msgs);
			case IrPackage.SIMPLE_VARIABLE__DEFAULT_VALUE:
				return basicSetDefaultValue(null, msgs);
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
			case IrPackage.SIMPLE_VARIABLE__TYPE:
				if (resolve) return getType();
				return basicGetType();
			case IrPackage.SIMPLE_VARIABLE__DEFAULT_VALUE:
				return getDefaultValue();
			case IrPackage.SIMPLE_VARIABLE__OPTION:
				return isOption();
			case IrPackage.SIMPLE_VARIABLE__CONST_EXPR:
				return isConstExpr();
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
			case IrPackage.SIMPLE_VARIABLE__TYPE:
				setType((BaseType)newValue);
				return;
			case IrPackage.SIMPLE_VARIABLE__DEFAULT_VALUE:
				setDefaultValue((Expression)newValue);
				return;
			case IrPackage.SIMPLE_VARIABLE__OPTION:
				setOption((Boolean)newValue);
				return;
			case IrPackage.SIMPLE_VARIABLE__CONST_EXPR:
				setConstExpr((Boolean)newValue);
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
			case IrPackage.SIMPLE_VARIABLE__TYPE:
				setType((BaseType)null);
				return;
			case IrPackage.SIMPLE_VARIABLE__DEFAULT_VALUE:
				setDefaultValue((Expression)null);
				return;
			case IrPackage.SIMPLE_VARIABLE__OPTION:
				setOption(OPTION_EDEFAULT);
				return;
			case IrPackage.SIMPLE_VARIABLE__CONST_EXPR:
				setConstExpr(CONST_EXPR_EDEFAULT);
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
			case IrPackage.SIMPLE_VARIABLE__TYPE:
				return type != null;
			case IrPackage.SIMPLE_VARIABLE__DEFAULT_VALUE:
				return defaultValue != null;
			case IrPackage.SIMPLE_VARIABLE__OPTION:
				return option != OPTION_EDEFAULT;
			case IrPackage.SIMPLE_VARIABLE__CONST_EXPR:
				return constExpr != CONST_EXPR_EDEFAULT;
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
		result.append(" (option: ");
		result.append(option);
		result.append(", constExpr: ");
		result.append(constExpr);
		result.append(')');
		return result.toString();
	}

} //SimpleVariableImpl
