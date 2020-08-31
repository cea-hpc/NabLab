package fr.cea.nabla.interpreter.runtime;

import com.oracle.truffle.api.interop.TruffleObject;

@SuppressWarnings("static-method")
public final class NablaNull implements TruffleObject {

    public static final NablaNull SINGLETON = new NablaNull();

    private NablaNull() {}

    @Override
    public String toString() {
        return "NULL";
    }
}
