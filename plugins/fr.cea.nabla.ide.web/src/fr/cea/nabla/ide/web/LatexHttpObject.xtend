/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ide.web

package class LatexHttpObject
{
	String projectName
	String nablaModelPath
	Integer offset
	String formulaColor

	def String getProjectName()
	{
		this.projectName
	}

	def String getNablaModelPath()
	{
		this.nablaModelPath
	}

	def Integer getOffset()
	{
		this.offset
	}
	
	def String getFormulaColor()
	{
		this.formulaColor
	}
}
