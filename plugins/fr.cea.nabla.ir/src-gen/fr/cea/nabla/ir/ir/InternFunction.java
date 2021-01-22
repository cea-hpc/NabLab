/**
 */
package fr.cea.nabla.ir.ir;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Intern Function</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.InternFunction#getBody <em>Body</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getInternFunction()
 * @model
 * @generated
 */
public interface InternFunction extends Function {
	/**
	 * Returns the value of the '<em><b>Body</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Body</em>' containment reference.
	 * @see #setBody(Instruction)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getInternFunction_Body()
	 * @model containment="true" resolveProxies="true"
	 * @generated
	 */
	Instruction getBody();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.InternFunction#getBody <em>Body</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Body</em>' containment reference.
	 * @see #getBody()
	 * @generated
	 */
	void setBody(Instruction value);

} // InternFunction
