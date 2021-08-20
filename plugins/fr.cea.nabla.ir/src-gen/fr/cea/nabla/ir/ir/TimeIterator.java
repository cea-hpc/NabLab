/**
 */
package fr.cea.nabla.ir.ir;

import org.eclipse.emf.common.util.EList;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Time Iterator</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.TimeIterator#getName <em>Name</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.TimeIterator#getInnerIterators <em>Inner Iterators</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.TimeIterator#getParentIterator <em>Parent Iterator</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.TimeIterator#getVariables <em>Variables</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.TimeIterator#getTimeLoopJob <em>Time Loop Job</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getTimeIterator()
 * @model
 * @generated
 */
public interface TimeIterator extends IrAnnotable {
	/**
	 * Returns the value of the '<em><b>Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Name</em>' attribute.
	 * @see #setName(String)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getTimeIterator_Name()
	 * @model unique="false" required="true"
	 * @generated
	 */
	String getName();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.TimeIterator#getName <em>Name</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Name</em>' attribute.
	 * @see #getName()
	 * @generated
	 */
	void setName(String value);

	/**
	 * Returns the value of the '<em><b>Inner Iterators</b></em>' containment reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.TimeIterator}.
	 * It is bidirectional and its opposite is '{@link fr.cea.nabla.ir.ir.TimeIterator#getParentIterator <em>Parent Iterator</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Inner Iterators</em>' containment reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getTimeIterator_InnerIterators()
	 * @see fr.cea.nabla.ir.ir.TimeIterator#getParentIterator
	 * @model opposite="parentIterator" containment="true" resolveProxies="true"
	 * @generated
	 */
	EList<TimeIterator> getInnerIterators();

	/**
	 * Returns the value of the '<em><b>Parent Iterator</b></em>' container reference.
	 * It is bidirectional and its opposite is '{@link fr.cea.nabla.ir.ir.TimeIterator#getInnerIterators <em>Inner Iterators</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Parent Iterator</em>' container reference.
	 * @see #setParentIterator(TimeIterator)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getTimeIterator_ParentIterator()
	 * @see fr.cea.nabla.ir.ir.TimeIterator#getInnerIterators
	 * @model opposite="innerIterators" transient="false"
	 * @generated
	 */
	TimeIterator getParentIterator();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.TimeIterator#getParentIterator <em>Parent Iterator</em>}' container reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Parent Iterator</em>' container reference.
	 * @see #getParentIterator()
	 * @generated
	 */
	void setParentIterator(TimeIterator value);

	/**
	 * Returns the value of the '<em><b>Variables</b></em>' reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.Variable}.
	 * It is bidirectional and its opposite is '{@link fr.cea.nabla.ir.ir.Variable#getTimeIterator <em>Time Iterator</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Variables</em>' reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getTimeIterator_Variables()
	 * @see fr.cea.nabla.ir.ir.Variable#getTimeIterator
	 * @model opposite="timeIterator"
	 * @generated
	 */
	EList<Variable> getVariables();

	/**
	 * Returns the value of the '<em><b>Time Loop Job</b></em>' reference.
	 * It is bidirectional and its opposite is '{@link fr.cea.nabla.ir.ir.ExecuteTimeLoopJob#getTimeIterator <em>Time Iterator</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Time Loop Job</em>' reference.
	 * @see #setTimeLoopJob(ExecuteTimeLoopJob)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getTimeIterator_TimeLoopJob()
	 * @see fr.cea.nabla.ir.ir.ExecuteTimeLoopJob#getTimeIterator
	 * @model opposite="timeIterator" required="true"
	 * @generated
	 */
	ExecuteTimeLoopJob getTimeLoopJob();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.TimeIterator#getTimeLoopJob <em>Time Loop Job</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Time Loop Job</em>' reference.
	 * @see #getTimeLoopJob()
	 * @generated
	 */
	void setTimeLoopJob(ExecuteTimeLoopJob value);

} // TimeIterator
