/**
 */
package fr.cea.nabla.ir.ir;

import org.eclipse.emf.common.util.EList;

import org.eclipse.emf.ecore.EObject;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Base Type</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.BaseType#getRoot <em>Root</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.BaseType#getDimSizes <em>Dim Sizes</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getBaseType()
 * @model
 * @generated
 */
public interface BaseType extends EObject {
	/**
	 * Returns the value of the '<em><b>Root</b></em>' attribute.
	 * The literals are from the enumeration {@link fr.cea.nabla.ir.ir.PrimitiveType}.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Root</em>' attribute isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Root</em>' attribute.
	 * @see fr.cea.nabla.ir.ir.PrimitiveType
	 * @see #setRoot(PrimitiveType)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getBaseType_Root()
	 * @model required="true"
	 * @generated
	 */
	PrimitiveType getRoot();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.BaseType#getRoot <em>Root</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Root</em>' attribute.
	 * @see fr.cea.nabla.ir.ir.PrimitiveType
	 * @see #getRoot()
	 * @generated
	 */
	void setRoot(PrimitiveType value);

	/**
	 * Returns the value of the '<em><b>Dim Sizes</b></em>' attribute list.
	 * The list contents are of type {@link java.lang.Integer}.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Dim Sizes</em>' attribute list isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Dim Sizes</em>' attribute list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getBaseType_DimSizes()
	 * @model
	 * @generated
	 */
	EList<Integer> getDimSizes();

} // BaseType
