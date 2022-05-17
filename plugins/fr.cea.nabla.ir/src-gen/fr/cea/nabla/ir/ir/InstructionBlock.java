/**
 */
package fr.cea.nabla.ir.ir;

import org.eclipse.emf.common.util.EList;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Instruction Block</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.InstructionBlock#getInstructions <em>Instructions</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getInstructionBlock()
 * @model
 * @generated
 */
public interface InstructionBlock extends Instruction {
	/**
	 * Returns the value of the '<em><b>Instructions</b></em>' containment reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.Instruction}.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Instructions</em>' containment reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getInstructionBlock_Instructions()
	 * @model containment="true" required="true"
	 * @generated
	 */
	EList<Instruction> getInstructions();

} // InstructionBlock
