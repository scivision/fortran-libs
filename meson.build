project('MUMPS', 'c', 'fortran',
  version : '5.2.1',
  meson_version: '>=0.50',
  default_options : ['default_library=static', 'buildtype=release', 'warning_level=0',
    'libdir=mumps-5.2.1', 'includedir=mumps-5.2.1/include'])

arith = get_option('arith')
ordering = get_option('ordering')
subdir('cmake')

message('arith: ' + arith)

threads = dependency('threads')
scalapack = declare_dependency(dependencies: [scalapack, lapack, blas, threads])

# PORD is always used, alongside the optional metis or scotch
subdir('PORD')
ordering_lib = [pord]
if ordering == 'scotch'
  message('Scotch has not been tested, let us know if there are issues.')
  ordering_lib += dependency('scotch', cmake_module_path: 'cmake/Modules')
elif ordering == 'metis'
  message('Metis has not been tested, let us know if there are issues.')
  ordering_lib += dependency('metis', cmake_module_path: 'cmake/Modules')
endif

# -- MUMPS
mumps_inc = include_directories('include')
subdir('src')

# --- generate pkg-config
#pkg = import('pkgconfig')
#pkg.generate(mumps_lib,
#  url: 'https://github.com/scivision/mumps',
#  description: 'MUMPS')

mumps = declare_dependency(
include_directories: mumps_inc,
link_with: [mumps_lib, mumps_common, ordering_lib]
)

if not meson.is_subproject()
  subdir('tests')
endif