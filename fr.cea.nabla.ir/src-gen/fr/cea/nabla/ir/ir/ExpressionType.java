/**
 */
package fr.cea.nabla.ir.ir;

import org.eclipse.emf.ecore.EObject;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Expression Type</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.ExpressionType#getBasicType <em>Basic Type</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.ExpressionType#getDimension <em>Dimension</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getExpressionType()
 * @model
 * @generated
 */
public interface ExpressionType extends EObject {
	/**
	 * Returns the value of the '<em><b>Basic Type</b></em>' attribute.
	 * The literals are from the enumeration {@link fr.cea.nabla.ir.ir.BasicType}.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Basic Type</em>' attribute isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Basic Type</em>' attribute.
	 * @see fr.cea.nabla.ir.ir.BasicType
	 * @see #setBasicType(BasicType)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getExpressionType_BasicType()
	 * @model unique="false" required="true"
	 * @generated
	 */
	BasicType getBasicType();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.ExpressionType#getBasicType <em>Basic Type</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Basic Type</em>' attribute.
	 * @see fr.cea.nabla.ir.ir.BasicType
	 * @see #getBasicType()
	 * @generated
	 */
	void setBasicType(BasicType value);

	/**
	 * Returns the value of the '<em><b>Dimension</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Dimension</em>' attribute isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Dimension</em>' attribute.
	 * @see #setDimension(int)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getExpressionType_Dimension()
	 * @model unique="false" required="true"
	 * @generated
	 */
	int getDimension();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.ExpressionType#getDimension <em>Dimension</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Dimension</em>' attribute.
	 * @see #getDimension()
	 * @generated
	 */
	void setDimension(int value);

} // ExpressionType
