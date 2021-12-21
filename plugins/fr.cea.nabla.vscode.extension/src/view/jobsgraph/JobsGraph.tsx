/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
import { DiagramWebSocketContainer, Selection } from '@eclipse-sirius/sirius-components';
import React, { useEffect, useState } from 'react';
import './reset.css';
import './Sprotty.css';
import './variables.css';

interface JobsGraphState {
  editingContextId: string;
  representationId: string;
  representationLabel: string;
  selection: Selection;
}

interface JobsGraphProps {
  editingContextId: string;
  representationId: string;
  representationLabel: string;
}

export const JobsGraph = ({ editingContextId, representationId, representationLabel }: JobsGraphProps) => {
  const [state, setState] = useState<JobsGraphState>({
    editingContextId,
    representationId,
    representationLabel,
    selection: { entries: [] },
  });

  useEffect(() => {
    setState((prevState) => {
      return { ...prevState, editingContextId, representationId };
    });
  }, [editingContextId, representationId]);

  const setSelection = (selection: Selection) => {
    setState((prevState) => {
      return { ...prevState, selection };
    });
  };

  const appStyle = {
    display: 'grid',
    gridTemplateColumns: '1fr',
    gridTemplateRows: 'min-content 1fr',
    rowGap: '1px',
    height: '1000px',
    width: '100%',
    padding: '24px',
  };

  const headerStyle = {
    display: 'grid',
    gridTemplateColumns: 'min-content min-content min-content min-content min-content',
    gridTemplateRows: '1fr',
    columnGap: '1px',
  };

  const componentStyle = {
    display: 'grid',
    gridTemplateColumns: '1fr',
    gridTemplateRows: '1fr',
  };

  const component = (
    <DiagramWebSocketContainer
      editingContextId={state.editingContextId}
      representationId={state.representationId}
      readOnly={true}
      selection={state.selection}
      setSelection={setSelection}
    />
  );

  return (
    <div style={appStyle}>
      <div style={headerStyle}></div>
      {state.editingContextId ? <div style={componentStyle}>{component}</div> : null}
    </div>
  );
};
