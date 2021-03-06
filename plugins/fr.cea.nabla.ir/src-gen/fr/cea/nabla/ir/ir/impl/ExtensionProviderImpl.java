/**
 */
package fr.cea.nabla.ir.ir.impl;

import org.eclipse.emf.common.notify.Notification;
import org.eclipse.emf.common.notify.NotificationChain;
import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;
import org.eclipse.emf.ecore.impl.ENotificationImpl;
import org.eclipse.emf.ecore.util.EObjectContainmentWithInverseEList;
import org.eclipse.emf.ecore.util.InternalEList;
import fr.cea.nabla.ir.ir.ExtensionProvider;
import fr.cea.nabla.ir.ir.ExternFunction;
import fr.cea.nabla.ir.ir.IrPackage;
import java.util.Collection;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Extension Provider</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.ExtensionProviderImpl#getExtensionName <em>Extension Name</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.ExtensionProviderImpl#getProviderName <em>Provider Name</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.ExtensionProviderImpl#getOutputPath <em>Output Path</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.ExtensionProviderImpl#isLinearAlgebra <em>Linear Algebra</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.ExtensionProviderImpl#getFunctions <em>Functions</em>}</li>
 * </ul>
 *
 * @generated
 */
public class ExtensionProviderImpl extends IrAnnotableImpl implements ExtensionProvider {
	/**
	 * The default value of the '{@link #getExtensionName() <em>Extension Name</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getExtensionName()
	 * @generated
	 * @ordered
	 */
	protected static final String EXTENSION_NAME_EDEFAULT = null;

	/**
	 * The cached value of the '{@link #getExtensionName() <em>Extension Name</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getExtensionName()
	 * @generated
	 * @ordered
	 */
	protected String extensionName = EXTENSION_NAME_EDEFAULT;

	/**
	 * The default value of the '{@link #getProviderName() <em>Provider Name</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getProviderName()
	 * @generated
	 * @ordered
	 */
	protected static final String PROVIDER_NAME_EDEFAULT = null;

	/**
	 * The cached value of the '{@link #getProviderName() <em>Provider Name</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getProviderName()
	 * @generated
	 * @ordered
	 */
	protected String providerName = PROVIDER_NAME_EDEFAULT;

	/**
	 * The default value of the '{@link #getOutputPath() <em>Output Path</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getOutputPath()
	 * @generated
	 * @ordered
	 */
	protected static final String OUTPUT_PATH_EDEFAULT = null;

	/**
	 * The cached value of the '{@link #getOutputPath() <em>Output Path</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getOutputPath()
	 * @generated
	 * @ordered
	 */
	protected String outputPath = OUTPUT_PATH_EDEFAULT;

	/**
	 * The default value of the '{@link #isLinearAlgebra() <em>Linear Algebra</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #isLinearAlgebra()
	 * @generated
	 * @ordered
	 */
	protected static final boolean LINEAR_ALGEBRA_EDEFAULT = false;

	/**
	 * The cached value of the '{@link #isLinearAlgebra() <em>Linear Algebra</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #isLinearAlgebra()
	 * @generated
	 * @ordered
	 */
	protected boolean linearAlgebra = LINEAR_ALGEBRA_EDEFAULT;

