/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.ExecuteTimeLoopJob;
import fr.cea.nabla.ir.ir.IrPackage;
import fr.cea.nabla.ir.ir.TimeIterator;
import fr.cea.nabla.ir.ir.Variable;

import java.util.Collection;

import org.eclipse.emf.common.notify.Notification;
import org.eclipse.emf.common.notify.NotificationChain;

import org.eclipse.emf.common.util.EList;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;

import org.eclipse.emf.ecore.impl.ENotificationImpl;

import org.eclipse.emf.ecore.util.EObjectContainmentWithInverseEList;
import org.eclipse.emf.ecore.util.EObjectWithInverseResolvingEList;
import org.eclipse.emf.ecore.util.EcoreUtil;
import org.eclipse.emf.ecore.util.InternalEList;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Time Iterator</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.TimeIteratorImpl#getName <em>Name</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.TimeIteratorImpl#getInnerIterators <em>Inner Iterators</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.TimeIteratorImpl#getParentIterator <em>Parent Iterator</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.TimeIteratorImpl#getVariables <em>Variables</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.TimeIteratorImpl#getTimeLoopJob <em>Time Loop Job</em>}</li>
 * </ul>
 *
 * @generated
 */
public class TimeIteratorImpl extends IrAnnotableImpl implements TimeIterator {
	/**
	 * The default value of the '{@link #getName() <em>Name</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getName()
	 * @generated
	 * @ordered
	 */
	protected static final String NAME_EDEFAULT = null;

	/**
	 * The cached value of the '{@link #getName() <em>Name</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getName()
	 * @generated
	 * @ordered
	 */
	protected String name = NAME_EDEFAULT;

