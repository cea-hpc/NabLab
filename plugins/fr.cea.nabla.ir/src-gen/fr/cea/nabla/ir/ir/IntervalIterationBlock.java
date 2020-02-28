/**
 */
package fr.cea.nabla.ir.ir;


/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Interval Iteration Block</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.IntervalIterationBlock#getIndex <em>Index</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.IntervalIterationBlock#getNbElems <em>Nb Elems</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getIntervalIterationBlock()
 * @model
 * @generated
 */
public interface IntervalIterationBlock extends IterationBlock {
	/**
	 * Returns the value of the '<em><b>Index</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Index</em>' containment reference.
	 * @see #setIndex(SizeTypeSymbol)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getIntervalIterationBlock_Index()
	 * @model containment="true" resolveProxies="true" required="true"
	 * @generated
	 */
	SizeTypeSymbol getIndex();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.IntervalIterationBlock#getIndex <em>Index</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Index</em>' containment reference.
	 * @see #getIndex()
	 * @generated
	 */
	void setIndex(SizeTypeSymbol value);

	/**
	 * Returns the value of the '<em><b>Nb Elems</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Nb Elems</em>' containment reference.
	 * @see #setNbElems(SizeType)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getIntervalIterationBlock_NbElems()
	 * @model containment="true" resolveProxies="true" required="true"
	 * @generated
	 */
	SizeType getNbElems();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.IntervalIterationBlock#getNbElems <em>Nb Elems</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Nb Elems</em>' containment reference.
	 * @see #getNbElems()
	 * @generated
	 */
	void setNbElems(SizeType value);

} // IntervalIterationBlock
