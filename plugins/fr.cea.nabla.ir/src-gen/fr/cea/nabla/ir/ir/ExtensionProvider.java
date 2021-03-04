/**
 */
package fr.cea.nabla.ir.ir;

import org.eclipse.emf.common.util.EList;


/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Extension Provider</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.ExtensionProvider#getExtensionName <em>Extension Name</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.ExtensionProvider#getProviderName <em>Provider Name</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.ExtensionProvider#getProjectDir <em>Project Dir</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.ExtensionProvider#getInstallDir <em>Install Dir</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.ExtensionProvider#getNamespace <em>Namespace</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.ExtensionProvider#getLibName <em>Lib Name</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.ExtensionProvider#isLinearAlgebra <em>Linear Algebra</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.ExtensionProvider#getFunctions <em>Functions</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getExtensionProvider()
 * @model
 * @generated
 */
public interface ExtensionProvider extends IrAnnotable {
	/**
	 * Returns the value of the '<em><b>Extension Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Extension Name</em>' attribute.
	 * @see #setExtensionName(String)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getExtensionProvider_ExtensionName()
	 * @model required="true"
	 * @generated
	 */
	String getExtensionName();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.ExtensionProvider#getExtensionName <em>Extension Name</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Extension Name</em>' attribute.
	 * @see #getExtensionName()
	 * @generated
	 */
	void setExtensionName(String value);

	/**
	 * Returns the value of the '<em><b>Provider Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Provider Name</em>' attribute.
	 * @see #setProviderName(String)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getExtensionProvider_ProviderName()
	 * @model required="true"
	 * @generated
	 */
	String getProviderName();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.ExtensionProvider#getProviderName <em>Provider Name</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Provider Name</em>' attribute.
	 * @see #getProviderName()
	 * @generated
	 */
	void setProviderName(String value);

	/**
	 * Returns the value of the '<em><b>Project Dir</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Project Dir</em>' attribute.
	 * @see #setProjectDir(String)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getExtensionProvider_ProjectDir()
	 * @model required="true"
	 * @generated
	 */
	String getProjectDir();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.ExtensionProvider#getProjectDir <em>Project Dir</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Project Dir</em>' attribute.
	 * @see #getProjectDir()
	 * @generated
	 */
	void setProjectDir(String value);

	/**
	 * Returns the value of the '<em><b>Install Dir</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Install Dir</em>' attribute.
	 * @see #setInstallDir(String)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getExtensionProvider_InstallDir()
	 * @model required="true"
	 * @generated
	 */
	String getInstallDir();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.ExtensionProvider#getInstallDir <em>Install Dir</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Install Dir</em>' attribute.
	 * @see #getInstallDir()
	 * @generated
	 */
	void setInstallDir(String value);

	/**
	 * Returns the value of the '<em><b>Namespace</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Namespace</em>' attribute.
	 * @see #setNamespace(String)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getExtensionProvider_Namespace()
	 * @model required="true"
	 * @generated
	 */
	String getNamespace();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.ExtensionProvider#getNamespace <em>Namespace</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Namespace</em>' attribute.
	 * @see #getNamespace()
	 * @generated
	 */
	void setNamespace(String value);

	/**
	 * Returns the value of the '<em><b>Lib Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Lib Name</em>' attribute.
	 * @see #setLibName(String)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getExtensionProvider_LibName()
	 * @model required="true"
	 * @generated
	 */
	String getLibName();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.ExtensionProvider#getLibName <em>Lib Name</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Lib Name</em>' attribute.
	 * @see #getLibName()
	 * @generated
	 */
	void setLibName(String value);

	/**
	 * Returns the value of the '<em><b>Linear Algebra</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Linear Algebra</em>' attribute.
	 * @see #setLinearAlgebra(boolean)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getExtensionProvider_LinearAlgebra()
	 * @model required="true"
	 * @generated
	 */
	boolean isLinearAlgebra();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.ExtensionProvider#isLinearAlgebra <em>Linear Algebra</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Linear Algebra</em>' attribute.
	 * @see #isLinearAlgebra()
	 * @generated
	 */
	void setLinearAlgebra(boolean value);

	/**
	 * Returns the value of the '<em><b>Functions</b></em>' containment reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.ExternFunction}.
	 * It is bidirectional and its opposite is '{@link fr.cea.nabla.ir.ir.ExternFunction#getProvider <em>Provider</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Functions</em>' containment reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getExtensionProvider_Functions()
	 * @see fr.cea.nabla.ir.ir.ExternFunction#getProvider
	 * @model opposite="provider" containment="true"
	 * @generated
	 */
	EList<ExternFunction> getFunctions();

} // ExtensionProvider
