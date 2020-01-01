/**
 */
package fr.cea.nabla.ir.ir;

import org.eclipse.emf.common.util.EList;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Time Loop Copy Job</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.TimeLoopCopyJob#getCopies <em>Copies</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.TimeLoopCopyJob#getTimeLoop <em>Time Loop</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getTimeLoopCopyJob()
 * @model abstract="true"
 * @generated
 */
public interface TimeLoopCopyJob extends Job {
	/**
	 * Returns the value of the '<em><b>Copies</b></em>' containment reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.TimeLoopCopy}.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Copies</em>' containment reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getTimeLoopCopyJob_Copies()
	 * @model containment="true" resolveProxies="true"
	 * @generated
	 */
	EList<TimeLoopCopy> getCopies();

	/**
	 * Returns the value of the '<em><b>Time Loop</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Time Loop</em>' reference.
	 * @see #setTimeLoop(TimeLoop)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getTimeLoopCopyJob_TimeLoop()
	 * @model required="true"
	 * @generated
	 */
	TimeLoop getTimeLoop();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.TimeLoopCopyJob#getTimeLoop <em>Time Loop</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Time Loop</em>' reference.
	 * @see #getTimeLoop()
	 * @generated
	 */
	void setTimeLoop(TimeLoop value);

} // TimeLoopCopyJob
