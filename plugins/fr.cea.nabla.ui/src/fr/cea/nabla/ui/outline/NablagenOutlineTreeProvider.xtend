/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ui.outline

import fr.cea.nabla.nablagen.CppKokkos
import fr.cea.nabla.nablagen.CppKokkosTeamThread
import fr.cea.nabla.nablagen.CppOpenMP
import fr.cea.nabla.nablagen.CppSequential
import fr.cea.nabla.nablagen.CppStlThread
import fr.cea.nabla.nablagen.Java
import fr.cea.nabla.nablagen.LevelDB
import fr.cea.nabla.nablagen.NablagenModule
import fr.cea.nabla.nablagen.NablagenRoot
import fr.cea.nabla.nablagen.OutputVar
import fr.cea.nabla.nablagen.Target
import org.eclipse.xtext.ui.editor.outline.impl.DefaultOutlineTreeProvider

/**
 * Customization of the default outline structure.
 *
 * See https://www.eclipse.org/Xtext/documentation/310_eclipse_support.html#outline
 */
class NablagenOutlineTreeProvider extends DefaultOutlineTreeProvider
{
	def _text(NablagenRoot it)
	{
		'Generation options "' + eResource.URI.lastSegment + '"'
	}

	def _isLeaf(NablagenModule it) { true }
	def _text(NablagenModule it) { name }

	def _image(OutputVar it) { null }
	def _text(OutputVar it) { varName }

	def _isLeaf(LevelDB it) { true }
	def _text(LevelDB it) { 'LevelDB activated' }

	def _isLeaf(Target it) { true }
	def _text(Target it)
	{
		switch it
		{
			Java: 'Multi-thread Java'
			CppKokkos: 'Kokkos C++'
			CppKokkosTeamThread: 'Kokkos C++ with teams of threads'
			CppOpenMP: 'OpenMP C++'
			CppSequential: 'Sequential C++'
			CppStlThread: 'Multi-thread STL C++'
		}
	}
}
