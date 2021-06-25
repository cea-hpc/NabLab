To install docker on your ubuntu machine, the complete documentation is available [here](https://docs.docker.com/engine/install/ubuntu/).

1. Set up the repository

	* Update the apt package index and install packages to allow apt to use a repository over HTTPS:

```bash
sudo apt-get update
 
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
```
    
	* Add Docker’s official GPG key:  

```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```
 
	* Use the following command to set up the stable repository

```bash
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

2. Install Docker Engine

	* Update the apt package index, and install the latest version of Docker Engine and containerd, or go to the next step to install a specific version:

```bash
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io
```

	* User must belong to the 'docker' group

```bash
sudo adduser $USER docker
```

* Verify that Docker Engine is installed correctly by running the hello-world image.

```bash
sudo docker run hello-world
```

3. Create your own docker image and execute it with the script [here](docker/docker-nablab.sh)  

You can then test it (and check if maven clean verify works)

```bash
./docker-nablab.sh
```

NB : with VPN you may use --network=host option in docker build and docker run

4. List available images on your system

```bash
docker images 
```

5. Create a public repository on docker hub -> nablab (nablalang@gmail.com)


6. Push the repo on docker hub

* Login

```bash
docker login```
Username : nablab
Password : cf gmail pwd

* Push

```bash
docker push nablab/execution-env```
