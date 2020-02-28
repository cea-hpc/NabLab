/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.IntervalIterationBlock;
import fr.cea.nabla.ir.ir.IrPackage;
import fr.cea.nabla.ir.ir.SizeType;
import fr.cea.nabla.ir.ir.SizeTypeSymbol;

import org.eclipse.emf.common.notify.Notification;
import org.eclipse.emf.common.notify.NotificationChain;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;

import org.eclipse.emf.ecore.impl.ENotificationImpl;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Interval Iteration Block</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IntervalIterationBlockImpl#getIndex <em>Index</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IntervalIterationBlockImpl#getNbElems <em>Nb Elems</em>}</li>
 * </ul>
 *
 * @generated
 */
public class IntervalIterationBlockImpl extends IterationBlockImpl implements IntervalIterationBlock {
	/**
	 * The cached value of the '{@link #getIndex() <em>Index</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getIndex()
	 * @generated
	 * @ordered
	 */
	protected SizeTypeSymbol index;

	/**
	 * The cached value of the '{@link #getNbElems() <em>Nb Elems</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getNbElems()
	 * @generated
	 * @ordered
	 */
	protected SizeType nbElems;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected IntervalIterationBlockImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return IrPackage.Literals.INTERVAL_ITERATION_BLOCK;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public SizeTypeSymbol getIndex() {
		if (index != null && index.eIsProxy()) {
			InternalEObject oldIndex = (InternalEObject)index;
			index = (SizeTypeSymbol)eResolveProxy(oldIndex);
			if (index != oldIndex) {
				InternalEObject newIndex = (InternalEObject)index;
				NotificationChain msgs = oldIndex.eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.INTERVAL_ITERATION_BLOCK__INDEX, null, null);
				if (newIndex.eInternalContainer() == null) {
					msgs = newIndex.eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.INTERVAL_ITERATION_BLOCK__INDEX, null, msgs);
				}
				if (msgs != null) msgs.dispatch();
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.INTERVAL_ITERATION_BLOCK__INDEX, oldIndex, index));
			}
		}
		return index;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public SizeTypeSymbol basicGetIndex() {
		return index;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetIndex(SizeTypeSymbol newIndex, NotificationChain msgs) {
		SizeTypeSymbol oldIndex = index;
		index = newIndex;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.INTERVAL_ITERATION_BLOCK__INDEX, oldIndex, newIndex);
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
	public void setIndex(SizeTypeSymbol newIndex) {
		if (newIndex != index) {
			NotificationChain msgs = null;
			if (index != null)
				msgs = ((InternalEObject)index).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.INTERVAL_ITERATION_BLOCK__INDEX, null, msgs);
			if (newIndex != null)
				msgs = ((InternalEObject)newIndex).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.INTERVAL_ITERATION_BLOCK__INDEX, null, msgs);
			msgs = basicSetIndex(newIndex, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.INTERVAL_ITERATION_BLOCK__INDEX, newIndex, newIndex));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public SizeType getNbElems() {
		if (nbElems != null && nbElems.eIsProxy()) {
			InternalEObject oldNbElems = (InternalEObject)nbElems;
			nbElems = (SizeType)eResolveProxy(oldNbElems);
			if (nbElems != oldNbElems) {
				InternalEObject newNbElems = (InternalEObject)nbElems;
				NotificationChain msgs = oldNbElems.eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.INTERVAL_ITERATION_BLOCK__NB_ELEMS, null, null);
				if (newNbElems.eInternalContainer() == null) {
					msgs = newNbElems.eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.INTERVAL_ITERATION_BLOCK__NB_ELEMS, null, msgs);
				}
				if (msgs != null) msgs.dispatch();
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.INTERVAL_ITERATION_BLOCK__NB_ELEMS, oldNbElems, nbElems));
			}
		}
		return nbElems;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public SizeType basicGetNbElems() {
		return nbElems;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetNbElems(SizeType newNbElems, NotificationChain msgs) {
		SizeType oldNbElems = nbElems;
		nbElems = newNbElems;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.INTERVAL_ITERATION_BLOCK__NB_ELEMS, oldNbElems, newNbElems);
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
	public void setNbElems(SizeType newNbElems) {
		if (newNbElems != nbElems) {
			NotificationChain msgs = null;
			if (nbElems != null)
				msgs = ((InternalEObject)nbElems).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.INTERVAL_ITERATION_BLOCK__NB_ELEMS, null, msgs);
			if (newNbElems != null)
				msgs = ((InternalEObject)newNbElems).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.INTERVAL_ITERATION_BLOCK__NB_ELEMS, null, msgs);
			msgs = basicSetNbElems(newNbElems, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.INTERVAL_ITERATION_BLOCK__NB_ELEMS, newNbElems, newNbElems));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public NotificationChain eInverseRemove(InternalEObject otherEnd, int featureID, NotificationChain msgs) {
		switch (featureID) {
			case IrPackage.INTERVAL_ITERATION_BLOCK__INDEX:
				return basicSetIndex(null, msgs);
			case IrPackage.INTERVAL_ITERATION_BLOCK__NB_ELEMS:
				return basicSetNbElems(null, msgs);
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
			case IrPackage.INTERVAL_ITERATION_BLOCK__INDEX:
				if (resolve) return getIndex();
				return basicGetIndex();
			case IrPackage.INTERVAL_ITERATION_BLOCK__NB_ELEMS:
				if (resolve) return getNbElems();
				return basicGetNbElems();
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
			case IrPackage.INTERVAL_ITERATION_BLOCK__INDEX:
				setIndex((SizeTypeSymbol)newValue);
				return;
			case IrPackage.INTERVAL_ITERATION_BLOCK__NB_ELEMS:
				setNbElems((SizeType)newValue);
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
			case IrPackage.INTERVAL_ITERATION_BLOCK__INDEX:
				setIndex((SizeTypeSymbol)null);
				return;
			case IrPackage.INTERVAL_ITERATION_BLOCK__NB_ELEMS:
				setNbElems((SizeType)null);
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
			case IrPackage.INTERVAL_ITERATION_BLOCK__INDEX:
				return index != null;
			case IrPackage.INTERVAL_ITERATION_BLOCK__NB_ELEMS:
				return nbElems != null;
		}
		return super.eIsSet(featureID);
	}

} //IntervalIterationBlockImpl
