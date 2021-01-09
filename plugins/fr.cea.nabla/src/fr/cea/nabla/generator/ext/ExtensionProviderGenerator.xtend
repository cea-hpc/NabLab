package fr.cea.nabla.generator.ext

import com.google.inject.Inject
import fr.cea.nabla.generator.NablaGeneratorMessageDispatcher.MessageType
import fr.cea.nabla.generator.StandaloneGeneratorBase
import fr.cea.nabla.generator.ir.IrFunctionFactory
import fr.cea.nabla.ir.generator.Utils
import fr.cea.nabla.ir.transformers.ReplaceUtf8Chars
import fr.cea.nabla.nabla.NablaExtension
import fr.cea.nabla.nablaext.TargetType
import org.eclipse.core.resources.IProject
import org.eclipse.core.resources.IResource
import org.eclipse.core.resources.IWorkspace
import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.core.runtime.NullProgressMonitor

class ExtensionProviderGenerator extends StandaloneGeneratorBase
{
	@Inject CppProviderGenerator cppProviderGenerator
	@Inject JniProviderGenerator jniProviderGenerator
	@Inject IrFunctionFactory irFactory

	/**
	 * For an extension named X, generates XCpp.nablaext and XJni.nablaext
	 * in the project source folder. Cpp and Jni projects are generated in
	 * the same workspace in XCpp and XJni directories.
	 */
	def generate(NablaExtension nablaExt, IProject project, String libCppNablaDir)
	{
		val irFunctions = nablaExt.functions.map[x | 
			val irFunction = irFactory.toIrFunction(x)
			irFunction.name = ReplaceUtf8Chars.getNoUtf8(irFunction.name)
			return irFunction
		]

		// Generate C++ extension provider project
		val cppProject = getProject(project.workspace, nablaExt.name + "Cpp")
		cppProviderGenerator.generate(nablaExt, cppProject, irFunctions, libCppNablaDir.formatCMakePath)
		cppProject.refreshLocal(IResource::DEPTH_INFINITE, null)

		// Generate Jni extension provider project
		val jniProject = getProject(project.workspace, nablaExt.name + "Jni")
		jniProviderGenerator.generate(nablaExt, jniProject, irFunctions, cppProject.location.toString.formatCMakePath)
		jniProject.refreshLocal(IResource::DEPTH_INFINITE, null)

		// Generate .nablaext files in current project
		val projectHome = project.location.toString
		val fsa = getConfiguredFileSystemAccess(projectHome + "/src/" + nablaExt.name.toLowerCase, false)
		dispatcher.post(MessageType::Exec, "Starting extension provider files generation (.nablaext) in: " + projectHome)
		var fileName = nablaExt.name + "Cpp.nablaext"
		dispatcher.post(MessageType::Exec, "    Generating: " + fileName)
		fsa.generateFile(fileName, getCppExtensionProviderContent(nablaExt, cppProject.location.toString.formatCMakePath))
		fileName = nablaExt.name + "Jni.nablaext"
		dispatcher.post(MessageType::Exec, "    Generating: " + fileName)
		fsa.generateFile(fileName, getJniExtensionProviderContent(nablaExt, jniProject.location.toString.formatCMakePath))
	}

	private def getCppExtensionProviderContent(NablaExtension it, String libHome)
	'''
	«Utils.fileHeader»

	/*
	 * C++ Extension Provider
	 * Build instructions:
	 *   - go into the project directory: cd «libHome»
	 *   - create a directory to build the project: mkdir lib; cd lib
	 *   - start cmake with your compiler: cmake -D CMAKE_CXX_COMPILER=/usr/bin/g++ ../src
	 *   - compile: make
	 */
	ExtensionProvider «name»Cpp : «name»
	{
		targets = «FOR t : TargetType.values.filter[x | x != TargetType::JAVA] SEPARATOR ', '»«t.literal»«ENDFOR»;
		facadeClass = "«name.toLowerCase»::«name»";
		libHome = "«libHome»";
		libName = "lib«name.toLowerCase».so";
	}
	'''

	private def getJniExtensionProviderContent(NablaExtension it, String libHome)
	'''
	«Utils.fileHeader»

	/*
	 * JNI Extension Provider
	 * Build instructions:
	 *   - go into the project directory: cd «libHome»
	 *   - create a directory to build the project: mkdir lib; cd lib
	 *   - start cmake with your java home: cmake -D JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64 ../src/
	 *   - compile: make
	 */
	ExtensionProvider «name»Jni : «name»
	{
		targets = «TargetType::JAVA.literal»;
		facadeClass = "«name.toLowerCase».«name»";
		libHome = "«libHome»";
		libName = "«name.toLowerCase»jni.jar";
	}
	'''

	private def getProject(IWorkspace ws, String projectName)
	{
		var project = ResourcesPlugin.workspace.root.getProject(projectName)
		if (!project.exists)
		{
			val desc = ws.newProjectDescription(projectName)
			desc.locationURI = ws.pathVariableManager.getURIValue(projectName)
			val monitor = new NullProgressMonitor
			project.create(desc, monitor)
			project.open(monitor)

			// Create src folder
			val srcFolder = project.getFolder("src")
			srcFolder.create(false, true, monitor)
		}
		return project
	}
}