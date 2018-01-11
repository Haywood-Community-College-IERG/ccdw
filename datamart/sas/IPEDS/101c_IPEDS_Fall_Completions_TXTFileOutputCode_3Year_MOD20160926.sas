/* 101c */
*************************************************************************************
* CREATED BY:   Paul G. Earls                                                       *
* DATE CREATED: 08-12-2015                                                          *
*      CREDITS: Additional credit to Robert June and Alexandra Riley with           *
*               Marquette University - AIR 2015 Posterboard "EVOLUTION FROM EXCEL   *
*               PIVOT TABLES TO UPLOADING SAS-GENERATED FILES FOR IPEDS"            *
* DATE CREATED: 08-12-2015                                                          *
* MODIFIED1:        																*
* MODIFEID2:																		*
* REQUESTOR:    Planning and Research                                               *
* PURPOSE:      IPEDS Fall Data Collection - Completions For Any Year               *
*               Outputs a Fixed Length .txt File to be Uploaded to IPEDS            *
*                                                                                   *
* INSTRUCTIONS:                                                                     *
*          1 - FIRST DOWNLOAD AND CREATE PAST YEAR GRADUATE RO DATASETS             *
*          2 - Place copy of prior year's Approved Programs of Study list           *
*              in Completions folder, remove titles and blank rows, create          *
*              column and populate for Vitual program indicator then save as csv    *
*                                                                                   *
*          3 - Run program 101a.                                                    *
*              IF NO LIST OF MISSING DEMOGRAPHICS OCCURS THEN RUN PROGRAM 101b      *
*                                                                                   *
*              If list of Missing Demographics occurs - Run Through Informer        *
*              Then load into Colleague SLED - SaveList Edit Contents               *
*              Run Informer Report -                                                *
*               ST PER From Save List, List Student Demo Data for IPEDS Completions *
*              Save Informer output as                                              *
*               NoMatch02InformerDemoData.csv                                       *
*              Run Program 101c                                                     *
*************************************************************************************;
OPTIONS PS=500 LS=120 NONUMBER NOCENTER;

%LET PathRoot=H:\Planning and Research FTP\CPCCSASDatasets\A_XNC_Datatel; /* CHANGE TO YOU DATA MART LOCATION PATH */

LIBNAME Stud "&PathRoot\Downloads\SASDatasets\02_Student";
LIBNAME Grad "&PathRoot\Downloads\SASDatasets\03_Graduate";
LIBNAME CIPXWalk "&PathRoot\Downloads\SASDatasets\99_Crosswalks";

%LET Pth01=&PathRoot\SASPrograms\09_IPEDS\;
%LET Pth02=2017-2018\2017_03_Fall;			/* CHANGE FOR EACH REPORTING YEAR/SURVEY PERIOD */
%LET Pth03=\03_Completions\;

%LET csv01=Approved_Programs_of_Study_;
%LET csv02=20162017;						/* CHANGE FOR EACH REPORTING YEAR */
%LET csv03=_SAS_MERGE.csv;

%LET csv11=NoMatch02InformerDemoData.csv;

%LET lb21=CIPXWalk;
%LET ds21=ncccs_prog_cipcodes;
%LET rp21=_mod20150220;

%LET lb01=Grad;
%LET ds01=Grad_;
%LET rp01=_RO;

%LET lb02=Stud;
%LET ds02=ST_;
%LET rp02=_ET;

%LET yt08=201402;			/* update terms each year */
%LET yt09=201403;			/* update terms each year */
%LET yt10=201501;			/* update terms each year */
%LET yt11=201502;			/* update terms each year */
%LET yt12=201503;			/* update terms each year */
%LET yt13=201601;			/* update terms each year */
%LET yt14=201602;			/* update terms each year */
%LET yt15=201603;			/* update terms each year */
%LET yt16=201701;			/* update terms each year */
%LET CollYr=2016-2017;		/* update terms each year */
%LET CollFa=2016;			/* update terms each year */

%LET UNITID=198154;			/* CHANGE TO YOUR IPEDS UNIT ID */
%LET SURVSECT=COM;
%LET MAJORNUM=1;


/***********************************************/
/* NO FURTHER CHANGES NEEDED BEYOND THIS POINT */
/***********************************************/

%LET ar02b=01;
%LET ar02e=10;


*** BEGIN - IMPORT APPROVED LIST OF PROGRAMS FOR IPEDS Completions Survey REPORTING ***;

DATA WORK.ProgramList01a;
%LET _EFIERR_ = 0; /* set the ERROR detection macro variable */
    INFILE "&Pth01&Pth02&Pth03&csv01&csv02&csv03" DELIMITER = ',' MISSOVER DSD lrecl=32767 FIRSTOBS=2 ;
			INPUT
					PROGRAMTITLE	:$100.
					PROGCODE1		:$15.
					RequiredCredits :best32.
					DistanceED		:$1.
;
			FORMAT
					PROGRAMTITLE	$100.
					PROGCODE1		$15.
					RequiredCredits best32.
					DistanceED		:$1.
;
IF _ERROR_ THEN CALL symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
RUN;

DATA ProgramList01b;
FORMAT
		ProgCode $15.
		ProgCode2 $15.
		ProgCore $10.
;
SET ProgramList01a;
ProgCode=(SUBSTR(PROGCODE1,1,6));
ProgCode2=COMPRESS(PROGCODE1,'-');
ProgCore=(SUBSTR(PROGCODE1,2,4));
PROC SORT DATA=ProgramList01b; BY ProgCode;
RUN;

*** END - IMPORT APPROVED LIST OF PROGRAMS FOR IPEDS Completions Survey REPORTING ***;

*** BEGIN - BRING IN SAS CIP CODE CROSSWALK DATASET ***;

DATA CIPXWalk;
FORMAT
		ProgCode $15.
		ProgCore $10.
;
SET &lb21 .&ds21&rp21;
ProgCode=(SUBSTR(ADCStuCurPriProgCode,1,6));
ProgCore=(SUBSTR(ADCStuCurPriProgCode,2,4));
PROC SORT DATA=CIPXWalk; BY ProgCode;
RUN;

*** END - BRING IN SAS CIP CODE CROSSWALK DATASET ***;

*** BEGIN - MERGE CIP CROSSWALK DATASET TO APPROVED LIST OF PROGRAMS ***;

DATA CIPMerge01a;
	MERGE CIPXWalk (IN=a) ProgramList01b (IN=b);
	BY ProgCode;
	IF a*b=1;
RUN;

DATA CIPMerge01b;
	MERGE CIPXWalk (IN=a) ProgramList01b (IN=b);
	BY ProgCode;
	IF b AND NOT a;
