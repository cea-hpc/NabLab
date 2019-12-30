/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.InSituJob;
import fr.cea.nabla.ir.ir.IrPackage;
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
 * An implementation of the model object '<em><b>In Situ Job</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.InSituJobImpl#getDumpedVariables <em>Dumped Variables</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.InSituJobImpl#getPeriodValue <em>Period Value</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.InSituJobImpl#getPeriodVariable <em>Period Variable</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.InSituJobImpl#getIterationVariable <em>Iteration Variable</em>}</li>
 * </ul>
 *
 * @generated
 */
public class InSituJobImpl extends JobImpl implements InSituJob {
	/**
	 * The cached value of the '{@link #getDumpedVariables() <em>Dumped Variables</em>}' reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getDumpedVariables()
	 * @generated
	 * @ordered
	 */
	protected EList<Variable> dumpedVariables;

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
	 * The cached value of the '{@link #getIterationVariable() <em>Iteration Variable</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getIterationVariable()
	 * @generated
	 * @ordered
	 */
	protected SimpleVariable iterationVariable;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected InSituJobImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return IrPackage.Literals.IN_SITU_JOB;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public EList<Variable> getDumpedVariables() {
		if (dumpedVariables == null) {
			dumpedVariables = new EObjectResolvingEList<Variable>(Variable.class, this, IrPackage.IN_SITU_JOB__DUMPED_VARIABLES);
		}
		return dumpedVariables;
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
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.IN_SITU_JOB__PERIOD_VALUE, oldPeriodValue, periodValue));
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
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.IN_SITU_JOB__PERIOD_VARIABLE, oldPeriodVariable, periodVariable));
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
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.IN_SITU_JOB__PERIOD_VARIABLE, oldPeriodVariable, periodVariable));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public SimpleVariable getIterationVariable() {
		if (iterationVariable != null && iterationVariable.eIsProxy()) {
			InternalEObject oldIterationVariable = (InternalEObject)iterationVariable;
			iterationVariable = (SimpleVariable)eResolveProxy(oldIterationVariable);
			if (iterationVariable != oldIterationVariable) {
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.IN_SITU_JOB__ITERATION_VARIABLE, oldIterationVariable, iterationVariable));
			}
		}
		return iterationVariable;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public SimpleVariable basicGetIterationVariable() {
		return iterationVariable;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setIterationVariable(SimpleVariable newIterationVariable) {
		SimpleVariable oldIterationVariable = iterationVariable;
		iterationVariable = newIterationVariable;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.IN_SITU_JOB__ITERATION_VARIABLE, oldIterationVariable, iterationVariable));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Object eGet(int featureID, boolean resolve, boolean coreType) {
		switch (featureID) {
			case IrPackage.IN_SITU_JOB__DUMPED_VARIABLES:
				return getDumpedVariables();
			case IrPackage.IN_SITU_JOB__PERIOD_VALUE:
				return getPeriodValue();
			case IrPackage.IN_SITU_JOB__PERIOD_VARIABLE:
				if (resolve) return getPeriodVariable();
				return basicGetPeriodVariable();
			case IrPackage.IN_SITU_JOB__ITERATION_VARIABLE:
				if (resolve) return getIterationVariable();
				return basicGetIterationVariable();
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
			case IrPackage.IN_SITU_JOB__DUMPED_VARIABLES:
				getDumpedVariables().clear();
				getDumpedVariables().addAll((Collection<? extends Variable>)newValue);
				return;
			case IrPackage.IN_SITU_JOB__PERIOD_VALUE:
				setPeriodValue((Double)newValue);
				return;
			case IrPackage.IN_SITU_JOB__PERIOD_VARIABLE:
				setPeriodVariable((SimpleVariable)newValue);
				return;
			case IrPackage.IN_SITU_JOB__ITERATION_VARIABLE:
				setIterationVariable((SimpleVariable)newValue);
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
			case IrPackage.IN_SITU_JOB__DUMPED_VARIABLES:
				getDumpedVariables().clear();
				return;
			case IrPackage.IN_SITU_JOB__PERIOD_VALUE:
				setPeriodValue(PERIOD_VALUE_EDEFAULT);
				return;
			case IrPackage.IN_SITU_JOB__PERIOD_VARIABLE:
				setPeriodVariable((SimpleVariable)null);
				return;
			case IrPackage.IN_SITU_JOB__ITERATION_VARIABLE:
				setIterationVariable((SimpleVariable)null);
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
			case IrPackage.IN_SITU_JOB__DUMPED_VARIABLES:
				return dumpedVariables != null && !dumpedVariables.isEmpty();
			case IrPackage.IN_SITU_JOB__PERIOD_VALUE:
				return periodValue != PERIOD_VALUE_EDEFAULT;
			case IrPackage.IN_SITU_JOB__PERIOD_VARIABLE:
				return periodVariable != null;
			case IrPackage.IN_SITU_JOB__ITERATION_VARIABLE:
				return iterationVariable != null;
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

} //InSituJobImpl
