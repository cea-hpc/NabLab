/**
 */
package fr.cea.nabla.ir.ir;


/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Real2x2 Constant</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.Real2x2Constant#getX <em>X</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.Real2x2Constant#getY <em>Y</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getReal2x2Constant()
 * @model
 * @generated
 */
public interface Real2x2Constant extends Expression {
	/**
	 * Returns the value of the '<em><b>X</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>X</em>' containment reference isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>X</em>' containment reference.
	 * @see #setX(Real2Constant)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getReal2x2Constant_X()
	 * @model containment="true" required="true"
	 * @generated
	 */
	Real2Constant getX();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.Real2x2Constant#getX <em>X</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>X</em>' containment reference.
	 * @see #getX()
	 * @generated
	 */
	void setX(Real2Constant value);

	/**
	 * Returns the value of the '<em><b>Y</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Y</em>' containment reference isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Y</em>' containment reference.
	 * @see #setY(Real2Constant)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getReal2x2Constant_Y()
	 * @model containment="true" required="true"
	 * @generated
	 */
	Real2Constant getY();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.Real2x2Constant#getY <em>Y</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Y</em>' containment reference.
	 * @see #getY()
	 * @generated
	 */
	void setY(Real2Constant value);

} // Real2x2Constant
