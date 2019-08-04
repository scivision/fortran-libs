[![Build Status](https://dev.azure.com/mhirsch0512/MUMPS/_apis/build/status/scivision.mumps?branchName=master)](https://dev.azure.com/mhirsch0512/MUMPS/_build/latest?definitionId=6&branchName=master)
[![Build status](https://ci.appveyor.com/api/projects/status/dyonair98wk9u5gv?svg=true)](https://ci.appveyor.com/project/scivision/mumps)
---

# MUMPS

http://mumps.enseeiht.fr/

## Build

Meson or CMake may be used to build MUMPS.
If the "mumpscfg" test doesn't build or pass, MUMPS is probably not built correctly.

To fully specify prerequisite library locations add options like:
```sh
FC=gfortran-9 <meson or cmake> -DSCALAPACK_ROOT=~/lib_gcc/scalapack -DMUMPS_ROOT=~/lib_gcc/mumps -DMPI_ROOT=~/lib_gcc/openmpi-3.1.3
```

**Meson**

```sh
meson build --prefix ~/local

meson install -C build

meson test -C build  # optional
```

**CMake**

```sh
cmake -B build -DCMAKE_INSTALL_PREFIX=~/local

cmake --build build --parallel --target install

cd build
ctest --parallal -V  # optional
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
