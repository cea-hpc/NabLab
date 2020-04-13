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

import fr.cea.nabla.ui.UiUtils
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
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.transaction.RecordingCommand
import org.eclipse.jdt.core.IClasspathEntry
import org.eclipse.jdt.core.JavaCore
import org.eclipse.jface.operation.IRunnableWithProgress
import org.eclipse.jface.viewers.IStructuredSelection
import org.eclipse.jface.wizard.IWizardPage
import org.eclipse.jface.wizard.Wizard
import org.eclipse.pde.core.project.IBundleProjectDescription
import org.eclipse.sirius.business.api.componentization.ViewpointRegistry
import org.eclipse.sirius.business.api.modelingproject.ModelingProject
import org.eclipse.sirius.business.api.session.Session
import org.eclipse.sirius.business.api.session.SessionManager
import org.eclipse.sirius.ui.business.api.viewpoint.ViewpointSelectionCallback
import org.eclipse.sirius.ui.tools.api.project.ModelingProjectManager
import org.eclipse.ui.INewWizard
import org.eclipse.ui.IWorkbench
import org.eclipse.xtext.ui.XtextProjectHelper

class NewNablaProjectWizard extends Wizard implements INewWizard
{
	static val WIZARD_TITLE = "New Nabla Project"
	static val DEFAULT_PROJECT_NAME = "nabla.project"
	static val DEFAULT_MODULE_NAME = "MyModule"
	static val NEW_PROJECT_PAGE_TITLE = "Create a new Nabla project"
	static val NEW_PROJECT_PAGE_DESCRIPTION = "Set project and module name."
	static val NABLAGEN_VP_ID = "InstructionViewpoint"

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
		val imageDescriptor = UiUtils.getImageDescriptor("icons/Nabla.gif")
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
				val srcGenJavaFolder = project.getFolder("src-gen-java")
				srcGenJavaFolder.create(false, true, monitor)

				// Create src-gen-cpp folder
				val srcGenCppFolder = project.getFolder("src-gen-cpp")
				srcGenCppFolder.create(false, true, monitor)

				// Create all src-gen-cpp subfolders
				val cppFoldersByProgrammingModel = new LinkedHashMap<String, IFolder>

				val srcGenStlThreadFolder = srcGenCppFolder.getFolder("stl-thread")
				srcGenStlThreadFolder.create(false, true, monitor)
				cppFoldersByProgrammingModel.put("StlThread", srcGenStlThreadFolder)

				val srcGenKokkosFolder = srcGenCppFolder.getFolder("kokkos")
				srcGenKokkosFolder.create(false, true, monitor)
				cppFoldersByProgrammingModel.put("Kokkos", srcGenKokkosFolder)

				val srcGenKokkosTeamFolder = srcGenCppFolder.getFolder("kokkos-team")
				srcGenKokkosTeamFolder.create(false, true, monitor)
				cppFoldersByProgrammingModel.put("KokkosTeamThread", srcGenKokkosTeamFolder)

				// Create nabla and nablagen models
				val nablaFile = modulesFolder.getFile(newProjectPage.moduleName + ".nabla")
				createFile(nablaFile, getNablaModelContent(newProjectPage.moduleName), monitor)
				val nablagenFile = modulesFolder.getFile(newProjectPage.moduleName + ".nablagen")
				createFile(nablagenFile, getNablagenModelContent(newProjectPage.moduleName, srcGenJavaFolder, cppFoldersByProgrammingModel), monitor)

				// Create META-INF folder and MANIFEST
				val metaInf = project.getFolder("META-INF")
				metaInf.create(false, true, monitor)
				val manifestFile = metaInf.getFile("MANIFEST.MF")
				createFile(manifestFile, getManifestContent(), monitor)

				// Convert into Modeling Project
				ModelingProjectManager::INSTANCE.convertToModelingProject(project, monitor)

