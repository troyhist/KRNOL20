REM -------------------------------------------------------------------------
REM KRestiki-NOLiki ver. 2.0
REM Kolevatow Sergey (c) 1996
REM Troy computing, Inc.
REM -------------------------------------------------------------------------
DECLARE FUNCTION CHKCFG% ()
DECLARE FUNCTION DEINT% (HEXDT0%, HEXDT1%)
DECLARE FUNCTION GETUD% ()
DECLARE FUNCTION GETCOMPFIG% ()
DECLARE FUNCTION GETCOMPMOVE% ()
DECLARE FUNCTION GETLR% ()
DECLARE FUNCTION PLAYAGAIN% ()
DECLARE FUNCTION SHOWINTRO% ()
DECLARE FUNCTION SHTSTR$ (SSTR$, PAR%)
REM -------------------------------------------------------------------------
DECLARE SUB CREATWORKSCR (PAR%, NPTH$)
DECLARE SUB EXITGAME ()
DECLARE SUB GETPLAYERMOVE ()
DECLARE SUB HALLOFFAME ()
DECLARE SUB LOSER (FIG%)
DECLARE SUB PALLOAD (PLOD$)
DECLARE SUB PRKEY ()
DECLARE SUB SCROFF (PAR%)
DECLARE SUB SETPAL (SEGM%, OFFS%)
DECLARE SUB SHOWPOINT (X%, Y%)
DECLARE SUB SHOWSPRITE (XCOR%, YCOR%, FIG%)
DECLARE SUB VGALOAD (VLOD$)
REM -------------------------------------------------------------------------
REM $INCLUDE: 'QBX.BI'
REM $INCLUDE: 'KRNOL.BI'
REM $INCLUDE: 'SETUP.BI'
REM -------------------------------------------------------------------------
DEFINT A-Z
REM -------------------------------------------------------------------------
PRINT
PRINT SHTSTR$(STR0$, 255)
PRINT SHTSTR$(STR1$, 255)
PRINT SHTSTR$(STR2$, 255)
PRINT : PRINT "Press any key to continue ...": CALL PRKEY: PRINT
PRINT "Checking CFG file ...": PRINT
REM -------------------------------------------------------------------------
MAINDATA:
REM -------------------------------------------------------------------------
A = CHKCFG: NPTH$ = RTRIM$(SHTSTR$(CFG.path, 255))
REM -------------------------------------------------------------------------
PRINT
IF A = 1 THEN PRINT "Checking CFG - Ok": PRINT
PRINT "Press any key to continue ...": CALL PRKEY: PRINT
REM -------------------------------------------------------------------------
CHKINTRO:
REM -------------------------------------------------------------------------
B = SHOWINTRO%
REM -------------------------------------------------------------------------
IF B = 1 THEN
REM -------------------------------------------------------------------------
	GOTO NEWGAME
REM -------------------------------------------------------------------------
ELSEIF B = 2 THEN
REM -------------------------------------------------------------------------
	CALL HALLOFFAME
	GOTO CHKINTRO
REM -------------------------------------------------------------------------
ELSEIF B = 3 THEN
REM -------------------------------------------------------------------------
	CALL EXITGAME
REM -------------------------------------------------------------------------
END IF
REM -------------------------------------------------------------------------
NEWGAME:
REM -------------------------------------------------------------------------
FOR XC% = 1 TO 3
FOR YC% = 1 TO 3
KRNOLMAP(XC%, YC%).attrib = 0
NEXT YC%, XC%
REM -------------------------------------------------------------------------
PLX% = 2: PLY% = 2: CRX% = 2: CRY% = 2: OCX% = 2: OCY% = 2
REM -------------------------------------------------------------------------
FREECELL% = 0: FC = 0: CF = 0: PF = 0: FCX = 0: FCY = 0: FREECS = 9
REM -------------------------------------------------------------------------
F% = GETCOMPFIG%
REM -------------------------------------------------------------------------
IF F% = NOLIK% THEN COMPFIG% = KREST%: PLAYERFIG% = NOLIK%
IF F% = KREST% THEN COMPFIG% = NOLIK%: PLAYERFIG% = KREST%
REM -------------------------------------------------------------------------
COMPMOVE = GETCOMPMOVE%
REM -------------------------------------------------------------------------
CREATWORKSCR 1, NPTH$
REM -------------------------------------------------------------------------
IF COMPMOVE = 1 THEN
REM -------------------------------------------------------------------------
	KRNOLMAP(2, 2).attrib = COMPFIG%
	SHOWSPRITE 2, 2, COMPFIG%
	COMPMOVE = 0
	FREECS = FREECS - 1
REM -------------------------------------------------------------------------
END IF
REM -------------------------------------------------------------------------
SHOWSPRITE 2, 2, 3
REM -------------------------------------------------------------------------
GAMESTART:
REM -------------------------------------------------------------------------
IF FREECS = 0 THEN
REM -------------------------------------------------------------------------
	SLEEP 1
	EG = PLAYAGAIN%
	IF EG = NO% THEN GOTO CHKINTRO
	IF EG = YES% THEN GOTO NEWGAME
REM -------------------------------------------------------------------------
END IF
REM -------------------------------------------------------------------------
CALL GETPLAYERMOVE: FREECS = FREECS - 1: COMPMOVE = 1
REM -------------------------------------------------------------------------
REM Preprocessor (Diagonals checking)
REM -------------------------------------------------------------------------
REM Diagonal I (Main)
REM -------------------------------------------------------------------------
FOR I = 1 TO 3
REM -------------------------------------------------------------------------
IF KRNOLMAP(I, I).attrib = COMPFIG% THEN CF = CF + 1
IF KRNOLMAP(I, I).attrib = PLAYERFIG% THEN PF = PF + 1
IF KRNOLMAP(I, I).attrib = FREECELL% THEN FC = FC + 1: FCX = I: FCY = I
REM -------------------------------------------------------------------------
NEXT I
REM -------------------------------------------------------------------------
IF PF = 2 AND COMPMOVE = 1 AND KRNOLMAP(FCY, FCX).attrib = FREECELL% AND CF = 0 THEN
REM -------------------------------------------------------------------------
	KRNOLMAP(FCY, FCX).attrib = COMPFIG%
	SHOWSPRITE FCX, FCY, COMPFIG%
	COMPMOVE = 0
	FREECS = FREECS - 1
