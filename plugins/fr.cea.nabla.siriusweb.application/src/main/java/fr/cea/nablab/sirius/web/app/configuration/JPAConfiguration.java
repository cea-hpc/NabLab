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

import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

/**
 * Configuration of JPA.
 *
 * @author arichard
 */
@Configuration
@EntityScan(basePackages = { "org.eclipse.sirius.web.persistence.entities" })
@EnableJpaRepositories(basePackages = { "org.eclipse.sirius.web.persistence.repositories" }, namedQueriesLocation = "classpath:db/sirius-web-named-queries.properties")
public class JPAConfiguration {

}
