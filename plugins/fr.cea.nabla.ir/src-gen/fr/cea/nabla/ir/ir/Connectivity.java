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
 *   <li>{@link fr.cea.nabla.ir.ir.Connectivity#isMultiple <em>Multiple</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.Connectivity#getProvider <em>Provider</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.Connectivity#isLocal <em>Local</em>}</li>
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

	/**
	 * Returns the value of the '<em><b>Provider</b></em>' container reference.
	 * It is bidirectional and its opposite is '{@link fr.cea.nabla.ir.ir.MeshExtensionProvider#getConnectivities <em>Connectivities</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Provider</em>' container reference.
	 * @see #setProvider(MeshExtensionProvider)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getConnectivity_Provider()
	 * @see fr.cea.nabla.ir.ir.MeshExtensionProvider#getConnectivities
	 * @model opposite="connectivities" required="true" transient="false"
	 * @generated
	 */
	MeshExtensionProvider getProvider();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.Connectivity#getProvider <em>Provider</em>}' container reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Provider</em>' container reference.
	 * @see #getProvider()
	 * @generated
	 */
	void setProvider(MeshExtensionProvider value);

	/**
	 * Returns the value of the '<em><b>Local</b></em>' attribute.
	 * The default value is <code>"true"</code>.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Local</em>' attribute.
	 * @see #setLocal(boolean)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getConnectivity_Local()
	 * @model default="true" required="true"
	 * @generated
	 */
	boolean isLocal();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.Connectivity#isLocal <em>Local</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Local</em>' attribute.
	 * @see #isLocal()
	 * @generated
	 */
	void setLocal(boolean value);

} // Connectivity
