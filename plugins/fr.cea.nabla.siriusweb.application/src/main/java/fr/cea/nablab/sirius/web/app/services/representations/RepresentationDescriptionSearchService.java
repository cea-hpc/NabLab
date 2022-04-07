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

import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.UUID;

import org.eclipse.sirius.components.core.api.IEditingContext;
import org.eclipse.sirius.components.core.api.IRepresentationDescriptionSearchService;
import org.eclipse.sirius.components.representations.IRepresentationDescription;

/**
 * @author arichard
 */
public class RepresentationDescriptionSearchService implements IRepresentationDescriptionSearchService {

    private final RepresentationDescriptionRegistry registry;

    public RepresentationDescriptionSearchService(RepresentationDescriptionRegistry registry) {
        this.registry = Objects.requireNonNull(registry);
    }

    @Override
    public Optional<IRepresentationDescription> findById(IEditingContext editingContext, UUID representationDescriptionId) {
        return Optional.ofNullable(this.findAll(editingContext).get(representationDescriptionId));
    }

    @Override
    public Map<UUID, IRepresentationDescription> findAll(IEditingContext editingContext) {
        Map<UUID, IRepresentationDescription> allRepresentationDescriptions = new LinkedHashMap<>();
        this.registry.getRepresentationDescriptions().forEach(representationDescription -> {
            allRepresentationDescriptions.put(representationDescription.getId(), representationDescription);
        });
        return allRepresentationDescriptions;
    }

}
