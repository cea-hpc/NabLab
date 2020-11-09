/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.IrPackage;
import fr.cea.nabla.ir.ir.PostProcessing;
import fr.cea.nabla.ir.ir.SimpleVariable;
import fr.cea.nabla.ir.ir.Variable;

import java.util.Collection;

import org.eclipse.emf.common.notify.Notification;

import org.eclipse.emf.common.util.EList;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;

import org.eclipse.emf.ecore.impl.ENotificationImpl;

import org.eclipse.emf.ecore.util.EObjectResolvingEList;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Post Processing</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.PostProcessingImpl#getOutputVariables <em>Output Variables</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.PostProcessingImpl#getPeriodReference <em>Period Reference</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.PostProcessingImpl#getPeriodValue <em>Period Value</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.PostProcessingImpl#getLastDumpVariable <em>Last Dump Variable</em>}</li>
 * </ul>
 *
 * @generated
 */
public class PostProcessingImpl extends IrAnnotableImpl implements PostProcessing {
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
	 * The cached value of the '{@link #getPeriodValue() <em>Period Value</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getPeriodValue()
	 * @generated
	 * @ordered
	 */
	protected SimpleVariable periodValue;

	/**
	 * The cached value of the '{@link #getLastDumpVariable() <em>Last Dump Variable</em>}' reference.
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
	protected PostProcessingImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return IrPackage.Literals.POST_PROCESSING;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public EList<Variable> getOutputVariables() {
		if (outputVariables == null) {
			outputVariables = new EObjectResolvingEList<Variable>(Variable.class, this, IrPackage.POST_PROCESSING__OUTPUT_VARIABLES);
		}
		return outputVariables;
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
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.POST_PROCESSING__PERIOD_REFERENCE, oldPeriodReference, periodReference));
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
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.POST_PROCESSING__PERIOD_REFERENCE, oldPeriodReference, periodReference));
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
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.POST_PROCESSING__PERIOD_VALUE, oldPeriodValue, periodValue));
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
	@Override
	public void setPeriodValue(SimpleVariable newPeriodValue) {
		SimpleVariable oldPeriodValue = periodValue;
		periodValue = newPeriodValue;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.POST_PROCESSING__PERIOD_VALUE, oldPeriodValue, periodValue));
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
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.POST_PROCESSING__LAST_DUMP_VARIABLE, oldLastDumpVariable, lastDumpVariable));
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
	@Override
	public void setLastDumpVariable(SimpleVariable newLastDumpVariable) {
		SimpleVariable oldLastDumpVariable = lastDumpVariable;
		lastDumpVariable = newLastDumpVariable;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.POST_PROCESSING__LAST_DUMP_VARIABLE, oldLastDumpVariable, lastDumpVariable));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Object eGet(int featureID, boolean resolve, boolean coreType) {
		switch (featureID) {
			case IrPackage.POST_PROCESSING__OUTPUT_VARIABLES:
				return getOutputVariables();
			case IrPackage.POST_PROCESSING__PERIOD_REFERENCE:
				if (resolve) return getPeriodReference();
				return basicGetPeriodReference();
			case IrPackage.POST_PROCESSING__PERIOD_VALUE:
				if (resolve) return getPeriodValue();
				return basicGetPeriodValue();
			case IrPackage.POST_PROCESSING__LAST_DUMP_VARIABLE:
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
			case IrPackage.POST_PROCESSING__OUTPUT_VARIABLES:
				getOutputVariables().clear();
				getOutputVariables().addAll((Collection<? extends Variable>)newValue);
				return;
			case IrPackage.POST_PROCESSING__PERIOD_REFERENCE:
				setPeriodReference((SimpleVariable)newValue);
				return;
			case IrPackage.POST_PROCESSING__PERIOD_VALUE:
				setPeriodValue((SimpleVariable)newValue);
				return;
			case IrPackage.POST_PROCESSING__LAST_DUMP_VARIABLE:
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
			case IrPackage.POST_PROCESSING__OUTPUT_VARIABLES:
				getOutputVariables().clear();
				return;
			case IrPackage.POST_PROCESSING__PERIOD_REFERENCE:
				setPeriodReference((SimpleVariable)null);
				return;
			case IrPackage.POST_PROCESSING__PERIOD_VALUE:
				setPeriodValue((SimpleVariable)null);
				return;
			case IrPackage.POST_PROCESSING__LAST_DUMP_VARIABLE:
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
			case IrPackage.POST_PROCESSING__OUTPUT_VARIABLES:
				return outputVariables != null && !outputVariables.isEmpty();
			case IrPackage.POST_PROCESSING__PERIOD_REFERENCE:
				return periodReference != null;
			case IrPackage.POST_PROCESSING__PERIOD_VALUE:
				return periodValue != null;
			case IrPackage.POST_PROCESSING__LAST_DUMP_VARIABLE:
				return lastDumpVariable != null;
		}
		return super.eIsSet(featureID);
	}

} //PostProcessingImpl