DROP
	ADCStuCurPriProgCode
	Title
	PreviousCIPCode
	CurrentCIPCode
	Coordinator
;
PROC SORT DATA=CIPMerge01b; BY ProgCore;
RUN;

DATA CIPXWalk2;
SET CIPXWalk;
PROC SORT NODUPKEY DATA=CIPXWalk2; BY ProgCore;
RUN;

DATA CIPMerge01c;
	MERGE CIPXWalk2(IN=a) CIPMerge01b(IN=b);
	BY ProgCore;
	IF a*b=1;
RUN;

DATA CIPMerge01d;
	MERGE CIPXWalk2(IN=a) CIPMerge01b(IN=b);
	BY ProgCore;
	IF b AND NOT a;
RUN;

DATA CIPMerge01Final;
SET CIPMerge01a
	CIPMerge01c
	CIPMerge01d;
PROC SORT NODUPKEY DATA=CIPMerge01Final; BY ProgCode;
RUN;

DATA CIPMerge02FINAL;
FORMAT
		AWLEVEL 8.
		CTLEVEL 8.
		CRACE01 8.
		CRACE02 8.
		CRACE25 8.
		CRACE26 8.
		CRACE27 8.
		CRACE28 8.
		CRACE29 8.
		CRACE30 8.
		CRACE31 8.
		CRACE32 8.
		CRACE33 8.
		CRACE34 8.
		CRACE35 8.
		CRACE36 8.
		CRACE37 8.
		CRACE38 8.
		CRACE13 8.
		CRACE14 8.
;
SET CIPMerge01Final;
CRACE01=0;
CRACE02=0;
CRACE25=0;
CRACE26=0;
CRACE27=0;
CRACE28=0;
CRACE29=0;
CRACE30=0;
CRACE31=0;
CRACE32=0;
CRACE33=0;
CRACE34=0;
CRACE35=0;
CRACE36=0;
CRACE37=0;
CRACE38=0;
CRACE13=0;
CRACE14=0;
IF (SUBSTR(ProgCode,1,1)) EQ 'A' THEN AWLEVEL=3;
ELSE IF (SUBSTR(ProgCode,1,1)) EQ 'D' THEN AWLEVEL=2;
ELSE IF (SUBSTR(ProgCode,1,1)) EQ 'C' THEN AWLEVEL=1;
IF (SUBSTR(ProgCode,1,1)) EQ 'A' THEN CTLEVEL=3;
ELSE IF (SUBSTR(ProgCode,1,1)) EQ 'D' THEN CTLEVEL=2;
ELSE IF (SUBSTR(ProgCode,1,1)) EQ 'C' THEN CTLEVEL=1;
PROC SORT DATA=CIPMerge02Final; BY ProgCode;
RUN;

*** END - MERGE CIP CROSSWALK DATASET TO APPROVED LIST OF PROGRAMS ***;


/* GRADUATES DATA */
/* Summer, Fall, Spring */
DATA Grad01 (KEEP=
					ADCGradLastName
					ADCGradFirstName
					ADCGradMiddleName
					ADCGradTerm
					ADCGradAcadProgram
					ADCGradProgramCIP
					CIPCODE
					ADCPersonID
					GradProg
					GradCert
					CIPCode2010
);
SET &lb01 .&ds01&yt14&rp01(KEEP=
					ADCGradLastName
					ADCGradFirstName
					ADCGradMiddleName
					ADCGradTerm
					ADCGradAcadProgram
					ADCGradProgramCIP
					ADCPersonID
					GradProg
					GradCert
					CIPCode2010
)
	&lb01 .&ds01&yt15&rp01(KEEP=
					ADCGradLastName
					ADCGradFirstName
					ADCGradMiddleName
					ADCGradTerm
					ADCGradAcadProgram
					ADCGradProgramCIP
					ADCPersonID
					GradProg
					GradCert
					CIPCode2010
)
	&lb01 .&ds01&yt16&rp01(KEEP=
					ADCGradLastName
					ADCGradFirstName
					ADCGradMiddleName
					ADCGradTerm
					ADCGradAcadProgram
					ADCGradProgramCIP
					ADCPersonID
					GradProg
					GradCert
					CIPCode2010
);
CIPCODE=CIPCode2010;
IF ADCGradAcadProgram in ('AHS','GED') THEN DELETE;
PROC SORT DATA=Grad01; BY ADCPersonID;
RUN;


/* Completions Part A: CIP Data */
DATA Student01 (KEEP=
					InstTerm
					ADCPersonID
					ADCStuLastName
					ADCStuFirstName
					ADCStuCitizenship
					ADCStuGender
					ADCStuPrimaryEthnic
					ADCStuRaces01-ADCStuRaces10
					ADCStuVisaType
					BirthDate

);

SET
	&lb02 .&ds02&yt16&rp02 (KEEP=
					InstTerm
					ADCPersonID
					ADCStuLastName
					ADCStuFirstName
					ADCStuCitizenship
					ADCStuGender
					ADCStuPrimaryEthnic
					ADCStuRaces01-ADCStuRaces10
					ADCStuVisaType
					BirthDate
)
	&lb02 .&ds02&yt15&rp02 (KEEP=
					InstTerm
					ADCPersonID
					ADCStuLastName
					ADCStuFirstName
					ADCStuCitizenship
					ADCStuGender
					ADCStuPrimaryEthnic
					ADCStuRaces01-ADCStuRaces10
					ADCStuVisaType
					BirthDate
)
	&lb02 .&ds02&yt14&rp02 (KEEP=
					InstTerm
					ADCPersonID
					ADCStuLastName
					ADCStuFirstName
					ADCStuCitizenship
					ADCStuGender
					ADCStuPrimaryEthnic
					ADCStuRaces01-ADCStuRaces10
					ADCStuVisaType
					BirthDate
)
	&lb02 .&ds02&yt13&rp02 (KEEP=
					InstTerm
					ADCPersonID
					ADCStuLastName
					ADCStuFirstName
					ADCStuCitizenship
					ADCStuGender
					ADCStuPrimaryEthnic
					ADCStuRaces01-ADCStuRaces10
					ADCStuVisaType
					BirthDate
)
	&lb02 .&ds02&yt12&rp02 (KEEP=
					InstTerm
					ADCPersonID
					ADCStuLastName
					ADCStuFirstName
					ADCStuCitizenship
					ADCStuGender
					ADCStuPrimaryEthnic
					ADCStuRaces01-ADCStuRaces10
					ADCStuVisaType
					BirthDate
)
	&lb02 .&ds02&yt11&rp02 (KEEP=
					InstTerm
					ADCPersonID
					ADCStuLastName
					ADCStuFirstName
					ADCStuCitizenship
					ADCStuGender
					ADCStuPrimaryEthnic
					ADCStuRaces01-ADCStuRaces10
					ADCStuVisaType
					BirthDate
)
	&lb02 .&ds02&yt10&rp02 (KEEP=
					InstTerm
					ADCPersonID
					ADCStuLastName
					ADCStuFirstName
					ADCStuCitizenship
					ADCStuGender
					ADCStuPrimaryEthnic
					ADCStuRaces01-ADCStuRaces10
					ADCStuVisaType
					BirthDate
)
	&lb02 .&ds02&yt09&rp02 (KEEP=
					InstTerm
					ADCPersonID
					ADCStuLastName
					ADCStuFirstName
					ADCStuCitizenship
					ADCStuGender
					ADCStuPrimaryEthnic
					ADCStuRaces01-ADCStuRaces10
					ADCStuVisaType
					BirthDate
)
	&lb02 .&ds02&yt08&rp02 (KEEP=
					InstTerm
					ADCPersonID
					ADCStuLastName
					ADCStuFirstName
					ADCStuCitizenship
					ADCStuGender
					ADCStuPrimaryEthnic
					ADCStuRaces01-ADCStuRaces10
					ADCStuVisaType
					BirthDate
);
RUN;

