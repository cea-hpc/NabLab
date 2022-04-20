cd $1 # cd target dir
cd $2 # cd module folder
cp -r $3 . # Copy levelDBRef
cmake . > CMake.log 2>&1 # Configure
[ $? -eq 0 ] || exit 10 # Configure error
#make -n > printMakeCommand.txt
make > make.log 2>&1 # Compile
[ $? -eq 0 ] || exit 20 # Compile error
cp $4 ./test.json
echo $1 > kokkos.txt
if [[ $1 == *"kokkos"* ]]; then
	if [ $2 == "implicitheatequation" ]; then
		sed -i 's/"nonRegression":""/"nonRegression":"CompareToReference", "nonRegressionTolerance":1E-11/g' test.json
	fi
fi
sed -i 's/"nonRegression":""/"nonRegression":"CompareToReference"/g' test.json
./$2 test.json >exec.out 2>exec.err # Execute
[ $? -eq 0 ] || exit 30 # Execute error