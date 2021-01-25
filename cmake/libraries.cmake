# this reads libraries.json as a "single source of truth"
if(CMAKE_VERSION VERSION_LESS 3.19)
  # FIXME: we should eventually require CMake 3.19 for this and other stability enhancements.

  message(STATUS "Due to CMake < 3.19, using fallback library metadata in ${CMAKE_CURRENT_LIST_FILE}")

  set(lapack_url https://github.com/scivision/lapack.git)
  set(lapack_tag v3.9.0.2)

  set(scalapack_url https://github.com/scivision/scalapack.git)
  set(scalapack_tag v2.1.0.12)

  return()
endif()

# preferred method CMake >= 3.19
file(READ ${CMAKE_CURRENT_LIST_DIR}/libraries.json _libj)

string(JSON lapack_url GET ${_libj} lapack url)
string(JSON lapack_tag GET ${_libj} lapack tag)

string(JSON scalapack_url GET ${_libj} scalapack url)
string(JSON scalapack_tag GET ${_libj} scalapack tag)
