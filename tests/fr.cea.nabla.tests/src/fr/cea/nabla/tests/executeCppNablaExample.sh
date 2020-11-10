cd $1 # cd target dir
cp $2 . # Copy cpplib to tmp dir
unzip -nq libcppnabla.zip # Unzip cppdir
cd $3 # cd module folder
cp -r $4 . # Copy levelDBRef
cmake . > CMake.log 2>&1 # Configure
[ $? -eq 0 ] || exit 10 # Configure error
make > make.log 2>&1 # Compile
[ $? -eq 0 ] || exit 20 # Compile error
cp $5 ./test.json
sed -i 's/"nonRegression":""/"nonRegression":"CompareToReference"/g' test.json
./$3 test.json >exec.out 2>exec.err # Execute
[ $? -eq 0 ] || exit 30 # Execute error