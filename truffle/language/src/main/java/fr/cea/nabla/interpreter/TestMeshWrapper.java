package fr.cea.nabla.interpreter;

import java.io.File;
import java.io.IOException;

import org.graalvm.polyglot.Context;
import org.graalvm.polyglot.Source;
import org.graalvm.polyglot.Value;

class TestMeshWrapper {
	
	public static void main(String[] args) throws IOException {
		Context polyglot = Context.newBuilder("llvm")
				.allowAllAccess(true)
//				.option("inspect", "9229") //Uncomment to debug C++ in chrome
				.build();
		File file = new File("meshlib.so");
		Source source = Source.newBuilder("llvm", file).build();
		Value library = polyglot.eval(source);
		Value wrapper = library.getMember("get_wrapper").execute(2, 2, 1.0, 1.0);
		Value v1 = library.getMember("getOuterFaces").execute(wrapper);
		Value v2 = library.getMember("getNodesOfCell").execute(wrapper, 0);
		System.out.println("v1 = " + v1 + " ; v2 = " + v2);
		library.getMember("free_wrapper").execute(wrapper);
	}
}
