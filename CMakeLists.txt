cmake_minimum_required(VERSION 3.15)

include(cmake/policy.cmake)
include(cmake/compiler_find.cmake)
find_c_fortran()

project(MUMPS
LANGUAGES C Fortran
VERSION 5.3.5
DESCRIPTION "Sparse direct parallel solver"
HOMEPAGE_URL "http://mumps-solver.org/")

include(CTest)
if(NOT DEFINED ${PROJECT_NAME}_BUILD_TESTING)
  set(${PROJECT_NAME}_BUILD_TESTING ${BUILD_TESTING})
endif()

# --- user options
include(cmake/options.cmake)
include(cmake/libraries.cmake)

# --- compiler setup
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules)

include(cmake/compilers.cmake)

# --- dependencies
find_package(Threads)

# -- Lapack
include(cmake/lapack.cmake)

# -- Scalapack / MPI

if(parallel)
  include(cmake/mpi.cmake)
  include(cmake/scalapack.cmake)

  set(NUMERIC_LIBS SCALAPACK::SCALAPACK LAPACK::LAPACK MPI::MPI_Fortran MPI::MPI_C)
  if(openmp)
    find_package(OpenMP COMPONENTS C Fortran REQUIRED)
    list(APPEND NUMERIC_LIBS OpenMP::OpenMP_Fortran OpenMP::OpenMP_C)
  endif()
else(parallel)
  add_subdirectory(libseq)
  set(NUMERIC_LIBS MUMPS::mpiseq)
endif(parallel)
list(APPEND NUMERIC_LIBS LAPACK::LAPACK ${CMAKE_THREAD_LIBS_INIT})

# --- ordering libs

set(ORDERING_LIBS)
set(ORDERING_FLAGS -Dpord)
if(scotch)
  find_package(Scotch COMPONENTS ESMUMPS REQUIRED)
  list(APPEND ORDERING_FLAGS -Dscotch)
  list(APPEND ORDERING_LIBS Scotch::Scotch)
endif()
if(metis)
  find_package(METIS REQUIRED)
  list(APPEND ORDERING_FLAGS -Dmetis)
  list(APPEND ORDERING_LIBS METIS::METIS)
endif()
list(APPEND ORDERING_LIBS MUMPS::PORD)

# --- build MUMPS

add_subdirectory(PORD)
add_subdirectory(src)

if(${PROJECT_NAME}_BUILD_TESTING)
  add_subdirectory(tests)
  add_subdirectory(examples)
endif()

if(NOT CMAKE_SOURCE_DIR STREQUAL PROJECT_SOURCE_DIR)
  # being used via FetchContent
  return()
endif()

# --- matlab (optional)
if(matlab)
  add_subdirectory(MATLAB)
endif()

# --- feature summary

include(FeatureSummary)
add_feature_info(Parallel parallel "parallel MUMPS (using MPI and Scalapack)")
add_feature_info(64-bit-integer intsize64 "use 64-bit integers in C and Fortran")
add_feature_info(Metis metis "METIS graph partitioning http://glaros.dtc.umn.edu/gkhome/metis/metis/overview")
add_feature_info(Scotch scotch "Scotch graph partitioning https://www.labri.fr/perso/pelegrin/scotch/")
add_feature_info(Openmp openmp "OpenMP API https://www.openmp.org/")
add_feature_info(Matlab matlab "MUMPS Matlab interface")
add_feature_info(BuildScalapack scalapack_external "auto-build Scalapack")
add_feature_info(BuildLapack lapack_external "auto-build Lapack")
feature_summary(WHAT ENABLED_FEATURES PACKAGES_FOUND)
