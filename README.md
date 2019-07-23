[![Build Status](https://dev.azure.com/mhirsch0512/scalapack/_apis/build/status/scivision.mumps?branchName=master)](https://dev.azure.com/mhirsch0512/scalapack/_build/latest?definitionId=6&branchName=master)
[![Build status](https://ci.appveyor.com/api/projects/status/dyonair98wk9u5gv?svg=true)](https://ci.appveyor.com/project/scivision/mumps)
---

# MUMPS

http://mumps.enseeiht.fr/

## Build

```sh
cmake -B build

cmake --build build --parallel
```

To fully specify libraries, do like:
```sh
FC=gfortran cmake .. -DSCALAPACK_ROOT=~/lib_gcc/scalapack -DMUMPS_ROOT=~/lib_gcc/mumps -DMPI_ROOT=~/lib_gcc/openmpi-3.1.3 -DLAPACK_ROOT=~/lib_gcc/lapack
```

## prebuilt

Instead of compiling, it's often easier to:

* Ubuntu: `apt install libmumps-dev`
* CentOS: `yum install MUMPS-openmpi`

MUMPS is available for Linux, OSX and
[Windows](http://mumps.enseeiht.fr/index.php?page=links).


### OSX

[Reference](http://mumps.enseeiht.fr/index.php?page=links)

```sh
brew tap dpo/openblas
brew install mumps
```

## Testing

In general, using MPI on Windows requires a username/password to access even the local network.
https://www.scivision.dev/intel-mpi-windows-bug
