/**
 */
package fr.cea.nabla.ir.ir;


/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>If</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.If#getCondition <em>Condition</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.If#getThenInstruction <em>Then Instruction</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.If#getElseInstruction <em>Else Instruction</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getIf()
 * @model
 * @generated
 */
public interface If extends Instruction {
	/**
	 * Returns the value of the '<em><b>Condition</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Condition</em>' containment reference isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Condition</em>' containment reference.
	 * @see #setCondition(Expression)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getIf_Condition()
	 * @model containment="true" required="true"
	 * @generated
	 */
	Expression getCondition();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.If#getCondition <em>Condition</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Condition</em>' containment reference.
	 * @see #getCondition()
	 * @generated
	 */
	void setCondition(Expression value);

	/**
	 * Returns the value of the '<em><b>Then Instruction</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Then Instruction</em>' containment reference isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Then Instruction</em>' containment reference.
	 * @see #setThenInstruction(Instruction)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getIf_ThenInstruction()
	 * @model containment="true" required="true"
	 * @generated
	 */
	Instruction getThenInstruction();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.If#getThenInstruction <em>Then Instruction</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Then Instruction</em>' containment reference.
	 * @see #getThenInstruction()
	 * @generated
	 */
	void setThenInstruction(Instruction value);

	/**
	 * Returns the value of the '<em><b>Else Instruction</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Else Instruction</em>' containment reference isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Else Instruction</em>' containment reference.
	 * @see #setElseInstruction(Instruction)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getIf_ElseInstruction()
	 * @model containment="true"
	 * @generated
	 */
	Instruction getElseInstruction();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.If#getElseInstruction <em>Else Instruction</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Else Instruction</em>' containment reference.
	 * @see #getElseInstruction()
	 * @generated
	 */
	void setElseInstruction(Instruction value);

} // If
