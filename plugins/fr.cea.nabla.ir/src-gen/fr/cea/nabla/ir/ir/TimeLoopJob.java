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
 *   <li>{@link fr.cea.nabla.ir.ir.TimeLoopJob#getWhileCondition <em>While Condition</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.TimeLoopJob#getOuterTimeLoop <em>Outer Time Loop</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.TimeLoopJob#getInnerTimeLoop <em>Inner Time Loop</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.TimeLoopJob#getTimeLoopName <em>Time Loop Name</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getTimeLoopJob()
 * @model
 * @generated
 */
public interface TimeLoopJob extends Job {
	/**
	 * Returns the value of the '<em><b>Jobs</b></em>' reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.Job}.
	 * It is bidirectional and its opposite is '{@link fr.cea.nabla.ir.ir.Job#getTimeLoopContainer <em>Time Loop Container</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Jobs</em>' reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getTimeLoopJob_Jobs()
	 * @see fr.cea.nabla.ir.ir.Job#getTimeLoopContainer
	 * @model opposite="timeLoopContainer"
	 * @generated
	 */
	EList<Job> getJobs();

	/**
	 * Returns the value of the '<em><b>While Condition</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>While Condition</em>' containment reference.
	 * @see #setWhileCondition(Expression)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getTimeLoopJob_WhileCondition()
	 * @model containment="true" resolveProxies="true" required="true"
	 * @generated
	 */
	Expression getWhileCondition();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.TimeLoopJob#getWhileCondition <em>While Condition</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>While Condition</em>' containment reference.
	 * @see #getWhileCondition()
	 * @generated
	 */
	void setWhileCondition(Expression value);

	/**
	 * Returns the value of the '<em><b>Outer Time Loop</b></em>' reference.
	 * It is bidirectional and its opposite is '{@link fr.cea.nabla.ir.ir.TimeLoopJob#getInnerTimeLoop <em>Inner Time Loop</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Outer Time Loop</em>' reference.
	 * @see #setOuterTimeLoop(TimeLoopJob)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getTimeLoopJob_OuterTimeLoop()
	 * @see fr.cea.nabla.ir.ir.TimeLoopJob#getInnerTimeLoop
	 * @model opposite="innerTimeLoop"
	 * @generated
	 */
	TimeLoopJob getOuterTimeLoop();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.TimeLoopJob#getOuterTimeLoop <em>Outer Time Loop</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Outer Time Loop</em>' reference.
	 * @see #getOuterTimeLoop()
	 * @generated
	 */
	void setOuterTimeLoop(TimeLoopJob value);

	/**
	 * Returns the value of the '<em><b>Inner Time Loop</b></em>' reference.
	 * It is bidirectional and its opposite is '{@link fr.cea.nabla.ir.ir.TimeLoopJob#getOuterTimeLoop <em>Outer Time Loop</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Inner Time Loop</em>' reference.
	 * @see #setInnerTimeLoop(TimeLoopJob)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getTimeLoopJob_InnerTimeLoop()
	 * @see fr.cea.nabla.ir.ir.TimeLoopJob#getOuterTimeLoop
	 * @model opposite="outerTimeLoop"
	 * @generated
	 */
	TimeLoopJob getInnerTimeLoop();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.TimeLoopJob#getInnerTimeLoop <em>Inner Time Loop</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Inner Time Loop</em>' reference.
	 * @see #getInnerTimeLoop()
	 * @generated
	 */
	void setInnerTimeLoop(TimeLoopJob value);

	/**
	 * Returns the value of the '<em><b>Time Loop Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Time Loop Name</em>' attribute.
	 * @see #setTimeLoopName(String)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getTimeLoopJob_TimeLoopName()
	 * @model required="true"
	 * @generated
	 */
	String getTimeLoopName();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.TimeLoopJob#getTimeLoopName <em>Time Loop Name</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Time Loop Name</em>' attribute.
	 * @see #getTimeLoopName()
	 * @generated
	 */
	void setTimeLoopName(String value);

} // TimeLoopJob
