/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir

import com.google.gson.Gson
import com.google.gson.JsonObject
import fr.cea.nabla.ir.ir.Affectation
import fr.cea.nabla.ir.ir.ArgOrVarRef
import fr.cea.nabla.ir.ir.IrPackage
import fr.cea.nabla.ir.ir.Variable
import java.io.PrintWriter
import java.io.StringWriter
import org.eclipse.emf.ecore.EObject

import static extension fr.cea.nabla.ir.ArgOrVarExtensions.isGlobal

class IrUtils
{
	public static val NRepository = '.nablab'
	public static val LastDumpOptionName = "lastDump"
	public static val OutputPeriodOptionName = "outputPeriod"
	public static val OutputPathNameAndValue = new Pair<String, String>("outputPath", "output")
	public static val NonRegressionNameAndValue = new Pair<String, String>("nonRegression", '""')
	public static val NonRegressionToleranceNameAndValue = new Pair<String, String>("nonRegressionTolerance", '""')
	static enum NonRegressionValues { CreateReference, CompareToReference }

	/* Usefull functions from EcoreUtil2 (no dependency to org.eclipse.xtext in IR) */
	static def <T extends EObject> T getContainerOfType(/* @Nullable */ EObject ele, /* @NonNull */ Class<T> type)
	{
		for (var e = ele; e !== null; e = e.eContainer())
			if (type.isInstance(e))
				return type.cast(e);

		return null;
	}

	static def getUtfExponent(int x)
	{
		val xstring = x.toString
		var utfExponent = ''
		for (xchar : xstring.toCharArray)
		{
			val xValue = Character.getNumericValue(xchar)
			utfExponent += switch xValue
			{
				case 2: '\u00B2'
				case 3: '\u00B3'
				case 4: '\u2074'
				case 5: '\u2075'
				case 6: '\u2076'
				case 7: '\u2077'
				case 8: '\u2078'
				case 9: '\u2079'
				default: ''
			}
		}
		return utfExponent
	}

	static def String getStackTrace(Exception e)
	{
		val result = new StringWriter()
		val printWriter = new PrintWriter(result)
		e.printStackTrace(printWriter)
		return result.toString()
	}

	static def addNonRegressionTagsToJsonFile(String moduleName, String jsonContent, String value, double tolerance)
	{
		val gson = new Gson
		val jsonObject = gson.fromJson(jsonContent, JsonObject)
		// Read options in Json
		if (!jsonObject.has(moduleName.toFirstLower)) throw new RuntimeException("Options block is missing in Json data file")
		val jsonOptions = jsonObject.get(moduleName.toFirstLower).asJsonObject
		val nrName = NonRegressionNameAndValue.key
		jsonOptions.addProperty(nrName, value)
		val nrToleranceName = NonRegressionToleranceNameAndValue.key
		jsonOptions.addProperty(nrToleranceName, tolerance)
		return gson.toJson(jsonObject)
	}

	static def getInVars(EObject it)
	{
		val allReferencedVars = eAllContents.filter(ArgOrVarRef).filter[x|x.eContainingFeature != IrPackage::eINSTANCE.affectation_Left].map[target]
		allReferencedVars.filter(Variable).filter[global].toSet
	}

	static def getOutVars(EObject it)
	{
		eAllContents.filter(Affectation).map[left.target].filter(Variable).filter[global].toSet
	}
}
