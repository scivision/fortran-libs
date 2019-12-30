foreach a : arith
  executable(a + 'simpletest', a + 'simpletest.F',
    dependencies : test_deps,
    include_directories: mumps_inc,
    link_with: [mumps_lib, mumps_common],
    link_language: 'fortran')

  executable(a + 'simpletest_save_restore', a + 'simpletest_save_restore.F',
    dependencies : test_deps,
    include_directories: mumps_inc,
    link_with: [mumps_lib, mumps_common],
    link_language: 'fortran')
endforeach

if arith.contains('d')
  c_example_exe = executable('c_example', 'c_example.c',
    dependencies : test_deps,
    include_directories: mumps_inc,
    link_with: [mumps_lib, mumps_common],
    link_language: 'fortran')
  test('Example_C', c_example_exe, timeout: 10)
endif
