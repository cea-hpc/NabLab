/**
 */
package fr.cea.nabla.ir.ir;

import org.eclipse.emf.common.util.EList;

import org.eclipse.emf.ecore.EObject;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Annotable</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.IrAnnotable#getAnnotations <em>Annotations</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getIrAnnotable()
 * @model abstract="true"
 * @generated
 */
public interface IrAnnotable extends EObject {
	/**
	 * Returns the value of the '<em><b>Annotations</b></em>' containment reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.IrAnnotation}.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Annotations</em>' containment reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getIrAnnotable_Annotations()
	 * @model containment="true"
	 * @generated
	 */
	EList<IrAnnotation> getAnnotations();

} // IrAnnotable
