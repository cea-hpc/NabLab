/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ide.web

import com.google.inject.Guice
import com.google.inject.Inject
import com.google.inject.Module
import org.eclipse.lsp4j.jsonrpc.Launcher
import org.eclipse.lsp4j.services.LanguageClient
import org.eclipse.xtext.ide.server.LaunchArgs
import org.eclipse.xtext.ide.server.ServerLauncher
import org.eclipse.xtext.ide.server.ServerModule
import org.eclipse.xtext.resource.EObjectAtOffsetHelper
import org.eclipse.lsp4j.MessageParams
import org.eclipse.lsp4j.MessageType

class NabLabLauncher extends ServerLauncher
{
	@Inject NabLabLanguageServer nabLabLanguageServer
	@Inject EObjectAtOffsetHelper eObjectAtOffsetHelper

	def static void main(String[] args)
	{
		launch(ServerLauncher.name, args, new ServerModule())
	}

	def static void launch(String prefix, String[] args, Module... modules)
	{
		var launchArgs = createLaunchArgs(prefix, args)
		var injector = Guice.createInjector(modules)
		var launcher = injector.<NabLabLauncher>getInstance(NabLabLauncher)
		launcher.start(launchArgs)
	}

	override void start(LaunchArgs args)
	{
		try
		{
			InputOutput.println("Xtext Language Server is starting.")
			var launcher = Launcher.createLauncher(nabLabLanguageServer, LanguageClient,
				args.in, args.out, args.isValidate, args.trace)
			nabLabLanguageServer.connect(launcher.remoteProxy)
			var future = launcher.startListening()
			launcher.remoteProxy.logMessage(new MessageParams(MessageType.Info, "NabLab Language Server has been started."))
			
			var nabLabJettyServer = new NabLabJettyServer()
			try
			{
				nabLabJettyServer.start(nabLabLanguageServer, eObjectAtOffsetHelper)
			}
			catch (Exception e)
			{
				e.printStackTrace()
			}

			while (!future.isDone())
			{
				Thread.sleep(10_000L)
			}
		}
		catch (InterruptedException e)
		{
			throw Exceptions.sneakyThrow(e)
		}

	}
}
