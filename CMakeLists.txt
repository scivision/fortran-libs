cmake_minimum_required(VERSION 3.13)
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Debug or Release")
endif()
project(MUMPS
  LANGUAGES C Fortran
  VERSION 5.1.2
  HOMEPAGE_URL http://mumps.enseeiht.fr/)
enable_testing()

if(NOT DEFINED ARITH)
  set(ARITH d)
endif()

include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/compilers.cmake)
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules)

set(CMAKE_Fortran_MODULE_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/include)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/lib)

find_package(MPI REQUIRED COMPONENTS Fortran C)

find_package(SCALAPACK REQUIRED)
find_package(LAPACK REQUIRED)

add_subdirectory(PORD)
add_subdirectory(src)

add_subdirectory(tests)
