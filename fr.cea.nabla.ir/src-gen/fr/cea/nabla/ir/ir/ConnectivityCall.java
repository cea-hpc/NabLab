/**
 */
package fr.cea.nabla.ir.ir;

import org.eclipse.emf.common.util.EList;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Connectivity Call</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.ConnectivityCall#getConnectivity <em>Connectivity</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.ConnectivityCall#getArgs <em>Args</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getConnectivityCall()
 * @model
 * @generated
 */
public interface ConnectivityCall extends IrAnnotable {
	/**
	 * Returns the value of the '<em><b>Connectivity</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Connectivity</em>' reference isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Connectivity</em>' reference.
	 * @see #setConnectivity(Connectivity)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getConnectivityCall_Connectivity()
	 * @model required="true"
	 * @generated
	 */
	Connectivity getConnectivity();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.ConnectivityCall#getConnectivity <em>Connectivity</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Connectivity</em>' reference.
	 * @see #getConnectivity()
	 * @generated
	 */
	void setConnectivity(Connectivity value);

	/**
	 * Returns the value of the '<em><b>Args</b></em>' containment reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.ConnectivityCallIteratorRef}.
	 * It is bidirectional and its opposite is '{@link fr.cea.nabla.ir.ir.ConnectivityCallIteratorRef#getReferencedBy <em>Referenced By</em>}'.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Args</em>' containment reference list isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Args</em>' containment reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getConnectivityCall_Args()
	 * @see fr.cea.nabla.ir.ir.ConnectivityCallIteratorRef#getReferencedBy
	 * @model opposite="referencedBy" containment="true"
	 * @generated
	 */
	EList<ConnectivityCallIteratorRef> getArgs();

} // ConnectivityCall
