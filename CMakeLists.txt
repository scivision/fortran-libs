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
cmake_policy(SET CMP0074 NEW)
cmake_policy(SET CMP0076 NEW)
cmake_policy(SET CMP0077 NEW)
cmake_policy(SET CMP0082 NEW)
option(parallel "parallel or sequential (non-MPI, non-Scalapack)" ON)
option(metis "use METIS" OFF)
option(scotch "use Scotch" OFF)
option(openmp "use OpenMP (can be much slower for some cases)" OFF)
option(matlab "build optional Matlab interface" OFF)
option(ClangTest "run test for C-language" ON)

if(matlab)
  set(BUILD_SHARED_LIBS true)
endif()

if(NOT DEFINED arith)
  set(arith "s" "d")
endif()

# --- compiler setup

set(CDEFS "Add_")
# "Add_" works for all modern compilers we tried.

# being used via FetchContent
if(CMAKE_SOURCE_DIR STREQUAL PROJECT_SOURCE_DIR)
# problems with MPI can cause tests to hang forever, so set a default timeout [seconds]
  set(CTEST_TEST_TIMEOUT 15)

  if(CMAKE_Fortran_COMPILER_ID STREQUAL Intel)
    if(WIN32)
      set(CMAKE_Fortran_FLAGS /warn:declarations /heap-arrays)
    else()
      set(CMAKE_Fortran_FLAGS -warn declarations)
    endif()
  elseif(CMAKE_Fortran_COMPILER_ID STREQUAL GNU)
    add_compile_options(-mtune=native)
    set(CMAKE_Fortran_FLAGS -fimplicit-none)
  elseif(CMAKE_Fortran_COMPILER_ID STREQUAL PGI)
    set(CMAKE_Fortran_FLAGS -Mdclchk)
  endif()

   # --- install defaults
  if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  if(WIN32)
    set(HOME $ENV{USERPROFILE})
  else()
    set(HOME $ENV{HOME})
  endif()

  set(CMAKE_INSTALL_PREFIX "${HOME}/.local/mumps-${PROJECT_VERSION}" CACHE PATH "..." FORCE)
  endif()
endif()

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules)

# --- dependencies
find_package(Threads)
find_package(LAPACK REQUIRED)
if(parallel)
  find_package(MPI COMPONENTS Fortran C REQUIRED)
  find_package(SCALAPACK REQUIRED)
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

# stop here if being used via FetchContent
if(NOT CMAKE_SOURCE_DIR STREQUAL PROJECT_SOURCE_DIR)
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
