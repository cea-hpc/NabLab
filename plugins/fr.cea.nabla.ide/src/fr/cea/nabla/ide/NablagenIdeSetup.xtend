/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ide

import com.google.inject.Guice
import com.google.inject.Injector
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

	override Injector createInjectorAndDoEMFRegistration() {

		// The normal implementation initialize the sub grammar but it causes problem see the following link for more details
		// * https://github.com/eclipse/xtext-core/issues/993
		// * https://www.eclipse.org/forums/index.php/m/1848471/
		// Instead we rely on the fact that Nabla has already been initialized and use its injector to retrieve the GrammarAccess
		var Injector injector = createInjector
		register(injector)
		return injector
	}
}
