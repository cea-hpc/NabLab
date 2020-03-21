/**
 */
package fr.cea.nabla.ir.ir;


/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Item Index Definition</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.ItemIndexDefinition#getIndex <em>Index</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.ItemIndexDefinition#getValue <em>Value</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getItemIndexDefinition()
 * @model
 * @generated
 */
public interface ItemIndexDefinition extends Instruction {
	/**
	 * Returns the value of the '<em><b>Index</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Index</em>' containment reference.
	 * @see #setIndex(ItemIndex)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getItemIndexDefinition_Index()
	 * @model containment="true" resolveProxies="true" required="true"
	 * @generated
	 */
	ItemIndex getIndex();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.ItemIndexDefinition#getIndex <em>Index</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Index</em>' containment reference.
	 * @see #getIndex()
	 * @generated
	 */
	void setIndex(ItemIndex value);

	/**
	 * Returns the value of the '<em><b>Value</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Value</em>' containment reference.
	 * @see #setValue(ItemIndexValueId)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getItemIndexDefinition_Value()
	 * @model containment="true" resolveProxies="true" required="true"
	 * @generated
	 */
	ItemIndexValueId getValue();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.ItemIndexDefinition#getValue <em>Value</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Value</em>' containment reference.
	 * @see #getValue()
	 * @generated
	 */
	void setValue(ItemIndexValueId value);

} // ItemIndexDefinition
