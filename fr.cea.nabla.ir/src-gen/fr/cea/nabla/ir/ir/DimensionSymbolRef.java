/**
 */
package fr.cea.nabla.ir.ir;


/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Dimension Symbol Ref</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.DimensionSymbolRef#getTarget <em>Target</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getDimensionSymbolRef()
 * @model
 * @generated
 */
public interface DimensionSymbolRef extends Dimension {
	/**
	 * Returns the value of the '<em><b>Target</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Target</em>' reference isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Target</em>' reference.
	 * @see #setTarget(DimensionSymbol)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getDimensionSymbolRef_Target()
	 * @model required="true" ordered="false"
	 * @generated
	 */
	DimensionSymbol getTarget();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.DimensionSymbolRef#getTarget <em>Target</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Target</em>' reference.
	 * @see #getTarget()
	 * @generated
	 */
	void setTarget(DimensionSymbol value);

} // DimensionSymbolRef
