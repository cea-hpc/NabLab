/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ui.wizards

import fr.cea.nabla.generator.NablagenFileGenerator
import fr.cea.nabla.ui.NablaUiUtils
import fr.cea.nabla.ui.internal.NablaActivator
import java.io.ByteArrayInputStream
import java.lang.reflect.InvocationTargetException
import java.util.ArrayList
import java.util.Collection
import org.eclipse.core.resources.IFile
import org.eclipse.core.resources.IFolder
import org.eclipse.core.resources.IProject
import org.eclipse.core.resources.IProjectDescription
import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.core.runtime.CoreException
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.core.runtime.IStatus
import org.eclipse.core.runtime.Path
import org.eclipse.core.runtime.Status
import org.eclipse.jdt.core.IClasspathEntry
import org.eclipse.jdt.core.JavaCore
import org.eclipse.jface.operation.IRunnableWithProgress
import org.eclipse.jface.viewers.IStructuredSelection
import org.eclipse.jface.wizard.IWizardPage
import org.eclipse.jface.wizard.Wizard
import org.eclipse.pde.core.project.IBundleProjectDescription
import org.eclipse.ui.INewWizard
import org.eclipse.ui.IWorkbench
import org.eclipse.xtext.ui.XtextProjectHelper

class NewNablaProjectWizard extends Wizard implements INewWizard
{
	static val WIZARD_TITLE = "New NabLab Project"
	static val DEFAULT_PROJECT_NAME = "nablab.project"
	static val NEW_PROJECT_PAGE_TITLE = "Create a new NabLab project"
	static val NEW_PROJECT_PAGE_DESCRIPTION = "Set project and module/extension name."

	NablaProjectPage newProjectPage = null

	new()
	{
		super()
		windowTitle = WIZARD_TITLE
	}

	override init(IWorkbench workbench, IStructuredSelection selection)
	{
	}

	override addPages()
	{
		newProjectPage = new NablaProjectPage(WIZARD_TITLE)
		newProjectPage.initialProjectName = DEFAULT_PROJECT_NAME
		newProjectPage.title = NEW_PROJECT_PAGE_TITLE
		newProjectPage.description = NEW_PROJECT_PAGE_DESCRIPTION
		val imageDescriptor = NablaUiUtils.getImageDescriptor("icons/NabLab.gif")
		if (imageDescriptor.present)
		{
			newProjectPage.imageDescriptor = imageDescriptor.get
		}
		addPage(newProjectPage)
	}

	override getNextPage(IWizardPage page)
	{
		super.getNextPage(page)
	}

	override canFinish()
	{
		return newProjectPage.isPageComplete()
	}

	override needsProgressMonitor()
	{
		return true
	}

	override performFinish()
	{
		try
		{
			val iWizardContainer = this.getContainer()
			val projectCreation = new IRunnableWithProgress()
			{
				override run(IProgressMonitor monitor) throws InvocationTargetException, InterruptedException
				{
					createProject(monitor)
				}
			}
			iWizardContainer.run(false, false, projectCreation)
			return true
		}
		catch (InvocationTargetException | InterruptedException e)
		{
			NablaActivator::instance.log.log(new Status(IStatus.ERROR, NablaActivator.PLUGIN_ID, e.message))
		}
		return false
	}

