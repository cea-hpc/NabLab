/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 *
 * Contributors:
 * 	Benoit Lelandais - initial implementation
 * 	Marie-Pierre Oudot - initial implementation
 * 	Jean-Sylvan Camier - Nabla generation support
 *******************************************************************************/
package fr.cea.nabla.tests

import com.google.inject.Inject
import fr.cea.nabla.nabla.NablaModule
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.resource.impl.ResourceDescriptionsProvider
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.eclipse.xtext.testing.util.ParseHelper
import org.junit.Assert
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(NablaInjectorProvider))
class NablaIndexTest 
{
	@Inject extension ParseHelper<NablaModule> parseHelper
	@Inject ResourceDescriptionsProvider rdp

	@Test 
	def testExportedEObjectDescriptions()
	{
		'''module toto; global { ℝ  o = 4.0; }'''.parse.assertExportedEObjectDescriptions('toto, toto.o')
	}
	
	private def assertExportedEObjectDescriptions(EObject o, CharSequence expected)
	{
		val r = o.exportedEObjectDescriptions.map[qualifiedName].join(', ')
		Assert.assertEquals(expected.toString, r)
	}
	
	private def getResourceDescription(EObject o)
	{
		val index = rdp.getResourceDescriptions(o.eResource)
		index.getResourceDescription(o.eResource.URI)
	}
	
	private def getExportedEObjectDescriptions(EObject o)
	{
		o.resourceDescription.exportedObjects
	}
}