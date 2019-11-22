cmake_minimum_required(VERSION 3.13)
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Debug or Release")
endif()
project(PORD
  LANGUAGES C)

add_library(pord)
target_include_directories(pord PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/include)
target_compile_options(pord PRIVATE ${CFLAGS})

add_subdirectory(lib)