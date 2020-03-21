/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.Arg;
import fr.cea.nabla.ir.ir.BaseType;
import fr.cea.nabla.ir.ir.Function;
import fr.cea.nabla.ir.ir.Instruction;
import fr.cea.nabla.ir.ir.IrPackage;
import fr.cea.nabla.ir.ir.SizeTypeSymbol;

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
 * An implementation of the model object '<em><b>Function</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.FunctionImpl#getReturnType <em>Return Type</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.FunctionImpl#getProvider <em>Provider</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.FunctionImpl#getVariables <em>Variables</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.FunctionImpl#getName <em>Name</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.FunctionImpl#getInArgs <em>In Args</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.FunctionImpl#getBody <em>Body</em>}</li>
 * </ul>
 *
 * @generated
 */
public class FunctionImpl extends IrAnnotableImpl implements Function {
	/**
	 * The cached value of the '{@link #getReturnType() <em>Return Type</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getReturnType()
	 * @generated
	 * @ordered
	 */
	protected BaseType returnType;

	/**
	 * The default value of the '{@link #getProvider() <em>Provider</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getProvider()
	 * @generated
	 * @ordered
	 */
	protected static final String PROVIDER_EDEFAULT = null;

	/**
	 * The cached value of the '{@link #getProvider() <em>Provider</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getProvider()
	 * @generated
	 * @ordered
	 */
	protected String provider = PROVIDER_EDEFAULT;

	/**
	 * The cached value of the '{@link #getVariables() <em>Variables</em>}' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getVariables()
	 * @generated
	 * @ordered
	 */
	protected EList<SizeTypeSymbol> variables;

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
	 * The cached value of the '{@link #getInArgs() <em>In Args</em>}' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getInArgs()
	 * @generated
	 * @ordered
	 */
	protected EList<Arg> inArgs;

