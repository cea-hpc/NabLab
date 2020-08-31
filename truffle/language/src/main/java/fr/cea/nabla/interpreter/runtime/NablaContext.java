package fr.cea.nabla.interpreter.runtime;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.util.Collections;

import org.graalvm.options.OptionKey;
import org.graalvm.polyglot.Value;

import com.oracle.truffle.api.CompilerDirectives.CompilationFinal;
import com.oracle.truffle.api.Scope;
import com.oracle.truffle.api.TruffleLanguage;
import com.oracle.truffle.api.TruffleLanguage.Env;
import com.oracle.truffle.api.frame.Frame;
import com.oracle.truffle.api.frame.MaterializedFrame;
import com.oracle.truffle.api.instrumentation.AllocationReporter;
import com.oracle.truffle.api.nodes.Node;
import com.oracle.truffle.api.nodes.NodeInfo;
import com.oracle.truffle.api.object.Layout;

import fr.cea.nabla.interpreter.NablaLanguage;
import fr.cea.nabla.interpreter.nodes.local.NablaLexicalScope;

public final class NablaContext {

    static final Layout LAYOUT = Layout.createLayout();

    private final Env env;
    private final BufferedReader input;
    private final PrintWriter output;
    private final NablaFunctionRegistry functionRegistry;
    private final AllocationReporter allocationReporter;
    private final MeshWrapper meshWrapper;

    @CompilationFinal
    private MaterializedFrame globalFrame;
    @CompilationFinal
    private Iterable<Scope> topScopes;

    public NablaContext(NablaLanguage language, TruffleLanguage.Env env) {
        this.env = env;
        this.input = new BufferedReader(new InputStreamReader(env.in()));
        this.output = new PrintWriter(env.out(), true);
        this.allocationReporter = env.lookup(AllocationReporter.class);
        this.functionRegistry = new NablaFunctionRegistry(language);
        this.meshWrapper = new MeshWrapper();
    }

    public Env getEnv() {
        return env;
    }

    public BufferedReader getInput() {
        return input;
    }

    public PrintWriter getOutput() {
        return output;
    }

    public NablaFunctionRegistry getFunctionRegistry() {
        return functionRegistry;
    }
    
    public Iterable<Scope> getTopScopes() {
    	assert topScopes != null;
    	return topScopes;
    }

    public static NodeInfo lookupNodeInfo(Class<?> clazz) {
        if (clazz == null) {
            return null;
        }
        NodeInfo info = clazz.getAnnotation(NodeInfo.class);
        if (info != null) {
            return info;
        } else {
            return lookupNodeInfo(clazz.getSuperclass());
        }
    }
    
    public static NablaContext getCurrent() {
        return NablaLanguage.getCurrentContext();
    }
    
    public static void initializeMesh(final int nbXQuads, final int nbYQuads, final double xSize, final double ySize, final String pathToMeshLibrary) {
    	getCurrent().meshWrapper.initialize(nbXQuads, nbYQuads, xSize, ySize, pathToMeshLibrary);
    }
    
    public static Value getNodes() {
    	return getCurrent().meshWrapper.getNodes();
    }
    
    public static MeshWrapper getMeshWrapper() {
    	return getCurrent().meshWrapper;
    }
    
    public static Value getCartesianMesh() {
    	return getMeshWrapper().getMeshWrapper();
    }
    
//    public static Value getMeshWrapper() {
//    	return getCurrent().meshWrapper.getMeshWrapper();
//    }
//    
//    public static Value getMeshInstance() {
//    	return getCurrent().meshWrapper.getMeshInstance();
//    }
    
	public static Object fromForeignValue(Object object) {
		return null;
	}

	public AllocationReporter getAllocationReporter() {
		return allocationReporter;
	}

	public boolean getOption(OptionKey<Boolean> key) {
		return this.getEnv().getOptions().get(key);
	}

	public Frame getGlobalFrame() {
		return globalFrame;
	}
	
	public void setGlobalFrame(Node node, MaterializedFrame globalFrame) {
		this.globalFrame = globalFrame;
		final NablaLexicalScope scope = NablaLexicalScope.createScope(node, globalFrame);
		final Scope vscope = Scope.newBuilder(scope.getName(), scope.getVariables(globalFrame))
				.node(scope.getNode()).arguments(scope.getArguments(globalFrame))
				.rootInstance(null).build();
		topScopes = Collections.singleton(vscope);
	}

}
