/**
 */
package fr.cea.nabla.ir.ir;


/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Init Variable Job</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.InitVariableJob#getTarget <em>Target</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getInitVariableJob()
 * @model
 * @generated
 */
public interface InitVariableJob extends Job {
	/**
	 * Returns the value of the '<em><b>Target</b></em>' reference.
	 * It is bidirectional and its opposite is '{@link fr.cea.nabla.ir.ir.Variable#getInitJob <em>Init Job</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Target</em>' reference.
	 * @see #setTarget(Variable)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getInitVariableJob_Target()
	 * @see fr.cea.nabla.ir.ir.Variable#getInitJob
	 * @model opposite="initJob" required="true"
	 * @generated
	 */
	Variable getTarget();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.InitVariableJob#getTarget <em>Target</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Target</em>' reference.
	 * @see #getTarget()
	 * @generated
	 */
	void setTarget(Variable value);

} // InitVariableJob
