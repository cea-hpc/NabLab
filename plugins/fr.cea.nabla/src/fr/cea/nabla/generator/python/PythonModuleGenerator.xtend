package fr.cea.nabla.generator.python

import com.google.inject.Inject
import fr.cea.nabla.generator.NablaGeneratorMessageDispatcher.MessageType
import fr.cea.nabla.generator.StandaloneGeneratorBase
import fr.cea.nabla.generator.ir.IrRootBuilder
import fr.cea.nabla.ir.generator.GenerationContent
import fr.cea.nabla.ir.ir.Affectation
import fr.cea.nabla.ir.ir.Function
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.nablagen.NablagenApplication
import java.util.List
import java.util.Map

import static extension fr.cea.nabla.ir.IrRootExtensions.*
import fr.cea.nabla.ir.ir.ArgOrVar

class PythonModuleGenerator extends StandaloneGeneratorBase {
	@Inject IrRootBuilder irRootBuilder

	def void generate(NablagenApplication ngenApp, String genDir) {
		try {
			val ir = irRootBuilder.buildGeneratorGenericIr(ngenApp)
			dispatcher.post(MessageType.Exec, "Starting instrumentation interface generation")
			val startTime = System.currentTimeMillis

			var fsa = getConfiguredFileSystemAccess(genDir, false)

			val content = getPythonModuleContent(ir)

			generate(fsa, content, ir.dirName)

			val endTime = System.currentTimeMillis
			dispatcher.post(MessageType.Exec,
				"Instrumentation interface generation ended in " + (endTime - startTime) / 1000.0 + "s")
		} catch (Exception e) {
			dispatcher.post(MessageType::Error, '\n***' + e.class.name + ': ' + e.message)
			if (e.stackTrace !== null && !e.stackTrace.empty) {
				val stack = e.stackTrace.head
				dispatcher.post(MessageType::Error,
					'at ' + stack.className + '.' + stack.methodName + '(' + stack.fileName + ':' + stack.lineNumber + ')')
			}
			throw (e)
		}
	}

	def List<GenerationContent> getPythonModuleContent(IrRoot ir) {
		val allJobs = ir.eAllContents.filter[o|o instanceof Job].map[o|o as Job].toList
		val allFunctions = ir.eAllContents.filter[o|o instanceof Function].map[o|o as Function].toList
		val allAssigns = ir.eAllContents.filter[o|o instanceof Affectation].map[o|(o as Affectation).left.target].toList
		val allGlobals = ir.variables
		val Map<Object, List<ArgOrVar>> allLocals = newHashMap
		allAssigns.filter[a|!(a.eContainer instanceof IrModule)].forEach[a|
			var c = a.eContainer
			var continue = true
			while (c !== null && continue) {
				if (c instanceof Function || c instanceof Job) {
					allLocals.computeIfAbsent(c, [newArrayList]).add(a)
					continue = false
				} else {
					c = c.eContainer
				}
			}
		]
		
		val fileContent =
			'''
				import «ir.name.toLowerCase»internal as internal
				from singleton import *
				
				class «ir.name.toFirstUpper»GlobalContext(metaclass=Singleton):
				  «FOR v : allGlobals»
				  @property
				  def «v.name»(self):
				    return internal.«v.name»()
				  
				  «ENDFOR»
				
				«FOR j : allJobs»
				class «j.name.toFirstUpper»Context(«ir.name.toFirstUpper»GlobalContext):
				  pass
				
				«FOR l : allLocals.getOrDefault(j, emptyList)»
				class «j.name.toFirstUpper»«l.name.toFirstUpper»Context(«j.name.toFirstUpper»Context):
				  @property
				  def «l.name»(self):
				    return internal.«j.name»_«l.name»()
				
				«ENDFOR»
				
				class «j.name.toFirstUpper»(metaclass=Singleton):
				  context = «j.name.toFirstUpper»Context()
				  
				  «FOR l : allLocals.getOrDefault(j, emptyList)»
				  @property
				  def «l.name»(self):
				    return «l.name.toFirstUpper»()
				  
				  class «l.name.toFirstUpper»(metaclass=Singleton):
				    context = «j.name.toFirstUpper»«l.name.toFirstUpper»Context()
				  
				  «ENDFOR»
				
				«ENDFOR»
				
				«FOR f : allFunctions»
				class «f.name.toFirstUpper»Context(«ir.name.toFirstUpper»GlobalContext):
				  «FOR v : f.inArgs»
				  @property
				  def «v.name»(self):
				    return internal.«f.name»_«v.name»()
				  
				  «ENDFOR»
				
				«FOR l : allLocals.getOrDefault(f, emptyList)»
				class «f.name.toFirstUpper»«l.name.toFirstUpper»Context(«f.name.toFirstUpper»Context):
				  @property
				  def «l.name»(self):
				    return internal.«f.name»_«l.name»()
				
				«ENDFOR»
				
				class «f.name.toFirstUpper»(metaclass=Singleton):
				  context = «f.name.toFirstUpper»Context()
				  
				  «FOR l : allLocals.getOrDefault(f, emptyList)»
				  @property
				  def «l.name»(self):
				    return «l.name.toFirstUpper»()
				  
				  class «l.name.toFirstUpper»(metaclass=Singleton):
				    context = «f.name.toFirstUpper»«l.name.toFirstUpper»Context()
				  
				  «ENDFOR»
				
				«ENDFOR»
				
				«FOR a : allAssigns.filter[assign|assign.eContainer instanceof IrModule]»
				class «a.name.toFirstUpper»Context(«ir.name.toFirstUpper»GlobalContext):
				  pass
				
				class «a.name.toFirstUpper»(metaclass=Singleton):
				  context = «a.name.toFirstUpper»Context()
				
				«ENDFOR»
			'''
		
		val content = new GenerationContent(ir.name.toLowerCase + ".py", fileContent, false)
		
		return #[content]
	}

}
