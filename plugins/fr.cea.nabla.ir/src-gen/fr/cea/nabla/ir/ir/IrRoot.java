/**
 */
package fr.cea.nabla.ir.ir;

import org.eclipse.emf.common.util.EList;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Root</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.cea.nabla.ir.ir.IrRoot#getName <em>Name</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.IrRoot#getItemTypes <em>Item Types</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.IrRoot#getConnectivities <em>Connectivities</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.IrRoot#getVariables <em>Variables</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.IrRoot#getJobs <em>Jobs</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.IrRoot#getMain <em>Main</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.IrRoot#getModules <em>Modules</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.IrRoot#getMeshClassName <em>Mesh Class Name</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.IrRoot#getInitNodeCoordVariable <em>Init Node Coord Variable</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.IrRoot#getNodeCoordVariable <em>Node Coord Variable</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.IrRoot#getCurrentTimeVariable <em>Current Time Variable</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.IrRoot#getNextTimeVariable <em>Next Time Variable</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.IrRoot#getTimeStepVariable <em>Time Step Variable</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.IrRoot#getPostProcessing <em>Post Processing</em>}</li>
 *   <li>{@link fr.cea.nabla.ir.ir.IrRoot#getProviders <em>Providers</em>}</li>
 * </ul>
 *
 * @see fr.cea.nabla.ir.ir.IrPackage#getIrRoot()
 * @model
 * @generated
 */
public interface IrRoot extends IrAnnotable {
	/**
	 * Returns the value of the '<em><b>Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Name</em>' attribute.
	 * @see #setName(String)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getIrRoot_Name()
	 * @model unique="false" required="true"
	 * @generated
	 */
	String getName();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.IrRoot#getName <em>Name</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Name</em>' attribute.
	 * @see #getName()
	 * @generated
	 */
	void setName(String value);

	/**
	 * Returns the value of the '<em><b>Item Types</b></em>' containment reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.ItemType}.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Item Types</em>' containment reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getIrRoot_ItemTypes()
	 * @model containment="true" resolveProxies="true"
	 * @generated
	 */
	EList<ItemType> getItemTypes();

	/**
	 * Returns the value of the '<em><b>Connectivities</b></em>' containment reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.Connectivity}.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Connectivities</em>' containment reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getIrRoot_Connectivities()
	 * @model containment="true"
	 * @generated
	 */
	EList<Connectivity> getConnectivities();

	/**
	 * Returns the value of the '<em><b>Variables</b></em>' reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.Variable}.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Variables</em>' reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getIrRoot_Variables()
	 * @model resolveProxies="false"
	 * @generated
	 */
	EList<Variable> getVariables();

	/**
	 * Returns the value of the '<em><b>Jobs</b></em>' reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.Job}.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Jobs</em>' reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getIrRoot_Jobs()
	 * @model resolveProxies="false"
	 * @generated
	 */
	EList<Job> getJobs();

	/**
	 * Returns the value of the '<em><b>Main</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Main</em>' containment reference.
	 * @see #setMain(JobCaller)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getIrRoot_Main()
	 * @model containment="true" resolveProxies="true"
	 * @generated
	 */
	JobCaller getMain();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.IrRoot#getMain <em>Main</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Main</em>' containment reference.
	 * @see #getMain()
	 * @generated
	 */
	void setMain(JobCaller value);

	/**
	 * Returns the value of the '<em><b>Modules</b></em>' containment reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.IrModule}.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Modules</em>' containment reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getIrRoot_Modules()
	 * @model containment="true" resolveProxies="true"
	 * @generated
	 */
	EList<IrModule> getModules();

	/**
	 * Returns the value of the '<em><b>Mesh Class Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Mesh Class Name</em>' attribute.
	 * @see #setMeshClassName(String)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getIrRoot_MeshClassName()
	 * @model required="true"
	 * @generated
	 */
	String getMeshClassName();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.IrRoot#getMeshClassName <em>Mesh Class Name</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Mesh Class Name</em>' attribute.
	 * @see #getMeshClassName()
	 * @generated
	 */
	void setMeshClassName(String value);

	/**
	 * Returns the value of the '<em><b>Init Node Coord Variable</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Init Node Coord Variable</em>' reference.
	 * @see #setInitNodeCoordVariable(Variable)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getIrRoot_InitNodeCoordVariable()
	 * @model required="true"
	 * @generated
	 */
	Variable getInitNodeCoordVariable();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.IrRoot#getInitNodeCoordVariable <em>Init Node Coord Variable</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Init Node Coord Variable</em>' reference.
	 * @see #getInitNodeCoordVariable()
	 * @generated
	 */
	void setInitNodeCoordVariable(Variable value);

	/**
	 * Returns the value of the '<em><b>Node Coord Variable</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Node Coord Variable</em>' reference.
	 * @see #setNodeCoordVariable(Variable)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getIrRoot_NodeCoordVariable()
	 * @model required="true"
	 * @generated
	 */
	Variable getNodeCoordVariable();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.IrRoot#getNodeCoordVariable <em>Node Coord Variable</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Node Coord Variable</em>' reference.
	 * @see #getNodeCoordVariable()
	 * @generated
	 */
	void setNodeCoordVariable(Variable value);

	/**
	 * Returns the value of the '<em><b>Current Time Variable</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Current Time Variable</em>' reference.
	 * @see #setCurrentTimeVariable(Variable)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getIrRoot_CurrentTimeVariable()
	 * @model required="true"
	 * @generated
	 */
	Variable getCurrentTimeVariable();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.IrRoot#getCurrentTimeVariable <em>Current Time Variable</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Current Time Variable</em>' reference.
	 * @see #getCurrentTimeVariable()
	 * @generated
	 */
	void setCurrentTimeVariable(Variable value);

	/**
	 * Returns the value of the '<em><b>Next Time Variable</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Next Time Variable</em>' reference.
	 * @see #setNextTimeVariable(Variable)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getIrRoot_NextTimeVariable()
	 * @model required="true"
	 * @generated
	 */
	Variable getNextTimeVariable();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.IrRoot#getNextTimeVariable <em>Next Time Variable</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Next Time Variable</em>' reference.
	 * @see #getNextTimeVariable()
	 * @generated
	 */
	void setNextTimeVariable(Variable value);

	/**
	 * Returns the value of the '<em><b>Time Step Variable</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Time Step Variable</em>' reference.
	 * @see #setTimeStepVariable(Variable)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getIrRoot_TimeStepVariable()
	 * @model required="true"
	 * @generated
	 */
	Variable getTimeStepVariable();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.IrRoot#getTimeStepVariable <em>Time Step Variable</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Time Step Variable</em>' reference.
	 * @see #getTimeStepVariable()
	 * @generated
	 */
	void setTimeStepVariable(Variable value);

	/**
	 * Returns the value of the '<em><b>Post Processing</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Post Processing</em>' containment reference.
	 * @see #setPostProcessing(PostProcessing)
	 * @see fr.cea.nabla.ir.ir.IrPackage#getIrRoot_PostProcessing()
	 * @model containment="true" resolveProxies="true"
	 * @generated
	 */
	PostProcessing getPostProcessing();

	/**
	 * Sets the value of the '{@link fr.cea.nabla.ir.ir.IrRoot#getPostProcessing <em>Post Processing</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Post Processing</em>' containment reference.
	 * @see #getPostProcessing()
	 * @generated
	 */
	void setPostProcessing(PostProcessing value);

	/**
	 * Returns the value of the '<em><b>Providers</b></em>' containment reference list.
	 * The list contents are of type {@link fr.cea.nabla.ir.ir.ExtensionProvider}.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Providers</em>' containment reference list.
	 * @see fr.cea.nabla.ir.ir.IrPackage#getIrRoot_Providers()
	 * @model containment="true" resolveProxies="true"
	 * @generated
	 */
	EList<ExtensionProvider> getProviders();

} // IrRoot
