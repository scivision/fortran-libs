
# Ubuntu 16.04 requires explicit BLACS linking (also in CMake)
blacs = fc.find_library('blacs-openmpi', required: false)
if blacs.found()
  test_deps = [scalapack, blacs, mpif]
else
  test_deps = [scalapack, mpif]
endif

mumpscfg = executable('mumpscfg', 'test_mumps.f90',
  dependencies : test_deps,
  link_with : [mumps_lib, mumps_common, pord],
  include_directories : '../include',
  link_language: 'fortran'
)

simple = executable('simple', 'simple.f90',
  dependencies : test_deps,
  link_with : [mumps_lib, mumps_common, pord],
  include_directories : '../include',
  link_language: 'fortran'
)

test('Mumps Config', mumpscfg, timeout: 15)

mpiexec = find_program('mpiexec')
test('Mumps Simple', mpiexec,
  args: ['-np', '2', simple],
  timeout: 15
)
