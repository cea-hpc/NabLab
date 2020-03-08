/**
 */
package fr.cea.nabla.ir.ir;


/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Unique Id</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.IrUniqueId#getName <em>Name</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.IrUniqueId#getDefaultValueIndex <em>Default Value Index</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.IrUniqueId#getShift <em>Shift</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getIrUniqueId()
 * @model
 * @generated
 */
public interface IrUniqueId extends IrAnnotable {
	/**
	 * Returns the value of the '<em><b>Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Name</em>' attribute.
	 * @see #setName(String)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getIrUniqueId_Name()
	 * @model required="true"
	 * @generated
	 */
	String getName();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.IrUniqueId#getName <em>Name</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Name</em>' attribute.
	 * @see #getName()
	 * @generated
	 */
	void setName(String value);

	/**
	 * Returns the value of the '<em><b>Default Value Index</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Default Value Index</em>' reference.
	 * @see #setDefaultValueIndex(IrIndex)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getIrUniqueId_DefaultValueIndex()
	 * @model
	 * @generated
	 */
	IrIndex getDefaultValueIndex();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.IrUniqueId#getDefaultValueIndex <em>Default Value Index</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Default Value Index</em>' reference.
	 * @see #getDefaultValueIndex()
	 * @generated
	 */
	void setDefaultValueIndex(IrIndex value);

	/**
	 * Returns the value of the '<em><b>Shift</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Shift</em>' attribute.
	 * @see #setShift(int)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getIrUniqueId_Shift()
	 * @model required="true"
	 * @generated
	 */
	int getShift();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.IrUniqueId#getShift <em>Shift</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Shift</em>' attribute.
	 * @see #getShift()
	 * @generated
	 */
	void setShift(int value);

} // IrUniqueId
