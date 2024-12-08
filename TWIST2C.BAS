    1 REM TWIST2.BAS
    5 REM DECLARE ARRAYS FOR COMPUTED POLYGON VERTICES
   10 DIM RXP(12), RYP(12)
   15 REM DECLARE ARRAYS FOR SIN AND COS TO 0.1 DEGREES
   20 DIM RCOS(3600), RSIN(3600)
   24 REM SET MAXIMUM COLORS TO USE
   25 MAXC%=15
   26 CLS
   30 PRINT "COMPUTING SIN, COS ARRAYS"
   31 REM SHOW FUN CIRCULAR PATTERN WHEN COMPUTING SIN AND COS
   35 R=100 : REM RADIUS OF PATTERN
   36 W=10 : REM WIDTH OF PATTERN
   40 FOR A%=0 TO 3600
   50   RCOS(A%)=COS(RAD(A%/10))
   60   RSIN(A%)=SIN(RAD(A%/10))
   70   REM PRINT RCOS(A%);",";SIN(A%)
   74   GCOL 0,A%/10 MOD 16
   75   PLOT 4,512+R*RCOS(A%),512+R*RSIN(A%)
   76   PLOT 5,512+(R+W)*RCOS(A%),512+(R+W)*RSIN(A%)
   77   R=R+RSIN(A%)/4
   78   W=W+RCOS(A%)/4
   80 NEXT A%
   90 MAXX%=1024
  100 CLS
  101 REM RANDOMIZE ANGLE SIZE BETWEEN POLYGON VERTICES
  105 ANGST%=10*(1+RND(29))
  106 REM RANDOMIZE SCALING FACTOR FOR EACH SUCCESSIVE POLYGON IN PATTERN 
  110 SCALE=0.8+RND(190)/1000
  115 REM LOOP FOR NUMBER OF SIDES FOR EACH POLYGON (MIN 2)
  120 FOR S%=2 TO 8
  121   FOR C%=0 TO MAXC%
  122     COLOUR C%
  123     PRINT TAB(65,40+C%)"COLOR ";C%;
  124   NEXT C%
  125   PRINT TAB(62,11)"ANGLE=";ANGST%/10
  130   PRINT TAB(62,13)"SCALE=";SCALE;
  140   PRINT TAB(62,12)"SIDES=";S%;
  145   REM CALCULATE ANGLE IN 10THS OF DEG FOR NUMBER OF SIDES
  150   AD=3600/S%
  160   C%=1
  170   X%=MAXX%/2
  190   FOR A%=0 TO AD STEP ANGST%
  230     C%=C%+1
  240     GCOL 0,C%
  250     PROC_POLY(X%,MAXX%,A%,S%)
  300     IF C%>MAXC% THEN C%=1
  320   NEXT A%
  325   REM COMPUTE NEXT X VALUE SCALED FROM PREVIOUS UNTIL MIN OF 64
  330   X%=X%*SCALE
  340   IF X% >= 64 THEN GOTO 190
  345   REM INTRODUCE DELAY BETWEEN EACH NEW NUMBER OF SIDES
  350   K=INKEY(100)
  360   CLS
  370 NEXT S%
  380 GOTO 100
  390 END
  395 REM DEFINE PROCEDURE TO PLOT POLYGON
  396 REM GIVEN RADIUS, MAX X, STARTING ANGLE, AND NUMBER OF SIZES
  400 DEF PROC_POLY(XP%,MAXXP%,AP,NS%)
  410 CENTER%=MAXXP%/2
  420 FOR I%=1 TO NS%
  430   ADP%=INT(AP+(I%-1)*AD)
  440   RXP(I%)=CENTER%-XP%*RCOS(ADP%)
  450   RYP(I%)=CENTER%-XP%*RSIN(ADP%)
  460 NEXT I%
  470 PLOT 4,RXP(1),RYP(1)
  480 FOR I%=2 TO NS%
  490   PLOT 5,RXP(I%),RYP(I%)
  500 NEXT I%
  510 PLOT 5,RXP(1),RYP(1)
  520 ENDPROC
