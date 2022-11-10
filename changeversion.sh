#
#!/bin/bash
#

OLD_VERSION=0.5.3
NEW_VERSION=0.6.0

echo "Looking for MANIFEST.MF files"
FIND_RES=`find . -path ./.metadata -prune -o -name "MANIFEST.MF" -print`
for f in $FIND_RES
do
   if grep -q "Bundle-Vendor: CEA" $f; then
      if grep -q "Bundle-Version: $OLD_VERSION.qualifier" $f; then
         echo "   Changing version of:" $f
         cp $f $f.old
         sed "s/Bundle-Version: $OLD_VERSION.qualifier/Bundle-Version: $NEW_VERSION.qualifier/g" $f.old > $f
      fi
   fi
done

echo "Looking for pom.xml files"
FIND_RES=`find . -path ./.metadata -prune -o -name "pom.xml" -print`
for f in $FIND_RES
do
   if grep -q "<groupId>fr.cea.nabla</groupId>" $f; then
      if grep -q "<version>$OLD_VERSION-SNAPSHOT</version>" $f; then
         echo "   Changing version of:" $f
         cp $f $f.old
         sed "s%<version>$OLD_VERSION-SNAPSHOT</version>%<version>$NEW_VERSION-SNAPSHOT</version>%g" $f.old > $f
      fi
   fi
done

echo "Looking for feature.xml files"
FIND_RES=`find . -path ./.metadata -prune -o -name "feature.xml" -print`
for f in $FIND_RES
do
   if grep -q "provider-name=\"CEA\"" $f; then
      if grep -q "version=\"$OLD_VERSION.qualifier\"" $f; then
         echo "   Changing version of:" $f
         cp $f $f.old
         sed "s/version=\"$OLD_VERSION.qualifier\"/version=\"$NEW_VERSION.qualifier\"/g" $f.old > $f
      fi
   fi
done

f=./plugins/fr.cea.nabla.rcp/plugin.xml
if grep -q "Version $OLD_VERSION" $f; then
   echo "   Changing version of:" $f
   cp $f $f.old
   sed "s/Version $OLD_VERSION/Version $NEW_VERSION/g" $f.old > $f
fi

f=./releng/fr.cea.nabla.updatesite/NabLab.product
if grep -q "$OLD_VERSION.qualifier" $f; then
   echo "   Changing version of:" $f
   cp $f $f.old
   sed "s/$OLD_VERSION.qualifier/$NEW_VERSION.qualifier/g" $f.old > $f
fi

f=./.github/workflows/build.yml
if grep -q "$OLD_VERSION-SNAPSHOT.jar -Dversion=$OLD_VERSION" $f; then
   echo "   Changing version of:" $f
   cp $f $f.old
   sed "s/$OLD_VERSION-SNAPSHOT.jar -Dversion=$OLD_VERSION/$NEW_VERSION-SNAPSHOT.jar -Dversion=$NEW_VERSION/g" $f.old > $f
fi

f=./plugins/fr.cea.nabla.vscode.extension/package.json
if grep -q "\"version\": \"$OLD_VERSION\"" $f; then
   echo "   Changing version of:" $f
   cp $f $f.old
   sed "s/\"version\": \"$OLD_VERSION\"/\"version\": \"$NEW_VERSION\"/g" $f.old > $f
fi

MD_FILES="./README.md ./docs/fr.cea.nabla.mkdocs/docs/gettingstarted.md"
for f in $MD_FILES
do
   if grep -q "https://github.com/cea-hpc/NabLab/releases/tag/v$OLD_VERSION" $f; then
      echo "   Changing version of:" $f
      cp $f $f.old
      sed "s%https://github.com/cea-hpc/NabLab/releases/tag/v$OLD_VERSION%https://github.com/cea-hpc/NabLab/releases/tag/v$NEW_VERSION%g" $f.old > $f
   fi
done

echo "DONE. All that remains is to change the SPLASH SCREEN (BMP 459x347) and the update site release name in docs/fr.cea.nabla.mkdocs/Makefile"

