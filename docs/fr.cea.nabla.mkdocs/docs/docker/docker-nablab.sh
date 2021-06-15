#! /bin/sh

DOCKER=$(command -v docker 2>/dev/null)

if [ "${DOCKER}" = "" ]
then
    echo Could not find Docker on your system. Check your installation.
    exit 1
fi

echo "Using docker: ${DOCKER}"

USABLE_DOCKER=$(${DOCKER} info >/dev/null 2>&1 && echo yes)

if [ "${USABLE_DOCKER}" != "yes" ]
then
   echo "################### ABORTING ######################"
   echo "Cannot use Docker!"
   echo " - check that Docker server is running"
   echo " - check that you have permissions to use it"
   echo "   (usually user must belong to the 'docker' group)"
   echo "###################################################"

   exit 1
fi

USER=$(id -un)
USER_ID=$(id -u)
USER_GID=$(id -g)
DOCKER_HOSTNAME="$(hostname)-docker"

DOCKERFILE_DIR=/tmp/${USER}/nablab.docker
mkdir -p ${DOCKERFILE_DIR}

DOCKERFILE="${DOCKERFILE_DIR}/Dockerfile"

cat > ${DOCKERFILE} <<EOF
FROM ubuntu:bionic

ENV USER="${USER}" USER_ID="${USER_ID}" USER_GID="${USER_GID}" HOSTNAME="${DOCKER_HOSTNAME}"

RUN echo "${DOCKER_HOSTNAME}" > /etc/hostname
RUN groupadd --gid "${USER_GID}" "${USER}"
RUN useradd --uid "${USER_ID}" --gid "${USER_GID}" --create-home --shell /bin/bash "${USER}"

RUN apt-get update && apt-get -y upgrade && apt-get -y install git wget sudo g++ make cmake libhwloc-dev #snapd
RUN #snap install cmake
RUN apt-get clean

RUN rm /usr/bin/cc
RUN echo "${USER} ALL=(ALL:ALL) NOPASSWD:ALL" > "/etc/sudoers.d/${USER}"

RUN mkdir leveldb
WORKDIR "/leveldb"
RUN wget http://github.com/google/leveldb/archive/1.22.tar.gz -O leveldb.tar.gz && tar -zxvf leveldb.tar.gz
WORKDIR "/leveldb/leveldb-1.22"
RUN mkdir -p build && cd build && cmake -DCMAKE_BUILD_TYPE=Release .. && cmake --build .
ENV LEVELDB_HOME=/leveldb/leveldb-install

RUN mkdir kokkos
WORKDIR "/kokkos"
RUN wget http://github.com/kokkos/kokkos/archive/refs/tags/3.0.00.tar.gz -O kokkos.tar.gz && tar -zxvf kokkos.tar.gz
RUN mkdir kokkos-install
RUN mkdir kokkos-build
WORKDIR "/kokkos/kokkos-build"
RUN cmake ../kokkos-3.0.00 -DCMAKE_CXX_COMPILER=g++ -DKokkos_CXX_STANDARD=17 -DCMAKE_INSTALL_PREFIX=~/kokkos/kokkos-install -DKokkos_ENABLE_OPENMP=On -DKokkos_ENABLE_HWLOC=On
RUN cmake --build . --target install
WORKDIR "/kokkos"
RUN rm -rf kokkos-build
RUN mkdir kokkos-kernels
WORKDIR "/kokkos/kokkos-kernels"
RUN wget http://github.com/kokkos/kokkos-kernels/archive/refs/tags/3.0.00.tar.gz -O kernels.tar.gz && tar -zxvf kernels.tar.gz
RUN mkdir kokkos-build
WORKDIR "/kokkos/kokkos-kernels/kokkos-build"
RUN cmake ../kokkos-kernels-3.0.00 -DCMAKE_CXX_COMPILER=g++ -DCMAKE_INSTALL_PREFIX=~/kokkos/kokkos-install -DKokkos_ROOT=~/kokkos/kokkos-install -DKokkos_DIR=/kokkos/kokkos-install
RUN cmake --build . --target install
WORKDIR "/kokkos/kokkos-kernels"
RUN rm -rf kokkos-build
ENV KOKKOS_HOME=/kokkos/kokkos-install

RUN apt-get install -y zip

RUN apt install -y maven

WORKDIR "/"
RUN cd / && git clone https://github.com/cea-hpc/NabLab.git
RUN cd NabLab/plugins/fr.cea.nabla.ir/resources && chmod +x ./import.sh && ./import.sh

WORKDIR "/NabLab"
RUN cd /NabLab && mvn clean -P build,updatesite; mvn verify -P build,updatesite
RUN #cd /NabLab && mvn clean; mvn verify -Dmaven.test.skip=true

EOF

if [ -e "${DOCKERFILE}" ]
then
    echo "Successfully built: ${DOCKERFILE}"
else
    echo "Aborting: unable to build ${DOCKERFILE}"
    exit 1
fi

IMAGE_NAME="nablab-docker"
${DOCKER} build -t oudotmp/NabLab ${DOCKERFILE_DIR}

${DOCKER} run -w $(pwd) --user ${USER_ID}:${USER_GID} -ti --entrypoint /bin/bash --hostname="${DOCKER_HOSTNAME}" "${IMAGE_NAME}"
