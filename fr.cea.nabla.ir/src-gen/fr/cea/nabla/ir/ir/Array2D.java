/**
 */
package fr.cea.nabla.ir.ir;


/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Array2 D</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.Array2D#getNbRows <em>Nb Rows</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.Array2D#getNbCols <em>Nb Cols</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getArray2D()
 * @model
 * @generated
 */
public interface Array2D extends BaseType {
	/**
	 * Returns the value of the '<em><b>Nb Rows</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Nb Rows</em>' attribute isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Nb Rows</em>' attribute.
	 * @see #setNbRows(int)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getArray2D_NbRows()
	 * @model required="true"
	 * @generated
	 */
	int getNbRows();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.Array2D#getNbRows <em>Nb Rows</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Nb Rows</em>' attribute.
	 * @see #getNbRows()
	 * @generated
	 */
	void setNbRows(int value);

	/**
	 * Returns the value of the '<em><b>Nb Cols</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Nb Cols</em>' attribute isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Nb Cols</em>' attribute.
	 * @see #setNbCols(int)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getArray2D_NbCols()
	 * @model required="true"
	 * @generated
	 */
	int getNbCols();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.Array2D#getNbCols <em>Nb Cols</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Nb Cols</em>' attribute.
	 * @see #getNbCols()
	 * @generated
	 */
	void setNbCols(int value);

} // Array2D
