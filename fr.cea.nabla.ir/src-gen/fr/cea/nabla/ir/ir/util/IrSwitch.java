/**
 */
package fr.cea.nabla.ir.ir.util;

import fr.cea.nabla.ir.ir.*;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EPackage;

import org.eclipse.emf.ecore.util.Switch;

/**
 * <!-- begin-user-doc -->
 * The <b>Switch</b> for the model's inheritance hierarchy.
 * It supports the call {@link #doSwitch(EObject) doSwitch(object)}
 * to invoke the <code>caseXXX</code> method for each class of the model,
 * starting with the actual class of the object
 * and proceeding up the inheritance hierarchy
 * until a non-null result is returned,
 * which is the result of the switch.
 * <!-- end-user-doc -->
 * @see fr.cea.nabla.ir.ir.IrPackage
 * @generated
 */
public class IrSwitch<T> extends Switch<T> {
	/**
	 * The cached model package
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected static IrPackage modelPackage;

	/**
	 * Creates an instance of the switch.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public IrSwitch() {
		if (modelPackage == null) {
			modelPackage = IrPackage.eINSTANCE;
		}
	}

	/**
	 * Checks whether this is a switch for the given package.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param ePackage the package in question.
	 * @return whether this is a switch for the given package.
	 * @generated
	 */
	@Override
	protected boolean isSwitchFor(EPackage ePackage) {
		return ePackage == modelPackage;
	}

