project('MUMPS', 'c', 'fortran',
  version : '5.3.0',
  meson_version: '>=0.50',
  default_options : ['default_library=static', 'buildtype=release', 'warning_level=0',
    'libdir=mumps-5.3.0', 'includedir=mumps-5.3.0/include'])

arith = get_option('arith')
parallel = get_option('parallel')

subdir('cmake')

threads = dependency('threads')
scalapack = declare_dependency(dependencies: [scalapack, lapack, blas, openmp, threads])


cargs = ['-DAdd_']

if get_option('intsize64')
  add_project_arguments('-DINTSIZE64')
endif
subdir('include')
# if os == 'windows'
#   cargs += '-DMUMPS_WIN32'
# endif
ordering_flags = ['-Dpord']
# PORD is always used, alongside the optional metis or scotch
subdir('PORD')

ordering_libs = []
mumps_inc = [include_directories('include'), include_directories('PORD/include')]

if get_option('scotch')
  #ordering_libs += dependency('scotch', cmake_module_path: 'cmake/Modules')
  ordering_libs += [cc.find_library('scotch'), cc.find_library('esmumps'), cc.find_library('scotcherrexit')]
  mumps_inc += include_directories('/usr/include/scotch/')  # TODO: get dependency('scotch') working
  ordering_flags += '-Dscotch'
endif
if get_option('metis')
  #ordering_libs += dependency('metis', cmake_module_path: 'cmake/Modules')
  ordering_libs += cc.find_library('metis')
  ordering_flags += '-Dmetis'
endif

# -- MUMPS
mpiseq = []
if not parallel
  mumps_inc += include_directories('libseq')
  subdir('libseq')
endif

subdir('src')

# --- generate pkg-config
# pc = import('pkgconfig')
# pc.generate(mumps_lib,
#   url: 'http://http://mumps.enseeiht.fr/',
#   description: 'MUMPS')

mumps = declare_dependency(
include_directories: mumps_inc,
link_with: [mumps_lib, mumps_common, pord],
dependencies: [ordering_libs, scalapack],
)

if not meson.is_subproject()
  subdir('tests')
  subdir('examples')
endif
