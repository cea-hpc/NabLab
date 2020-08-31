package fr.cea.nabla.interpreter.runtime;

import com.oracle.truffle.api.CompilerDirectives;
import com.oracle.truffle.api.CompilerDirectives.CompilationFinal;
import com.oracle.truffle.api.RootCallTarget;
import com.oracle.truffle.api.Truffle;
import com.oracle.truffle.api.interop.InteropLibrary;
import com.oracle.truffle.api.interop.TruffleObject;
import com.oracle.truffle.api.library.ExportLibrary;

import fr.cea.nabla.interpreter.NablaLanguage;
import fr.cea.nabla.interpreter.nodes.NablaUndefinedFunctionRootNode;

@ExportLibrary(InteropLibrary.class)
public final class NablaFunction implements TruffleObject {

    public static final int INLINE_CACHE_SIZE = 2;

    private final String name;

    @CompilationFinal
    private RootCallTarget callTarget;
    
    protected NablaFunction(NablaLanguage language, String name) {
        this.name = name;
        this.callTarget = Truffle.getRuntime().createCallTarget(new NablaUndefinedFunctionRootNode(language, name));
    }

    public String getName() {
        return name;
    }

    protected void setCallTarget(RootCallTarget callTarget) {
    	CompilerDirectives.transferToInterpreterAndInvalidate();
        this.callTarget = callTarget;
    }

    public RootCallTarget getCallTarget() {
        return callTarget;
    }
    
    @Override
    public String toString() {
        return name;
    }
}
