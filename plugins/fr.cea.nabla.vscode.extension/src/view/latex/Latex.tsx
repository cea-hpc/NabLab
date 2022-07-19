/*******************************************************************************
 * Copyright (c) 2021, 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
import { decode } from 'base64-arraybuffer';
import React from 'react';

interface AppProps {
  latexFormula: string;
}

export const Latex = ({ latexFormula }: AppProps) => {
  let latexFormulaString = '';
  const decoded = decode(latexFormula);
  if (decoded) {
    const blob = new Blob([decoded], {
      type: 'image/png',
    });
    latexFormulaString = URL.createObjectURL(blob);
  }

  return (
    <div>
      <img src={latexFormulaString} alt='' />
    </div>
  );
};
