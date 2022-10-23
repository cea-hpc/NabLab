/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.tests

import com.google.inject.Inject
import com.google.inject.Provider
import fr.cea.nabla.NablaStandaloneSetup
import fr.cea.nabla.NablagenStandaloneSetup
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.NablaRoot
import fr.cea.nabla.nablagen.NablagenApplication
import fr.cea.nabla.nablagen.NablagenModule
import fr.cea.nabla.nablagen.NablagenPackage
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.xtext.scoping.IScopeProvider
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.eclipse.xtext.testing.util.ParseHelper
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(XtextRunner)
@InjectWith(NablagenInjectorProvider)
class NablagenScopeProviderTest
{
	@Inject extension IScopeProvider
	@Inject extension TestUtils
	@Inject Provider<ResourceSet> resourceSetProvider

	val nablaHydroModel =
	'''
	module Hydro;

	with CartesianMesh2D.*;

	// Simulation options
	real maxTime;
	int maxIter;

	let real t = 0.0;
	let real delta_t = 1.0;
	real[2] X{nodes};
	real hv1{cells}, hv2{cells}, hv3{cells}, hv4{cells}, hv5{cells}, hv6{cells}, hv7{cells};

	iterate n while (n+1 < maxIter && t^{n+1} < maxTime);

	hj1: forall c in cells(), hv3{c} = hv2{c};
	hj2: forall c in cells(), hv5{c} = hv3{c};
	hj3: forall c in cells(), hv7{c} = hv4{c} + hv5{c} + hv6{c};		
	'''

	val nablaRemapModel =
	'''
	module Remap;

	with CartesianMesh2D.*;

	real[2] X{nodes};
	real rv1{cells}, rv2{cells}, rv3{cells};

	rj1: forall c in cells(), rv2{c} = rv1{c};
	rj2: forall c in cells(), rv3{c} = rv2{c};
	'''

	val ngenModel = 
	'''
	Application HydroRemap;

	MainModule Hydro h
	{
		meshClassName = "CartesianMesh2D";
		nodeCoord = X;
		time = t;
		timeStep = delta_t;
		iterationMax = maxIter;
		timeMax = maxTime;
	}

	AdditionalModule Remap r1
	{
		r1.X = h.X;
		r1.rv1 = h.hv1;
		r1.rv2 = h.hv4;
	}

	AdditionalModule Remap r2
	{
		r2.X = h.X;
		r2.rv1 = h.hv3;
		r2.rv3 = h.hv6;
	}

	VtkOutput
	{
		periodReferenceVariable = h.t;
		outputVariables = h.hv1 as "HV1", r1.rv1 as "RV1";
	}
	'''

	val nablaSetup = new NablaStandaloneSetup
	val nablaInjector = nablaSetup.createInjectorAndDoEMFRegistration
	val ParseHelper<NablaRoot> nParseHelper = nablaInjector.getInstance(ParseHelper)

	val nablagenSetup = new NablagenStandaloneSetup
	val nablagenInjector = nablagenSetup.createInjectorAndDoEMFRegistration
	val ParseHelper<NablagenApplication> ngenParseHelper = nablagenInjector.getInstance(ParseHelper)

	NablaModule nablaHydro
	NablaModule nablaRemap
	NablagenApplication ngenApp

	@Before
	def void readModels()
	{
		val rs = resourceSetProvider.get
		nParseHelper.parse(readFileAsString(TestUtils.CartesianMesh2DPath), rs)
		nablaHydro = nParseHelper.parse(nablaHydroModel, rs) as NablaModule
		Assert.assertNotNull(nablaHydro)
		nablaRemap = nParseHelper.parse(nablaRemapModel, rs)  as NablaModule
		Assert.assertNotNull(nablaRemap)
		ngenApp = ngenParseHelper.parse(ngenModel, rs)
		Assert.assertNotNull(ngenApp)
	}

