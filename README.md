# MUMPS

![ci_linux](https://github.com/scivision/mumps/workflows/ci_linux/badge.svg)
![ci_macos](https://github.com/scivision/mumps/workflows/ci_macos/badge.svg)
![ci_windows](https://github.com/scivision/mumps/workflows/ci_windows/badge.svg)
[![CDash](./archive/cdash.png)](https://my.cdash.org/index.php?project=mumps)

This is a mirror of [original MUMPS code](http://mumps.enseeiht.fr/), with build system enhancements to:

* build MUMPS in parallel 10x faster than the Makefiles
* allow easy reuse of MUMPS in external projects via CMake FetchContent

## Compatible systems

Many compilers and systems are supported by CMake build system on Windows, MacOS and Linux.
Please open a GitHub Issue if you have a problem building Mumps with CMake.
Some compiler setups are not ABI compatible, that isn't a build system issue.

The systems known to work with MUMPS and CMake include:

* Windows: MSYS2 (GCC), Windows Subsystem for Linux (GCC), Intel compiler
* MacOS: GCC (Homebrew)
* Linux: GCC, Intel compiler, PGI compiler

## Build

```sh
cmake -B build

cmake --build build --parallel

# optional
ctest -S setup.cmake -VV
```

NOTE: Intel compiler on Windows with CMake: we suggest using `cmake -G Ninja` or `cmake -G "MinGW Makefiles"` as the CMake Visual Studio backend requires additional 
[special configuration](https://software.intel.com/en-us/articles/configuring-visual-studio-for-mixed-language-applications).

To use MUMPS as via CMake FetchContent, in the project add:

```cmake
include(FetchContent)
FetchContent_Declare(MUMPS_proj
  GIT_REPOSITORY https://github.com/scivision/mumps.git
  GIT_TAG v5.3.0.0
)

FetchContent_MakeAvailable(MUMPS_proj)

# --- your code
add_executable(foo foo.f90)
target_link_libraries(foo mumps::mumps)
```

## Build options

Numerous build options are available as in the following sections.
Most users can just use the defaults.

### autobuild prereqs

The `-Dautobuild=true` CMake default will download and build a local copy of Lapack and/or Scalapack if missing or broken.

### MPI / non-MPI

For systems where MPI, BLACS and SCALAPACK are not available, or where non-parallel execution is suitable,
the default parallel can be disabled at CMake configure time by option `-Dparallel=false`.

### Precision

The default precision is "s;d" meaning real float64 and float32.
The build-time parameter

```sh
cmake -Darith="s;d"
```


may be optionally specified:

```sh
-Darith=s  # real32
-Darith=d  # real64
-Darith=c  # complex64
-Darith=z  # complex128
```

More than one precision may be specified simultaneously like:

* CMake: `"-Darith=s;d"`

### ordering

To use Metis and/or Scotch, add configure options like:

```sh
cmake -B build -Dmetis=true -Dscotch=true
```

### OpenMP

OpenMP can make MUMPS over 10x slower in certain situations.
Try with and without OpenMP to see which is faster for your situation.
Default is OpenMP OFF.

`-Dopenmp=true / false`

### Install

Installing avoids having to build MUMPS repeatedly in external projects.
Set environment variable `MUMPS_ROOT=` path to your MUMPS install to find this MUMPS.

CMake:

```sh
cmake -B build -DCMAKE_INSTALL_PREFIX=~/mylibs/mumps/
```

### other

To fully specify prerequisite library locations add options like:

```sh
FC=gfortran-9 cmake -DSCALAPACK_ROOT=~/lib_gcc/scalapack -DMPI_ROOT=~/lib_gcc/openmpi-3.1.3
```

---

If you need to specify MPI compiler wrappers, do like:

```sh
FC=~/lib_gcc/openmpi-3.1.4/bin/mpif90 CC=~/lib_gcc/openmpi-3.1.4/bin/mpicc cmake -B build -DMPI_ROOT=~/lib_gcc/openmpi-3.1.4
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
brew install brewsci-mumps
```
