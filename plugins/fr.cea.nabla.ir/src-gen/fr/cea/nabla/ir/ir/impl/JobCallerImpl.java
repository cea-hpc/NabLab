/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.IrPackage;
import fr.cea.nabla.ir.ir.Job;
import fr.cea.nabla.ir.ir.JobCaller;

import fr.cea.nabla.ir.ir.Variable;
import java.util.Collection;

import org.eclipse.emf.common.notify.NotificationChain;

import org.eclipse.emf.common.util.EList;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;

import org.eclipse.emf.ecore.util.EObjectResolvingEList;
import org.eclipse.emf.ecore.util.EObjectWithInverseResolvingEList;
import org.eclipse.emf.ecore.util.InternalEList;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Job Caller</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.JobCallerImpl#getCalls <em>Calls</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.JobCallerImpl#getAllInVars <em>All In Vars</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.JobCallerImpl#getAllOutVars <em>All Out Vars</em>}</li>
 * </ul>
 *
 * @generated
 */
public class JobCallerImpl extends IrAnnotableImpl implements JobCaller {
	/**
	 * The cached value of the '{@link #getCalls() <em>Calls</em>}' reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getCalls()
	 * @generated
	 * @ordered
	 */
	protected EList<Job> calls;

	/**
	 * The cached value of the '{@link #getAllInVars() <em>All In Vars</em>}' reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getAllInVars()
	 * @generated
	 * @ordered
	 */
	protected EList<Variable> allInVars;
	/**
	 * The cached value of the '{@link #getAllOutVars() <em>All Out Vars</em>}' reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getAllOutVars()
	 * @generated
	 * @ordered
	 */
	protected EList<Variable> allOutVars;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected JobCallerImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return IrPackage.Literals.JOB_CALLER;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public EList<Job> getCalls() {
		if (calls == null) {
			calls = new EObjectWithInverseResolvingEList<Job>(Job.class, this, IrPackage.JOB_CALLER__CALLS, IrPackage.JOB__CALLER);
		}
		return calls;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public EList<Variable> getAllInVars() {
		if (allInVars == null) {
			allInVars = new EObjectResolvingEList<Variable>(Variable.class, this, IrPackage.JOB_CALLER__ALL_IN_VARS);
		}
		return allInVars;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public EList<Variable> getAllOutVars() {
		if (allOutVars == null) {
			allOutVars = new EObjectResolvingEList<Variable>(Variable.class, this, IrPackage.JOB_CALLER__ALL_OUT_VARS);
		}
		return allOutVars;
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
			case IrPackage.JOB_CALLER__CALLS:
				return ((InternalEList<InternalEObject>)(InternalEList<?>)getCalls()).basicAdd(otherEnd, msgs);
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
			case IrPackage.JOB_CALLER__CALLS:
				return ((InternalEList<?>)getCalls()).basicRemove(otherEnd, msgs);
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
			case IrPackage.JOB_CALLER__CALLS:
				return getCalls();
			case IrPackage.JOB_CALLER__ALL_IN_VARS:
				return getAllInVars();
			case IrPackage.JOB_CALLER__ALL_OUT_VARS:
				return getAllOutVars();
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
			case IrPackage.JOB_CALLER__CALLS:
				getCalls().clear();
				getCalls().addAll((Collection<? extends Job>)newValue);
				return;
			case IrPackage.JOB_CALLER__ALL_IN_VARS:
				getAllInVars().clear();
				getAllInVars().addAll((Collection<? extends Variable>)newValue);
				return;
			case IrPackage.JOB_CALLER__ALL_OUT_VARS:
				getAllOutVars().clear();
				getAllOutVars().addAll((Collection<? extends Variable>)newValue);
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
			case IrPackage.JOB_CALLER__CALLS:
				getCalls().clear();
				return;
			case IrPackage.JOB_CALLER__ALL_IN_VARS:
				getAllInVars().clear();
				return;
			case IrPackage.JOB_CALLER__ALL_OUT_VARS:
				getAllOutVars().clear();
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
			case IrPackage.JOB_CALLER__CALLS:
				return calls != null && !calls.isEmpty();
			case IrPackage.JOB_CALLER__ALL_IN_VARS:
				return allInVars != null && !allInVars.isEmpty();
			case IrPackage.JOB_CALLER__ALL_OUT_VARS:
				return allOutVars != null && !allOutVars.isEmpty();
		}
		return super.eIsSet(featureID);
	}

} //JobCallerImpl
