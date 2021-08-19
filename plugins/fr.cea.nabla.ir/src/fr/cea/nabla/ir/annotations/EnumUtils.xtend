package fr.cea.nabla.ir.annotations


class EnumUtils
{
	static def FuseRegions(RegionType r1, RegionType r2)
	{
		(r1 == r2) ? r1 : RegionType.BOTH
	}

	static def FuseRegions(Iterable<RegionType> regions)
	{
		if (regions.size == 0)
			throw new Exception("Can't reduce an empty list!")
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