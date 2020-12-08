/**
 */
package fr.cea.nabla.ir.ir;


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
 *   <li>{@link fr.cea.nabla.ir.ir.ExtensionProvider#getFacadeClass <em>Facade Class</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.ExtensionProvider#getLibHome <em>Lib Home</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.ExtensionProvider#getLibName <em>Lib Name</em>}</li>
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
	 * Returns the value of the '<em><b>Facade Class</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Facade Class</em>' attribute.
	 * @see #setFacadeClass(String)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getExtensionProvider_FacadeClass()
	 * @model required="true"
	 * @generated
	 */
	String getFacadeClass();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.ExtensionProvider#getFacadeClass <em>Facade Class</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Facade Class</em>' attribute.
	 * @see #getFacadeClass()
	 * @generated
	 */
	void setFacadeClass(String value);

	/**
	 * Returns the value of the '<em><b>Lib Home</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Lib Home</em>' attribute.
	 * @see #setLibHome(String)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getExtensionProvider_LibHome()
	 * @model required="true"
	 * @generated
	 */
	String getLibHome();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.ExtensionProvider#getLibHome <em>Lib Home</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Lib Home</em>' attribute.
	 * @see #getLibHome()
	 * @generated
	 */
	void setLibHome(String value);

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

} // ExtensionProvider
