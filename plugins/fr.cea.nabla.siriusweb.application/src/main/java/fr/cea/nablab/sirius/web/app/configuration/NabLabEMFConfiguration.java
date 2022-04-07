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

import fr.cea.nabla.ir.ir.IrPackage;

import org.eclipse.emf.ecore.EPackage;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * Configuration of the EMF support for Sirius Web.
 *
 * @author arichard
 */
@Configuration
public class NabLabEMFConfiguration {

    @Bean
    public EPackage irEPackage() {
        return IrPackage.eINSTANCE;
    }

}