REM -------------------------------------------------------------------------
END IF
REM -------------------------------------------------------------------------
IF CF = 3 THEN
REM -------------------------------------------------------------------------
	CALL PRKEY
	LOSER PLAYERFIG%
	EG = PLAYAGAIN%
	IF EG = NO% THEN GOTO CHKINTRO
	IF EG = YES% THEN GOTO NEWGAME
REM -------------------------------------------------------------------------
END IF
REM -------------------------------------------------------------------------
IF PF = 3 THEN
REM -------------------------------------------------------------------------
	CALL PRKEY
	LOSER COMPFIG%
	EG = PLAYAGAIN%
	IF EG = NO% THEN GOTO CHKINTRO
	IF EG = YES% THEN GOTO NEWGAME
REM -------------------------------------------------------------------------
END IF
REM -------------------------------------------------------------------------
CF = 0: PF = 0: FC = 0
REM -------------------------------------------------------------------------
REM Diagonal II (SubMain)
REM -------------------------------------------------------------------------
FOR I = 1 TO 3
REM -------------------------------------------------------------------------
IF KRNOLMAP(4 - I, I).attrib = COMPFIG% THEN CF = CF + 1
IF KRNOLMAP(4 - I, I).attrib = PLAYERFIG% THEN PF = PF + 1
IF KRNOLMAP(4 - I, I).attrib = FREECELL% THEN FC = FC + 1: FCX = I: FCY = 4 - I
REM -------------------------------------------------------------------------
NEXT I
REM -------------------------------------------------------------------------
IF PF = 2 AND COMPMOVE = 1 AND KRNOLMAP(FCY, FCX).attrib = FREECELL% AND CF = 0 THEN
REM -------------------------------------------------------------------------
	KRNOLMAP(FCY, FCX).attrib = COMPFIG%
	SHOWSPRITE FCX, FCY, COMPFIG%
	COMPMOVE = 0
	FREECS = FREECS - 1
REM -------------------------------------------------------------------------
END IF
REM -------------------------------------------------------------------------
IF CF = 3 THEN
REM -------------------------------------------------------------------------
	CALL PRKEY
	LOSER PLAYERFIG%
	EG = PLAYAGAIN%
	IF EG = NO% THEN GOTO CHKINTRO
	IF EG = YES% THEN GOTO NEWGAME
REM -------------------------------------------------------------------------
END IF
REM -------------------------------------------------------------------------
IF PF = 3 THEN
REM -------------------------------------------------------------------------
	CALL PRKEY
	LOSER COMPFIG%
	EG = PLAYAGAIN%
	IF EG = NO% THEN GOTO CHKINTRO
	IF EG = YES% THEN GOTO NEWGAME
REM -------------------------------------------------------------------------
END IF
REM -------------------------------------------------------------------------
CF = 0: PF = 0: FC = 0
REM -------------------------------------------------------------------------
REM Rows 1,2,3
REM -------------------------------------------------------------------------
FOR Y = 1 TO 3
REM -------------------------------------------------------------------------
FOR X = 1 TO 3
REM -------------------------------------------------------------------------
IF KRNOLMAP(Y, X).attrib = COMPFIG% THEN CF = CF + 1
IF KRNOLMAP(Y, X).attrib = PLAYERFIG% THEN PF = PF + 1
IF KRNOLMAP(Y, X).attrib = FREECELL% THEN FC = FC + 1: FCX = X: FCY = Y ': FREECS = FREECS + 1
REM -------------------------------------------------------------------------
NEXT X
REM -------------------------------------------------------------------------
IF PF = 2 AND COMPMOVE = 1 AND KRNOLMAP(FCY, FCX).attrib = FREECELL% AND CF = 0 THEN
REM -------------------------------------------------------------------------
	KRNOLMAP(FCY, FCX).attrib = COMPFIG%
	SHOWSPRITE FCX, FCY, COMPFIG%
	COMPMOVE = 0
	FREECS = FREECS - 1
REM -------------------------------------------------------------------------
END IF
REM -------------------------------------------------------------------------
IF CF = 3 THEN
REM -------------------------------------------------------------------------
	CALL PRKEY
	LOSER PLAYERFIG%
	EG = PLAYAGAIN%
	IF EG = NO% THEN GOTO CHKINTRO
	IF EG = YES% THEN GOTO NEWGAME
REM -------------------------------------------------------------------------
END IF
REM -------------------------------------------------------------------------
IF PF = 3 THEN
REM -------------------------------------------------------------------------
	CALL PRKEY
	LOSER COMPFIG%
	EG = PLAYAGAIN%
	IF EG = NO% THEN GOTO CHKINTRO
	IF EG = YES% THEN GOTO NEWGAME
REM -------------------------------------------------------------------------
END IF
REM -------------------------------------------------------------------------
CF = 0: PF = 0: FC = 0
REM -------------------------------------------------------------------------
NEXT Y
REM -------------------------------------------------------------------------
REM Columns 1,2,3
REM -------------------------------------------------------------------------
FOR X = 1 TO 3
REM -------------------------------------------------------------------------
FOR Y = 1 TO 3
REM -------------------------------------------------------------------------
IF KRNOLMAP(Y, X).attrib = COMPFIG% THEN CF = CF + 1
IF KRNOLMAP(Y, X).attrib = PLAYERFIG% THEN PF = PF + 1
IF KRNOLMAP(Y, X).attrib = FREECELL% THEN FC = FC + 1: FCX = X: FCY = Y ': FREECS = FREECS + 1
REM -------------------------------------------------------------------------
NEXT Y
REM -------------------------------------------------------------------------
IF PF = 2 AND COMPMOVE = 1 AND KRNOLMAP(FCY, FCX).attrib = FREECELL% AND CF = 0 THEN
REM -------------------------------------------------------------------------
	KRNOLMAP(FCY, FCX).attrib = COMPFIG%
	SHOWSPRITE FCX, FCY, COMPFIG%
	COMPMOVE = 0
	FREECS = FREECS - 1
