/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla

import com.google.inject.Inject
import org.eclipse.emf.common.util.URI
import org.eclipse.xtext.parser.IEncodingProvider

class NablaEncodingProvider implements IEncodingProvider
{
	@Inject IEncodingProvider.Runtime defaultProvider

	override getEncoding(URI uri)
	{
		if (uri.lastSegment.endsWith('.nabla') || uri.lastSegment.endsWith('.n')) 'UTF-8'
		else defaultProvider.getEncoding(uri)
	}
}