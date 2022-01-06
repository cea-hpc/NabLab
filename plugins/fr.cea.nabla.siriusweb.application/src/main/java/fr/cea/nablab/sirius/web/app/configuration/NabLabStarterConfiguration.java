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

import org.eclipse.sirius.web.spring.collaborative.api.ISubscriptionManagerFactory;
import org.eclipse.sirius.web.spring.collaborative.forms.WidgetSubscriptionManager;
import org.eclipse.sirius.web.spring.collaborative.forms.api.IWidgetSubscriptionManagerFactory;
import org.eclipse.sirius.web.spring.collaborative.projects.EditingContextEventProcessorExecutorServiceProvider;
import org.eclipse.sirius.web.spring.collaborative.projects.api.IEditingContextEventProcessorExecutorServiceProvider;
import org.eclipse.sirius.web.spring.collaborative.representations.SubscriptionManager;
import org.eclipse.sirius.web.spring.graphql.ws.api.IOperationMessagePreProcessor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * @author arichard
 */
@Configuration
public class NabLabStarterConfiguration {
    @Bean
    public ISubscriptionManagerFactory subscriptionManagerFactory() {
        return SubscriptionManager::new;
    }

    @Bean
    public IWidgetSubscriptionManagerFactory widgetSubscriptionManagerFactory() {
        return WidgetSubscriptionManager::new;
    }

    @Bean
    public IEditingContextEventProcessorExecutorServiceProvider editingContextEventProcessorExecutorServiceProvider() {
        return new EditingContextEventProcessorExecutorServiceProvider();
    }

    @Bean
    public IOperationMessagePreProcessor operationMessagePreProcessor() {
        return operationMessage -> {
        };
    }
}
