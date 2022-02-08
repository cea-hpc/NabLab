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
 * Interface used to represent a viewer, the root element a the SiriusWeb GraphQL schema.
 *
 * @author arichard
 */
public interface IViewer {
    UUID getId();

    String getUsername();
}
