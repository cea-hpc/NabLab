# Running the tests

In "Run As > Run Configurations... > Arguments > VM Arguments", add the following options:
-ea -DNZIP_FILE=${workspace_loc}/plugins/fr.cea.nabla.ir/resources/.nablab.zip

# Reference databases creation

To recreate reference databases in cases of changes on NabLabExamples models, we need to

1. Modify executeJava.sh, executeCpp.sh and executePython.sh by replacing CompareToReference with CreateReference
   Modify executeArcane.sh by replacing the environment variable STDENV_VERIF=READ by STDENV_VERIF=WRITE
2. Execute NabLabExamplesTest to generate new DBRefs
3. cd NabLab/tests/fr.cea.nabla.tests/results/compiler/ (required as script uses pwd)
4. Copy DBRefs with ./importResults.sh with test_working_directory as arg
5. Execute NabLabTestsTest to generate new DBRefs
6. cd NabLab/tests/fr.cea.nabla.tests/results/compiler/ (required as script uses pwd)
7. Copy DBRefs with ./importResults.sh with test_working_directory as arg
8. Modify executeJava.sh, executeCpp.sh and executePython.sh by replacing CreateReference with CompareToReference
   Modify executeArcane.sh by replacing the environment variable STDENV_VERIF=WRITE by STDENV_VERIF=READ
9. Execute NabLabExamplesTest/NabLabTestsTest to compare with new DBRefs

