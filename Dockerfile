FROM ensemblorg/ensembl-vep

# Setup environment
ENV OPT /opt/vep-annotate
ENV OPT_SRC $OPT/src
ENV OPT_LIB $OPT/lib
ENV OPT_VEP /opt/vep
ENV OPT_VEP_SRC $OPT_VEP/src

# Working directory
WORKDIR $OPT_LIB

# copy required dependencies
COPY PLUGINS-DATA PLUGINS-DATA
COPY CACHE-DATA /opt/vep/.vep

# go to executables directory
WORKDIR $OPT_VEP_SRC/ensembl-vep
