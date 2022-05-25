/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.json

import fr.cea.nabla.ir.ir.IrRoot

class IrRootContentProvider
{
	static def getJsonFileContent(IrRoot rootModel, boolean hasLevelDB)
	'''
		{
			"_comment": "GENERATED FILE - DO NOT OVERWRITE",
			«FOR irModule : rootModel.modules»
				"«irModule.name.toFirstLower»":
				{
					«FOR jsonValue : IrModuleContentProvider.getJsonValues(irModule, hasLevelDB) SEPARATOR ","»
						"«jsonValue.key»":«jsonValue.value»
					«ENDFOR»
				},
			«ENDFOR»
			"mesh":
			{
			}
		}
	'''
}