REM -------------------------------------------------------------------------
END IF
REM -------------------------------------------------------------------------
IF CF = 3 THEN
REM -------------------------------------------------------------------------
	CALL PRKEY
	LOSER PLAYERFIG%
	EG = PLAYAGAIN%
	IF EG = NO% THEN GOTO CHKINTRO
	IF EG = YES% THEN GOTO NEWGAME
REM -------------------------------------------------------------------------
END IF
REM -------------------------------------------------------------------------
IF PF = 3 THEN
REM -------------------------------------------------------------------------
	CALL PRKEY
	LOSER COMPFIG%
	EG = PLAYAGAIN%
	IF EG = NO% THEN GOTO CHKINTRO
	IF EG = YES% THEN GOTO NEWGAME
REM -------------------------------------------------------------------------
END IF
REM -------------------------------------------------------------------------
CF = 0: PF = 0: FC = 0
REM -------------------------------------------------------------------------
NEXT X
REM -------------------------------------------------------------------------
IF PF < 1 AND COMPMOVE = 1 AND KRNOLMAP(FCY, FCX).attrib = FREECELL% AND CF = 0 THEN
REM -------------------------------------------------------------------------
	KRNOLMAP(FCY, FCX).attrib = COMPFIG%
	SHOWSPRITE FCX, FCY, COMPFIG%
	COMPMOVE = 0
	FREECS = FREECS - 1
REM -------------------------------------------------------------------------
END IF
REM -------------------------------------------------------------------------
GOTO GAMESTART
REM -------------------------------------------------------------------------

FUNCTION CHKCFG%
REM -------------------------------------------------------------------------
FF = FREEFILE
REM -------------------------------------------------------------------------
OPEN "B", FF, CFGFILE$
REM -------------------------------------------------------------------------
SEEK FF, 0 + SK: GET FF, , CFG.initCFG
SEEK FF, 6 + SK: GET FF, , CFG.gameTC
SEEK FF, 8 + SK: GET FF, , CFG.path
SEEK FF, 72 + SK: GET FF, , CFG.user
SEEK FF, 328 + SK: GET FF, , CFG.sernum
SEEK FF, 330 + SK: GET FF, , CFG.video
SEEK FF, 332 + SK: GET FF, , CFG.sound
SEEK FF, 334 + SK: GET FF, , CFG.music
SEEK FF, 336 + SK: GET FF, , CFG.speed
REM -------------------------------------------------------------------------
CLOSE FF
REM -------------------------------------------------------------------------
PRINT "initCFG : "; CFG.initCFG
PRINT "gameTC  :"; CFG.gameTC
PRINT "path    : "; RTRIM$(SHTSTR$(CFG.path, 255))
PRINT "user    : "; RTRIM$(SHTSTR$(CFG.user, 255))
PRINT "sernum  :"; CFG.sernum
PRINT "video   : "; video(CFG.video).card
PRINT "sound   : "; music(CFG.sound).card
PRINT "music   : "; music(CFG.music).card
PRINT "speed   : "; CFG.speed
REM -------------------------------------------------------------------------
CHKCFG = 1
REM -------------------------------------------------------------------------
END FUNCTION

SUB CREATWORKSCR (PAR%, NPTH$)
REM -------------------------------------------------------------------------
SCREEN 13
CLS : SCROFF 1
PALLOAD NPTH$ + GRAPHSDIR$ + "LOGO04"
VGALOAD NPTH$ + GRAPHSDIR$ + "LOGO04"
SCROFF 0
REM -------------------------------------------------------------------------
END SUB

FUNCTION DEINT% (HEXDT0%, HEXDT1%)
HEXDT0$ = HEX$(HEXDT0%)
HEXDT1$ = HEX$(HEXDT1%)
IF HEXDT0% < 16 THEN HEXDT0$ = "0" + HEXDT0$
IF HEXDT1% < 16 THEN HEXDT1$ = "0" + HEXDT1$
HEXDAT$ = HEXDT0$ + HEXDT1$
DEINT% = VAL("&H" + HEXDAT$)
END FUNCTION

SUB EXITGAME
REM -------------------------------------------------------------------------
SCREEN 13
CLS : SCROFF 1
PALLOAD NPTH$ + GRAPHSDIR$ + "INTRO04"
VGALOAD NPTH$ + GRAPHSDIR$ + "INTRO04"
SCROFF 0: SLEEP 2
REM -------------------------------------------------------------------------
SCREEN 0: WIDTH 80
PRINT "Thanks for playing KRestiki-NOLiki ver. 2.0"
REM -------------------------------------------------------------------------
END
REM -------------------------------------------------------------------------
END SUB

FUNCTION GETCOMPFIG%
REM --------------------------------------------------------------------------
SCREEN 13
CLS : SCROFF 1
PALLOAD NPTH$ + GRAPHSDIR$ + "LOGO00"
VGALOAD NPTH$ + GRAPHSDIR$ + "LOGO00"
SCROFF 0
REM -------------------------------------------------------------------------
DFE% = GETLR%
REM -------------------------------------------------------------------------
IF DFE% = KREST% THEN
	TEMP% = 1
	CLS : SCROFF 1
	PALLOAD NPTH$ + GRAPHSDIR$ + "LOGO01"
	VGALOAD NPTH$ + GRAPHSDIR$ + "LOGO01"
	SCROFF 0: CALL PRKEY
END IF
REM -------------------------------------------------------------------------
IF DFE% = NOLIK% THEN
	TEMP% = 2
	CLS : SCROFF 1
	PALLOAD NPTH$ + GRAPHSDIR$ + "LOGO02"
	VGALOAD NPTH$ + GRAPHSDIR$ + "LOGO02"
	SCROFF 0: CALL PRKEY
END IF
REM -------------------------------------------------------------------------
GETCOMPFIG% = TEMP%
REM --------------------------------------------------------------------------
END FUNCTION

