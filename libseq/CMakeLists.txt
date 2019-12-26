add_library(mpiseq elapse.c mpi.f mpic.c)
target_compile_definitions(mpiseq PRIVATE ${CDEFS})
set_target_properties(mpiseq PROPERTIES
  Fortran_MODULE_DIRECTORY ${CMAKE_BINARY_DIR}
  ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}
  LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})