	/**
	 * The cached value of the '{@link #getFunctions() <em>Functions</em>}' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getFunctions()
	 * @generated
	 * @ordered
	 */
	protected EList<ExternFunction> functions;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected ExtensionProviderImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return IrPackage.Literals.EXTENSION_PROVIDER;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public String getExtensionName() {
		return extensionName;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setExtensionName(String newExtensionName) {
		String oldExtensionName = extensionName;
		extensionName = newExtensionName;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.EXTENSION_PROVIDER__EXTENSION_NAME, oldExtensionName, extensionName));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public String getProviderName() {
		return providerName;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setProviderName(String newProviderName) {
		String oldProviderName = providerName;
		providerName = newProviderName;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.EXTENSION_PROVIDER__PROVIDER_NAME, oldProviderName, providerName));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public String getOutputPath() {
		return outputPath;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setOutputPath(String newOutputPath) {
		String oldOutputPath = outputPath;
		outputPath = newOutputPath;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.EXTENSION_PROVIDER__OUTPUT_PATH, oldOutputPath, outputPath));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public boolean isLinearAlgebra() {
		return linearAlgebra;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setLinearAlgebra(boolean newLinearAlgebra) {
		boolean oldLinearAlgebra = linearAlgebra;
		linearAlgebra = newLinearAlgebra;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.EXTENSION_PROVIDER__LINEAR_ALGEBRA, oldLinearAlgebra, linearAlgebra));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public EList<ExternFunction> getFunctions() {
		if (functions == null) {
			functions = new EObjectContainmentWithInverseEList<ExternFunction>(ExternFunction.class, this, IrPackage.EXTENSION_PROVIDER__FUNCTIONS, IrPackage.EXTERN_FUNCTION__PROVIDER);
		}
		return functions;
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
			case IrPackage.EXTENSION_PROVIDER__FUNCTIONS:
				return ((InternalEList<InternalEObject>)(InternalEList<?>)getFunctions()).basicAdd(otherEnd, msgs);
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
			case IrPackage.EXTENSION_PROVIDER__FUNCTIONS:
				return ((InternalEList<?>)getFunctions()).basicRemove(otherEnd, msgs);
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
			case IrPackage.EXTENSION_PROVIDER__EXTENSION_NAME:
				return getExtensionName();
			case IrPackage.EXTENSION_PROVIDER__PROVIDER_NAME:
				return getProviderName();
			case IrPackage.EXTENSION_PROVIDER__OUTPUT_PATH:
				return getOutputPath();
			case IrPackage.EXTENSION_PROVIDER__LINEAR_ALGEBRA:
				return isLinearAlgebra();
			case IrPackage.EXTENSION_PROVIDER__FUNCTIONS:
				return getFunctions();
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
			case IrPackage.EXTENSION_PROVIDER__EXTENSION_NAME:
				setExtensionName((String)newValue);
				return;
			case IrPackage.EXTENSION_PROVIDER__PROVIDER_NAME:
				setProviderName((String)newValue);
				return;
			case IrPackage.EXTENSION_PROVIDER__OUTPUT_PATH:
				setOutputPath((String)newValue);
				return;
			case IrPackage.EXTENSION_PROVIDER__LINEAR_ALGEBRA:
				setLinearAlgebra((Boolean)newValue);
				return;
			case IrPackage.EXTENSION_PROVIDER__FUNCTIONS:
				getFunctions().clear();
				getFunctions().addAll((Collection<? extends ExternFunction>)newValue);
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
			case IrPackage.EXTENSION_PROVIDER__EXTENSION_NAME:
				setExtensionName(EXTENSION_NAME_EDEFAULT);
				return;
			case IrPackage.EXTENSION_PROVIDER__PROVIDER_NAME:
				setProviderName(PROVIDER_NAME_EDEFAULT);
				return;
			case IrPackage.EXTENSION_PROVIDER__OUTPUT_PATH:
				setOutputPath(OUTPUT_PATH_EDEFAULT);
				return;
			case IrPackage.EXTENSION_PROVIDER__LINEAR_ALGEBRA:
				setLinearAlgebra(LINEAR_ALGEBRA_EDEFAULT);
				return;
			case IrPackage.EXTENSION_PROVIDER__FUNCTIONS:
				getFunctions().clear();
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
			case IrPackage.EXTENSION_PROVIDER__EXTENSION_NAME:
				return EXTENSION_NAME_EDEFAULT == null ? extensionName != null : !EXTENSION_NAME_EDEFAULT.equals(extensionName);
			case IrPackage.EXTENSION_PROVIDER__PROVIDER_NAME:
				return PROVIDER_NAME_EDEFAULT == null ? providerName != null : !PROVIDER_NAME_EDEFAULT.equals(providerName);
			case IrPackage.EXTENSION_PROVIDER__OUTPUT_PATH:
				return OUTPUT_PATH_EDEFAULT == null ? outputPath != null : !OUTPUT_PATH_EDEFAULT.equals(outputPath);
			case IrPackage.EXTENSION_PROVIDER__LINEAR_ALGEBRA:
				return linearAlgebra != LINEAR_ALGEBRA_EDEFAULT;
			case IrPackage.EXTENSION_PROVIDER__FUNCTIONS:
				return functions != null && !functions.isEmpty();
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
		result.append(" (extensionName: ");
		result.append(extensionName);
		result.append(", providerName: ");
		result.append(providerName);
		result.append(", outputPath: ");
		result.append(outputPath);
		result.append(", linearAlgebra: ");
		result.append(linearAlgebra);
		result.append(')');
		return result.toString();
	}

} //ExtensionProviderImpl
