/**
 */
package fr.cea.nabla.ir.ir;


/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Size Type Operation</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.SizeTypeOperation#getLeft <em>Left</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.SizeTypeOperation#getRight <em>Right</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.SizeTypeOperation#getOperator <em>Operator</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getSizeTypeOperation()
 * @model
 * @generated
 */
public interface SizeTypeOperation extends SizeType {
	/**
	 * Returns the value of the '<em><b>Left</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Left</em>' containment reference.
	 * @see #setLeft(SizeType)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getSizeTypeOperation_Left()
	 * @model containment="true" resolveProxies="true" required="true"
	 * @generated
	 */
	SizeType getLeft();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.SizeTypeOperation#getLeft <em>Left</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Left</em>' containment reference.
	 * @see #getLeft()
	 * @generated
	 */
	void setLeft(SizeType value);

	/**
	 * Returns the value of the '<em><b>Right</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Right</em>' containment reference.
	 * @see #setRight(SizeType)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getSizeTypeOperation_Right()
	 * @model containment="true" resolveProxies="true" required="true"
	 * @generated
	 */
	SizeType getRight();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.SizeTypeOperation#getRight <em>Right</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Right</em>' containment reference.
	 * @see #getRight()
	 * @generated
	 */
	void setRight(SizeType value);

	/**
	 * Returns the value of the '<em><b>Operator</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Operator</em>' attribute.
	 * @see #setOperator(String)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getSizeTypeOperation_Operator()
	 * @model unique="false" required="true"
	 * @generated
	 */
	String getOperator();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.SizeTypeOperation#getOperator <em>Operator</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Operator</em>' attribute.
	 * @see #getOperator()
	 * @generated
	 */
	void setOperator(String value);

} // SizeTypeOperation
