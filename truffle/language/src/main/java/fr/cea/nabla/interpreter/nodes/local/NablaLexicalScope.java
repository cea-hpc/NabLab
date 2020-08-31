package fr.cea.nabla.interpreter.nodes.local;

import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Objects;

import com.oracle.truffle.api.CompilerDirectives.TruffleBoundary;
import com.oracle.truffle.api.frame.Frame;
import com.oracle.truffle.api.frame.FrameSlot;
import com.oracle.truffle.api.instrumentation.InstrumentableNode.WrapperNode;
import com.oracle.truffle.api.interop.InteropLibrary;
import com.oracle.truffle.api.interop.InvalidArrayIndexException;
import com.oracle.truffle.api.interop.TruffleObject;
import com.oracle.truffle.api.interop.UnknownIdentifierException;
import com.oracle.truffle.api.interop.UnsupportedMessageException;
import com.oracle.truffle.api.library.ExportLibrary;
import com.oracle.truffle.api.library.ExportMessage;
import com.oracle.truffle.api.nodes.Node;
import com.oracle.truffle.api.nodes.NodeUtil;
import com.oracle.truffle.api.nodes.NodeVisitor;
import com.oracle.truffle.api.nodes.RootNode;

import fr.cea.nabla.interpreter.nodes.NablaModuleNode;
import fr.cea.nabla.interpreter.nodes.NablaModulePrologNode;
import fr.cea.nabla.interpreter.nodes.NablaNode;
import fr.cea.nabla.interpreter.nodes.NablaRootNode;
import fr.cea.nabla.interpreter.nodes.expression.NablaReadArgumentNode;
import fr.cea.nabla.interpreter.nodes.instruction.NablaInstructionBlockNode;
import fr.cea.nabla.interpreter.nodes.instruction.NablaInstructionNode;
import fr.cea.nabla.interpreter.nodes.instruction.NablaPrologBlockNode;
import fr.cea.nabla.interpreter.nodes.instruction.NablaWriteVariableNode;
import fr.cea.nabla.interpreter.runtime.NablaInternalError;
import fr.cea.nabla.interpreter.runtime.NablaNull;

/**
 * Simple language lexical scope. There can be a block scope, or function scope.
 */
public final class NablaLexicalScope {

	private final Node current;
	private final NablaNode block;
	private final NablaNode parentBlock;
	private final NablaRootNode root;
	private NablaLexicalScope parent;
	private Map<String, FrameSlot> varSlots;

	/**
	 * Create a new block Nabla lexical scope.
	 *
	 * @param current     the current node
	 * @param block       a nearest block enclosing the current node
	 * @param parentBlock a next parent block
	 */
	private NablaLexicalScope(Node current, NablaNode block, NablaNode parentBlock) {
		this.current = current;
		this.block = block;
		this.parentBlock = parentBlock;
		this.root = null;
	}

	/**
	 * Create a new functional Nabla lexical scope.
	 *
	 * @param current the current node, or <code>null</code> when it would be above
	 *                the block
	 * @param block   a nearest block enclosing the current node
	 * @param root    a functional root node for top-most block
	 */
	private NablaLexicalScope(Node current, NablaNode block, NablaRootNode root) {
		this.current = current;
		this.block = block;
		this.parentBlock = null;
		this.root = root;
	}

	@SuppressWarnings("all")
	public static NablaLexicalScope createScope(Node node, Frame frame) {
//		if (node instanceof NablaModuleNode) {
//			return new NablaLexicalScope(node, (NablaModuleNode) node, (NablaRootNode) node.getRootNode());
//		}
		
		assert !isInProlog(node) : "Should not try to get scope from prolog node: " + node;
		
		NablaNode block = getParentBlock(node);
		
		if (block == null) {
			block = findChildrenBlock(node);
			if (block == null) {
				NablaInternalError.shouldNotReachHere("Corrupted AST, no block found");
			}
		}
		
		NablaNode parentBlock = getParentBlock(block);
		
		if (parentBlock == null) {
			return new NablaLexicalScope(node, block, (NablaRootNode) block.getRootNode());
		} else {
			return new NablaLexicalScope(node, block, parentBlock);
		}
	}

	private static boolean isInProlog(Node node) {
		if (node instanceof NablaPrologBlockNode) {
			return true;
		} else {
			Node parent = node.getParent();
			while (parent != null && !(parent instanceof NablaPrologBlockNode)) {
				parent = parent.getParent();
			}
			return parent != null;
		}
	}
	
	private static NablaInstructionBlockNode getParentBlock(Node node) {
		NablaInstructionBlockNode block = null;
		Node parent = null;
		if (node instanceof NablaInstructionBlockNode) {
			parent = node.getParent();
		} else {
			parent = node;
		}
		while (parent != null && block == null) {
			if (parent instanceof NablaInstructionBlockNode && !(parent instanceof WrapperNode)) {
				block = (NablaInstructionBlockNode) parent;
			} else {
				parent = parent.getParent();
			}
		}
		return block;
	}