	/**
	 * The cached value of the '{@link #getBody() <em>Body</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getBody()
	 * @generated
	 * @ordered
	 */
	protected Instruction body;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected FunctionImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return IrPackage.Literals.FUNCTION;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public BaseType getReturnType() {
		if (returnType != null && returnType.eIsProxy()) {
			InternalEObject oldReturnType = (InternalEObject)returnType;
			returnType = (BaseType)eResolveProxy(oldReturnType);
			if (returnType != oldReturnType) {
				InternalEObject newReturnType = (InternalEObject)returnType;
				NotificationChain msgs = oldReturnType.eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.FUNCTION__RETURN_TYPE, null, null);
				if (newReturnType.eInternalContainer() == null) {
					msgs = newReturnType.eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.FUNCTION__RETURN_TYPE, null, msgs);
				}
				if (msgs != null) msgs.dispatch();
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.FUNCTION__RETURN_TYPE, oldReturnType, returnType));
			}
		}
		return returnType;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public BaseType basicGetReturnType() {
		return returnType;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetReturnType(BaseType newReturnType, NotificationChain msgs) {
		BaseType oldReturnType = returnType;
		returnType = newReturnType;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.FUNCTION__RETURN_TYPE, oldReturnType, newReturnType);
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
	public void setReturnType(BaseType newReturnType) {
		if (newReturnType != returnType) {
			NotificationChain msgs = null;
			if (returnType != null)
				msgs = ((InternalEObject)returnType).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.FUNCTION__RETURN_TYPE, null, msgs);
			if (newReturnType != null)
				msgs = ((InternalEObject)newReturnType).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.FUNCTION__RETURN_TYPE, null, msgs);
			msgs = basicSetReturnType(newReturnType, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.FUNCTION__RETURN_TYPE, newReturnType, newReturnType));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public String getProvider() {
		return provider;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setProvider(String newProvider) {
		String oldProvider = provider;
		provider = newProvider;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.FUNCTION__PROVIDER, oldProvider, provider));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public EList<SizeTypeSymbol> getVariables() {
		if (variables == null) {
			variables = new EObjectContainmentEList.Resolving<SizeTypeSymbol>(SizeTypeSymbol.class, this, IrPackage.FUNCTION__VARIABLES);
		}
		return variables;
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
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.FUNCTION__NAME, oldName, name));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public EList<Arg> getInArgs() {
		if (inArgs == null) {
			inArgs = new EObjectContainmentEList.Resolving<Arg>(Arg.class, this, IrPackage.FUNCTION__IN_ARGS);
		}
		return inArgs;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Instruction getBody() {
		if (body != null && body.eIsProxy()) {
			InternalEObject oldBody = (InternalEObject)body;
			body = (Instruction)eResolveProxy(oldBody);
			if (body != oldBody) {
				InternalEObject newBody = (InternalEObject)body;
				NotificationChain msgs = oldBody.eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.FUNCTION__BODY, null, null);
				if (newBody.eInternalContainer() == null) {
					msgs = newBody.eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.FUNCTION__BODY, null, msgs);
				}
				if (msgs != null) msgs.dispatch();
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.FUNCTION__BODY, oldBody, body));
			}
		}
		return body;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Instruction basicGetBody() {
		return body;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetBody(Instruction newBody, NotificationChain msgs) {
		Instruction oldBody = body;
		body = newBody;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.FUNCTION__BODY, oldBody, newBody);
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
	public void setBody(Instruction newBody) {
		if (newBody != body) {
			NotificationChain msgs = null;
			if (body != null)
				msgs = ((InternalEObject)body).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.FUNCTION__BODY, null, msgs);
			if (newBody != null)
				msgs = ((InternalEObject)newBody).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.FUNCTION__BODY, null, msgs);
			msgs = basicSetBody(newBody, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.FUNCTION__BODY, newBody, newBody));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public NotificationChain eInverseRemove(InternalEObject otherEnd, int featureID, NotificationChain msgs) {
		switch (featureID) {
			case IrPackage.FUNCTION__RETURN_TYPE:
				return basicSetReturnType(null, msgs);
			case IrPackage.FUNCTION__VARIABLES:
				return ((InternalEList<?>)getVariables()).basicRemove(otherEnd, msgs);
			case IrPackage.FUNCTION__IN_ARGS:
				return ((InternalEList<?>)getInArgs()).basicRemove(otherEnd, msgs);
			case IrPackage.FUNCTION__BODY:
				return basicSetBody(null, msgs);
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
			case IrPackage.FUNCTION__RETURN_TYPE:
				if (resolve) return getReturnType();
				return basicGetReturnType();
			case IrPackage.FUNCTION__PROVIDER:
				return getProvider();
			case IrPackage.FUNCTION__VARIABLES:
				return getVariables();
			case IrPackage.FUNCTION__NAME:
				return getName();
			case IrPackage.FUNCTION__IN_ARGS:
				return getInArgs();
			case IrPackage.FUNCTION__BODY:
				if (resolve) return getBody();
				return basicGetBody();
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
			case IrPackage.FUNCTION__RETURN_TYPE:
				setReturnType((BaseType)newValue);
				return;
			case IrPackage.FUNCTION__PROVIDER:
				setProvider((String)newValue);
				return;
			case IrPackage.FUNCTION__VARIABLES:
				getVariables().clear();
				getVariables().addAll((Collection<? extends SizeTypeSymbol>)newValue);
				return;
			case IrPackage.FUNCTION__NAME:
				setName((String)newValue);
				return;
			case IrPackage.FUNCTION__IN_ARGS:
				getInArgs().clear();
				getInArgs().addAll((Collection<? extends Arg>)newValue);
				return;
			case IrPackage.FUNCTION__BODY:
				setBody((Instruction)newValue);
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
			case IrPackage.FUNCTION__RETURN_TYPE:
				setReturnType((BaseType)null);
				return;
			case IrPackage.FUNCTION__PROVIDER:
				setProvider(PROVIDER_EDEFAULT);
				return;
			case IrPackage.FUNCTION__VARIABLES:
				getVariables().clear();
				return;
			case IrPackage.FUNCTION__NAME:
				setName(NAME_EDEFAULT);
				return;
			case IrPackage.FUNCTION__IN_ARGS:
				getInArgs().clear();
				return;
			case IrPackage.FUNCTION__BODY:
				setBody((Instruction)null);
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
			case IrPackage.FUNCTION__RETURN_TYPE:
				return returnType != null;
			case IrPackage.FUNCTION__PROVIDER:
				return PROVIDER_EDEFAULT == null ? provider != null : !PROVIDER_EDEFAULT.equals(provider);
			case IrPackage.FUNCTION__VARIABLES:
				return variables != null && !variables.isEmpty();
			case IrPackage.FUNCTION__NAME:
				return NAME_EDEFAULT == null ? name != null : !NAME_EDEFAULT.equals(name);
			case IrPackage.FUNCTION__IN_ARGS:
				return inArgs != null && !inArgs.isEmpty();
			case IrPackage.FUNCTION__BODY:
				return body != null;
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
		result.append(" (provider: ");
		result.append(provider);
		result.append(", name: ");
		result.append(name);
		result.append(')');
		return result.toString();
	}

} //FunctionImpl
