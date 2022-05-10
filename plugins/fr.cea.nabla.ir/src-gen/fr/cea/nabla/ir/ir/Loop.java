/**
 */
package fr.cea.nabla.ir.ir;


/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Loop</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.Loop#getBody <em>Body</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.Loop#isMultithreadable <em>Multithreadable</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getLoop()
 * @model
 * @generated
 */
public interface Loop extends IterableInstruction {
	/**
	 * Returns the value of the '<em><b>Body</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Body</em>' containment reference.
	 * @see #setBody(Instruction)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getLoop_Body()
	 * @model containment="true" required="true"
	 * @generated
	 */
	Instruction getBody();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.Loop#getBody <em>Body</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Body</em>' containment reference.
	 * @see #getBody()
	 * @generated
	 */
	void setBody(Instruction value);

	/**
	 * Returns the value of the '<em><b>Multithreadable</b></em>' attribute.
	 * The default value is <code>"false"</code>.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Multithreadable</em>' attribute.
	 * @see #setMultithreadable(boolean)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getLoop_Multithreadable()
	 * @model default="false"
	 * @generated
	 */
	boolean isMultithreadable();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.Loop#isMultithreadable <em>Multithreadable</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Multithreadable</em>' attribute.
	 * @see #isMultithreadable()
	 * @generated
	 */
	void setMultithreadable(boolean value);

} // Loop
