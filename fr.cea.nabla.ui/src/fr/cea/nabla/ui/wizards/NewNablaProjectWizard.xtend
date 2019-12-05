/*******************************************************************************
 * Copyright (c) 2019 CEA, Obeo
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
 package fr.cea.nabla.ui.wizards

import fr.cea.nabla.NablagenStandaloneSetupGenerated
import fr.cea.nabla.nabla.NablaFactory
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nablagen.NablagenFactory
import fr.cea.nabla.ui.UiUtils
import fr.cea.nabla.ui.internal.NablaActivator
import java.io.ByteArrayInputStream
import java.lang.reflect.InvocationTargetException
import java.util.ArrayList
import java.util.Collection
import java.util.HashMap
import org.eclipse.core.resources.IFile
import org.eclipse.core.resources.IFolder
import org.eclipse.core.resources.IProject
import org.eclipse.core.resources.IProjectDescription
import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.core.runtime.CoreException
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.core.runtime.Path
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.xmi.XMLResource
import org.eclipse.emf.transaction.RecordingCommand
import org.eclipse.jdt.core.IClasspathEntry
import org.eclipse.jdt.core.JavaCore
import org.eclipse.jface.operation.IRunnableWithProgress
import org.eclipse.jface.viewers.IStructuredSelection
import org.eclipse.jface.wizard.IWizardPage
import org.eclipse.jface.wizard.Wizard
import org.eclipse.pde.core.project.IBundleProjectDescription
import org.eclipse.sirius.business.api.componentization.ViewpointRegistry
import org.eclipse.sirius.business.api.session.Session
import org.eclipse.sirius.business.api.session.SessionManager
import org.eclipse.sirius.ui.business.api.viewpoint.ViewpointSelectionCallback
import org.eclipse.sirius.ui.tools.api.project.ModelingProjectManager
import org.eclipse.ui.INewWizard
import org.eclipse.ui.IWorkbench
import org.eclipse.ui.actions.WorkspaceModifyOperation
import org.eclipse.xtext.resource.XtextResourceSet
import org.eclipse.xtext.ui.XtextProjectHelper
import org.eclipse.sirius.business.api.modelingproject.ModelingProject
import fr.cea.nabla.nablagen.Language
import fr.cea.nabla.nabla.ConnectivityVar
import fr.cea.nabla.nabla.VarGroupDeclaration
import fr.cea.nabla.nabla.PrimitiveType
import org.eclipse.core.runtime.Status
import org.eclipse.core.runtime.IStatus

class NewNablaProjectWizard extends Wizard implements INewWizard
{
	static val WIZARD_TITLE = "New Nabla Project"
	static val DEFAULT_PROJECT_NAME = "nabla.project"
	static val DEFAULT_MODULE_NAME = "MyModule"
	static val NEW_PROJECT_PAGE_TITLE = "Create a new Nabla project"
	static val NEW_PROJECT_PAGE_DESCRIPTION = "Set project and module name."
	static val NABLAGEN_VP_ID = "InstructionViewpoint"

	NablaProjectPage newProjectPage = null
	XtextResourceSet rs = null

	new()
	{
		super()
		windowTitle = WIZARD_TITLE
		val t = new NablagenStandaloneSetupGenerated()
		val i = t.createInjectorAndDoEMFRegistration
		rs = i.getInstance(XtextResourceSet)
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
		val imageDescriptor = UiUtils.getImageDescriptor("icons/Nabal.gif")
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

	private def createProject(IProgressMonitor monitor) {
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
				// Create src-gen-kokkos folder
				val srcGenKokkosFolder = project.getFolder("src-gen-kokkos")
				srcGenKokkosFolder.create(false, true, monitor)
				// Create nabla and nablagen models
				val nablaFile = modulesFolder.getFile(newProjectPage.moduleName + ".nabla")
				val nablaModule = createNablaModelContents()
				createModel(rs, nablaFile, nablaModule)
				val nablagenFile = modulesFolder.getFile(newProjectPage.moduleName + ".nablagen")
				createModel(rs, nablagenFile, createNablagenModelContents(nablaModule))
				// Create MANIFEST
				createManifest(project, monitor)
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
				convertIntoJavaProject(project, #{srcGenJavaFolder}, monitor)
				// Create build.properties
				createBuildProperties(project, #{srcGenJavaFolder}, monitor)
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

	private def createModel(ResourceSet resourceSet, IFile modelFile, EObject rootObject)
	{
		val operation = new WorkspaceModifyOperation()
		{
			override execute(IProgressMonitor progressMonitor)
			{
				try
				{
					// Get the URI of the model file.
					val fileURI = URI.createPlatformResourceURI(modelFile.fullPath.toString, true)
					// Create a resource for this file.
					val resource = resourceSet.createResource(fileURI)
					// Add the initial model object to the contents.
					if (rootObject !== null)
					{
						resource.contents.add(rootObject)
					}
					// Save the contents of the resource to the file system.
					val options = new HashMap<Object, Object>()
					options.put(XMLResource.OPTION_ENCODING, "UTF-8")
					resource.save(options)
				}
				catch (Exception e)
				{
					NablaActivator::instance.log.log(new Status(IStatus.ERROR, NablaActivator.PLUGIN_ID, e.message))
				}
				finally
				{
					progressMonitor.done()
				}
			}
		}
		container.run(false, false, operation)
	}

	private def NablaModule createNablaModelContents()
	{
		val module = NablaFactory::eINSTANCE.createNablaModule
		module.name = newProjectPage.moduleName
		val nodeItemType = NablaFactory::eINSTANCE.createItemType
		nodeItemType.name = "node"
		module.items.add(nodeItemType)
		val cellItemType = NablaFactory::eINSTANCE.createItemType
		cellItemType.name = "cell"
		module.items.add(cellItemType)
		val faceItemType = NablaFactory::eINSTANCE.createItemType
		faceItemType.name = "face"
		module.items.add(faceItemType)
		val nodesConnectivity = NablaFactory::eINSTANCE.createConnectivity
		nodesConnectivity.name = "nodes"
		module.connectivities.add(nodesConnectivity)
		val nodesItemArg = NablaFactory::eINSTANCE.createItemArgType
		nodesItemArg.type = nodeItemType
		nodesItemArg.multiple = true
		nodesConnectivity.returnType = nodesItemArg
		val cellsConnectivity = NablaFactory::eINSTANCE.createConnectivity
		cellsConnectivity.name = "cells"
		module.connectivities.add(cellsConnectivity)
		val cellsItemArg = NablaFactory::eINSTANCE.createItemArgType
		cellsItemArg.type = cellItemType
		cellsItemArg.multiple = true
		cellsConnectivity.returnType = cellsItemArg
		val facesConnectivity = NablaFactory::eINSTANCE.createConnectivity
		facesConnectivity.name = "faces"
		module.connectivities.add(facesConnectivity)
		val facesItemArg = NablaFactory::eINSTANCE.createItemArgType
		facesItemArg.type = faceItemType
		facesItemArg.multiple = true
		facesConnectivity.returnType = facesItemArg
		val constX = NablaFactory::eINSTANCE.createSimpleVarDefinition
		constX.const = true
		val baseTypeX = NablaFactory::eINSTANCE.createBaseType
		baseTypeX.primitive = PrimitiveType::INT
		constX.type = baseTypeX
		val simpleVarX = NablaFactory::eINSTANCE.createSimpleVar
		simpleVarX.name = "X"
		constX.variable = simpleVarX
		val intConstantX = NablaFactory::eINSTANCE.createIntConstant
		intConstantX.value = 1
		constX.defaultValue = intConstantX
		module.instructions.add(constX)
		val constX_EDGE_LENGTH = NablaFactory::eINSTANCE.createSimpleVarDefinition
		constX_EDGE_LENGTH.const = true
		val baseTypeX_EDGE_LENGTH = NablaFactory::eINSTANCE.createBaseType
		baseTypeX_EDGE_LENGTH.primitive = PrimitiveType::REAL
		constX_EDGE_LENGTH.type = baseTypeX_EDGE_LENGTH
		val simpleVarX_EDGE_LENGTH = NablaFactory::eINSTANCE.createSimpleVar
		simpleVarX_EDGE_LENGTH.name = "X_EDGE_LENGTH"
		constX_EDGE_LENGTH.variable = simpleVarX_EDGE_LENGTH
		val realConstantX_EDGE_LENGTH = NablaFactory::eINSTANCE.createRealConstant
		realConstantX_EDGE_LENGTH.value = 0.1
		constX_EDGE_LENGTH.defaultValue = realConstantX_EDGE_LENGTH
		module.instructions.add(constX_EDGE_LENGTH)
		val constY_EDGE_LENGTH = NablaFactory::eINSTANCE.createSimpleVarDefinition
		constY_EDGE_LENGTH.const = true
		val baseTypeY_EDGE_LENGTH = NablaFactory::eINSTANCE.createBaseType
		baseTypeY_EDGE_LENGTH.primitive = PrimitiveType::REAL
		constY_EDGE_LENGTH.type = baseTypeY_EDGE_LENGTH
		val simpleVarY_EDGE_LENGTH = NablaFactory::eINSTANCE.createSimpleVar
		simpleVarY_EDGE_LENGTH.name = "Y_EDGE_LENGTH"
		constY_EDGE_LENGTH.variable = simpleVarY_EDGE_LENGTH
		val argOrVarRefY_EDGE_LENGTH = NablaFactory::eINSTANCE.createArgOrVarRef
		argOrVarRefY_EDGE_LENGTH.target = simpleVarX_EDGE_LENGTH
		constY_EDGE_LENGTH.defaultValue = argOrVarRefY_EDGE_LENGTH
		module.instructions.add(constY_EDGE_LENGTH)
		val constX_EDGE_ELEMS = NablaFactory::eINSTANCE.createSimpleVarDefinition
		constX_EDGE_ELEMS.const = true
		val baseTypeX_EDGE_ELEMS = NablaFactory::eINSTANCE.createBaseType
		baseTypeX_EDGE_ELEMS.primitive = PrimitiveType::INT
		constX_EDGE_ELEMS.type = baseTypeX_EDGE_ELEMS
		val simpleVarX_EDGE_ELEMS = NablaFactory::eINSTANCE.createSimpleVar
		simpleVarX_EDGE_ELEMS.name = "X_EDGE_ELEMS"
		constX_EDGE_ELEMS.variable = simpleVarX_EDGE_ELEMS
		val intConstantX_EDGE_ELEMS = NablaFactory::eINSTANCE.createIntConstant
		intConstantX_EDGE_ELEMS.value = 20
		constX_EDGE_ELEMS.defaultValue = intConstantX_EDGE_ELEMS
		module.instructions.add(constX_EDGE_ELEMS)
		val constY_EDGE_ELEMS = NablaFactory::eINSTANCE.createSimpleVarDefinition
		constY_EDGE_ELEMS.const = true
		val baseTypeY_EDGE_ELEMS = NablaFactory::eINSTANCE.createBaseType
		baseTypeY_EDGE_ELEMS.primitive = PrimitiveType::INT
		constY_EDGE_ELEMS.type = baseTypeY_EDGE_ELEMS
		val simpleVarY_EDGE_ELEMS = NablaFactory::eINSTANCE.createSimpleVar
		simpleVarY_EDGE_ELEMS.name = "Y_EDGE_ELEMS"
		constY_EDGE_ELEMS.variable = simpleVarY_EDGE_ELEMS
		val intConstantY_EDGE_ELEMS = NablaFactory::eINSTANCE.createIntConstant
		intConstantY_EDGE_ELEMS.value = 20
		constY_EDGE_ELEMS.defaultValue = intConstantY_EDGE_ELEMS
		module.instructions.add(constY_EDGE_ELEMS)
		val constZ_EDGE_ELEMS = NablaFactory::eINSTANCE.createSimpleVarDefinition
		constZ_EDGE_ELEMS.const = true
		val baseTypeZ_EDGE_ELEMS = NablaFactory::eINSTANCE.createBaseType
		baseTypeZ_EDGE_ELEMS.primitive = PrimitiveType::INT
		constZ_EDGE_ELEMS.type = baseTypeZ_EDGE_ELEMS
		val simpleVarZ_EDGE_ELEMS = NablaFactory::eINSTANCE.createSimpleVar
		simpleVarZ_EDGE_ELEMS.name = "Z_EDGE_ELEMS"
		constZ_EDGE_ELEMS.variable = simpleVarZ_EDGE_ELEMS
		val intConstantZ_EDGE_ELEMS = NablaFactory::eINSTANCE.createIntConstant
		intConstantZ_EDGE_ELEMS.value = 20
		constZ_EDGE_ELEMS.defaultValue = intConstantZ_EDGE_ELEMS
		module.instructions.add(constZ_EDGE_ELEMS)
		val varGroup = NablaFactory::eINSTANCE.createVarGroupDeclaration
		val baseType = NablaFactory::eINSTANCE.createBaseType
		baseType.primitive = PrimitiveType::REAL
		varGroup.type = baseType
		module.instructions.add(varGroup)
		val connectivityVar = NablaFactory::eINSTANCE.createConnectivityVar
		connectivityVar.name = "u"
		connectivityVar.supports.add(cellsConnectivity)
		varGroup.variables.add(connectivityVar)
		return module
	}

	private def EObject createNablagenModelContents(NablaModule nablaModule)
	{
		val module = NablagenFactory::eINSTANCE.createNablagenModule
		val importNablaModule = NablaFactory::eINSTANCE.createImport
		importNablaModule.importedNamespace = newProjectPage.moduleName + ".*"
		module.imports.add(importNablaModule)
		val workflow = NablagenFactory::eINSTANCE.createWorkflow
		workflow.name = newProjectPage.moduleName + "GenerationChain"
		workflow.nablaModule = nablaModule
		module.workflow = workflow
		val nabla2ir = NablagenFactory::eINSTANCE.createNabla2IrComponent
		nabla2ir.name = "nabla2ir"
		workflow.components.add(nabla2ir)
		val tagPersistentVar = NablagenFactory::eINSTANCE.createTagPersistentVariablesComponent
		tagPersistentVar.name = "tagPersistentVariables"
		val persistentVar = NablagenFactory::eINSTANCE.createPersistentVar
		persistentVar.varName = "Temperature"
		persistentVar.varRef = nablaModule.instructions.filter(VarGroupDeclaration).get(0).variables.filter(ConnectivityVar).get(0)
		tagPersistentVar.vars.add(persistentVar)
		val iterationPeriod = NablagenFactory::eINSTANCE.createIteration
		iterationPeriod.value = 1
		tagPersistentVar.period = iterationPeriod
		tagPersistentVar.parent = nabla2ir
		workflow.components.add(tagPersistentVar)
		val replaceUTF = NablagenFactory::eINSTANCE.createReplaceUtfComponent
		replaceUTF.name = "replaceUtf"
		replaceUTF.parent = tagPersistentVar
		workflow.components.add(replaceUTF)
		val replaceReductions = NablagenFactory::eINSTANCE.createReplaceReductionsComponent
		replaceReductions.name = "replaceReductions"
		replaceReductions.parent = replaceUTF
		workflow.components.add(replaceReductions)
		val optimizeConnectivities = NablagenFactory::eINSTANCE.createOptimizeConnectivitiesComponent
		optimizeConnectivities.name = "optimizeConnectivities"
		optimizeConnectivities.connectivities.add(nablaModule.connectivities.filter[name.equals("cells")].get(0))
		optimizeConnectivities.connectivities.add(nablaModule.connectivities.filter[name.equals("nodes")].get(0))
		optimizeConnectivities.connectivities.add(nablaModule.connectivities.filter[name.equals("faces")].get(0))
		optimizeConnectivities.parent = replaceReductions
		workflow.components.add(optimizeConnectivities)
		val fillHLTs = NablagenFactory::eINSTANCE.createFillHLTsComponent
		fillHLTs.name = "fillHLTs"
		fillHLTs.dumpIr = true
		fillHLTs.parent = optimizeConnectivities
		workflow.components.add(fillHLTs)
		val javaGenerator = NablagenFactory::eINSTANCE.createIr2CodeComponent
		javaGenerator.name = "javaGenerator"
		javaGenerator.language = Language::JAVA
		javaGenerator.outputDir = "/" + newProjectPage.projectName + "/src-gen-java"
		javaGenerator.parent = fillHLTs
		workflow.components.add(javaGenerator)
		val kokkosGenerator = NablagenFactory::eINSTANCE.createIr2CodeComponent
		kokkosGenerator.name = "kokkosGenerator"
		kokkosGenerator.language = Language::KOKKOS
		kokkosGenerator.outputDir = "/" + newProjectPage.projectName + "/src-gen-kokkos"
		kokkosGenerator.parent = fillHLTs
		workflow.components.add(kokkosGenerator)
		return module
	}

	private def createManifest(IProject project, IProgressMonitor monitor)
	{
		val manifestContents = new StringBuilder("Manifest-Version: 1.0")
		manifestContents.append(System.lineSeparator())
		manifestContents.append("Bundle-ManifestVersion: 2")
		manifestContents.append(System.lineSeparator())
		manifestContents.append("Bundle-Name: " + newProjectPage.projectName)
		manifestContents.append(System.lineSeparator())
		manifestContents.append("Bundle-SymbolicName: ").append(newProjectPage.projectName)
		manifestContents.append(System.lineSeparator())
		manifestContents.append("Bundle-Version: 1.0.0.qualifier")
		manifestContents.append(System.lineSeparator())
		manifestContents.append("Bundle-RequiredExecutionEnvironment: JavaSE-1.8")
		manifestContents.append(System.lineSeparator())
		manifestContents.append("Automatic-Module-Name: ").append(newProjectPage.projectName)
		manifestContents.append(System.lineSeparator())
		manifestContents.append("Require-Bundle: fr.cea.nabla,")
		manifestContents.append(System.lineSeparator())
		manifestContents.append(" fr.cea.nabla.ir,")
		manifestContents.append(System.lineSeparator())
		manifestContents.append(" fr.cea.nabla.sirius,")
		manifestContents.append(System.lineSeparator())
		manifestContents.append(" fr.cea.nabla.javalib")
		manifestContents.append(System.lineSeparator())

		val metaInf = project.getFolder("META-INF")
		metaInf.create(false, true, monitor)
		val manifest = metaInf.getFile("MANIFEST.MF")
		val bytes = manifestContents.toString().bytes
		val is = new ByteArrayInputStream(bytes)
		manifest.create(is, false, monitor)
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

	private def createBuildProperties(IProject project, Collection<IFolder> srcFolders, IProgressMonitor monitor)
	{
		val buildPropertiesContents = new StringBuilder("source.. = ")
		val iterator = srcFolders.iterator
		while (iterator.hasNext)
		{
			buildPropertiesContents.append(iterator.next.name).append('/')
			if (iterator.hasNext())
			{
				buildPropertiesContents.append(",\\")
			}
			buildPropertiesContents.append(System.lineSeparator())
		}
		buildPropertiesContents.append("bin.includes = .,\\")
		buildPropertiesContents.append(System.lineSeparator())
		buildPropertiesContents.append("               META-INF/,\\")
		buildPropertiesContents.append(System.lineSeparator())
		val buildProperties = project.getFile("build.properties")
		val bytes = buildPropertiesContents.toString().bytes
		val is = new ByteArrayInputStream(bytes)
		buildProperties.create(is, false, monitor)
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
}