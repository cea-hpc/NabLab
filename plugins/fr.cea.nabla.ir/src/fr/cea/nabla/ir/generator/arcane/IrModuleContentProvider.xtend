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
import fr.cea.nabla.ir.annotations.AcceleratorAnnotation
import fr.cea.nabla.ir.generator.CppGeneratorUtils
import fr.cea.nabla.ir.generator.Utils
import fr.cea.nabla.ir.ir.ConnectivityType
import fr.cea.nabla.ir.ir.ExecuteTimeLoopJob
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.LinearAlgebraType

import static extension fr.cea.nabla.ir.ExtensionProviderExtensions.*
import static extension fr.cea.nabla.ir.IrModuleExtensions.*
import static extension fr.cea.nabla.ir.IrRootExtensions.*
import static extension fr.cea.nabla.ir.generator.arcane.ArcaneUtils.getCodeName

class IrModuleContentProvider
{
	static def getInterfaceFileContent(IrModule it)
	'''
	«val className = ArcaneUtils.getInterfaceName(it)»
	/* «Utils::doNotEditWarning» */

	#ifndef «CppGeneratorUtils.getHDefineName(className)»
	#define «CppGeneratorUtils.getHDefineName(className)»

	using namespace Arcane;

	class «className»
	{
	public:
		«className»() {}
		virtual ~«className»() {}

	public:
		«FOR j : jobs.filter[!mainTimeLoop]»
			«JobContentProvider.getDeclarationContent(j)» = 0;
		«ENDFOR»
	};

	#endif
	'''

	static def getHeaderFileContent(IrModule it)
	'''
	«val className = ArcaneUtils.getClassName(it)»
	/* «Utils::doNotEditWarning» */

	#ifndef «CppGeneratorUtils.getHDefineName(className)»
	#define «CppGeneratorUtils.getHDefineName(className)»

	#include <arcane/utils/NumArray.h>
	#include <arcane/datatype/RealArrayVariant.h>
	#include <arcane/datatype/RealArray2Variant.h>
	«IF AcceleratorAnnotation.tryToGet(it) !== null»
		#include <arcane/accelerator/core/IAcceleratorMng.h>
		#include <arcane/accelerator/Reduce.h>
		#include <arcane/accelerator/Accelerator.h>
		#include <arcane/accelerator/RunCommandEnumerate.h>
	«ENDIF»
	«FOR s : ArcaneUtils.getServices(it)»
	#include "«ArcaneUtils.getInterfaceName(s)».h"
	«ENDFOR»
	«IF ArcaneUtils.isArcaneService(it)»
	#include "«ArcaneUtils.getInterfaceName(it)».h"
	«ENDIF»
	#include "«name.toFirstUpper»_axl.h"
	#include "«irRoot.mesh.className».h"
	«FOR provider : externalProviders»
	#include "«provider.className».h"
	«ENDFOR»
	«IF variables.exists[v | TypeContentProvider.isArcaneStlVector(v.type)]»
	#include "Arcane2StlVector.h"
	«ENDIF»

	«IF AcceleratorAnnotation.tryToGet(it) !== null»namespace ax = Arcane::Accelerator;«ENDIF»
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
	/*** Module/Service **********************************************************/

	class «className»
	: public Arcane«name.toFirstUpper»Object
	{
	public:
		«className»(const «IF ArcaneUtils.isArcaneModule(it)»Module«ELSE»Service«ENDIF»BuildInfo& mbi);
		~«className»() {}
		«IF ArcaneUtils.isArcaneModule(it)»

		// entry points
		virtual void init() override;
		«FOR j : ArcaneUtils.getComputeLoopEntryPointJobs(it)»
			virtual void «j.name.toFirstLower»() override;
		«ENDFOR»

		VersionInfo versionInfo() const override { return VersionInfo(1, 0, 0); }
		«ENDIF»

	public:
		// jobs
		«FOR j : jobs.filter[!mainTimeLoop]»
			«JobContentProvider.getDeclarationContent(j)»«IF ArcaneUtils.isArcaneService(it)» override«ENDIF»;
		«ENDFOR»

	private:
		// mesh attributes
		«irRoot.mesh.className»* m_mesh;

		// other attributes
		«FOR p : externalProviders»
			«p.className» «ArcaneUtils.toAttributeName(p.instanceName)»;
		«ENDFOR»
		«FOR v : variables.filter[x | !(x.option || x.type instanceof ConnectivityType)]»
			«IF v.constExpr»
				static constexpr «TypeContentProvider.getTypeName(v.type)» «v.codeName» = «ExpressionContentProvider.getContent(v.defaultValue)»;
			«ELSE»
				««« Must not be declared const even it the const attribute is true
				««« because it will be initialized in the init method (not in cstr)
				«TypeContentProvider.getTypeName(v.type)» «v.codeName»;
			«ENDIF»
		«ENDFOR»
		«IF AcceleratorAnnotation.tryToGet(it) !== null»

			// accelerator queue
			ax::RunQueue* m_default_queue = nullptr;
		«ENDIF»
	};

	#endif
	'''

