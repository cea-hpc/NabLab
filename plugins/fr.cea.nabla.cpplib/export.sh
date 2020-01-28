#
#!/bin/sh
#
CPPLIB=../fr.cea.nabla.ir/cppresources/libcppnabla.zip
rm -f ${CPPLIB}
cp -R src libcppnabla
zip -r ${CPPLIB} libcppnabla
rm -rf libcppnabla

