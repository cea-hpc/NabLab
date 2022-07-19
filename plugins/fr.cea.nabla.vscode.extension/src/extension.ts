/*******************************************************************************
 * Copyright (c) 2021, 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
import { ChildProcess, exec } from 'child_process';
import fs from 'fs';
import JSZip from 'jszip';
import * as net from 'net';
import * as os from 'os';
import * as path from 'path';
import psList, { ProcessDescriptor } from 'ps-list';
import {
  commands,
  ExtensionContext,
  ProviderResult,
  TextDocumentContentProvider,
  Uri,
  window,
  workspace,
} from 'vscode';
import { Trace } from 'vscode-jsonrpc';
import {
  LanguageClient,
  LanguageClientOptions,
  ServerOptions,
  StreamInfo,
} from 'vscode-languageclient/node';
import JobsGraphWebViewLoader from './view/JobsGraphWebViewLoader';
import LatexWebViewLoader from './view/LatexWebViewLoader';

let lc: LanguageClient;
let siriusWebServer: ChildProcess;
let processesToKill: ProcessDescriptor[];

export function activate(context: ExtensionContext) {
  let serverOptions: ServerOptions;
  // Dev mode: In this mode the server is expected to be launched already
  // The communication is done using socket
  if (process.env.nablaLaunchingMode == 'socket') {
    const connectionInfo = {
      port: 5008,
    };

    serverOptions = () => {
      // Connect to language server via socket
      const socket = net.connect(connectionInfo);
      const result: StreamInfo = {
        writer: socket,
        reader: socket,
      };
      return Promise.resolve(result);
    };
  } else {
    // Normal mode: The LSP server is launched from embedded jars locally installed in src/nabla
    const launcher = os.platform() === 'win32' ? 'nablab-ls.bat' : 'nablab-ls';
    const script = context.asAbsolutePath(
      path.join('src', 'nablab', 'bin', launcher)
    );
    serverOptions = {
      run: { command: script },
      args: ['-trace'],
      debug: { command: script, args: [], options: { env: javaOptions() } },
    };
    // The Sirius Server is also launched from embedded jars locally installed in src/nabla
    const siriusWebServerLauncher =
      os.platform() === 'win32' ? 'nablab-sirius.bat' : 'nablab-sirius';
    const siriusWebServerScript = context.asAbsolutePath(
      path.join('src', 'nablab', 'bin', siriusWebServerLauncher)
    );

    siriusWebServer = exec(siriusWebServerScript);
  }
  const clientOptions: LanguageClientOptions = {
    documentSelector: ['nabla', 'nablagen'],
    synchronize: {
      fileEvents: workspace.createFileSystemWatcher('**/*.*'),
    },
  };

  // Create the language client and start the client.
  lc = new LanguageClient(
    'NabLabXtextServer',
    'NabLab Xtext Server',
    serverOptions,
    clientOptions
  );
  // enable tracing (.Off, .Messages, Verbose)
  lc.trace = Trace.Messages;

  const disposable = lc.start();

  // Push the disposable to the context's subscriptions so that the
  // client can be deactivated on extension deactivation
  context.subscriptions.push(disposable);

  const disposableLatexPanel = commands.registerCommand(
    'nablabweb.showLatexView',
    () => {
      LatexWebViewLoader.createOrShow(
        context.extensionPath,
        context.subscriptions
      );
    }
  );
  context.subscriptions.push(disposableLatexPanel);

  window.onDidChangeTextEditorSelection((e) => {
    if (e?.textEditor?.document?.languageId === 'nabla') {
      const activeEditorFileURI = e.textEditor.document.uri;
      const offset = e.textEditor.document.offsetAt(
        e.textEditor.selection?.anchor
      );
      const activeEditorFilePath = activeEditorFileURI.fsPath;

      if (LatexWebViewLoader.openedPanel && activeEditorFilePath && offset) {
        commands
          .executeCommand(
            'nablabweb.updateLatex',
            activeEditorFilePath,
            offset,
            LatexWebViewLoader.formulaColor
          )
          .then((latexFormula) => {
            LatexWebViewLoader.update(
              context.extensionPath,
              context.subscriptions,
              latexFormula as string
            );
          });
      }
    }
  });

  const disposableGenerateNablagen = commands.registerCommand(
    'nablabweb.generateNablagen.proxy',
    async (selectedFileURI: Uri) => {
      const genDir = path.dirname(selectedFileURI.fsPath);
      const projectFolder = workspace.getWorkspaceFolder(selectedFileURI);
      if (genDir && projectFolder) {
        commands.executeCommand(
          'nablabweb.generateNablagen',
          selectedFileURI.fsPath,
          genDir,
          projectFolder.name
        );
      }
    }
  );
  context.subscriptions.push(disposableGenerateNablagen);

  const disposableGenerateCode = commands.registerCommand(
    'nablabweb.generateCode.proxy',
    async (selectedFileURI: Uri) => {
      const ngenPath = path.dirname(selectedFileURI.fsPath);
      const projectFolder = workspace.getWorkspaceFolder(selectedFileURI);
      const projectPath = projectFolder?.uri.fsPath;
      if (ngenPath && projectPath && projectFolder) {
        const wsPath = projectPath.substring(
          0,
          projectPath.lastIndexOf(projectFolder.name) - 1
        );
        if (wsPath) {
          commands.executeCommand(
            'nablabweb.generateCode',
            selectedFileURI.fsPath,
            wsPath,
            projectFolder.name
          );
        }
      }
    }
  );
  context.subscriptions.push(disposableGenerateCode);

  const disposableGenerateIr = commands.registerCommand(
    'nablabweb.generateIr.proxy',
    async () => {
      const activeEditorDocumentURI = window?.activeTextEditor?.document?.uri;
      if (!activeEditorDocumentURI) {
        return;
      }
      const activeEditorDocumentPath = activeEditorDocumentURI.fsPath;
      const projectFolder = workspace.getWorkspaceFolder(
        activeEditorDocumentURI
      );
      if (projectFolder && activeEditorDocumentPath) {
        const irModel: string | undefined = await commands.executeCommand(
          'nablabweb.generateIr',
          activeEditorDocumentPath,
          projectFolder.name
        );
        if (irModel) {
          JobsGraphWebViewLoader.createOrShow(context.extensionPath, irModel);
        }
      }
    }
  );
  context.subscriptions.push(disposableGenerateIr);

  // Plug a TextDocumentContent that can read inside a jar file
  const jarContentProvider = new (class implements TextDocumentContentProvider {
    provideTextDocumentContent(uri: Uri): ProviderResult<string> {
      // URI format: jar:file:/<path>!<pathInJar>
      const path = uri.path;
      const parts = path.split('!');
      const jarFilePath = parts[0].replace('file:/', '');
      const insidePath = parts[1].substring(1);
      const fileContent = new JSZip()
        .loadAsync(fs.readFileSync(jarFilePath))
        .then((zip) => {
          return zip.file(insidePath)?.async('string');
        });
      return fileContent;
    }
  })();

  context.subscriptions.push(
    workspace.registerTextDocumentContentProvider('jar', jarContentProvider)
  );

  psList().then((result) => {
    // retrieve all java processes launched by this extension.
    processesToKill = result.filter(
      (p) => p.ppid === process.pid && p.name === 'java'
    );
  });
}

/**
 * LanguageClient should be stopped via stop() method (see https://code.visualstudio.com/api/language-extensions/language-server-extension-guide).
 * But it doesn't work when the extension is packaged.
 * So use kill() method instead.
 */
export function deactivate() {
  if (siriusWebServer) {
    siriusWebServer.kill();
  }
  //if (!lc) {
  //  return undefined;
  //}
  // return lc.stop();

  processesToKill.forEach((ptk) => {
    process.kill(ptk.pid);
  });

  return undefined;
}

/**
 * fix Google Guice message: "WARNING: An illegal reflective access operation has occurred"
 */
function javaOptions() {
  return Object.assign(
    {
      JAVA_OPTS: '--add-opens java.base/java.lang=ALL-UNNAMED',
    },
    process.env
  );
}
