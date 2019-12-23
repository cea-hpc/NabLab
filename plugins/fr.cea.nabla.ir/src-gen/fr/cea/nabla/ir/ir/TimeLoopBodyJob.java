/**
 */
package fr.cea.nabla.ir.ir;

import org.eclipse.emf.common.util.EList;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Time Loop Body Job</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.TimeLoopBodyJob#getInnerjobs <em>Innerjobs</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getTimeLoopBodyJob()
 * @model
 * @generated
 */
public interface TimeLoopBodyJob extends Job {
	/**
	 * Returns the value of the '<em><b>Innerjobs</b></em>' reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.Job}.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Innerjobs</em>' reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getTimeLoopBodyJob_Innerjobs()
	 * @model
	 * @generated
	 */
	EList<Job> getInnerjobs();

} // TimeLoopBodyJob
