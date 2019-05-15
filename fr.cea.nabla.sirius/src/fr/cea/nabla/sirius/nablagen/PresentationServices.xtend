package fr.cea.nabla.sirius.nablagen

class PresentationServices 
{
	def replaceUpperCaseWithSpace(String it)
	{
		val separator = ' '
		
		if (contains('_'))
			replace('_', separator)
		else 
			// chaine de la forme monNom
			Character::toUpperCase(charAt(0)) + toCharArray.tail.map[c | if (Character::isUpperCase(c)) separator + c else c  ].join
	}	
}