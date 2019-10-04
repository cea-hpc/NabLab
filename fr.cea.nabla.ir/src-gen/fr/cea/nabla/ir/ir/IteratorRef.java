/**
 */
package fr.cea.nabla.ir.ir;


/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Iterator Ref</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.IteratorRef#getTarget <em>Target</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.IteratorRef#getShift <em>Shift</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.IteratorRef#getIndexInReferencerList <em>Index In Referencer List</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getIteratorRef()
 * @model abstract="true"
 * @generated
 */
public interface IteratorRef extends IrAnnotable {
	/**
	 * Returns the value of the '<em><b>Target</b></em>' reference.
	 * It is bidirectional and its opposite is '{@link fr.cea.nabla.ir.ir.Iterator#getReferencers <em>Referencers</em>}'.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Target</em>' reference isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Target</em>' reference.
	 * @see #setTarget(Iterator)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getIteratorRef_Target()
	 * @see fr.cea.nabla.ir.ir.Iterator#getReferencers
	 * @model opposite="referencers" required="true"
	 * @generated
	 */
	Iterator getTarget();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.IteratorRef#getTarget <em>Target</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Target</em>' reference.
	 * @see #getTarget()
	 * @generated
	 */
	void setTarget(Iterator value);

	/**
	 * Returns the value of the '<em><b>Shift</b></em>' attribute.
	 * The default value is <code>"0"</code>.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Shift</em>' attribute isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Shift</em>' attribute.
	 * @see #setShift(int)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getIteratorRef_Shift()
	 * @model default="0" required="true"
	 * @generated
	 */
	int getShift();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.IteratorRef#getShift <em>Shift</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Shift</em>' attribute.
	 * @see #getShift()
	 * @generated
	 */
	void setShift(int value);

	/**
	 * Returns the value of the '<em><b>Index In Referencer List</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Index In Referencer List</em>' attribute isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Index In Referencer List</em>' attribute.
	 * @see #setIndexInReferencerList(int)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getIteratorRef_IndexInReferencerList()
	 * @model required="true"
	 * @generated
	 */
	int getIndexInReferencerList();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.IteratorRef#getIndexInReferencerList <em>Index In Referencer List</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Index In Referencer List</em>' attribute.
	 * @see #getIndexInReferencerList()
	 * @generated
	 */
	void setIndexInReferencerList(int value);

} // IteratorRef
