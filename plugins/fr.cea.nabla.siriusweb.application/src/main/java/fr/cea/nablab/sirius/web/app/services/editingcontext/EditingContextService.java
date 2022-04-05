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

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.concurrent.ConcurrentHashMap;

import org.eclipse.emf.common.command.BasicCommandStack;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.emf.ecore.impl.EPackageRegistryImpl;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.emf.ecore.util.ECrossReferenceAdapter;
import org.eclipse.emf.edit.domain.AdapterFactoryEditingDomain;
import org.eclipse.emf.edit.provider.ComposedAdapterFactory;
import org.eclipse.sirius.components.core.api.IEditingContext;
import org.eclipse.sirius.components.emf.services.EObjectIDManager;
import org.eclipse.sirius.components.emf.services.EditingContext;
import org.eclipse.sirius.components.emf.services.IEditingContextEPackageService;
import org.eclipse.sirius.emfjson.resource.JsonResource;
import org.eclipse.sirius.emfjson.resource.JsonResourceImpl;
import org.springframework.stereotype.Service;

/**
 * @author arichard
 */
@Service
public class EditingContextService implements IEditingContextService {

    private final Map<String, IEditingContext> editingContexts = new ConcurrentHashMap<>();

    private final ComposedAdapterFactory composedAdapterFactory;

    private final EPackage.Registry globalEPackageRegistry;

    private final IEditingContextEPackageService editingContextEPackageService;

    public EditingContextService(IEditingContextEPackageService editingContextEPackageService, ComposedAdapterFactory composedAdapterFactory, EPackage.Registry globalEPackageRegistry) {
        this.editingContextEPackageService = Objects.requireNonNull(editingContextEPackageService);
        this.composedAdapterFactory = Objects.requireNonNull(composedAdapterFactory);
        this.globalEPackageRegistry = Objects.requireNonNull(globalEPackageRegistry);
    }

    @Override
    public void delete(String editingContextId) {
        this.editingContexts.remove(editingContextId);
    }

    @Override
    public IEditingContext getEditingContext(String editingContextId) {
        return this.editingContexts.get(editingContextId);
    }

    @Override
    public IEditingContext createEditingContext(String editingContextId) {
        ResourceSet resourceSet = new ResourceSetImpl();
        resourceSet.eAdapters().add(new ECrossReferenceAdapter());

        EPackageRegistryImpl ePackageRegistry = new EPackageRegistryImpl();
        this.globalEPackageRegistry.forEach(ePackageRegistry::put);
        List<EPackage> additionalEPackages = this.editingContextEPackageService.getEPackages(editingContextId);
        additionalEPackages.forEach(ePackage -> ePackageRegistry.put(ePackage.getNsURI(), ePackage));
        resourceSet.setPackageRegistry(ePackageRegistry);

        AdapterFactoryEditingDomain editingDomain = new AdapterFactoryEditingDomain(this.composedAdapterFactory, new BasicCommandStack(), resourceSet);
        EditingContext editingContext = new EditingContext(editingContextId, editingDomain);
        this.editingContexts.put(editingContextId, editingContext);
        return editingContext;
    }

    @Override
    public void addModel(String editingContextId, EObject modelRoot) {
        IEditingContext iEditingContext = this.editingContexts.get(editingContextId);
        if (iEditingContext instanceof EditingContext) {
            EditingContext editingContext = (EditingContext) iEditingContext;
            AdapterFactoryEditingDomain domain = editingContext.getDomain();
            ResourceSet resourceSet = domain.getResourceSet();
            Map<String, Object> saveOptions = new HashMap<>();
            saveOptions.put(JsonResource.OPTION_ENCODING, JsonResource.ENCODING_UTF_8);
            saveOptions.put(JsonResource.OPTION_SCHEMA_LOCATION, Boolean.TRUE);
            saveOptions.put(JsonResource.OPTION_ID_MANAGER, new EObjectIDManager());
            Resource resource = new JsonResourceImpl(URI.createURI("inmemory"), saveOptions); //$NON-NLS-1$
            resourceSet.getResources().add(resource);
            resource.getContents().add(modelRoot);
        }
    }
}
