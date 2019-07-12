/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.ArgType;
import fr.cea.nabla.ir.ir.IrPackage;
import fr.cea.nabla.ir.ir.Reduction;

import org.eclipse.emf.common.notify.Notification;

import org.eclipse.emf.common.notify.NotificationChain;
import org.eclipse.emf.ecore.EClass;

import org.eclipse.emf.ecore.InternalEObject;
import org.eclipse.emf.ecore.impl.ENotificationImpl;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Reduction</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.ReductionImpl#getName <em>Name</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.ReductionImpl#getCollectionType <em>Collection Type</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.ReductionImpl#getReturnType <em>Return Type</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.ReductionImpl#getProvider <em>Provider</em>}</li>
 * </ul>
 *
 * @generated
 */
public class ReductionImpl extends IrAnnotableImpl implements Reduction {
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
	 * The cached value of the '{@link #getCollectionType() <em>Collection Type</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getCollectionType()
	 * @generated
	 * @ordered
	 */
	protected ArgType collectionType;

	/**
	 * The cached value of the '{@link #getReturnType() <em>Return Type</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getReturnType()
	 * @generated
	 * @ordered
	 */
	protected ArgType returnType;

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
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected ReductionImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return IrPackage.Literals.REDUCTION;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public String getName() {
		return name;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setName(String newName) {
		String oldName = name;
		name = newName;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.REDUCTION__NAME, oldName, name));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public ArgType getCollectionType() {
		if (collectionType != null && collectionType.eIsProxy()) {
			InternalEObject oldCollectionType = (InternalEObject)collectionType;
			collectionType = (ArgType)eResolveProxy(oldCollectionType);
			if (collectionType != oldCollectionType) {
				InternalEObject newCollectionType = (InternalEObject)collectionType;
				NotificationChain msgs = oldCollectionType.eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.REDUCTION__COLLECTION_TYPE, null, null);
				if (newCollectionType.eInternalContainer() == null) {
					msgs = newCollectionType.eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.REDUCTION__COLLECTION_TYPE, null, msgs);
				}
				if (msgs != null) msgs.dispatch();
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.REDUCTION__COLLECTION_TYPE, oldCollectionType, collectionType));
			}
		}
		return collectionType;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public ArgType basicGetCollectionType() {
		return collectionType;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetCollectionType(ArgType newCollectionType, NotificationChain msgs) {
		ArgType oldCollectionType = collectionType;
		collectionType = newCollectionType;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.REDUCTION__COLLECTION_TYPE, oldCollectionType, newCollectionType);
			if (msgs == null) msgs = notification; else msgs.add(notification);
		}
		return msgs;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setCollectionType(ArgType newCollectionType) {
		if (newCollectionType != collectionType) {
			NotificationChain msgs = null;
			if (collectionType != null)
				msgs = ((InternalEObject)collectionType).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.REDUCTION__COLLECTION_TYPE, null, msgs);
			if (newCollectionType != null)
				msgs = ((InternalEObject)newCollectionType).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.REDUCTION__COLLECTION_TYPE, null, msgs);
			msgs = basicSetCollectionType(newCollectionType, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.REDUCTION__COLLECTION_TYPE, newCollectionType, newCollectionType));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public ArgType getReturnType() {
		if (returnType != null && returnType.eIsProxy()) {
			InternalEObject oldReturnType = (InternalEObject)returnType;
			returnType = (ArgType)eResolveProxy(oldReturnType);
			if (returnType != oldReturnType) {
				InternalEObject newReturnType = (InternalEObject)returnType;
				NotificationChain msgs = oldReturnType.eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.REDUCTION__RETURN_TYPE, null, null);
				if (newReturnType.eInternalContainer() == null) {
					msgs = newReturnType.eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.REDUCTION__RETURN_TYPE, null, msgs);
				}
				if (msgs != null) msgs.dispatch();
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, IrPackage.REDUCTION__RETURN_TYPE, oldReturnType, returnType));
			}
		}
		return returnType;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public ArgType basicGetReturnType() {
		return returnType;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetReturnType(ArgType newReturnType, NotificationChain msgs) {
		ArgType oldReturnType = returnType;
		returnType = newReturnType;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, IrPackage.REDUCTION__RETURN_TYPE, oldReturnType, newReturnType);
			if (msgs == null) msgs = notification; else msgs.add(notification);
		}
		return msgs;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setReturnType(ArgType newReturnType) {
		if (newReturnType != returnType) {
			NotificationChain msgs = null;
			if (returnType != null)
				msgs = ((InternalEObject)returnType).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - IrPackage.REDUCTION__RETURN_TYPE, null, msgs);
			if (newReturnType != null)
				msgs = ((InternalEObject)newReturnType).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - IrPackage.REDUCTION__RETURN_TYPE, null, msgs);
			msgs = basicSetReturnType(newReturnType, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.REDUCTION__RETURN_TYPE, newReturnType, newReturnType));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public String getProvider() {
		return provider;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setProvider(String newProvider) {
		String oldProvider = provider;
		provider = newProvider;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.REDUCTION__PROVIDER, oldProvider, provider));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public NotificationChain eInverseRemove(InternalEObject otherEnd, int featureID, NotificationChain msgs) {
		switch (featureID) {
			case IrPackage.REDUCTION__COLLECTION_TYPE:
				return basicSetCollectionType(null, msgs);
			case IrPackage.REDUCTION__RETURN_TYPE:
				return basicSetReturnType(null, msgs);
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
			case IrPackage.REDUCTION__NAME:
				return getName();
			case IrPackage.REDUCTION__COLLECTION_TYPE:
				if (resolve) return getCollectionType();
				return basicGetCollectionType();
			case IrPackage.REDUCTION__RETURN_TYPE:
				if (resolve) return getReturnType();
				return basicGetReturnType();
			case IrPackage.REDUCTION__PROVIDER:
				return getProvider();
		}
		return super.eGet(featureID, resolve, coreType);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void eSet(int featureID, Object newValue) {
		switch (featureID) {
			case IrPackage.REDUCTION__NAME:
				setName((String)newValue);
				return;
			case IrPackage.REDUCTION__COLLECTION_TYPE:
				setCollectionType((ArgType)newValue);
				return;
			case IrPackage.REDUCTION__RETURN_TYPE:
				setReturnType((ArgType)newValue);
				return;
			case IrPackage.REDUCTION__PROVIDER:
				setProvider((String)newValue);
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
			case IrPackage.REDUCTION__NAME:
				setName(NAME_EDEFAULT);
				return;
			case IrPackage.REDUCTION__COLLECTION_TYPE:
				setCollectionType((ArgType)null);
				return;
			case IrPackage.REDUCTION__RETURN_TYPE:
				setReturnType((ArgType)null);
				return;
			case IrPackage.REDUCTION__PROVIDER:
				setProvider(PROVIDER_EDEFAULT);
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
			case IrPackage.REDUCTION__NAME:
				return NAME_EDEFAULT == null ? name != null : !NAME_EDEFAULT.equals(name);
			case IrPackage.REDUCTION__COLLECTION_TYPE:
				return collectionType != null;
			case IrPackage.REDUCTION__RETURN_TYPE:
				return returnType != null;
			case IrPackage.REDUCTION__PROVIDER:
				return PROVIDER_EDEFAULT == null ? provider != null : !PROVIDER_EDEFAULT.equals(provider);
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
		result.append(", provider: ");
		result.append(provider);
		result.append(')');
		return result.toString();
	}

} //ReductionImpl
