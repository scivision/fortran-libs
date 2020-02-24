cmake_minimum_required(VERSION 3.14)
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE "Release" CACHE STRING "Debug or Release")
endif()
project(MUMPS
  LANGUAGES C Fortran
  VERSION 5.2.1
  DESCRIPTION "Sparse direct parallel solver"
  HOMEPAGE_URL "http://mumps.enseeiht.fr/")
enable_testing()

# --- user options
option(autobuild "auto-build Lapack and/or Scalapack if missing or broken" ON)
option(parallel "parallel or sequential (non-MPI, non-Scalapack)" ON)
option(metis "use METIS" OFF)
option(scotch "use Scotch" OFF)
option(openmp "use OpenMP (can be much slower for some cases)" OFF)
option(matlab "build optional Matlab interface" OFF)
option(ClangTest "run test for C-language" ON)

set(CMAKE_CONFIGURATION_TYPES "Debug;Release" CACHE STRING "Build type selections" FORCE)
set(CMAKE_NMC_DEFAULT_BUILD_FILE_CONFIG "Release" CACHE STRING "Default Build type" FORCE)

if(matlab)
  set(BUILD_SHARED_LIBS true)
endif()

if(NOT DEFINED arith)
  set(arith "d")
endif()

# --- compiler setup

# don't use LTO, the MUMPS code is not compatible for GCC at least.
# will give link failures when used in real programs.
# include(CheckIPOSupported)
# check_ipo_supported(RESULT lto_supported)
# if(lto_supported)
#   set(CMAKE_INTERPROCEDURAL_OPTIMIZATION TRUE)
# endif()

set(CDEFS "Add_")
# "Add_" works for all modern compilers we tried.

if(CMAKE_Fortran_COMPILER_ID STREQUAL Intel)
  if(WIN32)
    # /heap-arrays is necessary to avoid runtime errors in programs using this library
    string(APPEND CMAKE_Fortran_FLAGS " /warn:declarations /heap-arrays")
  else()
    string(APPEND CMAKE_Fortran_FLAGS " -warn declarations")
  endif()
elseif(CMAKE_Fortran_COMPILER_ID STREQUAL GNU)
  add_compile_options(-mtune=native)
  string(APPEND CMAKE_Fortran_FLAGS " -fimplicit-none")
elseif(CMAKE_Fortran_COMPILER_ID STREQUAL PGI)
  string(APPEND CMAKE_Fortran_FLAGS " -Mdclchk")
endif()

# problems with MPI can cause tests to hang forever, so set a default timeout [seconds]
set(CTEST_TEST_TIMEOUT 15)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules)

# --- dependencies
find_package(Threads)

# -- Lapack
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/lapack.cmake)

# -- Scalapack / MPI
if(parallel)
  find_package(MPI COMPONENTS Fortran C REQUIRED)
  include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/scalapack.cmake)

  set(NUMERIC_INCDIRS ${SCALAPACK_INCLUDE_DIRS})
  set(NUMERIC_LIBS ${SCALAPACK_LIBRARIES} MPI::MPI_Fortran MPI::MPI_C)
  if(openmp)
    find_package(OpenMP COMPONENTS C Fortran REQUIRED)
    list(APPEND NUMERIC_LIBS OpenMP::OpenMP_Fortran OpenMP::OpenMP_C)
  endif()
else()
  add_subdirectory(libseq)
  set(NUMERIC_INCDIRS ${CMAKE_CURRENT_SOURCE_DIR}/libseq)
  set(NUMERIC_LIBS mpiseq)
endif()
list(APPEND NUMERIC_LIBS ${LAPACK_LIBRARIES} ${BLAS_LIBRARIES} ${CMAKE_THREAD_LIBS_INIT})

# --- build MUMPS

add_subdirectory(PORD)
add_subdirectory(src)

if(NOT CMAKE_SOURCE_DIR STREQUAL PROJECT_SOURCE_DIR)
  # being used via FetchContent
  return()
endif()

# --- matlab (optional)
if(matlab)
  add_subdirectory(MATLAB)
endif()

# --- examples (optional)

string(REGEX MATCH "^Visual Studio" vs_backend ${CMAKE_GENERATOR})
if(vs_backend)
  message(STATUS "Visual Studio programs linking Fortran and C code require special configuration, see:")
  message(STATUS "https://software.intel.com/en-us/articles/configuring-visual-studio-for-mixed-language-applications")
  return()
endif()

add_subdirectory(tests)

add_subdirectory(examples)
