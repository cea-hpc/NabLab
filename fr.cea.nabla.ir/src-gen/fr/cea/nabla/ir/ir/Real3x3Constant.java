/**
 */
package fr.cea.nabla.ir.ir;


/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Real3x3 Constant</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.Real3x3Constant#getX <em>X</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.Real3x3Constant#getY <em>Y</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.Real3x3Constant#getZ <em>Z</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getReal3x3Constant()
 * @model
 * @generated
 */
public interface Real3x3Constant extends Expression {
	/**
	 * Returns the value of the '<em><b>X</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>X</em>' containment reference isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>X</em>' containment reference.
	 * @see #setX(Real3Constant)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getReal3x3Constant_X()
	 * @model containment="true" required="true"
	 * @generated
	 */
	Real3Constant getX();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.Real3x3Constant#getX <em>X</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>X</em>' containment reference.
	 * @see #getX()
	 * @generated
	 */
	void setX(Real3Constant value);

	/**
	 * Returns the value of the '<em><b>Y</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Y</em>' containment reference isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Y</em>' containment reference.
	 * @see #setY(Real3Constant)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getReal3x3Constant_Y()
	 * @model containment="true" required="true"
	 * @generated
	 */
	Real3Constant getY();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.Real3x3Constant#getY <em>Y</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Y</em>' containment reference.
	 * @see #getY()
	 * @generated
	 */
	void setY(Real3Constant value);

	/**
	 * Returns the value of the '<em><b>Z</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Z</em>' containment reference isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Z</em>' containment reference.
	 * @see #setZ(Real3Constant)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getReal3x3Constant_Z()
	 * @model containment="true" required="true"
	 * @generated
	 */
	Real3Constant getZ();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.Real3x3Constant#getZ <em>Z</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Z</em>' containment reference.
	 * @see #getZ()
	 * @generated
	 */
	void setZ(Real3Constant value);

} // Real3x3Constant
