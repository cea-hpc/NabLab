/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.json

import com.google.gson.Gson
import fr.cea.nabla.ir.interpreter.NV0Bool
import fr.cea.nabla.ir.interpreter.NV0Int
import fr.cea.nabla.ir.interpreter.NV0Real
import fr.cea.nabla.ir.interpreter.NV1Bool
import fr.cea.nabla.ir.interpreter.NV1Int
import fr.cea.nabla.ir.interpreter.NV1Real
import fr.cea.nabla.ir.interpreter.NV2Bool
import fr.cea.nabla.ir.interpreter.NV2Int
import fr.cea.nabla.ir.interpreter.NV2Real
import fr.cea.nabla.ir.interpreter.NV3Bool
import fr.cea.nabla.ir.interpreter.NV3Int
import fr.cea.nabla.ir.interpreter.NV3Real
import fr.cea.nabla.ir.interpreter.NV4Bool
import fr.cea.nabla.ir.interpreter.NV4Int
import fr.cea.nabla.ir.interpreter.NV4Real

class NablaValueExtensions 
{
	val gson = new Gson

	def dispatch getContent(NV0Bool it) { gson.toJson(data) }
	def dispatch getContent(NV1Bool it) { gson.toJson(data) }
	def dispatch getContent(NV2Bool it) { gson.toJson(data) }
	def dispatch getContent(NV3Bool it) { gson.toJson(data) }
	def dispatch getContent(NV4Bool it) { gson.toJson(data) }

	def dispatch getContent(NV0Int it) { gson.toJson(data) }
	def dispatch getContent(NV1Int it) { gson.toJson(data) }
	def dispatch getContent(NV2Int it) { gson.toJson(data) }
	def dispatch getContent(NV3Int it) { gson.toJson(data) }
	def dispatch getContent(NV4Int it) { gson.toJson(data) }

	def dispatch getContent(NV0Real it) { gson.toJson(data) }
	def dispatch getContent(NV1Real it) { gson.toJson(data) }
	def dispatch getContent(NV2Real it) { gson.toJson(data) }
	def dispatch getContent(NV3Real it) { gson.toJson(data) }
	def dispatch getContent(NV4Real it) { gson.toJson(data) }
}
