cd $1 # cd target dir
cd $2 # cd module folder
cmake . > CMake.log 2>&1 # Configure
[ $? -eq 0 ] || exit 10 # Configure error
#make -n > printMakeCommand.txt
make > make.log 2>&1 # Compile
[ $? -eq 0 ] || exit 20 # Compile error
cp $4 ./test.arc
#export STDENV_VERIF=WRITE
export STDENV_VERIF=READ
export STDENV_VERIF_PATH=$3
./$2 test.arc >exec.out 2>exec.err # Execute
[ $? -eq 0 ] || exit 30 # Execute error