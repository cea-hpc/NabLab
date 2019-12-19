/**
 */
package fr.cea.nabla.ir.ir;

import org.eclipse.emf.common.util.EList;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Connectivity Type</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.ConnectivityType#getConnectivities <em>Connectivities</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.ConnectivityType#getBase <em>Base</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getConnectivityType()
 * @model
 * @generated
 */
public interface ConnectivityType extends IrType {
	/**
	 * Returns the value of the '<em><b>Connectivities</b></em>' reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.Connectivity}.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Connectivities</em>' reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getConnectivityType_Connectivities()
	 * @model
	 * @generated
	 */
	EList<Connectivity> getConnectivities();

	/**
	 * Returns the value of the '<em><b>Base</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Base</em>' containment reference.
	 * @see #setBase(BaseType)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getConnectivityType_Base()
	 * @model containment="true" resolveProxies="true" required="true"
	 * @generated
	 */
	BaseType getBase();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.ConnectivityType#getBase <em>Base</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Base</em>' containment reference.
	 * @see #getBase()
	 * @generated
	 */
	void setBase(BaseType value);

} // ConnectivityType
