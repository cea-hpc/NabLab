package fr.cea.nabla.ir.generator.cpp

import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.Connectivity
import fr.cea.nabla.ir.ir.ConnectivityType
import fr.cea.nabla.ir.ir.PrimitiveType

import static extension fr.cea.nabla.ir.generator.SizeTypeContentProvider.*
import static extension fr.cea.nabla.ir.generator.Utils.*

abstract class TypeContentProvider
{
	protected abstract def String getCppType(BaseType baseType, Iterable<Connectivity> connectivities)
	protected abstract def String getCstrInit(String varName, BaseType baseType, Iterable<Connectivity> connectivities)
	protected abstract def CharSequence formatVarIteratorsContent(String[] spaceIteratorNames)

	def dispatch String getCppType(BaseType it)
	{
		if (it === null)
			'null'
		else if (sizes.empty)
			primitive.cppType
		else
			getCppArrayType(primitive, sizes.size) + '<' + sizes.map[content].join(',') + '>'
	}

	def dispatch String getCppType(PrimitiveType it)
	{
		switch it
		{
			case null : 'void'
			case BOOL: 'bool'
			case INT: 'int'
			case REAL: 'double'
		}
 	}

	def dispatch String getCppType(ConnectivityType it)
	{
		getCppType(base, connectivities)
	}

	private def getCppArrayType(PrimitiveType t, int dim)
	{
		switch t
		{
			case null, case BOOL : throw new RuntimeException('Not implemented')
			case INT: 'IntArray' + dim + 'D'
			case REAL: 'RealArray' + dim + 'D'
		}
 	}
 }

class StdVectorTypeContentProvider extends TypeContentProvider
{
	override getCppType(BaseType baseType, Iterable<Connectivity> connectivities) 
	{
		if (connectivities.empty) baseType.cppType
		else 'std::vector<' + getCppType(baseType, connectivities.tail) + '>'
	}

	override protected getCstrInit(String varName, BaseType baseType, Iterable<Connectivity> connectivities)
	{
		switch connectivities.size
		{
			case 0: throw new RuntimeException("Ooops. Can not be there, normally...")
			case 1: connectivities.get(0).nbElems
			default: '''«connectivities.get(0).nbElems», «getCppType(baseType, connectivities.tail)»(«getCstrInit(varName, baseType, connectivities.tail)»)''' 
		}
	}

	override protected formatVarIteratorsContent(String[] spaceIteratorNames)
	'''«FOR s : spaceIteratorNames BEFORE '[' SEPARATOR '][' AFTER ']'»«s»«ENDFOR»'''
}

class KokkosTypeContentProvider extends TypeContentProvider
{
	override getCppType(BaseType baseType, Iterable<Connectivity> connectivities) 
	{
		'Kokkos::View<' + baseType.cppType + connectivities.map['*'].join + '>'
	}

	override getCstrInit(String varName, BaseType baseType, Iterable<Connectivity> connectivities)
	'''"«varName»", «FOR d : connectivities SEPARATOR ', '»«d.nbElems»«ENDFOR»'''

	override protected formatVarIteratorsContent(String[] spaceIteratorNames) 
	'''«FOR s : spaceIteratorNames BEFORE '(' SEPARATOR ',' AFTER ')'»«s»«ENDFOR»'''
}