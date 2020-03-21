/**
 */
package fr.cea.nabla.ir.ir;


/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Iterator</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.Iterator#getIndex <em>Index</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.Iterator#getIndexValue <em>Index Value</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.Iterator#getContainer <em>Container</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getIterator()
 * @model
 * @generated
 */
public interface Iterator extends IterationBlock {
	/**
	 * Returns the value of the '<em><b>Index</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Index</em>' containment reference.
	 * @see #setIndex(ItemIndex)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getIterator_Index()
	 * @model containment="true" resolveProxies="true" required="true"
	 * @generated
	 */
	ItemIndex getIndex();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.Iterator#getIndex <em>Index</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Index</em>' containment reference.
	 * @see #getIndex()
	 * @generated
	 */
	void setIndex(ItemIndex value);

	/**
	 * Returns the value of the '<em><b>Index Value</b></em>' containment reference.
	 * It is bidirectional and its opposite is '{@link fr.cea.nabla.ir.ir.ItemIndexValueIterator#getIterator <em>Iterator</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Index Value</em>' containment reference.
	 * @see #setIndexValue(ItemIndexValueIterator)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getIterator_IndexValue()
	 * @see fr.cea.nabla.ir.ir.ItemIndexValueIterator#getIterator
	 * @model opposite="iterator" containment="true" resolveProxies="true" required="true"
	 * @generated
	 */
	ItemIndexValueIterator getIndexValue();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.Iterator#getIndexValue <em>Index Value</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Index Value</em>' containment reference.
	 * @see #getIndexValue()
	 * @generated
	 */
	void setIndexValue(ItemIndexValueIterator value);

	/**
	 * Returns the value of the '<em><b>Container</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Container</em>' containment reference.
	 * @see #setContainer(ConnectivityCall)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getIterator_Container()
	 * @model containment="true" resolveProxies="true" required="true"
	 * @generated
	 */
	ConnectivityCall getContainer();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.Iterator#getContainer <em>Container</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Container</em>' containment reference.
	 * @see #getContainer()
	 * @generated
	 */
	void setContainer(ConnectivityCall value);

} // Iterator
