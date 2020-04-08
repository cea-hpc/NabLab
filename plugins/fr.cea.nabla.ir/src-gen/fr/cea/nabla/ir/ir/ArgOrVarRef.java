/**
 */
package fr.cea.nabla.ir.ir;

import org.eclipse.emf.common.util.EList;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Arg Or Var Ref</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.ArgOrVarRef#getTarget <em>Target</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.ArgOrVarRef#getIterators <em>Iterators</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.ArgOrVarRef#getIndices <em>Indices</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getArgOrVarRef()
 * @model
 * @generated
 */
public interface ArgOrVarRef extends Expression {
	/**
	 * Returns the value of the '<em><b>Target</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Target</em>' reference.
	 * @see #setTarget(ArgOrVar)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getArgOrVarRef_Target()
	 * @model required="true"
	 * @generated
	 */
	ArgOrVar getTarget();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.ArgOrVarRef#getTarget <em>Target</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Target</em>' reference.
	 * @see #getTarget()
	 * @generated
	 */
	void setTarget(ArgOrVar value);

	/**
	 * Returns the value of the '<em><b>Iterators</b></em>' reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.ItemIndex}.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Iterators</em>' reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getArgOrVarRef_Iterators()
	 * @model resolveProxies="false"
	 * @generated
	 */
	EList<ItemIndex> getIterators();

	/**
	 * Returns the value of the '<em><b>Indices</b></em>' containment reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.Expression}.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Indices</em>' containment reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getArgOrVarRef_Indices()
	 * @model containment="true" resolveProxies="true"
	 * @generated
	 */
	EList<Expression> getIndices();

} // ArgOrVarRef
