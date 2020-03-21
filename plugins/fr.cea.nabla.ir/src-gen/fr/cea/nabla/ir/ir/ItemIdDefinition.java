/**
 */
package fr.cea.nabla.ir.ir;


/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Item Id Definition</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.ItemIdDefinition#getId <em>Id</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.ItemIdDefinition#getValue <em>Value</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getItemIdDefinition()
 * @model
 * @generated
 */
public interface ItemIdDefinition extends Instruction {
	/**
	 * Returns the value of the '<em><b>Id</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Id</em>' containment reference.
	 * @see #setId(ItemId)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getItemIdDefinition_Id()
	 * @model containment="true" resolveProxies="true" required="true"
	 * @generated
	 */
	ItemId getId();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.ItemIdDefinition#getId <em>Id</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Id</em>' containment reference.
	 * @see #getId()
	 * @generated
	 */
	void setId(ItemId value);

	/**
	 * Returns the value of the '<em><b>Value</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Value</em>' containment reference.
	 * @see #setValue(ItemIdValue)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getItemIdDefinition_Value()
	 * @model containment="true" resolveProxies="true" required="true"
	 * @generated
	 */
	ItemIdValue getValue();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.ItemIdDefinition#getValue <em>Value</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Value</em>' containment reference.
	 * @see #getValue()
	 * @generated
	 */
	void setValue(ItemIdValue value);

} // ItemIdDefinition
