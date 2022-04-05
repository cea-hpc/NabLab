/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nablab.sirius.web.app.services.representations;

import java.util.Objects;
import java.util.UUID;

import org.eclipse.sirius.components.annotations.Immutable;
import org.eclipse.sirius.components.representations.IRepresentation;

/**
 * The representation descriptor.
 *
 * @author arichard
 */
@Immutable
public final class RepresentationDescriptor {
    private UUID id;

    private UUID projectId;

    private UUID descriptionId;

    private String targetObjectId;

    private String label;

    private IRepresentation representation;

    private RepresentationDescriptor() {
        // Prevent instantiation
    }

    public UUID getId() {
        return this.id;
    }

    public UUID getProjectId() {
        return this.projectId;
    }

    public UUID getDescriptionId() {
        return this.descriptionId;
    }

    public String getTargetObjectId() {
        return this.targetObjectId;
    }

    public String getLabel() {
        return this.label;
    }

    public IRepresentation getRepresentation() {
        return this.representation;
    }

    public static Builder newRepresentationDescriptor(UUID id) {
        return new Builder(id);
    }

    /**
     * The builder used to create the RepresentationDescriptor.
     *
     * @author gcoutable
     */
    @SuppressWarnings("checkstyle:HiddenField")
    public static final class Builder {
        private UUID id;

        private UUID projectId;

        private UUID descriptionId;

        private String targetObjectId;

        private String label;

        private IRepresentation representation;

        public Builder(UUID id) {
            this.id = Objects.requireNonNull(id);
        }

        public Builder projectId(UUID projectId) {
            this.projectId = Objects.requireNonNull(projectId);
            return this;
        }

        public Builder descriptionId(UUID descriptionId) {
            this.descriptionId = Objects.requireNonNull(descriptionId);
            return this;
        }

        public Builder targetObjectId(String targetObjectId) {
            this.targetObjectId = Objects.requireNonNull(targetObjectId);
            return this;
        }

        public Builder label(String label) {
            this.label = Objects.requireNonNull(label);
            return this;
        }

        public Builder representation(IRepresentation representation) {
            this.representation = Objects.requireNonNull(representation);
            return this;
        }

        public RepresentationDescriptor build() {
            RepresentationDescriptor representationDescriptor = new RepresentationDescriptor();
            representationDescriptor.id = Objects.requireNonNull(this.id);
            representationDescriptor.projectId = Objects.requireNonNull(this.projectId);
            representationDescriptor.descriptionId = Objects.requireNonNull(this.descriptionId);
            representationDescriptor.targetObjectId = Objects.requireNonNull(this.targetObjectId);
            representationDescriptor.label = Objects.requireNonNull(this.label);
            representationDescriptor.representation = Objects.requireNonNull(this.representation);
            return representationDescriptor;
        }

    }
}
