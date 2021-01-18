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
		result.append(')');
		return result.toString();
	}

} //ExtensionProviderImpl
