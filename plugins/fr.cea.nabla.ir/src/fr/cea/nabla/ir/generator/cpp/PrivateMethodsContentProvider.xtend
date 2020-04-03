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

import fr.cea.nabla.ir.ir.Function
import fr.cea.nabla.ir.ir.IrModule
import org.eclipse.xtend.lib.annotations.Data

import static extension fr.cea.nabla.ir.Utils.*

@Data
class PrivateMethodsContentProvider 
{
	protected val extension JobContentProvider
	protected val extension FunctionContentProvider

	def getContentFor(IrModule it)
	'''
		«FOR j : jobs.sortByAtAndName SEPARATOR '\n'»
			«j.content»
		«ENDFOR»			
		«FOR f : functions.filter(Function).filter[body !== null]»

			«f.content»
		«ENDFOR»
	'''
}

@Data
class KokkosTeamThreadPrivateMethodsContentProvider extends PrivateMethodsContentProvider
{
	override getContentFor(IrModule it)
	'''
		/**
		 * Utility function to get work load for each team of threads
		 * In  : thread and number of element to use for computation
		 * Out : pair of indexes, 1st one for start of chunk, 2nd one for size of chunk
		 */
		const std::pair<size_t, size_t> computeTeamWorkRange(const member_type& thread, const size_t& nb_elmt) noexcept
		{
			/*
			if (nb_elmt % thread.team_size())
			{
				std::cerr << "[ERROR] nb of elmt (" << nb_elmt << ") not multiple of nb of thread per team ("
			              << thread.team_size() << ")" << std::endl;
				std::terminate();
			}
			*/
			// Size
			size_t team_chunk(std::floor(nb_elmt / thread.league_size()));
			// Offset
			const size_t team_offset(thread.league_rank() * team_chunk);
			// Last team get remaining work
			if (thread.league_rank() == thread.league_size() - 1)
			{
				size_t left_over(nb_elmt - (team_chunk * thread.league_size()));
				team_chunk += left_over;
			}
			return std::pair<size_t, size_t>(team_offset, team_chunk);
		}

		«super.getContentFor(it)»
	'''
}