
lapack = dependency('lapack')
blas = dependency('blas')

mumpscfg = executable('mumpscfg', 'test_mumps.f90',
  dependencies : [scalapack, lapack, blas, mpif],
  link_with : [mumps_lib, mumps_common, pord],
  include_directories : '../include',
  link_language: 'fortran')

test('Mumps Config', mumpscfg)
