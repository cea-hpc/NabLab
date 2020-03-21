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
	 * Returns the value of the '<em><b>Args</b></em>' reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.ItemId}.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Args</em>' reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getConnectivityCall_Args()
	 * @model resolveProxies="false"
	 * @generated
	 */
	EList<ItemId> getArgs();

} // ConnectivityCall
