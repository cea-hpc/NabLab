/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.generator

import fr.cea.nabla.generator.NablaGeneratorMessageDispatcher.MessageType
import fr.cea.nabla.nabla.NablaExtension
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.NablaRoot
import fr.cea.nabla.nablagen.TargetType

class NablagenFileGenerator extends StandaloneGeneratorBase
{
	public static val CppGenFoldersByTarget = #{
		TargetType::CPP_SEQUENTIAL -> "sequential",
		TargetType::STL_THREAD -> "stl-thread",
		TargetType::OPEN_MP -> "openmp",
		TargetType::KOKKOS -> "kokkos",
		TargetType::KOKKOS_TEAM_THREAD -> "kokkos-team"
	}

	public static val ArcaneGenFoldersByTarget = #{
		TargetType::ARCANE_ACCELERATOR -> "accelerator",
		TargetType::ARCANE_SEQUENTIAL -> "sequential",
		TargetType::ARCANE_THREAD -> "thread"
	}

	def generate(NablaRoot moduleOrExtension, String genDir, String projectName)
	{
		val fsa = getConfiguredFileSystemAccess(genDir, false)
		var fileName = moduleOrExtension.name + ".ngen"
		// generated only once
		if (fsa.isFile(fileName))
		{
			dispatcher.post(MessageType::Exec, "    File already exists, no overwite: " + fileName)
		}
		else
		{
			dispatcher.post(MessageType::Exec, "    Generating: " + fileName)
			switch moduleOrExtension
			{
				NablaModule: fsa.generateFile(fileName, getApplicationContent(moduleOrExtension.name, projectName))
				NablaExtension: fsa.generateFile(fileName, getProviderContent(moduleOrExtension.name, projectName))
			}
		}
	}

	static def getProviderContent(String nablaExtensionName, String projectName)
	'''
	/*
	 * This file contains the providers for the «nablaExtensionName» NabLab extension.
	 * The list is ordered: the first Provider is the default one for the specified target.
	 * For example, if you entered two «TargetType::STL_THREAD» Provider instances,
	 * the first one in the following list will be the default one during NabLab
	 * code generation for the target «TargetType::STL_THREAD».
	 */

	/*
	 * C++ Extension Provider
	 */
	Provider «nablaExtensionName»Cpp : «nablaExtensionName»
	{
		target = «TargetType::CPP_SEQUENTIAL.literal»;
		// compatibleTargets can be added here
		outputPath = "/«projectName»/src-cpp/«CppGenFoldersByTarget.get(TargetType::CPP_SEQUENTIAL)»";
	}

	/* 
	 * Java Extension Provider
	 */
	Provider «nablaExtensionName»Java : «nablaExtensionName»
	{
		target = «TargetType::JAVA.literal»;
		// compatibleTargets can be added here
		outputPath = "/«projectName»/src-java";
	}
	'''

	static def getApplicationContent(String nablaModuleName, String projectName)
	'''
		Application «nablaModuleName»;

		MainModule «nablaModuleName» «nablaModuleName.toFirstLower»
		{
			nodeCoord = X;
			time = t;
			timeStep = delta_t;
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
			outputPath = "/«projectName»/src-gen-java";
		}

		CppSequential
		{
			outputPath = "/«projectName»/src-gen-cpp/«CppGenFoldersByTarget.get(TargetType::CPP_SEQUENTIAL)»";
			CMAKE_CXX_COMPILER = "/usr/bin/g++";
		}

		StlThread
		{
			outputPath = "/«projectName»/src-gen-cpp/«CppGenFoldersByTarget.get(TargetType::STL_THREAD)»";
			CMAKE_CXX_COMPILER = "/usr/bin/g++";
		}

		OpenMP
		{
			outputPath = "/«projectName»/src-gen-cpp/«CppGenFoldersByTarget.get(TargetType::OPEN_MP)»";
			CMAKE_CXX_COMPILER = "/usr/bin/g++";
		}

		Kokkos
		{
			outputPath = "/«projectName»/src-gen-cpp/«CppGenFoldersByTarget.get(TargetType::KOKKOS)»";
			CMAKE_CXX_COMPILER = "/usr/bin/g++";
			Kokkos_ROOT = "$ENV{HOME}/kokkos/install";
		}

		KokkosTeamThread
		{
			outputPath = "/«projectName»/src-gen-cpp/«CppGenFoldersByTarget.get(TargetType::KOKKOS_TEAM_THREAD)»";
			CMAKE_CXX_COMPILER = "/usr/bin/g++";
			Kokkos_ROOT = "$ENV{HOME}/kokkos/install";
		}

		ArcaneSequential
		{
			outputPath = "/«projectName»/src-gen-arcane/«ArcaneGenFoldersByTarget.get(TargetType::ARCANE_SEQUENTIAL)»";
			CMAKE_CXX_COMPILER = "/usr/bin/g++";
			Arcane_ROOT = "$ENV{HOME}/arcane/install";
		}

		ArcaneThread
		{
			outputPath = "/«projectName»/src-gen-arcane/«ArcaneGenFoldersByTarget.get(TargetType::ARCANE_THREAD)»";
			CMAKE_CXX_COMPILER = "/usr/bin/g++";
			Arcane_ROOT = "$ENV{HOME}/arcane/install";
		}

		ArcaneAccelerator
		{
			outputPath = "/«projectName»/src-gen-arcane/«ArcaneGenFoldersByTarget.get(TargetType::ARCANE_ACCELERATOR)»";
			CMAKE_CXX_COMPILER = "/usr/bin/g++";
			Arcane_ROOT = "$ENV{HOME}/arcane/install";
		}

		Python
		{
			outputPath = "/«projectName»/src-gen-python";
		}
	'''
}