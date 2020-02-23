package fr.cea.nabla.ir.generator.cpp

import org.eclipse.xtend.lib.annotations.Accessors

abstract class Backend
{
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) String name
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) TraceContentProvider traceContenProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) IncludesContentProvider includesContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) TypeContentProvider typeContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) AttributesContentProvider attributesContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) ArgOrVarContentProvider argOrVarContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) InstructionContentProvider instructionContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) FunctionContentProvider functionContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) JobCallsContentProvider jobCallsContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) JobContentProvider jobContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) PrivateMethodsContentProvider privateMethodsContentProvider
}

class KokkosBackend extends Backend
{
	new(String maxIterationVarName, String stopTimeVarName)
	{
		name = 'Kokkos'
		traceContenProvider = new TraceContentProvider(maxIterationVarName, stopTimeVarName)
		includesContentProvider = new KokkosIncludesContentProvider
		typeContentProvider = new KokkosTypeContentProvider
		attributesContentProvider = new AttributesContentProvider(typeContentProvider)
		argOrVarContentProvider = new KokkosArgOrVarContentProvider(typeContentProvider)
		instructionContentProvider = new KokkosInstructionContentProvider(argOrVarContentProvider)
		functionContentProvider = new KokkosFunctionContentProvider(typeContentProvider, instructionContentProvider)
		jobCallsContentProvider = new JobCallsContentProvider(traceContenProvider)
		jobContentProvider = new KokkosJobContentProvider(traceContenProvider, instructionContentProvider, jobCallsContentProvider)
		privateMethodsContentProvider = new PrivateMethodsContentProvider(jobContentProvider, functionContentProvider)
	}
}

class KokkosTeamThreadBackend extends Backend
{
	new(String maxIterationVarName, String stopTimeVarName)
	{
		name = 'Kokkos Team Thread'
		traceContenProvider = new TraceContentProvider(maxIterationVarName, stopTimeVarName)
		includesContentProvider = new KokkosIncludesContentProvider
		typeContentProvider = new KokkosTypeContentProvider
		attributesContentProvider = new KokkosTeamThreadAttributesContentProvider(typeContentProvider)
		argOrVarContentProvider = new KokkosArgOrVarContentProvider(typeContentProvider)
		instructionContentProvider = new KokkosTeamThreadInstructionContentProvider(argOrVarContentProvider)
		functionContentProvider = new KokkosFunctionContentProvider(typeContentProvider, instructionContentProvider)
		jobCallsContentProvider = new KokkosTeamThreadJobCallsContentProvider(traceContenProvider)
		jobContentProvider = new KokkosTeamThreadJobContentProvider(traceContenProvider, instructionContentProvider, jobCallsContentProvider)
		privateMethodsContentProvider = new KokkosTeamThreadPrivateMethodsContentProvider(jobContentProvider, functionContentProvider)
	}
}