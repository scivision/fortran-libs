# This test requires special configuration to work on Windows, as does any program using MPI:
# https://www.scivision.dev/intel-mpi-windows-bug
cmake_minimum_required(VERSION 3.12)
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Debug or Release")
endif()
project(FortranLibsDemo C Fortran)
enable_testing()

get_directory_property(hasParent PARENT_DIRECTORY)
if(NOT hasParent)
  list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/../cmake/Modules/)
  include(${CMAKE_CURRENT_SOURCE_DIR}/../cmake/compilers.cmake)

  if(NOT DEFINED MUMPS_ROOT)
    set(MUMPS_ROOT ${CMAKE_CURRENT_SOURCE_DIR}/../)
  endif()
  find_package(MUMPS REQUIRED COMPONENTS d)
else()  # testing what we just built
  set(MUMPS_LIBRARIES dmumps mumps_common pord)
  set(MUMPS_INCLUDE_DIRS ${CMAKE_SOURCE_DIR}/include)
endif()

find_package(MPI REQUIRED COMPONENTS Fortran)
find_package(LAPACK REQUIRED)
find_package(SCALAPACK REQUIRED)
find_package(BLACS)

# some systems (Ubuntu 16.04) need BLACS explicitly, when it isn't statically compiled into libscalapack
# other systems (homebrew, Ubuntu 18.04) link BLACS into libscalapack, and don't need BLACS as a separately linked library.
set(MUMPS_PREREQ_LIBS ${MUMPS_LIBRARIES} ${SCALAPACK_LIBRARIES})
if(BLACS_FOUND)
  list(APPEND MUMPS_PREREQ_LIBS ${BLACS_LIBRARIES})
endif()
list(APPEND MUMPS_PREREQ_LIBS ${LAPACK_LIBRARIES} MPI::MPI_Fortran)

add_executable(mumpscfg test_mumps.f90)
target_link_libraries(mumpscfg PRIVATE ${MUMPS_PREREQ_LIBS})
target_include_directories(mumpscfg PRIVATE ${MUMPS_INCLUDE_DIRS})

add_test(NAME MumpsCfg
  COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} ${MPIEXEC_MAX_NUMPROCS} $<TARGET_FILE:mumpscfg>)
set_tests_properties(MumpsCfg PROPERTIES TIMEOUT 10)