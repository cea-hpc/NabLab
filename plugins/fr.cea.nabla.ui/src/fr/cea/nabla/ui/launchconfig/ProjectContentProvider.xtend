package fr.cea.nabla.ui.launchconfig

import org.eclipse.core.resources.IProject
import org.eclipse.jface.viewers.ITreeContentProvider
import org.eclipse.ui.model.BaseWorkbenchContentProvider

class ProjectContentProvider extends BaseWorkbenchContentProvider implements ITreeContentProvider 
{
    override Object[] getChildren(Object element) 
    {
        if (element instanceof IProject)
            return #[]

        return super.getChildren(element);
    }
}