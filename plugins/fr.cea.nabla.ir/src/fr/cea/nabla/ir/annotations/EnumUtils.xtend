/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.annotations

class EnumUtils
{
	static def FuseRegions(RegionType r1, RegionType r2)
	{
		(r1 == r2) ? r1 : RegionType.BOTH
	}

	static def FuseRegions(Iterable<RegionType> regions)
	{
		// NOTE: If no region for a variable, it is considered to be "BOTH" is
		// it's only the case for things that are initialized at the beginning
		// of the program.
		if (regions.size == 0)
			return RegionType.BOTH
		regions.reduce[ r1, r2 | FuseRegions(r1, r2) ]
	}

	static def RegionFromTarget(TargetType target)
	{
		switch target
		{
			case CPU: return RegionType.CPU
			case GPU: return RegionType.GPU
		}
	}

	static def TargetFromRegion(RegionType region)
	{
		switch region
		{
			case CPU: return TargetType.CPU
			case GPU: return TargetType.GPU
			case BOTH: throw new Exception("Unsopported cast RegionType.BOTH to TargetType")
		}
	}
}