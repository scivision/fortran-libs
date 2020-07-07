find_package(Matlab COMPONENTS ENG_LIBRARY MX_LIBRARY REQUIRED)

set(_mat_arith "d;z")
foreach(a ${arith})

if(a IN_LIST _mat_arith)

set(_matlab_mumps ${a}mumpsmex.${Matlab_MEX_EXTENSION})

add_library(${_matlab_mumps} SHARED mumpsmex.c)
target_include_directories(${_matlab_mumps} PRIVATE ${Matlab_INCLUDE_DIRS})
target_link_libraries(${_matlab_mumps} PRIVATE MUMPS::MUMPS ${Matlab_ENG_LIBRARY} ${Matlab_MX_LIBRARY})
target_compile_definitions(${_matlab_mumps} PRIVATE MUMPS_ARITH=MUMPS_ARITH_${a})
set_target_properties(${_matlab_mumps} PROPERTIES
  PREFIX ""
  SUFFIX ""
  ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
  LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})

endif()

endforeach()
