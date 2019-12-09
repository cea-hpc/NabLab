/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.ContractedIf;
import fr.cea.nabla.ir.ir.Expression;
import fr.cea.nabla.ir.ir.IrPackage;

import org.eclipse.emf.common.notify.Notification;
import org.eclipse.emf.common.notify.NotificationChain;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;

import org.eclipse.emf.ecore.impl.ENotificationImpl;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Contracted If</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.ContractedIfImpl#getCondition <em>Condition</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.ContractedIfImpl#getThenExpression <em>Then Expression</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.ContractedIfImpl#getElseExpression <em>Else Expression</em>}</li>
 * </ul>
 *
 * @generated
 */
public class ContractedIfImpl extends ExpressionImpl implements ContractedIf {
	/**
	 * The cached value of the '{@link #getCondition() <em>Condition</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getCondition()
	 * @generated
	 * @ordered
	 */
	protected Expression condition;

	/**
	 * The cached value of the '{@link #getThenExpression() <em>Then Expression</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getThenExpression()
	 * @generated
	 * @ordered
	 */
	protected Expression thenExpression;

	/**
	 * The cached value of the '{@link #getElseExpression() <em>Else Expression</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getElseExpression()
	 * @generated
	 * @ordered
	 */
	protected Expression elseExpression;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected ContractedIfImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return IrPackage.Literals.CONTRACTED_IF;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Expression getCondition() {
		if (condition != null && condition.eIsProxy()) {
			InternalEObject oldCondition = (InternalEObject)condition;
			condition = (Expression)eResolveProxy(oldCondition);
			if (condition != oldCondition) {
				InternalEObject newCondition = (InternalEObject)condition;
				NotificationChain msgs = oldCondition.eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.CONTRACTED_IF__CONDITION, null, null);
				if (newCondition.eInternalContainer() == null) {
					msgs = newCondition.eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.CONTRACTED_IF__CONDITION, null, msgs);
				}
				if (msgs != null) msgs.dispatch();
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.CONTRACTED_IF__CONDITION, oldCondition, condition));
			}
		}
		return condition;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Expression basicGetCondition() {
		return condition;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetCondition(Expression newCondition, NotificationChain msgs) {
		Expression oldCondition = condition;
		condition = newCondition;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.CONTRACTED_IF__CONDITION, oldCondition, newCondition);
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
	public void setCondition(Expression newCondition) {
		if (newCondition != condition) {
			NotificationChain msgs = null;
			if (condition != null)
				msgs = ((InternalEObject)condition).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.CONTRACTED_IF__CONDITION, null, msgs);
			if (newCondition != null)
				msgs = ((InternalEObject)newCondition).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.CONTRACTED_IF__CONDITION, null, msgs);
			msgs = basicSetCondition(newCondition, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.CONTRACTED_IF__CONDITION, newCondition, newCondition));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Expression getThenExpression() {
		if (thenExpression != null && thenExpression.eIsProxy()) {
			InternalEObject oldThenExpression = (InternalEObject)thenExpression;
			thenExpression = (Expression)eResolveProxy(oldThenExpression);
			if (thenExpression != oldThenExpression) {
				InternalEObject newThenExpression = (InternalEObject)thenExpression;
				NotificationChain msgs = oldThenExpression.eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.CONTRACTED_IF__THEN_EXPRESSION, null, null);
				if (newThenExpression.eInternalContainer() == null) {
					msgs = newThenExpression.eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.CONTRACTED_IF__THEN_EXPRESSION, null, msgs);
				}
				if (msgs != null) msgs.dispatch();
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.CONTRACTED_IF__THEN_EXPRESSION, oldThenExpression, thenExpression));
			}
		}
		return thenExpression;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Expression basicGetThenExpression() {
		return thenExpression;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetThenExpression(Expression newThenExpression, NotificationChain msgs) {
		Expression oldThenExpression = thenExpression;
		thenExpression = newThenExpression;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.CONTRACTED_IF__THEN_EXPRESSION, oldThenExpression, newThenExpression);
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
	public void setThenExpression(Expression newThenExpression) {
		if (newThenExpression != thenExpression) {
			NotificationChain msgs = null;
			if (thenExpression != null)
				msgs = ((InternalEObject)thenExpression).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.CONTRACTED_IF__THEN_EXPRESSION, null, msgs);
			if (newThenExpression != null)
				msgs = ((InternalEObject)newThenExpression).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.CONTRACTED_IF__THEN_EXPRESSION, null, msgs);
			msgs = basicSetThenExpression(newThenExpression, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.CONTRACTED_IF__THEN_EXPRESSION, newThenExpression, newThenExpression));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Expression getElseExpression() {
		if (elseExpression != null && elseExpression.eIsProxy()) {
			InternalEObject oldElseExpression = (InternalEObject)elseExpression;
			elseExpression = (Expression)eResolveProxy(oldElseExpression);
			if (elseExpression != oldElseExpression) {
				InternalEObject newElseExpression = (InternalEObject)elseExpression;
				NotificationChain msgs = oldElseExpression.eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.CONTRACTED_IF__ELSE_EXPRESSION, null, null);
				if (newElseExpression.eInternalContainer() == null) {
					msgs = newElseExpression.eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.CONTRACTED_IF__ELSE_EXPRESSION, null, msgs);
				}
				if (msgs != null) msgs.dispatch();
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.CONTRACTED_IF__ELSE_EXPRESSION, oldElseExpression, elseExpression));
			}
		}
		return elseExpression;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Expression basicGetElseExpression() {
		return elseExpression;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetElseExpression(Expression newElseExpression, NotificationChain msgs) {
		Expression oldElseExpression = elseExpression;
		elseExpression = newElseExpression;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.CONTRACTED_IF__ELSE_EXPRESSION, oldElseExpression, newElseExpression);
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
	public void setElseExpression(Expression newElseExpression) {
		if (newElseExpression != elseExpression) {
			NotificationChain msgs = null;
			if (elseExpression != null)
				msgs = ((InternalEObject)elseExpression).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.CONTRACTED_IF__ELSE_EXPRESSION, null, msgs);
			if (newElseExpression != null)
				msgs = ((InternalEObject)newElseExpression).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.CONTRACTED_IF__ELSE_EXPRESSION, null, msgs);
			msgs = basicSetElseExpression(newElseExpression, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.CONTRACTED_IF__ELSE_EXPRESSION, newElseExpression, newElseExpression));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public NotificationChain eInverseRemove(InternalEObject otherEnd, int featureID, NotificationChain msgs) {
		switch (featureID) {
			case IrPackage.CONTRACTED_IF__CONDITION:
				return basicSetCondition(null, msgs);
			case IrPackage.CONTRACTED_IF__THEN_EXPRESSION:
				return basicSetThenExpression(null, msgs);
			case IrPackage.CONTRACTED_IF__ELSE_EXPRESSION:
				return basicSetElseExpression(null, msgs);
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
			case IrPackage.CONTRACTED_IF__CONDITION:
				if (resolve) return getCondition();
				return basicGetCondition();
			case IrPackage.CONTRACTED_IF__THEN_EXPRESSION:
				if (resolve) return getThenExpression();
				return basicGetThenExpression();
			case IrPackage.CONTRACTED_IF__ELSE_EXPRESSION:
				if (resolve) return getElseExpression();
				return basicGetElseExpression();
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
			case IrPackage.CONTRACTED_IF__CONDITION:
				setCondition((Expression)newValue);
				return;
			case IrPackage.CONTRACTED_IF__THEN_EXPRESSION:
				setThenExpression((Expression)newValue);
				return;
			case IrPackage.CONTRACTED_IF__ELSE_EXPRESSION:
				setElseExpression((Expression)newValue);
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
			case IrPackage.CONTRACTED_IF__CONDITION:
				setCondition((Expression)null);
				return;
			case IrPackage.CONTRACTED_IF__THEN_EXPRESSION:
				setThenExpression((Expression)null);
				return;
			case IrPackage.CONTRACTED_IF__ELSE_EXPRESSION:
				setElseExpression((Expression)null);
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
			case IrPackage.CONTRACTED_IF__CONDITION:
				return condition != null;
			case IrPackage.CONTRACTED_IF__THEN_EXPRESSION:
				return thenExpression != null;
			case IrPackage.CONTRACTED_IF__ELSE_EXPRESSION:
				return elseExpression != null;
		}
		return super.eIsSet(featureID);
	}

} //ContractedIfImpl
