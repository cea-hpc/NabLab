/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.IrPackage;
import fr.cea.nabla.ir.ir.PostProcessingInfo;
import fr.cea.nabla.ir.ir.SimpleVariable;
import fr.cea.nabla.ir.ir.Variable;

import java.util.Collection;

import org.eclipse.emf.common.notify.Notification;

import org.eclipse.emf.common.notify.NotificationChain;
import org.eclipse.emf.common.util.EList;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;

import org.eclipse.emf.ecore.impl.ENotificationImpl;

import org.eclipse.emf.ecore.util.EObjectResolvingEList;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Post Processing Info</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.PostProcessingInfoImpl#getOutputVariables <em>Output Variables</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.PostProcessingInfoImpl#getPeriodReference <em>Period Reference</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.PostProcessingInfoImpl#getPeriodValue <em>Period Value</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.PostProcessingInfoImpl#getLastDumpVariable <em>Last Dump Variable</em>}</li>
 * </ul>
 *
 * @generated
 */
public class PostProcessingInfoImpl extends IrAnnotableImpl implements PostProcessingInfo {
	/**
	 * The cached value of the '{@link #getOutputVariables() <em>Output Variables</em>}' reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getOutputVariables()
	 * @generated
	 * @ordered
	 */
	protected EList<Variable> outputVariables;

	/**
	 * The cached value of the '{@link #getPeriodReference() <em>Period Reference</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getPeriodReference()
	 * @generated
	 * @ordered
	 */
	protected SimpleVariable periodReference;

	/**
	 * The cached value of the '{@link #getPeriodValue() <em>Period Value</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getPeriodValue()
	 * @generated
	 * @ordered
	 */
	protected SimpleVariable periodValue;

