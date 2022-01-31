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

import java.util.Collections;
import java.util.List;

import org.eclipse.sirius.components.emf.view.IJavaServiceProvider;
import org.eclipse.sirius.components.view.View;
import org.eclipse.sirius.ext.emf.edit.EditingDomainServices;
import org.springframework.stereotype.Service;

/**
 * Provider for {@link org.eclipse.sirius.ext.emf.edit.EditingDomainServices} services.
 *
 * @author arichard
 */
@Service
public class EditingDomainServicesProvider implements IJavaServiceProvider {

    @Override
    public List<Class<?>> getServiceClasses(View view) {
        return Collections.singletonList(EditingDomainServices.class);
    }

}
