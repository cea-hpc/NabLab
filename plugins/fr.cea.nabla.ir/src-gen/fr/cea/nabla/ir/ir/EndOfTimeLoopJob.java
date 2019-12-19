/**
 */
package fr.cea.nabla.ir.ir;

import org.eclipse.emf.common.util.EList;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>End Of Time Loop Job</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.EndOfTimeLoopJob#getBegin <em>Begin</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.EndOfTimeLoopJob#getNextLoopCopies <em>Next Loop Copies</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.EndOfTimeLoopJob#getExitLoopCopies <em>Exit Loop Copies</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.EndOfTimeLoopJob#getWhileCondition <em>While Condition</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getEndOfTimeLoopJob()
 * @model
 * @generated
 */
public interface EndOfTimeLoopJob extends Job {
	/**
	 * Returns the value of the '<em><b>Begin</b></em>' reference.
	 * It is bidirectional and its opposite is '{@link fr.cea.nabla.ir.ir.BeginOfTimeLoopJob#getEnd <em>End</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Begin</em>' reference.
	 * @see #setBegin(BeginOfTimeLoopJob)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getEndOfTimeLoopJob_Begin()
	 * @see fr.cea.nabla.ir.ir.BeginOfTimeLoopJob#getEnd
	 * @model opposite="end" required="true"
	 * @generated
	 */
	BeginOfTimeLoopJob getBegin();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.EndOfTimeLoopJob#getBegin <em>Begin</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Begin</em>' reference.
	 * @see #getBegin()
	 * @generated
	 */
	void setBegin(BeginOfTimeLoopJob value);

	/**
	 * Returns the value of the '<em><b>Next Loop Copies</b></em>' containment reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.TimeLoopCopy}.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Next Loop Copies</em>' containment reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getEndOfTimeLoopJob_NextLoopCopies()
	 * @model containment="true" resolveProxies="true"
	 * @generated
	 */
	EList<TimeLoopCopy> getNextLoopCopies();

	/**
	 * Returns the value of the '<em><b>Exit Loop Copies</b></em>' containment reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.TimeLoopCopy}.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Exit Loop Copies</em>' containment reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getEndOfTimeLoopJob_ExitLoopCopies()
	 * @model containment="true" resolveProxies="true"
	 * @generated
	 */
	EList<TimeLoopCopy> getExitLoopCopies();

	/**
	 * Returns the value of the '<em><b>While Condition</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>While Condition</em>' containment reference.
	 * @see #setWhileCondition(Expression)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getEndOfTimeLoopJob_WhileCondition()
	 * @model containment="true" resolveProxies="true" required="true"
	 * @generated
	 */
	Expression getWhileCondition();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.EndOfTimeLoopJob#getWhileCondition <em>While Condition</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>While Condition</em>' containment reference.
	 * @see #getWhileCondition()
	 * @generated
	 */
	void setWhileCondition(Expression value);

} // EndOfTimeLoopJob
