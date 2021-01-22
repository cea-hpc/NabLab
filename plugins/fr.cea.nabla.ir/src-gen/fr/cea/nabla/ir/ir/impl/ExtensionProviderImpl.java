/**
 */
package fr.cea.nabla.ir.ir.impl;

import org.eclipse.emf.common.notify.Notification;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.impl.ENotificationImpl;

import fr.cea.nabla.ir.ir.ExtensionProvider;
import fr.cea.nabla.ir.ir.IrPackage;

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
 *   <li>{@link fr.cea.nabla.ir.ir.impl.ExtensionProviderImpl#getProjectDir <em>Project Dir</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.ExtensionProviderImpl#getInstallDir <em>Install Dir</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.ExtensionProviderImpl#getFacadeClass <em>Facade Class</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.ExtensionProviderImpl#getFacadeNamespace <em>Facade Namespace</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.ExtensionProviderImpl#getLibName <em>Lib Name</em>}</li>
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
	 * The default value of the '{@link #getProjectDir() <em>Project Dir</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getProjectDir()
	 * @generated
	 * @ordered
	 */
	protected static final String PROJECT_DIR_EDEFAULT = null;

	/**
	 * The cached value of the '{@link #getProjectDir() <em>Project Dir</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getProjectDir()
	 * @generated
	 * @ordered
	 */
	protected String projectDir = PROJECT_DIR_EDEFAULT;

	/**
	 * The default value of the '{@link #getInstallDir() <em>Install Dir</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getInstallDir()
	 * @generated
	 * @ordered
	 */
	protected static final String INSTALL_DIR_EDEFAULT = null;

	/**
	 * The cached value of the '{@link #getInstallDir() <em>Install Dir</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getInstallDir()
	 * @generated
	 * @ordered
	 */
	protected String installDir = INSTALL_DIR_EDEFAULT;

	/**
	 * The default value of the '{@link #getFacadeClass() <em>Facade Class</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getFacadeClass()
	 * @generated
	 * @ordered
	 */
	protected static final String FACADE_CLASS_EDEFAULT = null;

	/**
	 * The cached value of the '{@link #getFacadeClass() <em>Facade Class</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getFacadeClass()
	 * @generated
	 * @ordered
	 */
	protected String facadeClass = FACADE_CLASS_EDEFAULT;

	/**
	 * The default value of the '{@link #getFacadeNamespace() <em>Facade Namespace</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getFacadeNamespace()
	 * @generated
	 * @ordered
	 */
	protected static final String FACADE_NAMESPACE_EDEFAULT = null;

	/**
	 * The cached value of the '{@link #getFacadeNamespace() <em>Facade Namespace</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getFacadeNamespace()
	 * @generated
	 * @ordered
	 */
	protected String facadeNamespace = FACADE_NAMESPACE_EDEFAULT;

	/**
	 * The default value of the '{@link #getLibName() <em>Lib Name</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getLibName()
	 * @generated
	 * @ordered
	 */
	protected static final String LIB_NAME_EDEFAULT = null;

	/**
	 * The cached value of the '{@link #getLibName() <em>Lib Name</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getLibName()
	 * @generated
	 * @ordered
	 */
	protected String libName = LIB_NAME_EDEFAULT;

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
	public String getProjectDir() {
		return projectDir;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setProjectDir(String newProjectDir) {
		String oldProjectDir = projectDir;
		projectDir = newProjectDir;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.EXTENSION_PROVIDER__PROJECT_DIR, oldProjectDir, projectDir));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public String getInstallDir() {
		return installDir;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setInstallDir(String newInstallDir) {
		String oldInstallDir = installDir;
		installDir = newInstallDir;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.EXTENSION_PROVIDER__INSTALL_DIR, oldInstallDir, installDir));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public String getFacadeClass() {
		return facadeClass;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setFacadeClass(String newFacadeClass) {
		String oldFacadeClass = facadeClass;
		facadeClass = newFacadeClass;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.EXTENSION_PROVIDER__FACADE_CLASS, oldFacadeClass, facadeClass));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public String getFacadeNamespace() {
		return facadeNamespace;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setFacadeNamespace(String newFacadeNamespace) {
		String oldFacadeNamespace = facadeNamespace;
		facadeNamespace = newFacadeNamespace;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.EXTENSION_PROVIDER__FACADE_NAMESPACE, oldFacadeNamespace, facadeNamespace));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public String getLibName() {
		return libName;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setLibName(String newLibName) {
		String oldLibName = libName;
		libName = newLibName;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, IrPackage.EXTENSION_PROVIDER__LIB_NAME, oldLibName, libName));
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
			case IrPackage.EXTENSION_PROVIDER__PROJECT_DIR:
				return getProjectDir();
			case IrPackage.EXTENSION_PROVIDER__INSTALL_DIR:
				return getInstallDir();
			case IrPackage.EXTENSION_PROVIDER__FACADE_CLASS:
				return getFacadeClass();
			case IrPackage.EXTENSION_PROVIDER__FACADE_NAMESPACE:
				return getFacadeNamespace();
			case IrPackage.EXTENSION_PROVIDER__LIB_NAME:
				return getLibName();
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
			case IrPackage.EXTENSION_PROVIDER__EXTENSION_NAME:
				setExtensionName((String)newValue);
				return;
			case IrPackage.EXTENSION_PROVIDER__PROVIDER_NAME:
				setProviderName((String)newValue);
				return;
			case IrPackage.EXTENSION_PROVIDER__PROJECT_DIR:
				setProjectDir((String)newValue);
				return;
			case IrPackage.EXTENSION_PROVIDER__INSTALL_DIR:
				setInstallDir((String)newValue);
				return;
			case IrPackage.EXTENSION_PROVIDER__FACADE_CLASS:
				setFacadeClass((String)newValue);
				return;
			case IrPackage.EXTENSION_PROVIDER__FACADE_NAMESPACE:
				setFacadeNamespace((String)newValue);
				return;
			case IrPackage.EXTENSION_PROVIDER__LIB_NAME:
				setLibName((String)newValue);
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
			case IrPackage.EXTENSION_PROVIDER__PROJECT_DIR:
				setProjectDir(PROJECT_DIR_EDEFAULT);
				return;
			case IrPackage.EXTENSION_PROVIDER__INSTALL_DIR:
				setInstallDir(INSTALL_DIR_EDEFAULT);
				return;
			case IrPackage.EXTENSION_PROVIDER__FACADE_CLASS:
				setFacadeClass(FACADE_CLASS_EDEFAULT);
				return;
			case IrPackage.EXTENSION_PROVIDER__FACADE_NAMESPACE:
				setFacadeNamespace(FACADE_NAMESPACE_EDEFAULT);
				return;
			case IrPackage.EXTENSION_PROVIDER__LIB_NAME:
				setLibName(LIB_NAME_EDEFAULT);
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
			case IrPackage.EXTENSION_PROVIDER__PROJECT_DIR:
				return PROJECT_DIR_EDEFAULT == null ? projectDir != null : !PROJECT_DIR_EDEFAULT.equals(projectDir);
			case IrPackage.EXTENSION_PROVIDER__INSTALL_DIR:
				return INSTALL_DIR_EDEFAULT == null ? installDir != null : !INSTALL_DIR_EDEFAULT.equals(installDir);
			case IrPackage.EXTENSION_PROVIDER__FACADE_CLASS:
				return FACADE_CLASS_EDEFAULT == null ? facadeClass != null : !FACADE_CLASS_EDEFAULT.equals(facadeClass);
			case IrPackage.EXTENSION_PROVIDER__FACADE_NAMESPACE:
				return FACADE_NAMESPACE_EDEFAULT == null ? facadeNamespace != null : !FACADE_NAMESPACE_EDEFAULT.equals(facadeNamespace);
			case IrPackage.EXTENSION_PROVIDER__LIB_NAME:
				return LIB_NAME_EDEFAULT == null ? libName != null : !LIB_NAME_EDEFAULT.equals(libName);
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
		result.append(", projectDir: ");
		result.append(projectDir);
		result.append(", installDir: ");
		result.append(installDir);
		result.append(", facadeClass: ");
		result.append(facadeClass);
		result.append(", facadeNamespace: ");
		result.append(facadeNamespace);
		result.append(", libName: ");
		result.append(libName);
		result.append(')');
		return result.toString();
	}

} //ExtensionProviderImpl