DATA Student01b;
SET Student01;
PROC SORT DATA=Student01b; BY ADCPersonID DESCENDING  InstTerm;
PROC SORT NODUPKEY DATA=Student01b; BY ADCPersonID;
RUN;


/* nomatch is to check for students on the grad file but not on the student file */

DATA
	GradStud01
	NoMatch01
;
	MERGE Grad01(IN=a) Student01b(IN=b); BY ADCPersonID;
	IF a and b THEN OUTPUT GradStud01;
	IF a and not b THEN OUTPUT NoMatch01;
RUN;

PROC SORT DATA=NoMatch01; BY ADCPersonID;
RUN;


DATA NoMatch02;
SET NoMatch01;
PROC SORT NODUPKEY DATA=NoMatch02; BY ADCPersonID;
RUN;


DATA NoMatchInformerDemoData01;
	%LET _EFIERR_ = 0; /* set the ERROR detection macro variable */
      INFILE "&Pth01&Pth02&Pth03&csv11" DELIMITER = ',' MISSOVER DSD LRECL=32767 FIRSTOBS=2 ;
		INPUT
				ADCPersonID			:$10.
				ADCStuLastName		:$25.
				ADCStuFirstName		:$15.
				ADCStuCitizenship	:$3.
				ADCStuGender		:$3.
				ADCStuPrimaryEthnic	:$4.
				ADCStuEthnic		:$4.
				ADCStuRaces			:$4.
				ADCStuVisaType		:$3.
				BirthDate			:$10.
;
		FORMAT
				ADCPersonID			$10.
				ADCStuLastName		$25.
				ADCStuFirstName		$15.
				ADCStuCitizenship	$3.
				ADCStuGender		$3.
				ADCStuPrimaryEthnic	$4.
				ADCStuEthnic		$4.
				ADCStuRaces			$4.
				ADCStuVisaType		$3.
				BirthDate			$10.
;
      IF _ERROR_ THEN CALL symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
RUN;

DATA NoMatchInformerDemoData02;
RETAIN
				Var01
				Var02
				Var03
				Var04
				Var05
				Var06
				Var07
				Var08
				Var09
;
DROP
				Var01
				Var02
				Var03
				Var04
				Var05
				Var06
				Var07
				Var08
				Var09
;
SET NoMatchInformerDemoData01;
  IF ADCPersonID EQ ' ' AND ADCStuLastName EQ ' '
     THEN ADCStuLastName=Var02;
     ELSE Var02=ADCStuLastName;
  IF ADCPersonID EQ ' ' AND ADCStuFirstName EQ ' '
     THEN ADCStuFirstName=Var03;
     ELSE Var03=ADCStuFirstName;
  IF ADCPersonID EQ ' ' AND ADCStuCitizenship EQ ' '
     THEN ADCStuCitizenship=Var04;
     ELSE Var04=ADCStuCitizenship;
  IF ADCPersonID EQ ' ' AND ADCStuGender EQ ' '
     THEN ADCStuGender=Var05;
     ELSE Var05=ADCStuGender;
  IF ADCPersonID EQ ' ' AND ADCStuPrimaryEthnic EQ ' '
     THEN ADCStuPrimaryEthnic=Var06;
     ELSE Var06=ADCStuPrimaryEthnic;
  IF ADCPersonID EQ ' ' AND ADCStuEthnic EQ ' '
     THEN ADCStuEthnic=Var07;
     ELSE Var07=ADCStuEthnic;
  IF ADCPersonID EQ ' ' AND ADCStuVisaType EQ ' '
     THEN ADCStuVisaType=Var08;
     ELSE Var08=ADCStuVisaType;
  IF ADCPersonID EQ ' ' AND BirthDate EQ ' '
     THEN BirthDate=Var09;
     ELSE Var09=BirthDate;
  IF ADCPersonID EQ ' '
     THEN ADCPersonID=Var01;
     ELSE Var01=ADCPersonID;
PROC SORT DATA=NoMatchInformerDemoData02; BY ADCPersonID;
RUN;

DATA racearray (KEEP=ADCPersonID ADCStuRaces&ar02b-ADCStuRaces&ar02e);
RETAIN					ADCStuRaces&ar02b-ADCStuRaces&ar02e;
	ARRAY	rac (&ar02e) $4.	ADCStuRaces&ar02b-ADCStuRaces&ar02e;
SET NoMatchInformerDemoData02; BY ADCPersonID;
IF ADCPersonID EQ ' ' AND ADCStuRaces EQ ' ' THEN DELETE;
	IF FIRST.ADCPersonID THEN DO;
		i=1;
		DO j=1 TO &ar02e;
			rac(j)=' ';
		END;
	END;
	rac(i)=ADCStuRaces;
	IF LAST.ADCPersonID THEN OUTPUT;
	i+1;
RUN;

DATA NoMatchInformerDemoData03;
SET NoMatchInformerDemoData02;
DROP
	ADCStuRaces
;
PROC SORT NODUPKEY DATA=NoMatchInformerDemoData03; BY ADCPersonID;
RUN;


DATA NoMatchInformerDemoData04;
	MERGE NoMatchInformerDemoData03 (IN=m) racearray (IN=n); BY ADCPersonID;
RUN;

DATA GradStud02;
	MERGE Grad01 (IN=p) NoMatchInformerDemoData04 (IN=q); BY ADCPersonID;
	IF p*q=1;
RUN;



