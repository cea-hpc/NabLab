/**
 */
package fr.cea.nabla.ir.ir;

import org.eclipse.emf.common.util.EList;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Connectivity</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.Connectivity#getName <em>Name</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.Connectivity#getInTypes <em>In Types</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.Connectivity#getReturnType <em>Return Type</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.Connectivity#isIndexEqualId <em>Index Equal Id</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getConnectivity()
 * @model
 * @generated
 */
public interface Connectivity extends IrAnnotable {
	/**
	 * Returns the value of the '<em><b>Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Name</em>' attribute isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Name</em>' attribute.
	 * @see #setName(String)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getConnectivity_Name()
	 * @model unique="false"
	 * @generated
	 */
	String getName();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.Connectivity#getName <em>Name</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Name</em>' attribute.
	 * @see #getName()
	 * @generated
	 */
	void setName(String value);

	/**
	 * Returns the value of the '<em><b>In Types</b></em>' reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.ItemType}.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>In Types</em>' reference list isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>In Types</em>' reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getConnectivity_InTypes()
	 * @model
	 * @generated
	 */
	EList<ItemType> getInTypes();

	/**
	 * Returns the value of the '<em><b>Return Type</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Return Type</em>' containment reference isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Return Type</em>' containment reference.
	 * @see #setReturnType(ItemArgType)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getConnectivity_ReturnType()
	 * @model containment="true"
	 * @generated
	 */
	ItemArgType getReturnType();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.Connectivity#getReturnType <em>Return Type</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Return Type</em>' containment reference.
	 * @see #getReturnType()
	 * @generated
	 */
	void setReturnType(ItemArgType value);

	/**
	 * Returns the value of the '<em><b>Index Equal Id</b></em>' attribute.
	 * The default value is <code>"false"</code>.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Index Equal Id</em>' attribute isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Index Equal Id</em>' attribute.
	 * @see #setIndexEqualId(boolean)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getConnectivity_IndexEqualId()
	 * @model default="false" required="true"
	 * @generated
	 */
	boolean isIndexEqualId();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.Connectivity#isIndexEqualId <em>Index Equal Id</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Index Equal Id</em>' attribute.
	 * @see #isIndexEqualId()
	 * @generated
	 */
	void setIndexEqualId(boolean value);

} // Connectivity
