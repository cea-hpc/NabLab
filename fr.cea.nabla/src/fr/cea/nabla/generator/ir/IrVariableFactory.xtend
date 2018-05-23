package fr.cea.nabla.generator.ir

import com.google.inject.Inject
import com.google.inject.Singleton
import fr.cea.nabla.VarExtensions
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.Variable
import fr.cea.nabla.nabla.ArrayVar
import fr.cea.nabla.nabla.ScalarVar
import fr.cea.nabla.nabla.TimeIteratorRef
import fr.cea.nabla.nabla.Var
import fr.cea.nabla.ir.ir.ScalarVariable
import fr.cea.nabla.ir.ir.ArrayVariable

/**
 * Attention : cette classe doit être un singleton car elle utilise des méthodes create.
 * Si elle n'est pas singleton, plusieurs instances d'un même objet seront créées lors
 * deu parcours du graphe d'origine (voir la documentation Xtext).
 */
@Singleton
class IrVariableFactory 
{
	@Inject extension VarExtensions
	@Inject extension IrExpressionFactory
	@Inject extension Nabla2IrUtils
	@Inject extension IrAnnotationHelper
	@Inject extension IrConnectivityFactory

	/**
	 * Cette méthode permet de construire une variable IR depuis
	 * une variable Nabla. C'est utile à partir d'une instance de VarRef.
	 * A une variable Nabla peut correspondre plusieurs variables IR,
	 * en fonction de l'itérateur en temps.
	 */	
	def Variable toIrVariable(Var v, TimeIteratorRef tr)
	{
		val varName = v.buildVarName(tr)
		switch v
		{
			ScalarVar : v.toIrScalarVariable(varName)
			ArrayVar : v.toIrArrayVariable(varName)
		}
	}

	// fonctions générales retournent des Var
	def dispatch Variable toIrVariable(ScalarVar v) { toIrScalarVariable(v, v.name) }
	def dispatch Variable toIrVariable(ArrayVar v) { toIrArrayVariable(v, v.name) }

	// fonctions avec type de retour précis
	def ScalarVariable toIrScalarVariable(ScalarVar v) { toIrScalarVariable(v, v.name) }
	def ArrayVariable toIrArrayVariable(ArrayVar v) { toIrArrayVariable(v, v.name) }
	
	def create IrFactory::eINSTANCE.createScalarVariable toIrScalarVariable(ScalarVar v, String varName)
	{
		annotations += v.toIrAnnotation
		name = varName
		type = v.basicType.toIrBasicType
		val value = v.defaultValue
		if (value !== null) defaultValue = value.toIrExpression
	}

	def create IrFactory::eINSTANCE.createArrayVariable toIrArrayVariable(ArrayVar v, String varName)
	{
		annotations += v.toIrAnnotation
		name = varName
		type = v.basicType.toIrBasicType
		v.dimensions.forEach[x | dimensions += x.toIrConnectivity]
	}
	
	private def buildVarName(Var v, TimeIteratorRef i)
	{
		if (i !== null && i.next) v.name + '_' + i.iterator.name + '_plus_' + i.value
		else v.name
	}
}