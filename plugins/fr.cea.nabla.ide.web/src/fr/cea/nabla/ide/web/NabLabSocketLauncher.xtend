/*******************************************************************************
 * Copyright (c) 2021, 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ide.web

import com.google.gson.GsonBuilder
import com.google.inject.Guice
import java.io.PrintWriter
import java.net.InetSocketAddress
import java.nio.channels.AsynchronousServerSocketChannel
import java.nio.channels.Channels
import java.util.concurrent.Executors
import java.util.stream.Stream
import org.eclipse.lsp4j.jsonrpc.json.adapters.EnumTypeAdapter
import org.eclipse.lsp4j.launch.LSPLauncher.Builder
import org.eclipse.lsp4j.services.LanguageClient

/**
 * Special launcher used to run the server and listen to sockets for communication
 */
class NabLabSocketLauncher
{

	public static val int DEFAULT_PORT = 5008

	def static void main(String[] args)
	{
		new NabLabSocketLauncher().run(args)
	}

	def void run(String[] args)
	{
		val injector = Guice.createInjector(new NabLabServerModule())
		val serverSocket = AsynchronousServerSocketChannel.open.bind(new InetSocketAddress("0.0.0.0", DEFAULT_PORT))
		
		while(true)
		{
			val socketChannel = serverSocket.accept.get
			val in = Channels.newInputStream(socketChannel)
			val out = Channels.newOutputStream(socketChannel)
			val languageServer = injector.getInstance(NabLabLanguageServer)
			val executorService = Executors.newCachedThreadPool

			val  launcherBuilder = new Builder<LanguageClient>() //
			.setLocalService(languageServer) //
			.setRemoteInterface(LanguageClient) //
			.setInput(in) //
			.setOutput(out)//
			.setExecutorService(executorService)
			
			if(Stream.of(args).anyMatch["-traceLSPMessages".equals(it)])
			{
				launcherBuilder.traceMessages(new PrintWriter(System.out))
			}
			
			val launcher = launcherBuilder.create()

			languageServer.connect(launcher.remoteProxy)
			launcher.startListening

			println("Started language server for client " + socketChannel.remoteAddress)
		}
	}

	def GsonBuilder configureGson(GsonBuilder gsonBuilder)
	{
		return gsonBuilder.registerTypeAdapterFactory(new EnumTypeAdapter.Factory())
	}

}
