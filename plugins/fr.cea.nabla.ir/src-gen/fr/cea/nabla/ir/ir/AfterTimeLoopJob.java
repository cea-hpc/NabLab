/**
 */
package fr.cea.nabla.ir.ir;


/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>After Time Loop Job</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.AfterTimeLoopJob#getAssociatedTimeLoop <em>Associated Time Loop</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getAfterTimeLoopJob()
 * @model
 * @generated
 */
public interface AfterTimeLoopJob extends TimeLoopCopyJob {

	/**
	 * Returns the value of the '<em><b>Associated Time Loop</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Associated Time Loop</em>' reference.
	 * @see #setAssociatedTimeLoop(TimeLoopJob)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getAfterTimeLoopJob_AssociatedTimeLoop()
	 * @model required="true"
	 * @generated
	 */
	TimeLoopJob getAssociatedTimeLoop();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.AfterTimeLoopJob#getAssociatedTimeLoop <em>Associated Time Loop</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Associated Time Loop</em>' reference.
	 * @see #getAssociatedTimeLoop()
	 * @generated
	 */
	void setAssociatedTimeLoop(TimeLoopJob value);
} // AfterTimeLoopJob
