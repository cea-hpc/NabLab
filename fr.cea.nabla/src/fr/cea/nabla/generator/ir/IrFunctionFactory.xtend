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
import fr.cea.nabla.FunctionDeclaration
import fr.cea.nabla.ReductionDeclaration
import fr.cea.nabla.Utils
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.nabla.Function
import fr.cea.nabla.nabla.Reduction
import fr.cea.nabla.typing.ArrayType
import fr.cea.nabla.typing.DefinedType
import fr.cea.nabla.typing.ExpressionType
import fr.cea.nabla.typing.UndefinedType

/**
 * Attention : cette classe doit être un singleton car elle utilise des méthodes create.
 * Si elle n'est pas singleton, plusieurs instances d'un même objet seront créées lors
 * deu parcours du graphe d'origine (voir la documentation Xtext).
 */
@Singleton
class IrFunctionFactory 
{
	@Inject extension Nabla2IrUtils
	@Inject extension IrAnnotationHelper

	def create IrFactory::eINSTANCE.createFunction toIrFunction(Function f, FunctionDeclaration a)
	{
		annotations += a.model.toIrAnnotation
		name = f.name
		returnType = a.returnType.toIrArgType
		inTypes += a.inTypes.map[toIrArgType]
		provider = Utils::getNablaModule(f).name
	}

	def create IrFactory::eINSTANCE.createReduction toIrReduction(Reduction f, ReductionDeclaration a)
	{
		annotations += a.model.toIrAnnotation
		name = f.name
		collectionType = a.collectionType.toIrArgType
		returnType = a.returnType.toIrArgType
		provider = Utils::getNablaModule(f).name
	}
	
	private def toIrArgType(ExpressionType t)
	{
		switch t
		{
			UndefinedType: null
			ArrayType: IrFactory::eINSTANCE.createArgType =>
			[
				root = t.root.toIrPrimitiveType
				arrayDimension = t.sizes.size
			]
			DefinedType: IrFactory::eINSTANCE.createArgType =>
			[
				root = t.root.toIrPrimitiveType
			]
		}
	}}