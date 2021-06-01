To recreate reference databases in cases of changes on NablaExamples models, we need to

1. Modify NablaExamplesInterpreterTest by replacing CompareToReference with CreateReference
2. Execute NablaExamplesInterpreterTest to generate new DBRefs into results/interpreter directory
3. Modify NablaExamplesInterpreterTest by replacing CreateReference with CompareToReference
4. Execute NablaExamplesTest to compare with new DBRefs