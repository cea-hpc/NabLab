/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.IrPackage;
import fr.cea.nabla.ir.ir.PostProcessingInfo;
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
 * An implementation of the model object '<em><b>Post Processing Info</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.PostProcessingInfoImpl#getOutputVariables <em>Output Variables</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.PostProcessingInfoImpl#getPeriodValue <em>Period Value</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.PostProcessingInfoImpl#getPeriodVariable <em>Period Variable</em>}</li>
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
	 * The default value of the '{@link #getPeriodValue() <em>Period Value</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getPeriodValue()
	 * @generated
	 * @ordered
	 */
	protected static final double PERIOD_VALUE_EDEFAULT = -1.0;

	/**
	 * The cached value of the '{@link #getPeriodValue() <em>Period Value</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getPeriodValue()
	 * @generated
	 * @ordered
	 */
	protected double periodValue = PERIOD_VALUE_EDEFAULT;

	/**
	 * The cached value of the '{@link #getPeriodVariable() <em>Period Variable</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getPeriodVariable()
	 * @generated
	 * @ordered
	 */
	protected SimpleVariable periodVariable;

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
	public double getPeriodValue() {
		return periodValue;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setPeriodValue(double newPeriodValue) {
		double oldPeriodValue = periodValue;
		periodValue = newPeriodValue;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.POST_PROCESSING_INFO__PERIOD_VALUE, oldPeriodValue, periodValue));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public SimpleVariable getPeriodVariable() {
		if (periodVariable != null && periodVariable.eIsProxy()) {
			InternalEObject oldPeriodVariable = (InternalEObject)periodVariable;
			periodVariable = (SimpleVariable)eResolveProxy(oldPeriodVariable);
			if (periodVariable != oldPeriodVariable) {
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.POST_PROCESSING_INFO__PERIOD_VARIABLE, oldPeriodVariable, periodVariable));
			}
		}
		return periodVariable;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public SimpleVariable basicGetPeriodVariable() {
		return periodVariable;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setPeriodVariable(SimpleVariable newPeriodVariable) {
		SimpleVariable oldPeriodVariable = periodVariable;
		periodVariable = newPeriodVariable;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.POST_PROCESSING_INFO__PERIOD_VARIABLE, oldPeriodVariable, periodVariable));
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
	@Override
	public void setLastDumpVariable(SimpleVariable newLastDumpVariable) {
		SimpleVariable oldLastDumpVariable = lastDumpVariable;
		lastDumpVariable = newLastDumpVariable;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.POST_PROCESSING_INFO__LAST_DUMP_VARIABLE, oldLastDumpVariable, lastDumpVariable));
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
			case IrPackage.POST_PROCESSING_INFO__PERIOD_VALUE:
				return getPeriodValue();
			case IrPackage.POST_PROCESSING_INFO__PERIOD_VARIABLE:
				if (resolve) return getPeriodVariable();
				return basicGetPeriodVariable();
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
			case IrPackage.POST_PROCESSING_INFO__PERIOD_VALUE:
				setPeriodValue((Double)newValue);
				return;
			case IrPackage.POST_PROCESSING_INFO__PERIOD_VARIABLE:
				setPeriodVariable((SimpleVariable)newValue);
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
			case IrPackage.POST_PROCESSING_INFO__PERIOD_VALUE:
				setPeriodValue(PERIOD_VALUE_EDEFAULT);
				return;
			case IrPackage.POST_PROCESSING_INFO__PERIOD_VARIABLE:
				setPeriodVariable((SimpleVariable)null);
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
			case IrPackage.POST_PROCESSING_INFO__PERIOD_VALUE:
				return periodValue != PERIOD_VALUE_EDEFAULT;
			case IrPackage.POST_PROCESSING_INFO__PERIOD_VARIABLE:
				return periodVariable != null;
			case IrPackage.POST_PROCESSING_INFO__LAST_DUMP_VARIABLE:
				return lastDumpVariable != null;
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
		result.append(" (periodValue: ");
		result.append(periodValue);
		result.append(')');
		return result.toString();
	}

} //PostProcessingInfoImpl
