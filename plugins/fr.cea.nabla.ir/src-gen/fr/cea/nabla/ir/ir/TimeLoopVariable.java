/**
 */
package fr.cea.nabla.ir.ir;


/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Time Loop Variable</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.TimeLoopVariable#getInit <em>Init</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.TimeLoopVariable#getCurrent <em>Current</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.TimeLoopVariable#getNext <em>Next</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.TimeLoopVariable#getName <em>Name</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getTimeLoopVariable()
 * @model
 * @generated
 */
public interface TimeLoopVariable extends IrAnnotable {
	/**
	 * Returns the value of the '<em><b>Init</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Init</em>' reference.
	 * @see #setInit(Variable)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getTimeLoopVariable_Init()
	 * @model
	 * @generated
	 */
	Variable getInit();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.TimeLoopVariable#getInit <em>Init</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Init</em>' reference.
	 * @see #getInit()
	 * @generated
	 */
	void setInit(Variable value);

	/**
	 * Returns the value of the '<em><b>Current</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Current</em>' reference.
	 * @see #setCurrent(Variable)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getTimeLoopVariable_Current()
	 * @model required="true"
	 * @generated
	 */
	Variable getCurrent();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.TimeLoopVariable#getCurrent <em>Current</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Current</em>' reference.
	 * @see #getCurrent()
	 * @generated
	 */
	void setCurrent(Variable value);

	/**
	 * Returns the value of the '<em><b>Next</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Next</em>' reference.
	 * @see #setNext(Variable)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getTimeLoopVariable_Next()
	 * @model required="true"
	 * @generated
	 */
	Variable getNext();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.TimeLoopVariable#getNext <em>Next</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Next</em>' reference.
	 * @see #getNext()
	 * @generated
	 */
	void setNext(Variable value);

	/**
	 * Returns the value of the '<em><b>Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Name</em>' attribute.
	 * @see #setName(String)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getTimeLoopVariable_Name()
	 * @model required="true"
	 * @generated
	 */
	String getName();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.TimeLoopVariable#getName <em>Name</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Name</em>' attribute.
	 * @see #getName()
	 * @generated
	 */
	void setName(String value);

} // TimeLoopVariable
