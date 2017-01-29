SOL*    FIT             2.49213-5       SAG             LIN             
$
$ Solution Entries
$
$--1---><--2---><--3---><--4---><--5---><--6---><--7---><--8---><--9--->
FEAPROG MSCNAST IN      NONE    CEL     
OPTPROG NONE    MM      
SYMM    FULL            
MODFILE%Test.bdf
$
$ Surface Entries
$
$--1---><--2---><--3---><--4---><--5---><--6---><--7---><--8---><--9--->
SURFACE 1       Surface PROP    1               POS     -1              
SURDEF  1       1       2       
%       
SURGEOM 1       ASPH    80.315  0.      0.      0.      1.              
        OPT     
SURGRT  1       0               OPT     1.      0.      0.      
SUROFF  1       0.      0.      SAG             VCID    0.      
SURAPER 1       NONE                    
SUROBST 1       NONE                    
SURWT   1       CALC            SAME            
SURMESH 1       NONE                                            
SLUMP1  1       NONE    FCID    FCID    FCID    NO              
SUBT    1       ALL     NONE    LCL     0       
FITPOLY 1       ZRN     8       6                       
$--1---><--2---><--3---><--4---><--5---><--6---><--7---><--8---><--9--->
MATMED  1.      0.      0.      DATA    CONST           
$
$ Disturbances Entries
$
$--1---><--2---><--3---><--4---><--5---><--6---><--7---><--8---><--9--->
DISTYP  NO      ALL     NONE    NONE    NONE    NONE    
DFOPT   DFFILE  
DFSTPD1 ALL                                                             
$
$ Actuators Entries
$
$--1---><--2---><--3---><--4---><--5---><--6---><--7---><--8---><--9--->
ACTTYP  NO      ALL     NONE    NONE    NONE    NONE    
$
$ Genetic Optimization Entries
$
$--1---><--2---><--3---><--4---><--5---><--6---><--7---><--8---><--9--->
GENPRM  25      1.0-3   4       1.0-3   4       50      .6      .033    
$
$ Harmonic Response Entries
$
$--1---><--2---><--3---><--4---><--5---><--6---><--7---><--8---><--9--->
FREQ4   3       
$
$ Random Response Entries
$
$--1---><--2---><--3---><--4---><--5---><--6---><--7---><--8---><--9--->
PSDTYP  DATA    CONST           1.      
$
$ Damping Entries
$
$--1---><--2---><--3---><--4---><--5---><--6---><--7---><--8---><--9--->
DMPTYP1 DATA    CONST                           NONE    0.      0.      
%
$
$ Equation Entries
$
$--1---><--2---><--3---><--4---><--5---><--6---><--7---><--8---><--9--->
EQNLOS  NO      1       9       3       3       
EQNPOL  NO      1       9       3       3       
EQNRES  NO      1       9       100000  BOTH    3       3       
$
$ System Entries
$
$--1---><--2---><--3---><--4---><--5---><--6---><--7---><--8---><--9--->
SYSLOS  NO      NO      
LOSMTF  DATA    CONST           1.      0.              OPT     
SYSDATA 0.      
LOSREAD NO      FE      RAD     RHS     
$
$ Line-of-Sight Utilities Entries
$
$--1---><--2---><--3---><--4---><--5---><--6---><--7---><--8---><--9--->
LOSDATA 1.      1.0-5   1.0-5   1.0-8   FIX     
LOSRAY          0.      0.      0.      0.      0.      1.      
$
$ Monte Carlo Entries
$
$--1---><--2---><--3---><--4---><--5---><--6---><--7---><--8---><--9--->
MONTE   NO      1000            FEA     90.     YES     NO      
$
$ Output Entries
$
$--1---><--2---><--3---><--4---><--5---><--6---><--7---><--8---><--9--->
OUTSUM1 NO      
OUTSUM2 NO      
OUTNOD  NO      
OUTNODX NO      
OUTOPT  NO      
OUTDIS  NO      
OUTRSD  NO      
OUTCOF1 NO      
OUTCOF2 NO      
OUTCOF3 NO      
OUTACT  NO      
OUTCOR1 NO      
OUTCOR2 NO      
OUTSUB  NO      
OUTDYN  NO      
OUTDATA NONE    200     
OUTVEC  NONE    NONE    
OUTLOS  NO      
OUTRVIZ NO              
DIAGPRT STD     
APLTDOF TE2     TE3     TE4     TE5     TE6     TE7     TE8     TE9     
        TE10    TE11    TE12    TE13    TE14    TE15    TE16    TE17    
        TE18    TE19    TE20    TE21    TE22    TE23    TE24    TE25    
        TE26    
PARAM   OUTNAS  NO      
PARAM   EQNCORR EQNCORR 
PARAM   PRETOL  1.0-3   
PARAM   DLLDB   OPD     
PARAM   MAXACT  5000    
PARAM   NOROC   NO      
PARAM   EQNBLK  300     
PARAM   ZEMAX1  NO      
PARAM   COMBRMS NO      
PARAM   LOSZERO 1.0-10  
PARAM   APERTOL 1.0-3   
PARAM   FSTTOL  1.0-3   
PARAM   ROTZERO 1.0-18  
PARAM   OUT2D   NO      
PARAM   OUTSMCS -1      
PARAM   DELSCR  YES     
PARAM   TODN    ABS     
PARAM   NCLOS3D 8       
PARAM   MAXDIS  5000    
PARAM   ABQVER  6114    
PARAM   OUTANS  NO      
PARAM   ALOPTM  GENETIC 
PARAM   ZEROSLP YES     
PARAM   COUPDMP AUTO    
PARAM   DFREQ   1.0-5   
PARAM   NODATA  NO      
NCELL   10      10      1       
