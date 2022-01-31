/*******************************************************************************
 * Copyright (c) 2022 Obeo.
 * This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v2.0
 * which accompanies this distribution, and is available at
 * https://www.eclipse.org/legal/epl-2.0/
 *
 * SPDX-License-Identifier: EPL-2.0
 *
 * Contributors:
 *     Obeo - initial API and implementation
 *******************************************************************************/
package fr.cea.nablab.sirius.web.app.services.representations;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.eclipse.sirius.components.core.RepresentationMetadata;
import org.eclipse.sirius.components.core.api.IRepresentationMetadataSearchService;
import org.eclipse.sirius.components.diagrams.Diagram;
import org.eclipse.sirius.components.representations.IRepresentation;
import org.springframework.stereotype.Service;

/**
 * Used to find the metadata of a representation.
 *
 * @author sbegaudeau
 */
@Service
public class RepresentationMetadataSearchService implements IRepresentationMetadataSearchService {

    @Override
    public Optional<RepresentationMetadata> findByRepresentation(IRepresentation representation) {
        return Optional.of(new RepresentationMetadata(representation.getId(), representation.getKind(), representation.getLabel(), representation.getDescriptionId()));
    }

    @Override
    public List<RepresentationMetadata> findAll(String targetObjectId) {
        String volatileRepresentation = UUID.nameUUIDFromBytes("volatileRepresentation".getBytes()).toString(); //$NON-NLS-1$
        return List.of(new RepresentationMetadata("volatileRepresentation_" + targetObjectId, "", Diagram.KIND, UUID.fromString("7a08b478-2284-36b2-8e00-b5d3cdeaaaa5"))); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
    }

}
