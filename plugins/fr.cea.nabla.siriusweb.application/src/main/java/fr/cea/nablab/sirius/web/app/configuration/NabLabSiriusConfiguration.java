/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nablab.sirius.web.app.configuration;

import java.util.List;

import org.eclipse.sirius.components.compatibility.services.api.ISiriusConfiguration;
import org.springframework.context.annotation.Configuration;

/**
 * Configuration of the Sirius compatibility layer.
 *
 * @author arichard
 */
@Configuration
public class NabLabSiriusConfiguration implements ISiriusConfiguration {

    @Override
    public List<String> getODesignPaths() {
        return List.of("description/i1.odesign"); //$NON-NLS-1$
    }

}
