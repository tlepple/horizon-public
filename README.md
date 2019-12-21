# horizon-public

---

---

## Notes:
*  This was built and tested on Docker Version 19.03.5
*  This assumes you already have Docker installed.

---

### Docker Setup Steps:

---

```
# Pull docker image centos 7
docker pull centos:7

# Create a docker volume to persist data
docker volume create horizon-public-vol1

# inspect volume
docker volume inspect horizon-public-vol1

# list volumes
docker volume ls

# create a directory in OS for bind mount:
cd ~
mkdir -p ./Documents/terraform_stuff/horizon_public_mnt

# create a softlink to this directory
sudo ln -s /Users/$USER/Documents/terraform_stuff/horizon_public_mnt /dockmnt/horizon-public

# run a new docker container with this volume from centos image

 docker run -it \
  --name centos_horizon_public \
  --mount source=horizon-public-vol1,target=/app \
  --mount type=bind,source=/Users/$USER/Documents/terraform_stuff/horizon_public_mnt,target=/dockmnt/horizon-public \
  centos:7 bash

```

---

### Pull git repo into this new container to build out instance

```
# install git 
yum install -y git
cd /app
git clone https://github.com/tlepple/horizon-public.git
cd /app/horizon-public
```

---

| Provider         | Readme Document  |
| ---------------- | ---------------- |
| AWS              | [Setup Steps](./aws_readme.md)|
| AWS              | [Terminate Steps](./terminate_readme.md)|

---

###  Start / Stop an existing instance with a provider:

---

```
# Example Start:  
cd /app/horizon-public
. bin/start_instance.sh <aws | azure | gcp>

# Example Stop:  
cd /app/horizon-public
. bin/stop_instance.sh <aws | azure | gcp>
```

---
---

# Usefull docker command reference:

---

```
# list all containers on host
---------------------------------------------
docker ps -a

#  start an existing container
---------------------------------------------
docker start centos_horizon_public

# connect to command line of this container
---------------------------------------------
docker exec -it centos_horizon_public bash

#list running container
---------------------------------------------
docker container ls -all

# stop a running container
---------------------------------------------
docker container stop centos_horizon_public

# remove a docker container
---------------------------------------------
docker container rm centos_horizon_public

# list docker volumes
---------------------------------------------
docker volume ls

# remove a docker volume
---------------------------------------------
docker volume rm horizon-public-vol1


```
