/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.cpp

import fr.cea.nabla.ir.annotations.NabLabFileAnnotation
import fr.cea.nabla.ir.ir.Affectation
import fr.cea.nabla.ir.ir.ArgOrVar
import fr.cea.nabla.ir.ir.Function
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.ir.Job
import java.util.List
import java.util.Map

class PythonModuleGenerator
{
	def static getPythonModuleContent(IrRoot ir)
	{
		val allJobs = ir.eAllContents.filter[o|o instanceof Job].map[o|o as Job].toList
		val allAssigns = ir.eAllContents.filter[o|
			o instanceof Affectation &&
			// If affectation targets a user-defined (as opposed to derived) variable
			NabLabFileAnnotation.tryToGet((o as Affectation).left.target) !== null].map[o|o as Affectation].toList
		val Map<Object, List<ArgOrVar>> allWrites = newHashMap
		allAssigns.forEach[a|
			val target = a.left.target
			var c = a.eContainer
			var continue = true
			while (c !== null && continue)
			{
				if (c instanceof Function || c instanceof Job || c instanceof IrModule)
				{
					allWrites.computeIfAbsent(c, [newArrayList]).add(target)
					continue = false
				}
				else
				{
					c = c.eContainer
				}
			}
		]

		return
			'''
			«FOR j : allJobs SEPARATOR '\n'»
				class «j.name.toFirstUpper»():
				    pass
				    
				    class Before():
				        pass
				    
				    class After():
				        pass
				    
				    «val jobWrites = allWrites.getOrDefault(j, emptyList).map[name.toFirstUpper].toSet»
				    «FOR w : jobWrites»
				    	
				    	class «w»():
				    	    pass
				    	    
				    	    class Before():
				    	        pass
				    	    
				    	    class After():
				    	        pass
				    «ENDFOR»
			«ENDFOR»
			
			«val allAssignStrings = allAssigns.map[a|a.left.target].filter[target|target.eContainer instanceof IrModule]
					.map[name.toFirstUpper].toSet»
			«FOR a : allAssignStrings SEPARATOR '\n'»
				class «a»():
				    pass
				        
				    class Before():
				        pass
				    
				    class After():
				        pass
			«ENDFOR»
		'''
	}
}
