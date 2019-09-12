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
import fr.cea.nabla.Utils
import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.nabla.ArgType
import fr.cea.nabla.nabla.Dimension
import fr.cea.nabla.nabla.DimensionInt
import fr.cea.nabla.nabla.Function
import fr.cea.nabla.nabla.FunctionArg
import fr.cea.nabla.nabla.Reduction
import fr.cea.nabla.nabla.ReductionArg

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

	def create IrFactory::eINSTANCE.createFunction toIrFunction(Function f, FunctionArg a)
	{
		annotations += a.toIrAnnotation
		name = f.name
		returnType = a.returnType.toIrBaseType
		inTypes += a.inTypes.map[toIrBaseType]
		provider = Utils::getNablaModule(f).name
	}

	def create IrFactory::eINSTANCE.createReduction toIrReduction(Reduction f, ReductionArg a)
	{
		annotations += a.toIrAnnotation
		name = f.name
		collectionType = a.collectionType.toIrBaseType
		returnType = a.returnType.toIrBaseType
		provider = Utils::getNablaModule(f).name
	}
	
	/**
	 * No create method but a nested create to get a new instance at each call
	 */
	private def BaseType toIrBaseType(ArgType a)
	{
		if (a === null) null
		else switch a.indices.size
		{
			case 0: IrFactory.eINSTANCE.createScalar => 
			[ 
				primitive = a.primitive.toIrPrimitiveType
			]
			case 1: IrFactory.eINSTANCE.createArray1D => 
			[ 
				primitive = a.primitive.toIrPrimitiveType
				size = a.indices.get(0).value
			]
			case 2: IrFactory.eINSTANCE.createArray2D => 
			[ 
				primitive = a.primitive.toIrPrimitiveType
				nbRows = a.indices.get(0).value
				nbCols = a.indices.get(1).value
			]
		}
	}
	
	/**
	 * Return the value of the dimension if it is fixed (for example, det function only available on R[2]),
	 * or -1 if the dimension is undefined (for example R[x]).
	 */
	private def getValue(Dimension x)
	{
		if (x instanceof DimensionInt)
			x.value
		else
			-1
	}
}