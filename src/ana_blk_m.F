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
      MODULE MUMPS_ANA_BLK_M
      TYPE COL_LMATRIX_T
       INTEGER :: NBINCOL   
       INTEGER, POINTER :: IRN(:) => null()  
      END TYPE COL_LMATRIX_T
      TYPE LMATRIX_T
       INTEGER    :: NBCOL
       INTEGER(8) :: NZL
       TYPE(COL_LMATRIX_T), POINTER :: COL(:) => null()
      END TYPE LMATRIX_T
      TYPE COMPACT_GRAPH_T
       INTEGER(8) :: NZG, SIZEADJALLOCATED
       INTEGER    :: NG
       INTEGER(8), POINTER :: IPE(:) => null()  
       INTEGER, POINTER :: ADJ(:) => null()  
      END TYPE COMPACT_GRAPH_T
      END MODULE MUMPS_ANA_BLK_M
