package fr.cea.nabla.ir

import fr.cea.nabla.ir.ir.IrModule

class IrModuleExtensions
{
	def getJobByName(IrModule it, String jobName)
	{
		jobs.findFirst[j | j.name == jobName]
	}
}
