/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ide

import com.google.inject.Guice
import fr.cea.nabla.NablagenRuntimeModule
import fr.cea.nabla.NablagenStandaloneSetup
import org.eclipse.xtext.util.Modules2

/**
 * Initialization support for running Xtext languages as language servers.
 */
class NablagenIdeSetup extends NablagenStandaloneSetup
{
	override createInjector() 
	{
		Guice.createInjector(Modules2.mixin(new NablagenRuntimeModule, new NablagenIdeModule))
	}
}
