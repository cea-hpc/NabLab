package fr.cea.nabla.ir.generator.java

import com.google.inject.Inject
import fr.cea.nabla.ir.generator.Utils
import fr.cea.nabla.ir.ir.BasicType
import fr.cea.nabla.ir.ir.IteratorRange
import fr.cea.nabla.ir.ir.IteratorRef

class Ir2JavaUtils 
{
	@Inject extension Utils
	
	def getJavaType(BasicType t)
	{
		switch t
		{
			case VOID : 'void'
			case BOOL: 'boolean'
			case INT: 'int'
			case REAL: 'double'
			case REAL2: 'Real2'
			case REAL2X2: 'Real2x2'
			case REAL3: 'Real3'
			case REAL3X3: 'Real3x3'
		}
	}

	def isJavaBasicType(BasicType t)
	{
		switch t
		{
			case BOOL, case INT, case REAL: true
			default: false
		}
	}

	def getJavaOperator(String op) 
	{
		switch op
		{
			case '+': 'operator_plus'
			case '-': 'operator_minus'
			case '*': 'operator_multiply'
			case '/': 'operator_divide'
			case '+=': 'operator_add'
			case '=': 'operator_set'
			default: throw new RuntimeException("Pas d'équivalent Java pour l'opérateur : " + op)
		} 
	}
	
	def CharSequence getAccessor(IteratorRange it) 
	'''mesh.get«connectivity.name.toFirstUpper»(«args.map[rangeArgName].join(',')»)'''
	
	private def dispatch getRangeArgName(IteratorRange it) { accessor }
	private def dispatch getRangeArgName(IteratorRef it) { prefix(iterator.name + 'Id') }
}