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

import fr.cea.nabla.nablagen.AdditionalModule
import fr.cea.nabla.nablagen.CppKokkos
import fr.cea.nabla.nablagen.CppKokkosTeamThread
import fr.cea.nabla.nablagen.CppOpenMP
import fr.cea.nabla.nablagen.CppSequential
import fr.cea.nabla.nablagen.CppStlThread
import fr.cea.nabla.nablagen.Java
import fr.cea.nabla.nablagen.MainModule
import fr.cea.nabla.nablagen.NablagenModule
import fr.cea.nabla.nablagen.Target
import org.eclipse.xtext.ui.editor.outline.impl.DefaultOutlineTreeProvider

/**
 * Customization of the default outline structure.
 *
 * See https://www.eclipse.org/Xtext/documentation/310_eclipse_support.html#outline
 */
class NablagenOutlineTreeProvider extends DefaultOutlineTreeProvider
{
	def _image(NablagenModule it) { null }

	def _text(MainModule it) { "Main module: " + type + " " + name}
	def _text(AdditionalModule it) { "Additional module: " + type + " " + name}

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
