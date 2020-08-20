add_library(mpiseq elapse.c mpi.f mpic.c)
target_compile_definitions(mpiseq PRIVATE ${CDEFS})
target_include_directories(mpiseq INTERFACE ${CMAKE_CURRENT_SOURCE_DIR})
set_target_properties(mpiseq PROPERTIES
  Fortran_MODULE_DIRECTORY ${PROJECT_BINARY_DIR}
  ARCHIVE_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}
  LIBRARY_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR})
add_library(mumps::mpiseq ALIAS mpiseq)