	private def createProject(IProgressMonitor monitor)
	{
		try
		{
			var project = ResourcesPlugin.workspace.root.getProject(newProjectPage.projectName)
			if (!project.exists)
			{
				var location = newProjectPage.locationPath
				if (ResourcesPlugin.workspace.root.location.equals(location))
				{
					location = null
				}
				val desc = project.workspace.newProjectDescription(newProjectPage.projectName)
				desc.location = location
				addNatures(desc)
				project.create(desc, monitor)
				project.open(monitor)

				// Create src folder
				val srcFolder = project.getFolder("src")
				srcFolder.create(false, true, monitor)

				// Create modules folder
				val mOeName = newProjectPage.moduleOrExtensionName
				val modulesFolder = srcFolder.getFolder(mOeName.toLowerCase)
				modulesFolder.create(false, true, monitor)

				// Create src-gen-java folder
				val srcJavaFolderName = (newProjectPage.module ? "src-gen-java" : "src-java")
				val srcJavaFolder = project.getFolder(srcJavaFolderName)
				srcJavaFolder.create(false, true, monitor)

				// Create src-gen-cpp folder
				val srcCppFolderName = (newProjectPage.module ? "src-gen-cpp" : "src-cpp")
				val srcCppFolder = project.getFolder(srcCppFolderName)
				srcCppFolder.create(false, true, monitor)

				// Create all src-gen-cpp subfolders
				for (cppFolderName : NablagenFileGenerator.CppGenFoldersByTarget.values)
				{
					val cppFolder = srcCppFolder.getFolder(cppFolderName)
					cppFolder.create(false, true, monitor)
				}

				// Create src-gen-arcane folder
				val srcArcaneFolderName = (newProjectPage.module ? "src-gen-arcane" : "src-arcane")
				val srcArcaneFolder = project.getFolder(srcArcaneFolderName)
				srcArcaneFolder.create(false, true, monitor)

				// Create all src-gen-arcane subfolders
				for (cppFolderName : NablagenFileGenerator.ArcaneGenFoldersByTarget.values)
				{
					val cppFolder = srcArcaneFolder.getFolder(cppFolderName)
					cppFolder.create(false, true, monitor)
				}

				// Create src-gen-python folder
				val srcPythonFolderName = (newProjectPage.module ? "src-gen-python" : "src-python")
				val srcPythonFolder = project.getFolder(srcPythonFolderName)
				srcPythonFolder.create(false, true, monitor)

				// Create nabla and nablagen models
				val nablaFile = modulesFolder.getFile(mOeName + ".n")
				val nablagenFile = modulesFolder.getFile(mOeName + ".ngen")
				if (newProjectPage.module)
				{
					createFile(nablaFile, getNablaModuleContent(mOeName), monitor)
					createFile(nablagenFile, NablagenFileGenerator.getApplicationContent(mOeName, newProjectPage.projectName), monitor)
				}
				else
				{
					createFile(nablaFile, getNablaExtensionContent(mOeName), monitor)
					createFile(nablagenFile, NablagenFileGenerator.getProviderContent(mOeName, newProjectPage.projectName), monitor)
				}

				// Create META-INF folder and MANIFEST
				val metaInf = project.getFolder("META-INF")
				metaInf.create(false, true, monitor)
				val manifestFile = metaInf.getFile("MANIFEST.MF")
				createFile(manifestFile, getManifestContent(), monitor)

				// Convert into Java Project
				convertIntoJavaProject(project, #{srcFolder, srcJavaFolder}, monitor)

				// Create build.properties
				val buildPropertiesFile = project.getFile("build.properties")
				createFile(buildPropertiesFile, getBuildPropertiesContent(), monitor)

				addBuilders(desc)
				project.setDescription(desc, monitor)
			}
		}
		catch (CoreException e)
		{
			NablaActivator::instance.log.log(new Status(IStatus.ERROR, NablaActivator.PLUGIN_ID, e.message))
		}
	}

	private def addNatures(IProjectDescription description)
	{
		description.natureIds = #[IBundleProjectDescription.PLUGIN_NATURE, JavaCore.NATURE_ID, XtextProjectHelper.NATURE_ID]
	}

	private def addBuilders(IProjectDescription description)
	{
		var builders = new ArrayList
		var builder = description.newCommand
		builder.builderName = "org.eclipse.pde.ManifestBuilder"
		builders.add(builder)
		builder = description.newCommand
		builder.builderName = "org.eclipse.pde.SchemaBuilder"
		builders.add(builder)
		builder = description.newCommand
		builder.builderName = JavaCore.BUILDER_ID
		builders.add(builder)
		builder = description.newCommand
		builder.builderName = XtextProjectHelper.BUILDER_ID
		builders.add(builder)
		description.buildSpec = builders.toArray(#[])
	}

	private def convertIntoJavaProject(IProject project, Collection<IFolder> srcFolders, IProgressMonitor monitor)
	{
		val javaProject = JavaCore.create(project)
		val entries = new ArrayList<IClasspathEntry>()
		entries.add(JavaCore.newContainerEntry(new Path("org.eclipse.jdt.launching.JRE_CONTAINER/org.eclipse.jdt.internal.debug.ui.launcher.StandardVMType/JavaSE-11")))
		entries.add(JavaCore.newContainerEntry(new Path("org.eclipse.pde.core.requiredPlugins")))
		for (srcFolder : srcFolders)
		{
			val srcClasspathEntry = JavaCore.newSourceEntry(srcFolder.getFullPath())
			entries.add(srcClasspathEntry)
		}
		javaProject.setRawClasspath(entries.toArray(#[]), monitor)
		javaProject.setOutputLocation(new Path("/" + project.name + "/bin"), monitor)
	}

	private def createFile(IFile file, CharSequence fileContent, IProgressMonitor monitor)
	{
		val bytes = fileContent.toString.bytes
		val is = new ByteArrayInputStream(bytes)
		file.create(is, false, monitor)
	}

	private def getNablaModuleContent(String moduleName)
	'''
		module «moduleName»;

		with CartesianMesh2D.*;

		let int maxIter = 200;
		let real maxTime = 1.0;

		real t, delta_t;
		real[2] X{nodes};
		real e{nodes};

		iterate n while (n+1 < maxIter && t^{n+1} < maxTime);
	'''

	private def getNablaExtensionContent(String extensionName)
	'''
		extension «extensionName»;

		def myMatVectProduct: x, y  | real[x,y] , real[y] : real[x];
	'''

	private def getManifestContent()
	'''
		Manifest-Version: 1.0
		Bundle-ManifestVersion: 2
		Bundle-Name: «newProjectPage.projectName»
		Bundle-SymbolicName: «newProjectPage.projectName»
		Bundle-Version: 0.1.0.qualifier
		Bundle-RequiredExecutionEnvironment: JavaSE-11
		Automatic-Module-Name: «newProjectPage.projectName»
		Require-Bundle: fr.cea.nabla,
		   fr.cea.nabla.ir,
		   fr.cea.nabla.sirius,
		   fr.cea.nabla.javalib,
		   org.eclipse.xtext.xbase.lib,
		   com.google.gson,
		   commons-math3,
		   leveldb
		Export-Package: «newProjectPage.moduleOrExtensionName.toLowerCase»
	'''

	private def getBuildPropertiesContent()
	'''
		source.. = src, src«IF newProjectPage.module»-gen«ENDIF»-java/
		bin.includes = .,\
		               META-INF/
	'''
}