/**
 */
package fr.cea.nabla.ir.ir;

import org.eclipse.emf.common.util.EList;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Default Extension Provider</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.DefaultExtensionProvider#getFunctions <em>Functions</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.DefaultExtensionProvider#isLinearAlgebra <em>Linear Algebra</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getDefaultExtensionProvider()
 * @model
 * @generated
 */
public interface DefaultExtensionProvider extends ExtensionProvider {
	/**
	 * Returns the value of the '<em><b>Functions</b></em>' containment reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.ExternFunction}.
	 * It is bidirectional and its opposite is '{@link fr.cea.nabla.ir.ir.ExternFunction#getProvider <em>Provider</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Functions</em>' containment reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getDefaultExtensionProvider_Functions()
	 * @see fr.cea.nabla.ir.ir.ExternFunction#getProvider
	 * @model opposite="provider" containment="true"
	 * @generated
	 */
	EList<ExternFunction> getFunctions();

	/**
	 * Returns the value of the '<em><b>Linear Algebra</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Linear Algebra</em>' attribute.
	 * @see #setLinearAlgebra(boolean)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getDefaultExtensionProvider_LinearAlgebra()
	 * @model required="true"
	 * @generated
	 */
	boolean isLinearAlgebra();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.DefaultExtensionProvider#isLinearAlgebra <em>Linear Algebra</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Linear Algebra</em>' attribute.
	 * @see #isLinearAlgebra()
	 * @generated
	 */
	void setLinearAlgebra(boolean value);

} // DefaultExtensionProvider
