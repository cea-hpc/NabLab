/**
 */
package fr.cea.nabla.ir.ir;


/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Connectivity Variable</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.ConnectivityVariable#getType <em>Type</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.ConnectivityVariable#getDefaultValue <em>Default Value</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getConnectivityVariable()
 * @model
 * @generated
 */
public interface ConnectivityVariable extends Variable {
	/**
	 * Returns the value of the '<em><b>Type</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Type</em>' containment reference isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Type</em>' containment reference.
	 * @see #setType(ConnectivityType)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getConnectivityVariable_Type()
	 * @model containment="true" resolveProxies="true" required="true"
	 * @generated
	 */
	ConnectivityType getType();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.ConnectivityVariable#getType <em>Type</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Type</em>' containment reference.
	 * @see #getType()
	 * @generated
	 */
	void setType(ConnectivityType value);

	/**
	 * Returns the value of the '<em><b>Default Value</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Default Value</em>' containment reference isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Default Value</em>' containment reference.
	 * @see #setDefaultValue(ArgOrVarRef)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getConnectivityVariable_DefaultValue()
	 * @model containment="true" resolveProxies="true"
	 * @generated
	 */
	ArgOrVarRef getDefaultValue();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.ConnectivityVariable#getDefaultValue <em>Default Value</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Default Value</em>' containment reference.
	 * @see #getDefaultValue()
	 * @generated
	 */
	void setDefaultValue(ArgOrVarRef value);

} // ConnectivityVariable
