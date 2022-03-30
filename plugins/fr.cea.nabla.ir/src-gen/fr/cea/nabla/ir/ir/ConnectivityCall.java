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
 *   <li>{@link fr.cea.nabla.ir.ir.ConnectivityCall#getGroup <em>Group</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.ConnectivityCall#isIndexEqualId <em>Index Equal Id</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getConnectivityCall()
 * @model
 * @generated
 */
public interface ConnectivityCall extends Container {
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

	/**
	 * Returns the value of the '<em><b>Group</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Group</em>' attribute.
	 * @see #setGroup(String)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getConnectivityCall_Group()
	 * @model
	 * @generated
	 */
	String getGroup();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.ConnectivityCall#getGroup <em>Group</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Group</em>' attribute.
	 * @see #getGroup()
	 * @generated
	 */
	void setGroup(String value);

	/**
	 * Returns the value of the '<em><b>Index Equal Id</b></em>' attribute.
	 * The default value is <code>"false"</code>.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Index Equal Id</em>' attribute.
	 * @see #setIndexEqualId(boolean)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getConnectivityCall_IndexEqualId()
	 * @model default="false" required="true"
	 * @generated
	 */
	boolean isIndexEqualId();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.ConnectivityCall#isIndexEqualId <em>Index Equal Id</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Index Equal Id</em>' attribute.
	 * @see #isIndexEqualId()
	 * @generated
	 */
	void setIndexEqualId(boolean value);

} // ConnectivityCall
