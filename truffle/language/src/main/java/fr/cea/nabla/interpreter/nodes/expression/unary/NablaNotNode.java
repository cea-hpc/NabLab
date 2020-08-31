package fr.cea.nabla.interpreter.nodes.expression.unary;

import com.oracle.truffle.api.dsl.Fallback;
import com.oracle.truffle.api.dsl.NodeChild;
import com.oracle.truffle.api.dsl.Specialization;
import com.oracle.truffle.api.nodes.NodeInfo;

import fr.cea.nabla.interpreter.NablaException;
import fr.cea.nabla.interpreter.nodes.expression.NablaExpressionNode;
import fr.cea.nabla.interpreter.values.NV0Bool;

@NodeChild("valueNode")
@NodeInfo(shortName = "!")
public abstract class NablaNotNode extends NablaExpressionNode {

	@Specialization
    protected NV0Bool not(NV0Bool value) {
        return new NV0Bool(!value.isData());
    }

    @Fallback
    protected Object typeError(Object value) {
        throw NablaException.typeError(this, value);
    }
}
