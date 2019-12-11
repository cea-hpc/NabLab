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
 *   <li>{@link fr.cea.nabla.ir.ir.IntervalIterationBlock#getFrom <em>From</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.IntervalIterationBlock#getTo <em>To</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.IntervalIterationBlock#isToIncluded <em>To Included</em>}</li>
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
	 * Returns the value of the '<em><b>From</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>From</em>' containment reference.
	 * @see #setFrom(SizeType)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getIntervalIterationBlock_From()
	 * @model containment="true" resolveProxies="true" required="true"
	 * @generated
	 */
	SizeType getFrom();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.IntervalIterationBlock#getFrom <em>From</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>From</em>' containment reference.
	 * @see #getFrom()
	 * @generated
	 */
	void setFrom(SizeType value);

	/**
	 * Returns the value of the '<em><b>To</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>To</em>' containment reference.
	 * @see #setTo(SizeType)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getIntervalIterationBlock_To()
	 * @model containment="true" resolveProxies="true" required="true"
	 * @generated
	 */
	SizeType getTo();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.IntervalIterationBlock#getTo <em>To</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>To</em>' containment reference.
	 * @see #getTo()
	 * @generated
	 */
	void setTo(SizeType value);

	/**
	 * Returns the value of the '<em><b>To Included</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>To Included</em>' attribute.
	 * @see #setToIncluded(boolean)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getIntervalIterationBlock_ToIncluded()
	 * @model required="true"
	 * @generated
	 */
	boolean isToIncluded();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.IntervalIterationBlock#isToIncluded <em>To Included</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>To Included</em>' attribute.
	 * @see #isToIncluded()
	 * @generated
	 */
	void setToIncluded(boolean value);

} // IntervalIterationBlock
