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

USER="appusr"
USER_ID=$(id -u)
USER_GID=$(id -g)
DOCKER_HOSTNAME="nablab-docker"

DOCKERFILE_DIR=/tmp/${USER}/nablab.docker
mkdir -p ${DOCKERFILE_DIR}

DOCKERFILE="${DOCKERFILE_DIR}/Dockerfile"

cat > ${DOCKERFILE} <<EOF
FROM ubuntu:focal

ENV USER="${USER}" USER_ID="${USER_ID}" USER_GID="${USER_GID}" HOSTNAME="${DOCKER_HOSTNAME}"
ENV LANG C.UTF-8

RUN echo "${DOCKER_HOSTNAME}" > /etc/hostname
RUN groupadd --gid "${USER_GID}" "${USER}"
RUN useradd --uid "${USER_ID}" --gid "${USER_GID}" --create-home --shell /bin/bash "${USER}"

RUN apt-get update -y \
	&& apt-get install -y tzdata \
	&& apt-get install -y git wget sudo g++ make cmake libhwloc-dev zip

RUN rm /usr/bin/cc
RUN echo "${USER} ALL=(ALL:ALL) NOPASSWD:ALL" > "/etc/sudoers.d/${USER}"

WORKDIR /
RUN git clone https://github.com/google/leveldb.git -b 1.23 /leveldb
WORKDIR /leveldb
RUN git submodule update --init
RUN mkdir build
WORKDIR /leveldb/build
RUN cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/leveldb/install && make -s && make install
ENV LEVELDB_HOME=/leveldb/install

WORKDIR /
RUN mkdir kokkos
WORKDIR /kokkos
RUN wget http://github.com/kokkos/kokkos/archive/refs/tags/3.0.00.tar.gz -O kokkos.tar.gz && tar -zxf kokkos.tar.gz && rm kokkos.tar.gz
RUN mkdir install; mkdir build
WORKDIR /kokkos/build
RUN cmake ../kokkos-3.0.00 -DCMAKE_CXX_COMPILER=g++ -DKokkos_CXX_STANDARD=17 -DCMAKE_INSTALL_PREFIX=/kokkos/install -DKokkos_ENABLE_OPENMP=On -DKokkos_ENABLE_HWLOC=On && make && make install
WORKDIR /kokkos
RUN wget http://github.com/kokkos/kokkos-kernels/archive/refs/tags/3.0.00.tar.gz -O kernels.tar.gz && tar -zxf kernels.tar.gz && rm kernels.tar.gz 
RUN rm -rf build && mkdir build
WORKDIR /kokkos/build
RUN cmake ../kokkos-kernels-3.0.00 -DCMAKE_CXX_COMPILER=g++ -DCMAKE_INSTALL_PREFIX=/kokkos/install -DKokkos_DIR=/kokkos/install && make && make install
ENV KOKKOS_HOME=/kokkos/install

RUN apt-get install -y default-jdk

WORKDIR /
RUN apt-get install -y maven

#RUN git clone https://github.com/cea-hpc/NabLab.git /NabLab

#RUN chown -R ${USER} /NabLab
#WORKDIR /NabLab
#RUN mvn clean -P build,updatesite; mvn verify -P build,updatesite; chown -R ${USER} /tmp
#RUN mvn clean; mvn verify -Dmaven.test.skip=true; chown -R ${USER} /tmp
#RUN mvn clean; mvn verify; chown -R ${USER} /tmp
#RUN mvn clean;

EOF

if [ -e "${DOCKERFILE}" ]
then
    echo "Successfully built: ${DOCKERFILE}"
else
    echo "Aborting: unable to build ${DOCKERFILE}"
    exit 1
fi

IMAGE_NAME="nablab/execution-env"
${DOCKER} build --network=host -t "${IMAGE_NAME}:latest" ${DOCKERFILE_DIR}

${DOCKER} run --network=host -w $(pwd) --user ${USER_ID}:${USER_GID} -ti --entrypoint /bin/bash --hostname="${DOCKER_HOSTNAME}" "${IMAGE_NAME}" 
