# This test requires special configuration to work on Windows, as does any program using MPI:
# https://www.scivision.dev/intel-mpi-windows-bug

# testing what we just built
set(MUMPS_LIBRARIES mumps_common pord)
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

if(arith MATCHES "d")
  add_executable(mumpscfg test_mumps.f90)
  target_link_libraries(mumpscfg PRIVATE dmumps ${MUMPS_PREREQ_LIBS} MPI::MPI_Fortran)
  target_include_directories(mumpscfg PRIVATE ${MUMPS_INCLUDE_DIRS})
  add_test(NAME MumpsCfg
    COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} ${MPIEXEC_MAX_NUMPROCS} $<TARGET_FILE:mumpscfg>)
  set_tests_properties(MumpsCfg PROPERTIES TIMEOUT 10 RUN_SERIAL true)
endif()

if(arith MATCHES "s")
  add_executable(s_simple s_simple.f90)
  target_link_libraries(s_simple PRIVATE smumps ${MUMPS_PREREQ_LIBS} MPI::MPI_Fortran)
  target_include_directories(s_simple PRIVATE ${MUMPS_INCLUDE_DIRS})
  add_test(NAME SimpleReal32
    COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} ${MPIEXEC_MAX_NUMPROCS} $<TARGET_FILE:s_simple>)
  set_tests_properties(SimpleReal32 PROPERTIES TIMEOUT 15 RUN_SERIAL true)
endif()

if(arith MATCHES "d")
  add_executable(d_simple d_simple.f90)
  target_link_libraries(d_simple PRIVATE dmumps ${MUMPS_PREREQ_LIBS} MPI::MPI_Fortran)
  target_include_directories(d_simple PRIVATE ${MUMPS_INCLUDE_DIRS})
  add_test(NAME SimpleReal64
    COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} ${MPIEXEC_MAX_NUMPROCS} $<TARGET_FILE:d_simple>)
  set_tests_properties(SimpleReal64 PROPERTIES TIMEOUT 15 RUN_SERIAL true)

  add_executable(Csimple simple.c)
  target_link_libraries(Csimple PRIVATE dmumps ${MUMPS_PREREQ_LIBS} MPI::MPI_C)
  target_include_directories(Csimple PRIVATE ${MUMPS_INCLUDE_DIRS})
  add_test(NAME CSimpleReal64
    COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} ${MPIEXEC_MAX_NUMPROCS} $<TARGET_FILE:Csimple>)
  set_tests_properties(CSimpleReal64 PROPERTIES TIMEOUT 15 RUN_SERIAL true)
endif()
