if(NOT parallel)
  return()
endif()

# testing what we just built

set(_sfilename input_simpletest_real)
set(_dfilename input_simpletest_real)
set(_cfilename input_simpletest_cmplx)
set(_zfilename input_simpletest_cmplx)

foreach(a ${arith})
  add_executable(${a}simpletest ${a}simpletest.F)
  target_link_libraries(${a}simpletest PRIVATE MUMPS::MUMPS ${NUMERIC_LIBS} MPI::MPI_Fortran)
  if(UNIX)
    add_test(NAME mumps:example_${a} COMMAND sh -c "${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} 2 $<TARGET_FILE:${a}simpletest> < ${CMAKE_CURRENT_SOURCE_DIR}/${_${a}filename}")
    set_tests_properties(mumps:example_${a} PROPERTIES RESOURCE_LOCK cpu_mpi)
  endif()

  add_executable(${a}simpletest_save_restore ${a}simpletest_save_restore.F)
  target_link_libraries(${a}simpletest_save_restore PRIVATE MUMPS::MUMPS ${NUMERIC_LIBS} MPI::MPI_Fortran)
  if(UNIX)
    add_test(NAME mumps:saveRestore_${a} COMMAND sh -c "${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} 2 $<TARGET_FILE:${a}simpletest_save_restore> < ${CMAKE_CURRENT_SOURCE_DIR}/${_${a}filename}")
    set_tests_properties(mumps:saveRestore_${a} PROPERTIES RESOURCE_LOCK cpu_mpi)
  endif()
endforeach()

if(NOT ClangTest)
  return()
endif()

if("d" IN_LIST arith)
  add_executable(c_example c_example.c)
  target_link_libraries(c_example PRIVATE MUMPS::MUMPS ${NUMERIC_LIBS} MPI::MPI_C)
  add_test(NAME mumps:example_C COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} 2 $<TARGET_FILE:c_example>)
  set_tests_properties(mumps:example_C PROPERTIES RESOURCE_LOCK cpu_mpi)
endif()
