/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.generator

import fr.cea.nabla.ir.generator.Utils
import fr.cea.nabla.nablagen.NablagenApplication
import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.core.runtime.Platform
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.util.EcoreUtil
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import fr.cea.nabla.ir.IrUtils

/**
 * Generates code from your model files on save.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 */
class NablagenGenerator extends AbstractGenerator
{
	static val NablalibFiles = #[
		"Assert.n",
		"CartesianMesh2D.n",
		"CartesianMesh2D.ngen",
		"LinearAlgebra.n",
		"LinearAlgebra.ngen",
		"Math.n"]

	override void doGenerate(Resource input, IFileSystemAccess2 fsa, IGeneratorContext context)
	{
		if (input !== null && input.URI.platformResource && !input.contents.empty)
		{
			val model = input.contents.head
			if (model instanceof NablagenApplication)
			{
				val eclipsePath = Platform.installLocation.URL.path
				// Do not use root.location as wsPath: it will be wrong for imported projects
				val workspace = ResourcesPlugin.workspace.root
				val projectName = input.URI.segment(1)
				val project = workspace.getProject(projectName)
				val projectFolder = ResourcesPlugin.workspace.root.getFolder(project.location)
				val wsPath = projectFolder.parent.fullPath.toString
				val name = model.name.toLowerCase
				fsa.generateFile(name + "/" + name + ".py", getPyWrapperContent(eclipsePath, wsPath, projectName, input))
			}
		}
	}

	private def getPyWrapperContent(String eclipsePath, String workspacePath, String projectName, Resource ngen)
	'''
		# «Utils::doNotEditWarning»

		# Must be done before starting the VM (started at "import jnius")
		import jnius_config

		# Use the following lines in case of Eclipse runtime
		jnius_config.add_options("-DNZIP_FILE=«getPluginPath("fr.cea.nabla.ir")»resources/«IrUtils::NRepository».zip")
		jnius_config.add_classpath("«eclipsePath»plugins/*")
		jnius_config.add_classpath("«getPluginPath("fr.cea.nabla")»bin")
		jnius_config.add_classpath("«getPluginPath("fr.cea.nabla.ir")»bin")
		jnius_config.add_classpath("«getPluginPath("jgrapht-core")»*")

		# Use the following line in case of NabLab product built with Maven (comment lines above)
		#jnius_config.add_classpath("<NabLab product path>/plugins/fr.cea.nabla.vscode.extension/src/nablab/repo/*")

		import jnius

		if __name__ == '__main__':
			# Variables definition
			wsPath = "«workspacePath»"
			nablalibPath = "«nablalibPath»"
			ngenUri = «getFileUri(ngen)»

			# Dependencies management
			PyNablagenApplication = jnius.autoclass('fr.cea.nabla.pywrapper.PyNablagenApplication')
			app = PyNablagenApplication.create(wsPath, ngenUri)
			«FOR r : findDependencies(ngen).filter[x | !NablalibFiles.contains(x.URI.lastSegment)]»
				app.addNeededUri(«getFileUri(r)»)
			«ENDFOR»
			«FOR f : NablalibFiles»
				app.addNeededUri("file:" + nablalibPath + "/«f»")
			«ENDFOR»

			# Generation
			app.generate("«projectName»")
	'''

	private def getFileUri(Resource r)
	{
		'"file:" + wsPath + "' + r.URI.toString.replace("platform:/resource", "") + '"'
	}

	private def getPluginPath(String pluginId)
	{
		Platform.getBundle(pluginId).location.replace("reference:file:", "")
	}

	private def getNablalibPath()
	{
		getPluginPath("fr.cea.nabla") + 'nablalib'
	}

	private def findDependencies(Resource r)
	{
		val cr = EcoreUtil.CrossReferencer::find(r.contents.toList)
		cr.keySet.filter[eResource !== null].map[eResource].toSet
	}
}
