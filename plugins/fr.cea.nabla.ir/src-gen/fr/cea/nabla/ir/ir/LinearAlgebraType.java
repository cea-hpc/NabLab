/**
 */
package fr.cea.nabla.ir.ir;

import org.eclipse.emf.common.util.EList;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Linear Algebra Type</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.LinearAlgebraType#getSizes <em>Sizes</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getLinearAlgebraType()
 * @model
 * @generated
 */
public interface LinearAlgebraType extends IrType {
	/**
	 * Returns the value of the '<em><b>Sizes</b></em>' containment reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.Expression}.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Sizes</em>' containment reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getLinearAlgebraType_Sizes()
	 * @model containment="true" resolveProxies="true"
	 * @generated
	 */
	EList<Expression> getSizes();

} // LinearAlgebraType
