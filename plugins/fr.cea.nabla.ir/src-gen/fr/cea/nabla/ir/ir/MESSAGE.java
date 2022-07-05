/**
 */
package fr.cea.nabla.ir.ir;


/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>MESSAGE</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.MESSAGE#getVariable <em>Variable</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.MESSAGE#getString <em>String</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getMESSAGE()
 * @model
 * @generated
 */
public interface MESSAGE extends Instruction {
	/**
	 * Returns the value of the '<em><b>Variable</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Variable</em>' reference.
	 * @see #setVariable(Variable)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getMESSAGE_Variable()
	 * @model required="true"
	 * @generated
	 */
	Variable getVariable();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.MESSAGE#getVariable <em>Variable</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Variable</em>' reference.
	 * @see #getVariable()
	 * @generated
	 */
	void setVariable(Variable value);

	/**
	 * Returns the value of the '<em><b>String</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>String</em>' attribute.
	 * @see #setString(String)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getMESSAGE_String()
	 * @model required="true"
	 * @generated
	 */
	String getString();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.MESSAGE#getString <em>String</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>String</em>' attribute.
	 * @see #getString()
	 * @generated
	 */
	void setString(String value);

} // MESSAGE