	static def getSourceFileContent(IrModule it)
	'''
	«val className = ArcaneUtils.getClassName(it)»
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
	/*** Module/Service **********************************************************/

	«className»::«className»(const «IF ArcaneUtils.isArcaneModule(it)»Module«ELSE»Service«ENDIF»BuildInfo& bi)
	: Arcane«name.toFirstUpper»Object(bi)
	«FOR v : variables.filter[x | (x.type instanceof LinearAlgebraType)]»
		, «v.codeName»(«IF TypeContentProvider.isArcaneStlVector(v.type)»this, «ENDIF»"«v.name»")
	«ENDFOR»
	«IF AcceleratorAnnotation.tryToGet(it) !== null»
		, m_default_queue(subDomain()->acceleratorMng()->defaultQueue())
	«ENDIF»
	{}
	«IF ArcaneUtils.isArcaneModule(it)»

	void «className»::init()
	{
		// initialization of mesh attributes
		m_mesh = «irRoot.mesh.className»::createInstance(mesh());

		// initialization of other attributes
		«FOR v : variables.filter[!(constExpr || option)]»
			«val resizeDims = TypeContentProvider.getResizeDims(v.type)»
			«IF !resizeDims.empty»
				«v.codeName».resize(«FOR s : resizeDims SEPARATOR ', '»«s»«ENDFOR»);
			«ELSEIF v.defaultValue !== null»
				«v.codeName» = «ExpressionContentProvider.getContent(v.defaultValue)»;
			«ENDIF»
		«ENDFOR»
		«IF irRoot.initNodeCoordVariable !== irRoot.nodeCoordVariable»

			// Copy node coordinates
			ENUMERATE_NODE(inode, allNodes())
			{
				«irRoot.initNodeCoordVariable.codeName»[inode][0] = «irRoot.nodeCoordVariable.codeName»[inode][0];
				«irRoot.initNodeCoordVariable.codeName»[inode][1] = «irRoot.nodeCoordVariable.codeName»[inode][1];
			}
		«ENDIF»
		«val ts = irRoot.timeStepVariable»
		«IF ts.constExpr || ts.option»

			// constant time step
			m_global_deltat = «ts.codeName»;
		«ENDIF»
		«FOR p : externalProviders»
			«val optionName = StringExtensions.separateWithUpperCase(p.extensionName)»
			if (options()->«optionName».isPresent())
				«ArcaneUtils.toAttributeName(p.instanceName)».jsonInit(options()->«optionName».value().localstr());
		«ENDFOR»

		// calling jobs
		«FOR c : irRoot.main.calls.filter[!mainTimeLoop]»
			«ArcaneUtils.getCallName(c)»(); // @«c.at»
		«ENDFOR»
		«IF ArcaneUtils.getComputeLoopEntryPointJobs(it).empty»

		// No compute loop entry point: end of computation triggered to avoid infinite loop in tests
		subDomain()->timeLoopMng()->stopComputeLoop(true);
		«ENDIF»
	}
	«ENDIF»

	«FOR j : jobs»
		«JobContentProvider.getDefinitionContent(j)»

	«ENDFOR»
	«IF ArcaneUtils.isArcaneModule(it)»
	ARCANE_REGISTER_MODULE_«name.toUpperCase»(«className»);
	«ELSE»
	ARCANE_REGISTER_SERVICE_«name.toUpperCase»(«name.toFirstUpper», «className»);
	«ENDIF»
	'''

	/** The main time loop job is represented by the compute entry point */
	private static def boolean isMainTimeLoop(Job j)
	{
		j instanceof ExecuteTimeLoopJob && JobCallerExtensions.isMain(j.caller)
	}
}