	/**
	 * Calls <code>caseXXX</code> for each class of the model until one returns a non null result; it yields that result.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the first non-null result returned by a <code>caseXXX</code> call.
	 * @generated
	 */
	@Override
	protected T doSwitch(int classifierID, EObject theEObject) {
		switch (classifierID) {
			case IrPackage.IR_ANNOTABLE: {
				IrAnnotable irAnnotable = (IrAnnotable)theEObject;
				T result = caseIrAnnotable(irAnnotable);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.IR_ANNOTATION: {
				IrAnnotation irAnnotation = (IrAnnotation)theEObject;
				T result = caseIrAnnotation(irAnnotation);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.IR_MODULE: {
				IrModule irModule = (IrModule)theEObject;
				T result = caseIrModule(irModule);
				if (result == null) result = caseIrAnnotable(irModule);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.IMPORT: {
				Import import_ = (Import)theEObject;
				T result = caseImport(import_);
				if (result == null) result = caseIrAnnotable(import_);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.VARIABLE: {
				Variable variable = (Variable)theEObject;
				T result = caseVariable(variable);
				if (result == null) result = caseIrAnnotable(variable);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.SIMPLE_VARIABLE: {
				SimpleVariable simpleVariable = (SimpleVariable)theEObject;
				T result = caseSimpleVariable(simpleVariable);
				if (result == null) result = caseVariable(simpleVariable);
				if (result == null) result = caseIrAnnotable(simpleVariable);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.CONNECTIVITY_VARIABLE: {
				ConnectivityVariable connectivityVariable = (ConnectivityVariable)theEObject;
				T result = caseConnectivityVariable(connectivityVariable);
				if (result == null) result = caseVariable(connectivityVariable);
				if (result == null) result = caseIrAnnotable(connectivityVariable);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.FUNCTION: {
				Function function = (Function)theEObject;
				T result = caseFunction(function);
				if (result == null) result = caseIrAnnotable(function);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.REDUCTION: {
				Reduction reduction = (Reduction)theEObject;
				T result = caseReduction(reduction);
				if (result == null) result = caseIrAnnotable(reduction);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.CONNECTIVITY: {
				Connectivity connectivity = (Connectivity)theEObject;
				T result = caseConnectivity(connectivity);
				if (result == null) result = caseIrAnnotable(connectivity);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.ITEM_ARG_TYPE: {
				ItemArgType itemArgType = (ItemArgType)theEObject;
				T result = caseItemArgType(itemArgType);
				if (result == null) result = caseIrAnnotable(itemArgType);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.JOB: {
				Job job = (Job)theEObject;
				T result = caseJob(job);
				if (result == null) result = caseIrAnnotable(job);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.INSTRUCTION_JOB: {
				InstructionJob instructionJob = (InstructionJob)theEObject;
				T result = caseInstructionJob(instructionJob);
				if (result == null) result = caseJob(instructionJob);
				if (result == null) result = caseIrAnnotable(instructionJob);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.TIME_ITERATION_COPY_JOB: {
				TimeIterationCopyJob timeIterationCopyJob = (TimeIterationCopyJob)theEObject;
				T result = caseTimeIterationCopyJob(timeIterationCopyJob);
				if (result == null) result = caseJob(timeIterationCopyJob);
				if (result == null) result = caseIrAnnotable(timeIterationCopyJob);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.END_OF_TIME_LOOP_JOB: {
				EndOfTimeLoopJob endOfTimeLoopJob = (EndOfTimeLoopJob)theEObject;
				T result = caseEndOfTimeLoopJob(endOfTimeLoopJob);
				if (result == null) result = caseTimeIterationCopyJob(endOfTimeLoopJob);
				if (result == null) result = caseJob(endOfTimeLoopJob);
				if (result == null) result = caseIrAnnotable(endOfTimeLoopJob);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.END_OF_INIT_JOB: {
				EndOfInitJob endOfInitJob = (EndOfInitJob)theEObject;
				T result = caseEndOfInitJob(endOfInitJob);
				if (result == null) result = caseTimeIterationCopyJob(endOfInitJob);
				if (result == null) result = caseJob(endOfInitJob);
				if (result == null) result = caseIrAnnotable(endOfInitJob);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.INSTRUCTION: {
				Instruction instruction = (Instruction)theEObject;
				T result = caseInstruction(instruction);
				if (result == null) result = caseIrAnnotable(instruction);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.VAR_DEFINITION: {
				VarDefinition varDefinition = (VarDefinition)theEObject;
				T result = caseVarDefinition(varDefinition);
				if (result == null) result = caseInstruction(varDefinition);
				if (result == null) result = caseIrAnnotable(varDefinition);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.INSTRUCTION_BLOCK: {
				InstructionBlock instructionBlock = (InstructionBlock)theEObject;
				T result = caseInstructionBlock(instructionBlock);
				if (result == null) result = caseInstruction(instructionBlock);
				if (result == null) result = caseIrAnnotable(instructionBlock);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.AFFECTATION: {
				Affectation affectation = (Affectation)theEObject;
				T result = caseAffectation(affectation);
				if (result == null) result = caseInstruction(affectation);
				if (result == null) result = caseIrAnnotable(affectation);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.ITERABLE_INSTRUCTION: {
				IterableInstruction iterableInstruction = (IterableInstruction)theEObject;
				T result = caseIterableInstruction(iterableInstruction);
				if (result == null) result = caseInstruction(iterableInstruction);
				if (result == null) result = caseIrAnnotable(iterableInstruction);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.REDUCTION_INSTRUCTION: {
				ReductionInstruction reductionInstruction = (ReductionInstruction)theEObject;
				T result = caseReductionInstruction(reductionInstruction);
				if (result == null) result = caseIterableInstruction(reductionInstruction);
				if (result == null) result = caseInstruction(reductionInstruction);
				if (result == null) result = caseIrAnnotable(reductionInstruction);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.LOOP: {
				Loop loop = (Loop)theEObject;
				T result = caseLoop(loop);
				if (result == null) result = caseIterableInstruction(loop);
				if (result == null) result = caseInstruction(loop);
				if (result == null) result = caseIrAnnotable(loop);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.IF: {
				If if_ = (If)theEObject;
				T result = caseIf(if_);
				if (result == null) result = caseInstruction(if_);
				if (result == null) result = caseIrAnnotable(if_);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.EXPRESSION: {
				Expression expression = (Expression)theEObject;
				T result = caseExpression(expression);
				if (result == null) result = caseIrAnnotable(expression);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.CONTRACTED_IF: {
				ContractedIf contractedIf = (ContractedIf)theEObject;
				T result = caseContractedIf(contractedIf);
				if (result == null) result = caseExpression(contractedIf);
				if (result == null) result = caseIrAnnotable(contractedIf);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.BINARY_EXPRESSION: {
				BinaryExpression binaryExpression = (BinaryExpression)theEObject;
				T result = caseBinaryExpression(binaryExpression);
				if (result == null) result = caseExpression(binaryExpression);
				if (result == null) result = caseIrAnnotable(binaryExpression);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.UNARY_EXPRESSION: {
				UnaryExpression unaryExpression = (UnaryExpression)theEObject;
				T result = caseUnaryExpression(unaryExpression);
				if (result == null) result = caseExpression(unaryExpression);
				if (result == null) result = caseIrAnnotable(unaryExpression);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.PARENTHESIS: {
				Parenthesis parenthesis = (Parenthesis)theEObject;
				T result = caseParenthesis(parenthesis);
				if (result == null) result = caseExpression(parenthesis);
				if (result == null) result = caseIrAnnotable(parenthesis);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.CONSTANT: {
				Constant constant = (Constant)theEObject;
				T result = caseConstant(constant);
				if (result == null) result = caseExpression(constant);
				if (result == null) result = caseIrAnnotable(constant);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.MIN_CONSTANT: {
				MinConstant minConstant = (MinConstant)theEObject;
				T result = caseMinConstant(minConstant);
				if (result == null) result = caseExpression(minConstant);
				if (result == null) result = caseIrAnnotable(minConstant);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.MAX_CONSTANT: {
				MaxConstant maxConstant = (MaxConstant)theEObject;
				T result = caseMaxConstant(maxConstant);
				if (result == null) result = caseExpression(maxConstant);
				if (result == null) result = caseIrAnnotable(maxConstant);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.BASE_TYPE_CONSTANT: {
				BaseTypeConstant baseTypeConstant = (BaseTypeConstant)theEObject;
				T result = caseBaseTypeConstant(baseTypeConstant);
				if (result == null) result = caseExpression(baseTypeConstant);
				if (result == null) result = caseIrAnnotable(baseTypeConstant);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.REAL_VECTOR_CONSTANT: {
				RealVectorConstant realVectorConstant = (RealVectorConstant)theEObject;
				T result = caseRealVectorConstant(realVectorConstant);
				if (result == null) result = caseExpression(realVectorConstant);
				if (result == null) result = caseIrAnnotable(realVectorConstant);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.REAL_MATRIX_CONSTANT: {
				RealMatrixConstant realMatrixConstant = (RealMatrixConstant)theEObject;
				T result = caseRealMatrixConstant(realMatrixConstant);
				if (result == null) result = caseExpression(realMatrixConstant);
				if (result == null) result = caseIrAnnotable(realMatrixConstant);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.FUNCTION_CALL: {
				FunctionCall functionCall = (FunctionCall)theEObject;
				T result = caseFunctionCall(functionCall);
				if (result == null) result = caseExpression(functionCall);
				if (result == null) result = caseIrAnnotable(functionCall);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.VAR_REF: {
				VarRef varRef = (VarRef)theEObject;
				T result = caseVarRef(varRef);
				if (result == null) result = caseExpression(varRef);
				if (result == null) result = caseIrAnnotable(varRef);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.ITERATOR: {
				Iterator iterator = (Iterator)theEObject;
				T result = caseIterator(iterator);
				if (result == null) result = caseIrAnnotable(iterator);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.CONNECTIVITY_CALL: {
				ConnectivityCall connectivityCall = (ConnectivityCall)theEObject;
				T result = caseConnectivityCall(connectivityCall);
				if (result == null) result = caseIrAnnotable(connectivityCall);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.ITERATOR_REF: {
				IteratorRef iteratorRef = (IteratorRef)theEObject;
				T result = caseIteratorRef(iteratorRef);
				if (result == null) result = caseIrAnnotable(iteratorRef);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.CONNECTIVITY_CALL_ITERATOR_REF: {
				ConnectivityCallIteratorRef connectivityCallIteratorRef = (ConnectivityCallIteratorRef)theEObject;
				T result = caseConnectivityCallIteratorRef(connectivityCallIteratorRef);
				if (result == null) result = caseIteratorRef(connectivityCallIteratorRef);
				if (result == null) result = caseIrAnnotable(connectivityCallIteratorRef);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.VAR_REF_ITERATOR_REF: {
				VarRefIteratorRef varRefIteratorRef = (VarRefIteratorRef)theEObject;
				T result = caseVarRefIteratorRef(varRefIteratorRef);
				if (result == null) result = caseIteratorRef(varRefIteratorRef);
				if (result == null) result = caseIrAnnotable(varRefIteratorRef);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.ITEM_TYPE: {
				ItemType itemType = (ItemType)theEObject;
				T result = caseItemType(itemType);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.BASE_TYPE: {
				BaseType baseType = (BaseType)theEObject;
				T result = caseBaseType(baseType);
				if (result == null) result = caseIrAnnotable(baseType);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.EXPRESSION_TYPE: {
				ExpressionType expressionType = (ExpressionType)theEObject;
				T result = caseExpressionType(expressionType);
				if (result == null) result = caseBaseType(expressionType);
				if (result == null) result = caseIrAnnotable(expressionType);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.ARG_TYPE: {
				ArgType argType = (ArgType)theEObject;
				T result = caseArgType(argType);
				if (result == null) result = caseIrAnnotable(argType);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			default: return defaultCase(theEObject);
		}
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Annotable</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Annotable</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseIrAnnotable(IrAnnotable object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Annotation</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Annotation</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseIrAnnotation(IrAnnotation object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Module</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Module</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseIrModule(IrModule object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Import</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Import</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseImport(Import object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Variable</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Variable</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseVariable(Variable object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Simple Variable</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Simple Variable</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseSimpleVariable(SimpleVariable object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Connectivity Variable</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Connectivity Variable</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseConnectivityVariable(ConnectivityVariable object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Function</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Function</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseFunction(Function object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Reduction</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Reduction</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseReduction(Reduction object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Connectivity</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Connectivity</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseConnectivity(Connectivity object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Item Arg Type</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Item Arg Type</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseItemArgType(ItemArgType object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Job</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Job</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseJob(Job object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Instruction Job</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Instruction Job</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseInstructionJob(InstructionJob object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Time Iteration Copy Job</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Time Iteration Copy Job</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseTimeIterationCopyJob(TimeIterationCopyJob object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>End Of Time Loop Job</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>End Of Time Loop Job</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseEndOfTimeLoopJob(EndOfTimeLoopJob object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>End Of Init Job</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>End Of Init Job</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseEndOfInitJob(EndOfInitJob object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Instruction</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Instruction</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseInstruction(Instruction object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Var Definition</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Var Definition</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseVarDefinition(VarDefinition object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Instruction Block</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Instruction Block</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseInstructionBlock(InstructionBlock object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Affectation</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Affectation</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseAffectation(Affectation object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Iterable Instruction</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Iterable Instruction</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseIterableInstruction(IterableInstruction object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Reduction Instruction</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Reduction Instruction</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseReductionInstruction(ReductionInstruction object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Loop</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Loop</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseLoop(Loop object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>If</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>If</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseIf(If object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Expression</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Expression</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseExpression(Expression object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Contracted If</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Contracted If</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseContractedIf(ContractedIf object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Binary Expression</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Binary Expression</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseBinaryExpression(BinaryExpression object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Unary Expression</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Unary Expression</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseUnaryExpression(UnaryExpression object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Parenthesis</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Parenthesis</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseParenthesis(Parenthesis object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Constant</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Constant</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseConstant(Constant object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Max Constant</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Max Constant</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseMaxConstant(MaxConstant object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Base Type Constant</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Base Type Constant</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseBaseTypeConstant(BaseTypeConstant object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Real Vector Constant</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Real Vector Constant</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseRealVectorConstant(RealVectorConstant object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Real Matrix Constant</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Real Matrix Constant</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseRealMatrixConstant(RealMatrixConstant object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Min Constant</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Min Constant</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseMinConstant(MinConstant object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Function Call</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Function Call</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseFunctionCall(FunctionCall object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Var Ref</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Var Ref</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseVarRef(VarRef object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Iterator</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Iterator</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseIterator(Iterator object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Connectivity Call</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Connectivity Call</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseConnectivityCall(ConnectivityCall object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Iterator Ref</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Iterator Ref</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseIteratorRef(IteratorRef object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Connectivity Call Iterator Ref</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Connectivity Call Iterator Ref</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseConnectivityCallIteratorRef(ConnectivityCallIteratorRef object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Var Ref Iterator Ref</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Var Ref Iterator Ref</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseVarRefIteratorRef(VarRefIteratorRef object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Item Type</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Item Type</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseItemType(ItemType object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Base Type</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Base Type</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseBaseType(BaseType object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Expression Type</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Expression Type</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseExpressionType(ExpressionType object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Arg Type</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Arg Type</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseArgType(ArgType object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>EObject</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch, but this is the last case anyway.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>EObject</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject)
	 * @generated
	 */
	@Override
	public T defaultCase(EObject object) {
		return null;
	}

} //IrSwitch
