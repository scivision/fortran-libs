# NOTE: if you build MUMPS with auto-build scalapack and/or lapack, to use those, you must
# config like:
#
# cmake -B build -DMUMPS_ROOT=/path/to/mumps -DSCALAPACK_ROOT=/path/to/mumps -DLAPACK_ROOT=/path/to/mumps

cmake_minimum_required(VERSION 3.13)

include(${CMAKE_CURRENT_SOURCE_DIR}/../cmake/policy.cmake)
include(${CMAKE_CURRENT_SOURCE_DIR}/../cmake/compiler_find.cmake)
find_c_fortran()

project(MUMPS_examples
LANGUAGES C Fortran)

include(CTest)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/../cmake/Modules)


find_package(MUMPS CONFIG)

if(MUMPS_FOUND)
  # include in this order
  if(EXISTS ${MUMPS_DIR}/../LAPACK/LAPACKTargets.cmake)
    include(${MUMPS_DIR}/../LAPACK/LAPACKTargets.cmake)
  endif()

  if(EXISTS ${MUMPS_DIR}/../SCALAPACK/SCALAPACKTargets.cmake)
    include(${MUMPS_DIR}/../SCALAPACK/SCALAPACKTargets.cmake)
    # Not ALIAS for CMAKE_REQUIRED_LIBRARIES
    add_library(SCALAPACK::SCALAPACK INTERFACE IMPORTED)
    target_link_libraries(SCALAPACK::SCALAPACK INTERFACE SCALAPACK::scalapack)
  endif()

  include(${MUMPS_DIR}/MUMPSTargets.cmake)

else()
  find_package(MUMPS REQUIRED)
endif()

# include(${PROJECT_SOURCE_DIR}/../../cmakeutils/echo_target_properties.cmake)
# echo_target_properties(MUMPS::MUMPS)

# --- determine what libraries need to be loaded
find_package(MPI COMPONENTS C Fortran REQUIRED)

if(NOT TARGET SCALAPACK::SCALAPACK)
  find_package(SCALAPACK REQUIRED)
endif()

if(NOT TARGET LAPACK::LAPACK)
  find_package(LAPACK REQUIRED)
endif()

get_target_property(ifc_libs MUMPS::mumps_common INTERFACE_LINK_LIBRARIES)
string(FIND "${ifc_libs}" "METIS::METIS" needs_metis)
if(needs_metis GREATER 0)
  find_package(METIS REQUIRED)
endif()
string(FIND "${ifc_libs}" "Scotch::Scotch" needs_scotch)
if(needs_scotch GREATER 0)
  find_package(Scotch REQUIRED COMPONENTS ESMUMPS)
endif()

# --- build examples

set(_sfilename input_simpletest_real)
set(_dfilename input_simpletest_real)
set(_cfilename input_simpletest_cmplx)
set(_zfilename input_simpletest_cmplx)

foreach(a s d)
  # echo_target_properties(MUMPS::${a}mumps)
  if(NOT TARGET MUMPS::${a}mumps)
    continue()
  endif()

  add_executable(${a}simpletest ${a}simpletest.F)
  target_link_libraries(${a}simpletest PRIVATE MUMPS::MUMPS MPI::MPI_Fortran)
  if(UNIX)
    add_test(NAME mumps:example_${a} COMMAND sh -c "${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} 2 $<TARGET_FILE:${a}simpletest> < ${CMAKE_CURRENT_SOURCE_DIR}/${_${a}filename}")
    set_tests_properties(mumps:example_${a} PROPERTIES RESOURCE_LOCK cpu_mpi)
  endif()

  add_executable(${a}simpletest_save_restore ${a}simpletest_save_restore.F)
  target_link_libraries(${a}simpletest_save_restore PRIVATE MUMPS::MUMPS MPI::MPI_Fortran)
  if(UNIX)
    add_test(NAME mumps:saveRestore_${a} COMMAND sh -c "${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} 2 $<TARGET_FILE:${a}simpletest_save_restore> < ${CMAKE_CURRENT_SOURCE_DIR}/${_${a}filename}")
    set_tests_properties(mumps:saveRestore_${a} PROPERTIES RESOURCE_LOCK cpu_mpi)
 endif()
endforeach()

if(TARGET MUMPS::dmumps)
  add_executable(c_example c_example.c)
  target_link_libraries(c_example PRIVATE MUMPS::MUMPS MPI::MPI_C)
  add_test(NAME mumps:example_C COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} 2 $<TARGET_FILE:c_example>)
  set_tests_properties(mumps:example_C PROPERTIES RESOURCE_LOCK cpu_mpi)
endif()
