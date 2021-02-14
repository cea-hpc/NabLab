/**
 */
package fr.cea.nabla.ir.ir;

import org.eclipse.emf.common.util.EList;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Post Processing</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.PostProcessing#getOutputVariables <em>Output Variables</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.PostProcessing#getPeriodReference <em>Period Reference</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.PostProcessing#getPeriodValue <em>Period Value</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.PostProcessing#getLastDumpVariable <em>Last Dump Variable</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getPostProcessing()
 * @model
 * @generated
 */
public interface PostProcessing extends IrAnnotable {
	/**
	 * Returns the value of the '<em><b>Output Variables</b></em>' reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.PostProcessedVariable}.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Output Variables</em>' reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getPostProcessing_OutputVariables()
	 * @model
	 * @generated
	 */
	EList<PostProcessedVariable> getOutputVariables();

	/**
	 * Returns the value of the '<em><b>Period Reference</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Period Reference</em>' reference.
	 * @see #setPeriodReference(Variable)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getPostProcessing_PeriodReference()
	 * @model required="true"
	 * @generated
	 */
	Variable getPeriodReference();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.PostProcessing#getPeriodReference <em>Period Reference</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Period Reference</em>' reference.
	 * @see #getPeriodReference()
	 * @generated
	 */
	void setPeriodReference(Variable value);

	/**
	 * Returns the value of the '<em><b>Period Value</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Period Value</em>' reference.
	 * @see #setPeriodValue(Variable)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getPostProcessing_PeriodValue()
	 * @model required="true"
	 * @generated
	 */
	Variable getPeriodValue();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.PostProcessing#getPeriodValue <em>Period Value</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Period Value</em>' reference.
	 * @see #getPeriodValue()
	 * @generated
	 */
	void setPeriodValue(Variable value);

	/**
	 * Returns the value of the '<em><b>Last Dump Variable</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Last Dump Variable</em>' reference.
	 * @see #setLastDumpVariable(Variable)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getPostProcessing_LastDumpVariable()
	 * @model required="true"
	 * @generated
	 */
	Variable getLastDumpVariable();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.PostProcessing#getLastDumpVariable <em>Last Dump Variable</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Last Dump Variable</em>' reference.
	 * @see #getLastDumpVariable()
	 * @generated
	 */
	void setLastDumpVariable(Variable value);

} // PostProcessing
