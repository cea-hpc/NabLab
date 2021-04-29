/**
 */
package fr.cea.nabla.ir.ir;

import org.eclipse.emf.common.util.EList;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Job Caller</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.JobCaller#getCalls <em>Calls</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.JobCaller#getAllInVars <em>All In Vars</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.JobCaller#getAllOutVars <em>All Out Vars</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getJobCaller()
 * @model
 * @generated
 */
public interface JobCaller extends IrAnnotable {
	/**
	 * Returns the value of the '<em><b>Calls</b></em>' reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.Job}.
	 * It is bidirectional and its opposite is '{@link fr.cea.nabla.ir.ir.Job#getCaller <em>Caller</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Calls</em>' reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getJobCaller_Calls()
	 * @see fr.cea.nabla.ir.ir.Job#getCaller
	 * @model opposite="caller"
	 * @generated
	 */
	EList<Job> getCalls();

	/**
	 * Returns the value of the '<em><b>All In Vars</b></em>' reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.Variable}.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>All In Vars</em>' reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getJobCaller_AllInVars()
	 * @model
	 * @generated
	 */
	EList<Variable> getAllInVars();

	/**
	 * Returns the value of the '<em><b>All Out Vars</b></em>' reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.Variable}.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>All Out Vars</em>' reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getJobCaller_AllOutVars()
	 * @model
	 * @generated
	 */
	EList<Variable> getAllOutVars();

} // JobCaller