DATA GradStudFinal (KEEP=
					InstTerm
					ADCPersonID
					ADCStuLastName
					ADCStuFirstName
					ADCStuCitizenship
					ADCStuGender
					ADCStuPrimaryEthnic
					ADCStuRaces01-ADCStuRaces10
					ADCStuVisaType
					GradProg
					ADCGradAcadProgram
					BirthDate
					CRACE01
					CRACE02
					CRACE25
					CRACE26
					CRACE27
					CRACE28
					CRACE29
					CRACE30
					CRACE31
					CRACE32
					CRACE33
					CRACE34
					CRACE35
					CRACE36
					CRACE37
					CRACE38
					CRACE13
					CRACE14
					CRACE15
					CRACE16
					CRACE17
					CRACE41
					CRACE42
					CRACE43
					CRACE44
					CRACE45
					CRACE46
					CRACE47
					CRACE23
					CRACE999
					AGE1
					AGE2
					AGE3
					AGE4
					AGE5
					UNITID
					SURVSECT
					MAJORNUM
					AWLEVEL
					CTLEVEL
					ProgCode
					CIPCode2010
);

FORMAT
		CRACE01 8.
		CRACE02 8.
		CRACE25 8.
		CRACE26 8.
		CRACE27 8.
		CRACE28 8.
		CRACE29 8.
		CRACE30 8.
		CRACE31 8.
		CRACE32 8.
		CRACE33 8.
		CRACE34 8.
		CRACE35 8.
		CRACE36 8.
		CRACE37 8.
		CRACE38 8.
		CRACE13 8.
		CRACE14 8.
		CRACE15 8.
		CRACE16 8.
		CRACE17 8.
		CRACE41 8.
		CRACE42 8.
		CRACE43 8.
		CRACE44 8.
		CRACE45 8.
		CRACE46 8.
		CRACE47 8.
		CRACE23 8.
		CRACE999 8.
		AGE1 8.
		AGE2 8.
		AGE3 8.
		AGE4 8.
		AGE5 8.
		UNITID $6.
		SURVSECT $3.
		MAJORNUM $1.
		AWLEVEL 8.
		CTLEVEL 8.
		ProgCode $15.
;
SET
	GradStud01
	GradStud02
;
CRACE01=0;
CRACE02=0;
CRACE25=0;
CRACE26=0;
CRACE27=0;
CRACE28=0;
CRACE29=0;
CRACE30=0;
CRACE31=0;
CRACE32=0;
CRACE33=0;
CRACE34=0;
CRACE35=0;
CRACE36=0;
CRACE37=0;
CRACE38=0;
CRACE13=0;
CRACE14=0;
CRACE15=0;
CRACE16=0;
CRACE17=0;
CRACE41=0;
CRACE42=0;
CRACE43=0;
CRACE44=0;
CRACE45=0;
CRACE46=0;
CRACE47=0;
CRACE23=0;
CRACE999=0;
AGE1=0;
AGE2=0;
AGE3=0;
AGE4=0;
AGE5=0;
UNITID="&UNITID";
SURVSECT="&SURVSECT";
MAJORNUM="&MAJORNUM";
IF ADCStuGender EQ 'M' THEN CRACE15=1;
	ELSE IF ADCStuGender EQ 'F' OR ADCStuGender EQ ' ' THEN CRACE16=1;
	ELSE CRACE999=1;
IF ADCStuCitizenship NOT IN ('US','USA','   ')
	AND ADCStuVisaType NOT IN ('PR')
	THEN CRACE17=1;
	ELSE IF (ADCStuPrimaryEthnic EQ '   ' OR ADCStuPrimaryEthnic EQ 'NHS')
	AND ADCStuRaces01='   '
	AND ADCStuRaces02='   '
	AND ADCStuRaces03='   '
	AND ADCStuRaces04='   '
	AND ADCStuRaces05='   '
	AND ADCStuRaces06='   '
	AND ADCStuRaces07='   '
	AND ADCStuRaces08='   '
	AND ADCStuRaces09='   '
	AND ADCStuRaces10='   '
	THEN CRACE23=1;
	ELSE IF ADCStuPrimaryEthnic EQ 'HIS'
	THEN CRACE41=1;
	ELSE IF ADCStuRaces01 EQ 'AN'
	AND ADCStuRaces02='  '
	AND ADCStuRaces03='  '
	AND ADCStuRaces04='  '
	AND ADCStuRaces05='  '
	AND ADCStuRaces06='  '
	AND ADCStuRaces07='  '
	AND ADCStuRaces08='  '
	AND ADCStuRaces09='  '
	AND ADCStuRaces10='  '
	THEN CRACE42=1;
	ELSE IF ADCStuRaces01 EQ 'AS'
	AND ADCStuRaces02='  '
	AND ADCStuRaces03='  '
	AND ADCStuRaces04='  '
	AND ADCStuRaces05='  '
	AND ADCStuRaces06='  '
	AND ADCStuRaces07='  '
	AND ADCStuRaces08='  '
	AND ADCStuRaces09='  '
	AND ADCStuRaces10='  '
	THEN CRACE43=1;
	ELSE IF ADCStuRaces01 EQ 'BL'
	AND ADCStuRaces02='  '
	AND ADCStuRaces03='  '
	AND ADCStuRaces04='  '
	AND ADCStuRaces05='  '
	AND ADCStuRaces06='  '
	AND ADCStuRaces07='  '
	AND ADCStuRaces08='  '
	AND ADCStuRaces09='  '
	AND ADCStuRaces10='  '
	THEN CRACE44=1;
	ELSE IF ADCStuRaces01 EQ 'HP'
	AND ADCStuRaces02='  '
	AND ADCStuRaces03='  '
	AND ADCStuRaces04='  '
	AND ADCStuRaces05='  '
	AND ADCStuRaces06='  '
	AND ADCStuRaces07='  '
	AND ADCStuRaces08='  '
	AND ADCStuRaces09='  '
	AND ADCStuRaces10='  '
	THEN CRACE45=1;
	ELSE IF ADCStuRaces01 EQ 'WH'
	AND ADCStuRaces02='  '
	AND ADCStuRaces03='  '
	AND ADCStuRaces04='  '
	AND ADCStuRaces05='  '
	AND ADCStuRaces06='  '
	AND ADCStuRaces07='  '
	AND ADCStuRaces08='  '
	AND ADCStuRaces09='  '
	AND ADCStuRaces10='  '
	THEN CRACE46=1;
	ELSE CRACE47=1;