	/**
	 * The cached value of the '{@link #getLastDumpVariable() <em>Last Dump Variable</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getLastDumpVariable()
	 * @generated
	 * @ordered
	 */
	protected SimpleVariable lastDumpVariable;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected PostProcessingInfoImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return IrPackage.Literals.POST_PROCESSING_INFO;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public EList<Variable> getOutputVariables() {
		if (outputVariables == null) {
			outputVariables = new EObjectResolvingEList<Variable>(Variable.class, this, IrPackage.POST_PROCESSING_INFO__OUTPUT_VARIABLES);
		}
		return outputVariables;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public SimpleVariable getPeriodValue() {
		if (periodValue != null && periodValue.eIsProxy()) {
			InternalEObject oldPeriodValue = (InternalEObject)periodValue;
			periodValue = (SimpleVariable)eResolveProxy(oldPeriodValue);
			if (periodValue != oldPeriodValue) {
				InternalEObject newPeriodValue = (InternalEObject)periodValue;
				NotificationChain msgs = oldPeriodValue.eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.POST_PROCESSING_INFO__PERIOD_VALUE, null, null);
				if (newPeriodValue.eInternalContainer() == null) {
					msgs = newPeriodValue.eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.POST_PROCESSING_INFO__PERIOD_VALUE, null, msgs);
				}
				if (msgs != null) msgs.dispatch();
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.POST_PROCESSING_INFO__PERIOD_VALUE, oldPeriodValue, periodValue));
			}
		}
		return periodValue;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public SimpleVariable basicGetPeriodValue() {
		return periodValue;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetPeriodValue(SimpleVariable newPeriodValue, NotificationChain msgs) {
		SimpleVariable oldPeriodValue = periodValue;
		periodValue = newPeriodValue;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.POST_PROCESSING_INFO__PERIOD_VALUE, oldPeriodValue, newPeriodValue);
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
	public void setPeriodValue(SimpleVariable newPeriodValue) {
		if (newPeriodValue != periodValue) {
			NotificationChain msgs = null;
			if (periodValue != null)
				msgs = ((InternalEObject)periodValue).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.POST_PROCESSING_INFO__PERIOD_VALUE, null, msgs);
			if (newPeriodValue != null)
				msgs = ((InternalEObject)newPeriodValue).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.POST_PROCESSING_INFO__PERIOD_VALUE, null, msgs);
			msgs = basicSetPeriodValue(newPeriodValue, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.POST_PROCESSING_INFO__PERIOD_VALUE, newPeriodValue, newPeriodValue));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public SimpleVariable getPeriodReference() {
		if (periodReference != null && periodReference.eIsProxy()) {
			InternalEObject oldPeriodReference = (InternalEObject)periodReference;
			periodReference = (SimpleVariable)eResolveProxy(oldPeriodReference);
			if (periodReference != oldPeriodReference) {
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.POST_PROCESSING_INFO__PERIOD_REFERENCE, oldPeriodReference, periodReference));
			}
		}
		return periodReference;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public SimpleVariable basicGetPeriodReference() {
		return periodReference;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setPeriodReference(SimpleVariable newPeriodReference) {
		SimpleVariable oldPeriodReference = periodReference;
		periodReference = newPeriodReference;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.POST_PROCESSING_INFO__PERIOD_REFERENCE, oldPeriodReference, periodReference));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public SimpleVariable getLastDumpVariable() {
		if (lastDumpVariable != null && lastDumpVariable.eIsProxy()) {
			InternalEObject oldLastDumpVariable = (InternalEObject)lastDumpVariable;
			lastDumpVariable = (SimpleVariable)eResolveProxy(oldLastDumpVariable);
			if (lastDumpVariable != oldLastDumpVariable) {
				InternalEObject newLastDumpVariable = (InternalEObject)lastDumpVariable;
				NotificationChain msgs = oldLastDumpVariable.eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.POST_PROCESSING_INFO__LAST_DUMP_VARIABLE, null, null);
				if (newLastDumpVariable.eInternalContainer() == null) {
					msgs = newLastDumpVariable.eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.POST_PROCESSING_INFO__LAST_DUMP_VARIABLE, null, msgs);
				}
				if (msgs != null) msgs.dispatch();
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.POST_PROCESSING_INFO__LAST_DUMP_VARIABLE, oldLastDumpVariable, lastDumpVariable));
			}
		}
		return lastDumpVariable;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public SimpleVariable basicGetLastDumpVariable() {
		return lastDumpVariable;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetLastDumpVariable(SimpleVariable newLastDumpVariable, NotificationChain msgs) {
		SimpleVariable oldLastDumpVariable = lastDumpVariable;
		lastDumpVariable = newLastDumpVariable;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.POST_PROCESSING_INFO__LAST_DUMP_VARIABLE, oldLastDumpVariable, newLastDumpVariable);
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
	public void setLastDumpVariable(SimpleVariable newLastDumpVariable) {
		if (newLastDumpVariable != lastDumpVariable) {
			NotificationChain msgs = null;
			if (lastDumpVariable != null)
				msgs = ((InternalEObject)lastDumpVariable).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.POST_PROCESSING_INFO__LAST_DUMP_VARIABLE, null, msgs);
			if (newLastDumpVariable != null)
				msgs = ((InternalEObject)newLastDumpVariable).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.POST_PROCESSING_INFO__LAST_DUMP_VARIABLE, null, msgs);
			msgs = basicSetLastDumpVariable(newLastDumpVariable, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.POST_PROCESSING_INFO__LAST_DUMP_VARIABLE, newLastDumpVariable, newLastDumpVariable));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public NotificationChain eInverseRemove(InternalEObject otherEnd, int featureID, NotificationChain msgs) {
		switch (featureID) {
			case IrPackage.POST_PROCESSING_INFO__PERIOD_VALUE:
				return basicSetPeriodValue(null, msgs);
			case IrPackage.POST_PROCESSING_INFO__LAST_DUMP_VARIABLE:
				return basicSetLastDumpVariable(null, msgs);
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
			case IrPackage.POST_PROCESSING_INFO__OUTPUT_VARIABLES:
				return getOutputVariables();
			case IrPackage.POST_PROCESSING_INFO__PERIOD_REFERENCE:
				if (resolve) return getPeriodReference();
				return basicGetPeriodReference();
			case IrPackage.POST_PROCESSING_INFO__PERIOD_VALUE:
				if (resolve) return getPeriodValue();
				return basicGetPeriodValue();
			case IrPackage.POST_PROCESSING_INFO__LAST_DUMP_VARIABLE:
				if (resolve) return getLastDumpVariable();
				return basicGetLastDumpVariable();
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
			case IrPackage.POST_PROCESSING_INFO__OUTPUT_VARIABLES:
				getOutputVariables().clear();
				getOutputVariables().addAll((Collection<? extends Variable>)newValue);
				return;
			case IrPackage.POST_PROCESSING_INFO__PERIOD_REFERENCE:
				setPeriodReference((SimpleVariable)newValue);
				return;
			case IrPackage.POST_PROCESSING_INFO__PERIOD_VALUE:
				setPeriodValue((SimpleVariable)newValue);
				return;
			case IrPackage.POST_PROCESSING_INFO__LAST_DUMP_VARIABLE:
				setLastDumpVariable((SimpleVariable)newValue);
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
			case IrPackage.POST_PROCESSING_INFO__OUTPUT_VARIABLES:
				getOutputVariables().clear();
				return;
			case IrPackage.POST_PROCESSING_INFO__PERIOD_REFERENCE:
				setPeriodReference((SimpleVariable)null);
				return;
			case IrPackage.POST_PROCESSING_INFO__PERIOD_VALUE:
				setPeriodValue((SimpleVariable)null);
				return;
			case IrPackage.POST_PROCESSING_INFO__LAST_DUMP_VARIABLE:
				setLastDumpVariable((SimpleVariable)null);
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
			case IrPackage.POST_PROCESSING_INFO__OUTPUT_VARIABLES:
				return outputVariables != null && !outputVariables.isEmpty();
			case IrPackage.POST_PROCESSING_INFO__PERIOD_REFERENCE:
				return periodReference != null;
			case IrPackage.POST_PROCESSING_INFO__PERIOD_VALUE:
				return periodValue != null;
			case IrPackage.POST_PROCESSING_INFO__LAST_DUMP_VARIABLE:
				return lastDumpVariable != null;
		}
		return super.eIsSet(featureID);
	}

} //PostProcessingInfoImpl
