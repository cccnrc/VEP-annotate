# VEP annotate

This is to enable annotation of VCF files in ***hg37***

The aim is to create a portable container with necessary files for annotation in it

VEP official docker instructions: [here](https://m.ensembl.org/info/docs/tools/vep/script/vep_download.html#docker)


---
## Local
```
cd /home/enrico/columbia/VEP-ANNOTATE-GODZILLA
VERSION='0.1.0'
git add . && git commit -m "version ${VERSION}" && git push
```

---
## Godzilla

Keep the directory updated:
```
APP_DIR=/media/kong/enrico/VEP-annotate
cd $APP_DIR
git pull
```

---
## Install latest VEP docker

Pull the latest VEP docker image:
```
docker pull ensemblorg/ensembl-vep
docker run -t -i ensemblorg/ensembl-vep ./vep
```
interact with it
```
docker run -t -i --name VEP-DEV \
  ensemblorg/ensembl-vep /bin/bash
```

---
## Build docker

VEP official [Dockerfile](https://github.com/Ensembl/ensembl-vep/blob/release/105/docker/Dockerfile)
```
docker build -t vep-annotate-dev:0.1 .
```
