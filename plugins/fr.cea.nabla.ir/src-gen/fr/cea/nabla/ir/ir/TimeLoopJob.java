/**
 */
package fr.cea.nabla.ir.ir;

import org.eclipse.emf.common.util.EList;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Time Loop Job</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.TimeLoopJob#getJobs <em>Jobs</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getTimeLoopJob()
 * @model
 * @generated
 */
public interface TimeLoopJob extends TimeLoopCopyJob {
	/**
	 * Returns the value of the '<em><b>Jobs</b></em>' reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.Job}.
	 * It is bidirectional and its opposite is '{@link fr.cea.nabla.ir.ir.Job#getJobContainer <em>Job Container</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Jobs</em>' reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getTimeLoopJob_Jobs()
	 * @see fr.cea.nabla.ir.ir.Job#getJobContainer
	 * @model opposite="jobContainer"
	 * @generated
	 */
	EList<Job> getJobs();

} // TimeLoopJob
