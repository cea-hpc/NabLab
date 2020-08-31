package fr.cea.nabla.interpreter.values;

import java.util.Map;

import com.oracle.truffle.api.interop.InteropLibrary;
import com.oracle.truffle.api.interop.TruffleObject;
import com.oracle.truffle.api.interop.UnsupportedMessageException;
import com.oracle.truffle.api.library.ExportLibrary;
import com.oracle.truffle.api.library.ExportMessage;

@ExportLibrary(InteropLibrary.class)
public final class NablaOutput implements TruffleObject {

	private final Map<String, NablaValue> outputMap;
	
	public NablaOutput(Map<String, NablaValue> outputMap) {
		this.outputMap = outputMap;
	}
	
	@ExportMessage
	boolean hasMembers() {
		return true;
	}
	
	@ExportMessage
	Object getMembers(boolean includeInternal) throws UnsupportedMessageException {
		return outputMap.keySet().toArray(new String[0]);
	}
	
	@ExportMessage
	boolean isMemberReadable(String member) {
		return outputMap.containsKey(member);
	}
	
	@ExportMessage
	Object readMember(String member) {
		return outputMap.get(member);
	}
}