				// Enable Nablagen viewpoint
				val airdFilePath = project.fullPath + "/representations.aird"
				val airdFileURI = URI.createPlatformResourceURI(airdFilePath, true)
				val session = SessionManager::INSTANCE.getSession(airdFileURI, monitor)
				if (!session.isOpen)
				{
					session.open
				}
				enableNablagenViewpoint(session, monitor)
				session.save(monitor)

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
		description.natureIds = #[IBundleProjectDescription.PLUGIN_NATURE, ModelingProject.NATURE_ID, JavaCore.NATURE_ID, XtextProjectHelper.NATURE_ID]
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
		entries.add(JavaCore.newContainerEntry(new Path("org.eclipse.jdt.launching.JRE_CONTAINER/org.eclipse.jdt.internal.debug.ui.launcher.StandardVMType/JavaSE-1.8")))
		entries.add(JavaCore.newContainerEntry(new Path("org.eclipse.pde.core.requiredPlugins")))
		for (srcFolder : srcFolders)
		{
			val srcClasspathEntry = JavaCore.newSourceEntry(srcFolder.getFullPath())
			entries.add(srcClasspathEntry)
		}
		javaProject.setRawClasspath(entries.toArray(#[]), monitor)
		javaProject.setOutputLocation(new Path("/" + project.name + "/bin"), monitor)
	}

	private def enableNablagenViewpoint(Session session, IProgressMonitor monitor)
	{
		val editingDomain = session.transactionalEditingDomain
		val updateCommand = new RecordingCommand(editingDomain)
		{
			override doExecute()
			{
				val viewpoints = ViewpointRegistry::instance.viewpoints
				for (vp : viewpoints)
				{
					if (NABLAGEN_VP_ID.equals(vp.name))
					{
						new ViewpointSelectionCallback().selectViewpoint(vp, session, monitor)
						return
					}
				}
			}
		}
		editingDomain.commandStack.execute(updateCommand)
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

		set nodes: → { node };

		const X_EDGE_LENGTH = 0.1;
		const Y_EDGE_LENGTH = X_EDGE_LENGTH;
		const X_EDGE_ELEMS = 20;
		const Y_EDGE_ELEMS = 20;

		const max_iter = 200;
		const max_time = 1.0;

		ℝ t, δt;
		ℝ[2] X{nodes};
		ℝ e{nodes};

		iterate n while (n+1 < max_iter && t^{n+1} < max_time);
	'''

	private def getNablagenModelContent(String nablaModuleName, IFolder srcGenJavaFolder, HashMap<String, IFolder> cppFoldersByProgrammingModel)
	'''
		with «nablaModuleName».*;

		workflow «nablaModuleName»GenerationChain transforms «nablaModuleName»
		{
			Nabla2Ir nabla2ir
			{
				timeVariable = t;
				deltatVariable = δt;
				nodeCoordVariable = X;
			}

			TagPersistentVariables tagPersistentVariables follows nabla2ir
			{ 
				dumpedVariables = e as "Energy";
				period = 1.0 for n;
			}

			ReplaceUtf replaceUtf follows tagPersistentVariables
			{
			}

			ReplaceReductions replaceReductions follows replaceUtf
			{
			}

			OptimizeConnectivities optimizeConnectivities follows replaceReductions
			{
				connectivities = nodes;
			}

			FillHLTs fillHlts follows optimizeConnectivities
			{
			}

			Ir2Code javaGenerator follows fillHlts
			{
				language = Java;
				outputDir = "«srcGenJavaFolder.fullPath»";
			}
			«FOR cppProgrammingModel : cppFoldersByProgrammingModel.keySet»

			Ir2Code «cppProgrammingModel.toFirstLower»Generator follows fillHlts
			{
				language = Cpp
				{
					maxIterationVariable = max_iter;
					stopTimeVariable = max_time;
					programmingModel = «cppProgrammingModel»
				}
				outputDir = "«cppFoldersByProgrammingModel.get(cppProgrammingModel).fullPath»";
			}
			«ENDFOR»
		}
	'''

	private def getManifestContent()
	'''
		Manifest-Version: 1.0
		Bundle-ManifestVersion: 2
		Bundle-Name: nabla.project
		Bundle-SymbolicName: nabla.project
		Bundle-Version: 0.1.0.qualifier
		Bundle-RequiredExecutionEnvironment: JavaSE-1.8
		Automatic-Module-Name: nabla.project
		Require-Bundle: fr.cea.nabla,
		   fr.cea.nabla.ir,
		   fr.cea.nabla.sirius,
		   fr.cea.nabla.javalib,
		   org.eclipse.xtext.xbase.lib
	'''

	private def getBuildPropertiesContent()
	'''
		source.. = src, src-gen-java/
		bin.includes = .,\
		               META-INF/
	'''
}