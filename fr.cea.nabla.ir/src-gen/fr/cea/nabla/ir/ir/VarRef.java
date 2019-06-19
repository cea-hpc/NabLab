/**
 */
package fr.cea.nabla.ir.ir;

import org.eclipse.emf.common.util.EList;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Var Ref</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.VarRef#getVariable <em>Variable</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.VarRef#getIterators <em>Iterators</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.VarRef#getArrayTypeIndices <em>Array Type Indices</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getVarRef()
 * @model
 * @generated
 */
public interface VarRef extends Expression {
	/**
	 * Returns the value of the '<em><b>Variable</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Variable</em>' reference isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Variable</em>' reference.
	 * @see #setVariable(Variable)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getVarRef_Variable()
	 * @model required="true"
	 * @generated
	 */
	Variable getVariable();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.VarRef#getVariable <em>Variable</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Variable</em>' reference.
	 * @see #getVariable()
	 * @generated
	 */
	void setVariable(Variable value);

	/**
	 * Returns the value of the '<em><b>Iterators</b></em>' containment reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.VarRefIteratorRef}.
	 * It is bidirectional and its opposite is '{@link fr.cea.nabla.ir.ir.VarRefIteratorRef#getReferencedBy <em>Referenced By</em>}'.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Iterators</em>' containment reference list isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Iterators</em>' containment reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getVarRef_Iterators()
	 * @see fr.cea.nabla.ir.ir.VarRefIteratorRef#getReferencedBy
	 * @model opposite="referencedBy" containment="true"
	 * @generated
	 */
	EList<VarRefIteratorRef> getIterators();

	/**
	 * Returns the value of the '<em><b>Array Type Indices</b></em>' attribute list.
	 * The list contents are of type {@link java.lang.Integer}.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Array Type Indices</em>' attribute list isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Array Type Indices</em>' attribute list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getVarRef_ArrayTypeIndices()
	 * @model
	 * @generated
	 */
	EList<Integer> getArrayTypeIndices();

} // VarRef
