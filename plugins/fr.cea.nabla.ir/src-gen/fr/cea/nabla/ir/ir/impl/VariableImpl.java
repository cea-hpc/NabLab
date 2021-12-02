/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.Expression;
import fr.cea.nabla.ir.ir.IrPackage;
import fr.cea.nabla.ir.ir.Job;
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
 *   <li>{@link fr.cea.nabla.ir.ir.impl.VariableImpl#getProducerJobs <em>Producer Jobs</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.VariableImpl#getConsumerJobs <em>Consumer Jobs</em>}</li>
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
	 * The cached value of the '{@link #getProducerJobs() <em>Producer Jobs</em>}' reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getProducerJobs()
	 * @generated
	 * @ordered
	 */
	protected EList<Job> producerJobs;
	/**
	 * The cached value of the '{@link #getConsumerJobs() <em>Consumer Jobs</em>}' reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getConsumerJobs()
	 * @generated
	 * @ordered
	 */
	protected EList<Job> consumerJobs;
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
	public EList<Job> getProducerJobs() {
		if (producerJobs == null) {
			producerJobs = new EObjectWithInverseResolvingEList.ManyInverse<Job>(Job.class, this, IrPackage.VARIABLE__PRODUCER_JOBS, IrPackage.JOB__OUT_VARS);
		}
		return producerJobs;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public EList<Job> getConsumerJobs() {
		if (consumerJobs == null) {
			consumerJobs = new EObjectWithInverseResolvingEList.ManyInverse<Job>(Job.class, this, IrPackage.VARIABLE__CONSUMER_JOBS, IrPackage.JOB__IN_VARS);
		}
		return consumerJobs;
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
			case IrPackage.VARIABLE__PRODUCER_JOBS:
				return ((InternalEList<InternalEObject>)(InternalEList<?>)getProducerJobs()).basicAdd(otherEnd, msgs);
			case IrPackage.VARIABLE__CONSUMER_JOBS:
				return ((InternalEList<InternalEObject>)(InternalEList<?>)getConsumerJobs()).basicAdd(otherEnd, msgs);
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
			case IrPackage.VARIABLE__PRODUCER_JOBS:
				return ((InternalEList<?>)getProducerJobs()).basicRemove(otherEnd, msgs);
			case IrPackage.VARIABLE__CONSUMER_JOBS:
				return ((InternalEList<?>)getConsumerJobs()).basicRemove(otherEnd, msgs);
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
			case IrPackage.VARIABLE__PRODUCER_JOBS:
				return getProducerJobs();
			case IrPackage.VARIABLE__CONSUMER_JOBS:
				return getConsumerJobs();
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
			case IrPackage.VARIABLE__PRODUCER_JOBS:
				getProducerJobs().clear();
				getProducerJobs().addAll((Collection<? extends Job>)newValue);
				return;
			case IrPackage.VARIABLE__CONSUMER_JOBS:
				getConsumerJobs().clear();
				getConsumerJobs().addAll((Collection<? extends Job>)newValue);
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
			case IrPackage.VARIABLE__PRODUCER_JOBS:
				getProducerJobs().clear();
				return;
			case IrPackage.VARIABLE__CONSUMER_JOBS:
				getConsumerJobs().clear();
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
			case IrPackage.VARIABLE__PRODUCER_JOBS:
				return producerJobs != null && !producerJobs.isEmpty();
			case IrPackage.VARIABLE__CONSUMER_JOBS:
				return consumerJobs != null && !consumerJobs.isEmpty();
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
		result.append(')');
		return result.toString();
	}

} //VariableImpl
