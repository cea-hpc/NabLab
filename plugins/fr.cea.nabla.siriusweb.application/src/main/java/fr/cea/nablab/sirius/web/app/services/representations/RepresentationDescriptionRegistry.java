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

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

import org.eclipse.sirius.components.core.configuration.IRepresentationDescriptionRegistry;
import org.eclipse.sirius.components.representations.IRepresentationDescription;

/**
 * Registry containing all the representation descriptions.
 *
 * @author arichard
 */
public class RepresentationDescriptionRegistry implements IRepresentationDescriptionRegistry {

    private final Map<UUID, IRepresentationDescription> id2representationDescriptions = new HashMap<>();

    @Override
    public void add(IRepresentationDescription representationDescription) {
        this.id2representationDescriptions.put(representationDescription.getId(), representationDescription);
    }

    public Optional<IRepresentationDescription> getRepresentationDescription(UUID id) {
        return Optional.ofNullable(this.id2representationDescriptions.get(id));
    }

    public List<IRepresentationDescription> getRepresentationDescriptions() {
        return this.id2representationDescriptions.values().stream().collect(Collectors.toList());
    }

}