IF ADCStuCitizenship NOT IN ('US','USA','   ')
	AND ADCStuVisaType NOT IN ('PR')
	AND ADCStuGender EQ 'M' THEN CRACE01=1;
	ELSE IF ADCStuCitizenship NOT IN ('US','USA','   ')
	AND ADCStuVisaType NOT IN ('PR')
	AND (ADCStuGender EQ 'F' OR ADCStuGender EQ ' ') THEN CRACE02=1;
	ELSE IF (ADCStuPrimaryEthnic EQ '   ' OR ADCStuPrimaryEthnic EQ 'NHS')
	AND ADCStuRaces01='   '
	AND ADCStuRaces02='   '
	AND ADCStuRaces03='   '
	AND ADCStuRaces04='   '
	AND ADCStuRaces05='   '
	AND ADCStuRaces06='   '
	AND ADCStuRaces07='   '
	AND ADCStuRaces08='   '
	AND ADCStuRaces09='   '
	AND ADCStuRaces10='   '
	AND ADCStuGender EQ 'M' THEN CRACE13=1;
	ELSE IF (ADCStuPrimaryEthnic EQ '   ' OR ADCStuPrimaryEthnic EQ 'NHS')
	AND ADCStuRaces01='   '
	AND ADCStuRaces02='   '
	AND ADCStuRaces03='   '
	AND ADCStuRaces04='   '
	AND ADCStuRaces05='   '
	AND ADCStuRaces06='   '
	AND ADCStuRaces07='   '
	AND ADCStuRaces08='   '
	AND ADCStuRaces09='   '
	AND ADCStuRaces10='   '
	AND (ADCStuGender EQ 'F' OR ADCStuGender EQ ' ') THEN CRACE14=1;
	ELSE IF ADCStuPrimaryEthnic EQ 'HIS'
	AND ADCStuGender EQ 'M' THEN CRACE25=1;
	ELSE IF ADCStuPrimaryEthnic EQ 'HIS'
	AND (ADCStuGender EQ 'F' OR ADCStuGender EQ ' ') THEN CRACE26=1;
	ELSE IF ADCStuRaces01 EQ 'AN'
	AND ADCStuRaces02='  '
	AND ADCStuRaces03='  '
	AND ADCStuRaces04='  '
	AND ADCStuRaces05='  '
	AND ADCStuRaces06='  '
	AND ADCStuRaces07='  '
	AND ADCStuRaces08='  '
	AND ADCStuRaces09='  '
	AND ADCStuRaces10='  '
	AND ADCStuGender EQ 'M' THEN CRACE27=1;
	ELSE IF ADCStuRaces01 EQ 'AN'
	AND ADCStuRaces02='  '
	AND ADCStuRaces03='  '
	AND ADCStuRaces04='  '
	AND ADCStuRaces05='  '
	AND ADCStuRaces06='  '
	AND ADCStuRaces07='  '
	AND ADCStuRaces08='  '
	AND ADCStuRaces09='  '
	AND ADCStuRaces10='  '
	AND (ADCStuGender EQ 'F' OR ADCStuGender EQ ' ') THEN CRACE28=1;
	ELSE IF ADCStuRaces01 EQ 'AS'
	AND ADCStuRaces02='  '
	AND ADCStuRaces03='  '
	AND ADCStuRaces04='  '
	AND ADCStuRaces05='  '
	AND ADCStuRaces06='  '
	AND ADCStuRaces07='  '
	AND ADCStuRaces08='  '
	AND ADCStuRaces09='  '
	AND ADCStuRaces10='  '
	AND ADCStuGender EQ 'M' THEN CRACE29=1;
	ELSE IF ADCStuRaces01 EQ 'AS'
	AND ADCStuRaces02='  '
	AND ADCStuRaces03='  '
	AND ADCStuRaces04='  '
	AND ADCStuRaces05='  '
	AND ADCStuRaces06='  '
	AND ADCStuRaces07='  '
	AND ADCStuRaces08='  '
	AND ADCStuRaces09='  '
	AND ADCStuRaces10='  '
	AND (ADCStuGender EQ 'F' OR ADCStuGender EQ ' ') THEN CRACE30=1;
	ELSE IF ADCStuRaces01 EQ 'BL'
	AND ADCStuRaces02='  '
	AND ADCStuRaces03='  '
	AND ADCStuRaces04='  '
	AND ADCStuRaces05='  '
	AND ADCStuRaces06='  '
	AND ADCStuRaces07='  '
	AND ADCStuRaces08='  '
	AND ADCStuRaces09='  '
	AND ADCStuRaces10='  '
	AND ADCStuGender EQ 'M' THEN CRACE31=1;
	ELSE IF ADCStuRaces01 EQ 'BL'
	AND ADCStuRaces02='  '
	AND ADCStuRaces03='  '
	AND ADCStuRaces04='  '
	AND ADCStuRaces05='  '
	AND ADCStuRaces06='  '
	AND ADCStuRaces07='  '
	AND ADCStuRaces08='  '
	AND ADCStuRaces09='  '
	AND ADCStuRaces10='  '
	AND (ADCStuGender EQ 'F' OR ADCStuGender EQ ' ') THEN CRACE32=1;
	ELSE IF ADCStuRaces01 EQ 'HP'
	AND ADCStuRaces02='  '
	AND ADCStuRaces03='  '
	AND ADCStuRaces04='  '
	AND ADCStuRaces05='  '
	AND ADCStuRaces06='  '
	AND ADCStuRaces07='  '
	AND ADCStuRaces08='  '
	AND ADCStuRaces09='  '
	AND ADCStuRaces10='  '
	AND ADCStuGender EQ 'M' THEN CRACE33=1;
	ELSE IF ADCStuRaces01 EQ 'HP'
	AND ADCStuRaces02='  '
	AND ADCStuRaces03='  '
	AND ADCStuRaces04='  '
	AND ADCStuRaces05='  '
	AND ADCStuRaces06='  '
	AND ADCStuRaces07='  '
	AND ADCStuRaces08='  '
	AND ADCStuRaces09='  '
	AND ADCStuRaces10='  '
	AND (ADCStuGender EQ 'F' OR ADCStuGender EQ ' ') THEN CRACE34=1;
	ELSE IF ADCStuRaces01 EQ 'WH'
	AND ADCStuRaces02='  '
	AND ADCStuRaces03='  '
	AND ADCStuRaces04='  '
	AND ADCStuRaces05='  '
	AND ADCStuRaces06='  '
	AND ADCStuRaces07='  '
	AND ADCStuRaces08='  '
	AND ADCStuRaces09='  '
	AND ADCStuRaces10='  '
	AND ADCStuGender EQ 'M' THEN CRACE35=1;
	ELSE IF ADCStuRaces01 EQ 'WH'
	AND ADCStuRaces02='  '
	AND ADCStuRaces03='  '
	AND ADCStuRaces04='  '
	AND ADCStuRaces05='  '
	AND ADCStuRaces06='  '
	AND ADCStuRaces07='  '
	AND ADCStuRaces08='  '
	AND ADCStuRaces09='  '
	AND ADCStuRaces10='  '
	AND (ADCStuGender EQ 'F' OR ADCStuGender EQ ' ') THEN CRACE36=1;
	ELSE IF ADCStuGender EQ 'M' THEN CRACE37=1;
	ELSE CRACE38=1;
