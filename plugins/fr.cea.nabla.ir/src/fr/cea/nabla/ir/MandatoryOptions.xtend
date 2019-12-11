/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir

class MandatoryMeshOptions
{
	public static val X_EDGE_LENGTH = 'X_EDGE_LENGTH'
	public static val Y_EDGE_LENGTH = 'Y_EDGE_LENGTH'
	public static val X_EDGE_ELEMS = 'X_EDGE_ELEMS'
	public static val Y_EDGE_ELEMS = 'Y_EDGE_ELEMS'
	public static val Z_EDGE_ELEMS = 'Z_EDGE_ELEMS'
	
	public static val NAMES = #[X_EDGE_LENGTH, Y_EDGE_LENGTH, X_EDGE_ELEMS, Y_EDGE_ELEMS, Z_EDGE_ELEMS]
}

class MandatorySimulationOptions
{
	public static val STOP_TIME = 'option_stoptime'
	public static val MAX_ITERATIONS = 'option_max_iterations'

	public static val NAMES = #[STOP_TIME, MAX_ITERATIONS]
}

class MandatoryMeshVariables
{	
	public static val COORD = 'X'

	public static val NAMES = #[COORD]
}

class MandatorySimulationVariables
{
	public static val TIME = 't'

	public static val NAMES = #[TIME]
}