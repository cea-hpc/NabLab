/**
 */
package fr.cea.nabla.ir.ir;


/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Var Ref Iterator Ref</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.VarRefIteratorRef#getReferencedBy <em>Referenced By</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getVarRefIteratorRef()
 * @model
 * @generated
 */
public interface VarRefIteratorRef extends IteratorRef {
	/**
	 * Returns the value of the '<em><b>Referenced By</b></em>' container reference.
	 * It is bidirectional and its opposite is '{@link fr.cea.nabla.ir.ir.VarRef#getIterators <em>Iterators</em>}'.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Referenced By</em>' container reference isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Referenced By</em>' container reference.
	 * @see #setReferencedBy(VarRef)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getVarRefIteratorRef_ReferencedBy()
	 * @see fr.cea.nabla.ir.ir.VarRef#getIterators
	 * @model opposite="iterators" required="true" transient="false"
	 * @generated
	 */
	VarRef getReferencedBy();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.VarRefIteratorRef#getReferencedBy <em>Referenced By</em>}' container reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Referenced By</em>' container reference.
	 * @see #getReferencedBy()
	 * @generated
	 */
	void setReferencedBy(VarRef value);

} // VarRefIteratorRef
