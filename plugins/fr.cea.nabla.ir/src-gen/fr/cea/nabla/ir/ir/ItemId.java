/**
 */
package fr.cea.nabla.ir.ir;


/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Item Id</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.ItemId#getName <em>Name</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.ItemId#getItemName <em>Item Name</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getItemId()
 * @model
 * @generated
 */
public interface ItemId extends IrAnnotable {
	/**
	 * Returns the value of the '<em><b>Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Name</em>' attribute.
	 * @see #setName(String)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getItemId_Name()
	 * @model required="true"
	 * @generated
	 */
	String getName();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.ItemId#getName <em>Name</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Name</em>' attribute.
	 * @see #getName()
	 * @generated
	 */
	void setName(String value);

	/**
	 * Returns the value of the '<em><b>Item Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Item Name</em>' attribute.
	 * @see #setItemName(String)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getItemId_ItemName()
	 * @model required="true"
	 * @generated
	 */
	String getItemName();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.ItemId#getItemName <em>Item Name</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Item Name</em>' attribute.
	 * @see #getItemName()
	 * @generated
	 */
	void setItemName(String value);

} // ItemId
