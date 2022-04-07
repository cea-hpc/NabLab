/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nablab.sirius.web.app.services.dto;

import java.util.UUID;

/**
 * @author arichard
 */
public class User implements IViewer {
    private final UUID id = UUID.nameUUIDFromBytes("system".getBytes()); //$NON-NLS-1$

    private final String username = "system"; //$NON-NLS-1$

    public User() {
    }

    @Override
    public UUID getId() {
        return this.id;
    }

    @Override
    public String getUsername() {
        return this.username;
    }
}
