/**
 */
package fr.cea.nabla.ir.ir;

import org.eclipse.emf.common.util.EList;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Reduction Instruction</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.ReductionInstruction#getInnerInstructions <em>Inner Instructions</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.ReductionInstruction#getBinaryFunction <em>Binary Function</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.ReductionInstruction#getLambda <em>Lambda</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.ReductionInstruction#getResult <em>Result</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getReductionInstruction()
 * @model
 * @generated
 */
public interface ReductionInstruction extends IterableInstruction {
	/**
	 * Returns the value of the '<em><b>Inner Instructions</b></em>' containment reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.Instruction}.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Inner Instructions</em>' containment reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getReductionInstruction_InnerInstructions()
	 * @model containment="true" resolveProxies="true"
	 * @generated
	 */
	EList<Instruction> getInnerInstructions();

	/**
	 * Returns the value of the '<em><b>Binary Function</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Binary Function</em>' reference.
	 * @see #setBinaryFunction(Function)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getReductionInstruction_BinaryFunction()
	 * @model required="true"
	 * @generated
	 */
	Function getBinaryFunction();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.ReductionInstruction#getBinaryFunction <em>Binary Function</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Binary Function</em>' reference.
	 * @see #getBinaryFunction()
	 * @generated
	 */
	void setBinaryFunction(Function value);

	/**
	 * Returns the value of the '<em><b>Lambda</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Lambda</em>' containment reference.
	 * @see #setLambda(Expression)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getReductionInstruction_Lambda()
	 * @model containment="true" required="true"
	 * @generated
	 */
	Expression getLambda();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.ReductionInstruction#getLambda <em>Lambda</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Lambda</em>' containment reference.
	 * @see #getLambda()
	 * @generated
	 */
	void setLambda(Expression value);

	/**
	 * Returns the value of the '<em><b>Result</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Result</em>' containment reference.
	 * @see #setResult(SimpleVariable)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getReductionInstruction_Result()
	 * @model containment="true" required="true"
	 * @generated
	 */
	SimpleVariable getResult();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.ReductionInstruction#getResult <em>Result</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Result</em>' containment reference.
	 * @see #getResult()
	 * @generated
	 */
	void setResult(SimpleVariable value);

} // ReductionInstruction
