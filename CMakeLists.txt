cmake_minimum_required(VERSION 3.14)
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE "Release" CACHE STRING "Debug or Release")
endif()
project(MUMPS
  LANGUAGES C Fortran
  VERSION 5.3.0
  DESCRIPTION "Sparse direct parallel solver"
  HOMEPAGE_URL "http://mumps-solver.org/")
enable_testing()
include(CTest)

# --- user options
option(autobuild "auto-build Lapack and/or Scalapack if missing or broken" ON)
option(parallel "parallel or sequential (non-MPI, non-Scalapack)" ON)
option(intsize64 "use 64-bit integers in C and Fortran" OFF)
option(metis "use METIS" OFF)
option(scotch "use Scotch" OFF)
option(openmp "use OpenMP (can be slower for some cases)" OFF)
option(matlab "build optional Matlab interface" OFF)
option(ClangTest "run test for C-language" ON)

if(matlab)
  set(BUILD_SHARED_LIBS true)
endif()

if(NOT DEFINED arith)
  set(arith "s;d")
endif()

if(intsize64)
  add_compile_definitions(INTSIZE64)
endif()

# --- compiler setup
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/compilers.cmake)
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules)

# problems with MPI can cause tests to hang forever, so set a default timeout [seconds]
set(CTEST_TEST_TIMEOUT 15)

# --- dependencies
find_package(Threads)

# -- Lapack
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/lapack.cmake)

# -- Scalapack / MPI

if(parallel)
  find_package(MPI COMPONENTS Fortran C REQUIRED)
  include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/scalapack.cmake)

  set(NUMERIC_INCDIRS "") # to avoid uninitialized warning
  if(SCALAPACK_INCLUDE_DIRS)
    set(NUMERIC_INCDIRS ${SCALAPACK_INCLUDE_DIRS})
  endif()
  set(NUMERIC_LIBS ${SCALAPACK_LIBRARIES} MPI::MPI_Fortran MPI::MPI_C)
  if(openmp)
    find_package(OpenMP COMPONENTS C Fortran REQUIRED)
    list(APPEND NUMERIC_LIBS OpenMP::OpenMP_Fortran OpenMP::OpenMP_C)
  endif()
else(parallel)
  add_subdirectory(libseq)
  set(NUMERIC_INCDIRS ${CMAKE_CURRENT_SOURCE_DIR}/libseq)
  set(NUMERIC_LIBS mpiseq)
endif(parallel)
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
  message(STATUS "Consider using Ninja backend instead of VS backend if possible for your project.")
  return()
endif()

add_subdirectory(tests)

add_subdirectory(examples)
