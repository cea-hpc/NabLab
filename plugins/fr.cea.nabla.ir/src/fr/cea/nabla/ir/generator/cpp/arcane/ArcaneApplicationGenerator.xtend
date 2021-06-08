/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.cpp.arcane

import fr.cea.nabla.ir.generator.ApplicationGenerator
import fr.cea.nabla.ir.generator.GenerationContent
import fr.cea.nabla.ir.generator.Utils
import fr.cea.nabla.ir.generator.cpp.CppGeneratorUtils
import fr.cea.nabla.ir.ir.InternFunction
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.transformers.ReplaceReductions
import java.util.ArrayList

import static extension fr.cea.nabla.ir.ExtensionProviderExtensions.*
import static extension fr.cea.nabla.ir.IrModuleExtensions.*

class ArcaneApplicationGenerator implements ApplicationGenerator
{
	val String arcaneDir

	override getName() { 'Arcane' }
	override getIrTransformationStep() { new ReplaceReductions(true) }

	new(String arcaneDir)
	{
		this.arcaneDir = arcaneDir
	}

	override getGenerationContents(IrRoot ir)
	{
		val fileContents = new ArrayList<GenerationContent>
		for (module : ir.modules)
		{
			fileContents += new GenerationContent(module.name + '.axl', AxlContentProvider.getContent(module), false)
			fileContents += new GenerationContent(module.className + '.h', module.headerFileContent, false)
//			fileContents += new GenerationContent(module.className + '.cc', module.sourceFileContent, false)
		}
		fileContents += new GenerationContent('CMakeLists.txt', CMakeContentProvider.getContent(ir, arcaneDir), false)
		fileContents += new GenerationContent(ir.name + '.config', TimeLoopContentProvider.getContent(ir), false)
		fileContents += new GenerationContent('main.cc', MainContentProvider.getContent(ir), false)
		return fileContents
	}

	private def getHeaderFileContent(IrModule it)
	'''
	/* «Utils::doNotEditWarning» */

	«val className = ArcaneUtils.getModuleName(it)»
	#ifndef «CppGeneratorUtils.getHDefineName(className)»
	#define «CppGeneratorUtils.getHDefineName(className)»

	#include <arcane/utils/Array.h>
	#include "«name»_axl.h"
	«FOR provider : extensionProviders»
	#include "«provider.className».h"
	«ENDFOR»

	using namespace Arcane;
	«val internFunctions = functions.filter(InternFunction)»
	«IF !internFunctions.empty»

	/******************** Free functions declarations ********************/

	namespace «CppGeneratorUtils.getFreeFunctionNs(it)»
	{
	«FOR f : internFunctions»
		«FunctionContentProvider.getDeclarationContent(f)»;
	«ENDFOR»
	}
	«ENDIF»

	/******************** Module declaration ********************/

	class «className»
	: public Arcane«name.toFirstUpper»Object
	{
	public:
		«className»(const ModuleBuildInfo& mbi)
		: Arcane«name.toFirstUpper»Object(mbi) {}
		~«className»() {}

		virtual void init() override;
		virtual void compute() override;

		VersionInfo versionInfo() const override { return VersionInfo(1, 0, 0); }

	private:
		«FOR j : jobs»
		«JobContentProvider.getDeclarationContent(j)»
		«ENDFOR»
	};

	#endif
	'''
}