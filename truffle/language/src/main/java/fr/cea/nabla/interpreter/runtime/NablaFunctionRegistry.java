package fr.cea.nabla.interpreter.runtime;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Map;

import com.oracle.truffle.api.RootCallTarget;
import com.oracle.truffle.api.interop.TruffleObject;

import fr.cea.nabla.interpreter.NablaLanguage;

public final class NablaFunctionRegistry {

	private final NablaLanguage language;
	private final FunctionsObject functionsObject = new FunctionsObject();

	public NablaFunctionRegistry(NablaLanguage language) {
		this.language = language;
	}

	public NablaFunction lookup(String name, boolean createIfNotPresent) {
		NablaFunction result = functionsObject.functions.get(name);
		if (result == null && createIfNotPresent) {
			result = new NablaFunction(language, name);
			functionsObject.functions.put(name, result);
		}
		return result;
	}

	public NablaFunction register(String name, RootCallTarget callTarget) {
		NablaFunction function = lookup(name, true);
		function.setCallTarget(callTarget);
		return function;
	}

	public void register(Map<String, RootCallTarget> newFunctions) {
		for (Map.Entry<String, RootCallTarget> entry : newFunctions.entrySet()) {
			register(entry.getKey(), entry.getValue());
		}
	}

	public NablaFunction getFunction(String name) {
		return functionsObject.functions.get(name);
	}

	/**
	 * Returns the sorted list of all functions, for printing purposes only.
	 */
	public List<NablaFunction> getFunctions() {
		List<NablaFunction> result = new ArrayList<>(functionsObject.functions.values());
		Collections.sort(result, new Comparator<NablaFunction>() {
			public int compare(NablaFunction f1, NablaFunction f2) {
				return f1.toString().compareTo(f2.toString());
			}
		});
		return result;
	}

	public TruffleObject getFunctionsObject() {
		return functionsObject;
	}

}
