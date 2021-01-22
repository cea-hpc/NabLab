/**
 */
package fr.cea.nabla.ir.ir;


/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Extern Function</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.ExternFunction#getProvider <em>Provider</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getExternFunction()
 * @model
 * @generated
 */
public interface ExternFunction extends Function {
	/**
	 * Returns the value of the '<em><b>Provider</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Provider</em>' reference.
	 * @see #setProvider(ExtensionProvider)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getExternFunction_Provider()
	 * @model
	 * @generated
	 */
	ExtensionProvider getProvider();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.ExternFunction#getProvider <em>Provider</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Provider</em>' reference.
	 * @see #getProvider()
	 * @generated
	 */
	void setProvider(ExtensionProvider value);

} // ExternFunction
