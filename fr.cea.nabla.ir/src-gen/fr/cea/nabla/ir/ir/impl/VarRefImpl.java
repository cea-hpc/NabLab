/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.IrPackage;
import fr.cea.nabla.ir.ir.VarRef;
import fr.cea.nabla.ir.ir.VarRefIteratorRef;
import fr.cea.nabla.ir.ir.Variable;

import java.util.Collection;

import org.eclipse.emf.common.notify.Notification;
import org.eclipse.emf.common.notify.NotificationChain;

import org.eclipse.emf.common.util.EList;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;

import org.eclipse.emf.ecore.impl.ENotificationImpl;
import org.eclipse.emf.ecore.util.EDataTypeUniqueEList;
import org.eclipse.emf.ecore.util.EObjectContainmentWithInverseEList;
import org.eclipse.emf.ecore.util.InternalEList;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Var Ref</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.VarRefImpl#getVariable <em>Variable</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.VarRefImpl#getIterators <em>Iterators</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.VarRefImpl#getArrayTypeIndices <em>Array Type Indices</em>}</li>
 * </ul>
 *
 * @generated
 */
public class VarRefImpl extends ExpressionImpl implements VarRef {
	/**
	 * The cached value of the '{@link #getVariable() <em>Variable</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getVariable()
	 * @generated
	 * @ordered
	 */
	protected Variable variable;

	/**
	 * The cached value of the '{@link #getIterators() <em>Iterators</em>}' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getIterators()
	 * @generated
	 * @ordered
	 */
	protected EList<VarRefIteratorRef> iterators;

	/**
	 * The cached value of the '{@link #getArrayTypeIndices() <em>Array Type Indices</em>}' attribute list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getArrayTypeIndices()
	 * @generated
	 * @ordered
	 */
	protected EList<Integer> arrayTypeIndices;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected VarRefImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return IrPackage.Literals.VAR_REF;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Variable getVariable() {
		if (variable != null && variable.eIsProxy()) {
			InternalEObject oldVariable = (InternalEObject)variable;
			variable = (Variable)eResolveProxy(oldVariable);
			if (variable != oldVariable) {
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.VAR_REF__VARIABLE, oldVariable, variable));
			}
		}
		return variable;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Variable basicGetVariable() {
		return variable;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setVariable(Variable newVariable) {
		Variable oldVariable = variable;
		variable = newVariable;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.VAR_REF__VARIABLE, oldVariable, variable));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EList<VarRefIteratorRef> getIterators() {
		if (iterators == null) {
			iterators = new EObjectContainmentWithInverseEList<VarRefIteratorRef>(VarRefIteratorRef.class, this, IrPackage.VAR_REF__ITERATORS, IrPackage.VAR_REF_ITERATOR_REF__REFERENCED_BY);
		}
		return iterators;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EList<Integer> getArrayTypeIndices() {
		if (arrayTypeIndices == null) {
			arrayTypeIndices = new EDataTypeUniqueEList<Integer>(Integer.class, this, IrPackage.VAR_REF__ARRAY_TYPE_INDICES);
		}
		return arrayTypeIndices;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@SuppressWarnings("unchecked")
	@Override
	public NotificationChain eInverseAdd(InternalEObject otherEnd, int featureID, NotificationChain msgs) {
		switch (featureID) {
			case IrPackage.VAR_REF__ITERATORS:
				return ((InternalEList<InternalEObject>)(InternalEList<?>)getIterators()).basicAdd(otherEnd, msgs);
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
			case IrPackage.VAR_REF__ITERATORS:
				return ((InternalEList<?>)getIterators()).basicRemove(otherEnd, msgs);
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
			case IrPackage.VAR_REF__VARIABLE:
				if (resolve) return getVariable();
				return basicGetVariable();
			case IrPackage.VAR_REF__ITERATORS:
				return getIterators();
			case IrPackage.VAR_REF__ARRAY_TYPE_INDICES:
				return getArrayTypeIndices();
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
			case IrPackage.VAR_REF__VARIABLE:
				setVariable((Variable)newValue);
				return;
			case IrPackage.VAR_REF__ITERATORS:
				getIterators().clear();
				getIterators().addAll((Collection<? extends VarRefIteratorRef>)newValue);
				return;
			case IrPackage.VAR_REF__ARRAY_TYPE_INDICES:
				getArrayTypeIndices().clear();
				getArrayTypeIndices().addAll((Collection<? extends Integer>)newValue);
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
			case IrPackage.VAR_REF__VARIABLE:
				setVariable((Variable)null);
				return;
			case IrPackage.VAR_REF__ITERATORS:
				getIterators().clear();
				return;
			case IrPackage.VAR_REF__ARRAY_TYPE_INDICES:
				getArrayTypeIndices().clear();
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
			case IrPackage.VAR_REF__VARIABLE:
				return variable != null;
			case IrPackage.VAR_REF__ITERATORS:
				return iterators != null && !iterators.isEmpty();
			case IrPackage.VAR_REF__ARRAY_TYPE_INDICES:
				return arrayTypeIndices != null && !arrayTypeIndices.isEmpty();
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
		result.append(" (arrayTypeIndices: ");
		result.append(arrayTypeIndices);
		result.append(')');
		return result.toString();
	}

} //VarRefImpl
