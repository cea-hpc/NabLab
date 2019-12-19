/**
 */
package fr.cea.nabla.ir.ir;


/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Expression</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.Expression#getType <em>Type</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getExpression()
 * @model abstract="true"
 * @generated
 */
public interface Expression extends IrAnnotable {
	/**
	 * Returns the value of the '<em><b>Type</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Type</em>' containment reference.
	 * @see #setType(IrType)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getExpression_Type()
	 * @model containment="true" required="true"
	 * @generated
	 */
	IrType getType();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.Expression#getType <em>Type</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Type</em>' containment reference.
	 * @see #getType()
	 * @generated
	 */
	void setType(IrType value);

} // Expression
