#!/usr/bin/env bash

declare -r JAVA_VERSION="${1:?First argument must be java version.}"
declare -r GRAALVM_VERSION="${2:?Second argument must be GraalVM version.}"
if [[ $JAVA_VERSION == 1.8* ]]; then
    JRE="jre/"
elif [[ $JAVA_VERSION == 11* ]]; then
    JRE=""
else
    echo "Unkown java version: $JAVA_VERSION"
    exit 1
fi
readonly COMPONENT_DIR="component_temp_dir"
readonly LANGUAGE_PATH="$COMPONENT_DIR/$JRE/languages/nabla"
if [[ -f ../native/nablanative ]]; then
    INCLUDE_NABLANATIVE="TRUE"
fi

rm -rf COMPONENT_DIR

mkdir -p "$LANGUAGE_PATH"
cp ../language/target/nabla.jar "$LANGUAGE_PATH"

mkdir -p "$LANGUAGE_PATH/launcher"
cp ../launcher/target/nabla-launcher.jar "$LANGUAGE_PATH/launcher/"

mkdir -p "$LANGUAGE_PATH/bin"
cp ../nabla $LANGUAGE_PATH/bin/
if [[ $INCLUDE_NABLANATIVE = "TRUE" ]]; then
    cp ../native/nablanative $LANGUAGE_PATH/bin/
fi

touch "$LANGUAGE_PATH/native-image.properties"

mkdir -p "$COMPONENT_DIR/META-INF"
{
    echo "Bundle-Name: Nabla";
    echo "Bundle-Symbolic-Name: fr.cea.nabla.interpreter";
    echo "Bundle-Version: $GRAALVM_VERSION";
    echo "Bundle-RequireCapability: org.graalvm; filter:=\"(&(graalvm_version=$GRAALVM_VERSION)(os_arch=amd64))\"";
    echo "x-GraalVM-Polyglot-Part: True"
} > "$COMPONENT_DIR/META-INF/MANIFEST.MF"

(
cd $COMPONENT_DIR || exit 1
jar cfm ../nabla-component.jar META-INF/MANIFEST.MF .

echo "bin/nabla = ../$JRE/languages/nabla/bin/nabla" > META-INF/symlinks

jar uf ../nabla-component.jar META-INF/symlinks

{
    echo "$JRE"'languages/nabla/bin/nabla = rwxrwxr-x'
    echo "$JRE"'languages/nabla/bin/nablanative = rwxrwxr-x'
} > META-INF/permissions
jar uf ../nabla-component.jar META-INF/permissions
)
rm -rf $COMPONENT_DIR

cp nabla-component.jar ../../features/fr.cea.nabla.feature/target/rootfiles/nabla-component.jar
cp graalvm-setup.sh ../../features/fr.cea.nabla.feature/target/rootfiles/graalvm-setup.sh
