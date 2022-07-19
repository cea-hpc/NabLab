/*******************************************************************************
 * Copyright (c) 2022 CEA
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
import fr.cea.nabla.BaseTypeSizeEvaluator
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.nabla.BaseType
import fr.cea.nabla.nabla.Connectivity
import fr.cea.nabla.nabla.ItemType
import fr.cea.nabla.nabla.MeshExtension
import fr.cea.nabla.nabla.PrimitiveType
import org.eclipse.xtext.EcoreUtil2

@Singleton
class IrBasicFactory
{
	@Inject extension NabLabFileAnnotationFactory
	@Inject extension IrExpressionFactory
	@Inject extension BaseTypeSizeEvaluator
	@Inject extension IrExtensionProviderFactory

	// No create method to ensure a new instance every time (for n+1 time variables)
	def fr.cea.nabla.ir.ir.BaseType toIrBaseType(BaseType t)
	{
		IrFactory::eINSTANCE.createBaseType =>
		[
			primitive = t.primitive.toIrPrimitiveType
			for (s : t.sizes)
			{
				sizes += s.toIrExpression
				intSizes += getIntSizeFor(s)
			}
			isStatic = intSizes.forall[x | x !== BaseTypeSizeEvaluator::DYNAMIC_SIZE]
		]
	}

	def toIrPrimitiveType(PrimitiveType t)
	{
		val type = fr.cea.nabla.ir.ir.PrimitiveType::get(t.value + 1) // First literal is VOID in the IR model
		if (type === null) throw new RuntimeException('Nabla --> IR problem: unknown type ' + t.literal)
		return type
	}

	def toIrConnectivity(Connectivity c)
	{
		c.name.toIrConnectivity =>
		[
			if (annotations.empty) annotations += c.toNabLabFileAnnotation
			returnType = c.returnType.toIrItemType
			if (inTypes.empty) inTypes += c.inTypes.map[toIrItemType]
			multiple = c.multiple
			val ext = EcoreUtil2.getContainerOfType(c, MeshExtension)
			provider = ext.toIrMeshExtensionProvider
			println(c.name + " local " + c.local)
			local = c.local
			println("\t" + name + " local " + local)
		]
	}

	def toIrItemType(ItemType i)
	{
		i.name.toIrItemType =>
		[
			annotations += i.toNabLabFileAnnotation
			val ext = EcoreUtil2.getContainerOfType(i, MeshExtension)
			provider = ext.toIrMeshExtensionProvider
		]
	}

	/** 
	 * Return an ItemType instance.
	 * PK is name (instead of nabla.ItemType) to avoid 
	 * multiple IR instances in case of multiple NablaModule.
	 */
	private def create IrFactory::eINSTANCE.createItemType toIrItemType(String itemTypeName)
	{
		name = itemTypeName
	}

	/** 
	 * Return a Connectivity instance.
	 * PK is name (instead of nabla.Connectivity) to avoid 
	 * multiple IR instances in case of multiple NablaModule.
	 */
	private def create IrFactory::eINSTANCE.createConnectivity toIrConnectivity(String connectivityName)
	{
		name = connectivityName
	}
}