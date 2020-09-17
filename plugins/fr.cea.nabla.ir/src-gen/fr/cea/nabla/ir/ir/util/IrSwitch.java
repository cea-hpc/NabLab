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
			case IrPackage.JOB_CONTAINER: {
				JobContainer jobContainer = (JobContainer)theEObject;
				T result = caseJobContainer(jobContainer);
				if (result == null) result = caseIrAnnotable(jobContainer);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.TIME_LOOP_CONTAINER: {
				TimeLoopContainer timeLoopContainer = (TimeLoopContainer)theEObject;
				T result = caseTimeLoopContainer(timeLoopContainer);
				if (result == null) result = caseIrAnnotable(timeLoopContainer);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.IR_MODULE: {
				IrModule irModule = (IrModule)theEObject;
				T result = caseIrModule(irModule);
				if (result == null) result = caseJobContainer(irModule);
				if (result == null) result = caseTimeLoopContainer(irModule);
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
			case IrPackage.POST_PROCESSING_INFO: {
				PostProcessingInfo postProcessingInfo = (PostProcessingInfo)theEObject;
				T result = casePostProcessingInfo(postProcessingInfo);
				if (result == null) result = caseIrAnnotable(postProcessingInfo);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.TIME_LOOP: {
				TimeLoop timeLoop = (TimeLoop)theEObject;
				T result = caseTimeLoop(timeLoop);
				if (result == null) result = caseTimeLoopContainer(timeLoop);
				if (result == null) result = caseIrAnnotable(timeLoop);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.ARG_OR_VAR: {
				ArgOrVar argOrVar = (ArgOrVar)theEObject;
				T result = caseArgOrVar(argOrVar);
				if (result == null) result = caseIrAnnotable(argOrVar);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.ARG: {
				Arg arg = (Arg)theEObject;
				T result = caseArg(arg);
				if (result == null) result = caseArgOrVar(arg);
				if (result == null) result = caseIrAnnotable(arg);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.VARIABLE: {
				Variable variable = (Variable)theEObject;
				T result = caseVariable(variable);
				if (result == null) result = caseArgOrVar(variable);
				if (result == null) result = caseIrAnnotable(variable);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.SIMPLE_VARIABLE: {
				SimpleVariable simpleVariable = (SimpleVariable)theEObject;
				T result = caseSimpleVariable(simpleVariable);
				if (result == null) result = caseVariable(simpleVariable);
				if (result == null) result = caseArgOrVar(simpleVariable);
				if (result == null) result = caseIrAnnotable(simpleVariable);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.CONNECTIVITY_VARIABLE: {
				ConnectivityVariable connectivityVariable = (ConnectivityVariable)theEObject;
				T result = caseConnectivityVariable(connectivityVariable);
				if (result == null) result = caseVariable(connectivityVariable);
				if (result == null) result = caseArgOrVar(connectivityVariable);
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
			case IrPackage.CONNECTIVITY: {
				Connectivity connectivity = (Connectivity)theEObject;
				T result = caseConnectivity(connectivity);
				if (result == null) result = caseIrAnnotable(connectivity);
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
			case IrPackage.TIME_LOOP_JOB: {
				TimeLoopJob timeLoopJob = (TimeLoopJob)theEObject;
				T result = caseTimeLoopJob(timeLoopJob);
				if (result == null) result = caseTimeLoopCopyJob(timeLoopJob);
				if (result == null) result = caseJobContainer(timeLoopJob);
				if (result == null) result = caseJob(timeLoopJob);
				if (result == null) result = caseIrAnnotable(timeLoopJob);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.TIME_LOOP_COPY_JOB: {
				TimeLoopCopyJob timeLoopCopyJob = (TimeLoopCopyJob)theEObject;
				T result = caseTimeLoopCopyJob(timeLoopCopyJob);
				if (result == null) result = caseJob(timeLoopCopyJob);
				if (result == null) result = caseIrAnnotable(timeLoopCopyJob);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.BEFORE_TIME_LOOP_JOB: {
				BeforeTimeLoopJob beforeTimeLoopJob = (BeforeTimeLoopJob)theEObject;
				T result = caseBeforeTimeLoopJob(beforeTimeLoopJob);
				if (result == null) result = caseTimeLoopCopyJob(beforeTimeLoopJob);
				if (result == null) result = caseJob(beforeTimeLoopJob);
				if (result == null) result = caseIrAnnotable(beforeTimeLoopJob);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.AFTER_TIME_LOOP_JOB: {
				AfterTimeLoopJob afterTimeLoopJob = (AfterTimeLoopJob)theEObject;
				T result = caseAfterTimeLoopJob(afterTimeLoopJob);
				if (result == null) result = caseTimeLoopCopyJob(afterTimeLoopJob);
				if (result == null) result = caseJob(afterTimeLoopJob);
				if (result == null) result = caseIrAnnotable(afterTimeLoopJob);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.TIME_LOOP_COPY: {
				TimeLoopCopy timeLoopCopy = (TimeLoopCopy)theEObject;
				T result = caseTimeLoopCopy(timeLoopCopy);
				if (result == null) result = caseIrAnnotable(timeLoopCopy);
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
			case IrPackage.INSTRUCTION_BLOCK: {
				InstructionBlock instructionBlock = (InstructionBlock)theEObject;
				T result = caseInstructionBlock(instructionBlock);
				if (result == null) result = caseInstruction(instructionBlock);
				if (result == null) result = caseIrAnnotable(instructionBlock);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.VARIABLE_DECLARATION: {
				VariableDeclaration variableDeclaration = (VariableDeclaration)theEObject;
				T result = caseVariableDeclaration(variableDeclaration);
				if (result == null) result = caseInstruction(variableDeclaration);
				if (result == null) result = caseIrAnnotable(variableDeclaration);
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
			case IrPackage.ITEM_INDEX_DEFINITION: {
				ItemIndexDefinition itemIndexDefinition = (ItemIndexDefinition)theEObject;
				T result = caseItemIndexDefinition(itemIndexDefinition);
				if (result == null) result = caseInstruction(itemIndexDefinition);
				if (result == null) result = caseIrAnnotable(itemIndexDefinition);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.ITEM_ID_DEFINITION: {
				ItemIdDefinition itemIdDefinition = (ItemIdDefinition)theEObject;
				T result = caseItemIdDefinition(itemIdDefinition);
				if (result == null) result = caseInstruction(itemIdDefinition);
				if (result == null) result = caseIrAnnotable(itemIdDefinition);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.SET_DEFINITION: {
				SetDefinition setDefinition = (SetDefinition)theEObject;
				T result = caseSetDefinition(setDefinition);
				if (result == null) result = caseInstruction(setDefinition);
				if (result == null) result = caseIrAnnotable(setDefinition);
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
			case IrPackage.WHILE: {
				While while_ = (While)theEObject;
				T result = caseWhile(while_);
				if (result == null) result = caseInstruction(while_);
				if (result == null) result = caseIrAnnotable(while_);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.RETURN: {
				Return return_ = (Return)theEObject;
				T result = caseReturn(return_);
				if (result == null) result = caseInstruction(return_);
				if (result == null) result = caseIrAnnotable(return_);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.EXIT: {
				Exit exit = (Exit)theEObject;
				T result = caseExit(exit);
				if (result == null) result = caseInstruction(exit);
				if (result == null) result = caseIrAnnotable(exit);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.ITERATION_BLOCK: {
				IterationBlock iterationBlock = (IterationBlock)theEObject;
				T result = caseIterationBlock(iterationBlock);
				if (result == null) result = caseIrAnnotable(iterationBlock);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.ITERATOR: {
				Iterator iterator = (Iterator)theEObject;
				T result = caseIterator(iterator);
				if (result == null) result = caseIterationBlock(iterator);
				if (result == null) result = caseIrAnnotable(iterator);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.INTERVAL: {
				Interval interval = (Interval)theEObject;
				T result = caseInterval(interval);
				if (result == null) result = caseIterationBlock(interval);
				if (result == null) result = caseIrAnnotable(interval);
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
			case IrPackage.INT_CONSTANT: {
				IntConstant intConstant = (IntConstant)theEObject;
				T result = caseIntConstant(intConstant);
				if (result == null) result = caseExpression(intConstant);
				if (result == null) result = caseIrAnnotable(intConstant);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.REAL_CONSTANT: {
				RealConstant realConstant = (RealConstant)theEObject;
				T result = caseRealConstant(realConstant);
				if (result == null) result = caseExpression(realConstant);
				if (result == null) result = caseIrAnnotable(realConstant);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.BOOL_CONSTANT: {
				BoolConstant boolConstant = (BoolConstant)theEObject;
				T result = caseBoolConstant(boolConstant);
				if (result == null) result = caseExpression(boolConstant);
				if (result == null) result = caseIrAnnotable(boolConstant);
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
			case IrPackage.FUNCTION_CALL: {
				FunctionCall functionCall = (FunctionCall)theEObject;
				T result = caseFunctionCall(functionCall);
				if (result == null) result = caseExpression(functionCall);
				if (result == null) result = caseIrAnnotable(functionCall);
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
			case IrPackage.VECTOR_CONSTANT: {
				VectorConstant vectorConstant = (VectorConstant)theEObject;
				T result = caseVectorConstant(vectorConstant);
				if (result == null) result = caseExpression(vectorConstant);
				if (result == null) result = caseIrAnnotable(vectorConstant);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.CARDINALITY: {
				Cardinality cardinality = (Cardinality)theEObject;
				T result = caseCardinality(cardinality);
				if (result == null) result = caseExpression(cardinality);
				if (result == null) result = caseIrAnnotable(cardinality);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.ARG_OR_VAR_REF: {
				ArgOrVarRef argOrVarRef = (ArgOrVarRef)theEObject;
				T result = caseArgOrVarRef(argOrVarRef);
				if (result == null) result = caseExpression(argOrVarRef);
				if (result == null) result = caseIrAnnotable(argOrVarRef);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.ITEM_TYPE: {
				ItemType itemType = (ItemType)theEObject;
				T result = caseItemType(itemType);
				if (result == null) result = caseIrAnnotable(itemType);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.IR_TYPE: {
				IrType irType = (IrType)theEObject;
				T result = caseIrType(irType);
				if (result == null) result = caseIrAnnotable(irType);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.BASE_TYPE: {
				BaseType baseType = (BaseType)theEObject;
				T result = caseBaseType(baseType);
				if (result == null) result = caseIrType(baseType);
				if (result == null) result = caseIrAnnotable(baseType);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.CONNECTIVITY_TYPE: {
				ConnectivityType connectivityType = (ConnectivityType)theEObject;
				T result = caseConnectivityType(connectivityType);
				if (result == null) result = caseIrType(connectivityType);
				if (result == null) result = caseIrAnnotable(connectivityType);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.TIME_LOOP_VARIABLE: {
				TimeLoopVariable timeLoopVariable = (TimeLoopVariable)theEObject;
				T result = caseTimeLoopVariable(timeLoopVariable);
				if (result == null) result = caseIrAnnotable(timeLoopVariable);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.CONTAINER: {
				Container container = (Container)theEObject;
				T result = caseContainer(container);
				if (result == null) result = caseIrAnnotable(container);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.CONNECTIVITY_CALL: {
				ConnectivityCall connectivityCall = (ConnectivityCall)theEObject;
				T result = caseConnectivityCall(connectivityCall);
				if (result == null) result = caseContainer(connectivityCall);
				if (result == null) result = caseIrAnnotable(connectivityCall);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.SET_REF: {
				SetRef setRef = (SetRef)theEObject;
				T result = caseSetRef(setRef);
				if (result == null) result = caseContainer(setRef);
				if (result == null) result = caseIrAnnotable(setRef);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.ITEM_ID: {
				ItemId itemId = (ItemId)theEObject;
				T result = caseItemId(itemId);
				if (result == null) result = caseIrAnnotable(itemId);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.ITEM_ID_VALUE: {
				ItemIdValue itemIdValue = (ItemIdValue)theEObject;
				T result = caseItemIdValue(itemIdValue);
				if (result == null) result = caseIrAnnotable(itemIdValue);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.ITEM_ID_VALUE_ITERATOR: {
				ItemIdValueIterator itemIdValueIterator = (ItemIdValueIterator)theEObject;
				T result = caseItemIdValueIterator(itemIdValueIterator);
				if (result == null) result = caseItemIdValue(itemIdValueIterator);
				if (result == null) result = caseIrAnnotable(itemIdValueIterator);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.ITEM_ID_VALUE_CONTAINER: {
				ItemIdValueContainer itemIdValueContainer = (ItemIdValueContainer)theEObject;
				T result = caseItemIdValueContainer(itemIdValueContainer);
				if (result == null) result = caseItemIdValue(itemIdValueContainer);
				if (result == null) result = caseIrAnnotable(itemIdValueContainer);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.ITEM_INDEX: {
				ItemIndex itemIndex = (ItemIndex)theEObject;
				T result = caseItemIndex(itemIndex);
				if (result == null) result = caseIrAnnotable(itemIndex);
				if (result == null) result = defaultCase(theEObject);
				return result;
			}
			case IrPackage.ITEM_INDEX_VALUE: {
				ItemIndexValue itemIndexValue = (ItemIndexValue)theEObject;
				T result = caseItemIndexValue(itemIndexValue);
				if (result == null) result = caseIrAnnotable(itemIndexValue);
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
	 * Returns the result of interpreting the object as an instance of '<em>Job Container</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Job Container</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseJobContainer(JobContainer object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Time Loop Container</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Time Loop Container</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseTimeLoopContainer(TimeLoopContainer object) {
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
	 * Returns the result of interpreting the object as an instance of '<em>Post Processing Info</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Post Processing Info</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T casePostProcessingInfo(PostProcessingInfo object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Time Loop</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Time Loop</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseTimeLoop(TimeLoop object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Arg Or Var</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Arg Or Var</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseArgOrVar(ArgOrVar object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Arg</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Arg</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseArg(Arg object) {
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
	 * Returns the result of interpreting the object as an instance of '<em>Time Loop Job</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Time Loop Job</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseTimeLoopJob(TimeLoopJob object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Time Loop Copy Job</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Time Loop Copy Job</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseTimeLoopCopyJob(TimeLoopCopyJob object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Before Time Loop Job</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Before Time Loop Job</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseBeforeTimeLoopJob(BeforeTimeLoopJob object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>After Time Loop Job</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>After Time Loop Job</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseAfterTimeLoopJob(AfterTimeLoopJob object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Time Loop Copy</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Time Loop Copy</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseTimeLoopCopy(TimeLoopCopy object) {
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
	 * Returns the result of interpreting the object as an instance of '<em>Variable Declaration</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Variable Declaration</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseVariableDeclaration(VariableDeclaration object) {
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
	 * Returns the result of interpreting the object as an instance of '<em>Item Index Definition</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Item Index Definition</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseItemIndexDefinition(ItemIndexDefinition object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Item Id Definition</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Item Id Definition</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseItemIdDefinition(ItemIdDefinition object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Set Definition</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Set Definition</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseSetDefinition(SetDefinition object) {
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
	 * Returns the result of interpreting the object as an instance of '<em>While</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>While</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseWhile(While object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Return</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Return</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseReturn(Return object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Exit</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Exit</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseExit(Exit object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Iteration Block</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Iteration Block</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseIterationBlock(IterationBlock object) {
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
	 * Returns the result of interpreting the object as an instance of '<em>Interval</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Interval</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseInterval(Interval object) {
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
	 * Returns the result of interpreting the object as an instance of '<em>Int Constant</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Int Constant</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseIntConstant(IntConstant object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Real Constant</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Real Constant</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseRealConstant(RealConstant object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Bool Constant</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Bool Constant</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseBoolConstant(BoolConstant object) {
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
	 * Returns the result of interpreting the object as an instance of '<em>Vector Constant</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Vector Constant</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseVectorConstant(VectorConstant object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Cardinality</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Cardinality</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseCardinality(Cardinality object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Arg Or Var Ref</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Arg Or Var Ref</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseArgOrVarRef(ArgOrVarRef object) {
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
	 * Returns the result of interpreting the object as an instance of '<em>Type</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Type</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseIrType(IrType object) {
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
	 * Returns the result of interpreting the object as an instance of '<em>Connectivity Type</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Connectivity Type</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseConnectivityType(ConnectivityType object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Time Loop Variable</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Time Loop Variable</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseTimeLoopVariable(TimeLoopVariable object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Container</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Container</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseContainer(Container object) {
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
	 * Returns the result of interpreting the object as an instance of '<em>Set Ref</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Set Ref</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseSetRef(SetRef object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Item Id</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Item Id</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseItemId(ItemId object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Item Id Value</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Item Id Value</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseItemIdValue(ItemIdValue object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Item Id Value Iterator</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Item Id Value Iterator</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseItemIdValueIterator(ItemIdValueIterator object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Item Id Value Container</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Item Id Value Container</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseItemIdValueContainer(ItemIdValueContainer object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Item Index</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Item Index</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseItemIndex(ItemIndex object) {
		return null;
	}

	/**
	 * Returns the result of interpreting the object as an instance of '<em>Item Index Value</em>'.
	 * <!-- begin-user-doc -->
	 * This implementation returns null;
	 * returning a non-null result will terminate the switch.
	 * <!-- end-user-doc -->
	 * @param object the target of the switch.
	 * @return the result of interpreting the object as an instance of '<em>Item Index Value</em>'.
	 * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
	 * @generated
	 */
	public T caseItemIndexValue(ItemIndexValue object) {
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
