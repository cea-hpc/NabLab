/**
 */
package fr.cea.nabla.ir.ir;

import org.eclipse.emf.common.util.EList;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Time Loop Container</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.TimeLoopContainer#getInnerTimeLoops <em>Inner Time Loops</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getTimeLoopContainer()
 * @model abstract="true"
 * @generated
 */
public interface TimeLoopContainer extends IrAnnotable {
	/**
	 * Returns the value of the '<em><b>Inner Time Loops</b></em>' containment reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.TimeLoop}.
	 * It is bidirectional and its opposite is '{@link fr.cea.nabla.ir.ir.TimeLoop#getContainer <em>Container</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Inner Time Loops</em>' containment reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getTimeLoopContainer_InnerTimeLoops()
	 * @see fr.cea.nabla.ir.ir.TimeLoop#getContainer
	 * @model opposite="container" containment="true" resolveProxies="true"
	 * @generated
	 */
	EList<TimeLoop> getInnerTimeLoops();

} // TimeLoopContainer
