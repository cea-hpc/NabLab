package fr.cea.nabla.ir.generator.cpp

import org.eclipse.xtend.lib.annotations.Accessors

abstract class Backend
{
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) String name
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) Ir2Cmake ir2Cmake
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) TraceContentProvider traceContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) IncludesContentProvider includesContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) TypeContentProvider typeContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) ExpressionContentProvider expressionContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) ArgOrVarContentProvider argOrVarContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) AttributesContentProvider attributesContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) InstructionContentProvider instructionContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) FunctionContentProvider functionContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) JobContainerContentProvider jobContainerContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) JobContentProvider jobContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) PrivateMethodsContentProvider privateMethodsContentProvider
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) MainContentProvider mainContentProvider
}

class KokkosBackend extends Backend
{
	new(String maxIterationVarName, String stopTimeVarName)
	{
		name = 'Kokkos'
		ir2Cmake = new KokkosIr2Cmake
		traceContentProvider = new TraceContentProvider(maxIterationVarName, stopTimeVarName)
		includesContentProvider = new KokkosIncludesContentProvider
		typeContentProvider = new KokkosTypeContentProvider
		expressionContentProvider = new ExpressionContentProvider(typeContentProvider)
		argOrVarContentProvider = new KokkosArgOrVarContentProvider(typeContentProvider)
		attributesContentProvider = new AttributesContentProvider(argOrVarContentProvider)
		instructionContentProvider = new KokkosInstructionContentProvider(argOrVarContentProvider, expressionContentProvider)
		functionContentProvider = new KokkosFunctionContentProvider(typeContentProvider, instructionContentProvider)
		jobContainerContentProvider = new JobContainerContentProvider
		jobContentProvider = new KokkosJobContentProvider(traceContentProvider, expressionContentProvider, instructionContentProvider, jobContainerContentProvider)
		privateMethodsContentProvider = new PrivateMethodsContentProvider(jobContentProvider, functionContentProvider)
		mainContentProvider = new KokkosMainContentProvider
	}
}

class KokkosTeamThreadBackend extends Backend
{
	new(String maxIterationVarName, String stopTimeVarName)
	{
		name = 'Kokkos Team Thread'
		ir2Cmake = new KokkosIr2Cmake
		traceContentProvider = new TraceContentProvider(maxIterationVarName, stopTimeVarName)
		includesContentProvider = new KokkosIncludesContentProvider
		typeContentProvider = new KokkosTypeContentProvider
		expressionContentProvider = new ExpressionContentProvider(typeContentProvider)
		argOrVarContentProvider = new KokkosArgOrVarContentProvider(typeContentProvider)
		attributesContentProvider = new KokkosTeamThreadAttributesContentProvider(argOrVarContentProvider)
		instructionContentProvider = new KokkosTeamThreadInstructionContentProvider(argOrVarContentProvider, expressionContentProvider)
		functionContentProvider = new KokkosFunctionContentProvider(typeContentProvider, instructionContentProvider)
		jobContainerContentProvider = new KokkosTeamThreadJobContainerContentProvider
		jobContentProvider = new KokkosTeamThreadJobContentProvider(traceContentProvider, expressionContentProvider, instructionContentProvider, jobContainerContentProvider)
		privateMethodsContentProvider = new KokkosTeamThreadPrivateMethodsContentProvider(jobContentProvider, functionContentProvider)
		mainContentProvider = new KokkosMainContentProvider
	}
}

class SequentialBackend extends Backend
{
	new(String maxIterationVarName, String stopTimeVarName)
	{
		name = 'Sequential'
		ir2Cmake = new Ir2Cmake
		traceContentProvider = new TraceContentProvider(maxIterationVarName, stopTimeVarName)
		includesContentProvider = new IncludesContentProvider
		typeContentProvider = new StdVectorTypeContentProvider
		expressionContentProvider = new ExpressionContentProvider(typeContentProvider)
		argOrVarContentProvider = new NoLinearAlgebraArgOrVarContentProvider(typeContentProvider)
		attributesContentProvider = new AttributesContentProvider(argOrVarContentProvider)
		instructionContentProvider = new SequentialInstructionContentProvider(argOrVarContentProvider, expressionContentProvider)
		functionContentProvider = new FunctionContentProvider(typeContentProvider, instructionContentProvider)
		jobContainerContentProvider = new JobContainerContentProvider
		jobContentProvider = new SequentialJobContentProvider(traceContentProvider, expressionContentProvider, instructionContentProvider, jobContainerContentProvider)
		privateMethodsContentProvider = new PrivateMethodsContentProvider(jobContentProvider, functionContentProvider)
		mainContentProvider = new MainContentProvider
	}
}
