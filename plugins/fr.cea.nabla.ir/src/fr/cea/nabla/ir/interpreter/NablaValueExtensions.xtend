/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.interpreter

import static org.iq80.leveldb.impl.Iq80DBFactory.bytes

class NablaValueExtensions
{
	static def getSize(NV1Int it) { data.size }
	static def getSize(NV1Real it) { data.size }

	static def getNbRows(NV2Int it) { data.size }
	static def getNbCols(NV2Int it) { data.get(0).size }
	static def getNbRows(NV2Real it) { data.size }
	static def getNbCols(NV2Real it) { data.get(0).size }

	static def serialize(NablaValue it) { bytes(it.toString) }
}
