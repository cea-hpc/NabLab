/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.transformers

import fr.cea.nabla.ir.IrUtils
import fr.cea.nabla.ir.ir.DefaultExtensionProvider
import fr.cea.nabla.ir.ir.IrRoot

abstract class IrTransformationStep
{
	static val TracePrefix = "    IR -> IR: "

	protected def String getDescription()
	protected def void transform(IrRoot ir, (String)=>void traceNotifier)
	protected def void transform(DefaultExtensionProvider ir, (String)=>void traceNotifier)

	def void transformIrRoot(IrRoot ir, (String)=>void traceNotifier) throws IrTransformationException
	{
		try
		{
			traceNotifier.apply(TracePrefix + description)
			transform(ir, traceNotifier)
		}
		catch (IrTransformationException e)
		{
			throw e
		}
		catch (Exception e)
		{
			traceNotifier.apply(e.class.name + ": " + e.message)
			traceNotifier.apply(IrUtils.getStackTrace(e))
			throw new IrTransformationException(e.message)
		}
	}

	def void transformProvider(DefaultExtensionProvider dep, (String)=>void traceNotifier) throws IrTransformationException
	{
		try
		{
			traceNotifier.apply(TracePrefix + description)
			transform(dep, traceNotifier)
		}
		catch (IrTransformationException e)
		{
			throw e
		}
		catch (Exception e)
		{
			traceNotifier.apply(e.class.name + ": " + e.message)
			traceNotifier.apply(IrUtils.getStackTrace(e))
			throw new IrTransformationException(e.message)
		}
	}
}