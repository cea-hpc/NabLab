package fr.cea.nabla.interpreter.nodes.expression;

import com.oracle.truffle.api.dsl.TypeSystemReference;
import com.oracle.truffle.api.frame.VirtualFrame;
import com.oracle.truffle.api.instrumentation.GenerateWrapper;
import com.oracle.truffle.api.instrumentation.ProbeNode;
import com.oracle.truffle.api.instrumentation.StandardTags;
import com.oracle.truffle.api.instrumentation.Tag;
import com.oracle.truffle.api.nodes.NodeInfo;
import com.oracle.truffle.api.nodes.UnexpectedResultException;

import fr.cea.nabla.interpreter.NablaTypes;
import fr.cea.nabla.interpreter.NablaTypesGen;
import fr.cea.nabla.interpreter.nodes.NablaNode;
import fr.cea.nabla.interpreter.values.NV0Bool;
import fr.cea.nabla.interpreter.values.NV0Int;
import fr.cea.nabla.interpreter.values.NV0Real;
import fr.cea.nabla.interpreter.values.NV1Bool;
import fr.cea.nabla.interpreter.values.NV1Int;
import fr.cea.nabla.interpreter.values.NV1Real;
import fr.cea.nabla.interpreter.values.NV2Bool;
import fr.cea.nabla.interpreter.values.NV2Int;
import fr.cea.nabla.interpreter.values.NV2Real;
import fr.cea.nabla.interpreter.values.NV3Int;
import fr.cea.nabla.interpreter.values.NV3Real;
import fr.cea.nabla.interpreter.values.NV4Int;
import fr.cea.nabla.interpreter.values.NV4Real;

@GenerateWrapper
@TypeSystemReference(NablaTypes.class)
@NodeInfo(description = "The abstract base node for all expressions")
public abstract class NablaExpressionNode extends NablaNode {

	private boolean hasExpressionTag;
	
	@Override
    public boolean hasTag(Class<? extends Tag> tag) {
        if (tag == StandardTags.ExpressionTag.class) {
            return hasExpressionTag;
        }
        return super.hasTag(tag);
    }
	
	public final void addExpressionTag() {
        hasExpressionTag = true;
    }
	
	public NV0Bool executeNV0Bool(VirtualFrame frame) throws UnexpectedResultException {
		return NablaTypesGen.expectNV0Bool(executeGeneric(frame));
	}
	
	public NV0Int executeNV0Int(VirtualFrame frame) throws UnexpectedResultException {
		return NablaTypesGen.expectNV0Int(executeGeneric(frame));
	}
	
	public NV0Real executeNV0Real(VirtualFrame frame) throws UnexpectedResultException {
		return NablaTypesGen.expectNV0Real(executeGeneric(frame));
	}
	
	public NV1Bool executeNV1Bool(VirtualFrame frame) throws UnexpectedResultException {
		return NablaTypesGen.expectNV1Bool(executeGeneric(frame));
	}
	
	public NV1Int executeNV1Int(VirtualFrame frame) throws UnexpectedResultException {
		return NablaTypesGen.expectNV1Int(executeGeneric(frame));
	}
	
	public NV1Real executeNV1Real(VirtualFrame frame) throws UnexpectedResultException {
		return NablaTypesGen.expectNV1Real(executeGeneric(frame));
	}
	
	public NV2Bool executeNV2Bool(VirtualFrame frame) throws UnexpectedResultException {
		return NablaTypesGen.expectNV2Bool(executeGeneric(frame));
	}
	
	public NV2Int executeNV2Int(VirtualFrame frame) throws UnexpectedResultException {
		return NablaTypesGen.expectNV2Int(executeGeneric(frame));
	}
	
	public NV2Real executeNV2Real(VirtualFrame frame) throws UnexpectedResultException {
		return NablaTypesGen.expectNV2Real(executeGeneric(frame));
	}
	
	public NV3Int executeNV3Int(VirtualFrame frame) throws UnexpectedResultException {
		return NablaTypesGen.expectNV3Int(executeGeneric(frame));
	}
	
	public NV3Real executeNV3Real(VirtualFrame frame) throws UnexpectedResultException {
		return NablaTypesGen.expectNV3Real(executeGeneric(frame));
	}
	
	public NV4Int executeNV4Int(VirtualFrame frame) throws UnexpectedResultException {
		return NablaTypesGen.expectNV4Int(executeGeneric(frame));
	}
	
	public NV4Real executeNV4Real(VirtualFrame frame) throws UnexpectedResultException {
		return NablaTypesGen.expectNV4Real(executeGeneric(frame));
	}
	
	@Override
	public WrapperNode createWrapper(ProbeNode probe) {
		return new NablaExpressionNodeWrapper(this, probe);
	}
	
}
