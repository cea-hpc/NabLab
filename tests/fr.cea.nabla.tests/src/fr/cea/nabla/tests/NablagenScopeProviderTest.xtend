/*******************************************************************************
 * Copyright (c) 2020 CEA
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
import fr.cea.nabla.nablagen.NablagenModule
import fr.cea.nabla.nablagen.NablagenPackage
import fr.cea.nabla.nablagen.NablagenRoot
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
	@Inject Provider<ResourceSet> resourceSetProvider

	val nablaHydroModel =
	'''
	module Hydro;

	itemtypes { node, cell }

	connectivity nodes: → {node};
	connectivity cells: → {cell};

	// Simulation options
	option ℝ maxTime = 0.1;
	option ℕ maxIter = 500;

	let ℝ t = 0.0;
	option ℝ δt = 1.0;
	ℝ[2] X{nodes};
	ℝ hv1{cells}, hv2{cells}, hv3{cells}, hv4{cells}, hv5{cells}, hv6{cells}, hv7{cells};

	// iterate n while (n+1 < maxIter && t^{n+1} < maxTime);

	hj1: ∀c∈cells(), hv3{c} = hv2{c};
	hj2: ∀c∈cells(), hv5{c} = hv3{c};
	hj3: ∀c∈cells(), hv7{c} = hv4{c} + hv5{c} + hv6{c};		
	'''

	val nablaRemapModel =
	'''
	module Remap;

	itemtypes { node, cell }

	connectivity nodes: → {node};
	connectivity cells: → {cell};

	ℝ[2] X{nodes};
	ℝ rv1{cells}, rv2{cells}, rv3{cells};

	rj1: ∀c∈cells(), rv2{c} = rv1{c};
	rj2: ∀c∈cells(), rv3{c} = rv2{c};
	'''

	val ngenModel = 
	'''
	Application HydroRemap;

	MainModule Hydro h
	{
		meshClassName = "CartesianMesh2D";
		nodeCoord = X;
		time = t;
		timeStep = δt;
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
	val ParseHelper<NablaModule> nablaParseHelper = nablaInjector.getInstance(ParseHelper)

	val nablagenSetup = new NablagenStandaloneSetup
	val nablagenInjector = nablagenSetup.createInjectorAndDoEMFRegistration
	val ParseHelper<NablagenRoot> nablagenParseHelper = nablagenInjector.getInstance(ParseHelper)

	NablaModule nablaHydro
	NablaModule nablaRemap
	NablagenRoot ngen

	@Before
	def void readModels()
	{
		val rs = resourceSetProvider.get
		nablaHydro = nablaParseHelper.parse(nablaHydroModel, rs)
		Assert.assertNotNull(nablaHydro)
		nablaRemap = nablaParseHelper.parse(nablaRemapModel, rs)
		Assert.assertNotNull(nablaRemap)
		ngen = nablagenParseHelper.parse(ngenModel, rs)
		Assert.assertNotNull(ngen)
	}

	@Test
	def void testScopeProviderForMainModuleNodeCoord()
	{
		val eref = NablagenPackage::eINSTANCE.mainModule_NodeCoord
		val o = ngen.mainModule
		o.assertScope(eref, "X")
	}

	@Test
	def void testScopeProviderForMainModuleTime()
	{
		val eref = NablagenPackage::eINSTANCE.mainModule_Time
		val o = ngen.mainModule
		o.assertScope(eref, "maxTime, δt, t")
	}

	@Test
	def void testScopeProviderForMainModuleTimeStep()
	{
		val eref = NablagenPackage::eINSTANCE.mainModule_TimeStep
		val o = ngen.mainModule
		o.assertScope(eref, "maxTime, δt, t")
	}

	@Test
	def void testScopeProviderForMainModuleIterationMax()
	{
		val eref = NablagenPackage::eINSTANCE.mainModule_IterationMax
		val o = ngen.mainModule
		o.assertScope(eref, "maxIter")
	}

	@Test
	def void testScopeProviderForMainModuleTimeMax()
	{
		val eref = NablagenPackage::eINSTANCE.mainModule_TimeMax
		val o = ngen.mainModule
		o.assertScope(eref, "maxTime, δt, t")
	}

	@Test
	def void testScopeProviderForVtkOutputPeriodReferenceVar()
	{
		val eref = NablagenPackage::eINSTANCE.vtkOutput_PeriodReferenceVar
		val o = ngen.vtkOutput
		o.assertScope(eref, "maxTime, maxIter, δt, t")
	}

	@Test
	def void testScopeProviderForOutputVarVarRef()
	{
		val eref = NablagenPackage::eINSTANCE.outputVar_VarRef
		val o = ngen.vtkOutput.vars
		o.get(0).assertScope(eref, "X, hv1, hv2, hv3, hv4, hv5, hv6, hv7")
		o.get(1).assertScope(eref, "X, rv1, rv2, rv3")
	}

	@Test
	def void testScopeProviderForNablagenModuleType()
	{
		val eref = NablagenPackage::eINSTANCE.nablagenModule_Type
		var NablagenModule o = ngen.mainModule
		o.assertScope(eref, "Hydro, Remap")
		o = ngen.additionalModules.get(0)
		o.assertScope(eref, "Remap")
		o = ngen.additionalModules.get(1)
		o.assertScope(eref, "Remap")
	}

	@Test
	def void testVarLinkAdditionalModule()
	{
		val eref = NablagenPackage::eINSTANCE.varLink_AdditionalModule
		val r1 = ngen.additionalModules.get(0)
		r1.varLinks.forEach[x | x.assertScope(eref, "r1")]
		val r2 = ngen.additionalModules.get(1)
		r2.varLinks.forEach[x | x.assertScope(eref, "r2")]
	}

	@Test
	def void testVarLinkAdditionalVariable()
	{
		val eref = NablagenPackage::eINSTANCE.varLink_AdditionalVariable
		for (r : ngen.additionalModules)
			for (v : r.varLinks)
				v.assertScope(eref, "X, rv1, rv2, rv3")
	}

	@Test
	def void testVarLinkMainModule()
	{
		val eref = NablagenPackage::eINSTANCE.varLink_MainModule
		for (r : ngen.additionalModules)
			for (v : r.varLinks)
				v.assertScope(eref, "h")
	}

	@Test
	def void testVarLinkMainVariable()
	{
		val eref = NablagenPackage::eINSTANCE.varLink_MainVariable
		for (r : ngen.additionalModules)
			for (v : r.varLinks)
				v.assertScope(eref, "maxTime, maxIter, t, δt, X, hv1, hv2, hv3, hv4, hv5, hv6, hv7")
	}

	def private assertScope(EObject context, EReference reference, CharSequence expected)
	{
		val elementNames = context.getScope(reference).allElements.map[name].join(", ")
		Assert.assertEquals(expected.toString, elementNames)
	}
}