/**
 */
package fr.cea.nabla.ir.ir;


/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Execute Time Loop Job</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.ExecuteTimeLoopJob#getWhileCondition <em>While Condition</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.ExecuteTimeLoopJob#getIterationCounter <em>Iteration Counter</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.ExecuteTimeLoopJob#getTimeIterator <em>Time Iterator</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getExecuteTimeLoopJob()
 * @model
 * @generated
 */
public interface ExecuteTimeLoopJob extends JobCaller, Job {
	/**
	 * Returns the value of the '<em><b>While Condition</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>While Condition</em>' containment reference.
	 * @see #setWhileCondition(Expression)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getExecuteTimeLoopJob_WhileCondition()
	 * @model containment="true" resolveProxies="true" required="true"
	 * @generated
	 */
	Expression getWhileCondition();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.ExecuteTimeLoopJob#getWhileCondition <em>While Condition</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>While Condition</em>' containment reference.
	 * @see #getWhileCondition()
	 * @generated
	 */
	void setWhileCondition(Expression value);

	/**
	 * Returns the value of the '<em><b>Iteration Counter</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Iteration Counter</em>' reference.
	 * @see #setIterationCounter(Variable)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getExecuteTimeLoopJob_IterationCounter()
	 * @model required="true"
	 * @generated
	 */
	Variable getIterationCounter();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.ExecuteTimeLoopJob#getIterationCounter <em>Iteration Counter</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Iteration Counter</em>' reference.
	 * @see #getIterationCounter()
	 * @generated
	 */
	void setIterationCounter(Variable value);

	/**
	 * Returns the value of the '<em><b>Time Iterator</b></em>' reference.
	 * It is bidirectional and its opposite is '{@link fr.cea.nabla.ir.ir.TimeIterator#getTimeLoopJob <em>Time Loop Job</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Time Iterator</em>' reference.
	 * @see #setTimeIterator(TimeIterator)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getExecuteTimeLoopJob_TimeIterator()
	 * @see fr.cea.nabla.ir.ir.TimeIterator#getTimeLoopJob
	 * @model opposite="timeLoopJob" required="true"
	 * @generated
	 */
	TimeIterator getTimeIterator();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.ExecuteTimeLoopJob#getTimeIterator <em>Time Iterator</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Time Iterator</em>' reference.
	 * @see #getTimeIterator()
	 * @generated
	 */
	void setTimeIterator(TimeIterator value);

} // ExecuteTimeLoopJob
