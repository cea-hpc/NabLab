/**
 */
package fr.cea.nabla.ir.ir;


/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Iterable Instruction</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.IterableInstruction#getIterationBlock <em>Iteration Block</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getIterableInstruction()
 * @model abstract="true"
 * @generated
 */
public interface IterableInstruction extends Instruction {
	/**
	 * Returns the value of the '<em><b>Iteration Block</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Iteration Block</em>' containment reference.
	 * @see #setIterationBlock(IterationBlock)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getIterableInstruction_IterationBlock()
	 * @model containment="true" resolveProxies="true" required="true"
	 * @generated
	 */
	IterationBlock getIterationBlock();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.IterableInstruction#getIterationBlock <em>Iteration Block</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Iteration Block</em>' containment reference.
	 * @see #getIterationBlock()
	 * @generated
	 */
	void setIterationBlock(IterationBlock value);

} // IterableInstruction
