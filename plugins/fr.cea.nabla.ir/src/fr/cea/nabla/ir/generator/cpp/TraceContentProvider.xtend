/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.cpp

import fr.cea.nabla.ir.ir.IrModule
import org.eclipse.xtend.lib.annotations.Data

import static extension fr.cea.nabla.ir.IrModuleExtensions.*
import static extension fr.cea.nabla.ir.generator.Utils.*

@Data
class TraceContentProvider
{
	val String maxIterationsVarName
	val String stopTimeVarName

	protected def getHwlocTraceContent()
	'''
		std::cout << "[" << __GREEN__ << "TOPOLOGY" << __RESET__ << "]  HWLOC unavailable cannot get topological informations" << std::endl;
	'''

	def getBeginOfSimuTrace(IrModule it, String simuName)
	'''
		std::cout << "\n" << __BLUE_BKG__ << __YELLOW__ << __BOLD__ <<"\tStarting «simuName» ..." << __RESET__ << "\n\n";

		«hwlocTraceContent»

		«IF postProcessingInfo === null»
		std::cout << "[" << __GREEN__ << "OUTPUT" << __RESET__ << "]    " << __BOLD__ << "Disabled" << __RESET__ << std::endl;
		«ELSE»
		if (!writer.isDisabled())
			std::cout << "[" << __GREEN__ << "OUTPUT" << __RESET__ << "]    VTK files stored in " << __BOLD__ << writer.outputDirectory() << __RESET__ << " directory" << std::endl;
		else
			std::cout << "[" << __GREEN__ << "OUTPUT" << __RESET__ << "]    " << __BOLD__ << "Disabled" << __RESET__ << std::endl;
		«ENDIF»
	'''

	def getBeginOfLoopTrace(IrModule it, String iterationVarName, boolean isTopLoop)
	'''
		«IF isTopLoop»
		if («iterationVarName»!=1)
			std::cout << "[" << __CYAN__ << __BOLD__ << setw(3) << «iterationVarName» << __RESET__ "] t = " << __BOLD__
				<< setiosflags(std::ios::scientific) << setprecision(8) << setw(16) << «timeVariable.codeName» << __RESET__;
		«ENDIF»
	'''

	def getEndOfLoopTrace(IrModule it, String iterationVarName, boolean isTopLoop, boolean hasWriter)
	'''
		«val maxIterationsVar = getVariableByName(maxIterationsVarName)»
		«val stopTimeVar = getVariableByName(stopTimeVarName)»
		«IF isTopLoop»
		// Timers display
		«IF hasWriter»
		if (!writer.isDisabled())
			std::cout << " {CPU: " << __BLUE__ << cpuTimer.print(true) << __RESET__ ", IO: " << __BLUE__ << ioTimer.print(true) << __RESET__ "} ";
		else
		«ENDIF»
			std::cout << " {CPU: " << __BLUE__ << cpuTimer.print(true) << __RESET__ ", IO: " << __RED__ << "none" << __RESET__ << "} ";

		// Progress
		std::cout << utils::progress_bar(«iterationVarName», «maxIterationsVar.codeName», «timeVariable.codeName», «stopTimeVar.codeName», 25);
		std::cout << __BOLD__ << __CYAN__ << utils::Timer::print(
			utils::eta(«iterationVarName», «maxIterationsVar.codeName», «timeVariable.codeName», «stopTimeVar.codeName», «deltatVariable.codeName», globalTimer), true)
			<< __RESET__ << "\r";
		std::cout.flush();
		«ENDIF»
	'''

	def getEndOfSimuTrace(boolean isLinearAlgebra)
	'''
		std::cout << __YELLOW__ << "\n\tDone ! Took " << __MAGENTA__ << __BOLD__ << globalTimer.print() << __RESET__ << std::endl;
		«IF isLinearAlgebra»std::cout << "[CG] average iteration: " << linearAlgebraFunctions.m_info.m_nb_it / linearAlgebraFunctions.m_info.m_nb_call << std::endl;«ENDIF»
	'''
}

@Data
class KokkosTraceContentProvider extends TraceContentProvider
{
	override getHwlocTraceContent()
	'''
		if (Kokkos::hwloc::available())
		{
			std::cout << "[" << __GREEN__ << "TOPOLOGY" << __RESET__ << "]  NUMA=" << __BOLD__ << Kokkos::hwloc::get_available_numa_count()
				<< __RESET__ << ", Cores/NUMA=" << __BOLD__ << Kokkos::hwloc::get_available_cores_per_numa()
				<< __RESET__ << ", Threads/Core=" << __BOLD__ << Kokkos::hwloc::get_available_threads_per_core() << __RESET__ << std::endl;
		}
		else
		{
			«super.hwlocTraceContent»
		}

		// std::cout << "[" << __GREEN__ << "KOKKOS" << __RESET__ << "]    " << __BOLD__ << (is_same<MyLayout,Kokkos::LayoutLeft>::value?"Left":"Right")" << __RESET__ << " layout" << std::endl;
	'''
}
