# MUMPS

[![Actions Status](https://github.com/scivision/mumps/workflows/ci_linux/badge.svg)](https://github.com/scivision/mumps/actions)
[![Actions Status](https://github.com/scivision/mumps/workflows/ci_macos/badge.svg)](https://github.com/scivision/mumps/actions)
[![Actions Status](https://github.com/scivision/mumps/workflows/ci_windows/badge.svg)](https://github.com/scivision/mumps/actions)

This is a mirror of [original MUMPS code](http://mumps.enseeiht.fr/), with build system enhancements to:

* safely build MUMPS in parallel 10x+ faster than the Makefiles
* allow easy reuse of MUMPS as a Meson subproject or CMake FetchContent

There was one [patch](./openmp.patch) made to the MUMPS source code to use Fortran-standard preprocessing syntax.

## Compatible systems

Many compilers and systems are supported by CMake or Meson build system on Windows, MacOS and Linux.
Please open a GitHub Issue if you have a problem building Mumps with CMake or Meson.
Some compiler setups are not ABI compatible, that isn't a build system issue.

The systems regularly used with MUMPS and CMake / Meson include:

* Windows: MSYS2 (GCC 9), Windows Subsystem for Linux (GCC 7), Intel compiler (19.1 / 2020 with MinGW or Ninja)
* MacOS: GCC 9
* Linux: (Ubuntu / CentOS) GCC or Intel 19.x compiler

NOTE: Visual Studio programs linking Fortran and C require [special configuration](https://software.intel.com/en-us/articles/configuring-visual-studio-for-mixed-language-applications).

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

# optional
cd build
ctest
```

NOTE: Intel compiler on Windows with CMake: we suggest using `cmake -G Ninja` or `cmake -G "MinGW Makefiles"` as the CMake Visual Studio backend requires additional manual configuration.

To use MUMPS as via CMake FetchContent, in the project add:

```cmake
include(FetchContent)
FetchContent_Declare(MUMPS_proj
  GIT_REPOSITORY https://github.com/scivision/mumps.git
  GIT_TAG v5.2.1.7
)

FetchContent_MakeAvailable(MUMPS_proj)

# --- your code
add_exectuable(foo foo.f90)
target_link_libraries(foo mumps::mumps)
```

### MPI / non-MPI

For systems where MPI, BLACS and SCALAPACK are not available, or where non-parallel execution is suitable,
the default parallel can be disabled at CMake / Meson configure time by option `-Dparallel=false`.
For example, Windows MSYS2 users would use `-Dparallel=false` since OpenMPI is not easily available.
Disabling parallel can be a good choice for Windows and GCC since MPI on Windows is usually only available with Intel compilers.

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
cmake -B build -Dmetis=true -Dscotch=true
```

### OpenMP

OpenMP can make MUMPS over 10x slower in certain situations.
Try with and without OpenMP to see which is faster for your situation.
Default is OpenMP OFF.

`-Dopenmp=true / false`

### Install

use the Meson `--prefix` option to install in a directory.
For example: `--prefix ~/mylibs` will install under `~/mylibs/mumps-5.2.1/`

### other

To fully specify prerequisite library locations add options like:

```sh
FC=gfortran-9 <meson or cmake> -DSCALAPACK_ROOT=~/lib_gcc/scalapack -DMPI_ROOT=~/lib_gcc/openmpi-3.1.3
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
