/*******************************************************************************
 * Copyright (c) 2020 CEA
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
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.nabla.Function
import fr.cea.nabla.nabla.Reduction

/**
 * Attention : cette classe doit être un singleton car elle utilise des méthodes create.
 * Si elle n'est pas singleton, plusieurs instances d'un même objet seront créées lors
 * deu parcours du graphe d'origine (voir la documentation Xtext).
 */
@Singleton
class IrFunctionFactory 
{
	@Inject extension IrAnnotationHelper
	@Inject extension BaseType2IrType
	@Inject extension IrArgOrVarFactory
	@Inject extension IrSizeTypeFactory
	@Inject extension IrInstructionFactory

	static val Reductions = #{ '\u2211'->'+', '\u220F'->'*' }

	def create IrFactory::eINSTANCE.createFunction toIrFunction(Function f, String providerName)
	{
		annotations += f.toIrAnnotation
		name = f.name
		provider = providerName
		f.vars.forEach[x | variables += x.toIrSizeTypeSymbol]
		inArgs += f.inArgs.map[x | toIrArg(x, x.name)]
		returnType = f.returnType.toIrBaseType
		if (!f.external) body = f.body.toIrInstruction
	}

	def create IrFactory::eINSTANCE.createReduction toIrReduction(Reduction f, String providerName)
	{
		annotations += f.toIrAnnotation
		provider = providerName
		f.vars.forEach[x | variables += x.toIrSizeTypeSymbol]
		val op = Reductions.get(f.name)
		name = op ?: f.name.replaceFirst("reduce", "").toFirstLower
		operator = (op !== null)
		collectionType = f.collectionType.toIrBaseType
		returnType = f.returnType.toIrBaseType
	}
}