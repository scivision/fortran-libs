
# Ubuntu 16.04 requires explicit BLACS linking (also in CMake)
blacs = fc.find_library('blacs-openmpi', required: false)
if blacs.found()
  test_deps = [scalapack, blacs, mpif]
else
  test_deps = [scalapack, mpif]
endif

if arith.contains('d')
  mumpscfg = executable('mumpscfg', 'test_mumps.f90',
    dependencies : [test_deps, mumps],
    link_language: 'fortran'
  )
  test('Mumps Config real64', mumpscfg, timeout: 15)
endif

if arith.contains('s')
  s_simple = executable('s_simple', 's_simple.f90',
    dependencies : [test_deps, mumps],
    link_language: 'fortran'
  )
  test('Mumps Simple real32', mpiexec,
    args: ['-np', '2', s_simple],
    timeout: 15
  )
endif
if arith.contains('d')
  d_simple = executable('d_simple', 'd_simple.f90',
    dependencies : [test_deps, mumps],
    link_language: 'fortran'
  )
  test('Mumps Simple real64', mpiexec,
    args: ['-np', '2', d_simple],
    timeout: 15
  )
endif

# if using compiler wrapper, might not work when linking between languages.
if get_option('test_c') and arith.contains('d')
  c_simple = executable('c_simple',
    sources: 'simple.c',
    dependencies : [mumps, scalapack, blacs, mpic])

  test('Mumps C', mpiexec,
    args : ['-np', '2', c_simple],
    timeout: 15)
endif