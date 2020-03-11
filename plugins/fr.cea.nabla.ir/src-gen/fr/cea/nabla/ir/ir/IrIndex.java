/**
 */
package fr.cea.nabla.ir.ir;


/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Index</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.IrIndex#getName <em>Name</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.IrIndex#getDefaultValueId <em>Default Value Id</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.IrIndex#getContainer <em>Container</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.IrIndex#getIterator <em>Iterator</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getIrIndex()
 * @model
 * @generated
 */
public interface IrIndex extends IrAnnotable {
	/**
	 * Returns the value of the '<em><b>Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Name</em>' attribute.
	 * @see #setName(String)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getIrIndex_Name()
	 * @model required="true"
	 * @generated
	 */
	String getName();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.IrIndex#getName <em>Name</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Name</em>' attribute.
	 * @see #getName()
	 * @generated
	 */
	void setName(String value);

	/**
	 * Returns the value of the '<em><b>Default Value Id</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Default Value Id</em>' reference.
	 * @see #setDefaultValueId(IrUniqueId)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getIrIndex_DefaultValueId()
	 * @model
	 * @generated
	 */
	IrUniqueId getDefaultValueId();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.IrIndex#getDefaultValueId <em>Default Value Id</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Default Value Id</em>' reference.
	 * @see #getDefaultValueId()
	 * @generated
	 */
	void setDefaultValueId(IrUniqueId value);

	/**
	 * Returns the value of the '<em><b>Container</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Container</em>' containment reference.
	 * @see #setContainer(IrConnectivityCall)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getIrIndex_Container()
	 * @model containment="true" resolveProxies="true" required="true"
	 * @generated
	 */
	IrConnectivityCall getContainer();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.IrIndex#getContainer <em>Container</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Container</em>' containment reference.
	 * @see #getContainer()
	 * @generated
	 */
	void setContainer(IrConnectivityCall value);

	/**
	 * Returns the value of the '<em><b>Iterator</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Iterator</em>' reference.
	 * @see #setIterator(Iterator)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getIrIndex_Iterator()
	 * @model required="true"
	 * @generated
	 */
	Iterator getIterator();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.IrIndex#getIterator <em>Iterator</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Iterator</em>' reference.
	 * @see #getIterator()
	 * @generated
	 */
	void setIterator(Iterator value);

} // IrIndex
