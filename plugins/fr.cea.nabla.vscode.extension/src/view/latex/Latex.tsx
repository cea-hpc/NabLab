/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
import React, { useEffect, useState } from 'react';

interface LatexState {
  imgURL: string;
}

interface AppProps {
  projectName: string;
  nablaModelPath: string;
  offset: number;
}

export const Latex = ({ projectName, nablaModelPath, offset }: AppProps) => {
  const [state, setState] = useState<LatexState>({ imgURL: '' });

  useEffect(() => {
    if (projectName && offset) {
      const formulaColor = getComputedStyle(document.documentElement).getPropertyValue('--vscode-editor-foreground');

      fetch(`http://127.0.0.1:8082/latex`, {
        method: 'POST',
        mode: 'cors',
        headers: {
          'Content-Type': 'text/plain',
        },
        body: JSON.stringify({
          projectName: projectName,
          nablaModelPath: nablaModelPath,
          offset: offset,
          formulaColor: formulaColor,
        }),
      })
        .then((response) => response.blob())
        .then((blob) => URL.createObjectURL(blob))
        .then((url) => {
          setState((prevState) => {
            return { ...prevState, imgURL: url };
          });
        })
        .catch((reason) => {
          console.log(reason);
        });
    }
  }, []);

  return (
    <div>
      <img src={state.imgURL} alt="" />
    </div>
  );
};
