#
#  This file is part of MUMPS 5.1.2, released
#  on Mon Oct  2 07:37:01 UTC 2017
#
# These settings for a PC under Debian/linux with standard packages :
# metis (parmetis), scotch (ptscotch), openmpi, gfortran

# packages installation : 
# apt install libmetis-dev libparmetis-dev libscotch-dev libptscotch-dev libatlas-base-dev openmpi-bin libopenmpi-dev liblapack-dev

# Begin orderings
LSCOTCHDIR = /usr/lib
ISCOTCH   = -I/usr/include/scotch

#LSCOTCH   = -L$(LSCOTCHDIR) -lptesmumps -lptscotch -lptscotcherr
LSCOTCH   = -L$(LSCOTCHDIR) -lesmumps -lscotch -lscotcherr

LPORDDIR = $(topdir)/PORD/lib/
IPORD    = -I$(topdir)/PORD/include/
LPORD    = -L$(LPORDDIR) -lpord

LMETISDIR = /usr/lib 
#IMETIS    = -I/usr/include/parmetis
IMETIS    = -I/usr/include/metis

# LMETIS    = -L$(LMETISDIR) -lparmetis -lmetis
LMETIS    = -L$(LMETISDIR) -lmetis

# Corresponding variables reused later
#ORDERINGSF = -Dmetis -Dpord -Dparmetis -Dscotch -Dptscotch
#ORDERINGSF = -Dmetis -Dpord -Dscotch
ORDERINGSF = -Dpord
ORDERINGSC  = $(ORDERINGSF)

LORDERINGS = $(LMETIS) $(LPORD) $(LSCOTCH)
IORDERINGSF = $(ISCOTCH)
IORDERINGSC = $(IMETIS) $(IPORD) $(ISCOTCH)
# End orderings
################################################################################

PLAT    =
LIBEXT  = .a
OUTC    = -o 
OUTF    = -o 
CC = mpicc
FC = mpif90
FL = mpif90
AR = ar vr 
RANLIB = ranlib
LAPACK = $(LAPACK) -llapack

SCALAPDIR = /usr/lib
SCALAP  = -L$(SCALAPDIR) -lscalapack-openmpi -lblacs-openmpi  -lblacsF77init-openmpi -lblacsCinit-openmpi

INCPAR = -I/usr/lib/x86_64-linux-gnu/openmpi/include/

LIBPAR = $(SCALAP) $(LAPACK)  -lmpi -lmpi_mpifh #-lmpi_f77

INCSEQ = -I$(topdir)/libseq
LIBSEQ  = $(LAPACK) -L$(topdir)/libseq -lmpiseq

LIBBLAS = $(BLAS) -lblas
LIBOTHERS = -lpthread

#Preprocessor defs for calling Fortran from C (-DAdd_ or -DAdd__ or -DUPPER)
CDEFS   = -DAdd_

#Begin Optimized options
# uncomment -fopenmp in lines below to benefit from OpenMP
OPTF    = -O # -fopenmp
OPTL    = -O # -fopenmp
OPTC    = -O # -fopenmp
#End Optimized options
 
INCS = $(INCPAR)
LIBS = $(LIBPAR)
LIBSEQNEEDED =
