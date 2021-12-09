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

import fr.cea.nabla.ir.ir.IrFactory;

import java.util.UUID;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.sirius.web.api.configuration.IStereotypeDescriptionRegistry;
import org.eclipse.sirius.web.api.configuration.IStereotypeDescriptionRegistryConfigurer;
import org.eclipse.sirius.web.api.configuration.StereotypeDescription;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.env.Environment;
import org.springframework.core.io.ClassPathResource;

import io.micrometer.core.instrument.MeterRegistry;

/**
 * Configuration used to register new stereotype descriptions.
 *
 * @author arichard
 */
@Configuration
public class StereotypeDescriptionRegistryConfigurer implements IStereotypeDescriptionRegistryConfigurer {

    public static final UUID EMPTY_ID = UUID.nameUUIDFromBytes("empty".getBytes()); //$NON-NLS-1$

    public static final String EMPTY_LABEL = "Others..."; //$NON-NLS-1$

    public static final UUID EMPTY_IR_ID = UUID.nameUUIDFromBytes("empty_ir".getBytes()); //$NON-NLS-1$

    public static final String EMPTY_IR_LABEL = "IR"; //$NON-NLS-1$

    public static final UUID EXPLICIT_HEAT_EQUATION_IR_ID = UUID.nameUUIDFromBytes("ExplicitHeatEquation_ir".getBytes()); //$NON-NLS-1$

    public static final String EXPLICIT_HEAT_EQUATION_IR_LABEL = "Explicit Heat Equation"; //$NON-NLS-1$

    private static final String TIMER_NAME = "siriusweb_stereotype_load"; //$NON-NLS-1$

    private final StereotypeBuilder stereotypeBuilder;

    public StereotypeDescriptionRegistryConfigurer(MeterRegistry meterRegistry, @Value("${org.eclipse.sirius.web.features.studioDefinition:false}") boolean studiosEnabled, Environment environment) {
        this.stereotypeBuilder = new StereotypeBuilder(TIMER_NAME, meterRegistry);
    }

    @Override
    public void addStereotypeDescriptions(IStereotypeDescriptionRegistry registry) {
        registry.add(new StereotypeDescription(EMPTY_IR_ID, EMPTY_IR_LABEL, this::getEmptyIrContent));
        registry.add(new StereotypeDescription(EXPLICIT_HEAT_EQUATION_IR_ID, EXPLICIT_HEAT_EQUATION_IR_LABEL, this::getExplicitHeatEquationIrContent));
        registry.add(new StereotypeDescription(EMPTY_ID, EMPTY_LABEL, "New", this::getEmptyContent)); //$NON-NLS-1$
    }

    private String getEmptyContent() {
        return this.stereotypeBuilder.getStereotypeBody((EObject) null);
    }

    private String getEmptyIrContent() {
        return this.stereotypeBuilder.getStereotypeBody(IrFactory.eINSTANCE.createIrRoot());
    }

    private String getExplicitHeatEquationIrContent() {
        return this.stereotypeBuilder.getStereotypeBody(new ClassPathResource("ExplicitHeatEquation.ir")); //$NON-NLS-1$
    }

}
