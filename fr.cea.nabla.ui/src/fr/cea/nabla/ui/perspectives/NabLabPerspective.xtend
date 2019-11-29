/*******************************************************************************
 * Copyright (c) 2019 CEA, Obeo
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
 package fr.cea.nabla.ui.perspectives

import org.eclipse.ui.IPerspectiveFactory
import org.eclipse.ui.IPageLayout
import org.eclipse.ui.console.IConsoleConstants
import org.eclipse.search.ui.NewSearchUI;
import org.eclipse.ui.progress.IProgressConstants

class NabLabPerspective implements IPerspectiveFactory {

	static val NABLAB_PERSPECTIVE_ID = "fr.cea.nabla.ui.NabLabPerpective";
	static val LEFT_FOLDER_ID = "left.folder";
	static val RIGHT_FOLDER_ID = "right.folder";
	static val BOTTOM_FOLDER_ID = "bottom.folder";
	static val MODEL_EXPLORER_VIEW_ID = "org.eclipse.sirius.ui.tools.views.model.explorer";
	static val ERROR_LOG_VIEW = "org.eclipse.pde.runtime.LogView";
	static val NABLA_LATEX_VIEW_ID = "fr.cea.nabla.ui.views.NablaLatexView";

	override createInitialLayout(IPageLayout layout) {
		layout.editorAreaVisible = true;

		var leftFolder = layout.createFolder(LEFT_FOLDER_ID, IPageLayout.LEFT, 0.25f, IPageLayout.ID_EDITOR_AREA);
		leftFolder.addView(MODEL_EXPLORER_VIEW_ID);

		var bottomFolder = layout.createFolder(BOTTOM_FOLDER_ID, IPageLayout.BOTTOM, 0.75f, IPageLayout.ID_EDITOR_AREA);
		bottomFolder.addView(IConsoleConstants.ID_CONSOLE_VIEW);
		bottomFolder.addView(IPageLayout.ID_PROP_SHEET);
		bottomFolder.addView(IPageLayout.ID_PROBLEM_VIEW);
		bottomFolder.addView(ERROR_LOG_VIEW);
		bottomFolder.addPlaceholder(NewSearchUI.SEARCH_VIEW_ID);
		bottomFolder.addPlaceholder(IProgressConstants.PROGRESS_VIEW_ID);
		bottomFolder.addView(NABLA_LATEX_VIEW_ID);

		var rightFolder = layout.createFolder(RIGHT_FOLDER_ID, IPageLayout.RIGHT, 0.75f, IPageLayout.ID_EDITOR_AREA);
		rightFolder.addView(IPageLayout.ID_OUTLINE);

		layout.addShowViewShortcut(NABLA_LATEX_VIEW_ID);
		layout.addShowViewShortcut(MODEL_EXPLORER_VIEW_ID);
		layout.addShowViewShortcut(IPageLayout.ID_OUTLINE);
		layout.addShowViewShortcut(IConsoleConstants.ID_CONSOLE_VIEW);
		layout.addShowViewShortcut(IPageLayout.ID_PROP_SHEET);
		layout.addShowViewShortcut(ERROR_LOG_VIEW);
		layout.addShowViewShortcut(IPageLayout.ID_PROBLEM_VIEW);

		layout.addPerspectiveShortcut(NABLAB_PERSPECTIVE_ID);
	}
}
