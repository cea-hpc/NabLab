/**
 */
package fr.cea.nabla.ir.ir;


/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Variable</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.Variable#getName <em>Name</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.Variable#getPersistenceName <em>Persistence Name</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.Variable#isConst <em>Const</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getVariable()
 * @model abstract="true"
 * @generated
 */
public interface Variable extends IrAnnotable {
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
	 * @see fr.cea.nabla.ir.ir.IrPackage#getVariable_Name()
	 * @model unique="false" required="true"
	 * @generated
	 */
	String getName();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.Variable#getName <em>Name</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Name</em>' attribute.
	 * @see #getName()
	 * @generated
	 */
	void setName(String value);

	/**
	 * Returns the value of the '<em><b>Persistence Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Persistence Name</em>' attribute isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Persistence Name</em>' attribute.
	 * @see #setPersistenceName(String)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getVariable_PersistenceName()
	 * @model
	 * @generated
	 */
	String getPersistenceName();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.Variable#getPersistenceName <em>Persistence Name</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Persistence Name</em>' attribute.
	 * @see #getPersistenceName()
	 * @generated
	 */
	void setPersistenceName(String value);

	/**
	 * Returns the value of the '<em><b>Const</b></em>' attribute.
	 * The default value is <code>"false"</code>.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Const</em>' attribute isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Const</em>' attribute.
	 * @see #setConst(boolean)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getVariable_Const()
	 * @model default="false" required="true"
	 * @generated
	 */
	boolean isConst();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.Variable#isConst <em>Const</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Const</em>' attribute.
	 * @see #isConst()
	 * @generated
	 */
	void setConst(boolean value);

} // Variable
