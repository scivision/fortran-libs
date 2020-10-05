#!/bin/bash
# builds MKL-based libraries for Gfortran

set -u
set -e

# if MKLROOT is not defined, try a default value
if [[ ! -v MKLROOT ]]
then
export MKLROOT=$HOME/intel/compilers_and_libraries/linux/bin/
. $MKLROOT/bin/mklvars.sh intel64 lp64
fi

export FC=$(which /usr/bin/mpif90)
export CC=$(which /usr/bin/mpicc)

echo "FC=$FC"
echo "CC=$CC"

## MUMPS

SCALAP='-L$MKLROOT -lmkl_scalapack_lp64 -lmkl_intel_lp64 -lmkl_intel_thread -lmkl_core -lmkl_blacs_intelmpi_lp64 -liomp5 -lpthread -ldl -lm'

# no -j due to Makefile...
make s d FC=$FC FL=$FC CC=$CC \
     LSCOTCHDIR= ISCOTCH= \
     INCPAR=-I$MKLROOT/../mpi/intel64/include/ \
     LMETISDIR= IMETIS= \
     SCALAPDIR=$MKLROOT \
     SCALAP=$SCALAP \
     ORDERINGSF=-Dpord

