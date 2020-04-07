# testing what we just built

include(CheckFortranSourceCompiles)
check_fortran_source_compiles("implicit none (external); end" impNoneExt SRC_EXT f90)
set(impext)
if(impNoneExt)
  set(impext "(external)")
endif()

if("d" IN_LIST arith)
  if(parallel)
    configure_file(test_mumps.in.f90 test_mumps.f90)
    add_executable(mumpscfg ${CMAKE_CURRENT_BINARY_DIR}/test_mumps.f90)
    add_test(NAME mumps:config
      COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} 2 $<TARGET_FILE:mumpscfg>)
  else()
    configure_file(test_mumps_seq.in.f90 test_mumps_seq.f90)
    add_executable(mumpscfg ${CMAKE_CURRENT_BINARY_DIR}/test_mumps_seq.f90)
    add_test(NAME mumps:config COMMAND mumpscfg)
  endif()

  target_link_libraries(mumpscfg PRIVATE dmumps mumps::mumps ${NUMERIC_LIBS})
  target_include_directories(mumpscfg PRIVATE ${NUMERIC_INCDIRS})

  set_tests_properties(mumps:config PROPERTIES RUN_SERIAL true)
endif()

if("s" IN_LIST arith)
  if(parallel)
    configure_file(s_simple.in.f90 s_simple.f90)
    add_executable(s_simple ${CMAKE_CURRENT_BINARY_DIR}/s_simple.f90)
    add_test(NAME mumps:simpleReal32
      COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} 2 $<TARGET_FILE:s_simple>)
  else()
    configure_file(s_simple_seq.in.f90 s_simple_seq.f90)
    add_executable(s_simple ${CMAKE_CURRENT_BINARY_DIR}/s_simple_seq.f90)
    add_test(NAME mumps:simpleReal32 COMMAND s_simple)
  endif()
  target_link_libraries(s_simple PRIVATE smumps mumps::mumps ${NUMERIC_LIBS})
  target_include_directories(s_simple PRIVATE ${NUMERIC_INCDIRS})

  set_tests_properties(mumps:simpleReal32 PROPERTIES RUN_SERIAL true)
endif()

if("d" IN_LIST arith)
  if(parallel)
    configure_file(d_simple.in.f90 d_simple.f90)
    add_executable(d_simple ${CMAKE_CURRENT_BINARY_DIR}/d_simple.f90)
    add_test(NAME mumps:simpleReal64
      COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} 2 $<TARGET_FILE:d_simple>)
  else()
    configure_file(d_simple_seq.in.f90 d_simple_seq.f90)
    add_executable(d_simple ${CMAKE_CURRENT_BINARY_DIR}/d_simple_seq.f90)
    add_test(NAME mumps:simpleReal64 COMMAND d_simple)
  endif()
  target_link_libraries(d_simple PRIVATE dmumps mumps::mumps ${NUMERIC_LIBS})
  target_include_directories(d_simple PRIVATE ${NUMERIC_INCDIRS})

  set_tests_properties(mumps:simpleReal64 PROPERTIES RUN_SERIAL true)

  if(NOT ClangTest)
    return()
  endif()

  if(parallel)
    add_executable(Csimple simple.c)
    add_test(NAME mumps:CsimpleReal64
      COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} 2 $<TARGET_FILE:Csimple>)
  else()
    add_executable(Csimple simple_seq.c)
    add_test(NAME mumps:CsimpleReal64 COMMAND Csimple)
  endif()
  target_link_libraries(Csimple PRIVATE dmumps mumps::mumps ${NUMERIC_LIBS})
  target_include_directories(Csimple PRIVATE ${NUMERIC_INCDIRS})

  set_tests_properties(mumps:CsimpleReal64 PROPERTIES RUN_SERIAL true)
endif()
