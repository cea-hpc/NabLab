/**
 */
package fr.cea.nabla.ir.ir;


/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Size Type Symbol Ref</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.SizeTypeSymbolRef#getTarget <em>Target</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getSizeTypeSymbolRef()
 * @model
 * @generated
 */
public interface SizeTypeSymbolRef extends SizeType {
	/**
	 * Returns the value of the '<em><b>Target</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Target</em>' reference.
	 * @see #setTarget(SizeTypeSymbol)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getSizeTypeSymbolRef_Target()
	 * @model required="true" ordered="false"
	 * @generated
	 */
	SizeTypeSymbol getTarget();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.SizeTypeSymbolRef#getTarget <em>Target</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Target</em>' reference.
	 * @see #getTarget()
	 * @generated
	 */
	void setTarget(SizeTypeSymbol value);

} // SizeTypeSymbolRef
