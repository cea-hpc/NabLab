/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.IrPackage;
import fr.cea.nabla.ir.ir.Iterator;
import fr.cea.nabla.ir.ir.SpaceIterationBlock;

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
 * An implementation of the model object '<em><b>Space Iteration Block</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.SpaceIterationBlockImpl#getRange <em>Range</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.SpaceIterationBlockImpl#getSingletons <em>Singletons</em>}</li>
 * </ul>
 *
 * @generated
 */
public class SpaceIterationBlockImpl extends IterationBlockImpl implements SpaceIterationBlock {
	/**
	 * The cached value of the '{@link #getRange() <em>Range</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getRange()
	 * @generated
	 * @ordered
	 */
	protected Iterator range;

	/**
	 * The cached value of the '{@link #getSingletons() <em>Singletons</em>}' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getSingletons()
	 * @generated
	 * @ordered
	 */
	protected EList<Iterator> singletons;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected SpaceIterationBlockImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return IrPackage.Literals.SPACE_ITERATION_BLOCK;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Iterator getRange() {
		return range;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetRange(Iterator newRange, NotificationChain msgs) {
		Iterator oldRange = range;
		range = newRange;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.SPACE_ITERATION_BLOCK__RANGE, oldRange, newRange);
			if (msgs == null) msgs = notification; else msgs.add(notification);
		}
		return msgs;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setRange(Iterator newRange) {
		if (newRange != range) {
			NotificationChain msgs = null;
			if (range != null)
				msgs = ((InternalEObject)range).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.SPACE_ITERATION_BLOCK__RANGE, null, msgs);
			if (newRange != null)
				msgs = ((InternalEObject)newRange).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.SPACE_ITERATION_BLOCK__RANGE, null, msgs);
			msgs = basicSetRange(newRange, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.SPACE_ITERATION_BLOCK__RANGE, newRange, newRange));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EList<Iterator> getSingletons() {
		if (singletons == null) {
			singletons = new EObjectContainmentEList.Resolving<Iterator>(Iterator.class, this, IrPackage.SPACE_ITERATION_BLOCK__SINGLETONS);
		}
		return singletons;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public NotificationChain eInverseRemove(InternalEObject otherEnd, int featureID, NotificationChain msgs) {
		switch (featureID) {
			case IrPackage.SPACE_ITERATION_BLOCK__RANGE:
				return basicSetRange(null, msgs);
			case IrPackage.SPACE_ITERATION_BLOCK__SINGLETONS:
				return ((InternalEList<?>)getSingletons()).basicRemove(otherEnd, msgs);
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
			case IrPackage.SPACE_ITERATION_BLOCK__RANGE:
				return getRange();
			case IrPackage.SPACE_ITERATION_BLOCK__SINGLETONS:
				return getSingletons();
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
			case IrPackage.SPACE_ITERATION_BLOCK__RANGE:
				setRange((Iterator)newValue);
				return;
			case IrPackage.SPACE_ITERATION_BLOCK__SINGLETONS:
				getSingletons().clear();
				getSingletons().addAll((Collection<? extends Iterator>)newValue);
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
			case IrPackage.SPACE_ITERATION_BLOCK__RANGE:
				setRange((Iterator)null);
				return;
			case IrPackage.SPACE_ITERATION_BLOCK__SINGLETONS:
				getSingletons().clear();
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
			case IrPackage.SPACE_ITERATION_BLOCK__RANGE:
				return range != null;
			case IrPackage.SPACE_ITERATION_BLOCK__SINGLETONS:
				return singletons != null && !singletons.isEmpty();
		}
		return super.eIsSet(featureID);
	}

} //SpaceIterationBlockImpl
