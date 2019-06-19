/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.Expression;
import fr.cea.nabla.ir.ir.Instruction;
import fr.cea.nabla.ir.ir.IrPackage;
import fr.cea.nabla.ir.ir.Reduction;
import fr.cea.nabla.ir.ir.ReductionInstruction;
import fr.cea.nabla.ir.ir.SimpleVariable;
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
 * An implementation of the model object '<em><b>Reduction Instruction</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.ReductionInstructionImpl#getInnerReductions <em>Inner Reductions</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.ReductionInstructionImpl#getReduction <em>Reduction</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.ReductionInstructionImpl#getArg <em>Arg</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.ReductionInstructionImpl#getResult <em>Result</em>}</li>
 * </ul>
 *
 * @generated
 */
public class ReductionInstructionImpl extends IterableInstructionImpl implements ReductionInstruction {
	/**
	 * The cached value of the '{@link #getInnerReductions() <em>Inner Reductions</em>}' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getInnerReductions()
	 * @generated
	 * @ordered
	 */
	protected EList<Instruction> innerReductions;

	/**
	 * The cached value of the '{@link #getReduction() <em>Reduction</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getReduction()
	 * @generated
	 * @ordered
	 */
	protected Reduction reduction;

	/**
	 * The cached value of the '{@link #getArg() <em>Arg</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getArg()
	 * @generated
	 * @ordered
	 */
	protected Expression arg;

	/**
	 * The cached value of the '{@link #getResult() <em>Result</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getResult()
	 * @generated
	 * @ordered
	 */
	protected SimpleVariable result;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected ReductionInstructionImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return IrPackage.Literals.REDUCTION_INSTRUCTION;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EList<Instruction> getInnerReductions() {
		if (innerReductions == null) {
			innerReductions = new EObjectContainmentEList.Resolving<Instruction>(Instruction.class, this, IrPackage.REDUCTION_INSTRUCTION__INNER_REDUCTIONS);
		}
		return innerReductions;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Reduction getReduction() {
		if (reduction != null && reduction.eIsProxy()) {
			InternalEObject oldReduction = (InternalEObject)reduction;
			reduction = (Reduction)eResolveProxy(oldReduction);
			if (reduction != oldReduction) {
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.REDUCTION_INSTRUCTION__REDUCTION, oldReduction, reduction));
			}
		}
		return reduction;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Reduction basicGetReduction() {
		return reduction;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setReduction(Reduction newReduction) {
		Reduction oldReduction = reduction;
		reduction = newReduction;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.REDUCTION_INSTRUCTION__REDUCTION, oldReduction, reduction));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Expression getArg() {
		return arg;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetArg(Expression newArg, NotificationChain msgs) {
		Expression oldArg = arg;
		arg = newArg;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.REDUCTION_INSTRUCTION__ARG, oldArg, newArg);
			if (msgs == null) msgs = notification; else msgs.add(notification);
		}
		return msgs;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setArg(Expression newArg) {
		if (newArg != arg) {
			NotificationChain msgs = null;
			if (arg != null)
				msgs = ((InternalEObject)arg).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.REDUCTION_INSTRUCTION__ARG, null, msgs);
			if (newArg != null)
				msgs = ((InternalEObject)newArg).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.REDUCTION_INSTRUCTION__ARG, null, msgs);
			msgs = basicSetArg(newArg, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.REDUCTION_INSTRUCTION__ARG, newArg, newArg));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public SimpleVariable getResult() {
		return result;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetResult(SimpleVariable newResult, NotificationChain msgs) {
		SimpleVariable oldResult = result;
		result = newResult;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.REDUCTION_INSTRUCTION__RESULT, oldResult, newResult);
			if (msgs == null) msgs = notification; else msgs.add(notification);
		}
		return msgs;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setResult(SimpleVariable newResult) {
		if (newResult != result) {
			NotificationChain msgs = null;
			if (result != null)
				msgs = ((InternalEObject)result).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.REDUCTION_INSTRUCTION__RESULT, null, msgs);
			if (newResult != null)
				msgs = ((InternalEObject)newResult).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.REDUCTION_INSTRUCTION__RESULT, null, msgs);
			msgs = basicSetResult(newResult, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.REDUCTION_INSTRUCTION__RESULT, newResult, newResult));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public NotificationChain eInverseRemove(InternalEObject otherEnd, int featureID, NotificationChain msgs) {
		switch (featureID) {
			case IrPackage.REDUCTION_INSTRUCTION__INNER_REDUCTIONS:
				return ((InternalEList<?>)getInnerReductions()).basicRemove(otherEnd, msgs);
			case IrPackage.REDUCTION_INSTRUCTION__ARG:
				return basicSetArg(null, msgs);
			case IrPackage.REDUCTION_INSTRUCTION__RESULT:
				return basicSetResult(null, msgs);
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
			case IrPackage.REDUCTION_INSTRUCTION__INNER_REDUCTIONS:
				return getInnerReductions();
			case IrPackage.REDUCTION_INSTRUCTION__REDUCTION:
				if (resolve) return getReduction();
				return basicGetReduction();
			case IrPackage.REDUCTION_INSTRUCTION__ARG:
				return getArg();
			case IrPackage.REDUCTION_INSTRUCTION__RESULT:
				return getResult();
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
			case IrPackage.REDUCTION_INSTRUCTION__INNER_REDUCTIONS:
				getInnerReductions().clear();
				getInnerReductions().addAll((Collection<? extends Instruction>)newValue);
				return;
			case IrPackage.REDUCTION_INSTRUCTION__REDUCTION:
				setReduction((Reduction)newValue);
				return;
			case IrPackage.REDUCTION_INSTRUCTION__ARG:
				setArg((Expression)newValue);
				return;
			case IrPackage.REDUCTION_INSTRUCTION__RESULT:
				setResult((SimpleVariable)newValue);
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
			case IrPackage.REDUCTION_INSTRUCTION__INNER_REDUCTIONS:
				getInnerReductions().clear();
				return;
			case IrPackage.REDUCTION_INSTRUCTION__REDUCTION:
				setReduction((Reduction)null);
				return;
			case IrPackage.REDUCTION_INSTRUCTION__ARG:
				setArg((Expression)null);
				return;
			case IrPackage.REDUCTION_INSTRUCTION__RESULT:
				setResult((SimpleVariable)null);
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
			case IrPackage.REDUCTION_INSTRUCTION__INNER_REDUCTIONS:
				return innerReductions != null && !innerReductions.isEmpty();
			case IrPackage.REDUCTION_INSTRUCTION__REDUCTION:
				return reduction != null;
			case IrPackage.REDUCTION_INSTRUCTION__ARG:
				return arg != null;
			case IrPackage.REDUCTION_INSTRUCTION__RESULT:
				return result != null;
		}
		return super.eIsSet(featureID);
	}

} //ReductionInstructionImpl
