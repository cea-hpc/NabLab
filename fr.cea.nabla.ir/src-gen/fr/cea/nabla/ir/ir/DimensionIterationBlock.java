/**
 */
package fr.cea.nabla.ir.ir;


/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Dimension Iteration Block</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.DimensionIterationBlock#getIndex <em>Index</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.DimensionIterationBlock#getFrom <em>From</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.DimensionIterationBlock#getTo <em>To</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.DimensionIterationBlock#isToIncluded <em>To Included</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getDimensionIterationBlock()
 * @model
 * @generated
 */
public interface DimensionIterationBlock extends IterationBlock {
	/**
	 * Returns the value of the '<em><b>Index</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Index</em>' containment reference isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Index</em>' containment reference.
	 * @see #setIndex(DimensionSymbol)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getDimensionIterationBlock_Index()
	 * @model containment="true" resolveProxies="true" required="true"
	 * @generated
	 */
	DimensionSymbol getIndex();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.DimensionIterationBlock#getIndex <em>Index</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Index</em>' containment reference.
	 * @see #getIndex()
	 * @generated
	 */
	void setIndex(DimensionSymbol value);

	/**
	 * Returns the value of the '<em><b>From</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>From</em>' containment reference isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>From</em>' containment reference.
	 * @see #setFrom(Dimension)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getDimensionIterationBlock_From()
	 * @model containment="true" resolveProxies="true" required="true"
	 * @generated
	 */
	Dimension getFrom();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.DimensionIterationBlock#getFrom <em>From</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>From</em>' containment reference.
	 * @see #getFrom()
	 * @generated
	 */
	void setFrom(Dimension value);

	/**
	 * Returns the value of the '<em><b>To</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>To</em>' containment reference isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>To</em>' containment reference.
	 * @see #setTo(Dimension)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getDimensionIterationBlock_To()
	 * @model containment="true" resolveProxies="true" required="true"
	 * @generated
	 */
	Dimension getTo();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.DimensionIterationBlock#getTo <em>To</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>To</em>' containment reference.
	 * @see #getTo()
	 * @generated
	 */
	void setTo(Dimension value);

	/**
	 * Returns the value of the '<em><b>To Included</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>To Included</em>' attribute isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>To Included</em>' attribute.
	 * @see #setToIncluded(boolean)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getDimensionIterationBlock_ToIncluded()
	 * @model required="true"
	 * @generated
	 */
	boolean isToIncluded();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.DimensionIterationBlock#isToIncluded <em>To Included</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>To Included</em>' attribute.
	 * @see #isToIncluded()
	 * @generated
	 */
	void setToIncluded(boolean value);

} // DimensionIterationBlock