	/**
	 * The cached value of the '{@link #getInnerIterators() <em>Inner Iterators</em>}' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getInnerIterators()
	 * @generated
	 * @ordered
	 */
	protected EList<TimeIterator> innerIterators;

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
	 * The cached value of the '{@link #getTimeLoopJob() <em>Time Loop Job</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getTimeLoopJob()
	 * @generated
	 * @ordered
	 */
	protected ExecuteTimeLoopJob timeLoopJob;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected TimeIteratorImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return IrPackage.Literals.TIME_ITERATOR;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public String getName() {
		return name;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setName(String newName) {
		String oldName = name;
		name = newName;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.TIME_ITERATOR__NAME, oldName, name));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public EList<TimeIterator> getInnerIterators() {
		if (innerIterators == null) {
			innerIterators = new EObjectContainmentWithInverseEList.Resolving<TimeIterator>(TimeIterator.class, this, IrPackage.TIME_ITERATOR__INNER_ITERATORS, IrPackage.TIME_ITERATOR__PARENT_ITERATOR);
		}
		return innerIterators;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public TimeIterator getParentIterator() {
		if (eContainerFeatureID() != IrPackage.TIME_ITERATOR__PARENT_ITERATOR) return null;
		return (TimeIterator)eContainer();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public TimeIterator basicGetParentIterator() {
		if (eContainerFeatureID() != IrPackage.TIME_ITERATOR__PARENT_ITERATOR) return null;
		return (TimeIterator)eInternalContainer();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetParentIterator(TimeIterator newParentIterator, NotificationChain msgs) {
		msgs = eBasicSetContainer((InternalEObject)newParentIterator, IrPackage.TIME_ITERATOR__PARENT_ITERATOR, msgs);
		return msgs;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setParentIterator(TimeIterator newParentIterator) {
		if (newParentIterator != eInternalContainer() || (eContainerFeatureID() != IrPackage.TIME_ITERATOR__PARENT_ITERATOR && newParentIterator != null)) {
			if (EcoreUtil.isAncestor(this, newParentIterator))
				throw new IllegalArgumentException("Recursive containment not allowed for " + toString());
			NotificationChain msgs = null;
			if (eInternalContainer() != null)
				msgs = eBasicRemoveFromContainer(msgs);
			if (newParentIterator != null)
				msgs = ((InternalEObject)newParentIterator).eInverseAdd(this, IrPackage.TIME_ITERATOR__INNER_ITERATORS, TimeIterator.class, msgs);
			msgs = basicSetParentIterator(newParentIterator, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.TIME_ITERATOR__PARENT_ITERATOR, newParentIterator, newParentIterator));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public EList<Variable> getVariables() {
		if (variables == null) {
			variables = new EObjectWithInverseResolvingEList<Variable>(Variable.class, this, IrPackage.TIME_ITERATOR__VARIABLES, IrPackage.VARIABLE__TIME_ITERATOR);
		}
		return variables;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public ExecuteTimeLoopJob getTimeLoopJob() {
		if (timeLoopJob != null && timeLoopJob.eIsProxy()) {
			InternalEObject oldTimeLoopJob = (InternalEObject)timeLoopJob;
			timeLoopJob = (ExecuteTimeLoopJob)eResolveProxy(oldTimeLoopJob);
			if (timeLoopJob != oldTimeLoopJob) {
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.TIME_ITERATOR__TIME_LOOP_JOB, oldTimeLoopJob, timeLoopJob));
			}
		}
		return timeLoopJob;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public ExecuteTimeLoopJob basicGetTimeLoopJob() {
		return timeLoopJob;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetTimeLoopJob(ExecuteTimeLoopJob newTimeLoopJob, NotificationChain msgs) {
		ExecuteTimeLoopJob oldTimeLoopJob = timeLoopJob;
		timeLoopJob = newTimeLoopJob;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.TIME_ITERATOR__TIME_LOOP_JOB, oldTimeLoopJob, newTimeLoopJob);
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
	public void setTimeLoopJob(ExecuteTimeLoopJob newTimeLoopJob) {
		if (newTimeLoopJob != timeLoopJob) {
			NotificationChain msgs = null;
			if (timeLoopJob != null)
				msgs = ((InternalEObject)timeLoopJob).eInverseRemove(this, IrPackage.EXECUTE_TIME_LOOP_JOB__TIME_ITERATOR, ExecuteTimeLoopJob.class, msgs);
			if (newTimeLoopJob != null)
				msgs = ((InternalEObject)newTimeLoopJob).eInverseAdd(this, IrPackage.EXECUTE_TIME_LOOP_JOB__TIME_ITERATOR, ExecuteTimeLoopJob.class, msgs);
			msgs = basicSetTimeLoopJob(newTimeLoopJob, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.TIME_ITERATOR__TIME_LOOP_JOB, newTimeLoopJob, newTimeLoopJob));
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
			case IrPackage.TIME_ITERATOR__INNER_ITERATORS:
				return ((InternalEList<InternalEObject>)(InternalEList<?>)getInnerIterators()).basicAdd(otherEnd, msgs);
			case IrPackage.TIME_ITERATOR__PARENT_ITERATOR:
				if (eInternalContainer() != null)
					msgs = eBasicRemoveFromContainer(msgs);
				return basicSetParentIterator((TimeIterator)otherEnd, msgs);
			case IrPackage.TIME_ITERATOR__VARIABLES:
				return ((InternalEList<InternalEObject>)(InternalEList<?>)getVariables()).basicAdd(otherEnd, msgs);
			case IrPackage.TIME_ITERATOR__TIME_LOOP_JOB:
				if (timeLoopJob != null)
					msgs = ((InternalEObject)timeLoopJob).eInverseRemove(this, IrPackage.EXECUTE_TIME_LOOP_JOB__TIME_ITERATOR, ExecuteTimeLoopJob.class, msgs);
				return basicSetTimeLoopJob((ExecuteTimeLoopJob)otherEnd, msgs);
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
			case IrPackage.TIME_ITERATOR__INNER_ITERATORS:
				return ((InternalEList<?>)getInnerIterators()).basicRemove(otherEnd, msgs);
			case IrPackage.TIME_ITERATOR__PARENT_ITERATOR:
				return basicSetParentIterator(null, msgs);
			case IrPackage.TIME_ITERATOR__VARIABLES:
				return ((InternalEList<?>)getVariables()).basicRemove(otherEnd, msgs);
			case IrPackage.TIME_ITERATOR__TIME_LOOP_JOB:
				return basicSetTimeLoopJob(null, msgs);
		}
		return super.eInverseRemove(otherEnd, featureID, msgs);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public NotificationChain eBasicRemoveFromContainerFeature(NotificationChain msgs) {
		switch (eContainerFeatureID()) {
			case IrPackage.TIME_ITERATOR__PARENT_ITERATOR:
				return eInternalContainer().eInverseRemove(this, IrPackage.TIME_ITERATOR__INNER_ITERATORS, TimeIterator.class, msgs);
		}
		return super.eBasicRemoveFromContainerFeature(msgs);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Object eGet(int featureID, boolean resolve, boolean coreType) {
		switch (featureID) {
			case IrPackage.TIME_ITERATOR__NAME:
				return getName();
			case IrPackage.TIME_ITERATOR__INNER_ITERATORS:
				return getInnerIterators();
			case IrPackage.TIME_ITERATOR__PARENT_ITERATOR:
				if (resolve) return getParentIterator();
				return basicGetParentIterator();
			case IrPackage.TIME_ITERATOR__VARIABLES:
				return getVariables();
			case IrPackage.TIME_ITERATOR__TIME_LOOP_JOB:
				if (resolve) return getTimeLoopJob();
				return basicGetTimeLoopJob();
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
			case IrPackage.TIME_ITERATOR__NAME:
				setName((String)newValue);
				return;
			case IrPackage.TIME_ITERATOR__INNER_ITERATORS:
				getInnerIterators().clear();
				getInnerIterators().addAll((Collection<? extends TimeIterator>)newValue);
				return;
			case IrPackage.TIME_ITERATOR__PARENT_ITERATOR:
				setParentIterator((TimeIterator)newValue);
				return;
			case IrPackage.TIME_ITERATOR__VARIABLES:
				getVariables().clear();
				getVariables().addAll((Collection<? extends Variable>)newValue);
				return;
			case IrPackage.TIME_ITERATOR__TIME_LOOP_JOB:
				setTimeLoopJob((ExecuteTimeLoopJob)newValue);
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
			case IrPackage.TIME_ITERATOR__NAME:
				setName(NAME_EDEFAULT);
				return;
			case IrPackage.TIME_ITERATOR__INNER_ITERATORS:
				getInnerIterators().clear();
				return;
			case IrPackage.TIME_ITERATOR__PARENT_ITERATOR:
				setParentIterator((TimeIterator)null);
				return;
			case IrPackage.TIME_ITERATOR__VARIABLES:
				getVariables().clear();
				return;
			case IrPackage.TIME_ITERATOR__TIME_LOOP_JOB:
				setTimeLoopJob((ExecuteTimeLoopJob)null);
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
			case IrPackage.TIME_ITERATOR__NAME:
				return NAME_EDEFAULT == null ? name != null : !NAME_EDEFAULT.equals(name);
			case IrPackage.TIME_ITERATOR__INNER_ITERATORS:
				return innerIterators != null && !innerIterators.isEmpty();
			case IrPackage.TIME_ITERATOR__PARENT_ITERATOR:
				return basicGetParentIterator() != null;
			case IrPackage.TIME_ITERATOR__VARIABLES:
				return variables != null && !variables.isEmpty();
			case IrPackage.TIME_ITERATOR__TIME_LOOP_JOB:
				return timeLoopJob != null;
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
		result.append(" (name: ");
		result.append(name);
		result.append(')');
		return result.toString();
	}

} //TimeIteratorImpl
