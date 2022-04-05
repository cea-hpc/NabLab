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

import fr.cea.nablab.sirius.web.app.services.api.IEditingContextService;
import fr.cea.nablab.sirius.web.app.services.api.IModelService;

import java.util.Objects;
import java.util.Optional;

import org.eclipse.sirius.components.core.api.IEditingContext;
import org.eclipse.sirius.components.core.api.IEditingContextSearchService;
import org.springframework.stereotype.Service;

import io.micrometer.core.instrument.MeterRegistry;

/**
 * @author arichard
 */
@Service
public class EditingContextSearchService implements IEditingContextSearchService {

    private final IModelService modelService;

    private IEditingContextService editingContextService;

    public EditingContextSearchService(MeterRegistry meterRegistry, IModelService modelService, IEditingContextService editingContextService) {
        this.modelService = Objects.requireNonNull(modelService);
        this.editingContextService = Objects.requireNonNull(editingContextService);
    }

    @Override
    public boolean existsById(String editingContextId) {
        return this.modelService.existsById(editingContextId);
    }

    @Override
    public Optional<IEditingContext> findById(String editingContextId) {
        IEditingContext editingContext = this.editingContextService.getEditingContext(editingContextId);
        if (editingContext == null) {
            editingContext = this.editingContextService.createEditingContext(editingContextId);
        }
        return Optional.of(editingContext);
    }

}
