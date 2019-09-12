/**
 */
package fr.cea.nabla.ir.ir;


/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Array1 D</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.Array1D#getSize <em>Size</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getArray1D()
 * @model
 * @generated
 */
public interface Array1D extends BaseType {
	/**
	 * Returns the value of the '<em><b>Size</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Size</em>' attribute isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Size</em>' attribute.
	 * @see #setSize(int)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getArray1D_Size()
	 * @model required="true"
	 * @generated
	 */
	int getSize();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.Array1D#getSize <em>Size</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Size</em>' attribute.
	 * @see #getSize()
	 * @generated
	 */
	void setSize(int value);

} // Array1D
