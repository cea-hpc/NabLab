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
import fr.cea.nabla.NablaRuntimeModule
import fr.cea.nabla.NablaStandaloneSetup
import org.eclipse.xtext.util.Modules2

/**
 * Initialization support for running Xtext languages as language servers.
 */
class NablaIdeSetup extends NablaStandaloneSetup
{
	override createInjector()
	{
		Guice.createInjector(Modules2.mixin(new NablaRuntimeModule, new NablaIdeModule))
	}
}
