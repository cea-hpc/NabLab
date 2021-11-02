cd $1/$2 # cd target dir / module folder
javac -classpath $4:${10}:$5:$6 *.java 2> javac.err
[ $? -eq 0 ] || exit 10 # Compile error
cp -r $7 . # Copy levelDBRef
cp $8 ./test.json
sed -i 's/"nonRegression":""/"nonRegression":"CompareToReference"/g' test.json
java -classpath $4:${10}:$9:$5:$6:${11}:$1 $2.$3 test.json > exec.log 2> exec.err
[ $? -eq 0 ] || exit 20 # Execution error