	public NablaLexicalScope findParent() {
		if (parentBlock == null) {
			// This was a root scope.
			return null;
		}
		if (parent == null) {
			Node node = block;
			NablaNode newBlock = parentBlock;
			// Test if there is a next parent block. If not, we're in the root scope.
			NablaNode newParentBlock = getParentBlock(newBlock);
			if (newParentBlock == null) {
				parent = new NablaLexicalScope(node, newBlock, (NablaRootNode) newBlock.getRootNode());
			} else {
				parent = new NablaLexicalScope(node, newBlock, newParentBlock);
			}
		}
		return parent;
	}
	
	private static NablaInstructionBlockNode findChildrenBlock(Node node) {
		NablaInstructionBlockNode[] blockPtr = new NablaInstructionBlockNode[1];
        node.accept(new NodeVisitor() {
            @Override
            public boolean visit(Node n) {
                if (n instanceof NablaInstructionBlockNode) {
                    blockPtr[0] = (NablaInstructionBlockNode) n;
                    return false;
                } else {
                    return true;
                }
            }
        });
        return blockPtr[0];
    }

	/**
	 * @return the function name for function scope, "block" otherwise.
	 */
	public String getName() {
		if (root != null) {
			return root.getName();
		} else {
			return "block";
		}
	}

	/**
	 * @return the node representing the scope, the block node for block scopes and
	 *         the {@link RootNode} for functional scope.
	 */
	public Node getNode() {
		if (root != null) {
			return root;
		} else {
			return block;
		}
	}

	public Object getVariables(Frame frame) {
		Map<String, FrameSlot> vars = getVars();
		Object[] args = null;
		// Use arguments when the current node is above the block
		if (current == null) {
			args = (frame != null) ? frame.getArguments() : null;
		}
		return new VariablesMapObject(vars, args, frame);
	}

	public Object getArguments(Frame frame) {
		if (root == null) {
			// No arguments for block scope
			return null;
		}
		// The slots give us names of the arguments:
		Map<String, FrameSlot> argSlots = collectArgs(root);
		// The frame's arguments array give us the argument values:
		Object[] frameArgs = frame.getArguments();
		Object[] args;
		if (frameArgs.length > 0) {
			args = (frame != null) ? Arrays.copyOfRange(frameArgs, 2, frameArgs.length) : null;
		} else {
			args = new Object[0];
		}
		// Create a TruffleObject having the arguments as properties:
		return new VariablesMapObject(argSlots, args, frame);
	}

	private Map<String, FrameSlot> getVars() {
		if (varSlots == null) {
			if (current instanceof NablaModuleNode) {
				varSlots = collectModuleVars(current);
			} else {
				if (root == null) {
					varSlots = collectVars(block, current);
				} else {
					varSlots = collectArgs(root);
				}
			}
			
		}
		return varSlots;
	}

	private boolean hasParentVar(String name) {
		NablaLexicalScope p = this;
		while ((p = p.findParent()) != null) {
			if (p.getVars().containsKey(name)) {
				return true;
			}
		}
		return false;
	}
	
	private Map<String, FrameSlot> collectModuleVars(Node currentNode) {
		Map<String, FrameSlot> slots = new LinkedHashMap<>(4);
		NodeUtil.forEachChild(current, new NodeVisitor() {
			@Override
			public boolean visit(Node node) {
				if (node instanceof NablaModulePrologNode) {
					boolean all = NodeUtil.forEachChild(node, new NodeVisitor() {
						@Override
						public boolean visit(Node prologNode) {
							if (prologNode instanceof NablaWriteVariableNode) {
								final NablaWriteVariableNode wn = (NablaWriteVariableNode) prologNode;
								final String name = Objects.toString(wn.getSlot().getIdentifier());
								final FrameSlot slot = wn.getSlot();
								slots.put(name, slot);
							}
							return true;
						}
					});
					if (!all) {
						return false;
					}
				}
				return true;
			}
		});
		return slots;
	}

	private Map<String, FrameSlot> collectVars(Node varsBlock, Node currentNode) {
		// Variables are slot-based. To collect declared variables, traverse the block's AST and find slots
		// associated with NablaWriteVariableNode. The traversal stops when we hit the current node.
		Map<String, FrameSlot> slots = new LinkedHashMap<>(4);
		NodeUtil.forEachChild(varsBlock, new NodeVisitor() {
			@Override
			public boolean visit(Node node) {
				if (node == currentNode) {
					return false;
				}
				// Do not enter any nested blocks.
				if (!(node instanceof NablaInstructionBlockNode)) {
					boolean all = NodeUtil.forEachChild(node, this);
					if (!all) {
						return false;
					}
				}
				// Write to a variable is a declaration unless it exists already in a parent scope.
				if (node instanceof NablaWriteVariableNode) {
					NablaWriteVariableNode wn = (NablaWriteVariableNode) node;
					String name = Objects.toString(wn.getSlot().getIdentifier());
					if (!hasParentVar(name)) {
						slots.put(name, wn.getSlot());
					}
				}
				return true;
			}
		});
		return slots;
	}

