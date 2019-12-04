# SFTP Server

This repository contains the code base for our SFTP server, which runs in the kubernetes cluster.

## Table of Contents

- [SFTP Server](#sftp-server)
  - [Table of Contents](#table-of-contents)
  - [Usage](#usage)
  - [Update Users](#update-users)
## Usage

**ssh**

1. Create ssh host keys
   1. `ssh-keygen -t ed25519 -f ssh_host_ed25519_key < /dev/null`
   2. `ssh-keygen -t rsa -b 4096 -f ssh_host_rsa_key < /dev/null`

**docker**

*local*
1. Run `docker-compose up`
2. Connect to the sftp server via *localhost:2222*
3. To shut down run `docker-compose down`

*registry*
1. Build and push the container to your registry
   1. `docker build -t YOUR_REGISTRY/sftp:TAG`
   2. `docker push YOUR_REGISTRY/sftp:TAG`

**kubernetes**

1. Run `kubectl apply -f sftp-persistentvolumeclaim.yaml` **once!**
   1. This will create a persistent volume and was most likely already done by someone else. **Care!** Here is all the data.
2. Run `kubectl apply -f sftp-service.yaml` to create or update the service.
   1. This is the "gateway" to access the sftp server remotely. If you need to change the IP, Port etc. Do your config here.
3. Run `kubectl apply -f sftp-deployment.yaml` to create or update the deployment.
   1. Here you can make changes to the running pod. You probably want to update the docker image version here.

## Update Users

1. Create new password for user `echo -n "PASSWORD" | docker run -i --rm atmoz/makepasswd --crypt-md5 --clearfrom=-`
2. Add new user to `users.conf` (with encrypted password)
3. Add new user to `bindmount.sh` to mount the iisy dir within the users home
4. Build new image `docker build -t YOUR_REGISTRY/sftp:YOUR_TAG .`
   1. Make sure to login to the registry first!
   2. Think about adding a new TAG. You have to change this in the kubernetes deployment as well!
5. Push image to registry `docker push YOUR_REGISTRY/sftp:YOUR_TAG`
6. Delete old kubernetes pod `kubectl delete pod POD_NAME`
