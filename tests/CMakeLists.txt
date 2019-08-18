# This test requires special configuration to work on Windows, as does any program using MPI:
# https://www.scivision.dev/intel-mpi-windows-bug

# testing what we just built
set(MUMPS_LIBRARIES dmumps mumps_common pord)
set(MUMPS_INCLUDE_DIRS ${CMAKE_SOURCE_DIR}/include)

find_package(LAPACK REQUIRED)
find_package(SCALAPACK REQUIRED)
if(NOT CMAKE_Fortran_COMPILER_ID STREQUAL Intel)
  find_package(BLACS)
endif()
# some systems (Ubuntu 16.04) need BLACS explicitly, when it isn't statically compiled into libscalapack
# other systems (homebrew, Ubuntu 18.04) link BLACS into libscalapack, and don't need BLACS as a separately linked library.
set(MUMPS_PREREQ_LIBS ${MUMPS_LIBRARIES} ${SCALAPACK_LIBRARIES})
if(BLACS_FOUND)
  list(APPEND MUMPS_PREREQ_LIBS ${BLACS_LIBRARIES})
endif()
list(APPEND MUMPS_PREREQ_LIBS ${LAPACK_LIBRARIES})

add_executable(mumpscfg test_mumps.f90)
target_link_libraries(mumpscfg PRIVATE ${MUMPS_PREREQ_LIBS} MPI::MPI_Fortran)
target_include_directories(mumpscfg PRIVATE ${MUMPS_INCLUDE_DIRS})
add_test(NAME MumpsCfg
  COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} ${MPIEXEC_MAX_NUMPROCS} $<TARGET_FILE:mumpscfg>)
set_tests_properties(MumpsCfg PROPERTIES TIMEOUT 10)

add_executable(simple simple.f90)
target_link_libraries(simple PRIVATE ${MUMPS_PREREQ_LIBS} MPI::MPI_Fortran)
target_include_directories(simple PRIVATE ${MUMPS_INCLUDE_DIRS})
add_test(NAME Simple
  COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} ${MPIEXEC_MAX_NUMPROCS} $<TARGET_FILE:simple>)
set_tests_properties(Simple PROPERTIES TIMEOUT 15)

add_executable(Csimple simple.c)
target_link_libraries(Csimple PRIVATE ${MUMPS_PREREQ_LIBS} MPI::MPI_C)
target_include_directories(Csimple PRIVATE ${MUMPS_INCLUDE_DIRS})
add_test(NAME C_Simple
  COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} ${MPIEXEC_MAX_NUMPROCS} $<TARGET_FILE:Csimple>)
set_tests_properties(Simple PROPERTIES TIMEOUT 15)