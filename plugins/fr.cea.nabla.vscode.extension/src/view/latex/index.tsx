/*******************************************************************************
 * Copyright (c) 2021, 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
import React from 'react';
import ReactDOM from 'react-dom';
import { Latex } from './Latex';

declare global {
  interface Window {
    acquireVsCodeApi(): any;
    latexFormula: string;
  }
}
const formulaColor = getComputedStyle(
  document.documentElement
).getPropertyValue('--vscode-editor-foreground');

acquireVsCodeApi().postMessage({
  command: 'updateFormulaColor',
  text: formulaColor,
});

ReactDOM.render(
  <Latex latexFormula={window.latexFormula} />,
  document.getElementById('root')
);
