/**
 */
package fr.cea.nabla.ir.ir;


/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Size Type Int</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.SizeTypeInt#getValue <em>Value</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getSizeTypeInt()
 * @model
 * @generated
 */
public interface SizeTypeInt extends SizeType {
	/**
	 * Returns the value of the '<em><b>Value</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Value</em>' attribute.
	 * @see #setValue(int)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getSizeTypeInt_Value()
	 * @model unique="false" required="true"
	 * @generated
	 */
	int getValue();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.SizeTypeInt#getValue <em>Value</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Value</em>' attribute.
	 * @see #getValue()
	 * @generated
	 */
	void setValue(int value);

} // SizeTypeInt
