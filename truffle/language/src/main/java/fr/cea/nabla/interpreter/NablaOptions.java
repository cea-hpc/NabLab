package fr.cea.nabla.interpreter;

import org.graalvm.options.OptionCategory;
import org.graalvm.options.OptionKey;
import org.graalvm.options.OptionMap;
import org.graalvm.options.OptionStability;

import com.oracle.truffle.api.Option;

@Option.Group("nabla")
public class NablaOptions {
	@Option(help = "User-defined properties", category = OptionCategory.USER)
    public static final OptionKey<OptionMap<String>> properties = OptionKey.mapOf(String.class);
	@Option(category = OptionCategory.INTERNAL, help = "Prints Java and Nabla stack traces for all errors")
    public static final OptionKey<Boolean> PrintErrorStacktraces = new OptionKey<>(false);
    @Option(category = OptionCategory.USER, stability = OptionStability.STABLE, help = "Dumps Java and Nabla stack traces to 'nabla_errors-{context ID}_{PID}.log' for all internal errors")
    public static final OptionKey<Boolean> PrintErrorStacktracesToFile = new OptionKey<>(false);
    @Option(name = "model", help = "Model to run", category = OptionCategory.USER, stability = OptionStability.STABLE)
	public static final OptionKey<String> MODEL = new OptionKey<>("");
    @Option(name = "genmodel", help = "Genmodel to run", category = OptionCategory.USER, stability = OptionStability.STABLE)
	public static final OptionKey<String> GENMODEL = new OptionKey<>("");
    @Option(name = "options", help = "Model to run", category = OptionCategory.USER, stability = OptionStability.STABLE)
	public static final OptionKey<String> OPTIONS = new OptionKey<>("");
    @Option(name = "meshlib", help = "Mesh Library", category = OptionCategory.USER, stability = OptionStability.STABLE)
	public static final OptionKey<String> MESH_LIB = new OptionKey<>("");

	public static Object getName(OptionKey<Boolean> key) {
		return null;
	}
}
