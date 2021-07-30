/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.Expression;
import fr.cea.nabla.ir.ir.IrPackage;
import fr.cea.nabla.ir.ir.Job;
import fr.cea.nabla.ir.ir.TimeIterator;
import fr.cea.nabla.ir.ir.Variable;
import java.util.Collection;
import org.eclipse.emf.common.notify.Notification;
import org.eclipse.emf.common.notify.NotificationChain;
import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;
import org.eclipse.emf.ecore.impl.ENotificationImpl;
import org.eclipse.emf.ecore.util.EObjectWithInverseResolvingEList;
import org.eclipse.emf.ecore.util.InternalEList;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Variable</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.VariableImpl#getDefaultValue <em>Default Value</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.VariableImpl#isConst <em>Const</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.VariableImpl#isConstExpr <em>Const Expr</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.VariableImpl#isOption <em>Option</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.VariableImpl#getPreviousJobs <em>Previous Jobs</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.VariableImpl#getNextJobs <em>Next Jobs</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.VariableImpl#getOriginName <em>Origin Name</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.VariableImpl#getTimeIterator <em>Time Iterator</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.VariableImpl#getTimeIteratorIndex <em>Time Iterator Index</em>}</li>
 * </ul>
 *
 * @generated
 */
public class VariableImpl extends ArgOrVarImpl implements Variable {
	/**
	 * The cached value of the '{@link #getDefaultValue() <em>Default Value</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getDefaultValue()
	 * @generated
	 * @ordered
	 */
	protected Expression defaultValue;
	/**
	 * The default value of the '{@link #isConst() <em>Const</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #isConst()
	 * @generated
	 * @ordered
	 */
	protected static final boolean CONST_EDEFAULT = false;
	/**
	 * The cached value of the '{@link #isConst() <em>Const</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #isConst()
	 * @generated
	 * @ordered
	 */
	protected boolean const_ = CONST_EDEFAULT;
	/**
	 * The default value of the '{@link #isConstExpr() <em>Const Expr</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #isConstExpr()
	 * @generated
	 * @ordered
	 */
	protected static final boolean CONST_EXPR_EDEFAULT = false;
	/**
	 * The cached value of the '{@link #isConstExpr() <em>Const Expr</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #isConstExpr()
	 * @generated
	 * @ordered
	 */
	protected boolean constExpr = CONST_EXPR_EDEFAULT;
	/**
	 * The default value of the '{@link #isOption() <em>Option</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #isOption()
	 * @generated
	 * @ordered
	 */
	protected static final boolean OPTION_EDEFAULT = false;
	/**
	 * The cached value of the '{@link #isOption() <em>Option</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #isOption()
	 * @generated
	 * @ordered
	 */
	protected boolean option = OPTION_EDEFAULT;

	/**
	 * The cached value of the '{@link #getPreviousJobs() <em>Previous Jobs</em>}' reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getPreviousJobs()
	 * @generated
	 * @ordered
	 */
	protected EList<Job> previousJobs;
	/**
	 * The cached value of the '{@link #getNextJobs() <em>Next Jobs</em>}' reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getNextJobs()
	 * @generated
	 * @ordered
	 */
	protected EList<Job> nextJobs;

	/**
	 * The default value of the '{@link #getOriginName() <em>Origin Name</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getOriginName()
	 * @generated
	 * @ordered
	 */
	protected static final String ORIGIN_NAME_EDEFAULT = null;
	/**
	 * The cached value of the '{@link #getOriginName() <em>Origin Name</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getOriginName()
	 * @generated
	 * @ordered
	 */
	protected String originName = ORIGIN_NAME_EDEFAULT;
	/**
	 * The cached value of the '{@link #getTimeIterator() <em>Time Iterator</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getTimeIterator()
	 * @generated
	 * @ordered
	 */
	protected TimeIterator timeIterator;

