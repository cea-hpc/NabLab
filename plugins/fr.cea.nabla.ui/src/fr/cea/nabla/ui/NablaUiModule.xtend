/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ui

import com.google.inject.Binder
import fr.cea.nabla.NablaEncodingProvider
import fr.cea.nabla.ui.hovers.NablaEObjectHoverProvider
import fr.cea.nabla.ui.syntaxcoloring.NablaHighlightingConfiguration
import fr.cea.nabla.ui.syntaxcoloring.NablaSemanticHighlightingCalculator
import org.eclipse.xtend.lib.annotations.FinalFieldsConstructor
import org.eclipse.xtext.ide.editor.syntaxcoloring.ISemanticHighlightingCalculator
import org.eclipse.xtext.parser.IEncodingProvider
import org.eclipse.xtext.service.DispatchingProvider
import org.eclipse.xtext.ui.editor.XtextEditor
import org.eclipse.xtext.ui.editor.hover.IEObjectHoverProvider
import org.eclipse.xtext.ui.editor.syntaxcoloring.IHighlightingConfiguration
import org.eclipse.xtext.ui.editor.autoedit.AbstractEditStrategyProvider

/**
 * Use this class to register components to be used within the Eclipse IDE.
 */
@FinalFieldsConstructor
class NablaUiModule extends AbstractNablaUiModule
{
	def Class<? extends IHighlightingConfiguration> bindIHighlightingConfiguration()
	{
		typeof(NablaHighlightingConfiguration)
	}

	def Class<? extends ISemanticHighlightingCalculator> bindISemanticHighlightingCalculator()
	{
		typeof(NablaSemanticHighlightingCalculator)
	}

	def Class<? extends XtextEditor> bindXtextEditor() 
	{
		typeof(NablaDslEditor)
	}

	def Class<? extends IEObjectHoverProvider> bindIEObjectHoverProvider()
	{
		typeof(NablaEObjectHoverProvider)
	}

	override Class<? extends AbstractEditStrategyProvider> bindAbstractEditStrategyProvider()
	{
		typeof(NablaAutoEditStrategyProvider)
	}

	override configureUiEncodingProvider(Binder binder)
	{
		binder.bind(typeof(IEncodingProvider))
		.annotatedWith(typeof(DispatchingProvider.Ui))
		.to(typeof(NablaEncodingProvider))
	}
}
