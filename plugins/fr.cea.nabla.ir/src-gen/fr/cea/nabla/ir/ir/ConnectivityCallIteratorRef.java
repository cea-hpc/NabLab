/**
 */
package fr.cea.nabla.ir.ir;


/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Connectivity Call Iterator Ref</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.ConnectivityCallIteratorRef#getReferencedBy <em>Referenced By</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getConnectivityCallIteratorRef()
 * @model
 * @generated
 */
public interface ConnectivityCallIteratorRef extends IteratorRef {
	/**
	 * Returns the value of the '<em><b>Referenced By</b></em>' container reference.
	 * It is bidirectional and its opposite is '{@link fr.cea.nabla.ir.ir.ConnectivityCall#getArgs <em>Args</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Referenced By</em>' container reference.
	 * @see #setReferencedBy(ConnectivityCall)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getConnectivityCallIteratorRef_ReferencedBy()
	 * @see fr.cea.nabla.ir.ir.ConnectivityCall#getArgs
	 * @model opposite="args" required="true" transient="false"
	 * @generated
	 */
	ConnectivityCall getReferencedBy();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.ConnectivityCallIteratorRef#getReferencedBy <em>Referenced By</em>}' container reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Referenced By</em>' container reference.
	 * @see #getReferencedBy()
	 * @generated
	 */
	void setReferencedBy(ConnectivityCall value);

} // ConnectivityCallIteratorRef
