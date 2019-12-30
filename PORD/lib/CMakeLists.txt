add_library(pord graph.c gbipart.c gbisect.c ddcreate.c ddbisect.c nestdiss.c multisector.c gelim.c bucket.c tree.c symbfac.c interface.c sort.c minpriority.c)
target_include_directories(pord PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/../include)
set_target_properties(pord PROPERTIES
  Fortran_MODULE_DIRECTORY ${CMAKE_BINARY_DIR}
  ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}
  LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})
install(TARGETS pord
  ARCHIVE DESTINATION ${CMAKE_INSTALL_PREFIX}
  LIBRARY DESTINATION ${CMAKE_INSTALL_PREFIX})