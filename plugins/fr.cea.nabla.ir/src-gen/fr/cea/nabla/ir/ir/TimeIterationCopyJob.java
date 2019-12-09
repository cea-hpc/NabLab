/**
 */
package fr.cea.nabla.ir.ir;


/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Time Iteration Copy Job</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.TimeIterationCopyJob#getLeft <em>Left</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.TimeIterationCopyJob#getRight <em>Right</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.TimeIterationCopyJob#getTimeIteratorName <em>Time Iterator Name</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getTimeIterationCopyJob()
 * @model abstract="true"
 * @generated
 */
public interface TimeIterationCopyJob extends Job {
	/**
	 * Returns the value of the '<em><b>Left</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Left</em>' reference isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Left</em>' reference.
	 * @see #setLeft(Variable)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getTimeIterationCopyJob_Left()
	 * @model required="true"
	 * @generated
	 */
	Variable getLeft();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.TimeIterationCopyJob#getLeft <em>Left</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Left</em>' reference.
	 * @see #getLeft()
	 * @generated
	 */
	void setLeft(Variable value);

	/**
	 * Returns the value of the '<em><b>Right</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Right</em>' reference isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Right</em>' reference.
	 * @see #setRight(Variable)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getTimeIterationCopyJob_Right()
	 * @model required="true"
	 * @generated
	 */
	Variable getRight();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.TimeIterationCopyJob#getRight <em>Right</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Right</em>' reference.
	 * @see #getRight()
	 * @generated
	 */
	void setRight(Variable value);

	/**
	 * Returns the value of the '<em><b>Time Iterator Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Time Iterator Name</em>' attribute isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Time Iterator Name</em>' attribute.
	 * @see #setTimeIteratorName(String)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getTimeIterationCopyJob_TimeIteratorName()
	 * @model unique="false" required="true"
	 * @generated
	 */
	String getTimeIteratorName();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.TimeIterationCopyJob#getTimeIteratorName <em>Time Iterator Name</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Time Iterator Name</em>' attribute.
	 * @see #getTimeIteratorName()
	 * @generated
	 */
	void setTimeIteratorName(String value);

} // TimeIterationCopyJob
