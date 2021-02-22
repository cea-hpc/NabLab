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
 *   <li>{@link fr.cea.nabla.ir.ir.LinearAlgebraType#getProvider <em>Provider</em>}</li>
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

	/**
	 * Returns the value of the '<em><b>Provider</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Provider</em>' reference.
	 * @see #setProvider(ExtensionProvider)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getLinearAlgebraType_Provider()
	 * @model required="true"
	 * @generated
	 */
	ExtensionProvider getProvider();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.LinearAlgebraType#getProvider <em>Provider</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Provider</em>' reference.
	 * @see #getProvider()
	 * @generated
	 */
	void setProvider(ExtensionProvider value);

} // LinearAlgebraType
