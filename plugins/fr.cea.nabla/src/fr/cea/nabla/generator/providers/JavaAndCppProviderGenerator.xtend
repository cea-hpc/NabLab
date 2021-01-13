package fr.cea.nabla.generator.providers

import com.google.inject.Inject
import fr.cea.nabla.generator.BackendFactory
import fr.cea.nabla.generator.NablaGeneratorMessageDispatcher.MessageType
import fr.cea.nabla.generator.StandaloneGeneratorBase
import fr.cea.nabla.generator.UnzipHelper
import fr.cea.nabla.ir.generator.cpp.CppProviderGenerator
import fr.cea.nabla.ir.generator.java.JavaProviderGenerator
import fr.cea.nabla.ir.ir.Function
import fr.cea.nabla.nablaext.ExtensionProvider
import fr.cea.nabla.nablaext.TargetType
import java.io.File
import org.eclipse.core.resources.IProject
import org.eclipse.core.resources.IProjectDescription
import org.eclipse.core.resources.IResource
import org.eclipse.core.resources.IWorkspace
import org.eclipse.core.runtime.NullProgressMonitor
import org.eclipse.core.runtime.Path

class JavaAndCppProviderGenerator extends StandaloneGeneratorBase
{
	@Inject BackendFactory backendFactory
	@Inject extension ProvidersUtils

	def generate(Iterable<ExtensionProvider> providers, IProject project)
	{
		var Iterable<Function> functions = null
		for (provider : providers)
		{
			val generator = getCodeGenerator(provider.target, project.workspace.root.location.toString)
			val providerProject = getProject(project.workspace, provider)
			dispatcher.post(MessageType::Exec, "Generating extension provider project: " + providerProject.location.toString)
			val fsa = getConfiguredFileSystemAccess(providerProject.location.toString + '/src', false)
			if (functions === null)
			{
				// Functions are calculated only once.
				// A validator ensures all providers are for the same extension.
				functions = provider.extension.irFunctions
			}
			generate(fsa, generator.getGenerationContents(provider.toIrExtensionProvider, functions), '')
			providerProject.refreshLocal(IResource::DEPTH_INFINITE, null)
		}
	}

	private def getCodeGenerator(TargetType targetType, String baseDir)
	{
		if (targetType == TargetType::JAVA)
		{
			//UnzipHelper::unzipLibJavaNabla(new File(baseDir))
			new JavaProviderGenerator
		}
		else
		{
			val backend = backendFactory.getCppBackend(targetType)
			UnzipHelper::unzipLibCppNabla(new File(baseDir))
			val libCppNablaDir = baseDir + '/' + UnzipHelper.CppResourceName
			new CppProviderGenerator(backend, libCppNablaDir.formatCMakePath)
		}
	}

	private def getProject(IWorkspace ws, ExtensionProvider provider)
	{
		var project = ws.root.getProject(provider.name)
		var IProjectDescription desc
		if (!project.exists)
		{
			if (provider.target === TargetType::JAVA)
			{
				val location = ws.root.location.toString
				val fsa = getConfiguredFileSystemAccess(location, false)
				fsa.generateFile(project.name + "/.project", getDotProjectContent(project.name))
				fsa.generateFile(project.name + "/.classpath", dotClassPath)
				fsa.generateFile(project.name + "/build.properties", buildProperties)
				val packageName = provider.extension.name.toLowerCase
				fsa.generateFile(project.name + "/META-INF/MANIFEST.MF", getManifestContent(project.name, packageName))
				fsa.generateFile(project.name + "/build.xml", getAntFile(project.name, packageName))
				fsa.generateFile(project.name + "/.externalToolBuilders/CreateJar.launch", getCreateJarToolFile(project.name))
				desc = ws.loadProjectDescription(new Path(location + "/" + project.name + "/.project"))
			}
			else
			{
				desc = ws.newProjectDescription(project.name)
			}

			desc.locationURI = ws.pathVariableManager.getURIValue(project.name)
			val monitor = new NullProgressMonitor
			project.create(desc, monitor)
			project.open(monitor)

			// Create src folder
			val srcFolder = project.getFolder("src")
			srcFolder.create(false, true, monitor)
		}
		return project
	}

