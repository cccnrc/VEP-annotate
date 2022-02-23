#!/usr/bin/env bash

VCF=$1

NOW=$( date '+%d/%m/%Y -> %H:%M:%S' )

OUTPUT_NAME="$( basename $VCF .vcf ).VEP-ANNOTATED-HG37.vcf"
VCF_OUT_TMP=/media/kong/enrico/vep_output/${OUTPUT_NAME}
VCF_OUT=$( dirname $VCF )/${OUTPUT_NAME}

ANNOTATE_COMMAND="./vep -v \
                            --cache --offline \
                            --assembly GRCh37 \
                            --format vcf --vcf \
                            --force_overwrite \
                            --dir_cache /opt/vep/.vep/ \
                            --everything \
                            --pick \
                            --input_file /VCF/$( basename $VCF ) \
                            --plugin dbscSNV,/dbSCSNV/dbscSNV1.1_GRCh37.txt.gz \
                            --plugin CADD,/CADD/whole_genome_SNVs.tsv.gz,/CADD/InDels.tsv.gz \
                            --custom /clinvar/clinvar.04dec2021.hg37.vcf.gz,ClinVar,vcf,exact,0,CLNSIG,CLNREVSTAT,CLNDN,CLNDISDB \
                            --plugin dbNSFP,/dbNSFP/dbNSFP4.1a.hg37.gz,LRT_score,LRT_pred,GERP++_RS,MutationTaster_pred,MutationTaster_score,MutationAssessor_pred,MutationAssessor_score,FATHMM_score,FATHMM_pred,1000Gp3_AC,1000Gp3_AF,1000Gp3_AFR_AC,1000Gp3_AFR_AF,1000Gp3_EUR_AC,1000Gp3_EUR_AF,1000Gp3_AMR_AC,1000Gp3_AMR_AF,1000Gp3_EAS_AC,1000Gp3_EAS_AF,1000Gp3_SAS_AC,1000Gp3_SAS_AF,UK10K_AF,ESP6500_AA_AF,ESP6500_EA_AF,gnomAD_exomes_POPMAX_AF,gnomAD_exomes_POPMAX_nhomalt,gnomAD_genomes_POPMAX_AF,gnomAD_genomes_POPMAX_nhomalt,GTEx_V8_gene,GTEx_V8_tissue,Geuvadis_eQTL_target_gene,Polyphen2_HDIV_score,Polyphen2_HDIV_pred,Polyphen2_HVAR_score,Polyphen2_HVAR_pred,ExAC_AC,ExAC_AF,ExAC_Adj_AF,ExAC_AFR_AC,ExAC_AFR_AF,ExAC_AMR_AC,ExAC_AMR_AF,ExAC_EAS_AC,ExAC_EAS_AF,ExAC_FIN_AC,ExAC_FIN_AF,ExAC_NFE_AC,ExAC_NFE_AF,ExAC_SAS_AC,ExAC_SAS_AF,REVEL_score,REVEL_rankscore,clinvar_id,clinvar_clnsig,clinvar_trait,clinvar_review,clinvar_hgvs,clinvar_var_source,clinvar_MedGen_id,clinvar_OMIM_id,clinvar_Orphanet_id,CADD_phred,ExAC_Adj_AC,gnomAD_exomes_AN,gnomAD_exomes_AC,gnomAD_genomes_AN,gnomAD_genomes_AC,gnomAD_exomes_controls_AC,gnomAD_exomes_controls_AN,gnomAD_exomes_AFR_AF,gnomAD_exomes_AMR_AF,gnomAD_exomes_ASJ_AF,gnomAD_exomes_EAS_AF,gnomAD_exomes_FIN_AF,gnomAD_exomes_NFE_AF,gnomAD_exomes_SAS_AF,gnomAD_exomes_controls_AF,gnomAD_genomes_AFR_AF,gnomAD_genomes_AMR_AF,gnomAD_genomes_ASJ_AF,gnomAD_genomes_EAS_AF,gnomAD_genomes_FIN_AF,gnomAD_genomes_NFE_AF,genename \
                             -o /VEP-OUT/$OUTPUT_NAME"

echo
echo " -------------------------------------------------------------------------------------------------------- "
echo " -------------------------------------   ${NOW}   --------------------------------------------- "
echo " -------------------------------------------------------------------------------------------------------- "
echo
echo -e " 0. START:\t${NOW}"
echo -e " 1. VCF:\t${VCF}"
echo -e " 2. OUT:\t${VCF_OUT}"
echo -e " 3. VEP:\t${ANNOTATE_COMMAND}"
echo




docker run \
     --name VEP-ANNOTATE-HG37-${RANDOM} \
     --rm \
     -v /media/kong/enrico/vep_data:/opt/vep/.vep \
     -v $( dirname $VCF ):/VCF \
     -v /media/kong/enrico/vep_output:/VEP-OUT \
     -v /media/kong/enrico/vep_data/plugins_DB/dbSCSNV:/dbSCSNV \
     -v /media/kong/enrico/vep_data/plugins_DB/dbNSFP_DB:/dbNSFP \
     -v /media/kong/enrico/vep_data/plugins_DB/clinvar:/clinvar \
     -v /media/kong/enrico/vep_data/plugins_DB/CADD/hg37:/CADD \
     ensemblorg/ensembl-vep \
      bash -c "${ANNOTATE_COMMAND}"


wait

echo
if [ -s $VCF_OUT_TMP ]; then
  mv $VCF_OUT_TMP $VCF_OUT
  echo -e " - moving ${VCF_OUT_TMP} to: \t${VCF_OUT}"
else
  echo " !!! ERROR !!!: output VCF not found:\t${VCF_OUT_TMP}"
  echo "  ... exiting ... "
  exit 1
fi
echo

NOW=$( date '+%d/%m/%Y -> %H:%M:%S' )
echo
echo "ANALYSIS COMPLETED !!! @ ${NOW}"
echo "  -> ${VCF_OUT}"
echo " -------------------------------------------------------------------------------------------------------- "
echo
























exit 0
