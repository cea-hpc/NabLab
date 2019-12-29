/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.generator.ir

import com.google.inject.Inject
import com.google.inject.Singleton
import fr.cea.nabla.ArgOrVarExtensions
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.Variable
import fr.cea.nabla.nabla.Arg
import fr.cea.nabla.nabla.ArgOrVar
import fr.cea.nabla.nabla.ConnectivityVar
import fr.cea.nabla.nabla.SimpleVar

/**
 * Attention : cette classe doit être un singleton car elle utilise des méthodes create.
 * Si elle n'est pas singleton, plusieurs instances d'un même objet seront créées lors
 * deu parcours du graphe d'origine (voir la documentation Xtext).
 */
@Singleton
class IrArgOrVarFactory 
{
	@Inject extension ArgOrVarExtensions
	@Inject extension IrExpressionFactory
	@Inject extension BaseType2IrType
	@Inject extension IrAnnotationHelper

	/**
	 * Cette méthode permet de construire une variable IR depuis
	 * une variable Nabla. C'est utile à partir d'une instance de VarRef.
	 * A une variable Nabla peut correspondre plusieurs variables IR,
	 * en fonction de l'itérateur en temps.
	 */	
	def toIrArgOrVar(ArgOrVar v, String timeSuffix)
	{
		val name = v.name + timeSuffix
		switch v
		{
			SimpleVar : v.toIrSimpleVariable(name)
			ConnectivityVar : v.toIrConnectivityVariable(name)
			Arg: v.toIrArg(name)
		}
	}

	// fonctions générales retournent des Var
	def dispatch Variable toIrVariable(SimpleVar v) { toIrSimpleVariable(v, v.name) }
	def dispatch Variable toIrVariable(ConnectivityVar v) { toIrConnectivityVariable(v, v.name) }

	def create IrFactory::eINSTANCE.createArg toIrArg(Arg v, String varName)
	{
		annotations += v.toIrAnnotation
		name = varName
		type = v.type.toIrBaseType
	}

	def create IrFactory::eINSTANCE.createSimpleVariable toIrSimpleVariable(SimpleVar v, String varName)
	{
		annotations += v.toIrAnnotation
		name = varName
		type = v.type.toIrBaseType
		const = v.const
		val value = v.defaultValue
		if (value !== null) defaultValue = value.toIrExpression
	}

	def create IrFactory::eINSTANCE.createConnectivityVariable toIrConnectivityVariable(ConnectivityVar v, String varName)
	{
		annotations += v.toIrAnnotation
		name = varName
		type = toIrConnectivityType(v.type, v.supports)
		const = v.const
	}
}