FUNCTION GETCOMPMOVE%
REM -------------------------------------------------------------------------
SCREEN 13
CLS : SCROFF 1
PALLOAD NPTH$ + GRAPHSDIR$ + "LOGO03"
VGALOAD NPTH$ + GRAPHSDIR$ + "LOGO03"
SCROFF 0
REM -------------------------------------------------------------------------
CDE% = GETLR%
REM -------------------------------------------------------------------------
IF CDE% = PLAYER% THEN TEMP% = 0
IF CDE% = COMPUTER% THEN TEMP% = 1
REM -------------------------------------------------------------------------
GETCOMPMOVE% = TEMP%
REM -------------------------------------------------------------------------
END FUNCTION

FUNCTION GETLR%
REM -------------------------------------------------------------------------
DIM CURSORL(519) AS INTEGER, CURSORR(519) AS INTEGER
REM -------------------------------------------------------------------------
GET (POINTL%, POINTT%)-(POINTL% + 32, POINTT% + 16), CURSORL
GET (POINTR%, POINTT%)-(POINTR% + 32, POINTT% + 16), CURSORR
REM -------------------------------------------------------------------------
SHOWSPRITE POINTL%, POINTT%, 5
REM -------------------------------------------------------------------------
POSIT% = LEFT%
REM -------------------------------------------------------------------------
LABTMP01:
REM -------------------------------------------------------------------------
A$ = INKEY$
IF A$ = "" THEN GOTO LABTMP01
REM -------------------------------------------------------------------------
IF MID$(A$, 2, 1) = CHR$(75) THEN
REM -------------------------------------------------------------------------
	IF POSIT% = RIGHT% THEN
		POSIT% = LEFT%
		'PUT (POINTR% + 32, POINTT%), CURSORR, PSET
		PUT (POINTR%, POINTT%), CURSORR, PSET
		SHOWSPRITE POINTL%, POINTT%, 5
	END IF
REM -------------------------------------------------------------------------
ELSEIF MID$(A$, 2, 1) = CHR$(77) THEN
REM -------------------------------------------------------------------------
	IF POSIT% = LEFT% THEN
		POSIT% = RIGHT%
		PUT (POINTL%, POINTT%), CURSORL, PSET
		SHOWSPRITE POINTR% - 32, POINTT%, 6
	END IF
REM -------------------------------------------------------------------------
ELSEIF A$ = CHR$(13) THEN
REM -------------------------------------------------------------------------
	       GETLR% = POSIT%
	       EXIT FUNCTION
REM -------------------------------------------------------------------------
ELSEIF A$ = CHR$(27) THEN
REM -------------------------------------------------------------------------
		EXITGAME
REM -------------------------------------------------------------------------
END IF
REM -------------------------------------------------------------------------
GOTO LABTMP01
REM -------------------------------------------------------------------------
GETLR% = POSIT%
REM -------------------------------------------------------------------------
END FUNCTION

SUB GETPLAYERMOVE
REM -------------------------------------------------------------------------
SHARED PLX%, PLY%, CRX%, CRY%, OCX%, OCY%, PLAYERFIG%, FREECELL%
REM -------------------------------------------------------------------------
LABTMP00:
REM -------------------------------------------------------------------------
A$ = INKEY$
IF A$ = "" THEN GOTO LABTMP00:
REM -------------------------------------------------------------------------
IF A$ = CHR$(13) AND KRNOLMAP(CRY%, CRX%).attrib = FREECELL% THEN
	KRNOLMAP(CRY%, CRX%).attrib = PLAYERFIG%
	SHOWSPRITE CRX%, CRY%, PLAYERFIG%
	EXIT SUB
ELSEIF A$ = CHR$(27) THEN
	EXITGAME
END IF
REM -------------------------------------------------------------------------
IF MID$(A$, 2, 1) = CHR$(75) THEN
REM -------------------------------------------------------------------------
	OCX% = CRX%: OCY% = CRY%
	SHOWSPRITE OCX%, OCY%, 4
	CRX% = CRX% - 1
	IF CRX% < 1 THEN CRX% = 1
	SHOWSPRITE CRX%, CRY%, 3
REM -------------------------------------------------------------------------
ELSEIF MID$(A$, 2, 1) = CHR$(77) THEN
REM -------------------------------------------------------------------------
	OCX% = CRX%: OCY% = CRY%
	SHOWSPRITE OCX%, OCY%, 4
	CRX% = CRX% + 1
	IF CRX% > 3 THEN CRX% = 3
	SHOWSPRITE CRX%, CRY%, 3
REM -------------------------------------------------------------------------
ELSEIF MID$(A$, 2, 1) = CHR$(72) THEN
REM -------------------------------------------------------------------------
	OCX% = CRX%: OCY% = CRY%
	SHOWSPRITE OCX%, OCY%, 4
	CRY% = CRY% - 1
	IF CRY% < 1 THEN CRY% = 1
	SHOWSPRITE CRX%, CRY%, 3
REM -------------------------------------------------------------------------
ELSEIF MID$(A$, 2, 1) = CHR$(80) THEN
REM -------------------------------------------------------------------------
	OCX% = CRX%: OCY% = CRY%
	SHOWSPRITE OCX%, OCY%, 4
	CRY% = CRY% + 1
	IF CRY% > 3 THEN CRY% = 3
	SHOWSPRITE CRX%, CRY%, 3
REM -------------------------------------------------------------------------
END IF
REM -------------------------------------------------------------------------
GOTO LABTMP00:
REM -------------------------------------------------------------------------
END SUB

