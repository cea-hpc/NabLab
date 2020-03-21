/**
 */
package fr.cea.nabla.ir.ir;


/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Item Id Value Call</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.ItemIdValueCall#getCall <em>Call</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getItemIdValueCall()
 * @model
 * @generated
 */
public interface ItemIdValueCall extends ItemIdValue {
	/**
	 * Returns the value of the '<em><b>Call</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Call</em>' containment reference.
	 * @see #setCall(ConnectivityCall)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getItemIdValueCall_Call()
	 * @model containment="true" resolveProxies="true" required="true"
	 * @generated
	 */
	ConnectivityCall getCall();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.ItemIdValueCall#getCall <em>Call</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Call</em>' containment reference.
	 * @see #getCall()
	 * @generated
	 */
	void setCall(ConnectivityCall value);

} // ItemIdValueCall
