package fr.cea.nabla.ir.annotations

import fr.cea.nabla.ir.ir.IrAnnotable
import fr.cea.nabla.ir.ir.IrAnnotation
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.Variable
import org.eclipse.xtend.lib.annotations.Accessors

/* VariableRegionAnnotation: Small annotation to get the regions where a
 * vairable is written (should only be one region...) and the regions where
 * that variable is used.
 */
class VariableRegionAnnotation
{
	static val ANNOTATION_SOURCE = VariableRegionAnnotation.name
	static val ANNOTATION_READ_REGION = "read-region"
	static val ANNOTATION_WRITE_REGION = "write-region"
	
	@Accessors val IrAnnotation irAnnotation
	
	static def get(Variable object) { _get(object) }
	
	// Create an annotation for a variable
	static def create(RegionType read, RegionType write)
	{
		val o = IrFactory::eINSTANCE.createIrAnnotation =>
		[
			// For now every computation goes on CPU
			source = ANNOTATION_SOURCE
			details.put(ANNOTATION_READ_REGION, read.toString)
			details.put(ANNOTATION_WRITE_REGION, write.toString)
		]
		return new VariableRegionAnnotation(o)
	}
	
	// Fuse two computed VariableRegionAnnotation for the same variable
	static def fuse(VariableRegionAnnotation first, VariableRegionAnnotation second)
	{
		val read = fuse(first.readRegion, second.readRegion)
		val write = fuse(first.writeRegion, second.writeRegion)
		return create(read, write)
	}
	
	def isReadGPU()  { isRegion(ANNOTATION_READ_REGION,  RegionType.GPU) }
	def isReadCPU()  { isRegion(ANNOTATION_READ_REGION,  RegionType.CPU) }
	def isWriteGPU() { isRegion(ANNOTATION_WRITE_REGION, RegionType.GPU) }
	def isWriteCPU() { isRegion(ANNOTATION_WRITE_REGION, RegionType.CPU) }
	
	def getReadRegion()
	{
		RegionType.valueOf(irAnnotation.details.get(ANNOTATION_READ_REGION))
	}

	def getWriteRegion()
	{
		RegionType.valueOf(irAnnotation.details.get(ANNOTATION_WRITE_REGION))
	}
	
	private static def fuse(RegionType first, RegionType second)
	{
		return first == second ? first : RegionType.BOTH;
	}

	private def boolean isRegion(String whichReadWrite, RegionType type)
	{
		val region = RegionType.valueOf(irAnnotation.details.get(whichReadWrite))
		region == type || region == RegionType.BOTH
	}
	
	private static def _get(IrAnnotable object)
	{
		val o = object.annotations.findFirst[ x | x.source == ANNOTATION_SOURCE ]
		return o === null ? null : new VariableRegionAnnotation(o)
	}
	
	private new(IrAnnotation irAnnotation)
	{
		this.irAnnotation = irAnnotation
	}
}