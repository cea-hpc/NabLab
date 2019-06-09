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
 *   <li>{@link fr.cea.nabla.ir.ir.ReductionInstruction#getInnerReductions <em>Inner Reductions</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.ReductionInstruction#getReduction <em>Reduction</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.ReductionInstruction#getArg <em>Arg</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.ReductionInstruction#getResult <em>Result</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getReductionInstruction()
 * @model
 * @generated
 */
public interface ReductionInstruction extends IterableInstruction {
	/**
	 * Returns the value of the '<em><b>Inner Reductions</b></em>' containment reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.Instruction}.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Inner Reductions</em>' containment reference list isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Inner Reductions</em>' containment reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getReductionInstruction_InnerReductions()
	 * @model containment="true" resolveProxies="true"
	 * @generated
	 */
	EList<Instruction> getInnerReductions();

	/**
	 * Returns the value of the '<em><b>Reduction</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Reduction</em>' reference isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Reduction</em>' reference.
	 * @see #setReduction(Reduction)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getReductionInstruction_Reduction()
	 * @model required="true"
	 * @generated
	 */
	Reduction getReduction();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.ReductionInstruction#getReduction <em>Reduction</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Reduction</em>' reference.
	 * @see #getReduction()
	 * @generated
	 */
	void setReduction(Reduction value);

	/**
	 * Returns the value of the '<em><b>Arg</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Arg</em>' containment reference isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Arg</em>' containment reference.
	 * @see #setArg(Expression)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getReductionInstruction_Arg()
	 * @model containment="true" required="true"
	 * @generated
	 */
	Expression getArg();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.ReductionInstruction#getArg <em>Arg</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Arg</em>' containment reference.
	 * @see #getArg()
	 * @generated
	 */
	void setArg(Expression value);

	/**
	 * Returns the value of the '<em><b>Result</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Result</em>' containment reference isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Result</em>' containment reference.
	 * @see #setResult(ScalarVariable)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getReductionInstruction_Result()
	 * @model containment="true" required="true"
	 * @generated
	 */
	ScalarVariable getResult();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.ReductionInstruction#getResult <em>Result</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Result</em>' containment reference.
	 * @see #getResult()
	 * @generated
	 */
	void setResult(ScalarVariable value);

} // ReductionInstruction