FUNCTION GETUD%
REM -------------------------------------------------------------------------
DIM CURSOR0(519) AS INTEGER
DIM CURSOR1(519) AS INTEGER
DIM CURSOR2(519) AS INTEGER
REM -------------------------------------------------------------------------
GET (INTROX0%, INTROY0%)-(INTROX0% + 32, INTROY0% + 16), CURSOR0
GET (INTROX1%, INTROY1%)-(INTROX1% + 32, INTROY1% + 16), CURSOR1
GET (INTROX2%, INTROY2%)-(INTROX2% + 32, INTROY2% + 16), CURSOR2
REM -------------------------------------------------------------------------
CURX% = INTROX0%: CURY% = INTROY0%: PAR% = 0
OLDX% = INTROX1%: OLDY% = INTROY1%
REM -------------------------------------------------------------------------
SHOWPOINT CURX%, CURY%
REM -------------------------------------------------------------------------
LABTMP02:
REM -------------------------------------------------------------------------
A$ = INKEY$
IF A$ = "" THEN GOTO LABTMP02
REM -------------------------------------------------------------------------
IF MID$(A$, 2, 1) = CHR$(72) THEN
REM -------------------------------------------------------------------------
IF PAR% = 1 THEN
	PUT (INTROX1%, INTROY1%), CURSOR1, PSET
	SHOWPOINT INTROX0%, INTROY0%: PAR% = 0
ELSEIF PAR% = 2 THEN
	PUT (INTROX2%, INTROY2%), CURSOR2, PSET
	SHOWPOINT INTROX1%, INTROY1%: PAR% = 1
END IF
REM -------------------------------------------------------------------------
ELSEIF MID$(A$, 2, 1) = CHR$(80) THEN
REM -------------------------------------------------------------------------
IF PAR% = 0 THEN
	PUT (INTROX0%, INTROY0%), CURSOR0, PSET
	SHOWPOINT INTROX1%, INTROY1%: PAR% = 1
ELSEIF PAR% = 1 THEN
	PUT (INTROX1%, INTROY1%), CURSOR1, PSET
	SHOWPOINT INTROX2%, INTROY2%: PAR% = 2
END IF
REM -------------------------------------------------------------------------
ELSEIF A$ = CHR$(13) THEN
REM -------------------------------------------------------------------------
	       GETUD% = PAR%
	       EXIT FUNCTION
REM -------------------------------------------------------------------------
ELSEIF A$ = CHR$(27) THEN
REM -------------------------------------------------------------------------
		EXITGAME
REM -------------------------------------------------------------------------
END IF
REM -------------------------------------------------------------------------
GOTO LABTMP02
REM -------------------------------------------------------------------------
GETUD% = PAR%
REM -------------------------------------------------------------------------
END FUNCTION

SUB HALLOFFAME
REM -------------------------------------------------------------------------
SCREEN 13
CLS : SCROFF 1
REM -------------------------------------------------------------------------
FF = FREEFILE
REM -------------------------------------------------------------------------
OPEN "B", FF, HOFFILE$
REM -------------------------------------------------------------------------
SEEK FF, 8 + SK: GET FF, , HOF.res0
SEEK FF, 10 + SK: GET FF, , HOF.res1
SEEK FF, 12 + SK: GET FF, , HOF.res2
SEEK FF, 14 + SK: GET FF, , HOF.res3
SEEK FF, 16 + SK: GET FF, , HOF.res4
SEEK FF, 18 + SK: GET FF, , HOF.res5
SEEK FF, 20 + SK: GET FF, , HOF.res6
SEEK FF, 22 + SK: GET FF, , HOF.res7
SEEK FF, 24 + SK: GET FF, , HOF.res8
SEEK FF, 26 + SK: GET FF, , HOF.res9
REM -------------------------------------------------------------------------
SEEK FF, 92 + SK: GET FF, , HOF.name0
SEEK FF, 156 + SK: GET FF, , HOF.name1
SEEK FF, 220 + SK: GET FF, , HOF.name2
SEEK FF, 284 + SK: GET FF, , HOF.name3
SEEK FF, 348 + SK: GET FF, , HOF.name4
SEEK FF, 412 + SK: GET FF, , HOF.name5
SEEK FF, 476 + SK: GET FF, , HOF.name6
SEEK FF, 540 + SK: GET FF, , HOF.name7
SEEK FF, 604 + SK: GET FF, , HOF.name8
SEEK FF, 668 + SK: GET FF, , HOF.name9
REM -------------------------------------------------------------------------
PALLOAD NPTH$ + GRAPHSDIR$ + "LOGO08"
VGALOAD NPTH$ + GRAPHSDIR$ + "LOGO08"
SCROFF 0: COLOR WHT%
REM -------------------------------------------------------------------------
LOCATE 8, 3: PRINT "1."; RTRIM$(SHTSTR$(HOF.name0, 255)); "        "; res0
LOCATE 10, 3: PRINT "2."; RTRIM$(SHTSTR$(HOF.name0, 255)); "        "; res1
LOCATE 12, 3: PRINT "3."; RTRIM$(SHTSTR$(HOF.name0, 255)); "        "; res2
LOCATE 14, 3: PRINT "4."; RTRIM$(SHTSTR$(HOF.name0, 255)); "        "; res3
LOCATE 16, 3: PRINT "5."; RTRIM$(SHTSTR$(HOF.name0, 255)); "        "; res4
LOCATE 18, 3: PRINT "6."; RTRIM$(SHTSTR$(HOF.name0, 255)); "        "; res5
LOCATE 20, 3: PRINT "7."; RTRIM$(SHTSTR$(HOF.name0, 255)); "        "; res6
LOCATE 22, 3: PRINT "8."; RTRIM$(SHTSTR$(HOF.name0, 255)); "        "; res7
REM -------------------------------------------------------------------------
CALL PRKEY
REM -------------------------------------------------------------------------
END SUB

SUB LOSER (FIG%)
REM -------------------------------------------------------------------------
IF FIG% < 1 OR FIG% > 2 THEN FIG% = 1
REM -------------------------------------------------------------------------
SCREEN 13
CLS : SCROFF 1
REM -------------------------------------------------------------------------
IF FIG% = 1 THEN PIC$ = "5"
IF FIG% = 2 THEN PIC$ = "6"
REM -------------------------------------------------------------------------
PALLOAD NPTH$ + GRAPHSDIR$ + "LOGO0" + PIC$
VGALOAD NPTH$ + GRAPHSDIR$ + "LOGO0" + PIC$
SCROFF 0
REM -------------------------------------------------------------------------
CALL PRKEY:
REM -------------------------------------------------------------------------
END SUB

