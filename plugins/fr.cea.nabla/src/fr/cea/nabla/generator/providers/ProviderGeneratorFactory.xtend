/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.generator.providers

import com.google.inject.Inject
import fr.cea.nabla.generator.BackendFactory
import fr.cea.nabla.ir.generator.ProviderGenerator
import fr.cea.nabla.ir.generator.cpp.CppProviderGenerator
import fr.cea.nabla.ir.generator.java.JavaProviderGenerator
import fr.cea.nabla.nablagen.TargetType

class ProviderGeneratorFactory
{
	@Inject BackendFactory backendFactory

	def ProviderGenerator create(TargetType targetType)
	{
		switch targetType
		{
			case JAVA: new JavaProviderGenerator
			case ARCANE : throw new Exception("Not yet implemented")
			default: new CppProviderGenerator(backendFactory.getCppBackend(targetType))
		}
	}
}