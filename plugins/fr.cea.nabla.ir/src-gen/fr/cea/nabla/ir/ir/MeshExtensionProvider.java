/**
 */
package fr.cea.nabla.ir.ir;

import org.eclipse.emf.common.util.EList;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Mesh Extension Provider</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.MeshExtensionProvider#getItemTypes <em>Item Types</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.MeshExtensionProvider#getConnectivities <em>Connectivities</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getMeshExtensionProvider()
 * @model
 * @generated
 */
public interface MeshExtensionProvider extends ExtensionProvider {
	/**
	 * Returns the value of the '<em><b>Item Types</b></em>' containment reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.ItemType}.
	 * It is bidirectional and its opposite is '{@link fr.cea.nabla.ir.ir.ItemType#getProvider <em>Provider</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Item Types</em>' containment reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getMeshExtensionProvider_ItemTypes()
	 * @see fr.cea.nabla.ir.ir.ItemType#getProvider
	 * @model opposite="provider" containment="true" resolveProxies="true"
	 * @generated
	 */
	EList<ItemType> getItemTypes();

	/**
	 * Returns the value of the '<em><b>Connectivities</b></em>' containment reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.Connectivity}.
	 * It is bidirectional and its opposite is '{@link fr.cea.nabla.ir.ir.Connectivity#getProvider <em>Provider</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Connectivities</em>' containment reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getMeshExtensionProvider_Connectivities()
	 * @see fr.cea.nabla.ir.ir.Connectivity#getProvider
	 * @model opposite="provider" containment="true"
	 * @generated
	 */
	EList<Connectivity> getConnectivities();

} // MeshExtensionProvider