SUB PALLOAD (FLNM$)
REM --------------------------------------------------------------------------
REM PALette LOADer ver. 3.0
REM Quick Shot Assembly ver. 1.0
REM Загрузка палитры PAL96C
REM --------------------------------------------------------------------------
FLNM$ = FLNM$ + ".PAL": P = 1
FF = FREEFILE: OPEN "B", FF, FLNM$
REM --------------------------------------------------------------------------
SEEK FF, SK + 0: GET FF, , PAL.initPAL
SEEK FF, SK + 6: GET FF, , PAL.name
SEEK FF, SK + 17: GET FF, , PAL.caption
SEEK FF, SK + 273: GET FF, , PAL.exCOL
SEEK FF, SK + 275: GET FF, , PAL.stCOL
SEEK FF, SK + 277: GET FF, , PAL.ptype
REM --------------------------------------------------------------------------
DATAS$ = SPACE$(PAL.exCOL * 3)
REM --------------------------------------------------------------------------
SEEK FF, SK + 279: GET FF, , DATAS$
REM --------------------------------------------------------------------------
CLOSE FF
REM --------------------------------------------------------------------------
FOR TMPCOL% = PAL.stCOL TO PAL.exCOL - 1
REM --------------------------------------------------------------------------
R$ = MID$(DATAS$, 0 + P, 1)
G$ = MID$(DATAS$, 1 + P, 1)
B$ = MID$(DATAS$, 2 + P, 1)
P = P + 3
REM --------------------------------------------------------------------------
PALS(TMPCOL% + 1).color = R$ + G$ + B$
REM --------------------------------------------------------------------------
NEXT TMPCOL%
REM --------------------------------------------------------------------------
SETPAL VARSEG(PALS(1).color), VARPTR(PALS(1).color)
REM --------------------------------------------------------------------------
END SUB

FUNCTION PLAYAGAIN%
REM -------------------------------------------------------------------------
SCREEN 13
CLS : SCROFF 1
PALLOAD NPTH$ + GRAPHSDIR$ + "LOGO07"
VGALOAD NPTH$ + GRAPHSDIR$ + "LOGO07"
SCROFF 0
REM -------------------------------------------------------------------------
CDF% = GETLR%
REM -------------------------------------------------------------------------
IF CDF% = LEFT% THEN TEMP% = YES%
IF CDF% = RIGHT% THEN TEMP% = NO%
REM -------------------------------------------------------------------------
PLAYAGAIN% = TEMP%
REM -------------------------------------------------------------------------
END FUNCTION

SUB PRKEY
REM -------------------------------------------------------------------------
WHILE A$ = ""
A$ = INKEY$
WEND
REM -------------------------------------------------------------------------
END SUB

SUB SCROFF (PAR%)
IF PAR% < 0 OR PAR% > 1 THEN PAR% = 0
DIM regs AS RegType
IF PAR% = 0 THEN regs.ax = &H1200 + &H0
IF PAR% = 1 THEN regs.ax = &H1200 + &H1
regs.bx = &H36
Interrupt &H10, regs, regs
END SUB

SUB SETPAL (SEGM%, OFFS%)
REM -------------------------------------------------------------------------
REM Установка всей палитры
REM -------------------------------------------------------------------------
DIM regx AS RegTypeX
regx.ax = &H1012
regx.bx = &H0
regx.cx = 256
regx.es = SEGM%
regx.dx = OFFS%
InterruptX &H10, regx, regx
REM -------------------------------------------------------------------------
END SUB

FUNCTION SHOWINTRO%
REM -------------------------------------------------------------------------
SHARED NPTH$
REM -------------------------------------------------------------------------
SCREEN 13: CLS : SCROFF 1
REM -------------------------------------------------------------------------
FOR I = 0 TO 2
REM -------------------------------------------------------------------------
PIC$ = LTRIM$(STR$(I))
PALLOAD NPTH$ + GRAPHSDIR$ + "INTRO0" + PIC$
VGALOAD NPTH$ + GRAPHSDIR$ + "INTRO0" + PIC$
SCROFF 0: SLEEP 2: SCROFF 1
REM -------------------------------------------------------------------------
NEXT I
REM -------------------------------------------------------------------------
PALLOAD NPTH$ + GRAPHSDIR$ + "INTRO03"
VGALOAD NPTH$ + GRAPHSDIR$ + "INTRO03": SCROFF 0
REM -------------------------------------------------------------------------
TEMP% = GETUD% + 1
REM -------------------------------------------------------------------------
SHOWINTRO% = TEMP%
REM -------------------------------------------------------------------------
END FUNCTION

SUB SHOWPOINT (X%, Y%)
REM -------------------------------------------------------------------------
	LINE (X% + 12, Y% + 6)-(X% + 29, Y% + 9), WHT%, BF
	LINE (X% + 12, Y% + 6)-(X% + 29, Y% + 6), BLK%
	LINE (X% + 12, Y% + 9)-(X% + 29, Y% + 9), BLK%
	LINE (X% + 30, Y% + 7)-(X% + 30, Y% + 8), BLK%
	LINE (X% + 5, Y% + 6)-(X% + 11, Y% + 9), WHT%, BF
	LINE (X% + 11, Y% + 0)-(X% + 11, Y% + 5), BLK%
	LINE (X% + 11, Y% + 10)-(X% + 11, Y% + 15), BLK%
	LINE (X% + 8, Y% + 3)-(X% + 10, Y% + 5), WHT%, BF
	LINE (X% + 8, Y% + 9)-(X% + 10, Y% + 12), WHT%, BF
	LINE (X% + 11, Y% + 0)-(X% + 4, Y% + 7), BLK%
	LINE (X% + 11, Y% + 15)-(X% + 4, Y% + 8), BLK%
	PSET (X% + 10, Y% + 2), WHT%: PSET (X% + 10, Y% + 13), WHT%
	PSET (X% + 7, Y% + 5), WHT%: PSET (X% + 7, Y% + 10), WHT%
REM -------------------------------------------------------------------------
END SUB

