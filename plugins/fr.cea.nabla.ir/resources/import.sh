#
#!/bin/sh
#

### build the libcppnabla resource from fr.cea.nabla.cpplib project
CPP_ZIP=libcppnabla.zip
CPP_DIR=LibCppNabla
rm -f ${CPP_ZIP}
mkdir ${CPP_DIR}
cp -R ../../fr.cea.nabla.cpplib/src ${CPP_DIR}/src
zip -r ${CPP_ZIP} ${CPP_DIR}
rm -rf ${CPP_DIR}

### copy the libjavanabla resource from fr.cea.nabla.javalib project
JAVA_ZIP=libjavanabla.zip
JAVA_DIR=LibJavaNabla
rm -f ${JAVA_ZIP}
mkdir ${JAVA_DIR}
cp -R ../../fr.cea.nabla.javalib/lib ${JAVA_DIR}/lib
zip -r ${JAVA_ZIP} ${JAVA_DIR}
rm -rf ${JAVA_DIR}

