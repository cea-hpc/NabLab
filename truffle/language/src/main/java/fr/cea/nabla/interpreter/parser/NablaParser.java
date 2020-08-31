package fr.cea.nabla.interpreter.parser;

import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.LogManager;
import org.eclipse.emf.ecore.EPackage;
import org.graalvm.options.OptionValues;

import com.google.gson.Gson;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.oracle.truffle.api.RootCallTarget;
import com.oracle.truffle.api.Truffle;
import com.oracle.truffle.api.TruffleLanguage.Env;
import com.oracle.truffle.api.nodes.RootNode;
import com.oracle.truffle.api.source.Source;

import fr.cea.nabla.interpreter.NablaLanguage;
import fr.cea.nabla.interpreter.NablaOptions;
import fr.cea.nabla.interpreter.nodes.NablaEvalRootNode;
import fr.cea.nabla.ir.ir.IrModule;
import fr.cea.nabla.ir.ir.IrPackage;

public class NablaParser {

	public RootCallTarget parseNabla(NablaLanguage nablaLanguage, Source source) {
		LogManager.shutdown();
		final Env env = NablaLanguage.getCurrentContext().getEnv();
		final OptionValues options = env.getOptions();
		String jsonOptionsString = options.get(NablaOptions.OPTIONS);
		String pathToMeshLibrary = options.get(NablaOptions.MESH_LIB);
		EPackage.Registry.INSTANCE.put(IrPackage.eNS_URI, IrPackage.eINSTANCE);
		final IrModule irModule = getIrModule(source, options.get(NablaOptions.GENMODEL));
		final Map<String, JsonElement> jsonOptions = new HashMap<>();
		if (jsonOptionsString != null && !jsonOptionsString.isEmpty()) {
			final Gson gson = new Gson();
			gson.fromJson(jsonOptionsString, JsonObject.class).entrySet()
					.forEach(e -> jsonOptions.put(e.getKey(), e.getValue()));
		}
		
		final RootCallTarget moduleCallTarget = Truffle.getRuntime()
				.createCallTarget(new NablaNodeFactory(nablaLanguage, source).createModule(irModule, jsonOptions, pathToMeshLibrary));
		final RootNode evalModule = new NablaEvalRootNode(nablaLanguage, moduleCallTarget);
		final RootCallTarget result = Truffle.getRuntime().createCallTarget(evalModule);
		return result;
	}

	private IrModule getIrModule(Source source, String genModel) {
		final String model = source.getCharacters().toString();
		NablaInjectorProvider inj = new NablaInjectorProvider();
		CompilationChainHelper helper = new CompilationChainHelper();
		inj.getInjector().injectMembers(helper);
		return helper.getIrModule(model, genModel);
	}
}