SUB SHOWSPRITE (XCOR%, YCOR%, FIG%)
REM -------------------------------------------------------------------------
IF FIG% = 1 THEN
REM -------------------------------------------------------------------------
	LINE (GRP(XCOR%, YCOR%).figureX + 1, GRP(XCOR%, YCOR%).figureY + 3)-(GRP(XCOR%, YCOR%).figureX + 12, GRP(XCOR%, YCOR%).figureY + 14), COL0%
	LINE (GRP(XCOR%, YCOR%).figureX + 3, GRP(XCOR%, YCOR%).figureY + 14)-(GRP(XCOR%, YCOR%).figureX + 14, GRP(XCOR%, YCOR%).figureY + 3), COL0%
	LINE (GRP(XCOR%, YCOR%).figureX + 1, GRP(XCOR%, YCOR%).figureY + 12)-(GRP(XCOR%, YCOR%).figureX + 12, GRP(XCOR%, YCOR%).figureY + 1), COL2%
	LINE (GRP(XCOR%, YCOR%).figureX + 3, GRP(XCOR%, YCOR%).figureY + 1)-(GRP(XCOR%, YCOR%).figureX + 14, GRP(XCOR%, YCOR%).figureY + 12), COL2%
	LINE (GRP(XCOR%, YCOR%).figureX + 2, GRP(XCOR%, YCOR%).figureY + 13)-(GRP(XCOR%, YCOR%).figureX + 13, GRP(XCOR%, YCOR%).figureY + 2), COL1%
	LINE (GRP(XCOR%, YCOR%).figureX + 2, GRP(XCOR%, YCOR%).figureY + 2)-(GRP(XCOR%, YCOR%).figureX + 13, GRP(XCOR%, YCOR%).figureY + 13), COL1%
	LINE (GRP(XCOR%, YCOR%).figureX + 2, GRP(XCOR%, YCOR%).figureY + 12)-(GRP(XCOR%, YCOR%).figureX + 12, GRP(XCOR%, YCOR%).figureY + 2), COL1%
	LINE (GRP(XCOR%, YCOR%).figureX + 3, GRP(XCOR%, YCOR%).figureY + 13)-(GRP(XCOR%, YCOR%).figureX + 13, GRP(XCOR%, YCOR%).figureY + 3), COL1%
	LINE (GRP(XCOR%, YCOR%).figureX + 3, GRP(XCOR%, YCOR%).figureY + 2)-(GRP(XCOR%, YCOR%).figureX + 13, GRP(XCOR%, YCOR%).figureY + 12), COL1%
	LINE (GRP(XCOR%, YCOR%).figureX + 2, GRP(XCOR%, YCOR%).figureY + 3)-(GRP(XCOR%, YCOR%).figureX + 12, GRP(XCOR%, YCOR%).figureY + 13), COL1%
REM -------------------------------------------------------------------------
ELSEIF FIG% = 2 THEN
REM -------------------------------------------------------------------------
	LINE (GRP(XCOR%, YCOR%).figureX + 2, GRP(XCOR%, YCOR%).figureY + 2)-(GRP(XCOR%, YCOR%).figureX + 13, GRP(XCOR%, YCOR%).figureY + 13), COL1%, BF
	LINE (GRP(XCOR%, YCOR%).figureX + 6, GRP(XCOR%, YCOR%).figureY + 6)-(GRP(XCOR%, YCOR%).figureX + 9, GRP(XCOR%, YCOR%).figureY + 9), COL3%, BF
	LINE (GRP(XCOR%, YCOR%).figureX + 3, GRP(XCOR%, YCOR%).figureY + 1)-(GRP(XCOR%, YCOR%).figureX + 12, GRP(XCOR%, YCOR%).figureY + 1), COL2%
	LINE (GRP(XCOR%, YCOR%).figureX + 1, GRP(XCOR%, YCOR%).figureY + 3)-(GRP(XCOR%, YCOR%).figureX + 1, GRP(XCOR%, YCOR%).figureY + 12), COL2%
	LINE (GRP(XCOR%, YCOR%).figureX + 3, GRP(XCOR%, YCOR%).figureY + 14)-(GRP(XCOR%, YCOR%).figureX + 12, GRP(XCOR%, YCOR%).figureY + 14), COL0%
	LINE (GRP(XCOR%, YCOR%).figureX + 14, GRP(XCOR%, YCOR%).figureY + 3)-(GRP(XCOR%, YCOR%).figureX + 14, GRP(XCOR%, YCOR%).figureY + 12), COL0%
	LINE (GRP(XCOR%, YCOR%).figureX + 6, GRP(XCOR%, YCOR%).figureY + 5)-(GRP(XCOR%, YCOR%).figureX + 9, GRP(XCOR%, YCOR%).figureY + 5), COL0%
	LINE (GRP(XCOR%, YCOR%).figureX + 5, GRP(XCOR%, YCOR%).figureY + 6)-(GRP(XCOR%, YCOR%).figureX + 5, GRP(XCOR%, YCOR%).figureY + 9), COL0%
	LINE (GRP(XCOR%, YCOR%).figureX + 10, GRP(XCOR%, YCOR%).figureY + 6)-(GRP(XCOR%, YCOR%).figureX + 10, GRP(XCOR%, YCOR%).figureY + 9), COL2%
	LINE (GRP(XCOR%, YCOR%).figureX + 6, GRP(XCOR%, YCOR%).figureY + 10)-(GRP(XCOR%, YCOR%).figureX + 9, GRP(XCOR%, YCOR%).figureY + 10), COL2%
	PSET (GRP(XCOR%, YCOR%).figureX + 2, GRP(XCOR%, YCOR%).figureY + 2), COL2%: PSET (GRP(XCOR%, YCOR%).figureX + 13, GRP(XCOR%, YCOR%).figureY + 2), COL2%
	PSET (GRP(XCOR%, YCOR%).figureX + 2, GRP(XCOR%, YCOR%).figureY + 13), COL2%: PSET (GRP(XCOR%, YCOR%).figureX + 13, GRP(XCOR%, YCOR%).figureY + 13), COL0%
