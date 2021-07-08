/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.arcane

import fr.cea.nabla.ir.ir.IrRoot

class MainContentProvider
{
	static def getContent(IrRoot it)
	'''
	#include <arcane/launcher/ArcaneLauncher.h>

	using namespace Arcane;

	int
	main(int argc,char* argv[])
	{
		ArcaneLauncher::init(CommandLineArguments(&argc,&argv));
		auto& app_build_info = ArcaneLauncher::applicationBuildInfo();
		app_build_info.setCodeName("«name»");
		app_build_info.setCodeVersion(VersionInfo(1,0,0));
		return ArcaneLauncher::run();
	}
	'''
}