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
 *   <li>{@link fr.cea.nabla.ir.ir.ExtensionProvider#getOutputPath <em>Output Path</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getExtensionProvider()
 * @model abstract="true"
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
	 * Returns the value of the '<em><b>Output Path</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Output Path</em>' attribute.
	 * @see #setOutputPath(String)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getExtensionProvider_OutputPath()
	 * @model required="true"
	 * @generated
	 */
	String getOutputPath();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.ExtensionProvider#getOutputPath <em>Output Path</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Output Path</em>' attribute.
	 * @see #getOutputPath()
	 * @generated
	 */
	void setOutputPath(String value);

} // ExtensionProvider
