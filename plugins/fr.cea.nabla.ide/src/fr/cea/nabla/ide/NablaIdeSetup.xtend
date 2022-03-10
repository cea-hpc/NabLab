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
import fr.cea.nabla.NablaRuntimeModule
import fr.cea.nabla.NablaStandaloneSetup
import org.eclipse.xtext.util.Modules2

/**
 * Initialization support for running Xtext languages as language servers.
 */
class NablaIdeSetup extends NablaStandaloneSetup
{
	
	/*
	 * Workaround for bug https://github.com/eclipse/xtext-core/issues/993 due to language dependency from NableGen to Nabla. See https://www.eclipse.org/forums/index.php/m/1848471/ for more details
	 */
	public static Injector injector

	override createInjector()
	{
		injector = Guice.createInjector(Modules2.mixin(new NablaRuntimeModule, new NablaIdeModule))
		return injector
	}
}
