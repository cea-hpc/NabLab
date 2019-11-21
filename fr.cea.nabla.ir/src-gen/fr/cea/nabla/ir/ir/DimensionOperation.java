/**
 */
package fr.cea.nabla.ir.ir;


/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Dimension Operation</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.DimensionOperation#getLeft <em>Left</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.DimensionOperation#getRight <em>Right</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.DimensionOperation#getOperator <em>Operator</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getDimensionOperation()
 * @model
 * @generated
 */
public interface DimensionOperation extends Dimension {
	/**
	 * Returns the value of the '<em><b>Left</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Left</em>' containment reference isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Left</em>' containment reference.
	 * @see #setLeft(Dimension)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getDimensionOperation_Left()
	 * @model containment="true" resolveProxies="true" required="true"
	 * @generated
	 */
	Dimension getLeft();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.DimensionOperation#getLeft <em>Left</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Left</em>' containment reference.
	 * @see #getLeft()
	 * @generated
	 */
	void setLeft(Dimension value);

	/**
	 * Returns the value of the '<em><b>Right</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Right</em>' containment reference isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Right</em>' containment reference.
	 * @see #setRight(Dimension)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getDimensionOperation_Right()
	 * @model containment="true" resolveProxies="true" required="true"
	 * @generated
	 */
	Dimension getRight();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.DimensionOperation#getRight <em>Right</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Right</em>' containment reference.
	 * @see #getRight()
	 * @generated
	 */
	void setRight(Dimension value);

	/**
	 * Returns the value of the '<em><b>Operator</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Operator</em>' attribute isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Operator</em>' attribute.
	 * @see #setOperator(String)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getDimensionOperation_Operator()
	 * @model unique="false" required="true"
	 * @generated
	 */
	String getOperator();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.DimensionOperation#getOperator <em>Operator</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Operator</em>' attribute.
	 * @see #getOperator()
	 * @generated
	 */
	void setOperator(String value);

} // DimensionOperation
