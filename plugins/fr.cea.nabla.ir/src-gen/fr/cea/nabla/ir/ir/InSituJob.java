/**
 */
package fr.cea.nabla.ir.ir;

import org.eclipse.emf.common.util.EList;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>In Situ Job</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.InSituJob#getDumpedVariables <em>Dumped Variables</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.InSituJob#getPeriodValue <em>Period Value</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.InSituJob#getPeriodVariable <em>Period Variable</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.InSituJob#getIterationVariable <em>Iteration Variable</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getInSituJob()
 * @model
 * @generated
 */
public interface InSituJob extends Job {
	/**
	 * Returns the value of the '<em><b>Dumped Variables</b></em>' reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.Variable}.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Dumped Variables</em>' reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getInSituJob_DumpedVariables()
	 * @model
	 * @generated
	 */
	EList<Variable> getDumpedVariables();

	/**
	 * Returns the value of the '<em><b>Period Value</b></em>' attribute.
	 * The default value is <code>"-1.0"</code>.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Period Value</em>' attribute.
	 * @see #setPeriodValue(double)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getInSituJob_PeriodValue()
	 * @model default="-1.0" required="true"
	 * @generated
	 */
	double getPeriodValue();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.InSituJob#getPeriodValue <em>Period Value</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Period Value</em>' attribute.
	 * @see #getPeriodValue()
	 * @generated
	 */
	void setPeriodValue(double value);

	/**
	 * Returns the value of the '<em><b>Period Variable</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Period Variable</em>' reference.
	 * @see #setPeriodVariable(SimpleVariable)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getInSituJob_PeriodVariable()
	 * @model required="true"
	 * @generated
	 */
	SimpleVariable getPeriodVariable();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.InSituJob#getPeriodVariable <em>Period Variable</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Period Variable</em>' reference.
	 * @see #getPeriodVariable()
	 * @generated
	 */
	void setPeriodVariable(SimpleVariable value);

	/**
	 * Returns the value of the '<em><b>Iteration Variable</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Iteration Variable</em>' reference.
	 * @see #setIterationVariable(SimpleVariable)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getInSituJob_IterationVariable()
	 * @model required="true"
	 * @generated
	 */
	SimpleVariable getIterationVariable();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.InSituJob#getIterationVariable <em>Iteration Variable</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Iteration Variable</em>' reference.
	 * @see #getIterationVariable()
	 * @generated
	 */
	void setIterationVariable(SimpleVariable value);

} // InSituJob
