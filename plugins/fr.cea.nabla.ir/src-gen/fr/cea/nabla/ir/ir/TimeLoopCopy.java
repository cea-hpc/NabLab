/**
 */
package fr.cea.nabla.ir.ir;


/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Time Loop Copy</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.TimeLoopCopy#getDestination <em>Destination</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.TimeLoopCopy#getSource <em>Source</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getTimeLoopCopy()
 * @model
 * @generated
 */
public interface TimeLoopCopy extends IrAnnotable {
	/**
	 * Returns the value of the '<em><b>Destination</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Destination</em>' reference.
	 * @see #setDestination(Variable)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getTimeLoopCopy_Destination()
	 * @model required="true"
	 * @generated
	 */
	Variable getDestination();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.TimeLoopCopy#getDestination <em>Destination</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Destination</em>' reference.
	 * @see #getDestination()
	 * @generated
	 */
	void setDestination(Variable value);

	/**
	 * Returns the value of the '<em><b>Source</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Source</em>' reference.
	 * @see #setSource(Variable)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getTimeLoopCopy_Source()
	 * @model required="true"
	 * @generated
	 */
	Variable getSource();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.TimeLoopCopy#getSource <em>Source</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Source</em>' reference.
	 * @see #getSource()
	 * @generated
	 */
	void setSource(Variable value);

} // TimeLoopCopy
