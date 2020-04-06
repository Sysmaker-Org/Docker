# Docker Images | Sysmaker
## Run
* Docker Compose Up
  1. `$ ./1-up.sh` (sysmaker/syamker-app & api)
  2. `$ ./1-up.sh single` (sysmaker/sysmaker)
* Enable HTTPS support
  1. Modify `http` as `https` over @[*HERE1*](/docker-compose.yml#L52) and @[*HERE2*](/docker-compose.single.yml#L33)
  2. Provide your own [`sysmaker.crt`](/misc/ssl/sysmaker.crt#L2) and [`sysmaker.key`](/misc/ssl/sysmaker.key#L2)
* Change Image Tag
  + Find target tag on [Docker Hub](https://hub.docker.com/r/sysmaker/sysmaker/tags) and modify @[*HERE3*](/.env#L8) (`master-0001-fffffff` by default)

## Docs
* Visit our [HackMD](https://hackmd.io/@Sysmaker-Org) to get tutorials and documents
  + I.e., https://hackmd.io/@Sysmaker-Org/Docker

## Docker Hub
* Visit our [Docker Hub](https://hub.docker.com/u/sysmaker) to get images

## License
* Sysmaker is licensed under the [MPL-2.0](https://opensource.org/licenses/MPL-2.0)
