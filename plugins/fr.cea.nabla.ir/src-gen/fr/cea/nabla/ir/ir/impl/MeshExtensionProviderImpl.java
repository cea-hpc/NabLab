/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.Connectivity;
import fr.cea.nabla.ir.ir.IrPackage;
import fr.cea.nabla.ir.ir.ItemType;
import fr.cea.nabla.ir.ir.MeshExtensionProvider;

import java.util.Collection;

import org.eclipse.emf.common.notify.NotificationChain;

import org.eclipse.emf.common.util.EList;

import org.eclipse.emf.common.util.EMap;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EStructuralFeature;
import org.eclipse.emf.ecore.EcorePackage;
import org.eclipse.emf.ecore.InternalEObject;

import org.eclipse.emf.ecore.impl.EStringToStringMapEntryImpl;
import org.eclipse.emf.ecore.util.EObjectContainmentWithInverseEList;
import org.eclipse.emf.ecore.util.EcoreEMap;
import org.eclipse.emf.ecore.util.InternalEList;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Mesh Extension Provider</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.MeshExtensionProviderImpl#getItemTypes <em>Item Types</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.MeshExtensionProviderImpl#getConnectivities <em>Connectivities</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.MeshExtensionProviderImpl#getGenerationVariables <em>Generation Variables</em>}</li>
 * </ul>
 *
 * @generated
 */
public class MeshExtensionProviderImpl extends ExtensionProviderImpl implements MeshExtensionProvider {
	/**
	 * The cached value of the '{@link #getItemTypes() <em>Item Types</em>}' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getItemTypes()
	 * @generated
	 * @ordered
	 */
	protected EList<ItemType> itemTypes;

	/**
	 * The cached value of the '{@link #getConnectivities() <em>Connectivities</em>}' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getConnectivities()
	 * @generated
	 * @ordered
	 */
	protected EList<Connectivity> connectivities;

	/**
	 * The cached value of the '{@link #getGenerationVariables() <em>Generation Variables</em>}' map.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getGenerationVariables()
	 * @generated
	 * @ordered
	 */
	protected EMap<String, String> generationVariables;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected MeshExtensionProviderImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return IrPackage.Literals.MESH_EXTENSION_PROVIDER;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public EList<ItemType> getItemTypes() {
		if (itemTypes == null) {
			itemTypes = new EObjectContainmentWithInverseEList.Resolving<ItemType>(ItemType.class, this, IrPackage.MESH_EXTENSION_PROVIDER__ITEM_TYPES, IrPackage.ITEM_TYPE__PROVIDER);
		}
		return itemTypes;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public EList<Connectivity> getConnectivities() {
		if (connectivities == null) {
			connectivities = new EObjectContainmentWithInverseEList<Connectivity>(Connectivity.class, this, IrPackage.MESH_EXTENSION_PROVIDER__CONNECTIVITIES, IrPackage.CONNECTIVITY__PROVIDER);
		}
		return connectivities;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public EMap<String, String> getGenerationVariables() {
		if (generationVariables == null) {
			generationVariables = new EcoreEMap<String,String>(EcorePackage.Literals.ESTRING_TO_STRING_MAP_ENTRY, EStringToStringMapEntryImpl.class, this, IrPackage.MESH_EXTENSION_PROVIDER__GENERATION_VARIABLES);
		}
		return generationVariables;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@SuppressWarnings("unchecked")
	@Override
	public NotificationChain eInverseAdd(InternalEObject otherEnd, int featureID, NotificationChain msgs) {
		switch (featureID) {
			case IrPackage.MESH_EXTENSION_PROVIDER__ITEM_TYPES:
				return ((InternalEList<InternalEObject>)(InternalEList<?>)getItemTypes()).basicAdd(otherEnd, msgs);
			case IrPackage.MESH_EXTENSION_PROVIDER__CONNECTIVITIES:
				return ((InternalEList<InternalEObject>)(InternalEList<?>)getConnectivities()).basicAdd(otherEnd, msgs);
		}
		return super.eInverseAdd(otherEnd, featureID, msgs);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public NotificationChain eInverseRemove(InternalEObject otherEnd, int featureID, NotificationChain msgs) {
		switch (featureID) {
			case IrPackage.MESH_EXTENSION_PROVIDER__ITEM_TYPES:
				return ((InternalEList<?>)getItemTypes()).basicRemove(otherEnd, msgs);
			case IrPackage.MESH_EXTENSION_PROVIDER__CONNECTIVITIES:
				return ((InternalEList<?>)getConnectivities()).basicRemove(otherEnd, msgs);
			case IrPackage.MESH_EXTENSION_PROVIDER__GENERATION_VARIABLES:
				return ((InternalEList<?>)getGenerationVariables()).basicRemove(otherEnd, msgs);
		}
		return super.eInverseRemove(otherEnd, featureID, msgs);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Object eGet(int featureID, boolean resolve, boolean coreType) {
		switch (featureID) {
			case IrPackage.MESH_EXTENSION_PROVIDER__ITEM_TYPES:
				return getItemTypes();
			case IrPackage.MESH_EXTENSION_PROVIDER__CONNECTIVITIES:
				return getConnectivities();
			case IrPackage.MESH_EXTENSION_PROVIDER__GENERATION_VARIABLES:
				if (coreType) return getGenerationVariables();
				else return getGenerationVariables().map();
		}
		return super.eGet(featureID, resolve, coreType);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void eSet(int featureID, Object newValue) {
		switch (featureID) {
			case IrPackage.MESH_EXTENSION_PROVIDER__ITEM_TYPES:
				getItemTypes().clear();
				getItemTypes().addAll((Collection<? extends ItemType>)newValue);
				return;
			case IrPackage.MESH_EXTENSION_PROVIDER__CONNECTIVITIES:
				getConnectivities().clear();
				getConnectivities().addAll((Collection<? extends Connectivity>)newValue);
				return;
			case IrPackage.MESH_EXTENSION_PROVIDER__GENERATION_VARIABLES:
				((EStructuralFeature.Setting)getGenerationVariables()).set(newValue);
				return;
		}
		super.eSet(featureID, newValue);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void eUnset(int featureID) {
		switch (featureID) {
			case IrPackage.MESH_EXTENSION_PROVIDER__ITEM_TYPES:
				getItemTypes().clear();
				return;
			case IrPackage.MESH_EXTENSION_PROVIDER__CONNECTIVITIES:
				getConnectivities().clear();
				return;
			case IrPackage.MESH_EXTENSION_PROVIDER__GENERATION_VARIABLES:
				getGenerationVariables().clear();
				return;
		}
		super.eUnset(featureID);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public boolean eIsSet(int featureID) {
		switch (featureID) {
			case IrPackage.MESH_EXTENSION_PROVIDER__ITEM_TYPES:
				return itemTypes != null && !itemTypes.isEmpty();
			case IrPackage.MESH_EXTENSION_PROVIDER__CONNECTIVITIES:
				return connectivities != null && !connectivities.isEmpty();
			case IrPackage.MESH_EXTENSION_PROVIDER__GENERATION_VARIABLES:
				return generationVariables != null && !generationVariables.isEmpty();
		}
		return super.eIsSet(featureID);
	}

} //MeshExtensionProviderImpl
