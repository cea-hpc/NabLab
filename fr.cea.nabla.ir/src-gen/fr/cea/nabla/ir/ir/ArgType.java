/**
 */
package fr.cea.nabla.ir.ir;


/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Arg Type</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.ArgType#getRoot <em>Root</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.ArgType#getArrayDimension <em>Array Dimension</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getArgType()
 * @model
 * @generated
 */
public interface ArgType extends IrAnnotable {
	/**
	 * Returns the value of the '<em><b>Root</b></em>' attribute.
	 * The literals are from the enumeration {@link fr.cea.nabla.ir.ir.PrimitiveType}.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Root</em>' attribute isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Root</em>' attribute.
	 * @see fr.cea.nabla.ir.ir.PrimitiveType
	 * @see #setRoot(PrimitiveType)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getArgType_Root()
	 * @model required="true"
	 * @generated
	 */
	PrimitiveType getRoot();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.ArgType#getRoot <em>Root</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Root</em>' attribute.
	 * @see fr.cea.nabla.ir.ir.PrimitiveType
	 * @see #getRoot()
	 * @generated
	 */
	void setRoot(PrimitiveType value);

	/**
	 * Returns the value of the '<em><b>Array Dimension</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Array Dimension</em>' attribute isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Array Dimension</em>' attribute.
	 * @see #setArrayDimension(int)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getArgType_ArrayDimension()
	 * @model required="true"
	 * @generated
	 */
	int getArrayDimension();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.ArgType#getArrayDimension <em>Array Dimension</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Array Dimension</em>' attribute.
	 * @see #getArrayDimension()
	 * @generated
	 */
	void setArrayDimension(int value);

} // ArgType
