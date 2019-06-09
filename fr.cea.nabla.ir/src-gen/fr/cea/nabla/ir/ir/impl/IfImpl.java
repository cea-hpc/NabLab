/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.Expression;
import fr.cea.nabla.ir.ir.If;
import fr.cea.nabla.ir.ir.Instruction;
import fr.cea.nabla.ir.ir.IrPackage;

import org.eclipse.emf.common.notify.Notification;
import org.eclipse.emf.common.notify.NotificationChain;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;

import org.eclipse.emf.ecore.impl.ENotificationImpl;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>If</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IfImpl#getCondition <em>Condition</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IfImpl#getThenInstruction <em>Then Instruction</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IfImpl#getElseInstruction <em>Else Instruction</em>}</li>
 * </ul>
 *
 * @generated
 */
public class IfImpl extends InstructionImpl implements If {
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
	 * The cached value of the '{@link #getThenInstruction() <em>Then Instruction</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getThenInstruction()
	 * @generated
	 * @ordered
	 */
	protected Instruction thenInstruction;

	/**
	 * The cached value of the '{@link #getElseInstruction() <em>Else Instruction</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getElseInstruction()
	 * @generated
	 * @ordered
	 */
	protected Instruction elseInstruction;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected IfImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return IrPackage.Literals.IF;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Expression getCondition() {
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
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.IF__CONDITION, oldCondition, newCondition);
			if (msgs == null) msgs = notification; else msgs.add(notification);
		}
		return msgs;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setCondition(Expression newCondition) {
		if (newCondition != condition) {
			NotificationChain msgs = null;
			if (condition != null)
				msgs = ((InternalEObject)condition).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.IF__CONDITION, null, msgs);
			if (newCondition != null)
				msgs = ((InternalEObject)newCondition).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.IF__CONDITION, null, msgs);
			msgs = basicSetCondition(newCondition, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.IF__CONDITION, newCondition, newCondition));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Instruction getThenInstruction() {
		return thenInstruction;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetThenInstruction(Instruction newThenInstruction, NotificationChain msgs) {
		Instruction oldThenInstruction = thenInstruction;
		thenInstruction = newThenInstruction;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.IF__THEN_INSTRUCTION, oldThenInstruction, newThenInstruction);
			if (msgs == null) msgs = notification; else msgs.add(notification);
		}
		return msgs;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setThenInstruction(Instruction newThenInstruction) {
		if (newThenInstruction != thenInstruction) {
			NotificationChain msgs = null;
			if (thenInstruction != null)
				msgs = ((InternalEObject)thenInstruction).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.IF__THEN_INSTRUCTION, null, msgs);
			if (newThenInstruction != null)
				msgs = ((InternalEObject)newThenInstruction).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.IF__THEN_INSTRUCTION, null, msgs);
			msgs = basicSetThenInstruction(newThenInstruction, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.IF__THEN_INSTRUCTION, newThenInstruction, newThenInstruction));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Instruction getElseInstruction() {
		return elseInstruction;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetElseInstruction(Instruction newElseInstruction, NotificationChain msgs) {
		Instruction oldElseInstruction = elseInstruction;
		elseInstruction = newElseInstruction;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.IF__ELSE_INSTRUCTION, oldElseInstruction, newElseInstruction);
			if (msgs == null) msgs = notification; else msgs.add(notification);
		}
		return msgs;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setElseInstruction(Instruction newElseInstruction) {
		if (newElseInstruction != elseInstruction) {
			NotificationChain msgs = null;
			if (elseInstruction != null)
				msgs = ((InternalEObject)elseInstruction).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.IF__ELSE_INSTRUCTION, null, msgs);
			if (newElseInstruction != null)
				msgs = ((InternalEObject)newElseInstruction).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.IF__ELSE_INSTRUCTION, null, msgs);
			msgs = basicSetElseInstruction(newElseInstruction, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.IF__ELSE_INSTRUCTION, newElseInstruction, newElseInstruction));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public NotificationChain eInverseRemove(InternalEObject otherEnd, int featureID, NotificationChain msgs) {
		switch (featureID) {
			case IrPackage.IF__CONDITION:
				return basicSetCondition(null, msgs);
			case IrPackage.IF__THEN_INSTRUCTION:
				return basicSetThenInstruction(null, msgs);
			case IrPackage.IF__ELSE_INSTRUCTION:
				return basicSetElseInstruction(null, msgs);
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
			case IrPackage.IF__CONDITION:
				return getCondition();
			case IrPackage.IF__THEN_INSTRUCTION:
				return getThenInstruction();
			case IrPackage.IF__ELSE_INSTRUCTION:
				return getElseInstruction();
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
			case IrPackage.IF__CONDITION:
				setCondition((Expression)newValue);
				return;
			case IrPackage.IF__THEN_INSTRUCTION:
				setThenInstruction((Instruction)newValue);
				return;
			case IrPackage.IF__ELSE_INSTRUCTION:
				setElseInstruction((Instruction)newValue);
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
			case IrPackage.IF__CONDITION:
				setCondition((Expression)null);
				return;
			case IrPackage.IF__THEN_INSTRUCTION:
				setThenInstruction((Instruction)null);
				return;
			case IrPackage.IF__ELSE_INSTRUCTION:
				setElseInstruction((Instruction)null);
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
			case IrPackage.IF__CONDITION:
				return condition != null;
			case IrPackage.IF__THEN_INSTRUCTION:
				return thenInstruction != null;
			case IrPackage.IF__ELSE_INSTRUCTION:
				return elseInstruction != null;
		}
		return super.eIsSet(featureID);
	}

} //IfImpl
