/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 *
 * Contributors:
 * 	Benoit Lelandais - initial implementation
 * 	Marie-Pierre Oudot - initial implementation
 * 	Jean-Sylvain Camier - Nabla generation support
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
	
// Avant, des commentaires sp�ciaux permettaient de mettre une documentation sur l'objet...
// Faudrait penser � refaire quelques chose pour g�n�rer une documentation
//	def Class<? extends IEObjectDocumentationProvider> bindIEObjectDocumentationProvider()
//	{
//		typeof(NablaEObjectDocumentationProvider)
//	}
	
	override configureUiEncodingProvider(Binder binder)
	{
		binder.bind(typeof(IEncodingProvider))
		.annotatedWith(typeof(DispatchingProvider.Ui))
		.to(typeof(NablaEncodingProvider))
	}
}
