/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.cpp.backends

import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.IrRoot
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.Data

import static extension fr.cea.nabla.ir.IrModuleExtensions.*
import static extension fr.cea.nabla.ir.generator.Utils.*

class TraceContentProvider
{
	@Accessors String maxIterationsVarName
	@Accessors String stopTimeVarName

	protected def getHwlocTraceContent()
	'''
		std::cout << "[" << __GREEN__ << "TOPOLOGY" << __RESET__ << "]  HWLOC unavailable cannot get topological informations" << std::endl;
	'''

	def getBeginOfSimuTrace(IrModule it)
	'''
		std::cout << "\n" << __BLUE_BKG__ << __YELLOW__ << __BOLD__ <<"\tStarting «irRoot.name» ..." << __RESET__ << "\n\n";

		«hwlocTraceContent»

		«IF irRoot.postProcessing === null»
		std::cout << "[" << __GREEN__ << "OUTPUT" << __RESET__ << "]    " << __BOLD__ << "Disabled" << __RESET__ << std::endl;
		«ELSE»
		if (!writer.isDisabled())
			std::cout << "[" << __GREEN__ << "OUTPUT" << __RESET__ << "]    VTK files stored in " << __BOLD__ << writer.outputDirectory() << __RESET__ << " directory" << std::endl;
		else
			std::cout << "[" << __GREEN__ << "OUTPUT" << __RESET__ << "]    " << __BOLD__ << "Disabled" << __RESET__ << std::endl;
		«ENDIF»
	'''

	def getBeginOfLoopTrace(IrModule it, String iterationVarName)
	'''
		if («iterationVarName»!=1)
			std::cout << "[" << __CYAN__ << __BOLD__ << setw(3) << «iterationVarName» << __RESET__ "] t = " << __BOLD__
				<< setiosflags(std::ios::scientific) << setprecision(8) << setw(16) << «irRoot.currentTimeVariable.codeName» << __RESET__;
	'''

	def getEndOfLoopTrace(IrModule it, String iterationVarName, boolean hasWriter)
	'''
		«val maxIterationsVar = getVariableByName(maxIterationsVarName)»
		«val stopTimeVar = getVariableByName(stopTimeVarName)»
		«val ir = irRoot»
		// Timers display
		«IF hasWriter»
		if (!writer.isDisabled())
			std::cout << " {CPU: " << __BLUE__ << cpuTimer.print(true) << __RESET__ ", IO: " << __BLUE__ << ioTimer.print(true) << __RESET__ "} ";
		else
		«ENDIF»
			std::cout << " {CPU: " << __BLUE__ << cpuTimer.print(true) << __RESET__ ", IO: " << __RED__ << "none" << __RESET__ << "} ";

		// Progress
		«IF maxIterationsVar !== null && stopTimeVarName !== null»
		std::cout << progress_bar(«iterationVarName», «maxIterationsVar.codeName», «ir.currentTimeVariable.codeName», «stopTimeVar.codeName», 25);
		«ENDIF»
		std::cout << __BOLD__ << __CYAN__ << Timer::print(
			eta(«iterationVarName», «maxIterationsVar.codeName», «ir.currentTimeVariable.codeName», «stopTimeVar.codeName», «ir.timeStepVariable.codeName», globalTimer), true)
			<< __RESET__ << "\r";
		std::cout.flush();
	'''

	def getEndOfSimuTrace(IrRoot it, boolean isLinearAlgebra)
	'''
		std::cout << "\nFinal time = " << «currentTimeVariable.codeName» << endl;
		std::cout << __YELLOW__ << "\n\tDone ! Took " << __MAGENTA__ << __BOLD__ << globalTimer.print() << __RESET__ << std::endl;
		«IF isLinearAlgebra»std::cout << "[CG] average iteration: " << options.linearAlgebra.m_info.m_nb_it / options.linearAlgebra.m_info.m_nb_call << std::endl;«ENDIF»
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
