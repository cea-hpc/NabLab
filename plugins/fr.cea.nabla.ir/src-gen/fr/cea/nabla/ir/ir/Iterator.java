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
 *   <li>{@link fr.cea.nabla.ir.ir.Iterator#isSingleton <em>Singleton</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.Iterator#getIndex <em>Index</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.Iterator#getNeededIds <em>Needed Ids</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.Iterator#getNeededIndices <em>Needed Indices</em>}</li>
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
	 * Returns the value of the '<em><b>Singleton</b></em>' attribute.
	 * The default value is <code>"false"</code>.
	 * <!-- begin-user-doc -->
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
	 * Returns the value of the '<em><b>Index</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Index</em>' containment reference.
	 * @see #setIndex(IrIndex)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getIterator_Index()
	 * @model containment="true" resolveProxies="true" required="true"
	 * @generated
	 */
	IrIndex getIndex();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.Iterator#getIndex <em>Index</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Index</em>' containment reference.
	 * @see #getIndex()
	 * @generated
	 */
	void setIndex(IrIndex value);

	/**
	 * Returns the value of the '<em><b>Needed Ids</b></em>' containment reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.IrUniqueId}.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Needed Ids</em>' containment reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getIterator_NeededIds()
	 * @model containment="true" resolveProxies="true"
	 * @generated
	 */
	EList<IrUniqueId> getNeededIds();

	/**
	 * Returns the value of the '<em><b>Needed Indices</b></em>' containment reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.IrIndex}.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Needed Indices</em>' containment reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getIterator_NeededIndices()
	 * @model containment="true" resolveProxies="true"
	 * @generated
	 */
	EList<IrIndex> getNeededIndices();

} // Iterator
