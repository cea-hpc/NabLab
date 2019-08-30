/**
 */
package fr.cea.nabla.ir.ir;

import org.eclipse.emf.common.util.EList;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Int Matrix Constant</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.IntMatrixConstant#getValues <em>Values</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getIntMatrixConstant()
 * @model
 * @generated
 */
public interface IntMatrixConstant extends Expression {
	/**
	 * Returns the value of the '<em><b>Values</b></em>' containment reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.IntVectorConstant}.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Values</em>' containment reference list isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Values</em>' containment reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getIntMatrixConstant_Values()
	 * @model containment="true" resolveProxies="true"
	 * @generated
	 */
	EList<IntVectorConstant> getValues();

} // IntMatrixConstant
