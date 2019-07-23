
lapack = dependency('lapack')
blas = dependency('blas')

mumpscfg = executable('mumpscfg', 'test_mumps.f90',
  dependencies : [blas, lapack, scalapack, mpif],
  link_with : mumps_lib,
  include_directories : '../include')

test('Mumps Config', mumpscfg)
