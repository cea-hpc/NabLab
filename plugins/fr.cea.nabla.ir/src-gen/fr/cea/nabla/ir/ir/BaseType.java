/**
 */
package fr.cea.nabla.ir.ir;

import org.eclipse.emf.common.util.EList;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Base Type</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.BaseType#getPrimitive <em>Primitive</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.BaseType#getSizes <em>Sizes</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.BaseType#getIntSizes <em>Int Sizes</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.BaseType#isIsStatic <em>Is Static</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getBaseType()
 * @model
 * @generated
 */
public interface BaseType extends IrType {
	/**
	 * Returns the value of the '<em><b>Primitive</b></em>' attribute.
	 * The literals are from the enumeration {@link fr.cea.nabla.ir.ir.PrimitiveType}.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Primitive</em>' attribute.
	 * @see fr.cea.nabla.ir.ir.PrimitiveType
	 * @see #setPrimitive(PrimitiveType)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getBaseType_Primitive()
	 * @model required="true"
	 * @generated
	 */
	PrimitiveType getPrimitive();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.BaseType#getPrimitive <em>Primitive</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Primitive</em>' attribute.
	 * @see fr.cea.nabla.ir.ir.PrimitiveType
	 * @see #getPrimitive()
	 * @generated
	 */
	void setPrimitive(PrimitiveType value);

	/**
	 * Returns the value of the '<em><b>Sizes</b></em>' containment reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.Expression}.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Sizes</em>' containment reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getBaseType_Sizes()
	 * @model containment="true" resolveProxies="true"
	 * @generated
	 */
	EList<Expression> getSizes();

	/**
	 * Returns the value of the '<em><b>Int Sizes</b></em>' attribute list.
	 * The list contents are of type {@link java.lang.Integer}.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Int Sizes</em>' attribute list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getBaseType_IntSizes()
	 * @model unique="false"
	 * @generated
	 */
	EList<Integer> getIntSizes();

	/**
	 * Returns the value of the '<em><b>Is Static</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Is Static</em>' attribute.
	 * @see #setIsStatic(boolean)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getBaseType_IsStatic()
	 * @model required="true"
	 * @generated
	 */
	boolean isIsStatic();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.BaseType#isIsStatic <em>Is Static</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Is Static</em>' attribute.
	 * @see #isIsStatic()
	 * @generated
	 */
	void setIsStatic(boolean value);

} // BaseType
