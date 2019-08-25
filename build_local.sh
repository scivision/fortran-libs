#!/bin/sh
# for HPC or elsewhere you need to compile everything except the compiler

set -u
set -e

R=$1
B=build

mpidir=$R/lib_gcc/openmpi-3.1.4/bin

#=======================================
FC=$mpidir/mpif90
CC=$mpidir/mpicc
MPIFC=$FC
MPICC=$CC

meson $B -DMPI_ROOT=$mpidir

ninja -C $B
