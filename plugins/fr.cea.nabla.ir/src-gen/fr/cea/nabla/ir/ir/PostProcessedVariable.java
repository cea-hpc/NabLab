/**
 */
package fr.cea.nabla.ir.ir;

import org.eclipse.emf.ecore.EObject;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Post Processed Variable</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.PostProcessedVariable#getTarget <em>Target</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.PostProcessedVariable#getOutputName <em>Output Name</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.PostProcessedVariable#getSupport <em>Support</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getPostProcessedVariable()
 * @model
 * @generated
 */
public interface PostProcessedVariable extends EObject {
	/**
	 * Returns the value of the '<em><b>Target</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Target</em>' reference.
	 * @see #setTarget(Variable)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getPostProcessedVariable_Target()
	 * @model required="true"
	 * @generated
	 */
	Variable getTarget();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.PostProcessedVariable#getTarget <em>Target</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Target</em>' reference.
	 * @see #getTarget()
	 * @generated
	 */
	void setTarget(Variable value);

	/**
	 * Returns the value of the '<em><b>Output Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Output Name</em>' attribute.
	 * @see #setOutputName(String)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getPostProcessedVariable_OutputName()
	 * @model required="true"
	 * @generated
	 */
	String getOutputName();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.PostProcessedVariable#getOutputName <em>Output Name</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Output Name</em>' attribute.
	 * @see #getOutputName()
	 * @generated
	 */
	void setOutputName(String value);

	/**
	 * Returns the value of the '<em><b>Support</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Support</em>' reference.
	 * @see #setSupport(ItemType)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getPostProcessedVariable_Support()
	 * @model
	 * @generated
	 */
	ItemType getSupport();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.PostProcessedVariable#getSupport <em>Support</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Support</em>' reference.
	 * @see #getSupport()
	 * @generated
	 */
	void setSupport(ItemType value);

} // PostProcessedVariable
