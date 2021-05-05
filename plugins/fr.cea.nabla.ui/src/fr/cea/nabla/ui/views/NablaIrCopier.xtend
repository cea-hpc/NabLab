/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
 package fr.cea.nabla.ui.views

import org.eclipse.emf.ecore.EAttribute
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.emf.ecore.util.EcoreUtil.Copier
import java.util.Collection

class NablaIrCopier extends Copier {

	def EObject nablaIrCopy(EObject irRootSource, EObject irRootTarget)
	{
		if (irRootSource === null)
		{
			return null
		} else
		{
			var EObject copyEObject = irRootTarget
			if (copyEObject !== null)
			{
				put(irRootSource, copyEObject)
				var EClass eClass = irRootSource.eClass()
				for (var int i = 0, var int size = eClass.getFeatureCount(); i < size; {
					i = i + 1
				})
				{
					var EStructuralFeature eStructuralFeature = eClass.getEStructuralFeature(i)
					if (eStructuralFeature.isChangeable() && !eStructuralFeature.isDerived())
					{
						if (eStructuralFeature instanceof EAttribute)
						{
							copyAttribute((eStructuralFeature), irRootSource, copyEObject)
						} 
						else
						{
							var EReference eReference = (eStructuralFeature as EReference)
							if (eReference.isContainment())
							{
								var refValue = irRootTarget.eGet(eReference)
								if (refValue instanceof Collection)
								{
									refValue.clear
								}
								copyContainment(eReference, irRootSource, copyEObject)
							}
						}
					}
				}
				copyProxyURI(irRootSource, copyEObject)
			}
			return copyEObject
		}
	}
}
