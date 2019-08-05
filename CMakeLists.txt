cmake_minimum_required(VERSION 3.13)  # for target_sources upward
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Debug or Release")
endif()
project(MUMPS
  LANGUAGES C Fortran
  VERSION 5.2.1
  HOMEPAGE_URL http://mumps.enseeiht.fr/)
enable_testing()

cmake_policy(SET CMP0076 NEW)

if(NOT DEFINED arith)
  set(arith d)
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


# --- install
if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  if(WIN32)
    set(HOME $ENV{USERPROFILE})
  else()
    set(HOME $ENV{HOME})
  endif()

  set(CMAKE_INSTALL_PREFIX "${HOME}/.local/mumps-${PROJECT_VERSION}" CACHE PATH "..." FORCE)
endif()

install(TARGETS pord mumps_common ${arith}mumps
  ARCHIVE DESTINATION ${CMAKE_INSTALL_PREFIX}
  LIBRARY DESTINATION ${CMAKE_INSTALL_PREFIX})

install(DIRECTORY ${CMAKE_SOURCE_DIR}/include  # no trailing slash!
  DESTINATION ${CMAKE_INSTALL_PREFIX})