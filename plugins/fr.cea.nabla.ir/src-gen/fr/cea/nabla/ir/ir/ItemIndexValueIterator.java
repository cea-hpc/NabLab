/**
 */
package fr.cea.nabla.ir.ir;


/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Item Index Value Iterator</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.ItemIndexValueIterator#getIterator <em>Iterator</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getItemIndexValueIterator()
 * @model
 * @generated
 */
public interface ItemIndexValueIterator extends ItemIndexValue {
	/**
	 * Returns the value of the '<em><b>Iterator</b></em>' container reference.
	 * It is bidirectional and its opposite is '{@link fr.cea.nabla.ir.ir.Iterator#getIndexValue <em>Index Value</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Iterator</em>' container reference.
	 * @see #setIterator(Iterator)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getItemIndexValueIterator_Iterator()
	 * @see fr.cea.nabla.ir.ir.Iterator#getIndexValue
	 * @model opposite="indexValue" required="true" transient="false"
	 * @generated
	 */
	Iterator getIterator();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.ItemIndexValueIterator#getIterator <em>Iterator</em>}' container reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Iterator</em>' container reference.
	 * @see #getIterator()
	 * @generated
	 */
	void setIterator(Iterator value);

} // ItemIndexValueIterator
