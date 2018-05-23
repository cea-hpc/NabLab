package fr.cea.nabla.typing

import fr.cea.nabla.nabla.BasicType

class BasicTypeProvider 
{
	public static val INT = new NablaType(BasicType::INT, 0)
	public static val REAL = new NablaType(BasicType::REAL, 0)
	public static val REAL2 = new NablaType(BasicType::REAL2, 0)
	public static val REAL2X2 = new NablaType(BasicType::REAL2X2, 0)
	public static val REAL3 = new NablaType(BasicType::REAL3, 0)
	public static val REAL3X3 = new NablaType(BasicType::REAL3X3, 0)
	public static val BOOL = new NablaType(BasicType::BOOL, 0)
	
	def NablaType getTypeFor(BasicType it) 
	{
		switch it
		{
			case BOOL: return BOOL
			case INT: return INT
			case REAL: return REAL
			case REAL2: return REAL2
			case REAL3: return REAL3
			case REAL2X2: return REAL2X2
			case REAL3X3: return REAL3X3
		}
	}	
}