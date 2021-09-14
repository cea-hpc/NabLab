/**
 */
package fr.cea.nabla.ir.ir;


/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Time Variable</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.TimeVariable#getOriginName <em>Origin Name</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.TimeVariable#getTimeIterator <em>Time Iterator</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.TimeVariable#getTimeIteratorIndex <em>Time Iterator Index</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getTimeVariable()
 * @model
 * @generated
 */
public interface TimeVariable extends Variable {
	/**
	 * Returns the value of the '<em><b>Origin Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Origin Name</em>' attribute.
	 * @see #setOriginName(String)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getTimeVariable_OriginName()
	 * @model required="true"
	 * @generated
	 */
	String getOriginName();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.TimeVariable#getOriginName <em>Origin Name</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Origin Name</em>' attribute.
	 * @see #getOriginName()
	 * @generated
	 */
	void setOriginName(String value);

	/**
	 * Returns the value of the '<em><b>Time Iterator</b></em>' reference.
	 * It is bidirectional and its opposite is '{@link fr.cea.nabla.ir.ir.TimeIterator#getVariables <em>Variables</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Time Iterator</em>' reference.
	 * @see #setTimeIterator(TimeIterator)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getTimeVariable_TimeIterator()
	 * @see fr.cea.nabla.ir.ir.TimeIterator#getVariables
	 * @model opposite="variables"
	 * @generated
	 */
	TimeIterator getTimeIterator();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.TimeVariable#getTimeIterator <em>Time Iterator</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Time Iterator</em>' reference.
	 * @see #getTimeIterator()
	 * @generated
	 */
	void setTimeIterator(TimeIterator value);

	/**
	 * Returns the value of the '<em><b>Time Iterator Index</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Time Iterator Index</em>' attribute.
	 * @see #setTimeIteratorIndex(int)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getTimeVariable_TimeIteratorIndex()
	 * @model
	 * @generated
	 */
	int getTimeIteratorIndex();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.TimeVariable#getTimeIteratorIndex <em>Time Iterator Index</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Time Iterator Index</em>' attribute.
	 * @see #getTimeIteratorIndex()
	 * @generated
	 */
	void setTimeIteratorIndex(int value);

} // TimeVariable
