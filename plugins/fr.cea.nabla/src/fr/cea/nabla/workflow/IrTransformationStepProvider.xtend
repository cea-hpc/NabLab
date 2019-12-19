package fr.cea.nabla.workflow

import fr.cea.nabla.ir.transformers.FillJobHLTs
import fr.cea.nabla.ir.transformers.OptimizeConnectivities
import fr.cea.nabla.ir.transformers.ReplaceReductions
import fr.cea.nabla.ir.transformers.ReplaceUtf8Chars
import fr.cea.nabla.ir.transformers.TagPersistentVariables
import fr.cea.nabla.nablagen.FillHLTsComponent
import fr.cea.nabla.nablagen.OptimizeConnectivitiesComponent
import fr.cea.nabla.nablagen.ReplaceReductionsComponent
import fr.cea.nabla.nablagen.ReplaceUtfComponent
import fr.cea.nabla.nablagen.TagPersistentVariablesComponent
import java.util.ArrayList
import java.util.HashMap

class IrTransformationStepProvider 
{
	// Dispatch on Ir2IrComponent
	static def dispatch get(TagPersistentVariablesComponent it)
	{
		val outVars = new HashMap<String, String>
		dumpedVars.forEach[x | outVars.put(x.varRef.name, x.varName)]
		return new TagPersistentVariables(timeVar.name, iterationVar.name, outVars, periodValue, periodVar.name)
	}

	static def dispatch get(ReplaceUtfComponent it)
	{
		new ReplaceUtf8Chars
	}

	static def dispatch get(ReplaceReductionsComponent it)
	{
		new ReplaceReductions(replaceAllReductions)
	}

	static def dispatch get(OptimizeConnectivitiesComponent it)
	{
		val c = new ArrayList<String>
		c.addAll(connectivities.map[name])
		new OptimizeConnectivities(c)
	}

	static def dispatch get(FillHLTsComponent it)
	{
		new FillJobHLTs
	}
}