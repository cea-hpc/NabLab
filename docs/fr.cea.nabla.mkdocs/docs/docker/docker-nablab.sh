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
FROM ubuntu:focal

ENV USER="${USER}" USER_ID="${USER_ID}" USER_GID="${USER_GID}" HOSTNAME="${DOCKER_HOSTNAME}"

RUN echo "${DOCKER_HOSTNAME}" > /etc/hostname
RUN groupadd --gid "${USER_GID}" "${USER}"
RUN useradd --uid "${USER_ID}" --gid "${USER_GID}" --create-home --shell /bin/bash "${USER}"

RUN apt-get update \
	&& apt-get install -y tzdata \
	&& apt-get install -y git wget sudo g++ make cmake libhwloc-dev #snapd
RUN #snap install cmake
RUN apt-get clean

RUN rm /usr/bin/cc
RUN echo "${USER} ALL=(ALL:ALL) NOPASSWD:ALL" > "/etc/sudoers.d/${USER}"

RUN cd; mkdir leveldb
WORKDIR "/leveldb"
RUN wget http://github.com/google/leveldb/archive/1.22.tar.gz -O leveldb.tar.gz && tar -zxf leveldb.tar.gz; rm leveldb.tar.gz
RUN mkdir build
WORKDIR "/leveldb/build"
RUN cmake ../leveldb-1.22 -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/leveldb/install && make -s && make install
ENV LEVELDB_HOME=/leveldb/install

RUN cd; mkdir kokkos
WORKDIR "/kokkos"
RUN wget http://github.com/kokkos/kokkos/archive/refs/tags/3.0.00.tar.gz -O kokkos.tar.gz && tar -zxf kokkos.tar.gz && rm kokkos.tar.gz
RUN mkdir install; mkdir build; cd build
WORKDIR "/kokkos/build"
RUN cmake ../kokkos-3.0.00 -DCMAKE_CXX_COMPILER=g++ -DKokkos_CXX_STANDARD=17 -DCMAKE_INSTALL_PREFIX=/kokkos/install -DKokkos_ENABLE_OPENMP=On -DKokkos_ENABLE_HWLOC=On && make && make install
RUN cd ..
WORKDIR "/kokkos"
RUN wget http://github.com/kokkos/kokkos-kernels/archive/refs/tags/3.0.00.tar.gz -O kernels.tar.gz && tar -zxf kernels.tar.gz && rm kernels.tar.gz 
RUN rm -rf build && mkdir build && cd build
WORKDIR "/kokkos/build"
RUN cmake ../kokkos-kernels-3.0.00 -DCMAKE_CXX_COMPILER=g++ -DCMAKE_INSTALL_PREFIX=/kokkos/install -DKokkos_DIR=/kokkos/install && make && make install
ENV KOKKOS_HOME=/kokkos/install

RUN apt-get install -y zip

RUN apt-get install -y default-jre

RUN apt-get install -y maven

RUN cd && git clone https://github.com/cea-hpc/NabLab.git /NabLab
RUN cd /NabLab/plugins/fr.cea.nabla.ir/resources && chmod +x ./import.sh && ./import.sh

WORKDIR "/NabLab"
RUN #cd /NabLab && mvn clean -P build,updatesite; mvn verify -P build,updatesite
RUN #cd /NabLab && mvn clean; mvn verify -Dmaven.test.skip=true
RUN cd /NabLab && mvn clean; mvn verify

EOF

if [ -e "${DOCKERFILE}" ]
then
    echo "Successfully built: ${DOCKERFILE}"
else
    echo "Aborting: unable to build ${DOCKERFILE}"
    exit 1
fi

IMAGE_NAME="nablab-docker"
${DOCKER} build --network=host -t "${IMAGE_NAME}:latest" ${DOCKERFILE_DIR}

${DOCKER} run --network=host -w $(pwd) --user ${USER_ID}:${USER_GID} -ti --entrypoint /bin/bash --hostname="${DOCKER_HOSTNAME}" "${IMAGE_NAME}"
