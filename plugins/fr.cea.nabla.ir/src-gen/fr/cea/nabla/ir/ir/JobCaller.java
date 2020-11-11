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

} // JobCaller
