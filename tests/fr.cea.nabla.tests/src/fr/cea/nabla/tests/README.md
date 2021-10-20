To recreate reference databases in cases of changes on NabLabExamples models, we need to

1. Modify executeJava.sh and executeCpp.sh by replacing CompareToReference with CreateReference
2. Execute NabLabExamplesTest/NabLabTestsTest to generate new DBRefs
3. cd NabLab/tests/fr.cea.nabla.tests/results/compiler/ (required as script uses pwd)
4. Copy DBRefs with ./importResults.sh with test_working_directory as arg
5. Modify executeJava.sh and executeCpp.sh by replacing CreateReference with CompareToReference
6. Execute NabLabExamplesTest to compare with new DBRefs