Age=1*(SUBSTR(ADCGradTerm,1,4))-INT(BirthDate/10000);
IF Age  <18 THEN AGE1=1;
ELSE IF Age >=18 AND Age <=24 THEN AGE2=1;
ELSE IF Age >=25 AND Age<=39 THEN AGE3=1;
ELSE IF Age >=40 AND Age<=100 THEN AGE4=1;
ELSE AGE5=1;
ProgCode=GradProg;
IF (SUBSTR(ProgCode,1,1)) EQ 'A' THEN AWLEVEL=3;
ELSE IF (SUBSTR(ProgCode,1,1)) EQ 'D' THEN AWLEVEL=2;
ELSE IF (SUBSTR(ProgCode,1,1)) EQ 'C' THEN AWLEVEL=1;
IF (SUBSTR(ProgCode,1,1)) EQ 'A' THEN CTLEVEL=3;
ELSE IF (SUBSTR(ProgCode,1,1)) EQ 'D' THEN CTLEVEL=2;
ELSE IF (SUBSTR(ProgCode,1,1)) EQ 'C' THEN CTLEVEL=1;
PROC SORT DATA=GradStudFinal; BY ProgCode;
RUN;

DATA GradStudCIP01a;
	MERGE CIPMerge01Final (IN=t) GradStudFinal (IN=u); BY ProgCode;
	IF t*u=1;
RUN;

DATA GradStudCIP01b;
	MERGE GradStudFinal (IN=t) CIPMerge01Final (IN=u); BY ProgCode;
	IF t AND NOT u;
RUN;

DATA GradStudCIP01c;
FORMAT ProgCore $10.;
SET GradStudCIP01b;
ProgCore=(SUBSTR(ProgCode,2,4));
DROP
	ADCStuCURPriProgCode
	Title
	PreviousCIPCode
	CurrentCIPCode
	Coordinator
	ProgCode2
	PROGRAMTITLE
	PROGCODE1
	REQuiredCredits
	DistanceED
;
PROC SORT DATA=GradStudCIP01c; BY ProgCore;
RUN;

DATA CIPMerge01bFinal;
SET CIPMerge01Final;
PROC SORT NODUPKEY DATA=CIPMerge01bFinal; BY ProgCore;
RUN;

DATA GradStudCIP01d;
	MERGE CIPMerge01bFinal (IN=c) GradStudCIP01c (IN=d); BY ProgCore;
	IF c*d=1;
RUN;

DATA GradStudCIP01e;
	MERGE GradStudCIP01c (IN=c) CIPMerge01bFinal (IN=d); BY ProgCore;
	IF c AND NOT d;
RUN;

DATA GradStudCIP01f;
SET GradStudCIP01e;
DROP
	ADCStuCURPriProgCode
	Title
	PreviousCIPCode
	CurrentCIPCode
	Coordinator
	ProgCode2
	PROGRAMTITLE
	PROGCODE1
	REQuiredCredits
	DistanceED
;
PROC SORT DATA=GradStudCIP01c; BY ProgCore;
RUN;

DATA GradStudCIP01g;
	MERGE GradStudCIP01f (IN=e) CIPXWalk2 (IN=f); BY ProgCore;
	IF e*f=1;
DistanceED='2';
RUN;

DATA GradStudCIP01h;
	MERGE GradStudCIP01f (IN=e) CIPXWalk2 (IN=f); BY ProgCore;
	IF e AND NOT f;
RUN;

DATA StudentFinal;
FORMAT CIPCode $7.;
SET
	GradStudCIP01a
	GradStudCIP01d
	GradStudCIP01g
;
CIPCode=CurrentCipCode;
PROC SORT DATA=StudentFinal; BY ADCPersonID;
RUN;
	

DATA IPEDSCompletionsPartA;
FORMAT PART $1.;
SET StudentFinal;
PART="A";
PROC SORT DATA=IPEDSCompletionsPartA; BY UNITID SURVSECT PART MAJORNUM CIPCODE AWLEVEL;
PROC SUMMARY DATA=IPEDSCompletionsPartA; BY UNITID SURVSECT PART MAJORNUM CIPCODE AWLEVEL;
	VAR
					CRACE01
					CRACE02
					CRACE25
					CRACE26
					CRACE27
					CRACE28
					CRACE29
					CRACE30
					CRACE31
					CRACE32
					CRACE33
					CRACE34
					CRACE35
					CRACE36
					CRACE37
					CRACE38
					CRACE13
					CRACE14
;
OUTPUT OUT=COMPartAOut SUM=
					CRACE01
					CRACE02
					CRACE25
					CRACE26
					CRACE27
					CRACE28
					CRACE29
					CRACE30
					CRACE31
					CRACE32
					CRACE33
					CRACE34
					CRACE35
					CRACE36
					CRACE37
					CRACE38
					CRACE13
					CRACE14
;
RUN;

DATA CIPLevel01;
FORMAT
		CIPCODE $7.
;
SET CIPMerge02Final;
CIPCODE=CurrentCIPCode;
PROC SORT DATA=CIPLevel01; BY CIPCODE AWLEVEL;
PROC SORT NODUPKEY DATA=CIPLevel01; BY CIPCODE AWLEVEL;
RUN;

DATA CredCIPLevel01;
SET StudentFinal;
PROC SORT DATA=CredCIPLevel01; BY CIPCODE AWLEVEL;
PROC SORT NODUPKEY DATA=CredCIPLevel01; BY CIPCODE AWLEVEL;
RUN;

DATA CIPCredLevelMerge (KEEP=
					UNITID
					SURVSECT
					PART
					MAJORNUM
					CIPCODE
					AWLEVEL
					CRACE01
					CRACE02
					CRACE25
					CRACE26
					CRACE27
					CRACE28
					CRACE29
					CRACE30
					CRACE31
					CRACE32
					CRACE33
					CRACE34
					CRACE35
					CRACE36
					CRACE37
					CRACE38
					CRACE13
					CRACE14
					DistanceED
);
RETAIN
					UNITID
					SURVSECT
					PART
					MAJORNUM
					CIPCODE
					AWLEVEL
					CRACE01
					CRACE02
					CRACE25
					CRACE26
					CRACE27
					CRACE28
					CRACE29
					CRACE30
					CRACE31
					CRACE32
					CRACE33
					CRACE34
					CRACE35
					CRACE36
					CRACE37
					CRACE38
					CRACE13
					CRACE14
					DistanceED
