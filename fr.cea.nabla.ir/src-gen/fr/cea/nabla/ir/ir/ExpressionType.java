/**
 */
package fr.cea.nabla.ir.ir;

import org.eclipse.emf.common.util.EList;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Expression Type</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.ExpressionType#getConnectivities <em>Connectivities</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getExpressionType()
 * @model
 * @generated
 */
public interface ExpressionType extends BaseType {
	/**
	 * Returns the value of the '<em><b>Connectivities</b></em>' reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.Connectivity}.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Connectivities</em>' reference list isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Connectivities</em>' reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getExpressionType_Connectivities()
	 * @model
	 * @generated
	 */
	EList<Connectivity> getConnectivities();

} // ExpressionType
