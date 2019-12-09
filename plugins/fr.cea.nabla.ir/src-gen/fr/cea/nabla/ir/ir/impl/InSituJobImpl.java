/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.InSituJob;
import fr.cea.nabla.ir.ir.IrPackage;
import fr.cea.nabla.ir.ir.Variable;

import java.util.Collection;

import org.eclipse.emf.common.notify.Notification;
import org.eclipse.emf.common.util.EList;

import org.eclipse.emf.ecore.EClass;

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
 *   <li>{@link fr.cea.nabla.ir.ir.impl.InSituJobImpl#getVariables <em>Variables</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.InSituJobImpl#getIterationPeriod <em>Iteration Period</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.InSituJobImpl#getTimeStep <em>Time Step</em>}</li>
 * </ul>
 *
 * @generated
 */
public class InSituJobImpl extends JobImpl implements InSituJob {
	/**
	 * The cached value of the '{@link #getVariables() <em>Variables</em>}' reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getVariables()
	 * @generated
	 * @ordered
	 */
	protected EList<Variable> variables;

	/**
	 * The default value of the '{@link #getIterationPeriod() <em>Iteration Period</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getIterationPeriod()
	 * @generated
	 * @ordered
	 */
	protected static final int ITERATION_PERIOD_EDEFAULT = -1;
	/**
	 * The cached value of the '{@link #getIterationPeriod() <em>Iteration Period</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getIterationPeriod()
	 * @generated
	 * @ordered
	 */
	protected int iterationPeriod = ITERATION_PERIOD_EDEFAULT;
	/**
	 * The default value of the '{@link #getTimeStep() <em>Time Step</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getTimeStep()
	 * @generated
	 * @ordered
	 */
	protected static final double TIME_STEP_EDEFAULT = -1.0;
	/**
	 * The cached value of the '{@link #getTimeStep() <em>Time Step</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getTimeStep()
	 * @generated
	 * @ordered
	 */
	protected double timeStep = TIME_STEP_EDEFAULT;

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
	public EList<Variable> getVariables() {
		if (variables == null) {
			variables = new EObjectResolvingEList<Variable>(Variable.class, this, IrPackage.IN_SITU_JOB__VARIABLES);
		}
		return variables;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public int getIterationPeriod() {
		return iterationPeriod;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setIterationPeriod(int newIterationPeriod) {
		int oldIterationPeriod = iterationPeriod;
		iterationPeriod = newIterationPeriod;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.IN_SITU_JOB__ITERATION_PERIOD, oldIterationPeriod, iterationPeriod));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public double getTimeStep() {
		return timeStep;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setTimeStep(double newTimeStep) {
		double oldTimeStep = timeStep;
		timeStep = newTimeStep;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.IN_SITU_JOB__TIME_STEP, oldTimeStep, timeStep));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Object eGet(int featureID, boolean resolve, boolean coreType) {
		switch (featureID) {
			case IrPackage.IN_SITU_JOB__VARIABLES:
				return getVariables();
			case IrPackage.IN_SITU_JOB__ITERATION_PERIOD:
				return getIterationPeriod();
			case IrPackage.IN_SITU_JOB__TIME_STEP:
				return getTimeStep();
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
			case IrPackage.IN_SITU_JOB__VARIABLES:
				getVariables().clear();
				getVariables().addAll((Collection<? extends Variable>)newValue);
				return;
			case IrPackage.IN_SITU_JOB__ITERATION_PERIOD:
				setIterationPeriod((Integer)newValue);
				return;
			case IrPackage.IN_SITU_JOB__TIME_STEP:
				setTimeStep((Double)newValue);
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
			case IrPackage.IN_SITU_JOB__VARIABLES:
				getVariables().clear();
				return;
			case IrPackage.IN_SITU_JOB__ITERATION_PERIOD:
				setIterationPeriod(ITERATION_PERIOD_EDEFAULT);
				return;
			case IrPackage.IN_SITU_JOB__TIME_STEP:
				setTimeStep(TIME_STEP_EDEFAULT);
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
			case IrPackage.IN_SITU_JOB__VARIABLES:
				return variables != null && !variables.isEmpty();
			case IrPackage.IN_SITU_JOB__ITERATION_PERIOD:
				return iterationPeriod != ITERATION_PERIOD_EDEFAULT;
			case IrPackage.IN_SITU_JOB__TIME_STEP:
				return timeStep != TIME_STEP_EDEFAULT;
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
		result.append(" (iterationPeriod: ");
		result.append(iterationPeriod);
		result.append(", timeStep: ");
		result.append(timeStep);
		result.append(')');
		return result.toString();
	}

} //InSituJobImpl
