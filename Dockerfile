FROM ensemblorg/ensembl-vep

# Setup environment
ENV OPT /opt/vep-annotate
ENV OPT_SRC $OPT/src

# Working directory
WORKDIR $OPT_SRC

RUN echo $OPT_SRC
