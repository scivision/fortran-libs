#
#  This file is part of MUMPS 5.3.4, released
#  on Mon Sep 28 07:16:41 UTC 2020
#
all: libmpiseq

.PHONY: all libmpiseq clean

include ../Makefile.inc

libmpiseq: libmpiseq$(PLAT)$(LIBEXT)

libmpiseq$(PLAT)$(LIBEXT): mpi.o mpic.o elapse.o
	$(AR)$@ mpi.o mpic.o elapse.o
	$(RANLIB) $@
.f.o:
	$(FC) $(OPTF)              -c $*.f $(OUTF)$*.o
.c.o:
	$(CC) $(OPTC) $(CDEFS) -I. -c $*.c $(OUTC)$*.o

clean:
	$(RM) *.o *$(LIBEXT)
