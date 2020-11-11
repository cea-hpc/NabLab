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
 *   <li>{@link fr.cea.nabla.ir.ir.TimeLoopJob#getCopies <em>Copies</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getTimeLoopJob()
 * @model abstract="true"
 * @generated
 */
public interface TimeLoopJob extends Job {
	/**
	 * Returns the value of the '<em><b>Copies</b></em>' containment reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.TimeLoopCopy}.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Copies</em>' containment reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getTimeLoopJob_Copies()
	 * @model containment="true" resolveProxies="true"
	 * @generated
	 */
	EList<TimeLoopCopy> getCopies();

} // TimeLoopJob
