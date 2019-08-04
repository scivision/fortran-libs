
# Ubuntu 16.04 requires explicit BLACS linking (also in CMake)
blacs = fc.find_library('blacs-openmpi', required: false)
if blacs.found()
  test_deps = [scalapack, blacs, mpif]
else
  test_deps = [scalapack, mpif]
endif

mpiexec = find_program('mpiexec')

mumpscfg = executable('mumpscfg', 'test_mumps.f90',
  dependencies : [test_deps, mumps],
  link_language: 'fortran'
)
test('Mumps Config', mumpscfg, timeout: 15)


simple = executable('simple', 'simple.f90',
  dependencies : [test_deps, mumps],
  link_language: 'fortran'
)
test('Mumps Simple', mpiexec,
  args: ['-np', '2', simple],
  timeout: 15
)

c_simple = executable('c_simple', 'simple.c',
  dependencies : [mumps, scalapack, blacs, mpic],
)
test('Mumps C', mpiexec,
  args : ['-np', '2', c_simple],
  timeout: 15)