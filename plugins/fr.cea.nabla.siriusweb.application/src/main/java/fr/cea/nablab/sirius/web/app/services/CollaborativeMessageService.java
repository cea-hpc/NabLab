/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nablab.sirius.web.app.services;

import org.eclipse.sirius.components.collaborative.messages.ICollaborativeMessageService;
import org.springframework.stereotype.Service;

/**
 * @author arichard
 */
@Service
public class CollaborativeMessageService implements ICollaborativeMessageService {

    @Override
    public String invalidInput(String expectedInputTypeName, String receivedInputTypeName) {
        return "Invalid input type, " + receivedInputTypeName + " has been received while " + expectedInputTypeName + " was expected"; //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
    }

    @Override
    public String objectCreationFailed() {
        return "The creation of the new object has failed"; //$NON-NLS-1$
    }

    @Override
    public String timeout() {
        return "The request has been interrupted due to a timeout"; //$NON-NLS-1$
    }

}
