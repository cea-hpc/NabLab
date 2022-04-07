/*******************************************************************************
 * Copyright (c) 2021, 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
import { useMutation } from '@apollo/client';
import { DiagramWebSocketContainer, Selection } from '@eclipse-sirius/sirius-components';
import gql from 'graphql-tag';
import React, { useEffect, useState } from 'react';
import { v4 as uuid } from 'uuid';
import './reset.css';
import './Sprotty.css';
import './variables.css';

interface JobsGraphState {
  editingContextId: string;
  representationId: string;
  selection: Selection;
}

interface JobsGraphProps {
  irModel: string;
}

interface GQLUploadModelMutationData {
  uploadModel: GQLUploadModelPayload;
}

interface GQLUploadModelPayload {
  __typename: string;
}

interface GQLUploadModelSuccessPayload extends GQLUploadModelPayload {
  id: string;
  representation: GQLRepresentation;
}

interface GQLRepresentation {
  id: string;
}

interface GQLErrorPayload extends GQLUploadModelPayload {
  message: string;
}

const uploadModelMutation = gql`
  mutation uploadModel($input: UploadModelInput!) {
    uploadModel(input: $input) {
      __typename
      ... on UploadModelSuccessPayload {
        id
        representation {
          id
        }
      }
      ... on ErrorPayload {
        message
      }
    }
  }
`;

const isUploadModelSuccessPayload = (payload: GQLUploadModelPayload): payload is GQLUploadModelSuccessPayload =>
  payload.__typename === 'UploadModelSuccessPayload';

const isErrorPayload = (payload: GQLUploadModelPayload): payload is GQLErrorPayload =>
  payload.__typename === 'ErrorPayload';

export const JobsGraph = ({ irModel }: JobsGraphProps) => {
  const initialState = {
    editingContextId: '',
    representationId: '',
    selection: { entries: [] },
  };

  const [state, setState] = useState<JobsGraphState>(initialState);

  const [uploadModel, { loading, data, error }] = useMutation<GQLUploadModelMutationData>(uploadModelMutation);

  const setSelection = (selection: Selection) => {
    if (state.selection !== selection) {
      setState((prevState) => {
        const newRepId = selection?.entries[0]?.id;
        if (prevState.selection !== selection && newRepId?.startsWith('volatileRepresentation_')) {
          return { ...prevState, representationId: newRepId, selection };
        } else {
          return { ...prevState, selection };
        }
      });
    }
  };

  const appStyle = {
    display: 'grid',
    gridTemplateColumns: '1fr',
    gridTemplateRows: 'min-content 1fr',
    rowGap: '1px',
    height: '100vh',
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

  useEffect(() => {
    const variables = {
      input: {
        id: uuid(),
        model: irModel,
      },
    };
    uploadModel({ variables });
  }, []);

  useEffect(() => {
    if (!loading) {
      if (error) {
        console.log('Upload model error');
      }
      if (data) {
        const { uploadModel } = data;
        if (isErrorPayload(uploadModel)) {
          const { message } = uploadModel;
          console.log(message);
        } else if (isUploadModelSuccessPayload(uploadModel)) {
          const { id, representation } = uploadModel;
          setState((prevState) => {
            return { ...prevState, editingContextId: id, representationId: representation.id };
          });
        } else {
          console.log('Upload model unknown payload');
        }
      }
    }
  }, [loading, data, error]);

  const component = (
    <DiagramWebSocketContainer
      editingContextId={state.editingContextId}
      representationId={state.representationId}
      readOnly={false}
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
