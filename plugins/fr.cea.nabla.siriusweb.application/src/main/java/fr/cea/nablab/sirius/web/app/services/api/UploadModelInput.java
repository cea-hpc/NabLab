/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nablab.sirius.web.app.services.api;

import java.text.MessageFormat;
import java.util.Objects;
import java.util.UUID;

import org.eclipse.sirius.components.core.api.IInput;

/**
 * @author arichard
 */
public class UploadModelInput implements IInput {

    private UUID id;

    private String model;

    public UploadModelInput() {
        // Used by Jackson
    }

    public UploadModelInput(UUID id, String model) {
        this.id = Objects.requireNonNull(id);
        this.model = Objects.requireNonNull(model);
    }

    @Override
    public UUID getId() {
        return this.id;
    }

    public String getModel() {
        return this.model;
    }

    @Override
    public String toString() {
        String pattern = "{0} '{'id: {1}'}'"; //$NON-NLS-1$
        return MessageFormat.format(pattern, this.getClass().getSimpleName(), this.id);
    }

}
