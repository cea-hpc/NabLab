/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla

import com.google.inject.Binder
import org.eclipse.xtext.naming.IQualifiedNameProvider
import org.eclipse.xtext.parser.IEncodingProvider
import org.eclipse.xtext.service.DispatchingProvider

/**
 * Use this class to register components to be used at runtime / without the Equinox extension registry.
 */
class NablaRuntimeModule extends AbstractNablaRuntimeModule 
{
	override configureRuntimeEncodingProvider(Binder binder)
	{
		binder.bind(typeof(IEncodingProvider))
		.annotatedWith(typeof(DispatchingProvider.Runtime))
		.to(typeof(NablaEncodingProvider))
	}
	
	override Class<? extends IQualifiedNameProvider> bindIQualifiedNameProvider() 
	{
		return NablaQualifiedNameProvider
	}
}
