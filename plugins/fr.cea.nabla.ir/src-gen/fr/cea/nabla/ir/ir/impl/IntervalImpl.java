/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.Expression;
import fr.cea.nabla.ir.ir.Interval;
import fr.cea.nabla.ir.ir.IrPackage;
import fr.cea.nabla.ir.ir.SimpleVariable;

import org.eclipse.emf.common.notify.Notification;
import org.eclipse.emf.common.notify.NotificationChain;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;

import org.eclipse.emf.ecore.impl.ENotificationImpl;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Interval</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IntervalImpl#getIndex <em>Index</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.IntervalImpl#getNbElems <em>Nb Elems</em>}</li>
 * </ul>
 *
 * @generated
 */
public class IntervalImpl extends IterationBlockImpl implements Interval {
	/**
	 * The cached value of the '{@link #getIndex() <em>Index</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getIndex()
	 * @generated
	 * @ordered
	 */
	protected SimpleVariable index;

	/**
	 * The cached value of the '{@link #getNbElems() <em>Nb Elems</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getNbElems()
	 * @generated
	 * @ordered
	 */
	protected Expression nbElems;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected IntervalImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return IrPackage.Literals.INTERVAL;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public SimpleVariable getIndex() {
		if (index != null && index.eIsProxy()) {
			InternalEObject oldIndex = (InternalEObject)index;
			index = (SimpleVariable)eResolveProxy(oldIndex);
			if (index != oldIndex) {
				InternalEObject newIndex = (InternalEObject)index;
				NotificationChain msgs = oldIndex.eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.INTERVAL__INDEX, null, null);
				if (newIndex.eInternalContainer() == null) {
					msgs = newIndex.eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.INTERVAL__INDEX, null, msgs);
				}
				if (msgs != null) msgs.dispatch();
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.INTERVAL__INDEX, oldIndex, index));
			}
		}
		return index;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public SimpleVariable basicGetIndex() {
		return index;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetIndex(SimpleVariable newIndex, NotificationChain msgs) {
		SimpleVariable oldIndex = index;
		index = newIndex;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.INTERVAL__INDEX, oldIndex, newIndex);
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
	public void setIndex(SimpleVariable newIndex) {
		if (newIndex != index) {
			NotificationChain msgs = null;
			if (index != null)
				msgs = ((InternalEObject)index).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.INTERVAL__INDEX, null, msgs);
			if (newIndex != null)
				msgs = ((InternalEObject)newIndex).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.INTERVAL__INDEX, null, msgs);
			msgs = basicSetIndex(newIndex, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.INTERVAL__INDEX, newIndex, newIndex));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Expression getNbElems() {
		if (nbElems != null && nbElems.eIsProxy()) {
			InternalEObject oldNbElems = (InternalEObject)nbElems;
			nbElems = (Expression)eResolveProxy(oldNbElems);
			if (nbElems != oldNbElems) {
				InternalEObject newNbElems = (InternalEObject)nbElems;
				NotificationChain msgs = oldNbElems.eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.INTERVAL__NB_ELEMS, null, null);
				if (newNbElems.eInternalContainer() == null) {
					msgs = newNbElems.eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.INTERVAL__NB_ELEMS, null, msgs);
				}
				if (msgs != null) msgs.dispatch();
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.INTERVAL__NB_ELEMS, oldNbElems, nbElems));
			}
		}
		return nbElems;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Expression basicGetNbElems() {
		return nbElems;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetNbElems(Expression newNbElems, NotificationChain msgs) {
		Expression oldNbElems = nbElems;
		nbElems = newNbElems;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.INTERVAL__NB_ELEMS, oldNbElems, newNbElems);
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
	public void setNbElems(Expression newNbElems) {
		if (newNbElems != nbElems) {
			NotificationChain msgs = null;
			if (nbElems != null)
				msgs = ((InternalEObject)nbElems).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.INTERVAL__NB_ELEMS, null, msgs);
			if (newNbElems != null)
				msgs = ((InternalEObject)newNbElems).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.INTERVAL__NB_ELEMS, null, msgs);
			msgs = basicSetNbElems(newNbElems, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.INTERVAL__NB_ELEMS, newNbElems, newNbElems));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public NotificationChain eInverseRemove(InternalEObject otherEnd, int featureID, NotificationChain msgs) {
		switch (featureID) {
			case IrPackage.INTERVAL__INDEX:
				return basicSetIndex(null, msgs);
			case IrPackage.INTERVAL__NB_ELEMS:
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
			case IrPackage.INTERVAL__INDEX:
				if (resolve) return getIndex();
				return basicGetIndex();
			case IrPackage.INTERVAL__NB_ELEMS:
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
			case IrPackage.INTERVAL__INDEX:
				setIndex((SimpleVariable)newValue);
				return;
			case IrPackage.INTERVAL__NB_ELEMS:
				setNbElems((Expression)newValue);
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
			case IrPackage.INTERVAL__INDEX:
				setIndex((SimpleVariable)null);
				return;
			case IrPackage.INTERVAL__NB_ELEMS:
				setNbElems((Expression)null);
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
			case IrPackage.INTERVAL__INDEX:
				return index != null;
			case IrPackage.INTERVAL__NB_ELEMS:
				return nbElems != null;
		}
		return super.eIsSet(featureID);
	}

} //IntervalImpl
