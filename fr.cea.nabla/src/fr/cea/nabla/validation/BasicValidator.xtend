package fr.cea.nabla.validation

import com.google.inject.Inject
import fr.cea.nabla.MandatoryOptions
import fr.cea.nabla.VarExtensions
import fr.cea.nabla.nabla.Affectation
import fr.cea.nabla.nabla.ArrayVar
import fr.cea.nabla.nabla.Connectivity
import fr.cea.nabla.nabla.Function
import fr.cea.nabla.nabla.FunctionCall
import fr.cea.nabla.nabla.NablaPackage
import fr.cea.nabla.nabla.Reduction
import fr.cea.nabla.nabla.ReductionCall
import fr.cea.nabla.nabla.ScalarVarDefinition
import fr.cea.nabla.nabla.SpaceIterator
import fr.cea.nabla.nabla.SpaceIteratorRange
import fr.cea.nabla.nabla.SpaceIteratorRef
import fr.cea.nabla.nabla.Var
import fr.cea.nabla.nabla.VarRef
import org.eclipse.xtext.validation.Check

import static extension fr.cea.nabla.Utils.*

class BasicValidator  extends AbstractNablaValidator
{
	@Inject extension VarExtensions
	
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
	def checkConstVar(Affectation it)
	{
		if (varRef.variable.isConst)
			error('Affectation to const variable', NablaPackage.Literals::AFFECTATION__VAR_REF)
	}
	
	@Check
	def checkConstVar(ScalarVarDefinition it)
	{
		if (isConst && defaultValue!==null && defaultValue.eAllContents.filter(VarRef).exists[x|!x.variable.isConst])
			error('Assignment with non const variables', NablaPackage.Literals::SCALAR_VAR_DEFINITION__DEFAULT_VALUE)
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
								error('Wrong iterator type: Expected ' + expectedT.literal + ', but was ' + rt.type.literal, NablaPackage.Literals::VAR_REF__SPACE_ITERATORS, i)
						}
						SpaceIteratorRef:
						{
							val actualT = si.iterator.range.connectivity.returnType.type
							if (actualT != expectedT)
								error('Wrong iterator type: Expected ' + expectedT.literal + ', but was ' + actualT.literal, NablaPackage.Literals::VAR_REF__SPACE_ITERATORS, i)
							else
							{	
								val actualC = si.iterator.range.connectivity
								if (actualC !== expectedC && !expectedC.inTypes.empty)
									// Les connectivités sont différentes (ex: cells, cellsOfNode).
									// Celle de la variable doit être globale, i.e. sans inTypes (ex: cells)
									error('Wrong iterator type: ' + actualC.name + ' is not a subset of ' + expectedC.name, NablaPackage.Literals::VAR_REF__SPACE_ITERATORS, i)
							}
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
				val actualT = args.get(i).iterator.range.connectivity.returnType.type
				val expectedT = connectivity.inTypes.get(i)
				if (actualT != expectedT)
					error('Wrong arguments: Expected ' + expectedT.literal + ', but was ' + actualT.literal, NablaPackage.Literals::SPACE_ITERATOR_RANGE__ARGS, i)
			}
		}
	}
}