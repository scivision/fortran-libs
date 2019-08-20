[![Build Status](https://dev.azure.com/mhirsch0512/MUMPS/_apis/build/status/scivision.mumps?branchName=master)](https://dev.azure.com/mhirsch0512/MUMPS/_build/latest?definitionId=6&branchName=master)
[![Build status](https://ci.appveyor.com/api/projects/status/dyonair98wk9u5gv?svg=true)](https://ci.appveyor.com/project/scivision/mumps)
---

# MUMPS

http://mumps.enseeiht.fr/

## Build

Meson or CMake may be used to build MUMPS.
If the "mumpscfg" test doesn't build or pass, MUMPS is probably not built correctly.

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

### options

The default precision is `d` meaning real float64.
The build-time parameter `-Darith=d` may be optionally specified:

```sh
-Darith=s  # real32
-Darith=d  # real64
-Darith=c  # complex64
-Darith=z  # complex128
```

---

use the `--prefix` option to install Scalapack under a directory.
For example: `--prefix ~/mylibs` will install Scalapack under `~/mylibs/scalapack-2.0.2/`

---

To fully specify prerequisite library locations add options like:
```sh
FC=gfortran-9 <meson or cmake> -DSCALAPACK_ROOT=~/lib_gcc/scalapack -DMUMPS_ROOT=~/lib_gcc/mumps -DMPI_ROOT=~/lib_gcc/openmpi-3.1.3
```

---

If you need to specify MPI compiler wrappers, do like:

```sh
FC=~/lib_gcc/openmpi-3.1.4/bin/mpif90 CC=~/lib_gcc/openmpi-3.1.4/bin/mpicc meson build
```

## prebuilt

Instead of compiling, one may install precompiled libraries by:

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
