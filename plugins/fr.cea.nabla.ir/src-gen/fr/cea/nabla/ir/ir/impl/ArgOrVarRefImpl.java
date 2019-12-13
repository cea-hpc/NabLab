/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.ArgOrVar;
import fr.cea.nabla.ir.ir.ArgOrVarRef;
import fr.cea.nabla.ir.ir.ArgOrVarRefIteratorRef;
import fr.cea.nabla.ir.ir.IrPackage;
import fr.cea.nabla.ir.ir.SizeType;
import java.util.Collection;

import org.eclipse.emf.common.notify.Notification;
import org.eclipse.emf.common.notify.NotificationChain;

import org.eclipse.emf.common.util.EList;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;

import org.eclipse.emf.ecore.impl.ENotificationImpl;
import org.eclipse.emf.ecore.util.EObjectContainmentEList;
import org.eclipse.emf.ecore.util.EObjectContainmentWithInverseEList;
import org.eclipse.emf.ecore.util.InternalEList;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Arg Or Var Ref</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.ArgOrVarRefImpl#getTarget <em>Target</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.ArgOrVarRefImpl#getIterators <em>Iterators</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.ArgOrVarRefImpl#getIndices <em>Indices</em>}</li>
 * </ul>
 *
 * @generated
 */
public class ArgOrVarRefImpl extends ExpressionImpl implements ArgOrVarRef {
	/**
	 * The cached value of the '{@link #getTarget() <em>Target</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getTarget()
	 * @generated
	 * @ordered
	 */
	protected ArgOrVar target;

	/**
	 * The cached value of the '{@link #getIterators() <em>Iterators</em>}' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getIterators()
	 * @generated
	 * @ordered
	 */
	protected EList<ArgOrVarRefIteratorRef> iterators;

	/**
	 * The cached value of the '{@link #getIndices() <em>Indices</em>}' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getIndices()
	 * @generated
	 * @ordered
	 */
	protected EList<SizeType> indices;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected ArgOrVarRefImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return IrPackage.Literals.ARG_OR_VAR_REF;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public ArgOrVar getTarget() {
		if (target != null && target.eIsProxy()) {
			InternalEObject oldTarget = (InternalEObject)target;
			target = (ArgOrVar)eResolveProxy(oldTarget);
			if (target != oldTarget) {
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.ARG_OR_VAR_REF__TARGET, oldTarget, target));
			}
		}
		return target;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public ArgOrVar basicGetTarget() {
		return target;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setTarget(ArgOrVar newTarget) {
		ArgOrVar oldTarget = target;
		target = newTarget;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.ARG_OR_VAR_REF__TARGET, oldTarget, target));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public EList<ArgOrVarRefIteratorRef> getIterators() {
		if (iterators == null) {
			iterators = new EObjectContainmentWithInverseEList<ArgOrVarRefIteratorRef>(ArgOrVarRefIteratorRef.class, this, IrPackage.ARG_OR_VAR_REF__ITERATORS, IrPackage.ARG_OR_VAR_REF_ITERATOR_REF__REFERENCED_BY);
		}
		return iterators;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public EList<SizeType> getIndices() {
		if (indices == null) {
			indices = new EObjectContainmentEList.Resolving<SizeType>(SizeType.class, this, IrPackage.ARG_OR_VAR_REF__INDICES);
		}
		return indices;
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
			case IrPackage.ARG_OR_VAR_REF__ITERATORS:
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
			case IrPackage.ARG_OR_VAR_REF__ITERATORS:
				return ((InternalEList<?>)getIterators()).basicRemove(otherEnd, msgs);
			case IrPackage.ARG_OR_VAR_REF__INDICES:
				return ((InternalEList<?>)getIndices()).basicRemove(otherEnd, msgs);
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
			case IrPackage.ARG_OR_VAR_REF__TARGET:
				if (resolve) return getTarget();
				return basicGetTarget();
			case IrPackage.ARG_OR_VAR_REF__ITERATORS:
				return getIterators();
			case IrPackage.ARG_OR_VAR_REF__INDICES:
				return getIndices();
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
			case IrPackage.ARG_OR_VAR_REF__TARGET:
				setTarget((ArgOrVar)newValue);
				return;
			case IrPackage.ARG_OR_VAR_REF__ITERATORS:
				getIterators().clear();
				getIterators().addAll((Collection<? extends ArgOrVarRefIteratorRef>)newValue);
				return;
			case IrPackage.ARG_OR_VAR_REF__INDICES:
				getIndices().clear();
				getIndices().addAll((Collection<? extends SizeType>)newValue);
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
			case IrPackage.ARG_OR_VAR_REF__TARGET:
				setTarget((ArgOrVar)null);
				return;
			case IrPackage.ARG_OR_VAR_REF__ITERATORS:
				getIterators().clear();
				return;
			case IrPackage.ARG_OR_VAR_REF__INDICES:
				getIndices().clear();
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
			case IrPackage.ARG_OR_VAR_REF__TARGET:
				return target != null;
			case IrPackage.ARG_OR_VAR_REF__ITERATORS:
				return iterators != null && !iterators.isEmpty();
			case IrPackage.ARG_OR_VAR_REF__INDICES:
				return indices != null && !indices.isEmpty();
		}
		return super.eIsSet(featureID);
	}

} //ArgOrVarRefImpl
