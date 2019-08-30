/**
 */
package fr.cea.nabla.ir.ir;

import org.eclipse.emf.common.util.EList;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Int Vector Constant</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.IntVectorConstant#getValues <em>Values</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getIntVectorConstant()
 * @model
 * @generated
 */
public interface IntVectorConstant extends Expression {
	/**
	 * Returns the value of the '<em><b>Values</b></em>' attribute list.
	 * The list contents are of type {@link java.lang.Integer}.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Values</em>' attribute list isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Values</em>' attribute list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getIntVectorConstant_Values()
	 * @model unique="false"
	 * @generated
	 */
	EList<Integer> getValues();

} // IntVectorConstant
