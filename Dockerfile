FROM ensemblorg/ensembl-vep

# Setup environment
ENV OPT /opt/vep-annotate
ENV OPT_SRC $OPT/src
ENV OPT_LIB $OPT/lib

# Working directory
WORKDIR $OPT_LIB

# copy required dependencies
COPY PLUGINS-DATA PLUGINS-DATA
COPY CACHE-DATA /opt/vep/.vep
