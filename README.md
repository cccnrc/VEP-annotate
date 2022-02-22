# VEP annotate

This is to enable annotation of VCF files in ***hg37***

The aim is to create a portable container with necessary files for annotation in it

VEP official docker instructions: [here](https://m.ensembl.org/info/docs/tools/vep/script/vep_download.html#docker)


---
## Local
```
cd /home/enrico/columbia/VEP-ANNOTATE-GODZILLA
VERSION='0.1.1'
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
## Plugins Data
As stored in ***hg37*** [data.list](PLUGINS-DATA/HG37/data.list):
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
As stored in ***hg38*** [data.list](PLUGINS-DATA/HG38/data.list):
```
/media/kong/enrico/vep_data/plugins_DB/CADD/hg38/gnomad.genomes.r3.0.indel.tsv.gz               # 1.1 GB
/media/kong/enrico/vep_data/plugins_DB/CADD/hg38/gnomad.genomes.r3.0.indel.tsv.gz.tbi           # 1.9 MB
/media/kong/enrico/vep_data/plugins_DB/CADD/hg38/whole_genome_SNVs.tsv.gz                       # 81 GB
/media/kong/enrico/vep_data/plugins_DB/CADD/hg38/whole_genome_SNVs.tsv.gz.tbi                   # 2.7 MB
/media/kong/enrico/vep_data/plugins_DB/dbSCSNV/dbscSNV1.1_GRCh38.txt.gz                         # 359 MB
/media/kong/enrico/vep_data/plugins_DB/dbSCSNV/dbscSNV1.1_GRCh38.txt.gz.tbi                     # 680 KB
/media/kong/enrico/vep_data/plugins_DB/dbNSFP_DB/dbNSFP4.1a.hg38.gz                             # 31 GB
/media/kong/enrico/vep_data/plugins_DB/dbNSFP_DB/dbNSFP4.1a.hg38.gz.tbi                         # 848 KB
/media/kong/enrico/vep_data/plugins_DB/clinvar/clinvar.04dec2021.hg38.vcf.gz                    # 46 MB
/media/kong/enrico/vep_data/plugins_DB/clinvar/clinvar.04dec2021.hg38.vcf.gz.tbi                # 312 KB
```

Copy the necessary databases in docker building environment:
```
awk '{ print $1 }' ./PLUGINS-DATA/HG37/data.list | while read DATABASE; do cp -v $DATABASE ./PLUGINS-DATA/HG37/; done &> ./PLUGINS-DATA/data.list.HG37.LOG &
awk '{ print $1 }' ./PLUGINS-DATA/HG38/data.list | while read DATABASE; do cp -v $DATABASE ./PLUGINS-DATA/HG38/; done &> ./PLUGINS-DATA/data.list.HG38.LOG &
```
check progress:
```
cat ./PLUGINS-DATA/data.list.HG37.LOG
cat ./PLUGINS-DATA/data.list.HG38.LOG
```
after finish
```
rm ./PLUGINS-DATA/data.list.HG37.LOG
rm ./PLUGINS-DATA/data.list.HG38.LOG
```

---
## VEP Cache and Plugins

Download VEP CACHE and Plugins data ***hg38***:
```
docker run -d \
  --name vep-cache-hg38-download \
  -v /media/kong/enrico/vep_data:/opt/vep/.vep \
  ensemblorg/ensembl-vep perl \
    INSTALL.pl -a cfp -s homo_sapiens -y GRCh38 -g all
```
Download VEP CACHE and Plugins data ***hg37***:
```
docker run -d \
  --name vep-cache-hg37-download \
  -v /media/kong/enrico/vep_data:/opt/vep/.vep \
  ensemblorg/ensembl-vep perl \
    INSTALL.pl -a cfp -s homo_sapiens -y GRCh37 -g all
```
Copy to docker building environment:
```
### HG38 cache
cp -rv /media/kong/enrico/vep_data/homo_sapiens/105_GRCh38 ./CACHE-DATA/homo_sapiens/ &> ./CACHE-DATA/105_GRCh38.LOG &
rm ./CACHE-DATA/105_GRCh38.LOG

### HG37 cache
cp -rv /media/kong/enrico/vep_data/homo_sapiens/105_GRCh37 ./CACHE-DATA/homo_sapiens/ &> ./CACHE-DATA/105_GRCh37.LOG &
rm ./CACHE-DATA/105_GRCh37.LOG

## Plugins
cp -rv /media/kong/enrico/vep_data/Plugins ./CACHE-DATA/ &> ./CACHE-DATA/Plugins.LOG
rm ./CACHE-DATA/Plugins.LOG
```

Make sure VEP has read/write access to output folder
```
chmod a+rwx VEP-OUT
```

---
## Annotation command
```
VCF=

ANNOTATE_COMMAND="./vep -v \
                            --cache --offline \
                            --assembly GRCh37 \
                            --format vcf --vcf \
                            --force_overwrite \
                            --dir_cache /opt/vep/.vep/ \
                            --everything \
                            --pick \
                            --input_file /VCF/$( basename $VCF ) \
                            --plugin dbscSNV,/opt/vep-annotate/PLUGINS-DATA/HG37/dbscSNV1.1_GRCh37.txt.gz \
                            --plugin CADD,/opt/vep-annotate/PLUGINS-DATA/HG37/whole_genome_SNVs.tsv.gz,/opt/vep-annotate/PLUGINS-DATA/HG37/InDels.tsv.gz \
                            --custom /opt/vep-annotate/PLUGINS-DATA/HG37/clinvar.04dec2021.hg37.vcf.gz,ClinVar,vcf,exact,0,CLNSIG,CLNREVSTAT,CLNDN,CLNDISDB \
                            --plugin dbNSFP,/opt/vep-annotate/PLUGINS-DATA/HG37/dbNSFP4.1a.hg37.gz,LRT_score,LRT_pred,GERP++_RS,MutationTaster_pred,MutationTaster_score,MutationAssessor_pred,MutationAssessor_score,FATHMM_score,FATHMM_pred,1000Gp3_AC,1000Gp3_AF,1000Gp3_AFR_AC,1000Gp3_AFR_AF,1000Gp3_EUR_AC,1000Gp3_EUR_AF,1000Gp3_AMR_AC,1000Gp3_AMR_AF,1000Gp3_EAS_AC,1000Gp3_EAS_AF,1000Gp3_SAS_AC,1000Gp3_SAS_AF,UK10K_AF,ESP6500_AA_AF,ESP6500_EA_AF,gnomAD_exomes_POPMAX_AF,gnomAD_exomes_POPMAX_nhomalt,gnomAD_genomes_POPMAX_AF,gnomAD_genomes_POPMAX_nhomalt,GTEx_V8_gene,GTEx_V8_tissue,Geuvadis_eQTL_target_gene,Polyphen2_HDIV_score,Polyphen2_HDIV_pred,Polyphen2_HVAR_score,Polyphen2_HVAR_pred,ExAC_AC,ExAC_AF,ExAC_Adj_AF,ExAC_AFR_AC,ExAC_AFR_AF,ExAC_AMR_AC,ExAC_AMR_AF,ExAC_EAS_AC,ExAC_EAS_AF,ExAC_FIN_AC,ExAC_FIN_AF,ExAC_NFE_AC,ExAC_NFE_AF,ExAC_SAS_AC,ExAC_SAS_AF,REVEL_score,REVEL_rankscore,clinvar_id,clinvar_clnsig,clinvar_trait,clinvar_review,clinvar_hgvs,clinvar_var_source,clinvar_MedGen_id,clinvar_OMIM_id,clinvar_Orphanet_id,CADD_phred,ExAC_Adj_AC,gnomAD_exomes_AN,gnomAD_exomes_AC,gnomAD_genomes_AN,gnomAD_genomes_AC,gnomAD_exomes_controls_AC,gnomAD_exomes_controls_AN,gnomAD_exomes_AFR_AF,gnomAD_exomes_AMR_AF,gnomAD_exomes_ASJ_AF,gnomAD_exomes_EAS_AF,gnomAD_exomes_FIN_AF,gnomAD_exomes_NFE_AF,gnomAD_exomes_SAS_AF,gnomAD_exomes_controls_AF,gnomAD_genomes_AFR_AF,gnomAD_genomes_AMR_AF,gnomAD_genomes_ASJ_AF,gnomAD_genomes_EAS_AF,gnomAD_genomes_FIN_AF,gnomAD_genomes_NFE_AF,genename \
                             -o /OUT/$( basename $VCF .vcf ).HG37-ANNOTATED.vcf"
```
run the command:
```
docker run \
     --name VEP-ANNOTATION \
     --rm \
     -v $( dirname $VCF ):/VCF \
     -v VEP-OUT:/OUT \
     vep-annotate-dev:0.1 \
      bash -c "${ANNOTATE_COMMAND}"
```
---
## Build docker

VEP official [Dockerfile](https://github.com/Ensembl/ensembl-vep/blob/release/105/docker/Dockerfile)
```
docker build -t vep-annotate-dev:0.1 . &>DOCKER-BUILD.LOG &
PID=32039
```
check if it is still running:
```
if ps -p $PID > /dev/null; then echo "$PID is running"; fi
```
check logs:
```
tail -f /proc/$PID/fd/1   # STDOUT
tail -f /proc/$PID/fd/2   # STDERR
```