	@Test
	def void testScopeProviderForMainModuleNodeCoord()
	{
		val eref = NablagenPackage::eINSTANCE.mainModule_NodeCoord
		val o = ngenApp.mainModule
		o.assertScope(eref, "X")
	}

	@Test
	def void testScopeProviderForMainModuleTime()
	{
		val eref = NablagenPackage::eINSTANCE.mainModule_Time
		val o = ngenApp.mainModule
		o.assertScope(eref, "maxTime, t, delta_t")
	}

	@Test
	def void testScopeProviderForMainModuleTimeStep()
	{
		val eref = NablagenPackage::eINSTANCE.mainModule_TimeStep
		val o = ngenApp.mainModule
		o.assertScope(eref, "maxTime, t, delta_t")
	}

	@Test
	def void testScopeProviderForMainModuleIterationMax()
	{
		val eref = NablagenPackage::eINSTANCE.mainModule_IterationMax
		val o = ngenApp.mainModule
		o.assertScope(eref, "maxIter, n")
	}

	@Test
	def void testScopeProviderForMainModuleTimeMax()
	{
		val eref = NablagenPackage::eINSTANCE.mainModule_TimeMax
		val o = ngenApp.mainModule
		o.assertScope(eref, "maxTime, t, delta_t")
	}

	@Test
	def void testScopeProviderForVtkOutputPeriodReferenceVar()
	{
		val eref = NablagenPackage::eINSTANCE.vtkOutput_PeriodReferenceVar
		val o = ngenApp.vtkOutput
		o.assertScope(eref, "maxTime, maxIter, t, delta_t, n")
	}

	@Test
	def void testScopeProviderForOutputVarVarRef()
	{
		val eref = NablagenPackage::eINSTANCE.outputVar_VarRef
		val o = ngenApp.vtkOutput.vars
		o.get(0).assertScope(eref, "X, hv1, hv2, hv3, hv4, hv5, hv6, hv7")
		o.get(1).assertScope(eref, "X, rv1, rv2, rv3")
	}

	@Test
	def void testScopeProviderForNablagenModuleType()
	{
		val eref = NablagenPackage::eINSTANCE.nablagenModule_Type
		var NablagenModule o = ngenApp.mainModule
		o.assertScope(eref, "Hydro, Remap")
		o = ngenApp.additionalModules.get(0)
		o.assertScope(eref, "Remap")
		o = ngenApp.additionalModules.get(1)
		o.assertScope(eref, "Remap")
	}

	@Test
	def void testVarLinkAdditionalModule()
	{
		val eref = NablagenPackage::eINSTANCE.varLink_AdditionalModule
		val r1 = ngenApp.additionalModules.get(0)
		r1.varLinks.forEach[x | x.assertScope(eref, "r1")]
		val r2 = ngenApp.additionalModules.get(1)
		r2.varLinks.forEach[x | x.assertScope(eref, "r2")]
	}

	@Test
	def void testVarLinkAdditionalVariable()
	{
		val eref = NablagenPackage::eINSTANCE.varLink_AdditionalVariable
		for (r : ngenApp.additionalModules)
			for (v : r.varLinks)
				v.assertScope(eref, "X, rv1, rv2, rv3")
	}

	@Test
	def void testVarLinkMainModule()
	{
		val eref = NablagenPackage::eINSTANCE.varLink_MainModule
		for (r : ngenApp.additionalModules)
			for (v : r.varLinks)
				v.assertScope(eref, "h")
	}

	@Test
	def void testVarLinkMainVariable()
	{
		val eref = NablagenPackage::eINSTANCE.varLink_MainVariable
		for (r : ngenApp.additionalModules)
			for (v : r.varLinks)
				v.assertScope(eref, "maxTime, maxIter, t, delta_t, X, hv1, hv2, hv3, hv4, hv5, hv6, hv7")
	}

	def private assertScope(EObject context, EReference reference, CharSequence expected)
	{
		val elementNames = context.getScope(reference).allElements.map[name].join(", ")
		Assert.assertEquals(expected.toString, elementNames)
	}
}