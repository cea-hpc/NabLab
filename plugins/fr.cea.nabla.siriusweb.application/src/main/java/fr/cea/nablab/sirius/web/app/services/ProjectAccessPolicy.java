/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nablab.sirius.web.app.services;

import java.util.Optional;
import java.util.UUID;

import org.eclipse.sirius.web.services.api.projects.AccessLevel;
import org.eclipse.sirius.web.services.api.projects.IProjectAccessPolicy;
import org.springframework.stereotype.Service;

/**
 * The access policy of Sirius Web.
 *
 * @author arichard
 */
@Service
public class ProjectAccessPolicy implements IProjectAccessPolicy {

    @Override
    public Optional<AccessLevel> getAccessLevel(String username, UUID projectId) {
        return Optional.of(AccessLevel.ADMIN);
    }

    @Override
    public boolean canEdit(String username, UUID projectId) {
        return true;
    }

    @Override
    public boolean canAdmin(String username, UUID projectId) {
        return true;
    }

}
