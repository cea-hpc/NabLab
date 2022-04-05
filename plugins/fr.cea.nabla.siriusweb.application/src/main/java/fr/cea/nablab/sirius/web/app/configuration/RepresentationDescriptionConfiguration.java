/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nablab.sirius.web.app.configuration;

import fr.cea.nablab.sirius.web.app.services.representations.RepresentationDescriptionRegistry;
import fr.cea.nablab.sirius.web.app.services.representations.RepresentationDescriptionSearchService;

import java.util.List;

import org.eclipse.sirius.components.core.configuration.IRepresentationDescriptionRegistryConfigurer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * The configuration used to provide the services related to the representation descriptions.
 *
 * @author arichard
 */
@Configuration
public class RepresentationDescriptionConfiguration {

    public RepresentationDescriptionConfiguration() {
    }

    @Bean
    public RepresentationDescriptionSearchService representationDescriptionService(List<IRepresentationDescriptionRegistryConfigurer> configurers) {
        RepresentationDescriptionRegistry registry = new RepresentationDescriptionRegistry();
        configurers.forEach(configurer -> configurer.addRepresentationDescriptions(registry));
        return new RepresentationDescriptionSearchService(registry);
    }
}
