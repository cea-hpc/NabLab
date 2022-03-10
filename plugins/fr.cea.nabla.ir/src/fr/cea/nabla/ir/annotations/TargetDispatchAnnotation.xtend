/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.annotations

import fr.cea.nabla.ir.ir.IrAnnotable
import fr.cea.nabla.ir.ir.IrAnnotation
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.Job
import org.eclipse.xtend.lib.annotations.Accessors

enum TargetType { CPU, GPU }

/*
 * Commentaire pour Maël
 * La méthode get est publique sur NabLabFileAnnotation car ce type d'annotation
 * est positionné sur n'importe quel élément de modèle. Dans ton cas, mieux vaut la laisser
 * en privé et créer des méthodes pour chaque type ayant besoin d'être annoté.
 * De cette manière, ce sera plus facile de passer des annotations à un type statique sur l'IR :
 * on saura immédiatement quelles classes sont concernées.
 * J'ai fait la méthode get pour le Job, à titre d'exemple.
 */
class TargetDispatchAnnotation
{
	static val ANNOTATION_SOURCE = TargetDispatchAnnotation.name
	static val ANNOTATION_TARGET_TYPE_DETAIL = "target-type"

	@Accessors val IrAnnotation irAnnotation

	static def get(Job object) { _get(object) }

	static def create(TargetType targetType)
	{
		val o = IrFactory::eINSTANCE.createIrAnnotation => 
		[
			source = ANNOTATION_SOURCE
			details.put(ANNOTATION_TARGET_TYPE_DETAIL, targetType.toString)
		]
		return new TargetDispatchAnnotation(o)
	}

	def getTargetType()
	{
		TargetType.valueOf(irAnnotation.details.get(ANNOTATION_TARGET_TYPE_DETAIL))
	}

	private static def _get(IrAnnotable object)
	{
		val o = object.annotations.findFirst[x | x.source == ANNOTATION_SOURCE]
		if (o === null) null
		else new TargetDispatchAnnotation(o)
	}

	private new(IrAnnotation irAnnotation)
	{
		this.irAnnotation = irAnnotation
	}
}