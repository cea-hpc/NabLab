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
 *   <li>{@link fr.cea.nabla.ir.ir.Connectivity#isMultiple <em>Multiple</em>}</li>
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
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>In Types</em>' reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getConnectivity_InTypes()
	 * @model
	 * @generated
	 */
	EList<ItemType> getInTypes();

	/**
	 * Returns the value of the '<em><b>Return Type</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Return Type</em>' reference.
	 * @see #setReturnType(ItemType)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getConnectivity_ReturnType()
	 * @model resolveProxies="false"
	 * @generated
	 */
	ItemType getReturnType();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.Connectivity#getReturnType <em>Return Type</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Return Type</em>' reference.
	 * @see #getReturnType()
	 * @generated
	 */
	void setReturnType(ItemType value);

	/**
	 * Returns the value of the '<em><b>Index Equal Id</b></em>' attribute.
	 * The default value is <code>"false"</code>.
	 * <!-- begin-user-doc -->
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

	/**
	 * Returns the value of the '<em><b>Multiple</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Multiple</em>' attribute.
	 * @see #setMultiple(boolean)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getConnectivity_Multiple()
	 * @model unique="false" required="true"
	 * @generated
	 */
	boolean isMultiple();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.Connectivity#isMultiple <em>Multiple</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Multiple</em>' attribute.
	 * @see #isMultiple()
	 * @generated
	 */
	void setMultiple(boolean value);

} // Connectivity
