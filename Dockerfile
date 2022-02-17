FROM ensemblorg/ensembl-vep

RUN adduser -D diagnosticator

RUN echo $USER