REM -------------------------------------------------------------------------
ELSEIF FIG% = 3 THEN
REM -------------------------------------------------------------------------
	LINE (GRP(XCOR%, YCOR%).cursorX + 2, GRP(XCOR%, YCOR%).cursorY + 0)-(GRP(XCOR%, YCOR%).cursorX + 13, GRP(XCOR%, YCOR%).cursorY + 0), COL2%
	LINE (GRP(XCOR%, YCOR%).cursorX + 1, GRP(XCOR%, YCOR%).cursorY + 1)-(GRP(XCOR%, YCOR%).cursorX + 14, GRP(XCOR%, YCOR%).cursorY + 1), COL1%
	LINE (GRP(XCOR%, YCOR%).cursorX + 2, GRP(XCOR%, YCOR%).cursorY + 2)-(GRP(XCOR%, YCOR%).cursorX + 13, GRP(XCOR%, YCOR%).cursorY + 2), COL0%
REM -------------------------------------------------------------------------
ELSEIF FIG% = 4 THEN
REM -------------------------------------------------------------------------
	LINE (GRP(XCOR%, YCOR%).cursorX + 0, GRP(XCOR%, YCOR%).cursorY + 0)-(GRP(XCOR%, YCOR%).cursorX + 15, GRP(XCOR%, YCOR%).cursorY + 4), COL3%, BF
REM -------------------------------------------------------------------------
ELSEIF FIG% = 5 THEN
REM -------------------------------------------------------------------------
	LINE (POINTL% + 12, POINTT% + 6)-(POINTL% + 29, POINTT% + 9), WHT%, BF
	LINE (POINTL% + 12, POINTT% + 6)-(POINTL% + 29, POINTT% + 6), BLK%
	LINE (POINTL% + 12, POINTT% + 9)-(POINTL% + 29, POINTT% + 9), BLK%
	LINE (POINTL% + 30, POINTT% + 7)-(POINTL% + 30, POINTT% + 8), BLK%
	LINE (POINTL% + 5, POINTT% + 6)-(POINTL% + 11, POINTT% + 9), WHT%, BF
	LINE (POINTL% + 11, POINTT% + 0)-(POINTL% + 11, POINTT% + 5), BLK%
	LINE (POINTL% + 11, POINTT% + 10)-(POINTL% + 11, POINTT% + 15), BLK%
	LINE (POINTL% + 8, POINTT% + 3)-(POINTL% + 10, POINTT% + 5), WHT%, BF
	LINE (POINTL% + 8, POINTT% + 9)-(POINTL% + 10, POINTT% + 12), WHT%, BF
	LINE (POINTL% + 11, POINTT% + 0)-(POINTL% + 4, POINTT% + 7), BLK%
	LINE (POINTL% + 11, POINTT% + 15)-(POINTL% + 4, POINTT% + 8), BLK%
	PSET (POINTL% + 10, POINTT% + 2), WHT%: PSET (POINTL% + 10, POINTT% + 13), WHT%
	PSET (POINTL% + 7, POINTT% + 5), WHT%: PSET (POINTL% + 7, POINTT% + 10), WHT%
REM -------------------------------------------------------------------------
ELSEIF FIG% = 6 THEN
REM -------------------------------------------------------------------------
	LINE (POINTR% + 32 - 12, POINTT% + 6)-(POINTR% + 32 - 29, POINTT% + 9), WHT%, BF
	LINE (POINTR% + 32 - 12, POINTT% + 6)-(POINTR% + 32 - 29, POINTT% + 6), BLK%
	LINE (POINTR% + 32 - 12, POINTT% + 9)-(POINTR% + 32 - 29, POINTT% + 9), BLK%
	LINE (POINTR% + 32 - 30, POINTT% + 7)-(POINTR% + 32 - 30, POINTT% + 8), BLK%
	LINE (POINTR% + 32 - 5, POINTT% + 6)-(POINTR% + 32 - 11, POINTT% + 9), WHT%, BF
	LINE (POINTR% + 32 - 11, POINTT% + 0)-(POINTR% + 32 - 11, POINTT% + 5), BLK%
	LINE (POINTR% + 32 - 11, POINTT% + 10)-(POINTR% + 32 - 11, POINTT% + 15), BLK%
	LINE (POINTR% + 32 - 8, POINTT% + 3)-(POINTR% + 32 - 10, POINTT% + 5), WHT%, BF
	LINE (POINTR% + 32 - 8, POINTT% + 9)-(POINTR% + 32 - 10, POINTT% + 12), WHT%, BF
	LINE (POINTR% + 32 - 11, POINTT% + 0)-(POINTR% + 32 - 4, POINTT% + 7), BLK%
	LINE (POINTR% + 32 - 11, POINTT% + 15)-(POINTR% + 32 - 4, POINTT% + 8), BLK%
	PSET (POINTR% + 32 - 10, POINTT% + 2), WHT%: PSET (POINTR% + 32 - 10, POINTT% + 13), WHT%
	PSET (POINTR% + 32 - 7, POINTT% + 5), WHT%: PSET (POINTR% + 32 - 7, POINTT% + 10), WHT%
REM -------------------------------------------------------------------------
END IF
REM -------------------------------------------------------------------------
END SUB

FUNCTION SHTSTR$ (SSTR$, PAR%)
REM -------------------------------------------------------------------------
IF PAR% > 255 THEN PAR% = 255
IF PAR% < 0 THEN PAR% = 0
REM -------------------------------------------------------------------------
FOR I = 1 TO LEN(SSTR$)
B$ = MID$(SSTR$, I, 1)
C = ASC(B$)
D = PAR% - C
IF D < 0 THEN D = 255 + D
D$ = CHR$(D)
TEMP$ = TEMP$ + D$
NEXT I
REM -------------------------------------------------------------------------
SHTSTR$ = TEMP$
REM -------------------------------------------------------------------------
END FUNCTION

SUB VGALOAD (VLOD$)
REM --------------------------------------------------------------------------
FLNM$ = UCASE$(VLOD$) + ".VGA"
REM --------------------------------------------------------------------------
'IF FLNM$ <> DIR$(FLNM$) THEN EXIT SUB
REM --------------------------------------------------------------------------
DEF SEG = &HA000: BLOAD FLNM$, 0: DEF SEG
REM --------------------------------------------------------------------------
END SUB