;
FORMAT
		UNITID $6.
		SURVSECT $3.
		MAJORNUM $1.
		PART $1.
;
	MERGE CIPLevel01(IN=c) CredCIPLevel01(IN=d); BY CIPCODE AWLEVEL;
	IF c AND NOT d;
UNITID="&UNITID";
SURVSECT="&SURVSECT";
MAJORNUM="&MAJORNUM";
PART="A";
RUN;

DATA IPEDSCOMPartAFinal;
SET
	COMPartAOut
	CIPCredLevelMerge
;
DROP
	_TYPE_
	_FREQ_
;
PROC SORT DATA=IPEDSCOMPartAFinal; BY UNITID SURVSECT PART MAJORNUM CIPCODE AWLEVEL;
RUN;

/* Completions Part B: Distance Education */

DATA IPEDSCOMPartBFinal;
FORMAT
		DistanceED $1.
		UNITID $6.
		SURVSECT $3.
		MAJORNUM $1.
		PART $1.
;
SET
	StudentFinal
	CIPCredLevelMerge
;
*DistanceED='2';
UNITID="&UNITID";
SURVSECT="&SURVSECT";
MAJORNUM="&MAJORNUM";
PART="B";
PROC SORT DATA=IPEDSCOMPartBFinal; BY UNITID SURVSECT PART MAJORNUM CIPCODE AWLEVEL DistanceED;
PROC SORT NODUPKEY DATA=IPEDSCOMPartBFinal; BY UNITID SURVSECT PART MAJORNUM CIPCODE AWLEVEL;
RUN;

ODS LISTING CLOSE;
ODS HTML CLOSE;
ODS MARKUP TAGSET=CHTML BODY="&PathRoot\XX_SAS_TrashBin\Report03IPEDS.html";

DATA IPEDSCompletionsPartC;
FORMAT PART $1.;
SET StudentFinal;
PART="C";
PROC SORT DATA=IPEDSCompletionsPartC; BY ADCPersonID DESCENDING AWLEVEL;
PROC SORT NODUPKEY DATA=IPEDSCompletionsPartC; BY ADCPersonID;
PROC SORT DATA=IPEDSCompletionsPartC; BY UNITID SURVSECT PART MAJORNUM CIPCODE AWLEVEL;
PROC SUMMARY DATA=IPEDSCompletionsPartC; BY UNITID SURVSECT PART MAJORNUM CIPCODE AWLEVEL;
	VAR
					CRACE01
					CRACE02
					CRACE25
					CRACE26
					CRACE27
					CRACE28
					CRACE29
					CRACE30
					CRACE31
					CRACE32
					CRACE33
					CRACE34
					CRACE35
					CRACE36
					CRACE37
					CRACE38
					CRACE13
					CRACE14
;
OUTPUT OUT=COMPartCOut SUM=
					CRACE01
					CRACE02
					CRACE25
					CRACE26
					CRACE27
					CRACE28
					CRACE29
					CRACE30
					CRACE31
					CRACE32
					CRACE33
					CRACE34
					CRACE35
					CRACE36
					CRACE37
					CRACE38
					CRACE13
					CRACE14
;
RUN;

DATA CredCIPLevel02;
SET IPEDSCompletionsPartC;
PROC SORT DATA=CredCIPLevel02; BY CIPCODE AWLEVEL;
PROC SORT NODUPKEY DATA=CredCIPLevel02; BY CIPCODE AWLEVEL;
RUN;

DATA CIPCredLevelMerge2 (KEEP=
					UNITID
					SURVSECT
					PART
					MAJORNUM
					CIPCODE
					AWLEVEL
					CRACE01
					CRACE02
					CRACE25
					CRACE26
					CRACE27
					CRACE28
					CRACE29
					CRACE30
					CRACE31
					CRACE32
					CRACE33
					CRACE34
					CRACE35
					CRACE36
					CRACE37
					CRACE38
					CRACE13
					CRACE14
					DistanceED
);
RETAIN
					UNITID
					SURVSECT
					PART
					MAJORNUM
					CIPCODE
					AWLEVEL
					CRACE01
					CRACE02
					CRACE25
					CRACE26
					CRACE27
					CRACE28
					CRACE29
					CRACE30
					CRACE31
					CRACE32
					CRACE33
					CRACE34
					CRACE35
					CRACE36
					CRACE37
					CRACE38
					CRACE13
					CRACE14
					DistanceED
;
	MERGE CIPLevel01(IN=e) CredCIPLevel02(IN=f); BY CIPCODE AWLEVEL;
	IF e AND NOT f;
RUN;

DATA IPEDSCOMPartCFinal;
FORMAT
		UNITID $6.
		SURVSECT $3.
		MAJORNUM $1.
		PART $1.
;
SET
	COMPartCOut
	CIPCredLevelMerge2
;
UNITID="&UNITID";
SURVSECT="&SURVSECT";
MAJORNUM="&MAJORNUM";
PART="C";
DROP
	_TYPE_
	_FREQ_
;
PROC SORT DATA=IPEDSCOMPartCFinal; BY UNITID SURVSECT PART MAJORNUM CIPCODE AWLEVEL;
RUN;


DATA IPEDSCOMPartD (KEEP=
					ADCPersonID
					UNITID
					SURVSECT
/*					PART*/
					MAJORNUM
					CTLEVEL
					CRACE15
					CRACE16
					CRACE17
					CRACE41
					CRACE42
					CRACE43
					CRACE44
					CRACE45
					CRACE46
					CRACE47
					CRACE23
					AGE1
					AGE2
					AGE3
					AGE4
					AGE5
);
SET StudentFinal;
PROC SORT DATA=IPEDSCOMPartD; BY ADCPersonID CTLEVEL;
PROC SORT NODUPKEY DATA=IPEDSCOMPartD; BY ADCPersonID CTLEVEL;
PROC SORT DATA=IPEDSCOMPartD; BY UNITID SURVSECT MAJORNUM CTLEVEL;
PROC SUMMARY DATA=IPEDSCOMPartD; BY UNITID SURVSECT MAJORNUM CTLEVEL;
	VAR
					CRACE15
					CRACE16
					CRACE17
					CRACE41
					CRACE42
					CRACE43
					CRACE44
					CRACE45
					CRACE46
					CRACE47
					CRACE23
					AGE1
					AGE2
					AGE3
					AGE4
					AGE5
;
OUTPUT OUT=COMPartDOut SUM=
					CRACE15
					CRACE16
					CRACE17
					CRACE41
					CRACE42
					CRACE43
					CRACE44
					CRACE45
					CRACE46
					CRACE47
					CRACE23
					AGE1
					AGE2
					AGE3
					AGE4
					AGE5
