/**
 */
package fr.cea.nabla.ir.ir;


/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Simple Variable</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.SimpleVariable#getType <em>Type</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.SimpleVariable#getDefaultValue <em>Default Value</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.SimpleVariable#isOption <em>Option</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.SimpleVariable#isConst <em>Const</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.SimpleVariable#isConstExpr <em>Const Expr</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getSimpleVariable()
 * @model
 * @generated
 */
public interface SimpleVariable extends Variable {
	/**
	 * Returns the value of the '<em><b>Type</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Type</em>' containment reference.
	 * @see #setType(BaseType)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getSimpleVariable_Type()
	 * @model containment="true" resolveProxies="true" required="true"
	 * @generated
	 */
	BaseType getType();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.SimpleVariable#getType <em>Type</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Type</em>' containment reference.
	 * @see #getType()
	 * @generated
	 */
	void setType(BaseType value);

	/**
	 * Returns the value of the '<em><b>Default Value</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Default Value</em>' containment reference.
	 * @see #setDefaultValue(Expression)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getSimpleVariable_DefaultValue()
	 * @model containment="true"
	 * @generated
	 */
	Expression getDefaultValue();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.SimpleVariable#getDefaultValue <em>Default Value</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Default Value</em>' containment reference.
	 * @see #getDefaultValue()
	 * @generated
	 */
	void setDefaultValue(Expression value);

	/**
	 * Returns the value of the '<em><b>Option</b></em>' attribute.
	 * The default value is <code>"false"</code>.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Option</em>' attribute.
	 * @see #setOption(boolean)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getSimpleVariable_Option()
	 * @model default="false" required="true"
	 * @generated
	 */
	boolean isOption();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.SimpleVariable#isOption <em>Option</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Option</em>' attribute.
	 * @see #isOption()
	 * @generated
	 */
	void setOption(boolean value);

	/**
	 * Returns the value of the '<em><b>Const</b></em>' attribute.
	 * The default value is <code>"false"</code>.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Const</em>' attribute.
	 * @see #setConst(boolean)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getSimpleVariable_Const()
	 * @model default="false" required="true"
	 * @generated
	 */
	boolean isConst();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.SimpleVariable#isConst <em>Const</em>}' attribute.
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
	 * @see fr.cea.nabla.ir.ir.IrPackage#getSimpleVariable_ConstExpr()
	 * @model required="true"
	 * @generated
	 */
	boolean isConstExpr();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.SimpleVariable#isConstExpr <em>Const Expr</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Const Expr</em>' attribute.
	 * @see #isConstExpr()
	 * @generated
	 */
	void setConstExpr(boolean value);

} // SimpleVariable
