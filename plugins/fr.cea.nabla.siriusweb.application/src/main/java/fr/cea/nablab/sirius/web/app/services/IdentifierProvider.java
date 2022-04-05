/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nablab.sirius.web.app.services;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.util.EcoreUtil;
import org.eclipse.sirius.components.compatibility.api.IIdentifierProvider;
import org.springframework.stereotype.Service;

/**
 * @author arichard
 */
@Service
public class IdentifierProvider implements IIdentifierProvider {

    Map<UUID, String> idToVSmURIMap = new HashMap<>();

    @Override
    public String getIdentifier(Object element) {
        // @formatter:off
        String vsmElementId = Optional.of(element).filter(EObject.class::isInstance)
                .map(EObject.class::cast)
                .map(EcoreUtil::getURI)
                .map(Object::toString)
                .orElse(""); //$NON-NLS-1$

        UUID uuid = UUID.nameUUIDFromBytes(vsmElementId.getBytes());
        this.idToVSmURIMap.put(uuid, vsmElementId);
        return uuid.toString();
        // @formatter:on
    }

    @Override
    public Optional<String> findVsmElementId(UUID id) {
        return Optional.ofNullable(this.idToVSmURIMap.get(id));
    }
}
