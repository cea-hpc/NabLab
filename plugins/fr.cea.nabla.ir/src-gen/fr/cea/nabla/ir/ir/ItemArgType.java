/**
 */
package fr.cea.nabla.ir.ir;


/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Item Arg Type</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.ItemArgType#isMultiple <em>Multiple</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.ItemArgType#getType <em>Type</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getItemArgType()
 * @model
 * @generated
 */
public interface ItemArgType extends IrAnnotable {
	/**
	 * Returns the value of the '<em><b>Multiple</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Multiple</em>' attribute.
	 * @see #setMultiple(boolean)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getItemArgType_Multiple()
	 * @model unique="false" required="true"
	 * @generated
	 */
	boolean isMultiple();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.ItemArgType#isMultiple <em>Multiple</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Multiple</em>' attribute.
	 * @see #isMultiple()
	 * @generated
	 */
	void setMultiple(boolean value);

	/**
	 * Returns the value of the '<em><b>Type</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Type</em>' reference.
	 * @see #setType(ItemType)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getItemArgType_Type()
	 * @model required="true"
	 * @generated
	 */
	ItemType getType();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.ItemArgType#getType <em>Type</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Type</em>' reference.
	 * @see #getType()
	 * @generated
	 */
	void setType(ItemType value);

} // ItemArgType
