package fr.cea.nabla.interpreter;

import java.util.Iterator;
import java.util.NoSuchElementException;

import org.graalvm.options.OptionDescriptors;

import com.oracle.truffle.api.CallTarget;
import com.oracle.truffle.api.CompilerDirectives;
import com.oracle.truffle.api.Scope;
import com.oracle.truffle.api.TruffleLanguage;
import com.oracle.truffle.api.TruffleLanguage.ContextPolicy;
import com.oracle.truffle.api.frame.Frame;
import com.oracle.truffle.api.instrumentation.ProvidedTags;
import com.oracle.truffle.api.instrumentation.StandardTags;
import com.oracle.truffle.api.interop.InteropLibrary;
import com.oracle.truffle.api.interop.TruffleObject;
import com.oracle.truffle.api.interop.UnsupportedMessageException;
import com.oracle.truffle.api.nodes.Node;
import com.oracle.truffle.api.source.Source;

import fr.cea.nabla.interpreter.nodes.local.NablaLexicalScope;
import fr.cea.nabla.interpreter.parser.NablaParser;
import fr.cea.nabla.interpreter.runtime.NablaContext;
import fr.cea.nabla.interpreter.runtime.NablaLanguageView;
import fr.cea.nabla.interpreter.values.NablaOutput;
import fr.cea.nabla.interpreter.values.NablaValue;

@TruffleLanguage.Registration( //
		id = NablaLanguage.ID, //
		name = "Nabla", //
		defaultMimeType = NablaLanguage.MIME_TYPE, //
		characterMimeTypes = NablaLanguage.MIME_TYPE, //
		contextPolicy = ContextPolicy.SHARED, //
		fileTypeDetectors = NablaFileDetector.class)
@ProvidedTags({ //
		StandardTags.CallTag.class, //
		StandardTags.StatementTag.class, //
		StandardTags.RootTag.class, //
		StandardTags.RootBodyTag.class, //
		StandardTags.ExpressionTag.class, //
		StandardTags.WriteVariableTag.class })
public final class NablaLanguage extends TruffleLanguage<NablaContext> {

	public static final String ID = "nabla";

	public static final String MIME_TYPE = "application/x-nabla";

	@Override
	protected OptionDescriptors getOptionDescriptors() {
		return new NablaOptionsOptionDescriptors();
	}

	@Override
	protected NablaContext createContext(Env env) {
		return new NablaContext(this, env);
	}

	@Override
	protected CallTarget parse(ParsingRequest request) throws Exception {
		Source source = request.getSource();
		return (new NablaParser()).parseNabla(this, source);
	}

	@Override
	protected boolean isObjectOfLanguage(Object object) {
		if (!(object instanceof TruffleObject)) {
			return false;
		} else if (object instanceof NablaValue || object instanceof NablaOutput) {
			return true;
		} else {
			return false;
		}
	}

	public static String toString(Object value) {
		try {
			if (value == null) {
				return "ANY";
			}
			InteropLibrary interop = InteropLibrary.getFactory().getUncached(value);
			if (interop.fitsInLong(value)) {
				return Long.toString(interop.asLong(value));
			} else if (interop.isBoolean(value)) {
				return Boolean.toString(interop.asBoolean(value));
			} else if (interop.isString(value)) {
				return interop.asString(value);
			} else if (interop.isNull(value)) {
				return "NULL";
			} else if (interop.isExecutable(value)) {
				return "Function";
			} else if (interop.hasMembers(value)) {
				return "Object";
			} else {
				return "Unsupported";
			}
		} catch (UnsupportedMessageException e) {
			CompilerDirectives.transferToInterpreter();
			throw new AssertionError();
		}
	}

	@Override
	protected Object getLanguageView(NablaContext context, Object value) {
		return NablaLanguageView.create(value);
	}

	@Override
	public Iterable<Scope> findLocalScopes(NablaContext context, Node node, Frame frame) {
		final NablaLexicalScope scope = NablaLexicalScope.createScope(node, frame);
		final Iterable<Scope> result = new Iterable<Scope>() {
			@Override
			public Iterator<Scope> iterator() {
				return new Iterator<Scope>() {
					private NablaLexicalScope previousScope;
					private NablaLexicalScope nextScope = scope;

					@Override
					public boolean hasNext() {
						if (nextScope == null) {
							nextScope = previousScope.findParent();
						}
						return nextScope != null;
					}

					@Override
					public Scope next() {
						if (!hasNext()) {
							throw new NoSuchElementException();
						}
						Object functionObject = findFunctionObject();
						Scope vscope = Scope.newBuilder(nextScope.getName(), nextScope.getVariables(frame))
								.node(nextScope.getNode()).arguments(nextScope.getArguments(frame))
								.rootInstance(functionObject).build();
						previousScope = nextScope;
						nextScope = null;
						return vscope;
					}

					private Object findFunctionObject() {
//						TODO
//						String name = node.getRootNode().getName();
//						return context.getFunctionRegistry().getFunction(name);
						return null;
					}
				};
			}
		};
		return result;
	}

	@Override
	protected Iterable<Scope> findTopScopes(NablaContext context) {
		return context.getTopScopes();
	}

	public static NablaContext getCurrentContext() {
		return getCurrentContext(NablaLanguage.class);
	}
}
