/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 *
 * Contributors:
 * 	Benoit Lelandais - initial implementation
 * 	Marie-Pierre Oudot - initial implementation
 * 	Jean-Sylvain Camier - Nabla generation support
 *******************************************************************************/
package fr.cea.nabla.validation

import com.google.inject.Inject
import fr.cea.nabla.MandatoryOptions
import fr.cea.nabla.VarExtensions
import fr.cea.nabla.nabla.Affectation
import fr.cea.nabla.nabla.ArrayVar
import fr.cea.nabla.nabla.Connectivity
import fr.cea.nabla.nabla.Function
import fr.cea.nabla.nabla.FunctionCall
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.NablaPackage
import fr.cea.nabla.nabla.Reduction
import fr.cea.nabla.nabla.ReductionCall
import fr.cea.nabla.nabla.ScalarVarDefinition
import fr.cea.nabla.nabla.SpaceIterator
import fr.cea.nabla.nabla.SpaceIteratorRange
import fr.cea.nabla.nabla.SpaceIteratorRef
import fr.cea.nabla.nabla.Var
import fr.cea.nabla.nabla.VarGroupDeclaration
import fr.cea.nabla.nabla.VarRef
import org.eclipse.xtext.validation.Check

import static extension fr.cea.nabla.Utils.*

class BasicValidator  extends AbstractNablaValidator
{
	public static val NO_COORD_VARIABLE = "NablaError::NoCoordVariable"
	
	@Inject extension VarExtensions
	
	@Check
	def checkNoInnerReductionCall(ReductionCall it)
	{
		if (arg instanceof ReductionCall || arg.eAllContents.exists[x|x instanceof ReductionCall])
			error('Reduction must not contains reduction', NablaPackage.Literals.REDUCTION_CALL__ARG)
	}
	
	@Check
	def checkCoordVar(NablaModule it)
	{
		if (!variables.filter(VarGroupDeclaration).exists[g | g.variables.exists[v|v.name == MandatoryOptions::COORD]])
			warning("Module must contain a node variable named '" + MandatoryOptions::COORD + "' to store node coordinates", NablaPackage.Literals.NABLA_MODULE__NAME, NO_COORD_VARIABLE)
	}
	
	@Check
	def checkName(NablaModule it)
	{
		if (!name.nullOrEmpty && Character::isLowerCase(name.charAt(0)))
			error('Module name must start with an uppercase', NablaPackage.Literals.NABLA_MODULE__NAME)
	}
	
	@Check
	def checkUnusedVariables(Var it)
	{
		val referenced = MandatoryOptions::OPTION_NAMES.contains(name) || nablaModule.eAllContents.filter(VarRef).exists[x|x.variable===it]
		if (!referenced)
			warning('Unused variable', NablaPackage.Literals::VAR__NAME)
	}
	
	@Check
	def checkUnusedFunctions(Function it)
	{
		val referenced = nablaModule.eAllContents.filter(FunctionCall).exists[x|x.function===it]
		if (!referenced)
			warning('Unused function', NablaPackage.Literals::FUNCTION__NAME)
	}	
	
	@Check
	def checkUnusedReductions(Reduction it)
	{
		val referenced = nablaModule.eAllContents.filter(ReductionCall).exists[x|x.reduction===it]
		if (!referenced)
			warning('Unused function', NablaPackage.Literals::REDUCTION__NAME)
	}	

	@Check
	def checkUnusedConnectivities(Connectivity it)
	{
		val referenced = nablaModule.eAllContents.filter(SpaceIteratorRange).exists[x|x.connectivity===it]
			|| nablaModule.eAllContents.filter(ArrayVar).exists[x|x.dimensions.contains(it)]
		if (!referenced)
			warning('Unused connectivity', NablaPackage.Literals::CONNECTIVITY__NAME)
	}	

	@Check
	def checkDimensions(ArrayVar it)
	{
		if (dimensions.empty) return;

		if (!dimensions.exists[d | d.returnType.multiple])
				error('All dimensions must be on connectivities which return a set of items', NablaPackage.Literals::ARRAY_VAR__DIMENSIONS)

		if (!dimensions.head.inTypes.empty)
			error('Dimension 1 must be on connectivities with 0 argument', NablaPackage.Literals::ARRAY_VAR__DIMENSIONS)
		
		for (i : 1..<dimensions.length)
		{
			if (dimensions.get(i).inTypes.length != 1)
				error('Dimension 2..N must be on connectivities with 1 argument', NablaPackage.Literals::ARRAY_VAR__DIMENSIONS, i)
			else if (dimensions.get(i).inTypes.head != dimensions.get(i-1).returnType.type)
				error('Dimension ' + (i+1) + ' argument must have same type as dimension ' + i + ' return type', NablaPackage.Literals::ARRAY_VAR__DIMENSIONS, i)
		}
	}

