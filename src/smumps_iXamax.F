C
C  This file is part of MUMPS 5.3.1, released
C  on Fri Apr 10 13:52:30 UTC 2020
C
C
C  Copyright 1991-2020 CERFACS, CNRS, ENS Lyon, INP Toulouse, Inria,
C  Mumps Technologies, University of Bordeaux.
C
C  This version of MUMPS is provided to you free of charge. It is
C  released under the CeCILL-C license:
C  http://www.cecill.info/licences/Licence_CeCILL-C_V1-en.html
C
      INTEGER FUNCTION SMUMPS_IXAMAX(N,X,INCX,GRAIN)
      IMPLICIT NONE
      REAL, intent(in) :: X(*)
      INTEGER, intent(in) :: INCX,N
      INTEGER, intent(in) :: GRAIN
      INTEGER isamax
      SMUMPS_IXAMAX = isamax(N,X,INCX)
      RETURN
      END FUNCTION SMUMPS_IXAMAX
