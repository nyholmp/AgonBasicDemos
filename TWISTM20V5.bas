   10 REM TWISTM20.BAS
   20 :
   30 REM WRITTEN BY PETE NYHOLM
   40 REM CREDIT FOR PROC_LOAD_LOGO AND PROC_DRAW_LOGO TO STEVE LOVEJOY
   50 REM CODE BASED ON ORIGINAL BOOTSCREEN.BAS VERSION 2.0
   60 REM CREDIT FOR ICON TO ARNOLD MESZAROS
   70 REM TESTED FOR MODE 0
   80 REM LOAD LOGO AS HEX DATA AND LOAD INTO STRING ARRAY
   90 REM PARTS REWRITTEN FOR BBCBASIC V v1.00
  100 :
  110 DIM L$(7) : REM INITIALIZE LOGO STRING ARRAY 
  120 FOR LL%=0 TO 7 : L$(LL%)="" : FOR LC%=1 TO 6 
  130     READ V% : L$(LL%)+=CHR$(V%)
  140   NEXT LC% : NEXT LL%
  150 :
  160 DATA 032,032,200,201,032,032
  170 DATA 032,032,202,203,032,032
  180 DATA 032,204,205,206,207,032
  190 DATA 208,209,210,211,212,213
  200 DATA 214,215,216,209,217,218
  210 DATA 219,220,221,222,223,224
  220 DATA 225,226,227,228,229,230
  230 DATA 231,232,233,234,235,236
  240 : REM Declare arrays for changeable variables
  250 DIM chgval%(3),chgkey%(3),chgdesc$(3),chgmin%(3),chgmax%(3)
  260 FOR I%=0 TO 3
  270   READ chgval%(I%), chgkey%(I%), chgdesc$(I%), chgmin%(I%), chgmax%(I%)
  280 NEXT I%
  290 :
  300 DATA 30,65,"MAX ANGLE STEP",1,60
  310 DATA 0,66,"BG COLOR",0,63
  320 DATA 8,83,"MIN SCALE",1,10
  330 DATA 12,78,"MAX POLY SIDES",3,12
  340 :
  350 REM DECLARE ARRAYS FOR COMPUTED POLYGON VERTICES UP TO 12 SIDES
  360 DIM PX(12), PY(12)
  370 REM DECLARE ARRAYS FOR SIN AND COS TO 0.1 DEG, NEED 10*360 X 1 LOOKUP TABLE
  380 DIM LCOS(3600), LSIN(3600)
  390 REM SET MAXIMUM COLORS TO USE FOR MODE 0
  400 MAXC%=63
  410 COLOUR 128+chgval%(1)
  420 MODE 20 : CLS
  430 PROC_LOAD_LOGO
  440 LCOL%=23 : LROW%=20 : REM CENTERS LOGO FOR MODE 20
  450 PROC_DRAW_LOGO(LCOL%-10,LROW%-2,4)
  460 PRINT TAB(30,40)"COMPUTING SIN, COS ARRAYS";
  470 REM SHOW FUN CIRCULAR PATTERN WHEN COMPUTING SIN AND COS
  480 R=100 : REM RADIUS OF PATTERN
  490 W=10 : REM WIDTH OF PATTERN
  500 FOR A%=0 TO 3600
  510   LCOS(A%)=COS(RAD(A%/10))
  520   LSIN(A%)=SIN(RAD(A%/10))
  530   IF (A% MOD 10) = 0 THEN
  540     GCOL 0,A%/10 MOD (MAXC% + 1)
  550     PLOT 4,512+R*LCOS(A%),512+R*LSIN(A%)
  560     PLOT 5,512+(R+W)*LCOS(A%),512+(R+W)*LSIN(A%)
  570   ENDIF
  580   R+=LSIN(A%)/4
  590   W+=LCOS(A%)/4
  600 NEXT A%
  610 MAXX%=1024
  620 APER%=128 : REM MIN APERATURE FOR CENTER
  630 REPEAT
  640   REM RANDOMIZE ANGLE SIZE BETWEEN POLYGON VERTICES
  650   ASTEP%=10*(1+RND(chgval%(0)-1)) : REM RANDOM ANGLE UP TO MAXSTEP
  660   REM RANDOMIZE SCALING FACTOR FOR EACH SUCCESSIVE POLYGON IN PATTERN 
  670   SCALE=chgval%(2)/10+RND((10-chgval%(2))*100-1)/1000
  680   REM LOOP FOR NUMBER OF SIDES FOR EACH POLYGON (MIN 2) : MIN 3 FOR LOGO
  690   FOR S%=3 TO chgval%(3)
  700     COLOUR 128+chgval%(1) : CLS
  710     FOR C%=0 TO MAXC%
  720       COLOUR C% : PRINT TAB(52,26)"COLORS";
  730       D%=C% DIV 16 : PRINT TAB(52+3*D%,27+C%-16*D%);"";C%;
  740     NEXT C%
  750     REPEAT LCOLOR%=1+RND(14) : UNTIL LCOLOR% <> chgval%(1)
  760     PROC_DRAW_LOGO(LCOL%,LROW%,LCOLOR%)
  770     PRINT TAB(43,1)"HIT KEY DURING PAUSE";
  780     PRINT TAB(43,2)"TO CHANGE";
  790     FOR CHGVAR%=0 TO 3 : PROC_PRINT_CHGVAR(CHGVAR%) : NEXT CHGVAR%
  800     PRINT TAB(46,7)"Q: QUIT";
  810     PRINT TAB(52,11)"ANGLE=";ASTEP%/10
  820     PRINT TAB(52,12)"SCALE=";SCALE;
  830     PRINT TAB(52,13)"SIDES=";S%;
  840     REM CALCULATE ANGLE IN 10THS OF DEG FOR NUMBER OF SIDES
  850     ASIDE=3600/S% : C%=0 : X%=MAXX%/2
  860     REPEAT
  870       FOR A%=0 TO ASIDE STEP ASTEP%
  880         REPEAT C%=C%+1 UNTIL C% <> chgval%(2) : REM AVOID BACKGROUND COLOR
  890         GCOL 0,C%
  900         PROC_POLY(X%,MAXX%,A%,S%)
  910         IF C%>MAXC% THEN C%=0
  920       NEXT A%
  930       REM COMPUTE NEXT X VALUE SCALED FROM PREVIOUS UNTIL MIN OF APER%
  940       X%=X%*SCALE
  950     UNTIL X% < APER% + 54/(S%-2)
  960     REM INTRODUCE DELAY BETWEEN EACH NEW NUMBER OF SIDES
  970     K=INKEY(100)
  980     IF K <> -1 THEN 
  990     IF K = 81 EXIT REPEAT : REM Q = QUIT
 1000     FOR CHG% = 0 TO 3
 1010       IF K = chgkey%(CHG%) THEN chgval%(CHG%)=FN_NEWVAL(CHG%) : EXIT FOR
 1020     NEXT CHG%
 1030   ENDIF
 1040 NEXT S%
 1050 UNTIL FALSE
 1060 PRINT TAB(30,47);"THANKS FOR TRYING THE PROGRAM."
 1070 END
 1080 DEF FN_NEWVAL(CHG%)
 1090 REPEAT PRINT TAB(1,47);"ENTER NEW VALUE FOR ";chgdesc$(CHG%);"[";chgmin%(CHG%);"-";chgmax%(CHG%);"]"; : INPUT NEWVAL
 1100 UNTIL NEWVAL >= chgmin%(CHG%) AND NEWVAL <= chgmax%(CHG%)
 1110 =NEWVAL
 1120 :
 1130 DEF PROC_PRINT_CHGVAR(VAR%)
 1140 PRINT TAB(44,VAR%+3);CHR$(chgkey%(VAR%));": ";chgdesc$(VAR%);"=";chgval%(VAR%)
 1150 ENDPROC
 1160 :
 1170 REM DEFINE PROCEDURE TO PLOT POLYGON
 1180 REM GIVEN RADIUS, MAX X, STARTING ANGLE, AND NUMBER OF SIZES
 1190 DEF PROC_POLY(XP%,MAXXP%,AP,NS%)
 1200 CENTER%=MAXXP%/2
 1210 FOR I%=1 TO NS%
 1220   ADP%=INT(AP+(I%-1)*ASIDE)
 1230   PX(I%)=CENTER%-XP%*LCOS(ADP%)+8
 1240   PY(I%)=CENTER%-XP%*LSIN(ADP%)
 1250   IF I% = 1 THEN PLOT 4,PX(1),PY(1) ELSE PLOT 5,PX(I%),PY(I%)
 1260 NEXT I%
 1270 PLOT 5,PX(1),PY(1)
 1280 ENDPROC
 1290 :
 1300 DEF PROC_DRAW_LOGO(COL%,ROW%,LC%) : REM COLUMN, ROW, COLOR
 1310 REM DISPLAY THE LOGO LINE BY LINE FROM LOGO ARRAY
 1320 COLOUR LC%
 1330 FOR I%=0 TO 7 : PRINT TAB(COL%,ROW%+I%);L$(I%); : NEXT I%
 1340 ENDPROC
 1350 :
 1360 DEF PROC_LOAD_LOGO
 1370 REM AGON LIGHT "Sitting Kung Fu man" LOAD LOGO CHARS
 1380 FOR AC%=200 TO 237 : VDU 23,AC%
 1390   FOR I%=1 TO 8 : READ V$ : H%=EVAL("&"+V$) : VDU H% : NEXT I%
 1400 NEXT AC%
 1410 ENDPROC
 1420 REM HEX VALUES FOR CUSTOM LOGO CHARACTERS TO BE READ INTO VDU
 1430 DATA 07,0F,1F,1F,1F,1F,1F,3F, C0,E0,F0,F0,F0,F0,F0,F8
 1440 DATA 3F,3F,1F,0F,0F,0F,07,07, F8,F8,F0,E0,E0,E0,C0,C0
 1450 DATA 00,01,07,0F,1F,3F,7F,7F, 07,C7,C7,C3,E3,E1,F0,F0
 1460 DATA C0,C3,C3,87,87,0F,0F,1F, 00,00,E0,F0,F8,FC,FC,FE
 1470 DATA 00,00,01,01,03,03,07,07, FF,FF,FF,FF,FF,FF,FF,FF
 1480 DATA F8,F8,F8,F0,E0,E1,C1,C3, 3F,3F,7F,FF,FF,FF,FF,FF
 1490 DATA FF,FF,FF,FF,FF,FF,DF,DF, 00,00,80,80,80,C0,C0,C0
 1500 DATA 07,07,0F,0F,0F,0F,0F,1F, FF,F7,E7,E7,E7,C7,87,82
 1510 DATA C7,87,87,8F,0F,0F,1F,1F, CF,CF,CF,C7,C7,C3,81,01
 1520 DATA E0,E0,E0,F0,F0,F0,F0,F0, 1F,1F,1F,1F,0F,0F,0F,1F
 1530 DATA 80,80,80,80,81,8F,87,8F, 1F,3F,0F,00,80,E0,E0,C3
 1540 DATA FC,F0,80,00,03,07,23,F3, 01,01,01,81,C1,E1,F1,F1
 1550 DATA F0,F0,F0,F0,F0,F0,F0,F0, 1F,1F,03,03,03,03,07,0F
 1560 DATA DF,FF,FF,FF,FF,FF,FE,FE, C7,87,87,07,0F,0F,1F,1F
 1570 DATA F1,F1,F1,F8,F8,F8,F8,F8, FD,FF,FF,FF,FF,FF,FF,7F
 1580 DATA F0,F8,F8,E0,E0,E0,F0,F8, 1F,3F,3F,3F,1F,1F,0F,00
 1590 DATA FE,FC,FC,FC,F8,F8,E0,00, 1F,3C,20,00,00,00,00,00
 1600 DATA 78,1C,0C,0C,00,00,00,00, 7F,7F,7F,7F,7F,3F,0F,00
 1610 DATA F8,FC,FC,FC,FC,F8,F0,00, FF,FE,FC,F8,F0,E0,C0,80
