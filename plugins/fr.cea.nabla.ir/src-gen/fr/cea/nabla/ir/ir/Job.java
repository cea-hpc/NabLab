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
 *   <li>{@link fr.cea.nabla.ir.ir.Job#getPreviousJobsWithSameCaller <em>Previous Jobs With Same Caller</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.Job#getNextJobsWithSameCaller <em>Next Jobs With Same Caller</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getJob()
 * @model abstract="true"
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
	 * Returns the value of the '<em><b>Previous Jobs With Same Caller</b></em>' reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.Job}.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Previous Jobs With Same Caller</em>' reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getJob_PreviousJobsWithSameCaller()
	 * @model
	 * @generated
	 */
	EList<Job> getPreviousJobsWithSameCaller();

	/**
	 * Returns the value of the '<em><b>Next Jobs With Same Caller</b></em>' reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.Job}.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Next Jobs With Same Caller</em>' reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getJob_NextJobsWithSameCaller()
	 * @model
	 * @generated
	 */
	EList<Job> getNextJobsWithSameCaller();

} // Job
