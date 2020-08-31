/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 * 
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ui.launchconfig

import com.google.inject.Inject
import com.google.inject.Singleton
import fr.cea.nabla.generator.NablaGeneratorMessageDispatcher.MessageType
import fr.cea.nabla.ui.NabLabConsoleFactory
import java.io.BufferedReader
import java.io.File
import java.io.IOException
import java.io.InputStream
import java.io.InputStreamReader
import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.core.runtime.Path
import org.eclipse.debug.core.ILaunchConfiguration

@Singleton
class NablaRunner {
	@Inject NabLabConsoleFactory consoleFactory

	package def launch(ILaunchConfiguration configuration) {
		val graalVMHome = configuration.getAttribute(NablaLaunchConstants::GRAAL_HOME_LOCATION, '')
		val source = ResourcesPlugin.workspace.root.getFile(new Path(configuration.getAttribute(NablaLaunchConstants::SOURCE_FILE_LOCATION, '')))
				.rawLocation.makeAbsolute.toString
		val gen = ResourcesPlugin.workspace.root.getFile(new Path(configuration.getAttribute(NablaLaunchConstants::GEN_FILE_LOCATION, '')))
				.rawLocation.makeAbsolute.toString
		val moniloggers = configuration.getAttribute(NablaLaunchConstants::MONILOGGER_FILES_LOCATIONS, newArrayList).map[m|
							ResourcesPlugin.workspace.root.getFile(new Path(m)).rawLocation.makeAbsolute.toString]

		val name = source.substring(source.lastIndexOf(File::separator) + 1)

		consoleFactory.openConsole
		new Thread([
			consoleFactory.clearAndActivateConsole
			consoleFactory.printConsole(MessageType.Start, 'Starting execution: ' + name)
			
			val args = if (moniloggers.empty) {
					#[graalVMHome + '/bin/nabla', source, gen]
				} else {
					#[
						graalVMHome + '/bin/nabla',
						source,
						gen,
						'--monilogger.files=' + moniloggers.reduce [ s1, s2 |
							s1 + ',' + s2
						]
					]
				}

			val pb = new ProcessBuilder(args)
			pb.redirectErrorStream(true)
			val t0 = System::nanoTime
			val p = pb.start
			val outputGobbler = new StreamGobbler(p.getInputStream(), consoleFactory);
			outputGobbler.start();
			p.waitFor
			val t = (System::nanoTime - t0) * 0.000000001
			consoleFactory.printConsole(MessageType.End, 'End of execution: ' + name + ' (' + t + 's)')
		]).start
	}
}

class StreamGobbler extends Thread {
	val InputStream is
	val NabLabConsoleFactory consoleFactory

	new(InputStream is, NabLabConsoleFactory consoleFactory) {
		this.is = is
		this.consoleFactory = consoleFactory
	}

	override void run() {
		try {
			try (val InputStreamReader isr = new InputStreamReader(is);
					val BufferedReader br = new BufferedReader(isr)) {
				var String line = null
				while ((line = br.readLine()) !== null) {
					consoleFactory.printConsole(MessageType.Exec, line)
				}
			}
		} catch (IOException ioe) {
			ioe.printStackTrace()
		}
	}
}
