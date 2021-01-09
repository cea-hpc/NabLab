#
#!/bin/sh
#
CPPLIB=../fr.cea.nabla.ir/resources/libcppnabla.zip
rm -f ${CPPLIB}
cp -R src libcppnabla
zip -r ${CPPLIB} libcppnabla
rm -rf libcppnabla

