cmake_minimum_required(VERSION 3.7)
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Debug or Release")
endif()
project(MUMPS
  LANGUAGES C Fortran
  VERSION 5.2.1)
enable_testing()

if(CMAKE_VERSION VERSION_GREATER_EQUAL 3.13)
  cmake_policy(SET CMP0077 NEW)
endif()
# --- user options
option(parallel "parallel or sequential (non-MPI, non-Scalapack)" ON)

set(ordering "pord")

if(NOT DEFINED arith)
  set(arith "s" "d")
endif()

# --- compiler setup

set(CDEFS "Add_")
# this works for all modern compilers we tried.

if(CMAKE_Fortran_COMPILER_ID STREQUAL Intel)
  if(WIN32)
    set(FFLAGS /warn:declarations /Qopenmp /heap-arrays)
  else()
    set(FFLAGS -warn declarations -qopenmp)
  endif()
elseif(CMAKE_Fortran_COMPILER_ID STREQUAL GNU)
  add_compile_options(-mtune=native)
  set(FFLAGS -fimplicit-none)
elseif(CMAKE_Fortran_COMPILER_ID STREQUAL PGI)
  set(FFLAGS -Mdclchk)
endif()

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules)

set(CMAKE_Fortran_MODULE_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/include)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/lib)

# --- dependencies
find_package(Threads)
find_package(LAPACK REQUIRED)
if(parallel)
  find_package(MPI COMPONENTS Fortran C REQUIRED)
  find_package(OpenMP COMPONENTS C Fortran REQUIRED)
  find_package(SCALAPACK REQUIRED)
  set(NUMERIC_INCDIRS ${SCALAPACK_INCLUDE_DIRS})
  set(NUMERIC_LIBS ${SCALAPACK_LIBRARIES} MPI::MPI_Fortran MPI::MPI_C OpenMP::OpenMP_Fortran OpenMP::OpenMP_C)
else()
  add_subdirectory(libseq)
  set(NUMERIC_INCDIRS ${CMAKE_CURRENT_SOURCE_DIR}/libseq)
  set(NUMERIC_LIBS mpiseq)
endif()
list(APPEND NUMERIC_LIBS ${LAPACK_LIBRARIES} ${BLAS_LIBRARIES} ${CMAKE_THREAD_LIBS_INIT})

set(ORDERING_FLAGS -Dpord)
if(scotch IN_LIST ordering)
  find_package(Scotch COMPONENTS ESMUMPS REQUIRED)
  list(APPEND ORDERING_FLAGS -Dscotch)
endif()
if(metis IN_LIST ordering)
  find_package(METIS REQUIRED)
  list(APPEND ORDERING_FLAGS -Dmetis)
endif()

add_subdirectory(PORD/lib)
add_subdirectory(src)

# stop here if being used as an ExternalProject
if(NOT CMAKE_SOURCE_DIR STREQUAL PROJECT_SOURCE_DIR)
  return()
endif()

# --- self-tests (optional)

add_subdirectory(tests)


# --- install
if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  if(WIN32)
    set(HOME $ENV{USERPROFILE})
  else()
    set(HOME $ENV{HOME})
  endif()

  set(CMAKE_INSTALL_PREFIX "${HOME}/.local/mumps-${PROJECT_VERSION}" CACHE PATH "..." FORCE)
endif()
