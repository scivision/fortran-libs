if(CMAKE_VERSION VERSION_LESS 3.19)
  set(lapack_git https://github.com/scivision/lapack.git)
  set(lapack_tag v3.9.0.3)

  set(scalapack_git https://github.com/scivision/scalapack.git)
  set(scalapack_tag v2.1.0.14)

else()

  # CMake >= 3.19
  file(READ ${CMAKE_CURRENT_LIST_DIR}/libraries.json _libj)

  string(JSON lapack_git GET ${_libj} lapack git)
  string(JSON lapack_tag GET ${_libj} lapack tag)

  string(JSON scalapack_git GET ${_libj} scalapack git)
  string(JSON scalapack_tag GET ${_libj} scalapack tag)
endif()