	@Check
	def checkConstVar(Affectation it)
	{
		if (varRef.variable.isConst && (varRef.variable.eContainer instanceof NablaModule))
			error('Affectation to const variable', NablaPackage.Literals::AFFECTATION__VAR_REF)
	}
	
	@Check
	def checkConstVar(ScalarVarDefinition it)
	{
		if (isConst && defaultValue!==null && defaultValue.eAllContents.filter(VarRef).exists[x|!x.variable.isConst])
			error('Assignment with non const variables', NablaPackage.Literals::SCALAR_VAR_DEFINITION__DEFAULT_VALUE)
	}
	
	@Check
	def checkOnlyScalarVarInInstructions(ArrayVar it)
	{
		val varGroupDeclaration = eContainer
		if (varGroupDeclaration !== null && !(varGroupDeclaration.eContainer instanceof NablaModule))
			error('Local variables can only be scalar (no array).', NablaPackage.Literals::VAR__NAME)
	}

	@Check
	def checkIteratorRange(VarRef it)
	{
		if (variable instanceof ArrayVar)
		{
			val dimensions = (variable as ArrayVar).dimensions
			if (dimensions.length < spaceIterators.length)
				error('Too many indices: ' + spaceIterators.length + '(variable dimension is ' + dimensions.length + ')', NablaPackage.Literals::VAR_REF__SPACE_ITERATORS)
			else
			{
				for (i : 0..<spaceIterators.length)
				{
					val si = spaceIterators.get(i)
					val expectedC = dimensions.get(i)
					val expectedT = expectedC.returnType.type
					switch si
					{
						SpaceIteratorRange: 
						{
							val rt = si.connectivity.returnType
							if (rt.multiple) 
								error('Connectivity return type must be a singleton', NablaPackage.Literals::VAR_REF__SPACE_ITERATORS)
							else if (rt.type != expectedT)
								error('Wrong iterator type: Expected ' + expectedT.name + ', but was ' + rt.type.name, NablaPackage.Literals::VAR_REF__SPACE_ITERATORS, i)
						}
						SpaceIteratorRef:
						{
							val actualT = si.iterator.range.connectivity.returnType.type
							if (actualT != expectedT)
								error('Wrong iterator type: Expected ' + expectedT.name + ', but was ' + actualT.name, NablaPackage.Literals::VAR_REF__SPACE_ITERATORS, i)
//							else
//							{	
//								val actualC = si.iterator.range.connectivity
//								if (actualC !== expectedC && !expectedC.inTypes.empty)
//									// Les connectivités sont différentes (ex: cells, cellsOfNode).
//									// Celle de la variable doit être globale, i.e. sans inTypes (ex: cells)
//									error('Wrong iterator type: ' + actualC.name + ' is not a subset of ' + expectedC.name, NablaPackage.Literals::VAR_REF__SPACE_ITERATORS, i)
//							}
						}
					}
				}
			}
		}
	}
	
	@Check
	def checkArgs(SpaceIterator it)
	{
		if (!range.connectivity.returnType.multiple)
			error('Range of iteration must not be a singleton', NablaPackage.Literals::SPACE_ITERATOR__RANGE)
	}

	@Check
	def checkArgs(SpaceIteratorRange it)
	{
		if (args.length != connectivity.inTypes.length)
			error('Invalid number of arguments: Expected ' + connectivity.inTypes.length + ', but was ' + args.length, NablaPackage.Literals::SPACE_ITERATOR_RANGE__ARGS)
		else
		{
			for (i : 0..<args.length)
			{
				val si = args.get(i)
				val expectedT = connectivity.inTypes.get(i)
				switch si
				{
					SpaceIteratorRange: 
					{
						val actualT = si.connectivity.returnType.type
						if (actualT != expectedT)
							error('Wrong arguments: Expected ' + expectedT.name + ', but was ' + actualT.name, NablaPackage.Literals::SPACE_ITERATOR_RANGE__ARGS, i)
					}
					SpaceIteratorRef:
					{
						val actualT = si.iterator.range.connectivity.returnType.type
						if (actualT != expectedT)
							error('Wrong arguments: Expected ' + expectedT.name + ', but was ' + actualT.name, NablaPackage.Literals::SPACE_ITERATOR_RANGE__ARGS, i)
					}
				}
			}
		}
	}
}