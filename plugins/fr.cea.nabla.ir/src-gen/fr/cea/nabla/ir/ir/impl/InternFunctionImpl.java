/**
 */
package fr.cea.nabla.ir.ir.impl;

import org.eclipse.emf.common.notify.Notification;
import org.eclipse.emf.common.notify.NotificationChain;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;
import org.eclipse.emf.ecore.impl.ENotificationImpl;

import fr.cea.nabla.ir.ir.Instruction;
import fr.cea.nabla.ir.ir.InternFunction;
import fr.cea.nabla.ir.ir.IrPackage;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Intern Function</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.InternFunctionImpl#getBody <em>Body</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.InternFunctionImpl#isConstExpr <em>Const Expr</em>}</li>
 * </ul>
 *
 * @generated
 */
public class InternFunctionImpl extends FunctionImpl implements InternFunction {
	/**
	 * The cached value of the '{@link #getBody() <em>Body</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getBody()
	 * @generated
	 * @ordered
	 */
	protected Instruction body;

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
	protected InternFunctionImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return IrPackage.Literals.INTERN_FUNCTION;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Instruction getBody() {
		if (body != null && body.eIsProxy()) {
			InternalEObject oldBody = (InternalEObject)body;
			body = (Instruction)eResolveProxy(oldBody);
			if (body != oldBody) {
				InternalEObject newBody = (InternalEObject)body;
				NotificationChain msgs = oldBody.eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.INTERN_FUNCTION__BODY, null, null);
				if (newBody.eInternalContainer() == null) {
					msgs = newBody.eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.INTERN_FUNCTION__BODY, null, msgs);
				}
				if (msgs != null) msgs.dispatch();
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.INTERN_FUNCTION__BODY, oldBody, body));
			}
		}
		return body;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Instruction basicGetBody() {
		return body;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetBody(Instruction newBody, NotificationChain msgs) {
		Instruction oldBody = body;
		body = newBody;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.INTERN_FUNCTION__BODY, oldBody, newBody);
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
	public void setBody(Instruction newBody) {
		if (newBody != body) {
			NotificationChain msgs = null;
			if (body != null)
				msgs = ((InternalEObject)body).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.INTERN_FUNCTION__BODY, null, msgs);
			if (newBody != null)
				msgs = ((InternalEObject)newBody).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.INTERN_FUNCTION__BODY, null, msgs);
			msgs = basicSetBody(newBody, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.INTERN_FUNCTION__BODY, newBody, newBody));
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
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.INTERN_FUNCTION__CONST_EXPR, oldConstExpr, constExpr));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public NotificationChain eInverseRemove(InternalEObject otherEnd, int featureID, NotificationChain msgs) {
		switch (featureID) {
			case IrPackage.INTERN_FUNCTION__BODY:
				return basicSetBody(null, msgs);
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
			case IrPackage.INTERN_FUNCTION__BODY:
				if (resolve) return getBody();
				return basicGetBody();
			case IrPackage.INTERN_FUNCTION__CONST_EXPR:
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
			case IrPackage.INTERN_FUNCTION__BODY:
				setBody((Instruction)newValue);
				return;
			case IrPackage.INTERN_FUNCTION__CONST_EXPR:
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
			case IrPackage.INTERN_FUNCTION__BODY:
				setBody((Instruction)null);
				return;
			case IrPackage.INTERN_FUNCTION__CONST_EXPR:
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
			case IrPackage.INTERN_FUNCTION__BODY:
				return body != null;
			case IrPackage.INTERN_FUNCTION__CONST_EXPR:
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
		result.append(" (constExpr: ");
		result.append(constExpr);
		result.append(')');
		return result.toString();
	}

} //InternFunctionImpl
