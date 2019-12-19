/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.BeginOfTimeLoopJob;
import fr.cea.nabla.ir.ir.EndOfTimeLoopJob;
import fr.cea.nabla.ir.ir.Expression;
import fr.cea.nabla.ir.ir.IrPackage;

import fr.cea.nabla.ir.ir.TimeLoopCopy;
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
 * An implementation of the model object '<em><b>End Of Time Loop Job</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.EndOfTimeLoopJobImpl#getBegin <em>Begin</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.EndOfTimeLoopJobImpl#getNextLoopCopies <em>Next Loop Copies</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.EndOfTimeLoopJobImpl#getExitLoopCopies <em>Exit Loop Copies</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.EndOfTimeLoopJobImpl#getWhileCondition <em>While Condition</em>}</li>
 * </ul>
 *
 * @generated
 */
public class EndOfTimeLoopJobImpl extends JobImpl implements EndOfTimeLoopJob {
	/**
	 * The cached value of the '{@link #getBegin() <em>Begin</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getBegin()
	 * @generated
	 * @ordered
	 */
	protected BeginOfTimeLoopJob begin;

	/**
	 * The cached value of the '{@link #getNextLoopCopies() <em>Next Loop Copies</em>}' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getNextLoopCopies()
	 * @generated
	 * @ordered
	 */
	protected EList<TimeLoopCopy> nextLoopCopies;
	/**
	 * The cached value of the '{@link #getExitLoopCopies() <em>Exit Loop Copies</em>}' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getExitLoopCopies()
	 * @generated
	 * @ordered
	 */
	protected EList<TimeLoopCopy> exitLoopCopies;
	/**
	 * The cached value of the '{@link #getWhileCondition() <em>While Condition</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getWhileCondition()
	 * @generated
	 * @ordered
	 */
	protected Expression whileCondition;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected EndOfTimeLoopJobImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return IrPackage.Literals.END_OF_TIME_LOOP_JOB;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public BeginOfTimeLoopJob getBegin() {
		if (begin != null && begin.eIsProxy()) {
			InternalEObject oldBegin = (InternalEObject)begin;
			begin = (BeginOfTimeLoopJob)eResolveProxy(oldBegin);
			if (begin != oldBegin) {
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.END_OF_TIME_LOOP_JOB__BEGIN, oldBegin, begin));
			}
		}
		return begin;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public BeginOfTimeLoopJob basicGetBegin() {
		return begin;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetBegin(BeginOfTimeLoopJob newBegin, NotificationChain msgs) {
		BeginOfTimeLoopJob oldBegin = begin;
		begin = newBegin;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.END_OF_TIME_LOOP_JOB__BEGIN, oldBegin, newBegin);
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
	public void setBegin(BeginOfTimeLoopJob newBegin) {
		if (newBegin != begin) {
			NotificationChain msgs = null;
			if (begin != null)
				msgs = ((InternalEObject)begin).eInverseRemove(this, IrPackage.BEGIN_OF_TIME_LOOP_JOB__END, BeginOfTimeLoopJob.class, msgs);
			if (newBegin != null)
				msgs = ((InternalEObject)newBegin).eInverseAdd(this, IrPackage.BEGIN_OF_TIME_LOOP_JOB__END, BeginOfTimeLoopJob.class, msgs);
			msgs = basicSetBegin(newBegin, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.END_OF_TIME_LOOP_JOB__BEGIN, newBegin, newBegin));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public EList<TimeLoopCopy> getNextLoopCopies() {
		if (nextLoopCopies == null) {
			nextLoopCopies = new EObjectContainmentEList.Resolving<TimeLoopCopy>(TimeLoopCopy.class, this, IrPackage.END_OF_TIME_LOOP_JOB__NEXT_LOOP_COPIES);
		}
		return nextLoopCopies;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public EList<TimeLoopCopy> getExitLoopCopies() {
		if (exitLoopCopies == null) {
			exitLoopCopies = new EObjectContainmentEList.Resolving<TimeLoopCopy>(TimeLoopCopy.class, this, IrPackage.END_OF_TIME_LOOP_JOB__EXIT_LOOP_COPIES);
		}
		return exitLoopCopies;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Expression getWhileCondition() {
		if (whileCondition != null && whileCondition.eIsProxy()) {
			InternalEObject oldWhileCondition = (InternalEObject)whileCondition;
			whileCondition = (Expression)eResolveProxy(oldWhileCondition);
			if (whileCondition != oldWhileCondition) {
				InternalEObject newWhileCondition = (InternalEObject)whileCondition;
				NotificationChain msgs = oldWhileCondition.eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.END_OF_TIME_LOOP_JOB__WHILE_CONDITION, null, null);
				if (newWhileCondition.eInternalContainer() == null) {
					msgs = newWhileCondition.eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.END_OF_TIME_LOOP_JOB__WHILE_CONDITION, null, msgs);
				}
				if (msgs != null) msgs.dispatch();
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.END_OF_TIME_LOOP_JOB__WHILE_CONDITION, oldWhileCondition, whileCondition));
			}
		}
		return whileCondition;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Expression basicGetWhileCondition() {
		return whileCondition;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetWhileCondition(Expression newWhileCondition, NotificationChain msgs) {
		Expression oldWhileCondition = whileCondition;
		whileCondition = newWhileCondition;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.END_OF_TIME_LOOP_JOB__WHILE_CONDITION, oldWhileCondition, newWhileCondition);
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
	public void setWhileCondition(Expression newWhileCondition) {
		if (newWhileCondition != whileCondition) {
			NotificationChain msgs = null;
			if (whileCondition != null)
				msgs = ((InternalEObject)whileCondition).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.END_OF_TIME_LOOP_JOB__WHILE_CONDITION, null, msgs);
			if (newWhileCondition != null)
				msgs = ((InternalEObject)newWhileCondition).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.END_OF_TIME_LOOP_JOB__WHILE_CONDITION, null, msgs);
			msgs = basicSetWhileCondition(newWhileCondition, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.END_OF_TIME_LOOP_JOB__WHILE_CONDITION, newWhileCondition, newWhileCondition));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public NotificationChain eInverseAdd(InternalEObject otherEnd, int featureID, NotificationChain msgs) {
		switch (featureID) {
			case IrPackage.END_OF_TIME_LOOP_JOB__BEGIN:
				if (begin != null)
					msgs = ((InternalEObject)begin).eInverseRemove(this, IrPackage.BEGIN_OF_TIME_LOOP_JOB__END, BeginOfTimeLoopJob.class, msgs);
				return basicSetBegin((BeginOfTimeLoopJob)otherEnd, msgs);
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
			case IrPackage.END_OF_TIME_LOOP_JOB__BEGIN:
				return basicSetBegin(null, msgs);
			case IrPackage.END_OF_TIME_LOOP_JOB__NEXT_LOOP_COPIES:
				return ((InternalEList<?>)getNextLoopCopies()).basicRemove(otherEnd, msgs);
			case IrPackage.END_OF_TIME_LOOP_JOB__EXIT_LOOP_COPIES:
				return ((InternalEList<?>)getExitLoopCopies()).basicRemove(otherEnd, msgs);
			case IrPackage.END_OF_TIME_LOOP_JOB__WHILE_CONDITION:
				return basicSetWhileCondition(null, msgs);
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
			case IrPackage.END_OF_TIME_LOOP_JOB__BEGIN:
				if (resolve) return getBegin();
				return basicGetBegin();
			case IrPackage.END_OF_TIME_LOOP_JOB__NEXT_LOOP_COPIES:
				return getNextLoopCopies();
			case IrPackage.END_OF_TIME_LOOP_JOB__EXIT_LOOP_COPIES:
				return getExitLoopCopies();
			case IrPackage.END_OF_TIME_LOOP_JOB__WHILE_CONDITION:
				if (resolve) return getWhileCondition();
				return basicGetWhileCondition();
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
			case IrPackage.END_OF_TIME_LOOP_JOB__BEGIN:
				setBegin((BeginOfTimeLoopJob)newValue);
				return;
			case IrPackage.END_OF_TIME_LOOP_JOB__NEXT_LOOP_COPIES:
				getNextLoopCopies().clear();
				getNextLoopCopies().addAll((Collection<? extends TimeLoopCopy>)newValue);
				return;
			case IrPackage.END_OF_TIME_LOOP_JOB__EXIT_LOOP_COPIES:
				getExitLoopCopies().clear();
				getExitLoopCopies().addAll((Collection<? extends TimeLoopCopy>)newValue);
				return;
			case IrPackage.END_OF_TIME_LOOP_JOB__WHILE_CONDITION:
				setWhileCondition((Expression)newValue);
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
			case IrPackage.END_OF_TIME_LOOP_JOB__BEGIN:
				setBegin((BeginOfTimeLoopJob)null);
				return;
			case IrPackage.END_OF_TIME_LOOP_JOB__NEXT_LOOP_COPIES:
				getNextLoopCopies().clear();
				return;
			case IrPackage.END_OF_TIME_LOOP_JOB__EXIT_LOOP_COPIES:
				getExitLoopCopies().clear();
				return;
			case IrPackage.END_OF_TIME_LOOP_JOB__WHILE_CONDITION:
				setWhileCondition((Expression)null);
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
			case IrPackage.END_OF_TIME_LOOP_JOB__BEGIN:
				return begin != null;
			case IrPackage.END_OF_TIME_LOOP_JOB__NEXT_LOOP_COPIES:
				return nextLoopCopies != null && !nextLoopCopies.isEmpty();
			case IrPackage.END_OF_TIME_LOOP_JOB__EXIT_LOOP_COPIES:
				return exitLoopCopies != null && !exitLoopCopies.isEmpty();
			case IrPackage.END_OF_TIME_LOOP_JOB__WHILE_CONDITION:
				return whileCondition != null;
		}
		return super.eIsSet(featureID);
	}

} //EndOfTimeLoopJobImpl
