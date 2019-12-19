/**
 */
package fr.cea.nabla.ir.ir;


/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Contracted If</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.ContractedIf#getCondition <em>Condition</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.ContractedIf#getThenExpression <em>Then Expression</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.ContractedIf#getElseExpression <em>Else Expression</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getContractedIf()
 * @model
 * @generated
 */
public interface ContractedIf extends Expression {
	/**
	 * Returns the value of the '<em><b>Condition</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Condition</em>' containment reference.
	 * @see #setCondition(Expression)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getContractedIf_Condition()
	 * @model containment="true" resolveProxies="true" required="true"
	 * @generated
	 */
	Expression getCondition();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.ContractedIf#getCondition <em>Condition</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Condition</em>' containment reference.
	 * @see #getCondition()
	 * @generated
	 */
	void setCondition(Expression value);

	/**
	 * Returns the value of the '<em><b>Then Expression</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Then Expression</em>' containment reference.
	 * @see #setThenExpression(Expression)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getContractedIf_ThenExpression()
	 * @model containment="true" resolveProxies="true" required="true"
	 * @generated
	 */
	Expression getThenExpression();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.ContractedIf#getThenExpression <em>Then Expression</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Then Expression</em>' containment reference.
	 * @see #getThenExpression()
	 * @generated
	 */
	void setThenExpression(Expression value);

	/**
	 * Returns the value of the '<em><b>Else Expression</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Else Expression</em>' containment reference.
	 * @see #setElseExpression(Expression)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getContractedIf_ElseExpression()
	 * @model containment="true" resolveProxies="true" required="true"
	 * @generated
	 */
	Expression getElseExpression();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.ContractedIf#getElseExpression <em>Else Expression</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Else Expression</em>' containment reference.
	 * @see #getElseExpression()
	 * @generated
	 */
	void setElseExpression(Expression value);

} // ContractedIf
