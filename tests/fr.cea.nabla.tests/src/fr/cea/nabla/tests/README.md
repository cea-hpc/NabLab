To recreate reference databases in cases of changes on NabLabExamples models, we need to

1. Modify executeJava.sh and executeCpp.sh by replacing CompareToReference with CreateReference
   Modify executeArcane.sh by replacing the environment variable STDENV_VERIF=READ by STDENV_VERIF=WRITE
2. Execute NabLabExamplesTest/NabLabTestsTest to generate new reference results
3. cd NabLab/tests/fr.cea.nabla.tests/results/compiler/ (required as script uses pwd)
4. Copy DBRefs with ./importResults.sh with test_working_directory as arg
   Arcane reference results are directly written in the final directory
5. Modify executeJava.sh and executeCpp.sh by replacing CreateReference with CompareToReference
   Modify executeArcane.sh by replacing the environment variable STDENV_VERIF=WRITE by STDENV_VERIF=READ
6. Execute NabLabExamplesTest/NabLabTestsTest to compare with new reference results
