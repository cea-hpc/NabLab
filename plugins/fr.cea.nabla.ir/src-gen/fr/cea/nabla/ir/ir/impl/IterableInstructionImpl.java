/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.IrPackage;
import fr.cea.nabla.ir.ir.IterableInstruction;
import fr.cea.nabla.ir.ir.IterationBlock;

import org.eclipse.emf.common.notify.Notification;
import org.eclipse.emf.common.notify.NotificationChain;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;

import org.eclipse.emf.ecore.impl.ENotificationImpl;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Iterable Instruction</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IterableInstructionImpl#getIterationBlock <em>Iteration Block</em>}</li>
 * </ul>
 *
 * @generated
 */
public abstract class IterableInstructionImpl extends InstructionImpl implements IterableInstruction {
	/**
	 * The cached value of the '{@link #getIterationBlock() <em>Iteration Block</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getIterationBlock()
	 * @generated
	 * @ordered
	 */
	protected IterationBlock iterationBlock;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected IterableInstructionImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return IrPackage.Literals.ITERABLE_INSTRUCTION;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public IterationBlock getIterationBlock() {
		if (iterationBlock != null && iterationBlock.eIsProxy()) {
			InternalEObject oldIterationBlock = (InternalEObject)iterationBlock;
			iterationBlock = (IterationBlock)eResolveProxy(oldIterationBlock);
			if (iterationBlock != oldIterationBlock) {
				InternalEObject newIterationBlock = (InternalEObject)iterationBlock;
				NotificationChain msgs = oldIterationBlock.eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.ITERABLE_INSTRUCTION__ITERATION_BLOCK, null, null);
				if (newIterationBlock.eInternalContainer() == null) {
					msgs = newIterationBlock.eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.ITERABLE_INSTRUCTION__ITERATION_BLOCK, null, msgs);
				}
				if (msgs != null) msgs.dispatch();
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.ITERABLE_INSTRUCTION__ITERATION_BLOCK, oldIterationBlock, iterationBlock));
			}
		}
		return iterationBlock;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public IterationBlock basicGetIterationBlock() {
		return iterationBlock;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetIterationBlock(IterationBlock newIterationBlock, NotificationChain msgs) {
		IterationBlock oldIterationBlock = iterationBlock;
		iterationBlock = newIterationBlock;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.ITERABLE_INSTRUCTION__ITERATION_BLOCK, oldIterationBlock, newIterationBlock);
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
	public void setIterationBlock(IterationBlock newIterationBlock) {
		if (newIterationBlock != iterationBlock) {
			NotificationChain msgs = null;
			if (iterationBlock != null)
				msgs = ((InternalEObject)iterationBlock).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.ITERABLE_INSTRUCTION__ITERATION_BLOCK, null, msgs);
			if (newIterationBlock != null)
				msgs = ((InternalEObject)newIterationBlock).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.ITERABLE_INSTRUCTION__ITERATION_BLOCK, null, msgs);
			msgs = basicSetIterationBlock(newIterationBlock, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.ITERABLE_INSTRUCTION__ITERATION_BLOCK, newIterationBlock, newIterationBlock));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public NotificationChain eInverseRemove(InternalEObject otherEnd, int featureID, NotificationChain msgs) {
		switch (featureID) {
			case IrPackage.ITERABLE_INSTRUCTION__ITERATION_BLOCK:
				return basicSetIterationBlock(null, msgs);
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
			case IrPackage.ITERABLE_INSTRUCTION__ITERATION_BLOCK:
				if (resolve) return getIterationBlock();
				return basicGetIterationBlock();
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
			case IrPackage.ITERABLE_INSTRUCTION__ITERATION_BLOCK:
				setIterationBlock((IterationBlock)newValue);
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
			case IrPackage.ITERABLE_INSTRUCTION__ITERATION_BLOCK:
				setIterationBlock((IterationBlock)null);
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
			case IrPackage.ITERABLE_INSTRUCTION__ITERATION_BLOCK:
				return iterationBlock != null;
		}
		return super.eIsSet(featureID);
	}

} //IterableInstructionImpl
