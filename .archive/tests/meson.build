# Note: MacOS in some systems needed the library link_with and include_directories instead of declare_dependency


# Ubuntu 16.04 requires explicit BLACS linking (also in CMake)
test_deps = [scalapack, blacs, mpif]


tsrc = parallel ? files('test_mumps.f90') : files('test_mumps_seq.f90')

if arith.contains('d')
  mumpscfg = executable('mumpscfg',
    sources: tsrc,
    dependencies : test_deps,
    include_directories: mumps_inc,
    link_with: [mumps_lib, mumps_common],
    link_language: 'fortran'
  )
  test('ConfigReal64', mumpscfg, timeout: 15, suite: 'mumps')
endif

ssrc = parallel ? 's_simple.f90' : 's_simple_seq.f90'

if arith.contains('s')
  s_simple = executable('s_simple',
    sources: ssrc,
    dependencies : test_deps,
    include_directories: mumps_inc,
    link_with: [mumps_lib, mumps_common],
    link_language: 'fortran'
  )
  if parallel
    test('SimpleReal32', mpiexec,
      args: ['-np', '2', s_simple],
      timeout: 15,
      suite: 'mumps',
      is_parallel: false)
  else
    test('SimpleReal32', s_simple, timeout: 15, suite: 'mumps')
  endif
endif

dsrc = parallel ? 'd_simple.f90' : 'd_simple_seq.f90'

if arith.contains('d')
  d_simple = executable('d_simple',
    sources: dsrc,
    dependencies : [test_deps],
    include_directories: mumps_inc,
    link_with: [mumps_lib, mumps_common],
    link_language: 'fortran'
  )

  if parallel
    test('SimpleReal64', mpiexec,
      args: ['-np', '2', d_simple],
      timeout: 15,
      suite: 'mumps',
      is_parallel: false)
  else
    test('SimpleReal64', d_simple, timeout: 15, suite: 'mumps')
  endif
endif

if not get_option('ClangTest')
  subdir_done()
endif

# if using compiler wrapper, might not work when linking between languages.

csrc = parallel ? 'simple.c' : 'simple_seq.c'

if arith.contains('d')
  c_simple = executable('c_simple',
    sources: csrc,
    include_directories: mumps_inc,
    dependencies : [scalapack, blacs, mpic],
    link_with: [mumps_lib, mumps_common])

  if parallel
    test('Creal64', mpiexec,
      args : ['-np', '2', c_simple],
      timeout: 15,
      suite: 'mumps',
      is_parallel: false,)
  else
    test('Creal64', c_simple, timeout: 15, suite: 'c_mumps')
  endif
endif
