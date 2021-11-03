#
#!/bin/bash
#

if [ $1 = ""]
then
  echo " Usage : importResults.sh test_working_directory"
  exit 1
fi
REFERENCE=$1

echo "Copying the result database for compiled tests: " $REFERENCE
HERE=`pwd`
TARNAME=db.tar
cd $REFERENCE
FIND_RES=`find . -name "*DB.ref" -print`
rm -f $TARNAME

for f in $FIND_RES
do
    echo "  Adding " $f " to tar file " $TARNAME
    tar rvf $TARNAME $f
done

echo "  Moving and extracting tar file to: " $HERE
mv $TARNAME $HERE
cd $HERE
#rm -rf src-gen-*
tar xvf $TARNAME

rm $TARNAME
