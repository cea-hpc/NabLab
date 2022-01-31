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

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Objects;
import java.util.stream.Stream;

import org.eclipse.emf.ecore.EPackage;
import org.eclipse.sirius.components.emf.services.IEditingContextEPackageService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

/**
 * @author arichard
 */
@Service
public class EditingContextEPackageService implements IEditingContextEPackageService {

    private final Logger logger = LoggerFactory.getLogger(EditingContextEPackageService.class);

    private final EPackage.Registry globalEPackageRegistry;

    public EditingContextEPackageService(EPackage.Registry globalEPackageRegistry) {
        this.globalEPackageRegistry = Objects.requireNonNull(globalEPackageRegistry);
    }

    @Override
    public List<EPackage> getEPackages(String editingContextId) {
        LinkedHashMap<String, EPackage> allEPackages = new LinkedHashMap<>();
        this.findGlobalEPackages().forEach(ePackage -> {
            EPackage previous = allEPackages.put(ePackage.getNsURI(), ePackage);
            if (previous != null) {
                // This should never happen for EPackages coming from the global registry, but
                // it does not cost much to check it.
                this.logger.warn("Duplicate EPackages with nsURI {} found.", ePackage.getNsURI()); //$NON-NLS-1$
            }
        });
        return List.copyOf(allEPackages.values());
    }

    /**
     * Returns all the statically defined/contributed EPackages.
     */
    private Stream<EPackage> findGlobalEPackages() {
        return this.globalEPackageRegistry.values().stream().filter(EPackage.class::isInstance).map(EPackage.class::cast);
    }
}
