add_library(pord)
target_include_directories(pord PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/include
  INTERFACE
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
  $<INSTALL_INTERFACE:include>)
add_library(mumps::pord ALIAS pord)

install(TARGETS pord
  EXPORT MUMPSTargets
  ARCHIVE DESTINATION lib
  LIBRARY DESTINATION lib
  RUNTIME DESTINATION bin
  INCLUDES DESTINATION include)

add_subdirectory(lib)

# .h files
install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/include/ DESTINATION include)