	/**
	 * The default value of the '{@link #getTimeIteratorIndex() <em>Time Iterator Index</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getTimeIteratorIndex()
	 * @generated
	 * @ordered
	 */
	protected static final int TIME_ITERATOR_INDEX_EDEFAULT = 0;
	/**
	 * The cached value of the '{@link #getTimeIteratorIndex() <em>Time Iterator Index</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getTimeIteratorIndex()
	 * @generated
	 * @ordered
	 */
	protected int timeIteratorIndex = TIME_ITERATOR_INDEX_EDEFAULT;
	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected VariableImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return IrPackage.Literals.VARIABLE;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Expression getDefaultValue() {
		return defaultValue;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetDefaultValue(Expression newDefaultValue, NotificationChain msgs) {
		Expression oldDefaultValue = defaultValue;
		defaultValue = newDefaultValue;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.VARIABLE__DEFAULT_VALUE, oldDefaultValue, newDefaultValue);
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
	public void setDefaultValue(Expression newDefaultValue) {
		if (newDefaultValue != defaultValue) {
			NotificationChain msgs = null;
			if (defaultValue != null)
				msgs = ((InternalEObject)defaultValue).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.VARIABLE__DEFAULT_VALUE, null, msgs);
			if (newDefaultValue != null)
				msgs = ((InternalEObject)newDefaultValue).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.VARIABLE__DEFAULT_VALUE, null, msgs);
			msgs = basicSetDefaultValue(newDefaultValue, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.VARIABLE__DEFAULT_VALUE, newDefaultValue, newDefaultValue));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public boolean isConst() {
		return const_;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setConst(boolean newConst) {
		boolean oldConst = const_;
		const_ = newConst;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.VARIABLE__CONST, oldConst, const_));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public boolean isConstExpr() {
		return constExpr;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setConstExpr(boolean newConstExpr) {
		boolean oldConstExpr = constExpr;
		constExpr = newConstExpr;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.VARIABLE__CONST_EXPR, oldConstExpr, constExpr));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public boolean isOption() {
		return option;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setOption(boolean newOption) {
		boolean oldOption = option;
		option = newOption;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.VARIABLE__OPTION, oldOption, option));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public EList<Job> getPreviousJobs() {
		if (previousJobs == null) {
			previousJobs = new EObjectWithInverseResolvingEList.ManyInverse<Job>(Job.class, this, IrPackage.VARIABLE__PREVIOUS_JOBS, IrPackage.JOB__OUT_VARS);
		}
		return previousJobs;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public EList<Job> getNextJobs() {
		if (nextJobs == null) {
			nextJobs = new EObjectWithInverseResolvingEList.ManyInverse<Job>(Job.class, this, IrPackage.VARIABLE__NEXT_JOBS, IrPackage.JOB__IN_VARS);
		}
		return nextJobs;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public String getOriginName() {
		return originName;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setOriginName(String newOriginName) {
		String oldOriginName = originName;
		originName = newOriginName;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.VARIABLE__ORIGIN_NAME, oldOriginName, originName));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public TimeIterator getTimeIterator() {
		if (timeIterator != null && timeIterator.eIsProxy()) {
			InternalEObject oldTimeIterator = (InternalEObject)timeIterator;
			timeIterator = (TimeIterator)eResolveProxy(oldTimeIterator);
			if (timeIterator != oldTimeIterator) {
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.VARIABLE__TIME_ITERATOR, oldTimeIterator, timeIterator));
			}
		}
		return timeIterator;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public TimeIterator basicGetTimeIterator() {
		return timeIterator;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetTimeIterator(TimeIterator newTimeIterator, NotificationChain msgs) {
		TimeIterator oldTimeIterator = timeIterator;
		timeIterator = newTimeIterator;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.VARIABLE__TIME_ITERATOR, oldTimeIterator, newTimeIterator);
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
	public void setTimeIterator(TimeIterator newTimeIterator) {
		if (newTimeIterator != timeIterator) {
			NotificationChain msgs = null;
			if (timeIterator != null)
				msgs = ((InternalEObject)timeIterator).eInverseRemove(this, IrPackage.TIME_ITERATOR__VARIABLES, TimeIterator.class, msgs);
			if (newTimeIterator != null)
				msgs = ((InternalEObject)newTimeIterator).eInverseAdd(this, IrPackage.TIME_ITERATOR__VARIABLES, TimeIterator.class, msgs);
			msgs = basicSetTimeIterator(newTimeIterator, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.VARIABLE__TIME_ITERATOR, newTimeIterator, newTimeIterator));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public int getTimeIteratorIndex() {
		return timeIteratorIndex;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setTimeIteratorIndex(int newTimeIteratorIndex) {
		int oldTimeIteratorIndex = timeIteratorIndex;
		timeIteratorIndex = newTimeIteratorIndex;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.VARIABLE__TIME_ITERATOR_INDEX, oldTimeIteratorIndex, timeIteratorIndex));
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
			case IrPackage.VARIABLE__PREVIOUS_JOBS:
				return ((InternalEList<InternalEObject>)(InternalEList<?>)getPreviousJobs()).basicAdd(otherEnd, msgs);
			case IrPackage.VARIABLE__NEXT_JOBS:
				return ((InternalEList<InternalEObject>)(InternalEList<?>)getNextJobs()).basicAdd(otherEnd, msgs);
			case IrPackage.VARIABLE__TIME_ITERATOR:
				if (timeIterator != null)
					msgs = ((InternalEObject)timeIterator).eInverseRemove(this, IrPackage.TIME_ITERATOR__VARIABLES, TimeIterator.class, msgs);
				return basicSetTimeIterator((TimeIterator)otherEnd, msgs);
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
			case IrPackage.VARIABLE__DEFAULT_VALUE:
				return basicSetDefaultValue(null, msgs);
			case IrPackage.VARIABLE__PREVIOUS_JOBS:
				return ((InternalEList<?>)getPreviousJobs()).basicRemove(otherEnd, msgs);
			case IrPackage.VARIABLE__NEXT_JOBS:
				return ((InternalEList<?>)getNextJobs()).basicRemove(otherEnd, msgs);
			case IrPackage.VARIABLE__TIME_ITERATOR:
				return basicSetTimeIterator(null, msgs);
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
			case IrPackage.VARIABLE__DEFAULT_VALUE:
				return getDefaultValue();
			case IrPackage.VARIABLE__CONST:
				return isConst();
			case IrPackage.VARIABLE__CONST_EXPR:
				return isConstExpr();
			case IrPackage.VARIABLE__OPTION:
				return isOption();
			case IrPackage.VARIABLE__PREVIOUS_JOBS:
				return getPreviousJobs();
			case IrPackage.VARIABLE__NEXT_JOBS:
				return getNextJobs();
			case IrPackage.VARIABLE__ORIGIN_NAME:
				return getOriginName();
			case IrPackage.VARIABLE__TIME_ITERATOR:
				if (resolve) return getTimeIterator();
				return basicGetTimeIterator();
			case IrPackage.VARIABLE__TIME_ITERATOR_INDEX:
				return getTimeIteratorIndex();
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
			case IrPackage.VARIABLE__DEFAULT_VALUE:
				setDefaultValue((Expression)newValue);
				return;
			case IrPackage.VARIABLE__CONST:
				setConst((Boolean)newValue);
				return;
			case IrPackage.VARIABLE__CONST_EXPR:
				setConstExpr((Boolean)newValue);
				return;
			case IrPackage.VARIABLE__OPTION:
				setOption((Boolean)newValue);
				return;
			case IrPackage.VARIABLE__PREVIOUS_JOBS:
				getPreviousJobs().clear();
				getPreviousJobs().addAll((Collection<? extends Job>)newValue);
				return;
			case IrPackage.VARIABLE__NEXT_JOBS:
				getNextJobs().clear();
				getNextJobs().addAll((Collection<? extends Job>)newValue);
				return;
			case IrPackage.VARIABLE__ORIGIN_NAME:
				setOriginName((String)newValue);
				return;
			case IrPackage.VARIABLE__TIME_ITERATOR:
				setTimeIterator((TimeIterator)newValue);
				return;
			case IrPackage.VARIABLE__TIME_ITERATOR_INDEX:
				setTimeIteratorIndex((Integer)newValue);
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
			case IrPackage.VARIABLE__DEFAULT_VALUE:
				setDefaultValue((Expression)null);
				return;
			case IrPackage.VARIABLE__CONST:
				setConst(CONST_EDEFAULT);
				return;
			case IrPackage.VARIABLE__CONST_EXPR:
				setConstExpr(CONST_EXPR_EDEFAULT);
				return;
			case IrPackage.VARIABLE__OPTION:
				setOption(OPTION_EDEFAULT);
				return;
			case IrPackage.VARIABLE__PREVIOUS_JOBS:
				getPreviousJobs().clear();
				return;
			case IrPackage.VARIABLE__NEXT_JOBS:
				getNextJobs().clear();
				return;
			case IrPackage.VARIABLE__ORIGIN_NAME:
				setOriginName(ORIGIN_NAME_EDEFAULT);
				return;
			case IrPackage.VARIABLE__TIME_ITERATOR:
				setTimeIterator((TimeIterator)null);
				return;
			case IrPackage.VARIABLE__TIME_ITERATOR_INDEX:
				setTimeIteratorIndex(TIME_ITERATOR_INDEX_EDEFAULT);
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
			case IrPackage.VARIABLE__DEFAULT_VALUE:
				return defaultValue != null;
			case IrPackage.VARIABLE__CONST:
				return const_ != CONST_EDEFAULT;
			case IrPackage.VARIABLE__CONST_EXPR:
				return constExpr != CONST_EXPR_EDEFAULT;
			case IrPackage.VARIABLE__OPTION:
				return option != OPTION_EDEFAULT;
			case IrPackage.VARIABLE__PREVIOUS_JOBS:
				return previousJobs != null && !previousJobs.isEmpty();
			case IrPackage.VARIABLE__NEXT_JOBS:
				return nextJobs != null && !nextJobs.isEmpty();
			case IrPackage.VARIABLE__ORIGIN_NAME:
				return ORIGIN_NAME_EDEFAULT == null ? originName != null : !ORIGIN_NAME_EDEFAULT.equals(originName);
			case IrPackage.VARIABLE__TIME_ITERATOR:
				return timeIterator != null;
			case IrPackage.VARIABLE__TIME_ITERATOR_INDEX:
				return timeIteratorIndex != TIME_ITERATOR_INDEX_EDEFAULT;
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
		result.append(" (const: ");
		result.append(const_);
		result.append(", constExpr: ");
		result.append(constExpr);
		result.append(", option: ");
		result.append(option);
		result.append(", originName: ");
		result.append(originName);
		result.append(", timeIteratorIndex: ");
		result.append(timeIteratorIndex);
		result.append(')');
		return result.toString();
	}

} //VariableImpl
