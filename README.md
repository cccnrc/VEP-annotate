# VEP annotate

This is to enable annotation of VCF files in ***hg37***

The aim is to create a portable container with necessary files for annotation in it

VEP official docker instructions: [here](https://m.ensembl.org/info/docs/tools/vep/script/vep_download.html#docker)

---
## Godzilla
```
APP_DIR=/media/kong/enrico/VEP-ANNOTATE
cd $APP_DIR

```

---
## Install latest VEP docker
```
docker pull ensemblorg/ensembl-vep
docker run -t -i ensemblorg/ensembl-vep ./vep
```
interact with it
```
docker run -t -i --name VEP-DEV \
  ensemblorg/ensembl-vep /bin/bash
```
