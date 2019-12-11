/**
 */
package fr.cea.nabla.ir.ir;

import org.eclipse.emf.common.util.EList;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Iterator</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.Iterator#getName <em>Name</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.Iterator#getContainer <em>Container</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.Iterator#isSingleton <em>Singleton</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.Iterator#getReferencers <em>Referencers</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getIterator()
 * @model
 * @generated
 */
public interface Iterator extends IrAnnotable {
	/**
	 * Returns the value of the '<em><b>Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Name</em>' attribute isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Name</em>' attribute.
	 * @see #setName(String)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getIterator_Name()
	 * @model unique="false" required="true"
	 * @generated
	 */
	String getName();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.Iterator#getName <em>Name</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Name</em>' attribute.
	 * @see #getName()
	 * @generated
	 */
	void setName(String value);

	/**
	 * Returns the value of the '<em><b>Container</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Container</em>' containment reference isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Container</em>' containment reference.
	 * @see #setContainer(ConnectivityCall)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getIterator_Container()
	 * @model containment="true" required="true"
	 * @generated
	 */
	ConnectivityCall getContainer();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.Iterator#getContainer <em>Container</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Container</em>' containment reference.
	 * @see #getContainer()
	 * @generated
	 */
	void setContainer(ConnectivityCall value);

	/**
	 * Returns the value of the '<em><b>Singleton</b></em>' attribute.
	 * The default value is <code>"false"</code>.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Singleton</em>' attribute isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Singleton</em>' attribute.
	 * @see #setSingleton(boolean)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getIterator_Singleton()
	 * @model default="false" required="true"
	 * @generated
	 */
	boolean isSingleton();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.Iterator#isSingleton <em>Singleton</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Singleton</em>' attribute.
	 * @see #isSingleton()
	 * @generated
	 */
	void setSingleton(boolean value);

	/**
	 * Returns the value of the '<em><b>Referencers</b></em>' reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.IteratorRef}.
	 * It is bidirectional and its opposite is '{@link fr.cea.nabla.ir.ir.IteratorRef#getTarget <em>Target</em>}'.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Referencers</em>' reference list isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Referencers</em>' reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getIterator_Referencers()
	 * @see fr.cea.nabla.ir.ir.IteratorRef#getTarget
	 * @model opposite="target"
	 * @generated
	 */
	EList<IteratorRef> getReferencers();

} // Iterator
