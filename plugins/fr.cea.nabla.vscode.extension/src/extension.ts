/*******************************************************************************
 * Copyright (c) 2021, 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
import { ChildProcess, exec } from "child_process";
import * as net from "net";
import * as os from "os";
import * as path from "path";
import { commands, ExtensionContext, Uri, window, workspace } from "vscode";
import { Trace } from "vscode-jsonrpc";
import {
  LanguageClient,
  LanguageClientOptions,
  ServerOptions,
  StreamInfo,
} from "vscode-languageclient/node";
import JobsGraphWebViewLoader from "./view/JobsGraphWebViewLoader";
import LatexWebViewLoader from "./view/LatexWebViewLoader";

let lc: LanguageClient;
let siriusWebServer: ChildProcess;

export function activate(context: ExtensionContext) {
  let serverOptions: ServerOptions;
  // Dev mode: In this mode the server is expected to be launched already
  // The communication is done using socket
  if (process.env.nablaLaunchingMode == "socket") {
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
    const launcher = os.platform() === "win32" ? "nabla-ls.bat" : "nabla-ls";
    const script = context.asAbsolutePath(
      path.join("src", "nabla", "bin", launcher)
    );
    serverOptions = {
      run: { command: script },
      args: ["-trace"],
      debug: { command: script, args: [], options: { env: javaOptions() } },
    };
    // The Sirius Server is also launched from embedded jars locally installed in src/nabla
    const siriusWebServerLauncher =
      os.platform() === "win32" ? "nabla-sirius.bat" : "nabla-sirius";
    const siriusWebServerScript = context.asAbsolutePath(
      path.join("src", "nabla", "bin", siriusWebServerLauncher)
    );

    siriusWebServer = exec(siriusWebServerScript);
  }
  const clientOptions: LanguageClientOptions = {
    documentSelector: ["nabla", "nablagen"],
    synchronize: {
      fileEvents: workspace.createFileSystemWatcher("**/*.*"),
    },
  };

  // Create the language client and start the client.
  lc = new LanguageClient("NabLab Xtext Server", serverOptions, clientOptions);
  // enable tracing (.Off, .Messages, Verbose)
  lc.trace = Trace.Verbose;
  const disposable = lc.start();

  // Push the disposable to the context's subscriptions so that the
  // client can be deactivated on extension deactivation
  context.subscriptions.push(disposable);

  const disposableLatexPanel = commands.registerCommand(
    "nablabweb.showLatexView",
    () => {
      LatexWebViewLoader.createOrShow(context.extensionPath);
    }
  );
  context.subscriptions.push(disposableLatexPanel);

  const disposableJobsGraphPanel = commands.registerCommand(
    "nablabweb.showJobsGraphView",
    () => {
      JobsGraphWebViewLoader.createOrShow(context.extensionPath, "");
    }
  );
  context.subscriptions.push(disposableJobsGraphPanel);

  window.onDidChangeTextEditorSelection((e) => {
    if (e?.textEditor?.document?.languageId === "nabla") {
      const activeEditorFileURI = e.textEditor.document.uri;
      const projectFolder = workspace.getWorkspaceFolder(activeEditorFileURI);
      const offset = e.textEditor.document.offsetAt(
        e.textEditor.selection?.anchor
      );
      if (projectFolder && offset) {
        LatexWebViewLoader.update(
          context.extensionPath,
          projectFolder.name,
          activeEditorFileURI.toString(),
          offset
        );
      }
    }
  });

  const disposableGenerateNablagen = commands.registerCommand(
    "nablabweb.generateNablagen.proxy",
    async (selectedFileURI: Uri) => {
      const genDir = path.dirname(selectedFileURI.fsPath);
      const projectFolder = workspace.getWorkspaceFolder(selectedFileURI);
      if (genDir && projectFolder) {
        commands.executeCommand(
          "nablabweb.generateNablagen",
          selectedFileURI.fsPath,
          genDir,
          projectFolder.name
        );
      }
    }
  );
  context.subscriptions.push(disposableGenerateNablagen);

  const disposableGenerateCode = commands.registerCommand(
    "nablabweb.generateCode.proxy",
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
          const ngenRelativePath = path.relative(wsPath, ngenPath);
          commands.executeCommand(
            "nablabweb.generateCode",
            selectedFileURI.fsPath,
            wsPath,
            ngenRelativePath
          );
        }
      }
    }
  );
  context.subscriptions.push(disposableGenerateCode);

  const disposableGenerateIr = commands.registerCommand(
    "nablabweb.generateIr.proxy",
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
          "nablabweb.generateIr",
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
}

/**
 * Close extension properly (see https://code.visualstudio.com/api/language-extensions/language-server-extension-guide)
 */
export function deactivate() {
  if (siriusWebServer) {
    siriusWebServer.kill();
  }
  if (!lc) {
    return undefined;
  }
  return lc.stop();
}

/**
 * fix Google Guice message: "WARNING: An illegal reflective access operation has occurred"
 */
function javaOptions() {
  return Object.assign(
    {
      JAVA_OPTS: "--add-opens java.base/java.lang=ALL-UNNAMED",
    },
    process.env
  );
}
