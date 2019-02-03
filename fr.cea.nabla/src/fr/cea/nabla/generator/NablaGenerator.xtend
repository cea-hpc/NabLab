/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 *
 * Contributors:
 * 	Benoit Lelandais - initial implementation
 * 	Marie-Pierre Oudot - initial implementation
 * 	Jean-Sylvain Camier - Nabla generation support
 *******************************************************************************/
package fr.cea.nabla.generator

import com.google.inject.Inject
import fr.cea.nabla.generator.ir.Nabla2Ir
import fr.cea.nabla.ir.generator.java.Ir2Java
import fr.cea.nabla.ir.generator.kokkos.Ir2Kokkos
import fr.cea.nabla.ir.generator.n.Ir2N
import fr.cea.nabla.ir.transformers.TagPersistentVariables
import fr.cea.nabla.nabla.NablaModule
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.util.EcoreUtil
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext

/**
 * Generates code from your model files on save.
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 * 
 * Attention: avant la génération, le modèle IR subit des modifications par différentes passes.
 * Il n'est pas possible d'avoir plusieurs générateurs sans cloner l'IR ;  en effet le mécanisme
 * d'optimisation des créations de Xtend (def create) fait que s'il y a plusieurs appels à toIrModule
 * (Nabla -> IR), l'IR n'est pas recréée. Par conséquent, lors de la transformation, les passes 
 * se superposent.
 */
class NablaGenerator extends AbstractGenerator 
{
	static val IrExtension = 'nablair'
	static val PropertiesExtension = 'properties'
	
	@Inject GeneratorUtils utils
	@Inject SmallLatexGenerator latexGenerator
	@Inject Nabla2Ir nabla2ir
	
	@Inject Ir2N ir2N
	@Inject Ir2Java ir2Java
	@Inject Ir2Kokkos ir2Kokkos
	
	override doGenerate(Resource input, IFileSystemAccess2 fsa, IGeneratorContext context) 
	{
		// 1 seul module par resource par définition (cf .xtext)
		val module = input.contents.filter(NablaModule).head
		println("Model size (eAllContents.size): " + module.eAllContents.size)
		
		// ecriture du fichier de modele
		if (!module.jobs.empty)
		{
			val fileNameWithoutExtension = module.name.toLowerCase + '/' + module.name
			
			println('Generating Latex document')
			fsa.generateFile(fileNameWithoutExtension.addExtensions(#['tex']), latexGenerator.getLatexContent(module))
			
			println('Generating initial Ir')			
			val irModuleRef = nabla2ir.toIrModule(module)
			
			print('Looking for a properties file... ')
			val uri = input.URI.trimFileExtension.toString.addExtensions(#[PropertiesExtension])
			val properties = utils.getProperties(uri)
			val generators = #[ir2N, ir2Java, ir2Kokkos]	
			if (properties.empty) println('no file')
			else
			{
				println('ok file found')
				
				ir2Java.generationDir = properties.getProperty('javaGenerationDir', null)
				ir2Kokkos.generationDir = properties.getProperty('kokkosGenerationDir', null) 
				ir2N.generationDir = properties.getProperty('nGenerationDir', null) 
				
				val tagVariableStep = new TagPersistentVariables(properties)
				tagVariableStep.transform(irModuleRef)				
			}
			
			for (generator : generators.filter[x | !x.generationDir.nullOrEmpty])
			{
				val languageFileNameWithoutExtensions = generator.generationDir + '/' + fileNameWithoutExtension
				
				val irModule = EcoreUtil::copy(irModuleRef)
				println('Starting generation chain for ' + generator.shortName + ' (.' + generator.fileExtension + ' file)')
				println('\tBuilding Nabla Intermediate Representation')
	
				// application des transformation de l'IR (dépendant du langage
				var transformOK = true
				val stepIt = generator.transformationSteps.iterator
				while (stepIt.hasNext && transformOK)
				{
					val step = stepIt.next
					println('\tIR -> IR: ' + step.description)
					createAndSaveResource(fsa, input.resourceSet, languageFileNameWithoutExtensions.addExtensions(#['before' + step.shortName, generator.fileExtension, IrExtension]), irModule)		
					transformOK = step.transform(irModule)
				}
				createAndSaveResource(fsa, input.resourceSet, languageFileNameWithoutExtensions.addExtensions(#[generator.fileExtension, IrExtension]), irModule)
			
				// génération du fichier source
				if (transformOK)
				{
					println('\tGenerating .' + generator.fileExtension + ' file')
					val fileContent = generator.getFileContent(irModule)
					fsa.generateFile(languageFileNameWithoutExtensions.addExtensions(#[generator.fileExtension]), fileContent)	
				}	
			}
		}
	}
	
	private def getShortName(Object o) { o.class.name.substring(o.class.package.name.length + 1) }
	private def addExtensions(String fileNameWithoutExtension, String[] extensions) { fileNameWithoutExtension + '.' + extensions.join('.') } 
		
	/** Crée et sauve la resource au même endroit que le paramètre baseResource en changeant l'extension par newExtension */
	private def createAndSaveResource(IFileSystemAccess2 fsa, ResourceSet rSet, String fileName, EObject content)
	{
		val uri = fsa.getURI(fileName)
		val resource = rSet.createResource(uri)
		resource.contents += content
		resource.save(utils.xmlSaveOptions)
	}
}
