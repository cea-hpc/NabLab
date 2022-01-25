/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.arcane

import fr.cea.nabla.ir.JobCallerExtensions
import fr.cea.nabla.ir.generator.CppGeneratorUtils
import fr.cea.nabla.ir.generator.Utils
import fr.cea.nabla.ir.ir.ConnectivityType
import fr.cea.nabla.ir.ir.ExecuteTimeLoopJob
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.Job

import static extension fr.cea.nabla.ir.ContainerExtensions.*
import static extension fr.cea.nabla.ir.ExtensionProviderExtensions.*
import static extension fr.cea.nabla.ir.IrModuleExtensions.*
import static extension fr.cea.nabla.ir.IrRootExtensions.*
import static extension fr.cea.nabla.ir.generator.arcane.VariableExtensions.*

class IrModuleContentProvider
{
	static def getHeaderFileContent(IrModule it, String className)
	'''
	/* «Utils::doNotEditWarning» */

	#ifndef «CppGeneratorUtils.getHDefineName(className)»
	#define «CppGeneratorUtils.getHDefineName(className)»

	#include <arcane/utils/Array.h>
	#include <arcane/datatype/RealArrayVariant.h>
	#include <arcane/datatype/RealArray2Variant.h>
	#include "«name.toFirstUpper»_axl.h"
	#include "«irRoot.mesh.className».h"
	«FOR provider : externalProviders»
	#include "«provider.className».h"
	«ENDFOR»

	using namespace Arcane;

	«IF !functions.empty»
	/*** Free functions **********************************************************/

	namespace «CppGeneratorUtils.getFreeFunctionNs(it)»
	{
		«FOR f : functions»
			«FunctionContentProvider.getDeclarationContent(f)»;
		«ENDFOR»
	}

	«ENDIF»
	/*** Module ******************************************************************/

	class «className»
	: public Arcane«name.toFirstUpper»Object
	{
	public:
		«className»(const ModuleBuildInfo& mbi)
		: Arcane«name.toFirstUpper»Object(mbi) {}
		~«className»() {}

		virtual void init() override;
		«FOR j : ArcaneUtils.getComputeLoopEntryPointJobs(it)»
			virtual void «j.name.toFirstLower»() override;
		«ENDFOR»

		VersionInfo versionInfo() const override { return VersionInfo(1, 0, 0); }

	private:
		«FOR j : jobs.filter[!mainTimeLoop]»
			«JobContentProvider.getDeclarationContent(j)»
		«ENDFOR»

	private:
		// mesh attributes
		«irRoot.mesh.className»* m_mesh;
		«FOR c : irRoot.mesh.connectivities.filter[x | x.multiple && x.inTypes.empty]»
			Integer «ArcaneUtils.toAttributeName(c.nbElemsVar)»;
		«ENDFOR»

		// other attributes
		«FOR v : variables.filter[x | !(x.option || x.type instanceof ConnectivityType)]»
			«IF v.constExpr»
				static constexpr «TypeContentProvider.getTypeName(v.type)» «v.codeName» = «ExpressionContentProvider.getContent(v.defaultValue)»;
			«ELSE»
				««« Must not be declared const even it the const attribute is true
				««« because it will be initialized in the init method (not in cstr)
				«TypeContentProvider.getTypeName(v.type)» «v.codeName»;
			«ENDIF»
		«ENDFOR»
	};

	#endif
	'''

	static def getSourceFileContent(IrModule it, String className)
	'''
	/* «Utils::doNotEditWarning» */

	#include "«className».h"
	#include <arcane/Concurrency.h>
	#include <arcane/ITimeLoopMng.h>

	using namespace Arcane;

	«IF !functions.empty»
		/*** Free functions **********************************************************/

		namespace «CppGeneratorUtils.getFreeFunctionNs(it)»
		{
			«FOR f : functions SEPARATOR '\n'»
				«FunctionContentProvider.getDefinitionContent(f)»
			«ENDFOR»
		}

	«ENDIF»
	/*** Module ******************************************************************/

	void «className»::init()
	{
		// initialization of mesh attributes
		m_mesh = «irRoot.mesh.className»::createInstance(mesh());
		«FOR c : irRoot.mesh.connectivities.filter[x | x.multiple && x.inTypes.empty]»
			«ArcaneUtils.toAttributeName(c.nbElemsVar)» = m_mesh->getNb«c.name.toFirstUpper»()»;
		«ENDFOR»

		// initialization of other attributes
		«FOR v : variables.filter[!(constExpr || option)]»
			«val resizeDims = TypeContentProvider.getResizeDims(v.type)»
			«IF !resizeDims.empty»
				«v.codeName».resize(«FOR s : resizeDims SEPARATOR ', '»«s»«ENDFOR»);
			«ELSEIF v.defaultValue !== null»
				«v.codeName» = «ExpressionContentProvider.getContent(v.defaultValue)»;
			«ENDIF»
		«ENDFOR»

		// calling jobs
		«FOR c : irRoot.main.calls.filter[!mainTimeLoop]»
			«Utils::getCallName(c).replace('.', '->')»(); // @«c.at»
		«ENDFOR»
	}

	«FOR j : jobs»
		«JobContentProvider.getDefinitionContent(j)»

	«ENDFOR»

	ARCANE_REGISTER_MODULE_«name.toUpperCase»(«className»);
	'''

	/** The main time loop job is represented by the compute entry point */
	private static def boolean isMainTimeLoop(Job j)
	{
		j instanceof ExecuteTimeLoopJob && JobCallerExtensions.isMain(j.caller)
	}
}