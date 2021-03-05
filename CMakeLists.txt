cmake_minimum_required(VERSION 3.13...3.20)

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
  set(NUMERIC_LIBS mpiseq)
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
list(APPEND ORDERING_LIBS pord)

# --- build MUMPS

add_subdirectory(PORD)
add_subdirectory(src)

if(${PROJECT_NAME}_BUILD_TESTING)
  add_subdirectory(tests)
endif()

# --- matlab (optional)
if(mumps_matlab)
  add_subdirectory(MATLAB)
endif()

# --- feature summary

include(cmake/summary.cmake)

include(cmake/install.cmake)
