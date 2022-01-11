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
 *   <li>{@link fr.cea.nabla.ir.ir.Function#getReturnType <em>Return Type</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.Function#getVariables <em>Variables</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.Function#getInArgs <em>In Args</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.Function#getIndexInName <em>Index In Name</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getFunction()
 * @model abstract="true"
 * @generated
 */
public interface Function extends IrAnnotable {
	/**
	 * Returns the value of the '<em><b>Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Name</em>' attribute.
	 * @see #setName(String)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getFunction_Name()
	 * @model unique="false" required="true"
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
	 * Returns the value of the '<em><b>Return Type</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Return Type</em>' containment reference.
	 * @see #setReturnType(IrType)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getFunction_ReturnType()
	 * @model containment="true" resolveProxies="true"
	 * @generated
	 */
	IrType getReturnType();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.Function#getReturnType <em>Return Type</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Return Type</em>' containment reference.
	 * @see #getReturnType()
	 * @generated
	 */
	void setReturnType(IrType value);

	/**
	 * Returns the value of the '<em><b>Variables</b></em>' containment reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.Variable}.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Variables</em>' containment reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getFunction_Variables()
	 * @model containment="true" resolveProxies="true"
	 * @generated
	 */
	EList<Variable> getVariables();

	/**
	 * Returns the value of the '<em><b>In Args</b></em>' containment reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.Arg}.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>In Args</em>' containment reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getFunction_InArgs()
	 * @model containment="true" resolveProxies="true"
	 * @generated
	 */
	EList<Arg> getInArgs();

	/**
	 * Returns the value of the '<em><b>Index In Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Index In Name</em>' attribute.
	 * @see #setIndexInName(int)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getFunction_IndexInName()
	 * @model required="true"
	 * @generated
	 */
	int getIndexInName();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.Function#getIndexInName <em>Index In Name</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Index In Name</em>' attribute.
	 * @see #getIndexInName()
	 * @generated
	 */
	void setIndexInName(int value);

} // Function
