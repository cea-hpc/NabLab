/**
 */
package fr.cea.nabla.ir.ir;


/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Arg Or Var Ref Iterator Ref</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.ArgOrVarRefIteratorRef#getReferencedBy <em>Referenced By</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getArgOrVarRefIteratorRef()
 * @model
 * @generated
 */
public interface ArgOrVarRefIteratorRef extends IteratorRef {
	/**
	 * Returns the value of the '<em><b>Referenced By</b></em>' container reference.
	 * It is bidirectional and its opposite is '{@link fr.cea.nabla.ir.ir.ArgOrVarRef#getIterators <em>Iterators</em>}'.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Referenced By</em>' container reference isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Referenced By</em>' container reference.
	 * @see #setReferencedBy(ArgOrVarRef)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getArgOrVarRefIteratorRef_ReferencedBy()
	 * @see fr.cea.nabla.ir.ir.ArgOrVarRef#getIterators
	 * @model opposite="iterators" required="true" transient="false"
	 * @generated
	 */
	ArgOrVarRef getReferencedBy();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.ArgOrVarRefIteratorRef#getReferencedBy <em>Referenced By</em>}' container reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Referenced By</em>' container reference.
	 * @see #getReferencedBy()
	 * @generated
	 */
	void setReferencedBy(ArgOrVarRef value);

} // ArgOrVarRefIteratorRef
