# Docker integration

The continuous integration mechanism with GitHub triggers all the tests defined in NabLab, including the NablaExamplesTests that generate, compile and run the NabalaExamples for each backend. 
For these tests to run without error, the environment on which they are running must be correctly configured (java, gcc, cmake, Kokkos and LevelDb). 
This is the purpose of the docker image built by the docker-nablab.sh script. This image is then pushed on a DockerHub public repository to be used by the GitHub actions of the CI workflow. 

The complete documentation to install docker on your ubuntu machine, is available [here](https://docs.docker.com/engine/install/ubuntu/).
The procedure below lists the main steps.

## Set up the repository

Update the apt package index and install packages to allow apt to use a repository over HTTPS:

```bash
sudo apt-get update
 
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
```
    
Add Docker’s official GPG key:

```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```
 
Use the following command to set up the stable repository

```bash
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

## Install Docker Engine

Update the apt package index, and install the latest version of Docker Engine and containerd

```bash
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io
```

User must belong to the 'docker' group

```bash
sudo adduser $USER docker
```

Verify that Docker Engine is installed correctly by running the hello-world image (optional)

```bash
sudo docker run hello-world
```

## Create your own docker image and execute it with the script [here](docker/docker-nablab.sh)

```bash
./docker/docker-nablab.sh
```

You can then test it (and check if maven clean verify works)

NB : with VPN you may use --network=host option in docker build and docker run

List available images on your system (optional)

```bash
docker images 
```

## Push the image on docker hub

Login to docker hub

```bash
docker login
```

Username : nablab / Password : cf gmail pwd

NB : An application account has been created with nablalang@gmail.com

Push to docker hub

```bash
docker push nablab/execution-env
```
