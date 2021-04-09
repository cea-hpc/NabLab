/**
 */
package fr.cea.nabla.ir.ir;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Time Loop Job</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.TimeLoopJob#getInstruction <em>Instruction</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getTimeLoopJob()
 * @model abstract="true"
 * @generated
 */
public interface TimeLoopJob extends Job {
	/**
	 * Returns the value of the '<em><b>Instruction</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Instruction</em>' containment reference.
	 * @see #setInstruction(Instruction)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getTimeLoopJob_Instruction()
	 * @model containment="true" required="true"
	 * @generated
	 */
	Instruction getInstruction();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.TimeLoopJob#getInstruction <em>Instruction</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Instruction</em>' containment reference.
	 * @see #getInstruction()
	 * @generated
	 */
	void setInstruction(Instruction value);

} // TimeLoopJob
