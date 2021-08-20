/**
 */
package fr.cea.nabla.ir.ir;

import org.eclipse.emf.common.util.EList;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Variable</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.Variable#getDefaultValue <em>Default Value</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.Variable#isConst <em>Const</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.Variable#isConstExpr <em>Const Expr</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.Variable#isOption <em>Option</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.Variable#getPreviousJobs <em>Previous Jobs</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.Variable#getNextJobs <em>Next Jobs</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.Variable#getOriginName <em>Origin Name</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.Variable#getTimeIterator <em>Time Iterator</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.Variable#getTimeIteratorIndex <em>Time Iterator Index</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getVariable()
 * @model
 * @generated
 */
public interface Variable extends ArgOrVar {
	/**
	 * Returns the value of the '<em><b>Default Value</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Default Value</em>' containment reference.
	 * @see #setDefaultValue(Expression)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getVariable_DefaultValue()
	 * @model containment="true"
	 * @generated
	 */
	Expression getDefaultValue();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.Variable#getDefaultValue <em>Default Value</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Default Value</em>' containment reference.
	 * @see #getDefaultValue()
	 * @generated
	 */
	void setDefaultValue(Expression value);

	/**
	 * Returns the value of the '<em><b>Const</b></em>' attribute.
	 * The default value is <code>"false"</code>.
	 * <!-- begin-user-doc -->
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

	/**
	 * Returns the value of the '<em><b>Const Expr</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Const Expr</em>' attribute.
	 * @see #setConstExpr(boolean)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getVariable_ConstExpr()
	 * @model required="true"
	 * @generated
	 */
	boolean isConstExpr();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.Variable#isConstExpr <em>Const Expr</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Const Expr</em>' attribute.
	 * @see #isConstExpr()
	 * @generated
	 */
	void setConstExpr(boolean value);

	/**
	 * Returns the value of the '<em><b>Option</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Option</em>' attribute.
	 * @see #setOption(boolean)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getVariable_Option()
	 * @model required="true"
	 * @generated
	 */
	boolean isOption();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.Variable#isOption <em>Option</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Option</em>' attribute.
	 * @see #isOption()
	 * @generated
	 */
	void setOption(boolean value);

	/**
	 * Returns the value of the '<em><b>Previous Jobs</b></em>' reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.Job}.
	 * It is bidirectional and its opposite is '{@link fr.cea.nabla.ir.ir.Job#getOutVars <em>Out Vars</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Previous Jobs</em>' reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getVariable_PreviousJobs()
	 * @see fr.cea.nabla.ir.ir.Job#getOutVars
	 * @model opposite="outVars"
	 * @generated
	 */
	EList<Job> getPreviousJobs();

	/**
	 * Returns the value of the '<em><b>Next Jobs</b></em>' reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.Job}.
	 * It is bidirectional and its opposite is '{@link fr.cea.nabla.ir.ir.Job#getInVars <em>In Vars</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Next Jobs</em>' reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getVariable_NextJobs()
	 * @see fr.cea.nabla.ir.ir.Job#getInVars
	 * @model opposite="inVars"
	 * @generated
	 */
	EList<Job> getNextJobs();

	/**
	 * Returns the value of the '<em><b>Origin Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Origin Name</em>' attribute.
	 * @see #setOriginName(String)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getVariable_OriginName()
	 * @model required="true"
	 * @generated
	 */
	String getOriginName();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.Variable#getOriginName <em>Origin Name</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Origin Name</em>' attribute.
	 * @see #getOriginName()
	 * @generated
	 */
	void setOriginName(String value);

	/**
	 * Returns the value of the '<em><b>Time Iterator</b></em>' reference.
	 * It is bidirectional and its opposite is '{@link fr.cea.nabla.ir.ir.TimeIterator#getVariables <em>Variables</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Time Iterator</em>' reference.
	 * @see #setTimeIterator(TimeIterator)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getVariable_TimeIterator()
	 * @see fr.cea.nabla.ir.ir.TimeIterator#getVariables
	 * @model opposite="variables"
	 * @generated
	 */
	TimeIterator getTimeIterator();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.Variable#getTimeIterator <em>Time Iterator</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Time Iterator</em>' reference.
	 * @see #getTimeIterator()
	 * @generated
	 */
	void setTimeIterator(TimeIterator value);

	/**
	 * Returns the value of the '<em><b>Time Iterator Index</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Time Iterator Index</em>' attribute.
	 * @see #setTimeIteratorIndex(int)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getVariable_TimeIteratorIndex()
	 * @model
	 * @generated
	 */
	int getTimeIteratorIndex();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.Variable#getTimeIteratorIndex <em>Time Iterator Index</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Time Iterator Index</em>' attribute.
	 * @see #getTimeIteratorIndex()
	 * @generated
	 */
	void setTimeIteratorIndex(int value);

} // Variable
