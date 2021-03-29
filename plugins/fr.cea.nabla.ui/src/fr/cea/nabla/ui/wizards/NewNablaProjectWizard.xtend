/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ui.wizards

import fr.cea.nabla.nablagen.TargetType
import fr.cea.nabla.ui.NablaUiUtils
import fr.cea.nabla.ui.internal.NablaActivator
import java.io.ByteArrayInputStream
import java.lang.reflect.InvocationTargetException
import java.util.ArrayList
import java.util.Collection
import java.util.HashMap
import java.util.LinkedHashMap
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
	static val DEFAULT_MODULE_NAME = "MyModule"
	static val NEW_PROJECT_PAGE_TITLE = "Create a new NabLab project"
	static val NEW_PROJECT_PAGE_DESCRIPTION = "Set project and module name."

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
		newProjectPage.initialModuleName = DEFAULT_MODULE_NAME
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
				val modulesFolder = srcFolder.getFolder(newProjectPage.moduleName.toLowerCase)
				modulesFolder.create(false, true, monitor)

				// Create src-gen-java folder
				val srcGenFoldersByLanguage = new LinkedHashMap<TargetType, IFolder>
				val srcGenJavaFolder = project.getFolder("src-gen-java")
				srcGenJavaFolder.create(false, true, monitor)
				srcGenFoldersByLanguage.put(TargetType::JAVA, srcGenJavaFolder)

				// Create src-gen-cpp folder
				val srcGenCppFolder = project.getFolder("src-gen-cpp")
				srcGenCppFolder.create(false, true, monitor)

				// Create all src-gen-cpp subfolders
				val srcGenSequentialFolder = srcGenCppFolder.getFolder("sequential")
				srcGenSequentialFolder.create(false, true, monitor)
				srcGenFoldersByLanguage.put(TargetType::CPP_SEQUENTIAL, srcGenSequentialFolder)

				val srcGenStlThreadFolder = srcGenCppFolder.getFolder("stl-thread")
				srcGenStlThreadFolder.create(false, true, monitor)
				srcGenFoldersByLanguage.put(TargetType::STL_THREAD, srcGenStlThreadFolder)

				val srcGenOpenMpFolder = srcGenCppFolder.getFolder("openmp")
				srcGenOpenMpFolder.create(false, true, monitor)
				srcGenFoldersByLanguage.put(TargetType::OPEN_MP, srcGenOpenMpFolder)

				val srcGenKokkosFolder = srcGenCppFolder.getFolder("kokkos")
				srcGenKokkosFolder.create(false, true, monitor)
				srcGenFoldersByLanguage.put(TargetType::KOKKOS, srcGenKokkosFolder)

				val srcGenKokkosTeamFolder = srcGenCppFolder.getFolder("kokkos-team")
				srcGenKokkosTeamFolder.create(false, true, monitor)
				srcGenFoldersByLanguage.put(TargetType::KOKKOS_TEAM_THREAD, srcGenKokkosTeamFolder)

				// Create nabla and nablagen models
				val nablaFile = modulesFolder.getFile(newProjectPage.moduleName + ".n")
				createFile(nablaFile, getNablaModelContent(newProjectPage.moduleName), monitor)
				val nablagenFile = modulesFolder.getFile(newProjectPage.moduleName + ".ngen")
				createFile(nablagenFile, getNablagenModelContent(newProjectPage.moduleName, srcGenFoldersByLanguage), monitor)

				// Create META-INF folder and MANIFEST
				val metaInf = project.getFolder("META-INF")
				metaInf.create(false, true, monitor)
				val manifestFile = metaInf.getFile("MANIFEST.MF")
				createFile(manifestFile, getManifestContent(), monitor)

				// Convert into Java Project
				convertIntoJavaProject(project, #{srcFolder, srcGenJavaFolder}, monitor)

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

	private def getNablaModelContent(String moduleName)
	'''
		module «moduleName»;

		itemtypes { node }

		connectivity nodes: → { node };

		option ℕ maxIter = 200;
		option ℝ maxTime = 1.0;

		ℝ t, δt;
		ℝ[2] X{nodes};
		ℝ e{nodes};

		iterate n while (n+1 < maxIter && t^{n+1} < maxTime);
	'''

	private def getNablagenModelContent(String nablaModuleName, HashMap<TargetType, IFolder> srcGenFoldersByLanguage)
	'''
		Application «nablaModuleName»;

		MainModule «nablaModuleName» «nablaModuleName.toFirstLower»
		{
			meshClassName = "CartesianMesh2D";
			nodeCoord = X;
			time = t;
			timeStep = δt;
			iterationMax = maxIter;
			timeMax = maxTime;
		}

		VtkOutput
		{
			periodReferenceVariable = «nablaModuleName.toFirstLower».n;
			outputVariables = «nablaModuleName.toFirstLower».e as "Energy";
		}

		Java
		{
			outputPath = "«srcGenFoldersByLanguage.get(TargetType::JAVA).fullPath»";
		}

		CppSequential
		{
			outputPath = "«srcGenFoldersByLanguage.get(TargetType::CPP_SEQUENTIAL).fullPath»";
			N_CXX_COMPILER = "/usr/bin/g++";
		}

		StlThread
		{
			outputPath = "«srcGenFoldersByLanguage.get(TargetType::STL_THREAD).fullPath»";
			N_CXX_COMPILER = "/usr/bin/g++";
		}

		OpenMP
		{
			outputPath = "«srcGenFoldersByLanguage.get(TargetType::OPEN_MP).fullPath»";
			N_CXX_COMPILER = "/usr/bin/g++";
		}

		Kokkos
		{
			outputPath = "«srcGenFoldersByLanguage.get(TargetType::KOKKOS).fullPath»";
			N_CXX_COMPILER = "/usr/bin/g++";
			N_KOKKOS_PATH = "$ENV{HOME}/kokkos/kokkos-install";
		}

		KokkosTeamThread
		{
			outputPath = "«srcGenFoldersByLanguage.get(TargetType::KOKKOS_TEAM_THREAD).fullPath»";
			N_CXX_COMPILER = "/usr/bin/g++";
			N_KOKKOS_PATH = "$ENV{HOME}/kokkos/kokkos-install";
		}
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
		Export-Package: «newProjectPage.moduleName.toLowerCase»
	'''

	private def getBuildPropertiesContent()
	'''
		source.. = src, src-gen-java/
		bin.includes = .,\
		               META-INF/
	'''
}