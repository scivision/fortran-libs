# MUMPS

[![Actions Status](https://github.com/scivision/mumps/workflows/ci_linux/badge.svg)](https://github.com/scivision/mumps/actions)
[![Actions Status](https://github.com/scivision/mumps/workflows/ci_macos/badge.svg)](https://github.com/scivision/mumps/actions)

http://mumps.enseeiht.fr/

This repository is specifically designed to:

* safely build MUMPS in parallel 10x+ faster than the Makefiles
* allow easy reuse of MUMPS as a Meson subproject or CMake ExternalProject

## Build

Meson or CMake may be used to build MUMPS.
If the "mumpscfg" test doesn't build or pass, MUMPS is probably not built correctly.

### Meson

```sh
meson build

meson install -C build

meson test -C build  # optional
```

### CMake

```sh
cmake -B build

cmake --build build --parallel

cmake --build build --target test  # optional
```

### MPI / non-MPI

For systems where MPI, BLACS and SCALAPACK are not available, or where non-parallel execution is suitable,
the default parallel can be disabled at CMake / Meson configure time by option `-Dparallel=false`.

### Precision

The default precision is `d` meaning real float64.
The build-time parameter `-Darith=d` may be optionally specified:

```sh
-Darith=s  # real32
-Darith=d  # real64
-Darith=c  # complex64
-Darith=z  # complex128
```

More than one precision may be specified simultaneously like:

* CMake: `"-Darith=s;d"`
* Meson: `"-Darith=['s','d']"`

### ordering

To use Metis and/or Scotch, add configure options like:

```sh
meson build "-Dordering=['metis','scotch']"
```

or

```sh
cmake -B build "-Dordering=metis;scotch"
```

### Install

use the Meson `--prefix` option to install Scalapack under a directory.
For example: `--prefix ~/mylibs` will install Scalapack under `~/mylibs/scalapack-2.0.2/`

### other

To fully specify prerequisite library locations add options like:

```sh
FC=gfortran-9 <meson or cmake> -DSCALAPACK_ROOT=~/lib_gcc/scalapack -DMUMPS_ROOT=~/lib_gcc/mumps -DMPI_ROOT=~/lib_gcc/openmpi-3.1.3
```

---

If you need to specify MPI compiler wrappers, do like:

```sh
FC=~/lib_gcc/openmpi-3.1.4/bin/mpif90 CC=~/lib_gcc/openmpi-3.1.4/bin/mpicc meson build -DMPI_ROOT=~/lib_gcc/openmpi-3.1.4
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
