/**
 */
package fr.cea.nabla.ir.ir;


/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Variable Declaration</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.VariableDeclaration#getVariable <em>Variable</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getVariableDeclaration()
 * @model
 * @generated
 */
public interface VariableDeclaration extends Instruction {
	/**
	 * Returns the value of the '<em><b>Variable</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Variable</em>' containment reference.
	 * @see #setVariable(SimpleVariable)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getVariableDeclaration_Variable()
	 * @model containment="true" resolveProxies="true" required="true"
	 * @generated
	 */
	SimpleVariable getVariable();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.VariableDeclaration#getVariable <em>Variable</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Variable</em>' containment reference.
	 * @see #getVariable()
	 * @generated
	 */
	void setVariable(SimpleVariable value);

} // VariableDeclaration
