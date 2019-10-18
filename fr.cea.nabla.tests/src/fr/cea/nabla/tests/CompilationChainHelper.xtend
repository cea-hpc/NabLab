package fr.cea.nabla.tests

import com.google.inject.Inject
import com.google.inject.Provider
import fr.cea.nabla.NablaStandaloneSetup
import fr.cea.nabla.NablagenStandaloneSetup
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nablagen.NablagenModule
import fr.cea.nabla.workflow.WorkflowInterpretor
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.eclipse.xtext.testing.util.ParseHelper
import org.eclipse.xtext.testing.validation.ValidationTestHelper
import org.junit.runner.RunWith

@RunWith(XtextRunner)
@InjectWith(NablaInjectorProvider)
class CompilationChainHelper 
{
	@Inject extension ValidationTestHelper
	@Inject Provider<WorkflowInterpretor> interpretorProvider
	@Inject Provider<ResourceSet> resourceSetProvider

	var nablaSetup = new NablaStandaloneSetup
	var nablaInjector = nablaSetup.createInjectorAndDoEMFRegistration
	var ParseHelper<NablaModule> nablaParseHelper = nablaInjector.getInstance(ParseHelper)

	var nablagenSetup = new NablagenStandaloneSetup
	var nablagenInjector = nablagenSetup.createInjectorAndDoEMFRegistration
	var ParseHelper<NablagenModule> nablagenParseHelper = nablagenInjector.getInstance(ParseHelper)

	var IrModule irModule
		
	def getIrModule(CharSequence model, CharSequence genModel)
	{
		var nablaModule = nablaParseHelper.parse(model)
		nablaModule.assertNoErrors
		
		var rs = resourceSetProvider.get
		rs.resources.add(nablaModule.eResource)
		var nablaGenModule = nablagenParseHelper.parse(genModel, rs)
		nablaGenModule.assertNoErrors
		
		var workflow = nablaGenModule.workflow
		if (workflow!== null)
		{
			var interpretor = interpretorProvider.get
			interpretor.addWorkflowModelChangedLister([module|irModule = module])
			interpretor.launch(workflow)
		}	
		return irModule
	}
}
