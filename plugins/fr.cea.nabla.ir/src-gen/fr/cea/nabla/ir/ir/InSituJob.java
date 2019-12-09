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
 *   <li>{@link fr.cea.nabla.ir.ir.InSituJob#getVariables <em>Variables</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.InSituJob#getIterationPeriod <em>Iteration Period</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.InSituJob#getTimeStep <em>Time Step</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getInSituJob()
 * @model
 * @generated
 */
public interface InSituJob extends Job {
	/**
	 * Returns the value of the '<em><b>Variables</b></em>' reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.Variable}.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Variables</em>' reference list isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Variables</em>' reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getInSituJob_Variables()
	 * @model
	 * @generated
	 */
	EList<Variable> getVariables();

	/**
	 * Returns the value of the '<em><b>Iteration Period</b></em>' attribute.
	 * The default value is <code>"-1"</code>.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Iteration Period</em>' attribute isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Iteration Period</em>' attribute.
	 * @see #setIterationPeriod(int)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getInSituJob_IterationPeriod()
	 * @model default="-1" required="true"
	 * @generated
	 */
	int getIterationPeriod();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.InSituJob#getIterationPeriod <em>Iteration Period</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Iteration Period</em>' attribute.
	 * @see #getIterationPeriod()
	 * @generated
	 */
	void setIterationPeriod(int value);

	/**
	 * Returns the value of the '<em><b>Time Step</b></em>' attribute.
	 * The default value is <code>"-1.0"</code>.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Time Step</em>' attribute isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Time Step</em>' attribute.
	 * @see #setTimeStep(double)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getInSituJob_TimeStep()
	 * @model default="-1.0" required="true"
	 * @generated
	 */
	double getTimeStep();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.InSituJob#getTimeStep <em>Time Step</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Time Step</em>' attribute.
	 * @see #getTimeStep()
	 * @generated
	 */
	void setTimeStep(double value);

} // InSituJob
