package fr.cea.nabla.interpreter.runtime;

import org.eclipse.xtext.util.Strings;
import org.graalvm.polyglot.Context;
import org.graalvm.polyglot.Value;

import com.oracle.truffle.api.CompilerDirectives;
import com.oracle.truffle.api.CompilerDirectives.CompilationFinal;
import com.oracle.truffle.api.CompilerDirectives.TruffleBoundary;

import fr.cea.nabla.ir.ir.Iterator;
//import fr.cea.nabla.javalib.mesh.CartesianMesh2D;
//import fr.cea.nabla.javalib.mesh.Quad;
import fr.cea.nabla.javalib.mesh.CartesianMesh2D;
import fr.cea.nabla.javalib.mesh.CartesianMesh2DGenerator;

public class MeshWrapper {

	@CompilationFinal
	private Value meshWrapper;
	@CompilationFinal
	private Value meshInstance;
	@CompilationFinal
	private CartesianMesh2D mesh;

	@TruffleBoundary
	public MeshWrapper() {
	}

	@TruffleBoundary
	public void initialize(final int nbXQuads, final int nbYQuads, final double xSize, final double ySize, String pathToMeshLibrary) {
		assert (this.meshInstance == null);
		CompilerDirectives.transferToInterpreterAndInvalidate();
		this.mesh = CartesianMesh2DGenerator.generate(nbXQuads, nbYQuads, xSize, ySize);
		this.meshWrapper = Context.getCurrent().asValue(mesh);
//		final Context polyglot = Context.getCurrent();
//		final File file = new File(pathToMeshLibrary);
//		try {
//			meshWrapper = polyglot.eval(Source.newBuilder("llvm", file).build());
//			meshInstance = meshWrapper.getMember("get_wrapper").execute(nbXQuads, nbYQuads, xSize, ySize);
//		} catch (IOException e) {
//			e.printStackTrace();
//			throw NablaInternalError.shouldNotReachHere();
//		}
	}

	public Value getMeshInstance() {
		return meshInstance;
	}

	public Value getMeshWrapper() {
		return meshWrapper;
	}

	// FIXME ugly getNb
	public Value connectivityGetter(String connectivityName) {
		final String getterName;
		if (connectivityName.equals("nodes") || connectivityName.equals("cells")) {
			getterName = "getNb" + Strings.toFirstUpper(connectivityName);
		} else {
			getterName = "get" + Strings.toFirstUpper(connectivityName);
		}
		return meshWrapper.getMember(getterName);
	}

//	@TruffleBoundary
//	public int[] getElements(final String connectivityName, final int[] args) {
//		int[] _switchResult = null;
//		if (connectivityName == null || connectivityName.isEmpty() ) {
//			throw new IllegalArgumentException("Connectivity name can't be null or empty");
//		} else {
//			switch (connectivityName) {
//			case "nodes":
//				_switchResult = this.mesh.getNodes();
//				break;
//			case "cells":
//				_switchResult = this.mesh.getCells();
//				break;
//			case "faces":
//				_switchResult = this.mesh.getFaces();
//				break;
//			case "innerNodes":
//				_switchResult = this.mesh.getInnerNodes();
//				break;
//			case "outerFaces":
//				_switchResult = this.mesh.getOuterFaces();
//				break;
//			case "nodesOfCell":
//				_switchResult = this.mesh.getNodesOfCell(args[0]);
//				break;
//			case "cellsOfNode":
//				_switchResult = this.mesh.getCellsOfNode(args[0]);
//				break;
//			case "nodesOfFace":
//				_switchResult = this.mesh.getNodesOfFace(args[0]);
//				break;
//			case "neighbourCells":
//				_switchResult = this.mesh.getNeighbourCells(args[0]);
//				break;
//			case "cellsOfFace":
//				_switchResult = this.mesh.getCellsOfFace(args[0]);
//				break;
//			default:
//				throw new RuntimeException((("Not implemented yet (" + connectivityName) + ")"));
//			}
//		}
//		return _switchResult;
//	}

	@TruffleBoundary
	public int getIndexOf(final Iterator iterator, final int id) {
		throw new RuntimeException("Not implemented yet");
	}

//	@TruffleBoundary
//	public int getSingleton(final String connectivityName, final int[] params) {
//		int _switchResult = (int) 0;
//		if (connectivityName != null) {
//			switch (connectivityName) {
//			case "commonFace":
//				_switchResult = this.mesh.getCommonFace(params[0], params[1]);
//				break;
//			default:
//				throw new RuntimeException((("Not implemented yet (" + connectivityName) + ")"));
//			}
//		} else {
//			throw new RuntimeException((("Not implemented yet (" + connectivityName) + ")"));
//		}
//		return _switchResult;
//	}

	@TruffleBoundary
	public Value getNodes() {
		return meshWrapper.invokeMember("getGeometry").invokeMember("getNodes");
	}

//	@TruffleBoundary
//	public int getNbElems(final String connectivityName) {
//		int _switchResult = (int) 0;
//		if (connectivityName != null) {
//			switch (connectivityName) {
//			case "nodes":
//				_switchResult = this.mesh.getNbNodes();
//				break;
//			case "cells":
//				_switchResult = this.mesh.getNbCells();
//				break;
//			case "faces":
//				_switchResult = this.mesh.getNbFaces();
//				break;
//			case "outerFaces":
//				_switchResult = this.mesh.getNbOuterFaces();
//				break;
//			case "innerNodes":
//				_switchResult = this.mesh.getNbInnerNodes();
//				break;
//			default:
//				throw new RuntimeException("Not implemented yet");
//			}
//		} else {
//			throw new RuntimeException("Not implemented yet");
//		}
//		return _switchResult;
//	}

//	@TruffleBoundary
//	public int getMaxNbElems(final String connectivityName) {
//		int _switchResult = (int) 0;
//		if (connectivityName != null) {
//			switch (connectivityName) {
//			case "nodesOfCell":
//				_switchResult = CartesianMesh2D.MaxNbNodesOfCell;
//				break;
//			case "nodesOfFace":
//				_switchResult = CartesianMesh2D.MaxNbNodesOfFace;
//				break;
//			case "cellsOfNode":
//				_switchResult = CartesianMesh2D.MaxNbCellsOfNode;
//				break;
//			case "cellsOfFace":
//				_switchResult = CartesianMesh2D.MaxNbCellsOfFace;
//				break;
//			case "neighbourCells":
//				_switchResult = CartesianMesh2D.MaxNbNeighbourCells;
//				break;
//			case "facesOfCell":
//				_switchResult = CartesianMesh2D.MaxNbFacesOfCell;
//				break;
//			default:
//				throw new RuntimeException("Not implemented yet");
//			}
//		} else {
//			throw new RuntimeException("Not implemented yet");
//		}
//		return _switchResult;
//	}

//	@TruffleBoundary
//	public Quad[] getQuads() {
//		return this.mesh.getGeometry().getQuads();
//	}
}
