/**
 */
package fr.cea.nabla.ir.ir;

import org.eclipse.emf.common.util.EMap;

import org.eclipse.emf.ecore.EObject;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Annotation</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.IrAnnotation#getSource <em>Source</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.IrAnnotation#getDetails <em>Details</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getIrAnnotation()
 * @model
 * @generated
 */
public interface IrAnnotation extends EObject {
	/**
	 * Returns the value of the '<em><b>Source</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Source</em>' attribute.
	 * @see #setSource(String)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getIrAnnotation_Source()
	 * @model unique="false"
	 * @generated
	 */
	String getSource();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.IrAnnotation#getSource <em>Source</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Source</em>' attribute.
	 * @see #getSource()
	 * @generated
	 */
	void setSource(String value);

	/**
	 * Returns the value of the '<em><b>Details</b></em>' map.
	 * The key is of type {@link java.lang.String},
	 * and the value is of type {@link java.lang.String},
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Details</em>' map.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getIrAnnotation_Details()
	 * @model mapType="org.eclipse.emf.ecore.EStringToStringMapEntry&lt;org.eclipse.emf.ecore.EString, org.eclipse.emf.ecore.EString&gt;"
	 * @generated
	 */
	EMap<String, String> getDetails();

} // IrAnnotation
