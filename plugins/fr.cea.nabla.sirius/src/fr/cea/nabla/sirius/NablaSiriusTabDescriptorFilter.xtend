/** 
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 */
package fr.cea.nabla.sirius

import org.eclipse.eef.properties.ui.api.IEEFTabDescriptor
import org.eclipse.eef.properties.ui.api.IEEFTabDescriptorFilter

class NablaSiriusTabDescriptorFilter implements IEEFTabDescriptorFilter
{
	override boolean filter(IEEFTabDescriptor tabDescriptor)
	{
		if (tabDescriptor !== null)
		{
			val id = tabDescriptor.getId()
			if ("property.tab.style".equals(id))
			{
				return true
			}
			else if ("property.tab.AppearancePropertySection".equals(id))
			{
				return true
			}
			else if ("property.tab.DiagramPropertySection".equals(id))
			{
				return true
			}
		}
		return false
	}
}
