/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nablab.sirius.web.app.services.editingcontext;

import org.eclipse.sirius.components.core.api.IEditingContext;
import org.eclipse.sirius.components.core.api.IEditingContextPersistenceService;
import org.springframework.stereotype.Service;

/**
 * @author arichard
 */
@Service
public class EditingContextPersistenceService implements IEditingContextPersistenceService {

    @Override
    public void persist(IEditingContext editingContext) {
        // do nothing
    }

}
