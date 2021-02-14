/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.Expression;
import fr.cea.nabla.ir.ir.Function;
import fr.cea.nabla.ir.ir.Instruction;
import fr.cea.nabla.ir.ir.IrPackage;
import fr.cea.nabla.ir.ir.ReductionInstruction;
import fr.cea.nabla.ir.ir.Variable;
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
 *   <li>{@link fr.cea.nabla.ir.ir.impl.ReductionInstructionImpl#getInnerInstructions <em>Inner Instructions</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.ReductionInstructionImpl#getBinaryFunction <em>Binary Function</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.ReductionInstructionImpl#getLambda <em>Lambda</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.ReductionInstructionImpl#getResult <em>Result</em>}</li>
 * </ul>
 *
 * @generated
 */
public class ReductionInstructionImpl extends IterableInstructionImpl implements ReductionInstruction {
	/**
	 * The cached value of the '{@link #getInnerInstructions() <em>Inner Instructions</em>}' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getInnerInstructions()
	 * @generated
	 * @ordered
	 */
	protected EList<Instruction> innerInstructions;

	/**
	 * The cached value of the '{@link #getBinaryFunction() <em>Binary Function</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getBinaryFunction()
	 * @generated
	 * @ordered
	 */
	protected Function binaryFunction;

	/**
	 * The cached value of the '{@link #getLambda() <em>Lambda</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getLambda()
	 * @generated
	 * @ordered
	 */
	protected Expression lambda;

	/**
	 * The cached value of the '{@link #getResult() <em>Result</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getResult()
	 * @generated
	 * @ordered
	 */
	protected Variable result;

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
	@Override
	public EList<Instruction> getInnerInstructions() {
		if (innerInstructions == null) {
			innerInstructions = new EObjectContainmentEList.Resolving<Instruction>(Instruction.class, this, IrPackage.REDUCTION_INSTRUCTION__INNER_INSTRUCTIONS);
		}
		return innerInstructions;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Function getBinaryFunction() {
		if (binaryFunction != null && binaryFunction.eIsProxy()) {
			InternalEObject oldBinaryFunction = (InternalEObject)binaryFunction;
			binaryFunction = (Function)eResolveProxy(oldBinaryFunction);
			if (binaryFunction != oldBinaryFunction) {
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.REDUCTION_INSTRUCTION__BINARY_FUNCTION, oldBinaryFunction, binaryFunction));
			}
		}
		return binaryFunction;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Function basicGetBinaryFunction() {
		return binaryFunction;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setBinaryFunction(Function newBinaryFunction) {
		Function oldBinaryFunction = binaryFunction;
		binaryFunction = newBinaryFunction;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.REDUCTION_INSTRUCTION__BINARY_FUNCTION, oldBinaryFunction, binaryFunction));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Expression getLambda() {
		return lambda;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetLambda(Expression newLambda, NotificationChain msgs) {
		Expression oldLambda = lambda;
		lambda = newLambda;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.REDUCTION_INSTRUCTION__LAMBDA, oldLambda, newLambda);
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
	public void setLambda(Expression newLambda) {
		if (newLambda != lambda) {
			NotificationChain msgs = null;
			if (lambda != null)
				msgs = ((InternalEObject)lambda).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.REDUCTION_INSTRUCTION__LAMBDA, null, msgs);
			if (newLambda != null)
				msgs = ((InternalEObject)newLambda).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.REDUCTION_INSTRUCTION__LAMBDA, null, msgs);
			msgs = basicSetLambda(newLambda, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.REDUCTION_INSTRUCTION__LAMBDA, newLambda, newLambda));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Variable getResult() {
		return result;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetResult(Variable newResult, NotificationChain msgs) {
		Variable oldResult = result;
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
	@Override
	public void setResult(Variable newResult) {
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
			case IrPackage.REDUCTION_INSTRUCTION__INNER_INSTRUCTIONS:
				return ((InternalEList<?>)getInnerInstructions()).basicRemove(otherEnd, msgs);
			case IrPackage.REDUCTION_INSTRUCTION__LAMBDA:
				return basicSetLambda(null, msgs);
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
			case IrPackage.REDUCTION_INSTRUCTION__INNER_INSTRUCTIONS:
				return getInnerInstructions();
			case IrPackage.REDUCTION_INSTRUCTION__BINARY_FUNCTION:
				if (resolve) return getBinaryFunction();
				return basicGetBinaryFunction();
			case IrPackage.REDUCTION_INSTRUCTION__LAMBDA:
				return getLambda();
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
			case IrPackage.REDUCTION_INSTRUCTION__INNER_INSTRUCTIONS:
				getInnerInstructions().clear();
				getInnerInstructions().addAll((Collection<? extends Instruction>)newValue);
				return;
			case IrPackage.REDUCTION_INSTRUCTION__BINARY_FUNCTION:
				setBinaryFunction((Function)newValue);
				return;
			case IrPackage.REDUCTION_INSTRUCTION__LAMBDA:
				setLambda((Expression)newValue);
				return;
			case IrPackage.REDUCTION_INSTRUCTION__RESULT:
				setResult((Variable)newValue);
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
			case IrPackage.REDUCTION_INSTRUCTION__INNER_INSTRUCTIONS:
				getInnerInstructions().clear();
				return;
			case IrPackage.REDUCTION_INSTRUCTION__BINARY_FUNCTION:
				setBinaryFunction((Function)null);
				return;
			case IrPackage.REDUCTION_INSTRUCTION__LAMBDA:
				setLambda((Expression)null);
				return;
			case IrPackage.REDUCTION_INSTRUCTION__RESULT:
				setResult((Variable)null);
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
			case IrPackage.REDUCTION_INSTRUCTION__INNER_INSTRUCTIONS:
				return innerInstructions != null && !innerInstructions.isEmpty();
			case IrPackage.REDUCTION_INSTRUCTION__BINARY_FUNCTION:
				return binaryFunction != null;
			case IrPackage.REDUCTION_INSTRUCTION__LAMBDA:
				return lambda != null;
			case IrPackage.REDUCTION_INSTRUCTION__RESULT:
				return result != null;
		}
		return super.eIsSet(featureID);
	}

} //ReductionInstructionImpl
