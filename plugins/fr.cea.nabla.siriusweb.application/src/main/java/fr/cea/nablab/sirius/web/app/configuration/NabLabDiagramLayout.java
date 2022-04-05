/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nablab.sirius.web.app.configuration;

import fr.cea.nabla.ir.ir.Job;

import java.util.EnumSet;
import java.util.Objects;
import java.util.Optional;

import org.eclipse.elk.alg.layered.options.LayeredOptions;
import org.eclipse.elk.alg.layered.options.LayeringStrategy;
import org.eclipse.elk.core.math.ElkPadding;
import org.eclipse.elk.core.math.KVector;
import org.eclipse.elk.core.options.CoreOptions;
import org.eclipse.elk.core.options.Direction;
import org.eclipse.elk.core.options.EdgeRouting;
import org.eclipse.elk.core.options.HierarchyHandling;
import org.eclipse.elk.core.options.NodeLabelPlacement;
import org.eclipse.elk.core.options.PortAlignment;
import org.eclipse.elk.core.options.PortConstraints;
import org.eclipse.elk.core.options.PortLabelPlacement;
import org.eclipse.elk.core.options.PortSide;
import org.eclipse.elk.core.options.SizeConstraint;
import org.eclipse.elk.graph.ElkLabel;
import org.eclipse.elk.graph.ElkNode;
import org.eclipse.elk.graph.ElkPort;
import org.eclipse.emf.common.util.EList;
import org.eclipse.sirius.components.core.api.IEditingContext;
import org.eclipse.sirius.components.diagrams.Diagram;
import org.eclipse.sirius.components.diagrams.Node;
import org.eclipse.sirius.components.diagrams.NodeType;
import org.eclipse.sirius.components.diagrams.description.DiagramDescription;
import org.eclipse.sirius.components.diagrams.layout.ELKDiagramConverter;
import org.eclipse.sirius.components.diagrams.layout.IDiagramLayoutConfiguratorProvider;
import org.eclipse.sirius.components.diagrams.layout.ISiriusWebLayoutConfigurator;
import org.eclipse.sirius.components.diagrams.layout.SiriusWebLayoutConfigurator;
import org.eclipse.sirius.components.emf.services.ObjectService;
import org.springframework.stereotype.Component;

/**
 * @author arichard
 */
@Component
public class NabLabDiagramLayout implements IDiagramLayoutConfiguratorProvider {

    /**
     * The padding value.
     */
    private static final int PADDING = 30;

    /**
     * The minimum height constraint value.
     */
    private static final int MIN_HEIGHT_CONSTRAINT = 40;

    /**
     * The minimum width constraint value.
     */
    private static final int MIN_WIDTH_CONSTRAINT = 150;

    /**
     * The space between node and edges.
     */
    private static final Double SPACING_NODE_EDGE = Double.valueOf(40.0);

    /**
     * Diagram description label
     */
    private static final String DIAGRAM_DESCRIPTION_LABEL = "NablaIrDiagram"; //$NON-NLS-1$

    private final ObjectService objectService;

    public NabLabDiagramLayout(ObjectService objectService) {
        this.objectService = Objects.requireNonNull(objectService);
    }

    @Override
    public Optional<ISiriusWebLayoutConfigurator> getLayoutConfigurator(Diagram diagram, DiagramDescription diagramDescription) {
        if (diagramDescription.getLabel().equals(DIAGRAM_DESCRIPTION_LABEL)) {
            // @formatter:off
               SiriusWebLayoutConfigurator configurator = new SiriusWebLayoutConfigurator() {
                    @Override
                    public ElkNode applyBeforeLayout(ElkNode elkDiagram, IEditingContext editingContext, Diagram diagram) {
                        elkDiagram.getChildren().forEach(n -> {
                            n.setProperty(CoreOptions.PARTITIONING_PARTITION, this.getLevel(diagram, editingContext, n.getLabels().get(0).getText()));
                        });
                        return elkDiagram;
                    }

                    @Override
                    public ElkNode applyAfterLayout(ElkNode elkDiagram, IEditingContext editingContext, Diagram diagram) {

                        elkDiagram.getChildren().forEach(n -> {
                            EList<ElkPort> ports = n.getPorts();
                            for (ElkPort elkPort : ports) {
                                EList<ElkLabel> labels = elkPort.getLabels();
                                for (ElkLabel elkPortLabel : labels) {
                                    elkPortLabel.setLocation(elkPortLabel.getX() + 10, elkPortLabel.getY() + 10);
                                }
                            }
                        });

                        return super.applyAfterLayout(elkDiagram, editingContext, diagram);
                    }

                    protected Integer getLevel(Diagram diagram, IEditingContext editingContext, String nodeName) {
                        for (Node node : diagram.getNodes()) {
                            if (nodeName.equals(node.getTargetObjectLabel())) {
                                var targetObjectId = node.getTargetObjectId();
                                var targetObject = NabLabDiagramLayout.this.objectService.getObject(editingContext, targetObjectId);

                                if (targetObject.isPresent() && targetObject.get() instanceof Job) {
                                    return Double.valueOf(((Job)targetObject.get()).getAt()).intValue();
                                }
                            }
                        }
                        return 1;
                    }
               };

               configurator.configureByType(ELKDiagramConverter.DEFAULT_DIAGRAM_TYPE)
                       .setProperty(CoreOptions.ALGORITHM, LayeredOptions.ALGORITHM_ID)
                       .setProperty(CoreOptions.HIERARCHY_HANDLING, HierarchyHandling.INCLUDE_CHILDREN)
                       .setProperty(LayeredOptions.LAYERING_STRATEGY, LayeringStrategy.NETWORK_SIMPLEX)
                       .setProperty(LayeredOptions.DIRECTION, Direction.DOWN)
                       .setProperty(CoreOptions.SPACING_COMPONENT_COMPONENT, 10.0)
                       .setProperty(CoreOptions.EDGE_ROUTING, EdgeRouting.ORTHOGONAL)
                       .setProperty(CoreOptions.PORT_ALIGNMENT_DEFAULT, PortAlignment.CENTER)
                       .setProperty(CoreOptions.PARTITIONING_ACTIVATE, true)
                       //.setProperty(CoreOptions.PARTITIONING_PARTITION, null)
               ;

               configurator.configureByType(NodeType.NODE_RECTANGLE)
                       .setProperty(LayeredOptions.SPACING_EDGE_NODE, SPACING_NODE_EDGE)
                       .setProperty(CoreOptions.PADDING, new ElkPadding(PADDING))
                       .setProperty(CoreOptions.NODE_SIZE_CONSTRAINTS, SizeConstraint.free())
                       .setProperty(CoreOptions.NODE_SIZE_MINIMUM, new KVector(MIN_WIDTH_CONSTRAINT, MIN_HEIGHT_CONSTRAINT))
                       .setProperty(CoreOptions.NODE_LABELS_PLACEMENT, EnumSet.of(NodeLabelPlacement.H_CENTER, NodeLabelPlacement.V_CENTER, NodeLabelPlacement.INSIDE))
                       .setProperty(CoreOptions.PORT_CONSTRAINTS, PortConstraints.FIXED_SIDE)
                       .setProperty(CoreOptions.PORT_SIDE, PortSide.EAST)
                       .setProperty(CoreOptions.PORT_BORDER_OFFSET, Double.valueOf(-10.0))
                       .setProperty(CoreOptions.PORT_LABELS_PLACEMENT, EnumSet.of(PortLabelPlacement.ALWAYS_SAME_SIDE))
               ;
               // @formatter:on

            return Optional.of(configurator);
        }

        return Optional.empty();
    }

}
