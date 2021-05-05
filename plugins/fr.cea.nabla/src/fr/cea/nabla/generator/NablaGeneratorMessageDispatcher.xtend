/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.generator

import com.google.inject.Singleton
import java.util.ArrayList
import org.eclipse.xtend.lib.annotations.Accessors

@Singleton
class NablaGeneratorMessageDispatcher
{
	enum MessageType { Start, Exec, End, Warning, Error }

	@Accessors val traceListeners = new ArrayList<(MessageType, String) => void>

	def post(MessageType msgType, String msg)
	{
		traceListeners.forEach[apply(msgType, msg)]
	}
}