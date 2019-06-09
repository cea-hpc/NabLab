/**
 */
package fr.cea.nabla.ir.ir;

import org.eclipse.emf.common.util.EList;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Iterable Instruction</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.IterableInstruction#getRange <em>Range</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.IterableInstruction#getSingletons <em>Singletons</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getIterableInstruction()
 * @model abstract="true"
 * @generated
 */
public interface IterableInstruction extends Instruction {
	/**
	 * Returns the value of the '<em><b>Range</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Range</em>' containment reference isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Range</em>' containment reference.
	 * @see #setRange(Iterator)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getIterableInstruction_Range()
	 * @model containment="true" required="true"
	 * @generated
	 */
	Iterator getRange();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.IterableInstruction#getRange <em>Range</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Range</em>' containment reference.
	 * @see #getRange()
	 * @generated
	 */
	void setRange(Iterator value);

	/**
	 * Returns the value of the '<em><b>Singletons</b></em>' containment reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.Iterator}.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Singletons</em>' containment reference list isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Singletons</em>' containment reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getIterableInstruction_Singletons()
	 * @model containment="true" resolveProxies="true"
	 * @generated
	 */
	EList<Iterator> getSingletons();

} // IterableInstruction
