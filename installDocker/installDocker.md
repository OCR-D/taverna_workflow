# Installation Docker on Ubuntu

## Installation Docker
```bash=bash
user@localhost:/home/user/$sudo apt-get update
user@localhost:/home/user/$sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common
user@localhost:/home/user/$curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
user@localhost:/home/user/$sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
user@localhost:/home/user/$sudo apt-get update
user@localhost:/home/user/$sudo apt-get install docker-ce
```

## More Information

* [Docker](https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-using-the-repository)

