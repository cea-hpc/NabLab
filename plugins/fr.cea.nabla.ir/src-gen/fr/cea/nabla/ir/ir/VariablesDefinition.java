/**
 */
package fr.cea.nabla.ir.ir;

import org.eclipse.emf.common.util.EList;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Variables Definition</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.VariablesDefinition#getVariables <em>Variables</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getVariablesDefinition()
 * @model
 * @generated
 */
public interface VariablesDefinition extends Instruction {
	/**
	 * Returns the value of the '<em><b>Variables</b></em>' containment reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.Variable}.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Variables</em>' containment reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getVariablesDefinition_Variables()
	 * @model containment="true" resolveProxies="true" required="true"
	 * @generated
	 */
	EList<Variable> getVariables();

} // VariablesDefinition
