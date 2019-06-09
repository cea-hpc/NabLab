/**
 */
package fr.cea.nabla.ir.ir;

import org.eclipse.emf.common.util.EList;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Function</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.Function#getName <em>Name</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.Function#getInTypes <em>In Types</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.Function#getReturnType <em>Return Type</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.Function#getProvider <em>Provider</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getFunction()
 * @model
 * @generated
 */
public interface Function extends IrAnnotable {
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
	 * @see fr.cea.nabla.ir.ir.IrPackage#getFunction_Name()
	 * @model unique="false"
	 * @generated
	 */
	String getName();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.Function#getName <em>Name</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Name</em>' attribute.
	 * @see #getName()
	 * @generated
	 */
	void setName(String value);

	/**
	 * Returns the value of the '<em><b>In Types</b></em>' attribute list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.BasicType}.
	 * The literals are from the enumeration {@link fr.cea.nabla.ir.ir.BasicType}.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>In Types</em>' attribute list isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>In Types</em>' attribute list.
	 * @see fr.cea.nabla.ir.ir.BasicType
	 * @see fr.cea.nabla.ir.ir.IrPackage#getFunction_InTypes()
	 * @model unique="false"
	 * @generated
	 */
	EList<BasicType> getInTypes();

	/**
	 * Returns the value of the '<em><b>Return Type</b></em>' attribute.
	 * The literals are from the enumeration {@link fr.cea.nabla.ir.ir.BasicType}.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Return Type</em>' attribute isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Return Type</em>' attribute.
	 * @see fr.cea.nabla.ir.ir.BasicType
	 * @see #setReturnType(BasicType)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getFunction_ReturnType()
	 * @model unique="false" required="true"
	 * @generated
	 */
	BasicType getReturnType();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.Function#getReturnType <em>Return Type</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Return Type</em>' attribute.
	 * @see fr.cea.nabla.ir.ir.BasicType
	 * @see #getReturnType()
	 * @generated
	 */
	void setReturnType(BasicType value);

	/**
	 * Returns the value of the '<em><b>Provider</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Provider</em>' attribute isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Provider</em>' attribute.
	 * @see #setProvider(String)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getFunction_Provider()
	 * @model required="true"
	 * @generated
	 */
	String getProvider();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.Function#getProvider <em>Provider</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Provider</em>' attribute.
	 * @see #getProvider()
	 * @generated
	 */
	void setProvider(String value);

} // Function
