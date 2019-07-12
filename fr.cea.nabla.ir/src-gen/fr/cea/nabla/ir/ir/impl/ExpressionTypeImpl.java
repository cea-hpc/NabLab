/**
 */
package fr.cea.nabla.ir.ir.impl;

import fr.cea.nabla.ir.ir.Connectivity;
import fr.cea.nabla.ir.ir.ExpressionType;
import fr.cea.nabla.ir.ir.IrPackage;

import java.util.Collection;

import org.eclipse.emf.common.util.EList;

import org.eclipse.emf.ecore.EClass;

import org.eclipse.emf.ecore.util.EObjectResolvingEList;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Expression Type</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.impl.ExpressionTypeImpl#getConnectivities <em>Connectivities</em>}</li>
 * </ul>
 *
 * @generated
 */
public class ExpressionTypeImpl extends BaseTypeImpl implements ExpressionType {
	/**
	 * The cached value of the '{@link #getConnectivities() <em>Connectivities</em>}' reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getConnectivities()
	 * @generated
	 * @ordered
	 */
	protected EList<Connectivity> connectivities;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected ExpressionTypeImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return IrPackage.Literals.EXPRESSION_TYPE;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EList<Connectivity> getConnectivities() {
		if (connectivities == null) {
			connectivities = new EObjectResolvingEList<Connectivity>(Connectivity.class, this, IrPackage.EXPRESSION_TYPE__CONNECTIVITIES);
		}
		return connectivities;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Object eGet(int featureID, boolean resolve, boolean coreType) {
		switch (featureID) {
			case IrPackage.EXPRESSION_TYPE__CONNECTIVITIES:
				return getConnectivities();
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
			case IrPackage.EXPRESSION_TYPE__CONNECTIVITIES:
				getConnectivities().clear();
				getConnectivities().addAll((Collection<? extends Connectivity>)newValue);
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
			case IrPackage.EXPRESSION_TYPE__CONNECTIVITIES:
				getConnectivities().clear();
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
			case IrPackage.EXPRESSION_TYPE__CONNECTIVITIES:
				return connectivities != null && !connectivities.isEmpty();
		}
		return super.eIsSet(featureID);
	}

} //ExpressionTypeImpl
