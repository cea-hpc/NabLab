/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
import * as path from 'path';
import * as os from 'os';
import * as net from 'net';
import {Trace} from 'vscode-jsonrpc';
import { commands, window, workspace, ExtensionContext, Uri} from 'vscode';
import { LanguageClient,StreamInfo, LanguageClientOptions, ServerOptions } from 'vscode-languageclient';
import LatexWebViewLoader from './view/LatexWebViewLoader';
import JobsGraphWebViewLoader from './view/JobsGraphWebViewLoader';

export function activate(context: ExtensionContext) {

    let serverOptions : ServerOptions;
    // Dev mode. In this mode the server is expected to be launched already
    // The communication is done using socket
    if (process.env.nablaLaunchingMode == 'socket') {

        let connectionInfo = {
            port: 5008
        };
    
        serverOptions = () => {
            // Connect to language server via socket
            let socket = net.connect(connectionInfo);
            let result: StreamInfo = {
                writer: socket,
                reader: socket
            };
            return Promise.resolve(result);
        };
    } else {
         // The server is a locally installed in src/mydsl
        let launcher = os.platform() === 'win32' ? 'nabla-ls.bat' : 'nabla-ls';
        let script = context.asAbsolutePath(path.join('src', 'nabla', 'bin', launcher));
        // Normal mode: The server is launch from embedded jars
        serverOptions = {
            run : { command: script },
            args: ['-trace'],
            debug: { command: script, args: [], options: { env: createDebugEnv() } }
        };
    }
    let clientOptions: LanguageClientOptions = {
        documentSelector: ['nabla','nablagen'],
        synchronize: {
            fileEvents: workspace.createFileSystemWatcher('**/*.*')
        }
    };
    
    // Create the language client and start the client.
    let lc = new LanguageClient('NabLab Xtext Server', serverOptions, clientOptions);
    // enable tracing (.Off, .Messages, Verbose)
    lc.trace = Trace.Verbose;
    let disposable = lc.start();
    
    // Push the disposable to the context's subscriptions so that the 
    // client can be deactivated on extension deactivation
    context.subscriptions.push(disposable);

	const disposableLatexPanel = commands.registerCommand('nablabweb.showLatexView', () => {
        LatexWebViewLoader.createOrShow(context.extensionPath);
    });
	context.subscriptions.push(disposableLatexPanel);

    const disposableJobsGraphPanel = commands.registerCommand('nablabweb.showJobsGraphView', () => {
        JobsGraphWebViewLoader.createOrShow(context.extensionPath);
    });
	context.subscriptions.push(disposableJobsGraphPanel);

    window.onDidChangeTextEditorSelection((e) => {
        if (e?.textEditor?.document?.languageId === 'nabla') {
            const activeEditorFileURI = e.textEditor.document.uri;
            const projectFolder = workspace.getWorkspaceFolder(activeEditorFileURI);
			const offset = e.textEditor.document.offsetAt(e.textEditor.selection?.anchor);
            if (projectFolder && offset) {
                LatexWebViewLoader.update(context.extensionPath, projectFolder.name, activeEditorFileURI.toString(), offset);
            }
        }
    });
    
    const disposableGenerateNablagen = commands.registerCommand("nablabweb.generateNablagen.proxy", async (selectedFileURI: Uri) => {
        const genDir = path.dirname(selectedFileURI.fsPath);
        const projectFolder = workspace.getWorkspaceFolder(selectedFileURI);
        if (genDir && projectFolder) {
            commands.executeCommand("nablabweb.generateNablagen", selectedFileURI.fsPath, genDir, projectFolder.name);
        }
    })
    context.subscriptions.push(disposableGenerateNablagen);
}

export function deactivate() {}

function createDebugEnv() {
    return Object.assign({
        JAVA_OPTS:"-Xdebug -Xrunjdwp:server=y,transport=dt_socket,address=8000,suspend=n,quiet=y"
    }, process.env)
}
