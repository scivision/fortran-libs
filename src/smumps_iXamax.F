C
C  This file is part of MUMPS 5.3.3, released
C  on Mon Jun 15 09:57:25 UTC 2020
C
C
C  Copyright 1991-2020 CERFACS, CNRS, ENS Lyon, INP Toulouse, Inria,
C  Mumps Technologies, University of Bordeaux.
C
C  This version of MUMPS is provided to you free of charge. It is
C  released under the CeCILL-C license:
C  https://cecill.info/licences/Licence_CeCILL-C_V1-en.html
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
