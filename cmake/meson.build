fc = meson.get_compiler('fortran')
cc = meson.get_compiler('c')
os = target_machine.system()

if fc.get_id() == 'intel-cl'
  # /fpp is necessary for any Fortran preprocessing statement with Intel ifort on Windows
  # https://software.intel.com/en-us/fortran-compiler-developer-guide-and-reference-fpp
   add_project_arguments('/fpp', language: 'fortran')
endif

if meson.is_subproject()
  quiet = fc.first_supported_argument(['-w', '-nowarn', '/nowarn'])
  add_project_arguments(quiet, language: 'fortran')
endif

# -- MKL (in general, MKL can be used with intel, intel-cl, gcc or PGI)
mklroot = get_option('mklroot')
mkllib_root = os == 'windows' ? mklroot/'lib/intel64_win' : mklroot/'lib/intel64'

# == MPI
mpiexec = find_program('mpiexec')
mpif = dependency('mpi', language : 'fortran')
if mpif.found() and not fc.links('use mpi; end', dependencies : mpif, name: 'Fortran MPI')
  error('MUMPS Fortran not working, and MUMPS uses MPI throughout')
endif

# stdio.h is necessary for IntelMPI
mpic_code = '''
#include <mpi.h>
#include <stdio.h>
int main() { MPI_Init(NULL, NULL); MPI_Finalize(); return 0;}
'''
mpic = dependency('mpi', language : 'c')
if mpic.found() and not cc.links(mpic_code, dependencies: mpic, name: 'C MPI')
  error('MUMPS C not working, and MUMPS uses MPI throughout')
endif

# == Intel OpenMP
intelMP_lib = []
if mklroot != ''
  n = os == 'windows' ? 'iomp5md' : 'iomp5'
  intelMP_lib = fc.find_library(n, dirs: mklroot / '../compiler/lib/intel64')
endif

# == Lapack
if mklroot == ''
  blas = dependency('blas', required: false, disabler: true)
  if not blas.found()  # necessary for some systems incl. CentOS 7
    blas = fc.find_library('blas', required: false, disabler: true)
  endif
  if blas.found() and not fc.links('x=dnrm2(1, [2.], 1); end', dependencies: blas, name: 'BLAS')
    blas = disabler()
  endif

  lapack = dependency('lapack', cmake_module_path: 'cmake/Modules', required: false, disabler: true)
  if not lapack.found()
    lapack = fc.find_library('lapack', required: false, disabler: true)
  endif
  if lapack.found() and not fc.links('print *,disnan(0.); end', dependencies: lapack, name: 'LAPACK')
    lapack = disabler()
  endif
  if not lapack.found() or not blas.found()
    lapack_proj = subproject('lapack')
    lapack = lapack_proj.get_variable('lapack')
    blas = lapack_proj.get_variable('blas')
  endif
else
  # MKL
  lapack = []
  n1 = fc.get_id() == 'gcc' ? 'mkl_gf_lp64' : 'mkl_intel_lp64'
  names = [n1, 'mkl_intel_thread', 'mkl_core']
  if os == 'windows'
    names += 'iomp5md'
  endif
  foreach n : names
    lapack += fc.find_library(n, dirs: mkllib_root)
  endforeach
  lapack += intelMP_lib
  blas = lapack
endif

# --- intel MPI lib for Windows
intelmpi_lib = []
if mklroot != '' and os == 'windows'
  intelmpi_lib = fc.find_library('impi', dirs: mkllib_root)
endif

# --- Find BLACS
# some systems need Blacs explicitly, but most don't, so don't pass disabler() if not found.
blacs = []
if mklroot == ''
  blacs = fc.find_library('blacs-openmpi', required: false)
  if not blacs.found()
    blacs = []
  endif
else
  blacs += fc.find_library('mkl_blacs_intelmpi_lp64', dirs: mkllib_root)
endif

# --- Find Scalapack

# dependency('scalapack') not yet working in Meson--cmake->meson bug within Meson, yielding long meson-log.txt
# scalapack = dependency('scalapack', cmake_module_path : 'cmake/Modules')
scalapack = disabler()

if mklroot != ''
  scalapack_lib = fc.find_library('mkl_scalapack_lp64', dirs: mkllib_root)
  scalapack = declare_dependency(dependencies: [scalapack_lib, intelmpi_lib], include_directories: mklroot/'include/intel64/lp64')
endif

if not scalapack.found()
  scalapack_root = get_option('SCALAPACK_ROOT')
  if scalapack_root != ''
    scalapack = fc.find_library('scalapack', dirs : scalapack_root / 'lib', required: false, disabler: true)
  else
    if os == 'linux'
      scalapack = fc.find_library('scalapack-openmpi', required: false, disabler: true)
      if not scalapack.found()
        scalapack = fc.find_library('scalapack', required: false, disabler: true)
      endif
    elif os == 'darwin'
      scalapack_root = '/usr/local/opt/scalapack'
      scalapack = fc.find_library('scalapack', dirs: scalapack_root / 'lib', required: false, disabler: true)
    endif
  endif
  if scalapack.found() and not fc.links('L = numroc(1,1,1,1,1); end', dependencies: scalapack, name: 'SCALAPACK')
    scalapack = disabler()
  endif
endif

if not scalapack.found()
  scalapack_proj = subproject('scalapack')
  scalapack = declare_dependency(link_with: scalapack_proj.get_variable('scalapack_lib'))
endif