;
RUN;

ODS MARKUP TAGSET=CHTML CLOSE;

DATA IPEDSCOMPartDFinal;
FORMAT
		UNITID $6.
		SURVSECT $3.
		MAJORNUM $1.
		PART $1.
;
SET
	COMPartDOut
;
UNITID="&UNITID";
SURVSECT="&SURVSECT";
MAJORNUM="&MAJORNUM";
PART="D";
DROP
	_TYPE_
	_FREQ_
;
PROC SORT DATA=IPEDSCOMPartDFinal; BY UNITID SURVSECT PART MAJORNUM CTLEVEL;
RUN;


/* Output TXT file for Parts A, B, C & D */

FILENAME OUTABCD "&Pth01&Pth02&Pth03\IPEDSCompletionsPartABCD_FINAL.txt";
DATA _NULL_;
FILE OUTABCD;
/* Part A */
DO _N_ = 1 BY 1 UNTIL (EOF);
	SET IPEDSCOMPartAFinal END = EOF;
PUT 
	@1 UNITID
    @7 SURVSECT
	@10 PART
	@11 MAJORNUM
	@12 CIPCODE
	@19 AWLEVEL Z2.
	@21 CRACE01 Z6.
	@27 CRACE02 Z6.
	@33 CRACE25 Z6.
	@39 CRACE26 Z6.
	@45 CRACE27 Z6.
	@51 CRACE28 Z6.
	@57 CRACE29 Z6.
	@63 CRACE30 Z6.
	@69 CRACE31 Z6.
	@75 CRACE32 Z6.
	@81 CRACE33 Z6.
	@87 CRACE34 Z6.
	@93 CRACE35 Z6.
	@99 CRACE36 Z6.
	@105 CRACE37 Z6.
	@111 CRACE38 Z6.
	@117 CRACE13 Z6.
	@123 CRACE14 Z6.
;
END;
/* Part B */
EOF=0;
DO _N_ = 1 BY 1 UNTIL (EOF);
	SET IPEDSCOMPartBFinal END = EOF;
PUT 
	@1 UNITID
    @7 SURVSECT
	@10 PART
	@11 MAJORNUM
	@12 CIPCODE
	@19 AWLEVEL Z2.
	@21 DistanceED
;
END;
/* Part C */
EOF=0;
DO _N_ = 1 BY 1 UNTIL (EOF);
	SET IPEDSCOMPartCFinal END = EOF;
PUT 
	@1 UNITID
    @7 SURVSECT
	@10 PART
/*	@11 MAJORNUM
	@12 CIPCODE
	@19 AWLEVEL Z2.*/
	@11 CRACE01 Z6.
	@17 CRACE02 Z6.
	@23 CRACE25 Z6.
	@29 CRACE26 Z6.
	@35 CRACE27 Z6.
	@41 CRACE28 Z6.
	@47 CRACE29 Z6.
	@53 CRACE30 Z6.
	@59 CRACE31 Z6.
	@65 CRACE32 Z6.
	@71 CRACE33 Z6.
	@77 CRACE34 Z6.
	@83 CRACE35 Z6.
	@89 CRACE36 Z6.
	@95 CRACE37 Z6.
	@101 CRACE38 Z6.
	@107 CRACE13 Z6.
	@113 CRACE14 Z6.
;
END;
/* Part D */
EOF=0;
DO _N_ = 1 BY 1 UNTIL (EOF);
	SET IPEDSCOMPartDFinal END = EOF;
PUT 
	@1 UNITID
    @7 SURVSECT
	@10 PART
	@11 CTLEVEL
	@12 CRACE15 Z6.
	@18 CRACE16 Z6.
	@30 CRACE17 Z6.
	@36 CRACE41 Z6.
	@42 CRACE42 Z6.
	@48 CRACE43 Z6.
	@54 CRACE44 Z6.
	@60 CRACE45 Z6.
	@66 CRACE46 Z6.
	@72 CRACE47 Z6.
	@78 CRACE23 Z6.
	@90 AGE1 Z6.
	@96 AGE2 Z6.
	@102 AGE3 Z6.
	@108 AGE4 Z6.
	@114 AGE5 Z6.
;
END;
STOP;
RUN;



/* OUTPUT SCREENS */

ODS LISTING CLOSE;
ODS HTML CLOSE;
ODS MARKUP TAGSET=CHTML BODY="&PathRoot\XX_SAS_TrashBin\IPEDSTotCredsStuds.html";

DATA CHECKGradFileCIP;
SET Grad01;
IF CIPCode2010 IN (
					' '
					);
TITLE1 "ERROR - Missing CIP Codes For Graduate Files";
TITLE2 " - Look Up And Enter Manual Correction(s) To CIP Crosswalk Dataset Then Recreate Graduate Datasets";
PROC PRINT DATA=CHECKGradFileCIP;
	VAR
		ADCGradTerm
		ADCGradAcadProgram
		CIPCode2010
		ADCGradProgramCIP
		GradProg
		GradCert
;
RUN;

DATA CHECKApprovedProgsFileCIP;
SET CIPMerge02FINAL;
IF CurrentCIPCode IN (
					' '
					);
TITLE1 "ERROR - Missing CIP Codes For Approved Programs of Study List";
TITLE2 " - Look Up And Enter Manual Correction(s) To CIP Crosswalk Dataset";
PROC PRINT DATA=CHECKApprovedProgsFileCIP;
	VAR
		PROGCODE1
		CurrentCIPCode
;
RUN;

DATA NoMatch02b;
SET NoMatchInformerDemoData03;
PROC SORT NODUPKEY DATA=NoMatch02b; BY ADCPersonID;
PROC PRINT DATA=NoMatch02b;
TITLE1 "Missing Demographics - THESE HAVE NOW BEEN CORRECTED";
RUN;

DATA TotalCredentials;
SET IPEDSCompletionsPartA;
TITLE1 "TOTAL Completions by Award Level";
PROC FREQ DATA=TotalCredentials;
	TABLES AWLEVEL / NOCOL NOPERCENT NOROW;
RUN;

DATA UndupStudents;
SET TotalCredentials;
TITLE1 "TOTAL Unduplicated Graduates by Highest Award Level";
PROC SORT DATA=UndupStudents; BY ADCPersonID DESCENDING AWLEVEL;
PROC SORT NODUPKEY DATA=UndupStudents; BY ADCPersonID;
PROC FREQ DATA=UndupStudents;
	TABLES AWLEVEL / NOCOL NOPERCENT NOROW;
RUN;

ODS MARKUP TAGSET=CHTML CLOSE;




