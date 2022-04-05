/*******************************************************************************
 * Copyright (c) 2021, 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
import * as path from 'path';
import * as vscode from 'vscode';

export default class JobsGraphWebViewLoader {
  public static openedPanel: JobsGraphWebViewLoader | undefined;

  private readonly panel: vscode.WebviewPanel;

  public static createOrShow(extensionPath: string, irModel: string) {
    const column = vscode.window.activeTextEditor ? vscode.window.activeTextEditor.viewColumn : undefined;
    const webViewContext = {
      extensionPath,
      projectName: 'testProject',
      nablaModelPath: 'modelPathTest',
      irModel: irModel,
    };
    // If we already have a panel, show it.
    if (JobsGraphWebViewLoader.openedPanel) {
      JobsGraphWebViewLoader.openedPanel.panel.reveal(column);
      return;
    }
    // Otherwise, create a new panel.
    const panel = vscode.window.createWebviewPanel('jobsgraphwebview', 'Jobs Graph', column || vscode.ViewColumn.One, {
      enableScripts: true,
      localResourceRoots: [vscode.Uri.file(path.join(extensionPath, 'webviews'))],
    });
    JobsGraphWebViewLoader.openedPanel = new JobsGraphWebViewLoader(panel, webViewContext);
    // Once webview has been created, move it to the bottom of the editors part of the screen.
    vscode.commands.executeCommand('workbench.action.moveEditorToBelowGroup');
  }

  public static update(extensionPath: string, projectName: string, nablaModelPath: string, irModel: string) {
    // If we don't have a panel, do nothing.
    if (!JobsGraphWebViewLoader.openedPanel) {
      return;
    }
    JobsGraphWebViewLoader.openedPanel.panel.webview.html = JobsGraphWebViewLoader.getWebviewContent(
      JobsGraphWebViewLoader.openedPanel.panel.webview,
      { extensionPath, projectName, nablaModelPath, irModel }
    );
  }

  constructor(panel: vscode.WebviewPanel, webViewContext: JobsGraphWebViewContext) {
    this.panel = panel;
    panel.webview.html = JobsGraphWebViewLoader.getWebviewContent(panel.webview, webViewContext);
    panel.onDidDispose(
      () => {
        JobsGraphWebViewLoader.openedPanel = undefined;
      },
      null,
      []
    );
  }

  public static getWebviewContent(webView: vscode.Webview, webViewContext: JobsGraphWebViewContext): string {
    // Local path to main script run in the webview
    const reactAppPathOnDisk = vscode.Uri.file(
      path.join(webViewContext.extensionPath, 'webviews', 'jobsgraphwebview.js')
    );
    const reactAppUri = webView.asWebviewUri(reactAppPathOnDisk);
    return `<!DOCTYPE html>
      <html lang="en">
      <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <title>Jobs Graph</title>
          <script>
            window.acquireVsCodeApi = acquireVsCodeApi;
            window.projectName = '${webViewContext.projectName}';
            window.nablaModelPath = '${webViewContext.nablaModelPath}';
            window.irModel = '${webViewContext.irModel}';
          </script>
      </head>
      <body>
          <div id="root"></div>
          <script src="${reactAppUri}"></script>
      </body>
      </html>`;
  }
}

interface JobsGraphWebViewContext {
  extensionPath: string;
  projectName: string;
  nablaModelPath: string;
  irModel: string;
}
