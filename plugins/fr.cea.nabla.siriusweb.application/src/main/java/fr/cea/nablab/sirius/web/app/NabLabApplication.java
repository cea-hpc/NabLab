/*******************************************************************************
 * Copyright (c) 2021, 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nablab.sirius.web.app;

import org.eclipse.sirius.components.collaborative.diagrams.handlers.EditLabelEventHandler;
import org.eclipse.sirius.components.compatibility.services.diagrams.CompatibilityToolSectionsProvider;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.FilterType;

/**
 * Main class of the server, used as the entry point which will start the whole server properly initialized with a
 * Spring ApplicationContext (see {@link org.springframework.context.ApplicationContext}).
 * <p>
 * Thanks to the annotation {@link SpringBootApplication}, this class will act as a configuration which allows us to
 * declare beans and configure other features but we will not use this capacity in order to properly separate our code.
 * As such our configurations will be contained in dedicated classes elsewhere.
 * </p>
 * <p>
 * Starting this class will also trigger the scan of the classpath. In order to build our ApplicationContext Spring will
 * only scan the current package and its subpackages by default. Beans outside of those packages will not be discovered
 * automatically unless specified by additional information in our annotations.
 * </p>
 *
 * @author arichard
 */
@SpringBootApplication
@ComponentScan(
        basePackages = { "fr.cea.nablab.sirius.web.app", "org.eclipse.sirius.components.core", "org.eclipse.sirius.components.compatibility", "org.eclipse.sirius.components.diagrams",
                "org.eclipse.sirius.components.diagrams.layout", "org.eclipse.sirius.components.diagrams.layout.api", "org.eclipse.sirius.components.emf.compatibility",
                "org.eclipse.sirius.components.emf.configuration", "org.eclipse.sirius.components.emf.query", "org.eclipse.sirius.components.emf.services",
                "org.eclipse.sirius.components.graphql.utils.typeresolvers", "org.eclipse.sirius.components.collaborative.diagrams", "org.eclipse.sirius.components.collaborative.editingcontext",
                "org.eclipse.sirius.components.collaborative.handlers", "org.eclipse.sirius.components.collaborative.representations", "org.eclipse.sirius.components.graphql" },
        excludeFilters = { @ComponentScan.Filter(type = FilterType.ASSIGNABLE_TYPE, value = CompatibilityToolSectionsProvider.class),
                @ComponentScan.Filter(type = FilterType.ASSIGNABLE_TYPE, value = EditLabelEventHandler.class) })
public class NabLabApplication {

    /**
     * The entry point of the server.
     *
     * @param args
     *            The command line arguments
     */
    public static void main(String[] args) {
        SpringApplication.run(NabLabApplication.class, args);
    }
}
