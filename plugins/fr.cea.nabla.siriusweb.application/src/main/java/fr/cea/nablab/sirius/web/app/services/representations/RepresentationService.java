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

import java.util.Map;
import java.util.Optional;
import java.util.concurrent.ConcurrentHashMap;

import org.eclipse.sirius.web.core.api.IEditingContext;
import org.eclipse.sirius.web.representations.IRepresentation;
import org.eclipse.sirius.web.representations.ISemanticRepresentation;
import org.eclipse.sirius.web.spring.collaborative.api.IRepresentationPersistenceService;
import org.eclipse.sirius.web.spring.collaborative.api.IRepresentationSearchService;
import org.springframework.stereotype.Service;

/**
 * Mandatory service. Do not remove. Empty implementation for the NabLab use case.
 *
 * @author arichard
 */
@Service
public class RepresentationService implements IRepresentationPersistenceService, IRepresentationSearchService {

    private final Map<String, IRepresentation> representations = new ConcurrentHashMap<>();

    @Override
    public void save(IEditingContext editingContext, ISemanticRepresentation representation) {
        this.representations.put(representation.getId(), representation);
    }

    @Override
    public <T extends IRepresentation> Optional<T> findById(IEditingContext editingContext, String representationId, Class<T> representationClass) {
        return Optional.ofNullable(this.representations.get(representationId)).filter(representationClass::isInstance).map(representationClass::cast);
    }

}
