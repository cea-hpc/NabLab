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
import fr.cea.nabla.ArgOrVarExtensions
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.PrimitiveType
import fr.cea.nabla.ir.ir.Variable
import fr.cea.nabla.nabla.Arg
import fr.cea.nabla.nabla.ArgOrVar
import fr.cea.nabla.nabla.BaseType
import fr.cea.nabla.nabla.ConnectivityVar
import fr.cea.nabla.nabla.SimpleVar
import fr.cea.nabla.nabla.TimeIterator
import fr.cea.nabla.nabla.Var
import fr.cea.nabla.typing.ArgOrVarTypeProvider
import fr.cea.nabla.typing.NablaSimpleType

@Singleton
class IrArgOrVarFactory 
{
	@Inject extension ArgOrVarExtensions
	@Inject extension IrExpressionFactory
	@Inject extension BaseType2IrType
	@Inject extension IrAnnotationHelper
	@Inject extension ArgOrVarTypeProvider
	@Inject NablaType2IrType nablaType2IrType

	def toIrArgOrVar(ArgOrVar v, String timeSuffix)
	{
		val name = v.name + timeSuffix
		switch v
		{
			SimpleVar : v.toIrSimpleVariable(name)
			ConnectivityVar : v.toIrConnectivityVariable(name)
			Arg: v.toIrArg(name)
			TimeIterator: v.toIrIterationCounter
		}
	}

	def toIrVar(Var v, String timeSuffix)
	{
		val name = v.name + timeSuffix
		switch v
		{
			SimpleVar : v.toIrSimpleVariable(name)
			ConnectivityVar : v.toIrConnectivityVariable(name)
		}
	}

	// fonctions générales retournent des Var
	def dispatch Variable toIrVariable(SimpleVar v) { toIrSimpleVariable(v, v.name) }
	def dispatch Variable toIrVariable(ConnectivityVar v) { toIrConnectivityVariable(v, v.name) }

	def create IrFactory::eINSTANCE.createArg toIrArg(BaseType nablaType, String nablaName)
	{
		annotations += nablaType.toIrAnnotation
		name = nablaName
		type = nablaType.toIrBaseType
	}

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
		type = nablaType2IrType.toIrBaseType(v.typeFor as NablaSimpleType)
		const = v.const
		constExpr = v.constExpr
		option = v.option
		val value = v.value
		if (value !== null) defaultValue = value.toIrExpression
	}

	def create IrFactory::eINSTANCE.createConnectivityVariable toIrConnectivityVariable(ConnectivityVar v, String varName)
	{
		annotations += v.toIrAnnotation
		name = varName
		type = toIrConnectivityType(v.type, v.supports)
	}

	def create 	IrFactory::eINSTANCE.createSimpleVariable toIrIterationCounter(TimeIterator t)
	{
		annotations += t.toIrAnnotation
		name = t.name
		type = IrFactory.eINSTANCE.createBaseType => [ primitive = PrimitiveType::INT ]
		const = false
		constExpr = false
		option = false
	}
}