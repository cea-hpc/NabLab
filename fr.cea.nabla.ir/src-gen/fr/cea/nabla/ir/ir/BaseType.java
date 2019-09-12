/**
 */
package fr.cea.nabla.ir.ir;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Base Type</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.BaseType#getPrimitive <em>Primitive</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getBaseType()
 * @model abstract="true"
 * @generated
 */
public interface BaseType extends IrType {
	/**
	 * Returns the value of the '<em><b>Primitive</b></em>' attribute.
	 * The literals are from the enumeration {@link fr.cea.nabla.ir.ir.PrimitiveType}.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Primitive</em>' attribute isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Primitive</em>' attribute.
	 * @see fr.cea.nabla.ir.ir.PrimitiveType
	 * @see #setPrimitive(PrimitiveType)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getBaseType_Primitive()
	 * @model required="true"
	 * @generated
	 */
	PrimitiveType getPrimitive();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.BaseType#getPrimitive <em>Primitive</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Primitive</em>' attribute.
	 * @see fr.cea.nabla.ir.ir.PrimitiveType
	 * @see #getPrimitive()
	 * @generated
	 */
	void setPrimitive(PrimitiveType value);

} // BaseType