	private def getDotProjectContent(String projectName)
	'''
	<projectDescription>
		<name>«projectName»</name>
		<comment></comment>
		<projects>
		</projects>
		<buildSpec>
			<buildCommand>
				<name>org.eclipse.jdt.core.javabuilder</name>
				<arguments>
				</arguments>
			</buildCommand>
			<buildCommand>
				<name>org.eclipse.pde.ManifestBuilder</name>
				<arguments>
				</arguments>
			</buildCommand>
			<buildCommand>
				<name>org.eclipse.pde.SchemaBuilder</name>
				<arguments>
				</arguments>
			</buildCommand>
			<buildCommand>
				<name>org.eclipse.ui.externaltools.ExternalToolBuilder</name>
				<triggers>full,incremental,</triggers>
				<arguments>
					<dictionary>
						<key>LaunchConfigHandle</key>
						<value>&lt;project&gt;/.externalToolBuilders/CreateJar.launch</value>
					</dictionary>
				</arguments>
			</buildCommand>
		</buildSpec>
		<natures>
			<nature>org.eclipse.jdt.core.javanature</nature>
			<nature>org.eclipse.pde.PluginNature</nature>
		</natures>
	</projectDescription>
	'''

	private def getManifestContent(String projectName, String packageName)
	'''
	Manifest-Version: 1.0
	Automatic-Module-Name: «projectName»
	Bundle-ManifestVersion: 2
	Bundle-Name: «projectName»
	Bundle-SymbolicName: «projectName»
	Bundle-Version: 1.0.0.qualifier
	Export-Package: «packageName»
	Require-Bundle: com.google.gson
	Bundle-RequiredExecutionEnvironment: JavaSE-11
	'''

	private def getBuildProperties()
	'''
	source.. = src/
	bin.includes = META-INF/,\
	'''

	private def getDotClassPath()
	'''
	<?xml version="1.0" encoding="UTF-8"?>
	<classpath>
		<classpathentry kind="con" path="org.eclipse.jdt.launching.JRE_CONTAINER/org.eclipse.jdt.internal.debug.ui.launcher.StandardVMType/JavaSE-11"/>
		<classpathentry kind="src" path="src"/>
		<classpathentry kind="con" path="org.eclipse.pde.core.requiredPlugins"/>
		<classpathentry kind="output" path="bin"/>
	</classpath>
	'''

	private def getAntFile(String projectName, String jarName)
	'''
	<?xml version="1.0" ?>
		<!-- Configuration of the Ant build system to generate a Jar file --> 
		<project name="«projectName»" default="CreateJar">
			<target name="CreateJar" description="Create Jar file">
				<jar jarfile="lib/«jarName».jar" basedir="bin/" includes="**/*.class" />
			</target>
		</project>
	'''

	private def getCreateJarToolFile(String projectName)
	'''
	<?xml version="1.0" encoding="UTF-8" standalone="no"?>
	<launchConfiguration type="org.eclipse.ant.AntBuilderLaunchConfigurationType">
		<booleanAttribute key="org.eclipse.ant.ui.ATTR_TARGETS_UPDATED" value="true"/>
		<booleanAttribute key="org.eclipse.ant.ui.DEFAULT_VM_INSTALL" value="false"/>
		<booleanAttribute key="org.eclipse.debug.ui.ATTR_LAUNCH_IN_BACKGROUND" value="false"/>
		<stringAttribute key="org.eclipse.jdt.launching.CLASSPATH_PROVIDER" value="org.eclipse.ant.ui.AntClasspathProvider"/>
		<booleanAttribute key="org.eclipse.jdt.launching.DEFAULT_CLASSPATH" value="true"/>
		<stringAttribute key="org.eclipse.jdt.launching.PROJECT_ATTR" value="«projectName»"/>
		<stringAttribute key="org.eclipse.ui.externaltools.ATTR_LOCATION" value="${workspace_loc:/«projectName»/build.xml}"/>
		<stringAttribute key="org.eclipse.ui.externaltools.ATTR_RUN_BUILD_KINDS" value=""/>
		<booleanAttribute key="org.eclipse.ui.externaltools.ATTR_TRIGGERS_CONFIGURED" value="true"/>
	</launchConfiguration>
	'''
}
