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

import com.google.inject.Binder
import fr.cea.nabla.ide.codeactions.NablagenCodeActionService
import fr.cea.nabla.services.NablaGrammarAccess
import org.eclipse.xtext.ide.server.codeActions.ICodeActionService2

/**
 * Use this class to register ide components.
 */
class NablagenIdeModule extends AbstractNablagenIdeModule
{
	
	override configure(Binder binder)
	{
		super.configure(binder)
		// See https://www.eclipse.org/forums/index.php/m/1848471/
		binder.bind(NablaGrammarAccess).toProvider([NablaIdeSetup.injector.getInstance(NablaGrammarAccess)])
	}
	
	def Class<? extends ICodeActionService2> bindICodeActionService2() {
	 	return NablagenCodeActionService
	 }
}
