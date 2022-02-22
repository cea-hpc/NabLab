cd $1/$2 # cd target dir / module folder
cp -r $3 . # Copy levelDBRef
cp $4 ./test.json
sed -i 's/"nonRegression":""/"nonRegression":"CompareToReference"/g' test.json
chmod +x launch.sh
./runvenv.sh test.json > exec.log 2> exec.err
[ $? -eq 0 ] || exit 20 # Execution error
