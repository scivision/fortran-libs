add_library(pord)
target_include_directories(pord PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/include)
set_target_properties(pord PROPERTIES
  Fortran_MODULE_DIRECTORY ${CMAKE_BINARY_DIR}
  ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}
  LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})

add_subdirectory(lib)