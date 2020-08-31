package fr.cea.nabla.interpreter.nodes;

import com.oracle.truffle.api.CompilerDirectives.CompilationFinal;
import com.oracle.truffle.api.CompilerDirectives.TruffleBoundary;
import com.oracle.truffle.api.frame.VirtualFrame;
import com.oracle.truffle.api.instrumentation.GenerateWrapper;
import com.oracle.truffle.api.instrumentation.InstrumentableNode;
import com.oracle.truffle.api.instrumentation.ProbeNode;
import com.oracle.truffle.api.instrumentation.StandardTags;
import com.oracle.truffle.api.instrumentation.Tag;
import com.oracle.truffle.api.nodes.Node;
import com.oracle.truffle.api.nodes.RootNode;
import com.oracle.truffle.api.source.Source;
import com.oracle.truffle.api.source.SourceSection;

@GenerateWrapper
public abstract class NablaNode extends Node implements InstrumentableNode {
	
	private static final int NO_SOURCE = -1;
    private static final int UNAVAILABLE_SOURCE = -2;

    private int sourceCharIndex = NO_SOURCE;
    private int sourceLength;
	
	@Override
    @TruffleBoundary
    public SourceSection getSourceSection() {
        if (sourceCharIndex == NO_SOURCE) {
            // AST node without source
            return null;
        }
        RootNode rootNode = getRootNode();
        if (rootNode == null) {
            // not adopted yet
            return null;
        }
        SourceSection rootSourceSection = rootNode.getSourceSection();
        if (rootSourceSection == null) {
            return null;
        }
        Source source = rootSourceSection.getSource();
        if (sourceCharIndex == UNAVAILABLE_SOURCE) {
            return source.createUnavailableSection();
        } else {
            return source.createSection(sourceCharIndex, sourceLength);
        }
    }

    public final boolean hasSource() {
        return sourceCharIndex != NO_SOURCE;
    }

    public final int getSourceCharIndex() {
        return sourceCharIndex;
    }

    public final int getSourceEndIndex() {
        return sourceCharIndex + sourceLength;
    }

    public final int getSourceLength() {
        return sourceLength;
    }
    
    public final void setSourceSection(int charIndex, int length) {
        assert sourceCharIndex == NO_SOURCE : "source must only be set once";
        if (charIndex < 0) {
            throw new IllegalArgumentException("charIndex < 0");
        } else if (length < 0) {
            throw new IllegalArgumentException("length < 0");
        }
        this.sourceCharIndex = charIndex;
        this.sourceLength = length;
    }

    public final void setUnavailableSourceSection() {
        assert sourceCharIndex == NO_SOURCE : "source must only be set once";
        this.sourceCharIndex = UNAVAILABLE_SOURCE;
    }
	
	@Override
	public boolean isInstrumentable() {
		return hasSource();
	}
	
	@CompilationFinal
	private boolean hasRootBodyTag = false;
	
	@Override
	public boolean hasTag(Class<? extends Tag> tag) {
		return tag.equals(StandardTags.RootBodyTag.class) && hasRootBodyTag;
	}
	
	public final void addRootBodyTag() {
        hasRootBodyTag = true;
    }
	
	@Override
	public WrapperNode createWrapper(ProbeNode probe) {
		throw new IllegalStateException("No wrapper could be created");
	}
	
	public abstract Object executeGeneric(VirtualFrame frame);
	
}
