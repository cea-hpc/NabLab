/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ui.outline

import fr.cea.nabla.nablagen.LevelDB
import fr.cea.nabla.nablagen.NablagenModule
import fr.cea.nabla.nablagen.NablagenRoot
import fr.cea.nabla.nablagen.OutputVar
import fr.cea.nabla.nablagen.Target
import fr.cea.nabla.ui.NablaUiUtils
import org.eclipse.xtext.ui.editor.outline.impl.DefaultOutlineTreeProvider
import fr.cea.nabla.nablagen.NablagenProvider

/**
 * Customization of the default outline structure.
 *
 * See https://www.eclipse.org/Xtext/documentation/310_eclipse_support.html#outline
 */
class NablagenOutlineTreeProvider extends DefaultOutlineTreeProvider
{
	def _image(NablagenRoot it)
	{
		NablaUiUtils.createImage('icons/Nablagen.gif')
	}

	def _text(NablagenRoot it)
	{
		'Generation file "' + eResource.URI.lastSegment + '"'
	}

	def _image(NablagenProvider it) { null }
	def _isLeaf(NablagenProvider it) { true }
	def _text(NablagenProvider it) { name + " : " + extension?.name }

	def _isLeaf(NablagenModule it) { true }
	def _text(NablagenModule it) { name }

	def _image(OutputVar it) { null }
	def _text(OutputVar it) { varName }

	def _isLeaf(LevelDB it) { true }
	def _text(LevelDB it) { 'LevelDB activated' }

	def _isLeaf(Target it) { true }

	def _text(Target it)
	{
		switch type
		{
			case JAVA: if (interpreter) 'Interpreter' else 'Multi-thread Java'
			case KOKKOS: 'Kokkos C++'
			case KOKKOS_TEAM_THREAD: 'Kokkos C++ with teams of threads'
			case OPEN_MP: 'OpenMP C++'
			case CPP_SEQUENTIAL: 'Sequential C++'
			case STL_THREAD: 'Multi-thread STL C++'
			case ARCANE_ACCELERATOR: 'Arcane Accelerator API'
			case ARCANE_SEQUENTIAL: 'Arcane Sequential API'
			case ARCANE_THREAD: 'Arcane Thread API'
			default: 'Unknown target'
		}
	}

	def _image(Target it)
	{
		switch type
		{
			case JAVA: NablaUiUtils.createImage('icons/Java.gif')
			case KOKKOS: NablaUiUtils.createImage('icons/Kokkos.gif')
			case KOKKOS_TEAM_THREAD: NablaUiUtils.createImage('icons/KokkosTeamThread.gif')
			case OPEN_MP: NablaUiUtils.createImage('icons/OpenMP.gif')
			case CPP_SEQUENTIAL: NablaUiUtils.createImage('icons/CppSequential.gif')
			case STL_THREAD: NablaUiUtils.createImage('icons/StlThread.gif')
			case ARCANE_ACCELERATOR: NablaUiUtils.createImage('icons/Cuda.gif')
			case ARCANE_SEQUENTIAL: NablaUiUtils.createImage('icons/CppSequential.gif')
			case ARCANE_THREAD: NablaUiUtils.createImage('icons/StlThread.gif')
			default: null
		}
	}
}
