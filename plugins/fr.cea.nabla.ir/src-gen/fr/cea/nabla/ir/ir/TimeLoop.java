/**
 */
package fr.cea.nabla.ir.ir;

import org.eclipse.emf.common.util.EList;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Time Loop</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.TimeLoop#getName <em>Name</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.TimeLoop#getContainer <em>Container</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.TimeLoop#getVariables <em>Variables</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.TimeLoop#getWhileCondition <em>While Condition</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.TimeLoop#getAssociatedJob <em>Associated Job</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.TimeLoop#getIterationCounter <em>Iteration Counter</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getTimeLoop()
 * @model
 * @generated
 */
public interface TimeLoop extends TimeLoopContainer {
	/**
	 * Returns the value of the '<em><b>Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Name</em>' attribute.
	 * @see #setName(String)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getTimeLoop_Name()
	 * @model required="true"
	 * @generated
	 */
	String getName();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.TimeLoop#getName <em>Name</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Name</em>' attribute.
	 * @see #getName()
	 * @generated
	 */
	void setName(String value);

	/**
	 * Returns the value of the '<em><b>Container</b></em>' container reference.
	 * It is bidirectional and its opposite is '{@link fr.cea.nabla.ir.ir.TimeLoopContainer#getInnerTimeLoops <em>Inner Time Loops</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Container</em>' container reference.
	 * @see #setContainer(TimeLoopContainer)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getTimeLoop_Container()
	 * @see fr.cea.nabla.ir.ir.TimeLoopContainer#getInnerTimeLoops
	 * @model opposite="innerTimeLoops" transient="false"
	 * @generated
	 */
	TimeLoopContainer getContainer();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.TimeLoop#getContainer <em>Container</em>}' container reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Container</em>' container reference.
	 * @see #getContainer()
	 * @generated
	 */
	void setContainer(TimeLoopContainer value);

	/**
	 * Returns the value of the '<em><b>Variables</b></em>' containment reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.TimeLoopVariable}.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Variables</em>' containment reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getTimeLoop_Variables()
	 * @model containment="true" resolveProxies="true"
	 * @generated
	 */
	EList<TimeLoopVariable> getVariables();

	/**
	 * Returns the value of the '<em><b>While Condition</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>While Condition</em>' containment reference.
	 * @see #setWhileCondition(Expression)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getTimeLoop_WhileCondition()
	 * @model containment="true" resolveProxies="true" required="true"
	 * @generated
	 */
	Expression getWhileCondition();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.TimeLoop#getWhileCondition <em>While Condition</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>While Condition</em>' containment reference.
	 * @see #getWhileCondition()
	 * @generated
	 */
	void setWhileCondition(Expression value);

	/**
	 * Returns the value of the '<em><b>Associated Job</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Associated Job</em>' reference.
	 * @see #setAssociatedJob(TimeLoopJob)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getTimeLoop_AssociatedJob()
	 * @model required="true"
	 * @generated
	 */
	TimeLoopJob getAssociatedJob();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.TimeLoop#getAssociatedJob <em>Associated Job</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Associated Job</em>' reference.
	 * @see #getAssociatedJob()
	 * @generated
	 */
	void setAssociatedJob(TimeLoopJob value);

	/**
	 * Returns the value of the '<em><b>Iteration Counter</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Iteration Counter</em>' reference.
	 * @see #setIterationCounter(SimpleVariable)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getTimeLoop_IterationCounter()
	 * @model required="true"
	 * @generated
	 */
	SimpleVariable getIterationCounter();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.TimeLoop#getIterationCounter <em>Iteration Counter</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Iteration Counter</em>' reference.
	 * @see #getIterationCounter()
	 * @generated
	 */
	void setIterationCounter(SimpleVariable value);

} // TimeLoop
