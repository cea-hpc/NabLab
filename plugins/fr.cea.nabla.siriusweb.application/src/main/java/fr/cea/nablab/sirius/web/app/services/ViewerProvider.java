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

import org.eclipse.sirius.web.graphql.datafetchers.IViewerProvider;
import org.eclipse.sirius.web.services.api.viewer.IViewer;
import org.eclipse.sirius.web.services.api.viewer.User;
import org.springframework.stereotype.Service;

import graphql.schema.DataFetchingEnvironment;

/**
 * Service used to retrieve the current viewer.
 *
 * @author arichard
 */
@Service
public class ViewerProvider implements IViewerProvider {
    @Override
    public Optional<IViewer> getViewer(DataFetchingEnvironment environment) {
        return Optional.of(new User(UUID.randomUUID(), "system")); //$NON-NLS-1$
    }

}
