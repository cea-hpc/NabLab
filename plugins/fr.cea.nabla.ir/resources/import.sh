#
#!/bin/sh
#

### build the nablacore resource
ZIP_FILE=.nablab.zip
rm -f ${ZIP_FILE}

DIR_TO_ZIP=.nablab

# add C++ nablalib and linearalgebra
cp -R ../../fr.cea.nabla.cpplib/src ${DIR_TO_ZIP}
rm ${DIR_TO_ZIP}/CMakeLists.txt

# add Java linear algebra jar
mkdir ${DIR_TO_ZIP}/linearalgebra/linearalgebrajava
cp -R ../../fr.cea.nabla.javalib/lib ${DIR_TO_ZIP}/linearalgebra/linearalgebrajava

zip -r ${ZIP_FILE} ${DIR_TO_ZIP}
rm -rf ${DIR_TO_ZIP}

