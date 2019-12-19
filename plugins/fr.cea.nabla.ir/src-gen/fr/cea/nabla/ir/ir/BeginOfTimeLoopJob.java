/**
 */
package fr.cea.nabla.ir.ir;

import org.eclipse.emf.common.util.EList;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Begin Of Time Loop Job</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.BeginOfTimeLoopJob#getEnd <em>End</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.BeginOfTimeLoopJob#getInitializations <em>Initializations</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getBeginOfTimeLoopJob()
 * @model
 * @generated
 */
public interface BeginOfTimeLoopJob extends Job {
	/**
	 * Returns the value of the '<em><b>End</b></em>' reference.
	 * It is bidirectional and its opposite is '{@link fr.cea.nabla.ir.ir.EndOfTimeLoopJob#getBegin <em>Begin</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>End</em>' reference.
	 * @see #setEnd(EndOfTimeLoopJob)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getBeginOfTimeLoopJob_End()
	 * @see fr.cea.nabla.ir.ir.EndOfTimeLoopJob#getBegin
	 * @model opposite="begin"
	 * @generated
	 */
	EndOfTimeLoopJob getEnd();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.BeginOfTimeLoopJob#getEnd <em>End</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>End</em>' reference.
	 * @see #getEnd()
	 * @generated
	 */
	void setEnd(EndOfTimeLoopJob value);

	/**
	 * Returns the value of the '<em><b>Initializations</b></em>' containment reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.TimeLoopCopy}.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Initializations</em>' containment reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getBeginOfTimeLoopJob_Initializations()
	 * @model containment="true" resolveProxies="true"
	 * @generated
	 */
	EList<TimeLoopCopy> getInitializations();

} // BeginOfTimeLoopJob