	private static Map<String, FrameSlot> collectArgs(NablaRootNode root) {
		// Arguments are pushed to frame slots at the beginning of the function block.
		// To collect argument slots, search for NablaReadArgumentNode inside of NablaWriteVariableNode.
		Map<String, FrameSlot> args = new LinkedHashMap<>(4);
		NodeUtil.forEachChild(root, new NodeVisitor() {

			private NablaWriteVariableNode wn; // The current write node containing a slot

			@Override
			public boolean visit(Node node) {
				// When there is a write node, search for SLReadArgumentNode among its children:
				if (node instanceof NablaWriteVariableNode) {
					wn = (NablaWriteVariableNode) node;
					boolean all = NodeUtil.forEachChild(node, this);
					wn = null;
					return all;
				} else if (wn != null && (node instanceof NablaReadArgumentNode)) {
					FrameSlot slot = wn.getSlot();
					String name = Objects.toString(slot.getIdentifier());
					assert !args.containsKey(name) : name + " argument exists already.";
					args.put(name, slot);
					return true;
				} else if (wn == null && (node instanceof NablaInstructionNode) && !(node instanceof NablaPrologBlockNode)) {
					// A different node - we're done.
					return false;
				} else {
					return NodeUtil.forEachChild(node, this);
				}
			}
		});
		return args;
	}
	
	@ExportLibrary(InteropLibrary.class)
	static final class VariablesMapObject implements TruffleObject {

        final Map<String, ? extends FrameSlot> slots;
        final Object[] args;
        final Frame frame;

        private VariablesMapObject(Map<String, ? extends FrameSlot> slots, Object[] args, Frame frame) {
            this.slots = slots;
            this.args = args;
            this.frame = frame;
        }

        @SuppressWarnings("static-method")
        @ExportMessage
        boolean hasMembers() {
            return true;
        }

        @ExportMessage
        @TruffleBoundary
        Object getMembers(@SuppressWarnings("unused") boolean includeInternal) {
            return new KeysArray(slots.keySet().toArray(new String[0]));
        }

        @ExportMessage
        @TruffleBoundary
        void writeMember(String member, Object value) throws UnsupportedMessageException, UnknownIdentifierException {
            if (frame == null) {
                throw UnsupportedMessageException.create();
            }
            FrameSlot slot = slots.get(member);
            if (slot == null) {
                throw UnknownIdentifierException.create(member);
            } else {
                Object info = slot.getInfo();
                if (args != null && info != null) {
                    args[(Integer) info] = value;
                } else {
                    frame.setObject(slot, value);
                }
            }
        }

        @ExportMessage
        @TruffleBoundary
        Object readMember(String member) throws UnknownIdentifierException {
            if (frame == null) {
                return NablaNull.SINGLETON;
            }
            FrameSlot slot = slots.get(member);
            if (slot == null) {
                throw UnknownIdentifierException.create(member);
            } else {
                Object value;
                Object info = slot.getInfo();
                if (args != null && info != null) {
                    value = args[(Integer) info];
                } else {
                    value = frame.getValue(slot);
                }
                return value;
            }
        }

        @SuppressWarnings("static-method")
        @ExportMessage
        boolean isMemberInsertable(@SuppressWarnings("unused") String member) {
            return false;
        }

        @ExportMessage
        @TruffleBoundary
        boolean isMemberModifiable(String member) {
            return slots.containsKey(member);
        }

        @ExportMessage
        @TruffleBoundary
        boolean isMemberReadable(String member) {
            return frame == null || slots.containsKey(member);
        }

    }

    @ExportLibrary(InteropLibrary.class)
    static final class KeysArray implements TruffleObject {

        private final String[] keys;

        KeysArray(String[] keys) {
            this.keys = keys;
        }

        @SuppressWarnings("static-method")
        @ExportMessage
        boolean hasArrayElements() {
            return true;
        }

        @ExportMessage
        boolean isArrayElementReadable(long index) {
            return index >= 0 && index < keys.length;
        }

        @ExportMessage
        long getArraySize() {
            return keys.length;
        }

        @ExportMessage
        Object readArrayElement(long index) throws InvalidArrayIndexException {
            if (!isArrayElementReadable(index)) {
                throw InvalidArrayIndexException.create(index);
            }
            return keys[(int) index];
        }

    }
}
