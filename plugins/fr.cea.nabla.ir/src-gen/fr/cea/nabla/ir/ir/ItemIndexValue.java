/**
 */
package fr.cea.nabla.ir.ir;


/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Item Index Value</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.ItemIndexValue#getId <em>Id</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.ItemIndexValue#getContainer <em>Container</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getItemIndexValue()
 * @model
 * @generated
 */
public interface ItemIndexValue extends IrAnnotable {
	/**
	 * Returns the value of the '<em><b>Id</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Id</em>' reference.
	 * @see #setId(ItemId)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getItemIndexValue_Id()
	 * @model required="true"
	 * @generated
	 */
	ItemId getId();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.ItemIndexValue#getId <em>Id</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Id</em>' reference.
	 * @see #getId()
	 * @generated
	 */
	void setId(ItemId value);

	/**
	 * Returns the value of the '<em><b>Container</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Container</em>' containment reference.
	 * @see #setContainer(ConnectivityCall)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getItemIndexValue_Container()
	 * @model containment="true" resolveProxies="true" required="true"
	 * @generated
	 */
	ConnectivityCall getContainer();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.ItemIndexValue#getContainer <em>Container</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Container</em>' containment reference.
	 * @see #getContainer()
	 * @generated
	 */
	void setContainer(ConnectivityCall value);

} // ItemIndexValue
