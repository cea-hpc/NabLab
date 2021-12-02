/**
 */
package fr.cea.nabla.ir.ir;

import org.eclipse.emf.common.util.EList;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Job</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.Job#getName <em>Name</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.Job#getAt <em>At</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.Job#isOnCycle <em>On Cycle</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.Job#getCaller <em>Caller</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.Job#getInVars <em>In Vars</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.Job#getOutVars <em>Out Vars</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.Job#getPreviousJobs <em>Previous Jobs</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.Job#getNextJobs <em>Next Jobs</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.Job#getPreviousJobsWithSameCaller <em>Previous Jobs With Same Caller</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.Job#getNextJobsWithSameCaller <em>Next Jobs With Same Caller</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.Job#getInstruction <em>Instruction</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.Job#isTimeLoopJob <em>Time Loop Job</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getJob()
 * @model
 * @generated
 */
public interface Job extends IrAnnotable {
	/**
	 * Returns the value of the '<em><b>Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Name</em>' attribute.
	 * @see #setName(String)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getJob_Name()
	 * @model unique="false" required="true"
	 * @generated
	 */
	String getName();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.Job#getName <em>Name</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Name</em>' attribute.
	 * @see #getName()
	 * @generated
	 */
	void setName(String value);

	/**
	 * Returns the value of the '<em><b>At</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>At</em>' attribute.
	 * @see #setAt(double)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getJob_At()
	 * @model unique="false" required="true"
	 * @generated
	 */
	double getAt();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.Job#getAt <em>At</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>At</em>' attribute.
	 * @see #getAt()
	 * @generated
	 */
	void setAt(double value);

	/**
	 * Returns the value of the '<em><b>On Cycle</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>On Cycle</em>' attribute.
	 * @see #setOnCycle(boolean)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getJob_OnCycle()
	 * @model unique="false" required="true"
	 * @generated
	 */
	boolean isOnCycle();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.Job#isOnCycle <em>On Cycle</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>On Cycle</em>' attribute.
	 * @see #isOnCycle()
	 * @generated
	 */
	void setOnCycle(boolean value);

	/**
	 * Returns the value of the '<em><b>Caller</b></em>' reference.
	 * It is bidirectional and its opposite is '{@link fr.cea.nabla.ir.ir.JobCaller#getCalls <em>Calls</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Caller</em>' reference.
	 * @see #setCaller(JobCaller)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getJob_Caller()
	 * @see fr.cea.nabla.ir.ir.JobCaller#getCalls
	 * @model opposite="calls"
	 * @generated
	 */
	JobCaller getCaller();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.Job#getCaller <em>Caller</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Caller</em>' reference.
	 * @see #getCaller()
	 * @generated
	 */
	void setCaller(JobCaller value);

	/**
	 * Returns the value of the '<em><b>In Vars</b></em>' reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.Variable}.
	 * It is bidirectional and its opposite is '{@link fr.cea.nabla.ir.ir.Variable#getConsumerJobs <em>Consumer Jobs</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>In Vars</em>' reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getJob_InVars()
	 * @see fr.cea.nabla.ir.ir.Variable#getConsumerJobs
	 * @model opposite="consumerJobs"
	 * @generated
	 */
	EList<Variable> getInVars();

	/**
	 * Returns the value of the '<em><b>Out Vars</b></em>' reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.Variable}.
	 * It is bidirectional and its opposite is '{@link fr.cea.nabla.ir.ir.Variable#getProducerJobs <em>Producer Jobs</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Out Vars</em>' reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getJob_OutVars()
	 * @see fr.cea.nabla.ir.ir.Variable#getProducerJobs
	 * @model opposite="producerJobs"
	 * @generated
	 */
	EList<Variable> getOutVars();

	/**
	 * Returns the value of the '<em><b>Previous Jobs</b></em>' reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.Job}.
	 * It is bidirectional and its opposite is '{@link fr.cea.nabla.ir.ir.Job#getNextJobs <em>Next Jobs</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Previous Jobs</em>' reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getJob_PreviousJobs()
	 * @see fr.cea.nabla.ir.ir.Job#getNextJobs
	 * @model opposite="nextJobs"
	 * @generated
	 */
	EList<Job> getPreviousJobs();

	/**
	 * Returns the value of the '<em><b>Next Jobs</b></em>' reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.Job}.
	 * It is bidirectional and its opposite is '{@link fr.cea.nabla.ir.ir.Job#getPreviousJobs <em>Previous Jobs</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Next Jobs</em>' reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getJob_NextJobs()
	 * @see fr.cea.nabla.ir.ir.Job#getPreviousJobs
	 * @model opposite="previousJobs"
	 * @generated
	 */
	EList<Job> getNextJobs();

	/**
	 * Returns the value of the '<em><b>Previous Jobs With Same Caller</b></em>' reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.Job}.
	 * It is bidirectional and its opposite is '{@link fr.cea.nabla.ir.ir.Job#getNextJobsWithSameCaller <em>Next Jobs With Same Caller</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Previous Jobs With Same Caller</em>' reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getJob_PreviousJobsWithSameCaller()
	 * @see fr.cea.nabla.ir.ir.Job#getNextJobsWithSameCaller
	 * @model opposite="nextJobsWithSameCaller"
	 * @generated
	 */
	EList<Job> getPreviousJobsWithSameCaller();

	/**
	 * Returns the value of the '<em><b>Next Jobs With Same Caller</b></em>' reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.Job}.
	 * It is bidirectional and its opposite is '{@link fr.cea.nabla.ir.ir.Job#getPreviousJobsWithSameCaller <em>Previous Jobs With Same Caller</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Next Jobs With Same Caller</em>' reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getJob_NextJobsWithSameCaller()
	 * @see fr.cea.nabla.ir.ir.Job#getPreviousJobsWithSameCaller
	 * @model opposite="previousJobsWithSameCaller"
	 * @generated
	 */
	EList<Job> getNextJobsWithSameCaller();

	/**
	 * Returns the value of the '<em><b>Instruction</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Instruction</em>' containment reference.
	 * @see #setInstruction(Instruction)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getJob_Instruction()
	 * @model containment="true" required="true"
	 * @generated
	 */
	Instruction getInstruction();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.Job#getInstruction <em>Instruction</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Instruction</em>' containment reference.
	 * @see #getInstruction()
	 * @generated
	 */
	void setInstruction(Instruction value);

	/**
	 * Returns the value of the '<em><b>Time Loop Job</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Time Loop Job</em>' attribute.
	 * @see #setTimeLoopJob(boolean)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getJob_TimeLoopJob()
	 * @model
	 * @generated
	 */
	boolean isTimeLoopJob();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.Job#isTimeLoopJob <em>Time Loop Job</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Time Loop Job</em>' attribute.
	 * @see #isTimeLoopJob()
	 * @generated
	 */
	void setTimeLoopJob(boolean value);

} // Job
