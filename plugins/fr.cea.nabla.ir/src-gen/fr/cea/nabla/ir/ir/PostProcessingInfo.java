/**
 */
package fr.cea.nabla.ir.ir;

import org.eclipse.emf.common.util.EList;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Post Processing Info</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.PostProcessingInfo#getPostProcessedVariables <em>Post Processed Variables</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.PostProcessingInfo#getPeriodValue <em>Period Value</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.PostProcessingInfo#getPeriodVariable <em>Period Variable</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.PostProcessingInfo#getLastDumpVariable <em>Last Dump Variable</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getPostProcessingInfo()
 * @model
 * @generated
 */
public interface PostProcessingInfo extends IrAnnotable {
	/**
	 * Returns the value of the '<em><b>Post Processed Variables</b></em>' reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.Variable}.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Post Processed Variables</em>' reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getPostProcessingInfo_PostProcessedVariables()
	 * @model
	 * @generated
	 */
	EList<Variable> getPostProcessedVariables();

	/**
	 * Returns the value of the '<em><b>Period Value</b></em>' attribute.
	 * The default value is <code>"-1.0"</code>.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Period Value</em>' attribute.
	 * @see #setPeriodValue(double)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getPostProcessingInfo_PeriodValue()
	 * @model default="-1.0" required="true"
	 * @generated
	 */
	double getPeriodValue();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.PostProcessingInfo#getPeriodValue <em>Period Value</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Period Value</em>' attribute.
	 * @see #getPeriodValue()
	 * @generated
	 */
	void setPeriodValue(double value);

	/**
	 * Returns the value of the '<em><b>Period Variable</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Period Variable</em>' reference.
	 * @see #setPeriodVariable(SimpleVariable)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getPostProcessingInfo_PeriodVariable()
	 * @model required="true"
	 * @generated
	 */
	SimpleVariable getPeriodVariable();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.PostProcessingInfo#getPeriodVariable <em>Period Variable</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Period Variable</em>' reference.
	 * @see #getPeriodVariable()
	 * @generated
	 */
	void setPeriodVariable(SimpleVariable value);

	/**
	 * Returns the value of the '<em><b>Last Dump Variable</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Last Dump Variable</em>' reference.
	 * @see #setLastDumpVariable(SimpleVariable)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getPostProcessingInfo_LastDumpVariable()
	 * @model required="true"
	 * @generated
	 */
	SimpleVariable getLastDumpVariable();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.PostProcessingInfo#getLastDumpVariable <em>Last Dump Variable</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Last Dump Variable</em>' reference.
	 * @see #getLastDumpVariable()
	 * @generated
	 */
	void setLastDumpVariable(SimpleVariable value);

} // PostProcessingInfo
