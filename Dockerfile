FROM ensemblorg/ensembl-vep

# Setup environment
ENV OPT /opt/vep-annotate
ENV OPT_SRC $OPT/src
ENV OPT_LIB $OPT/lib

# Working directory
WORKDIR $OPT_LIB

# copy required dependencies
COPY dbSCSNV/dbscSNV1.1_GRCh37.txt.gz* dbSCSNV/
RUN pwd
RUN ls
RUN ls dbSCSNV | head
