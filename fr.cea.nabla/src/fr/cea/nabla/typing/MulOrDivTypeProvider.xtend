package fr.cea.nabla.typing

import com.google.inject.Inject

class MulOrDivTypeProvider 
{
	@Inject MulTypeProvider mtp
	@Inject DivTypeProvider dtp
	
	def BinaryOperatorTypeProvider getTypeProvider(String op)
	{
		switch op
		{
			case '*': mtp
			case '/': dtp
			default: throw new RuntimeException('Unexpected operator: ' + op)
		}
	}
}