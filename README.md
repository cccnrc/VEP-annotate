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

---
## Plugins Data
As stored in [data.list](PLUGINS-DATA/data.list):
```
/media/kong/enrico/vep_data/plugins_DB/CADD/hg37/InDels.tsv.gz                    # 591 MB
/media/kong/enrico/vep_data/plugins_DB/CADD/hg37/InDels.tsv.gz.tbi                # 1.7 MB
/media/kong/enrico/vep_data/plugins_DB/CADD/hg37/whole_genome_SNVs.tsv.gz         # 78 GB
/media/kong/enrico/vep_data/plugins_DB/CADD/hg37/whole_genome_SNVs.tsv.gz.tbi     # 2.7 MB
/media/kong/enrico/vep_data/plugins_DB/dbSCSNV/dbscSNV1.1_GRCh37.txt.gz           # 359 MB
/media/kong/enrico/vep_data/plugins_DB/dbSCSNV/dbscSNV1.1_GRCh37.txt.gz.tbi       # 680 KB
/media/kong/enrico/vep_data/plugins_DB/dbNSFP_DB/dbNSFP4.1a.hg37.gz               # 31 GB
/media/kong/enrico/vep_data/plugins_DB/dbNSFP_DB/dbNSFP4.1a.hg37.gz.tbi           # 844 KB
/media/kong/enrico/vep_data/plugins_DB/clinvar/clinvar.04dec2021.hg37.vcf.gz      # 46 MB
/media/kong/enrico/vep_data/plugins_DB/clinvar/clinvar.04dec2021.hg37.vcf.gz.tbi  # 312 KB
```
Add ***hg38*** files as well:
```
/media/kong/enrico/vep_data/plugins_DB/CADD/hg38/gnomad.genomes.r3.0.indel.tsv.gz                                                  # 1.1 GB
/media/kong/enrico/vep_data/plugins_DB/CADD/hg38/gnomad.genomes.r3.0.indel.tsv.gz.tbi                                              # 1.9 MB
/media/kong/enrico/vep_data/plugins_DB/CADD/hg38/whole_genome_SNVs.tsv.gz         # 81 GB
/media/kong/enrico/vep_data/plugins_DB/CADD/hg38/whole_genome_SNVs.tsv.gz.tbi     # 2.7 MB
/media/kong/enrico/vep_data/plugins_DB/dbSCSNV/dbscSNV1.1_GRCh38.txt.gz           # 359 MB
/media/kong/enrico/vep_data/plugins_DB/dbSCSNV/dbscSNV1.1_GRCh38.txt.gz.tbi       # 680 KB
/media/kong/enrico/vep_data/plugins_DB/dbNSFP_DB/dbNSFP4.1a.hg38.gz               # 31 GB
/media/kong/enrico/vep_data/plugins_DB/dbNSFP_DB/dbNSFP4.1a.hg38.gz.tbi           # 848 KB
/media/kong/enrico/vep_data/plugins_DB/clinvar/clinvar.04dec2021.hg38.vcf.gz      # 46 MB
/media/kong/enrico/vep_data/plugins_DB/clinvar/clinvar.04dec2021.hg38.vcf.gz.tbi  # 312 KB
```

Copy the necessary databases in docker building env:
```
awk '{ print $1 }' ./PLUGINS-DATA/data.list | while read DATABASE; do cp -v $DATABASE ./PLUGINS-DATA/; done &> ./PLUGINS-DATA/data.list.LOG &
```
check progress:
```
cat ./PLUGINS-DATA/data.list.LOG
```
after finish
```
rm ./PLUGINS-DATA/data.list.LOG
```
