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
import { Disposable } from 'vscode-languageserver-protocol';

export default class LatexWebViewLoader {
  public static openedPanel: LatexWebViewLoader | undefined;
  public static formulaColor: string = '#d4d4d4';

  private readonly panel: vscode.WebviewPanel;

  public static createOrShow(
    extensionPath: string,
    subscriptions: Disposable[]
  ) {
    const column = vscode.window.activeTextEditor
      ? vscode.window.activeTextEditor.viewColumn
      : undefined;
    const webViewContext = {
      extensionPath,
      subscriptions,
      latexFormula: '',
    };
    // If we already have a panel, show it.
    if (LatexWebViewLoader.openedPanel) {
      LatexWebViewLoader.openedPanel.panel.reveal(column);
      return;
    }
    // Otherwise, create a new panel.
    const panel = vscode.window.createWebviewPanel(
      'latexwebview',
      'LaTex',
      column || vscode.ViewColumn.One,
      {
        enableScripts: true,
        localResourceRoots: [
          vscode.Uri.file(path.join(extensionPath, 'webviews')),
        ],
      }
    );
    LatexWebViewLoader.openedPanel = new LatexWebViewLoader(
      panel,
      webViewContext
    );
    // Once webview has been created, move it to the bottom of the editors part of the screen.
    vscode.commands.executeCommand('workbench.action.moveEditorToBelowGroup');
  }

  public static update(
    extensionPath: string,
    subscriptions: Disposable[],
    latexFormula: string
  ) {
    // If we don't have a panel, do nothing.
    if (!LatexWebViewLoader.openedPanel) {
      return;
    }
    LatexWebViewLoader.openedPanel.panel.webview.html =
      LatexWebViewLoader.getWebviewContent(
        LatexWebViewLoader.openedPanel.panel.webview,
        { extensionPath, subscriptions, latexFormula }
      );
  }

  constructor(panel: vscode.WebviewPanel, webViewContext: LatexWebViewContext) {
    this.panel = panel;
    panel.webview.html = LatexWebViewLoader.getWebviewContent(
      panel.webview,
      webViewContext
    );
    panel.onDidDispose(
      () => {
        LatexWebViewLoader.openedPanel = undefined;
      },
      null,
      []
    );
    panel.webview.onDidReceiveMessage(
      (message) => {
        switch (message.command) {
          case 'updateFormulaColor':
            LatexWebViewLoader.formulaColor = message.text;
            return;
        }
      },
      undefined,
      webViewContext.subscriptions
    );
  }

  public static getWebviewContent(
    webView: vscode.Webview,
    webViewContext: LatexWebViewContext
  ): string {
    // Local path to main script run in the webview
    const reactAppPathOnDisk = vscode.Uri.file(
      path.join(webViewContext.extensionPath, 'webviews', 'latexwebview.js')
    );
    const reactAppUri = webView.asWebviewUri(reactAppPathOnDisk);
    return `<!DOCTYPE html>
      <html lang="en">
      <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <title>LaTex</title>
          <script>
            window.acquireVsCodeApi = acquireVsCodeApi;
            window.latexFormula = '${webViewContext.latexFormula}';
          </script>
      </head>
      <body>
          <div id="root"></div>
          <script src="${reactAppUri}"></script>
      </body>
      </html>`;
  }
}

interface LatexWebViewContext {
  extensionPath: string;
  subscriptions: Disposable[];
  latexFormula: string;
}
