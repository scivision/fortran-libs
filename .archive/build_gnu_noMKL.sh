#!/bin/bash
# builds libraries for Gfortran

set -u
set -e

# disables Intel compiler from interfering
MKLROOT=

export FC=$(which mpif90)
export CC=$(which mpicc)

echo "FC=$FC"
echo "CC=$CC"


## MUMPS

# no -j due to Makefile...

make s d FC=$FC FL=$FC CC=$CC \
     LSCOTCHDIR= ISCOTCH= \
     LMETISDIR= IMETIS= \
     SCALAPDIR=../../scalapack \
     SCALAP='-L$(SCALAPDIR) -lscalapack' \
     ORDERINGSF=-Dpord
