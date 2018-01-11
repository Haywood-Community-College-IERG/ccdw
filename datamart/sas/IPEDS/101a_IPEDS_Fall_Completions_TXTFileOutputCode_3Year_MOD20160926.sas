/* 101a */
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
*          1 - FIRST DOWNLOAD AND CREATE PAST YEAR GRADUATE _RO DATASETS            *
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
%LET Pth03=\03_Completions;

%LET csv01=\Approved_Programs_of_Study_;
%LET csv02=20162017;						/* CHANGE FOR EACH REPORTING YEAR */
%LET csv03=_SAS_MERGE.csv;

%LET csv11=NoMatch02InformerDemoData.csv;

%LET lb21=CIPXWalk;
%LET ds21=ncccs_prog_cipcodes;
%LET rp21=_mod20150220;

%LET lb01=Grad;
%LET ds01=Grad;				/* CHANGE TO Grad_ FOR _RO ONLY - CHANGE FOR EACH TERM FOR 6 DIGIT DATASET */
%LET rp01=;					/* CHANGE TO _RO FOR _RO ONLY - CHANGE FOR EACH TERM FOR 6 DIGIT DATASET */

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

%LET UNITID=198260;			/* CHANGE TO YOUR IPEDS UNIT ID */
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
*IF RequiredCredits GE 16;
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


ODS LISTING CLOSE;
ODS HTML CLOSE;
/*ODS MARKUP TAGSET=CHTML BODY="&PathRoot\XX_SAS_TrashBin\Report01IPEDS.html";*/
ODS MARKUP TAGSET=CHTML BODY="&Pth01&Pth02&Pth03\IPEDS_Completions_ERRORS.html";

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

DATA MissingDOB;
SET GradStud01;
IF BirthDate EQ ' ';
TITLE1 "ERROR - Missing Date of Birth";
PROC PRINT DATA=MissingDOB;
	VAR
		ADCPersonID
		ADCStuLastName
		ADCStuFirstname
		BirthDate
		BirthDate
		;
RUN;


DATA NoMatch02;
SET NoMatch01;
PROC SORT NODUPKEY DATA=NoMatch02; BY ADCPersonID;
PROC PRINT DATA=NoMatch02;
VAR ADCPersonID;
TITLE1 "ERROR - Missing Demographics - Run Through Informer";
RUN;

ODS MARKUP TAGSET=CHTML CLOSE;


