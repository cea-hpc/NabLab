/**
 */
package fr.cea.nabla.ir.ir;


/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Item Id Value Iterator</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.ItemIdValueIterator#getIterator <em>Iterator</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.ItemIdValueIterator#getShift <em>Shift</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getItemIdValueIterator()
 * @model
 * @generated
 */
public interface ItemIdValueIterator extends ItemIdValue {
	/**
	 * Returns the value of the '<em><b>Iterator</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Iterator</em>' reference.
	 * @see #setIterator(Iterator)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getItemIdValueIterator_Iterator()
	 * @model required="true"
	 * @generated
	 */
	Iterator getIterator();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.ItemIdValueIterator#getIterator <em>Iterator</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Iterator</em>' reference.
	 * @see #getIterator()
	 * @generated
	 */
	void setIterator(Iterator value);

	/**
	 * Returns the value of the '<em><b>Shift</b></em>' attribute.
	 * The default value is <code>"0"</code>.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Shift</em>' attribute.
	 * @see #setShift(int)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getItemIdValueIterator_Shift()
	 * @model default="0" required="true"
	 * @generated
	 */
	int getShift();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.ItemIdValueIterator#getShift <em>Shift</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Shift</em>' attribute.
	 * @see #getShift()
	 * @generated
	 */
	void setShift(int value);

} // ItemIdValueIterator
