*************************************************************************************
* CREATED BY:   Center for Applied Research Staff                                   *
*               Central Piedmont Community College                                  *
*               P. O. Box 35009                                                     *
*               Charlotte, NC 28235-5009                                            *
*               EMail: paul.earls@cpcc.edu                                          *
*               Phone: 704-330-6399                                                 *
*               EMail: bobbie.frye@cpcc.edu                                         *
*               Phone: 704-330-6459                                                 *
*               EMail: jason.temples@cpcc.edu                                       *
*               Phone: 704-330-6382                                                 *
*				EMail: courtnee.bonds@cpcc.edu          							*
*				Phone: 704-330-2722 ext 3808										*
* DATE CREATED: 00-00-2016                                                          *
* MODIFIED1:                                                                        *
* MOD1 DATE:                                                                        *
* MODIFIED2:                                                                        *
* MOD2 DATE:                                                                        *
* REQUESTOR:    CPCC Center For Applied Research - For Community Colleges           *
* PURPOSE:      Create Student SAS Datasets                                         *
*               For Any Term/Date                                                   *
*************************************************************************************;
OPTIONS PS=32765 LS=100 NONUMBER NOCENTER;

%LET PathRoot=W:\InstitutionalResearch\A_XNC_Datatel;

LIBNAME stu6 "&PathRoot\Downloads\SASDatasets\02_Student";

%LET Path00=&PathRoot\Downloads\;
%LET Pathxwk=&PathRoot\Downloads\SASDatasets\99_Crosswalks\;	/* LOCATION OF GRADE CROSSWALK */

%LET Infile09=ST_09_XNC_ST_SAS_STUDENT_COURSE_SEC.txt;
%LET Infile02=ST_02_XNC_ST_SAS_PERSON_DATA.txt;
%LET Infile11=ST_11_XNC_ST_SAS_STUDENT_ACAD_LEVELS_DATA.txt;
%LET Infile05=ST_05_XNC_ST_SAS_NON_COURSE_DATA.txt;
%LET Infile07=ST_07_XNC_ST_SAS_INSTITUTIONS_ATTENDED_DATA.txt;
%LET Infile03=ST_03_XNC_ST_SAS_REGISTRATION_QUESTIONS.txt;
%LET Infile14=ST_14_XNC_ST_SAS_STUDENT_PROGRAMS_DATA.txt;
%LET Infile15=ST_15_XNC_ST_SAS_STUDENTS_DATA.txt;
%LET Infile12=ST_12_XNC_ST_SAS_PERSON_ST_DATA.txt;
%LET Infilexw=gradeschemesxwalk.sas7bdat;	/* GRADE CROSSWALK DATASET */

%LET lb01=stu6;
%LET ds01=ST_;
%LET rp01=_ET;				/* CHANGE FOR EACH REPORTING POINTS DATASET CREATION */

%LET yt01=201403;			/* CHANGE FOR EACH TERMS DATASET CREATIONS 01-SPRING, 02-SUMMER, 03-FALL */

%LET rt01=2014FA;			/* CHANGE FOR EACH TERMS DATASET CREATIONS */
%LET rt02=2014CE3;			/* CHANGE FOR EACH TERMS DATASET CREATIONS */

%LET rt01b=2014CU3;			/* CHANGE FOR EACH TERMS DATASET CREATIONS CU1-SPRING, CU2-SUMMER, CU3-FALL */
%LET rt02b=2014CE3;			/* CHANGE FOR EACH TERMS DATASET CREATIONS CE1-SPRING, CE2-SUMMER, CE3-FALL */

%LET StartDate=20140818;	/* CHANGE FOR EACH TERM DATASET CREATION - PROGRAMS WITH END DATES THAT ARE BLANK OR AFTER THIS DATE ARE KEPT AS CURRENT PROGRAMS */
							/* SEE 00_TermStartEndDate.xlsx */

%LET EndDate=20141216;  	/* CHANGE FOR EACH TERM DATASET CREATION - PROGRAM WITH START DATES BEFORE THIS DATE ARE KEPT AS CURRENT WHILE PROGRAMS WITH */
							/*	START DATES ON OR AFTER THIS DATE ARE ELIMINATED AS FUTURE-DATED PROGRAM CODES */
							/* SEE 00_TermStartEndDate.xlsx */

*NO CHANGES NEEDED BEYOND THIS POINT;
*-----------------------------------;

%LET IC01=US;		* Country of Institution;
%LET IS01=NC;		* State of Institution;
%LET II01=882;		* state institution ID;
%LET IN01=SWCC;	* Institution Short name;
%LET IU01=199731;	* IPEDS Unit ID;
%LET OI01=008466;	* OPE ID / FICE Code;

%LET ar01b=001;		* BEGINNING NUMBER OF ELEMENTS IN ST09 CLASS ARRAY;
%LET ar01e=150;		* ENDING NUMBER OF ELEMENTS IN ST09 CLASS ARRAY;

%LET ar02b=01;		* BEGINNING NUMBER OF ELEMENTS IN ST02 RACE ARRAY;
%LET ar02e=10;		* ENDING NUMBER OF ELEMENTS IN ST02 RACE ARRAY;

%LET ar03b=01;		* BEGINNING NUMBER OF ELEMENTS IN ST15 EdGoals ARRAY;
%LET ar03e=25;		* ENDING NUMBER OF ELEMENTS IN ST15 EdGoals ARRAY;

%LET ar04b=01;		* BEGINNING NUMBER OF ELEMENTS IN ST15 ActivePrograms ARRAY;
%LET ar04e=40;		* ENDING NUMBER OF ELEMENTS IN ST15 ActivePrograms ARRAY;



* BEGIN - SECTION st09download - IMPORTS DATATEL FLAT FILE DOWNLOAD ST_09_XNC_ST_SAS_STUDENT_COURSE_SEC.txt 
																	WHICH IS NUMBER 5 of 9 STUDENT FILES *;

DATA st09download (KEEP=
					ADCPersonID 
					ADCStuCourseDash
					ADCStuClsSection
					ADCStuClsPrefix
					ADCStuClsTerm
					ADCStuClsReportTerm
					ADCStuClsStatus
					ADCStuClsStatusDate
					ADCStuClsStatusTime
					ADCStuClsStatusReason
					ADCStuClsGradeScheme
					ADCStuRegCEUnits
					ADCStuRegCUCredits
					ADCStuClsFinalGradeCode
					ADCStuClsFinalGrade
					ADCStuClsGradeLegend
					ADCStuClsVrfdGradeCode
					ADCStuClsVrfdGradeChgOpr
					ADCStuClsVrfdGradeDate
					ADCStuClsRegMethod
					ADCStuClsNumber
					ADCStuPrimaryProgramCode
					ADCClsID
);
INFILE "&Path00&Infile09"  LINESIZE=650 TRUNCOVER;
INPUT @1 ADCPersonID $10. @;
	SELECT;
	WHEN (ADCPersonID NE 'Person ID ') DO;
		INPUT @1	ADCPersonID					$10.
			@11		ADCStuCourseDash			$12.
			@26		ADCStuClsSection			$6.
			@33		ADCStuClsPrefix				$8.
			@73		ADCStuClsTerm 				$7.
			@108	ADCStuClsReportTerm			$7.
			@143	ADCStuClsStatus				$4.
			@158	ADCStuClsStatusDate			$10.
			@169	ADCStuClsStatusTime			$9.
		/*	@176	ADCStuClsStatusReason		$4. */
			@180    ADCStuClsStatusReason	    $4. /* updated by Catherine 2/5/13 */
			@205	ADCStuClsGradeScheme		$4.
			@240	ADCStuRegCEUnits			6.
			@246	ADCStuRegCUCredits			8.
			@254	ADCStuClsFinalGradeCode		$4.
			@265	ADCStuClsFinalGrade			$4.
			@270	ADCStuClsGradeLegend		$30.
			@300	ADCStuClsVrfdGradeCode		$4.
			@305	ADCStuClsVrfdGradeChgOpr	$8.
			@330	ADCStuClsVrfdGradeDate		$10.
			@349	ADCStuClsRegMethod			$7.
			@379	ADCStuClsNumber				$8.
			@398	ADCStuPrimaryProgramCode	$12.
			@416	ADCClsID					$7.
/*			@437	ADCPersonID2				$10.*/
;
		OUTPUT st09download;
	END;
	OTHERWISE DO;
	PUT 'Error in record ' _n_ 'as follows:' _INFILE_;
		DELETE;
	END;
END;
RUN;

* END - SECTION st09download - IMPORTS DATATEL FLAT FILE DOWNLOAD ST_09_XNC_ST_SAS_STUDENT_COURSE_SEC.txt 
																	WHICH IS NUMBER 5 of 9 STUDENT FILES *;

* BEGIN - SECTION 9a2 - REPEATS NECESSARY VARIABLE VALUES FOR SECTION 9a *;

DATA repeat09flds1a;
SET st09download;
	RETAIN PreviousID;
	DROP   PreviousID;
	RETAIN PreviousCNDash;
	DROP   PreviousCNDash;
	RETAIN Previoussec;
	DROP   Previoussec;
	RETAIN PreviousPref;
	DROP   PreviousPref;
	RETAIN PreviousTm;
	DROP   PreviousTm;
	RETAIN PreviousRptTm;
	DROP   PreviousRptTm;
	RETAIN PreviousGS;
	DROP   PreviousGS;
/*	RETAIN PreviousCEU;
	DROP   PreviousCEU;
	RETAIN PreviousCUC;
	DROP   PreviousCUC;
	RETAIN PreviousFGC;
	DROP   PreviousFGC;
	RETAIN PreviousFG;
	DROP   PreviousFG;
	RETAIN PreviousGL;
	DROP   PreviousGL;
	RETAIN PreviousVGC;
	DROP   PreviousVGC;
	RETAIN PreviousVGCO;
	DROP   PreviousVGCO;
	RETAIN PreviousVGD;
	DROP   PreviousVGD;
	RETAIN PreviousRegM;
	DROP   PreviousRegM;*/
	RETAIN PreviousClsNum;
	DROP   PreviousClsNum;
	RETAIN PreviousProg;
	DROP   PreviousProg;
	RETAIN PreviousClsID;
	DROP   PreviousClsID;
  IF ADCPersonID EQ ' ' AND ADCStuCourseDash EQ ' ' 
     THEN ADCStuCourseDash=PreviousCNDash;
     ELSE PreviousCNDash=ADCStuCourseDash;
  IF ADCPersonID EQ ' ' AND ADCStuClsSection EQ ' ' 
     THEN ADCStuClsSection=Previoussec;
     ELSE Previoussec=ADCStuClsSection;
  IF ADCPersonID EQ ' ' AND ADCStuClsPrefix EQ ' ' 
     THEN ADCStuClsPrefix=PreviousPref;
     ELSE PreviousPref=ADCStuClsPrefix;
  IF ADCPersonID EQ ' ' AND ADCStuClsTerm EQ ' ' 
     THEN ADCStuClsTerm=PreviousTm;
     ELSE PreviousTm=ADCStuClsTerm;
  IF ADCPersonID EQ ' ' AND ADCStuClsReportTerm EQ ' ' 
     THEN ADCStuClsReportTerm=PreviousRptTm;
     ELSE PreviousRptTm=ADCStuClsReportTerm;
  IF ADCPersonID EQ ' ' AND ADCStuClsGradeScheme EQ ' ' 
     THEN ADCStuClsGradeScheme=PreviousGS;
     ELSE PreviousGS=ADCStuClsGradeScheme;
/*  IF ADCStuRegCEUnits EQ .
     THEN ADCStuRegCEUnits=PreviousCEU;
     ELSE PreviousCEU=ADCStuRegCEUnits;
  IF ADCStuRegCUCredits EQ .
     THEN ADCStuRegCUCredits=PreviousCUC;
     ELSE PreviousCUC=ADCStuRegCUCredits;
  IF ADCStuClsFinalGradeCode EQ ' ' 
     THEN ADCStuClsFinalGradeCode=PreviousFGC;
     ELSE PreviousFGC=ADCStuClsFinalGradeCode;
  IF ADCStuClsFinalGrade EQ ' ' 
     THEN ADCStuClsFinalGrade=PreviousFG;
     ELSE PreviousFG=ADCStuClsFinalGrade;
  IF ADCStuClsGradeLegend EQ ' ' 
     THEN ADCStuClsGradeLegend=PreviousGL;
     ELSE PreviousGL=ADCStuClsGradeLegend;
  IF ADCStuClsVrfdGradeCode EQ ' ' 
     THEN ADCStuClsVrfdGradeCode=PreviousVGC;
     ELSE PreviousVGC=ADCStuClsVrfdGradeCode;
  IF ADCStuClsVrfdGradeChgOpr EQ ' ' 
     THEN ADCStuClsVrfdGradeChgOpr=PreviousVGCO;
     ELSE PreviousVGCO=ADCStuClsVrfdGradeChgOpr;
  IF ADCStuClsVrfdGradeDate EQ ' ' 
     THEN ADCStuClsVrfdGradeDate=PreviousVGD;
     ELSE PreviousVGD=ADCStuClsVrfdGradeDate;
  IF ADCStuClsRegMethod EQ ' ' 
     THEN ADCStuClsRegMethod=PreviousRegM;
     ELSE PreviousRegM=ADCStuClsRegMethod;*/
  IF ADCPersonID EQ ' ' AND ADCStuClsNumber EQ ' ' 
     THEN ADCStuClsNumber=PreviousClsNum;
     ELSE PreviousClsNum=ADCStuClsNumber;
  IF ADCPersonID EQ ' ' AND ADCStuPrimaryProgramCode EQ ' ' 
     THEN ADCStuPrimaryProgramCode=PreviousProg;
     ELSE PreviousProg=ADCStuPrimaryProgramCode;
  IF ADCPersonID EQ ' ' AND ADCClsID EQ ' ' 
     THEN ADCClsID=PreviousClsID;
     ELSE PreviousClsID=ADCClsID;
  IF ADCPersonID EQ ' ' 
     THEN ADCPersonID=PreviousID;
     ELSE PreviousID=ADCPersonID;
*PROC SORT DATA=repeat09flds1a; *BY ADCPersonID;
*PROC PRINT DATA=repeat09flds1a;
RUN;

* END - SECTION 9a2 - REPEATS NECESSARY VARIABLE VALUES FOR SECTION 9a *;

* BEGIN - SECTION 9b - SELECTS ONLY CURRENT TERM RECORDS AND UNDUPLICATES FOR SECTION 9a2 *;

DATA st09downb1;
RETAIN	Class;
FORMAT 	Class $15.;
SET repeat09flds1a;
IF ADCStuClsTerm NE "&rt01"
	AND ADCStuClsTerm NE "&rt02"
	THEN DELETE;
/* BEGIN CORRECTIONS FOR SUMMER 2015 */
/*	
IF ADCPersonID IN (
					'1374887',
					'2516915',
					'3218785',
					'3809684',
					'3901331'
					)
AND ADCClsID EQ '164883' THEN ADCStuClsSection='G01';
*/
/* END CORRECTIONS FOR SUMMER 2015 */

/*BEGIN CORRECTION 1 FOR 201601_R5, 201601_R4 - ERRONEOUS SECTION NUMBER for PTA13501 (IN STUDENT FILE AS PTA13501111)*/
	IF ADCStuClsPrefix EQ "PTA" AND ADCStuClsNumber EQ "135" AND ADCStuClsSection EQ "01111" 
		THEN ADCStuClsSection="01";
		ELSE ADCStuClsSection=ADCStuClsSection;	
/*END   CORRECTION 1 FOR 201601_R5 - ERRONEOUS SECTION NUMBER for PTA13501 (IN STUDENT FILE AS PTA13501111)*/

Class=(TRIM(LEFT(ADCStuClsPrefix)))||(TRIM(LEFT(ADCStuClsNumber)))||(TRIM(LEFT(ADCStuClsSection)));
Class=(UPCASE(Class));
*CORRECTIONS FOR FALL 2011 ET Dataset;
/*
IF ADCPersonID EQ '0094622' AND Class EQ 'PSX795202' THEN Class='PSX7952L';
IF ADCPersonID EQ '0295921' AND Class EQ 'PSX795202' THEN Class='PSX7952L';
IF ADCPersonID EQ '0807356' AND Class EQ 'PSX795202' THEN Class='PSX7952L';
IF ADCPersonID EQ '1027376' AND Class EQ 'PSX795202' THEN Class='PSX7952L';
IF ADCPersonID EQ '1588616' AND Class EQ 'PSX795202' THEN Class='PSX7952L';
IF ADCPersonID EQ '2126459' AND Class EQ 'PSX795202' THEN Class='PSX7952L';
IF ADCPersonID EQ '2309354' AND Class EQ 'PSX795202' THEN Class='PSX7952L';
IF ADCPersonID EQ '2327663' AND Class EQ 'PSX795202' THEN Class='PSX7952L';
IF ADCPersonID EQ '2344124' AND Class EQ 'PSX795202' THEN Class='PSX7952L';
IF ADCPersonID EQ '2641720' AND Class EQ 'PSX795202' THEN Class='PSX7952L';
IF ADCPersonID EQ '2677267' AND Class EQ 'PSX795202' THEN Class='PSX7952L';
IF ADCPersonID EQ '2688883' AND Class EQ 'PSX795202' THEN Class='PSX7952L';
IF ADCPersonID EQ '2697310' AND Class EQ 'PSX795202' THEN Class='PSX7952L';
IF ADCPersonID EQ '3349354' AND Class EQ 'PSX795202' THEN Class='PSX7952L';
IF ADCPersonID EQ '3576999' AND Class EQ 'PSX795202' THEN Class='PSX7952L';
IF ADCPersonID EQ '3649150' AND Class EQ 'PSX795202' THEN Class='PSX7952L';
IF ADCPersonID EQ '3649160' AND Class EQ 'PSX795202' THEN Class='PSX7952L';
IF ADCPersonID EQ '3650698' AND Class EQ 'PSX795202' THEN Class='PSX7952L';
IF ADCPersonID EQ '3687667' AND Class EQ 'PSX795202' THEN Class='PSX7952L';
IF ADCPersonID EQ '3687836' AND Class EQ 'PSX795202' THEN Class='PSX7952L';
IF ADCPersonID EQ '3695938' AND Class EQ 'PSX795202' THEN Class='PSX7952L';
IF ADCPersonID EQ '3719089' AND Class EQ 'PSX795202' THEN Class='PSX7952L';
IF ADCPersonID EQ '3719507' AND Class EQ 'PSX795202' THEN Class='PSX7952L';
IF ADCPersonID EQ '3735639' AND Class EQ 'PSX795202' THEN Class='PSX7952L';
IF ADCPersonID EQ '3762294' AND Class EQ 'PSX795202' THEN Class='PSX7952L';
IF ADCPersonID EQ '3778222' AND Class EQ 'PSX795202' THEN Class='PSX7952L';
IF ADCPersonID EQ '3790692' AND Class EQ 'PSX795202' THEN Class='PSX7952L';
*/
*END CORRECTION FOR FALL 2011 ET;
RUN;


DATA st09downb2;
SET st09downb1;
PROC SORT NODUPKEY DATA=st09downb2; BY ADCPersonID ADCClsID;
PROC SORT DATA=st09downb2; BY ADCPersonID Class;
/*PROC SORT DATA=st09downb2; BY ADCPersonID ClassDash;*/
*PROC FREQ DATA=st09downb2 ORDER=FREQ;
*	TABLES ADCPersonID / NOCOL NOCUM NOPERCENT NOROW;
RUN;

PROC SORT DATA=ST09DOWNB2; BY ADCStuClsVrfdGradeCode;
run;

Data gradexwalk;
set "&Pathxwk&Infilexw";
If "&II01"=InstID;
PROC SORT DATA=GRADEXWALK; BY ADCStuClsVrfdGradeCode;
run;

Data ST09DOWNB3;
	MERGE
		ST09DOWNB2 (IN=A)
		GRADEXWALK;
		BY ADCStuClsVrfdGradeCode;
		IF A;
RUN;

* END - SECTION 9b - SELECTS ONLY CURRENT TERM RECORDS AND UNDUPLICATES FOR SECTION 9a2 *;

* BEGIN - SECTION 9c - CREATES ExitCode AND ExitTranslation VARIABLES FOR SECTION 9b *;

DATA st09downc;
RETAIN	ExitCode
		ExitTranslation;
FORMAT 	ExitCode $5. 
		ExitTranslation $15.;
SET st09downb3;
IF ADCStuClsStatus EQ 'N' 
	OR ADCStuClsStatus EQ 'A'
	THEN ExitCode=ADCStuClsVrfdGradeCode;
	ELSE IF ADCStuClsVrfdGradeCode NE ' ' THEN ExitCode=ADCStuClsVrfdGradeCode;
	ELSE IF ADCStuClsStatus EQ 'C' THEN ExitCode='CC';
	ELSE IF ADCStuClsStatus EQ 'D' THEN ExitCode='DA';
	ELSE IF ADCStuClsStatus EQ 'NC' THEN ExitCode='NC';
	ELSE IF ADCStuClsStatus EQ 'NP' THEN ExitCode='NP';
	ELSE IF ADCStuClsStatus EQ 'PR' THEN ExitCode='PR';
	ELSE IF ADCStuClsStatus EQ 'TR' THEN ExitCode='TR';
	ELSE IF ADCStuClsStatus EQ 'W' THEN ExitCode='DW';
	ELSE IF ADCStuClsStatus EQ 'X' THEN ExitCode='DX';
	ELSE IF ADCStuClsStatus EQ 'XT' THEN ExitCode='XT';
	ELSE ExitCode=ADCStuClsVrfdGradeCode;
/*IF ExitCode EQ '1' THEN ExitTranslation='A';
	ELSE IF ExitCode EQ '2' THEN ExitTranslation='B';
	ELSE IF ExitCode EQ '3' THEN ExitTranslation='C';
	ELSE IF ExitCode EQ '4' THEN ExitTranslation='D';
	ELSE IF ExitCode EQ '5' THEN ExitTranslation='I/A';
	ELSE IF ExitCode EQ '6' THEN ExitTranslation='F';
	ELSE IF ExitCode EQ '7' THEN ExitTranslation='I';
	ELSE IF ExitCode EQ '8' THEN ExitTranslation='I/B';
	ELSE IF ExitCode EQ '9' THEN ExitTranslation='Audit';
	ELSE IF ExitCode EQ '15' THEN ExitTranslation='S';
	ELSE IF ExitCode EQ '16' THEN ExitTranslation='U';
	ELSE IF ExitCode EQ '17' THEN ExitTranslation='W';
	ELSE IF ExitCode EQ '19' THEN ExitTranslation='A';
	ELSE IF ExitCode EQ '20' THEN ExitTranslation='B';
	ELSE IF ExitCode EQ '21' THEN ExitTranslation='C';
	ELSE IF ExitCode EQ '22' THEN ExitTranslation='D';
	ELSE IF ExitCode EQ '23' THEN ExitTranslation='F';
	ELSE IF ExitCode EQ '24' THEN ExitTranslation='S';
	ELSE IF ExitCode EQ '25' THEN ExitTranslation='U';
	ELSE IF ExitCode EQ '26' THEN ExitTranslation='W';
	ELSE IF ExitCode EQ '27' THEN ExitTranslation='I/C';
	ELSE IF ExitCode EQ '28' THEN ExitTranslation='I/D';
	ELSE IF ExitCode EQ '29' THEN ExitTranslation='I/F';
	ELSE IF ExitCode EQ '30' THEN ExitTranslation='Credit By Exam';
	ELSE IF ExitCode EQ '31' THEN ExitTranslation='W';
	ELSE IF ExitCode EQ '32' THEN ExitTranslation='I';
	ELSE IF ExitCode EQ '39' THEN ExitTranslation='I/R';
	ELSE IF ExitCode EQ '40' THEN ExitTranslation='Audit';
	ELSE IF ExitCode EQ '41' THEN ExitTranslation='No Grade';
	ELSE IF ExitCode EQ '42' THEN ExitTranslation='Transfer Credit';
	ELSE IF ExitCode EQ '43' THEN ExitTranslation='Pass';
	ELSE IF ExitCode EQ '44' THEN ExitTranslation='I/M';
	ELSE IF ExitCode EQ '45' THEN ExitTranslation='Credit By Exam';
	ELSE IF ExitCode EQ '46' THEN ExitTranslation='I/A';
	ELSE IF ExitCode EQ '47' THEN ExitTranslation='I/B';
	ELSE IF ExitCode EQ '48' THEN ExitTranslation='I/C';
	ELSE IF ExitCode EQ '49' THEN ExitTranslation='I/D';
	ELSE IF ExitCode EQ '50' THEN ExitTranslation='I/F';
	ELSE IF ExitCode EQ '51' THEN ExitTranslation='I/A';
	ELSE IF ExitCode EQ '52' THEN ExitTranslation='I/B';
	ELSE IF ExitCode EQ '53' THEN ExitTranslation='I/C';
	ELSE IF ExitCode EQ '54' THEN ExitTranslation='I/D';
	ELSE IF ExitCode EQ '55' THEN ExitTranslation='I/F';
	ELSE IF ExitCode EQ '57' THEN ExitTranslation='I';
	ELSE IF ExitCode EQ '58' THEN ExitTranslation='Credit By Exam';
	ELSE IF ExitCode EQ '60' THEN ExitTranslation='Audit';
	ELSE IF ExitCode EQ '61' THEN ExitTranslation='Transfer Credit';
	ELSE IF ExitCode EQ '62' THEN ExitTranslation='Pass';
	ELSE IF ExitCode EQ '63' THEN ExitTranslation='I/M';
	ELSE IF ExitCode EQ '64' THEN ExitTranslation='S';
	ELSE IF ExitCode EQ '65' THEN ExitTranslation='Pass';
	ELSE IF ExitCode EQ '66' THEN ExitTranslation='U';
	ELSE IF ExitCode EQ '67' THEN ExitTranslation='I/R';
	ELSE IF ExitCode EQ '68' THEN ExitTranslation='No Grade';
	ELSE IF ExitCode EQ '69' THEN ExitTranslation='Transfer Credit';
	ELSE IF ExitCode EQ '70' THEN ExitTranslation='I/M';
	ELSE IF ExitCode EQ '72' THEN ExitTranslation='I/R';
	ELSE IF ExitCode EQ '73' THEN ExitTranslation='WN';
	ELSE IF ExitCode EQ '74' THEN ExitTranslation='WN';
	ELSE IF ExitCode EQ '75' THEN ExitTranslation='WN';
	ELSE IF ExitCode EQ '76' THEN ExitTranslation='A';
	ELSE IF ExitCode EQ '77' THEN ExitTranslation='B';
	ELSE IF ExitCode EQ '78' THEN ExitTranslation='C';
	ELSE IF ExitCode EQ '79' THEN ExitTranslation='D';
	ELSE IF ExitCode EQ '80' THEN ExitTranslation='F';
	ELSE IF ExitCode EQ '82' THEN ExitTranslation='Transfer Credit';
	ELSE IF ExitCode EQ '84' THEN ExitTranslation='P';
	ELSE IF ExitCode EQ '85' THEN ExitTranslation='R';
	ELSE IF ExitCode EQ '86' THEN ExitTranslation='Audit';
	ELSE IF ExitCode EQ '87' THEN ExitTranslation='W';
	ELSE IF ExitCode EQ '88' THEN ExitTranslation='WN';
	ELSE IF ExitCode EQ '93' THEN ExitTranslation='P';
	ELSE IF ExitCode EQ '94' THEN ExitTranslation='R';*/
IF ExitCode EQ ADCStuClsVrfdGradeCode AND ExitCode NE ' ' AND  ADCStuClsVrfdGradeCode NE ' ' then Exittranslation=ADCStuClsVrfdGrade;
	ELSE IF ExitCode EQ 'NC' THEN ExitTranslation='NC';
	ELSE IF ExitCode EQ '  ' THEN ExitTranslation='Blank';
	ELSE IF ExitCode EQ 'CC' THEN ExitTranslation='Cancelled Class';
	ELSE IF ExitCode EQ 'DA' THEN ExitTranslation='DADrop';
	ELSE IF ExitCode EQ 'NC' THEN ExitTranslation='NonCourseEquiv';
	ELSE IF ExitCode EQ 'NP' THEN ExitTranslation='Non-Payment';
	ELSE IF ExitCode EQ 'PR' THEN ExitTranslation='PrelimEquivEval';
	ELSE IF ExitCode EQ 'TR' THEN ExitTranslation='TransEquivEval';
	ELSE IF ExitCode EQ 'DW' THEN ExitTranslation='W';
	ELSE IF ExitCode EQ 'DX' THEN ExitTranslation='XDrop';
	ELSE IF ExitCode EQ 'XT' THEN ExitTranslation='ExtTransEquiv';
	ELSE IF ExitCode EQ '0' THEN ExitTranslation='Mid-Term Unsatisfactory';
	ELSE ExitTranslation='Unknown';
*PROC FREQ DATA=st09downc;
*	TABLES ExitTranslation;
PROC SORT DATA =st09downc; BY ADCPERSONID;
RUN;

* END - SECTION 9c - CREATES ExitCode AND ExitTranslation VARIABLES FOR SECTION 9b *;


* BEGIN - SECTION 9d -  CREATES TotalCUCrdits AND TotalCEUs Variables 
		AND CALCULATES STUDENT TOTAL CU CREDITS AND CEUs FOR SECTION 9b *;

DATA st09downd;
RETAIN TotalCUCredits
		TotalCEUs;
FORMAT TotalCUCredits 8.2
		TotalCEUs 6.2;
SET st09downc;
IF (ADCStuClsStatus EQ 'N'
	OR ADCStuClsStatus EQ 'A')
	AND (ExitTranslation NE 'W'
	AND ExitTranslation NOT IN (
								'WN',
								'NA',
								'NG'
								))
	THEN TotalCUCredits=ADCStuRegCUCredits;
	ELSE TotalCUCredits=0;
IF (ADCStuClsStatus EQ 'N'
	OR ADCStuClsStatus EQ 'A')
	AND (ExitTranslation NE 'W'
	AND ExitTranslation NOT IN (
								'WN',
								'NA',
								'NG'
								))
	THEN TotalCEUs=ADCStuRegCEUnits;
	ELSE TotalCEUs=0;
PROC SUMMARY DATA=st09downd; BY ADCPersonID;
	VAR TotalCUCredits TotalCEUs;
OUTPUT OUT=st09dout SUM=TotalCUCredits TotalCEUs;
*PROC PRINT DATA=st09dout;
RUN;

* END - SECTION 9d -  CREATES TotalCUCrdits AND TotalCEUs Variables 
		AND CALCULATES STUDENT TOTAL CU CREDITS AND CEUs FOR SECTION 9b *;


* BEGIN - SECTION 9collapse - COLLAPSES MULTIPLE CLASSES DATA INTO ARRAYS FOR SECTION 9c *;

DATA st09collapse (KEEP=
					ADCPersonID 
					ADCStuPrimaryProgramCode
/*					ADCStuClsFinalGradeCode&ar01b-ADCStuClsFinalGradeCode&ar01e
					ADCStuClsFinalGrade&ar01b-ADCStuClsFinalGrade&ar01e
					ADCStuClsGradeLegend&ar01b-ADCStuClsGradeLegend&ar01e
					ADCStuClsGradeScheme&ar01b-ADCStuClsGradeScheme&ar01e */
					ADCStuClsStatusReason&ar01b-ADCStuClsStatusReason&ar01e
					ADCStuClsRegMethod&ar01b-ADCStuClsRegMethod&ar01e
					ADCStuClsTerm
					ADCStuClsReportTerm
					ADCStuClsStatus&ar01b-ADCStuClsStatus&ar01e
					ADCStuClsStatusDate&ar01b-ADCStuClsStatusDate&ar01e
					ADCStuClsStatusTime&ar01b-ADCStuClsStatusTime&ar01e
					ADCStuClsVrfdGradeChgOpr&ar01b-ADCStuClsVrfdGradeChgOpr&ar01e
					ADCStuClsVrfdGradeDate&ar01b-ADCStuClsVrfdGradeDate&ar01e
					ADCStuClsVrfdGradeCode&ar01b-ADCStuClsVrfdGradeCode&ar01e
					Class&ar01b-Class&ar01e
					ADCClsID&ar01b-ADCClsID&ar01e
					ExitTranslation&ar01b-ExitTranslation&ar01e
);
RETAIN
				/*	ADCStuClsFinalGradeCode&ar01b-ADCStuClsFinalGradeCode&ar01e
					ADCStuClsFinalGrade&ar01b-ADCStuClsFinalGrade&ar01e
					ADCStuClsGradeLegend&ar01b-ADCStuClsGradeLegend&ar01e
					ADCStuClsGradeScheme&ar01b-ADCStuClsGradeScheme&ar01e */
					ADCStuClsRegMethod&ar01b-ADCStuClsRegMethod&ar01e
					ADCStuClsTerm&ar01b-ADCStuClsTerm&ar01e
					ADCStuClsReportTerm&ar01b-ADCStuClsReportTerm&ar01e
					ADCStuClsStatus&ar01b-ADCStuClsStatus&ar01e
					ADCStuClsStatusDate&ar01b-ADCStuClsStatusDate&ar01e
					ADCStuClsStatusTime&ar01b-ADCStuClsStatusTime&ar01e
					ADCStuClsStatusReason&ar01b-ADCStuClsStatusReason&ar01e
					ADCStuClsVrfdGradeChgOpr&ar01b-ADCStuClsVrfdGradeChgOpr&ar01e
					ADCStuClsVrfdGradeDate&ar01b-ADCStuClsVrfdGradeDate&ar01e
					ADCStuClsVrfdGradeCode&ar01b-ADCStuClsVrfdGradeCode&ar01e
					Class&ar01b-Class&ar01e
					ADCClsID&ar01b-ADCClsID&ar01e
					ExitTranslation&ar01b-ExitTranslation&ar01e
;
/*	ARRAY	fgc (&ar01e) $		ADCStuClsFinalGradeCode&ar01b-ADCStuClsFinalGradeCode&ar01e;
	ARRAY	fgr (&ar01e) $		ADCStuClsFinalGrade&ar01b-ADCStuClsFinalGrade&ar01e;
	ARRAY	fgl (&ar01e) $		ADCStuClsGradeLegend&ar01b-ADCStuClsGradeLegend&ar01e;
	ARRAY	ags (&ar01e) $		ADCStuClsGradeScheme&ar01b-ADCStuClsGradeScheme&ar01e; */
	ARRAY	arm (&ar01e) $7.	ADCStuClsRegMethod&ar01b-ADCStuClsRegMethod&ar01e;
	ARRAY	trm (&ar01e) $7.	ADCStuClsTerm&ar01b-ADCStuClsTerm&ar01e;
	ARRAY	rtm (&ar01e) $7.	ADCStuClsReportTerm&ar01b-ADCStuClsReportTerm&ar01e;
	ARRAY	sta (&ar01e) $4.	ADCStuClsStatus&ar01b-ADCStuClsStatus&ar01e;
	ARRAY	sdt (&ar01e) $10.	ADCStuClsStatusDate&ar01b-ADCStuClsStatusDate&ar01e;
	ARRAY	stt (&ar01e) $9.	ADCStuClsStatusTime&ar01b-ADCStuClsStatusTime&ar01e;
	ARRAY	rea (&ar01e) $4.	ADCStuClsStatusReason&ar01b-ADCStuClsStatusReason&ar01e;
	ARRAY	vgb (&ar01e) $8.	ADCStuClsVrfdGradeChgOpr&ar01b-ADCStuClsVrfdGradeChgOpr&ar01e;
	ARRAY	vgd (&ar01e) $10.	ADCStuClsVrfdGradeDate&ar01b-ADCStuClsVrfdGradeDate&ar01e;
	ARRAY	vgc (&ar01e) $4.	ADCStuClsVrfdGradeCode&ar01b-ADCStuClsVrfdGradeCode&ar01e;
	ARRAY	cla (&ar01e) $24.	Class&ar01b-Class&ar01e;
	ARRAY	cid (&ar01e) $7.	ADCClsID&ar01b-ADCClsID&ar01e;
	ARRAY	ext (&ar01e) $15.	ExitTranslation&ar01b-ExitTranslation&ar01e;
	SET st09downc; BY ADCPersonID;
	IF FIRST.ADCPersonID THEN DO;
		i=1;
		DO j=1 TO &ar01e;
/*			fgc(j)=' ';
			fgr(j)=' ';
			fgl(j)=' ';
			ags(j)=' '; */
			arm(j)=' ';
			rtm(j)=' ';
			trm(j)=' ';
			sta(j)=' ';
			sdt(j)=' ';
			stt(j)=' ';
			rea(j)=' ';
			vgb(j)=' ';
			vgd(j)=' ';
			vgc(j)=' ';
			cla(j)=' ';
			cid(j)=' ';
			ext(j)=' ';
		END;
	END;
/*	fgc(i)=ADCStuClsFinalGradeCode;
	fgr(i)=ADCStuClsFinalGrade;
	fgl(i)=ADCStuClsGradeLegend;
	ags(i)=ADCStuClsGradeScheme; */
	arm(i)=ADCStuClsRegMethod;
	trm(i)=ADCStuClsTerm;
	rtm(i)=ADCStuClsReportTerm;
	sta(i)=ADCStuClsStatus;
	sdt(i)=ADCStuClsStatusDate;
	stt(i)=ADCStuClsStatusTime;
	rea(i)=ADCStuClsStatusReason;
	vgb(i)=ADCStuClsVrfdGradeChgOpr;
	vgd(i)=ADCStuClsVrfdGradeDate;
	vgc(i)=ADCStuClsVrfdGradeCode;
	cla(i)=Class;
	cid(i)=ADCClsID;
	ext(i)=ExitTranslation;
	IF LAST.ADCPersonID THEN OUTPUT;
	i+1;
*PROC PRINT DATA=st09collapse;
RUN;

*PROC CONTENTS DATA=st09collapse;
*RUN;

* END - SECTION 9collapse - COLLAPSES MULTIPLE CLASSES DATA INTO ARRAYS FOR SECTION 9c *;

* BEGIN - SECTION 9e - MERGES TOTCREDHRS AND TOTCEUS INTO 09Collapse *;
DATA st09downe;
	MERGE st09collapse(IN=a) st09dout(IN=b); 
	BY ADCPersonID;
	IF a*b=1;
RUN;

* END - SECTION 9e - MERGES TOTCREDHRS AND TOTCEUS INTO 9Collapse *;


* BEGIN - SECTION st02downa - INFILE FOR st02Down *;

DATA st02downa (KEEP=
					ADCPersonID 
					ADCStuSSN
					ADCStuCitizenship
					ADCStuAltIDs
					ADCStuLastName
					ADCStuFirstName
					ADCStuMiddleName
					ADCStuNameSuffix
					ADCStuPreviousLastNames
					ADCStuMailAddress1
					ADCStuMailCity
					ADCStuMailState
					ADCStuMailZip
					ADCStuCounty
					ADCStuMailAddress1Type
					ADCStuPersonalPhone
					ADCStuPersonalPhoneType
					ADCStuEmergencyPhone
					ADCStuBirthDate
					ADCStuEthnicOLD
					ADCStuGender
					ADCStuMailingCountry
					ADCStuResidenceCountry
					ADCStuResidenceState
					ADCStuEmploymentStatus
					ADCStuVeteranType
					ADCStuDeceasedDate
					ADCStuDriverLicenseState
					ADCStuDriverLicenseNumber
					ADCStuMaritalStatus
					ADCStuEMailAddress
					ADCStuEMailType
					ADCStuPrivacyFlag
					ADCStuVisaType
					ADCStuAddDate
					ADCStuAddOpr
					ADCStuChgDate
					ADCStuChgOpr
					ADCStuEthnic
					ADCStuRaces
					ADCStuPrimaryEthnic
					ADCStuPrimaryRace
);
INFILE "&Path00&Infile02"  LINESIZE=800 TRUNCOVER;
INPUT @1 ADCPersonID $10. @;
	SELECT;
	WHEN (ADCPersonID NE 'PERSON ') DO;
		INPUT @1	ADCPersonID					$10.
			@11		ADCStuSSN					$11.
			@22		ADCStuCitizenship			$3.
			@33		ADCStuAltIDs				$13.
			@63		ADCStuLastName 				$25.
			@88		ADCStuFirstName				$15.
			@103	ADCStuMiddleName			$15.
			@118	ADCStuNameSuffix			$15.
			@143	ADCStuPreviousLastNames		$25.
			@168	ADCStuMailAddress1			$30.
			@198	ADCStuMailCity				$25.
			@223	ADCStuMailState				$4.
			@228	ADCStuMailZip				$10.
			@238	ADCStuCounty				$5.
			@268	ADCStuMailAddress1Type		$20.
			@288	ADCStuPersonalPhone			$12.
			@309	ADCStuPersonalPhoneType		$6.
			@328	ADCStuEmergencyPhone		$14.
			@346	ADCStuBirthDate				$10.
			@356	ADCStuEthnicOLD				$3.
			@362	ADCStuGender				$3.
			@368	ADCStuMailingCountry		$3.
			@388	ADCStuResidenceCountry		$3.
			@408	ADCStuResidenceState		$3.
			@438	ADCStuEmploymentStatus		$3.
			@463	ADCStuVeteranType			$10.
			@483	ADCStuDeceasedDate			$10.
			@496	ADCStuDriverLicenseState	$3.
			@511	ADCStuDriverLicenseNumber	$15.
			@526	ADCStuMaritalStatus			$3.
			@540	ADCStuEMailAddress			$50.
			@590	ADCStuEMailType				$5.
			@601	ADCStuPrivacyFlag			$2.
			@626	ADCStuVisaType				$3.
			@656	ADCStuAddDate				$10.
			@671	ADCStuAddOpr				$10.
			@690	ADCStuChgDate				$10.
			@708	ADCStuChgOpr				$10.
			@730	ADCStuEthnic				$4.
			@740	ADCStuRaces					$4.
			@750	ADCStuPrimaryEthnic			$4.
			@764	ADCStuPrimaryRace			$4.
;
		OUTPUT st02downa;
	END;
	OTHERWISE DO;
	PUT 'Error in record ' _n_ 'as follows:' _INFILE_;
		DELETE;
	END;
END;
RUN;

* END - SECTION st02downa - INFILE FOR st02Down *;


* BEGIN - SECTION st02downb - REPEATS MISSING VARIABLES FOR st02downa *;

DATA st02downb;
RETAIN	ID;
DROP	ID;
RETAIN	SIN;
DROP	SIN;
RETAIN	CIT;
DROP	CIT;
RETAIN	AID;
DROP	AID;
RETAIN	SLN;
DROP	SLN;
RETAIN	SFN;
DROP	SFN;
RETAIN	SMN;
DROP	SMN;
RETAIN	SNS;
DROP	SNS;
RETAIN	SPN;
DROP	SPN;
RETAIN	SMA1;
DROP	SMA1;
RETAIN	SMC;
DROP	SMC;
RETAIN	SMS;
DROP	SMS;
RETAIN	SMZ;
DROP	SMZ;
RETAIN	SCY;
DROP	SCY;
RETAIN	SEP;
DROP	SEP;
RETAIN	SBD;
DROP	SBD;
RETAIN	SET;
DROP	SET;
RETAIN	SGE;
DROP	SGE;
RETAIN	SCO;
DROP	SCO;
RETAIN	SRC;
DROP	SRC;
RETAIN	SRS;
DROP	SRS;
RETAIN	SES;
DROP	SES;
RETAIN	SVT;
DROP	SVT;
RETAIN	SDD;
DROP	SDD;
RETAIN	SLS;
DROP	SLS;
RETAIN	SLNO;
DROP	SLNO;
RETAIN	SMST;
DROP	SMST;
RETAIN	SPF;
DROP	SPF;
RETAIN	SVST;
DROP	SVST;
RETAIN	SAD;
DROP	SAD;
RETAIN	SAO;
DROP	SAO;
RETAIN	SCD;
DROP	SCD;
RETAIN	SCY;
DROP	SCY;
RETAIN	SETH;
DROP	SETH;
RETAIN	SPE;
DROP	SPE;
RETAIN	SPR;
DROP	SPR;
RETAIN	BirthDate;
FORMAT BirthYear1 $4.
		BirthMonth1 $2.
		BirthDay1 $2.
		BirthDate $8.;
SET st02downa;
  IF ADCPersonID EQ ' ' AND ADCStuSSN EQ ' '
     THEN ADCStuSSN=SIN;
     ELSE SIN=ADCStuSSN;
  IF ADCPersonID EQ ' ' AND ADCStuCitizenship EQ ' '
     THEN ADCStuCitizenship=CIT;
     ELSE CIT=ADCStuCitizenship;
  IF ADCPersonID EQ ' ' AND ADCStuAltIDs EQ ' '
     THEN ADCStuAltIDs=AID;
     ELSE AID=ADCStuAltIDs;
  IF ADCPersonID EQ ' ' AND ADCStuLastName EQ ' '
     THEN ADCStuLastName=SLN;
     ELSE SLN=ADCStuLastName;
  IF ADCPersonID EQ ' ' AND ADCStuFirstName EQ ' '
     THEN ADCStuFirstName=SFN;
     ELSE SFN=ADCStuFirstName;
  IF ADCPersonID EQ ' ' AND ADCStuMiddleName EQ ' '
     THEN ADCStuMiddleName=SMN;
     ELSE SMN=ADCStuMiddleName;
  IF ADCPersonID EQ ' ' AND ADCStuNameSuffix EQ ' '
     THEN ADCStuNameSuffix=SNS;
     ELSE SNS=ADCStuNameSuffix;
  IF ADCPersonID EQ ' ' AND ADCStuPreviousLastNames EQ ' '
     THEN ADCStuPreviousLastNames=SPN;
     ELSE SPN=ADCStuPreviousLastNames;
  IF ADCPersonID EQ ' ' AND ADCStuMailAddress1 EQ ' '
     THEN ADCStuMailAddress1=SMA1;
     ELSE SMA1=ADCStuMailAddress1;
  IF ADCPersonID EQ ' ' AND ADCStuMailCity EQ ' '
     THEN ADCStuMailCity=SMC;
     ELSE SMC=ADCStuMailCity;
  IF ADCPersonID EQ ' ' AND ADCStuMailState EQ ' '
     THEN ADCStuMailState=SMS;
     ELSE SMS=ADCStuMailState;
  IF ADCPersonID EQ ' ' AND ADCStuMailZip EQ ' '
     THEN ADCStuMailZip=SMZ;
     ELSE SMZ=ADCStuMailZip;
  IF ADCPersonID EQ ' ' AND ADCStuCounty EQ ' '
     THEN ADCStuCounty=SCY;
     ELSE SCY=ADCStuCounty;
  IF ADCPersonID EQ ' ' AND ADCStuEmergencyPhone EQ ' '
     THEN ADCStuEmergencyPhone=SEP;
     ELSE SEP=ADCStuEmergencyPhone;
  IF ADCPersonID EQ ' ' AND ADCStuBirthDate EQ ' '
     THEN ADCStuBirthDate=SBD;
     ELSE SBD=ADCStuBirthDate;
  IF ADCPersonID EQ ' ' AND ADCStuEthnicOLD EQ ' '
     THEN ADCStuEthnicOLD=SET;
     ELSE SET=ADCStuEthnicOLD;
  IF ADCPersonID EQ ' ' AND ADCStuGender EQ ' '
     THEN ADCStuGender=SGE;
     ELSE SGE=ADCStuGender;
  IF ADCPersonID EQ ' ' AND ADCStuMailingCountry EQ ' '
     THEN ADCStuMailingCountry=SCO;
     ELSE SCO=ADCStuMailingCountry;
  IF ADCPersonID EQ ' ' AND ADCStuResidenceCountry EQ ' '
     THEN ADCStuResidenceCountry=SRC;
     ELSE SRC=ADCStuResidenceCountry;
  IF ADCPersonID EQ ' ' AND ADCStuResidenceState EQ ' '
     THEN ADCStuResidenceState=SRS;
     ELSE SRS=ADCStuResidenceState;
  IF ADCPersonID EQ ' ' AND ADCStuEmploymentStatus EQ ' '
     THEN ADCStuEmploymentStatus=SES;
     ELSE SES=ADCStuEmploymentStatus;
  IF ADCPersonID EQ ' ' AND ADCStuVeteranType EQ ' '
     THEN ADCStuVeteranType=SVT;
     ELSE SVT=ADCStuVeteranType;
  IF ADCPersonID EQ ' ' AND ADCStuDeceasedDate EQ ' '
     THEN ADCStuDeceasedDate=SDD;
     ELSE SDD=ADCStuDeceasedDate;
  IF ADCPersonID EQ ' ' AND ADCStuDriverLicenseState EQ ' '
     THEN ADCStuDriverLicenseState=SLS;
     ELSE SLS=ADCStuDriverLicenseState;
  IF ADCPersonID EQ ' ' AND ADCStuDriverLicenseNumber EQ ' '
     THEN ADCStuDriverLicenseNumber=SLNO;
     ELSE SLNO=ADCStuDriverLicenseNumber;
  IF ADCPersonID EQ ' ' AND ADCStuMaritalStatus EQ ' '
     THEN ADCStuMaritalStatus=SMST;
     ELSE SMST=ADCStuMaritalStatus;
  IF ADCPersonID EQ ' ' AND ADCStuPrivacyFlag EQ ' '
     THEN ADCStuPrivacyFlag=SPF;
     ELSE SPF=ADCStuPrivacyFlag;
  IF ADCPersonID EQ ' ' AND ADCStuVisaType EQ ' '
     THEN ADCStuVisaType=SVST;
     ELSE SVST=ADCStuVisaType;
  IF ADCPersonID EQ ' ' AND ADCStuAddDate EQ ' '
     THEN ADCStuAddDate=SAD;
     ELSE SAD=ADCStuAddDate;
  IF ADCPersonID EQ ' ' AND ADCStuAddOpr EQ ' '
     THEN ADCStuAddOpr=SAO;
     ELSE SAO=ADCStuAddOpr;
  IF ADCPersonID EQ ' ' AND ADCStuChgDate EQ ' '
     THEN ADCStuChgDate=SCD;
     ELSE SCD=ADCStuChgDate;
  IF ADCPersonID EQ ' ' AND ADCStuChgOpr EQ ' '
     THEN ADCStuChgOpr=SCO;
     ELSE SCO=ADCStuChgOpr;
  IF ADCPersonID EQ ' ' AND ADCStuEthnic EQ ' '
     THEN ADCStuEthnic=SETH;
     ELSE SETH=ADCStuEthnic;
  IF ADCPersonID EQ ' ' AND ADCStuPrimaryEthnic EQ ' '
     THEN ADCStuPrimaryEthnic=SPE;
     ELSE SPE=ADCStuPrimaryEthnic;
  IF ADCPersonID EQ ' ' AND ADCStuPrimaryRace EQ ' '
     THEN ADCStuPrimaryRace=SPR;
     ELSE SPR=ADCStuPrimaryRace;
  IF ADCPersonID EQ ' '
     THEN ADCPersonID=ID;
     ELSE ID=ADCPersonID;
/*	IF ADCPersonID EQ ' ' 
     THEN ADCPersonID=ID;
     ELSE ID=ADCPersonID;
  IF ADCStuSSN EQ ' ' 
     THEN ADCStuSSN=SIN;
     ELSE SIN=ADCStuSSN;
  IF ADCStuCitizenship EQ ' ' 
     THEN ADCStuCitizenship=CIT;
     ELSE CIT=ADCStuCitizenship;
  IF ADCStuAltIDs EQ ' ' 
     THEN ADCStuAltIDs=AID;
     ELSE AID=ADCStuAltIDs;
  IF ADCStuLastName EQ ' ' 
     THEN ADCStuLastName=SLN;
     ELSE SLN=ADCStuLastName;
  IF ADCStuFirstName EQ ' ' 
     THEN ADCStuFirstName=SFN;
     ELSE SFN=ADCStuFirstName;
  IF ADCStuMiddleName EQ ' ' 
     THEN ADCStuMiddleName=SMN;
     ELSE SMN=ADCStuMiddleName;
  IF ADCStuNameSuffix EQ ' ' 
     THEN ADCStuNameSuffix=SNS;
     ELSE SNS=ADCStuNameSuffix;
  IF ADCStuPreviousLastNames EQ ' ' 
     THEN ADCStuPreviousLastNames=SPN;
     ELSE SPN=ADCStuPreviousLastNames;
  IF ADCStuMailCity EQ ' ' 
     THEN ADCStuMailCity=SMC;
     ELSE SMC=ADCStuMailCity;
  IF ADCStuMailState EQ ' ' 
     THEN ADCStuMailState=SMS;
     ELSE SMS=ADCStuMailState;
  IF ADCStuMailZip EQ ' ' 
     THEN ADCStuMailZip=SMZ;
     ELSE SMZ=ADCStuMailZip;
  IF ADCStuCounty EQ ' ' 
     THEN ADCStuCounty=SCY;
     ELSE SCY=ADCStuCounty;
  IF ADCStuEmergencyPhone EQ ' ' 
     THEN ADCStuEmergencyPhone=SEP;
     ELSE SEP=ADCStuEmergencyPhone;
  IF ADCStuBirthDate EQ ' ' 
     THEN ADCStuBirthDate=SBD;
     ELSE SBD=ADCStuBirthDate;
  IF ADCStuEthnic EQ ' ' 
     THEN ADCStuEthnic=SET;
     ELSE SET=ADCStuEthnic;
  IF ADCStuGender EQ ' ' 
     THEN ADCStuGender=SGE;
     ELSE SGE=ADCStuGender;
  IF ADCStuMailingCountry EQ ' ' 
     THEN ADCStuMailingCountry=SCO;
     ELSE SCO=ADCStuMailingCountry;
  IF ADCStuResidenceCountry EQ ' ' 
     THEN ADCStuResidenceCountry=SRC;
     ELSE SRC=ADCStuResidenceCountry;
  IF ADCStuResidenceState EQ ' ' 
     THEN ADCStuResidenceState=SRS;
     ELSE SRS=ADCStuResidenceState;
  IF ADCStuEmploymentStatus EQ ' ' 
     THEN ADCStuEmploymentStatus=SES;
     ELSE SES=ADCStuEmploymentStatus;
  IF ADCStuVeteranType EQ ' ' 
     THEN ADCStuVeteranType=SVT;
     ELSE SVT=ADCStuVeteranType;
  IF ADCStuDeceasedDate EQ ' ' 
     THEN ADCStuDeceasedDate=SDD;
     ELSE SDD=ADCStuDeceasedDate;
  IF ADCStuDriverLicenseState EQ ' ' 
     THEN ADCStuDriverLicenseState=SLS;
     ELSE SLS=ADCStuDriverLicenseState;
  IF ADCStuDriverLicenseNumber EQ ' ' 
     THEN ADCStuDriverLicenseNumber=SLNO;
     ELSE SLNO=ADCStuDriverLicenseNumber;
  IF ADCStuMaritalStatus EQ ' ' 
     THEN ADCStuMaritalStatus=SMST;
     ELSE SMST=ADCStuMaritalStatus;
  IF ADCStuPrivacyFlag EQ ' ' 
     THEN ADCStuPrivacyFlag=SPF;
     ELSE SPF=ADCStuPrivacyFlag;
  IF ADCStuVisaType EQ ' ' 
     THEN ADCStuVisaType=SVST;
     ELSE SVST=ADCStuVisaType;
  IF ADCStuAddDate EQ ' ' 
     THEN ADCStuAddDate=SAD;
     ELSE SAD=ADCStuAddDate;
  IF ADCStuAddOpr EQ ' ' 
     THEN ADCStuAddOpr=SAO;
     ELSE SAO=ADCStuAddOpr;
  IF ADCStuChgDate EQ ' ' 
     THEN ADCStuChgDate=SCD;
     ELSE SCD=ADCStuChgDate;
  IF ADCStuChgOpr EQ ' ' 
     THEN ADCStuChgOpr=SCO;
     ELSE SCO=ADCStuChgOpr;
  IF ADCStuEthnic EQ ' ' 
     THEN ADCStuEthnic=SETH;
     ELSE SETH=ADCStuEthnic;
  IF ADCStuPrimaryEthnic EQ ' ' 
     THEN ADCStuPrimaryEthnic=SPE;
     ELSE SPE=ADCStuPrimaryEthnic;
  IF ADCStuPrimaryRace EQ ' ' 
     THEN ADCStuPrimaryRace=SPR;
     ELSE SPR=ADCStuPrimaryRace;*/
BirthYear1=(SUBSTR(ADCStuBirthdate,7,4));
BirthMonth1=(SUBSTR(ADCStuBirthdate,1,2));
BirthDay1=(SUBSTR(ADCStuBirthdate,4,2));
BirthDate=BirthYear1||BirthMonth1||BirthDay1;
DROP BirthYear1 BirthMonth1 BirthDay1;
RUN;

/* THESE VARIABLES ARE NOT REPEATED BUT REASSIGNED IN NEXT PHASE */
/*
ADCStuPersonalPhone
ADCStuPersonalPhoneType
ADCStuEMailAddress
ADCStuEMailType
ADCStuRaces
*/

* END - SECTION st02downb - REPEATS MISSING VARIABLES FOR st02downa *;

* BEGIN - SECTION st02downb_undup - UNDUPLICATES st02downb *;

DATA st02downb_undup;
SET st02downb;
PROC SORT NODUPKEY DATA=st02downb_undup; BY ADCPersonID;
RUN;

* END - SECTION st02downb_undup - UNDUPLICATES st02downb *;


* BEGIN - SECTION st02downc - PROCESSES VARIABLES NOT BEING REPEATED AND ARRAYS RACES *;
DATA st02downc_st
		st02downc_pr
		st02downc_cp
		st02downc_ot;
SET st02downb;
IF ADCStuEMailType EQ 'ST' THEN OUTPUT st02downc_st;			* CPCC CUSTOMIZATION;
	ELSE IF ADCStuEMailType EQ 'P' THEN OUTPUT st02downc_pr;
	ELSE IF ADCStuEMailType EQ 'CP' THEN OUTPUT st02downc_cp;	* CPCC CUSTOMIZATION;
	ELSE OUTPUT st02downc_ot;
RUN;

DATA st02down_stemail (KEEP=ADCPersonID ADCStuStEMailAddress);
FORMAT ADCStuStEMailAddress $50.;
SET st02downc_st (KEEP=ADCPersonID ADCStuEMailAddress);
ADCStuStEMailAddress=ADCStuEMailAddress;
PROC SORT NODUPKEY DATA=st02down_stemail; BY ADCPersonID;
RUN;

DATA st02down_premail (KEEP=ADCPersonID ADCStuPriEMailAddress);
FORMAT ADCStuPriEMailAddress $50.;
SET st02downc_pr (KEEP=ADCPersonID ADCStuEMailAddress);
ADCStuPriEMailAddress=ADCStuEMailAddress;
DROP ADCStuEMailAddress;
PROC SORT NODUPKEY DATA=st02down_premail; BY ADCPersonID;
RUN;

DATA st02down_cpemail (KEEP=ADCPersonID ADCStuCPCCEmpEMailAddress);		* CPCC CUSTOMIZATION;
FORMAT ADCStuCPCCEmpEMailAddress $50.;
SET st02downc_cp (KEEP=ADCPersonID ADCStuEMailAddress);
ADCStuCPCCEmpEMailAddress=ADCStuEMailAddress;
DROP ADCStuEMailAddress;
PROC SORT NODUPKEY DATA=st02down_cpemail; BY ADCPersonID;
RUN;

DATA st02down_otemail (KEEP=ADCPersonID ADCStuOtrEMailAddress);
FORMAT ADCStuOtrEMailAddress $50.;
SET st02downc_ot (KEEP=ADCPersonID ADCStuEMailAddress);
ADCStuOtrEMailAddress=ADCStuEMailAddress;
DROP ADCStuEMailAddress;
PROC SORT NODUPKEY DATA=st02down_otemail; BY ADCPersonID;
RUN;

DATA st02down_email (KEEP=ADCPersonID 
							ADCStuStEMailAddress 
							ADCStuPriEMailAddress 
							ADCStuCPCCEmpEMailAddress 
							ADCStuOtrEMailAddress);
MERGE st02down_stemail
		st02down_premail
		st02down_cpemail
		st02down_otemail; BY ADCPersonID;
RUN;

DATA st02downc_h
		st02downc_cell
		st02downc_bu
		st02downc_ot;
SET st02downb;
IF ADCStuPersonalPhoneType EQ 'H' THEN OUTPUT st02downc_h;
	ELSE IF ADCStuPersonalPhoneType EQ 'CELL' THEN OUTPUT st02downc_cell;
	ELSE IF ADCStuPersonalPhoneType EQ 'BU' THEN OUTPUT st02downc_bu;
	ELSE OUTPUT st02downc_ot;
RUN;

DATA st02downd_hp (KEEP=ADCPersonID ADCStuHomePhone);
FORMAT ADCStuHomePhone $14.;
SET st02downc_h (KEEP=ADCPersonID ADCStuPersonalPhone);
ADCStuHomePhone=ADCStuPersonalPhone;
DROP ADCStuPersonalPhone;
PROC SORT NODUPKEY DATA=st02downd_hp; BY ADCPersonID;
RUN;

DATA st02downd_cp (KEEP=ADCPersonID ADCStuCellPhone);
FORMAT ADCStuCellPhone $14.;
SET st02downc_cell (KEEP=ADCPersonID ADCStuPersonalPhone);
ADCStuCellPhone=ADCStuPersonalPhone;
DROP ADCStuPersonalPhone;
PROC SORT NODUPKEY DATA=st02downd_cp; BY ADCPersonID;
RUN;

DATA st02downd_bp (KEEP=ADCPersonID ADCStuBusPhone);
FORMAT ADCStuBusPhone $14.;
SET st02downc_bu (KEEP=ADCPersonID ADCStuPersonalPhone);
ADCStuBusPhone=ADCStuPersonalPhone;
DROP ADCStuPersonalPhone;
PROC SORT NODUPKEY DATA=st02downd_bp; BY ADCPersonID;
RUN;

DATA st02downd_op (KEEP=ADCPersonID ADCStuOtrPhone);
FORMAT ADCStuOtrPhone $14.;
SET st02downc_ot (KEEP=ADCPersonID ADCStuPersonalPhone);
ADCStuOtrPhone=ADCStuPersonalPhone;
DROP ADCStuPersonalPhone;
PROC SORT NODUPKEY DATA=st02downd_op; BY ADCPersonID;
RUN;

DATA st02down_phone (KEEP=ADCPersonID 
							ADCStuHomePhone 
							ADCStuCellPhone 
							ADCStuBusPhone 
							ADCStuOtrPhone);
MERGE st02downd_hp
		st02downd_bp
		st02downd_cp
		st02downd_op; BY ADCPersonID;
RUN;

/*
DATA st02downb;
set st02downb;
if adcpersonid in ('3714014') and adcstumailaddress1type in ('VPO') then delete;
run;
*/

DATA trunc10race;
SET st02downb; BY ADCPersonID;
	IF FIRST.ADCPersonID THEN count10=0;
		count10+1;
		IF count10 LE 10 THEN OUTPUT;
RUN;


DATA st02racearray (KEEP=ADCPersonID ADCStuRaces&ar02b-ADCStuRaces&ar02e);
RETAIN					ADCStuRaces&ar02b-ADCStuRaces&ar02e;
	ARRAY	rac (&ar02e) $4.	ADCStuRaces&ar02b-ADCStuRaces&ar02e;
SET trunc10race; BY ADCPersonID;
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
*PROC PRINT DATA=st02racearray;
RUN;

* END - SECTION st02downc - PROCESSES VARIABLES NOT BEING REPEATED AND ARRAYS RACES *;

* BEGIN - SECTION st02downfinal - MERGES ALL st02 DATASETS *;

DATA st02final;
	MERGE st02downb_undup
			st02down_email
			st02down_phone
			st02racearray; BY ADCpersonID;
PROC SORT NODUPKEY DATA=st02final; BY ADCPersonID;
RUN;
	

* END - SECTION st02downfinal - MERGES ALL st02 DATASETS *;


* BEGIN - SECTION merge0902a - MERGES st09 AND st02 DATASETS *;
DATA merge0902a;
	MERGE st09downe(IN=a) st02final(IN=b); BY ADCPersonID;
	IF a*b=1;
RUN;

DATA merge0902b;
	MERGE st09downe(IN=a) st02final(IN=b); BY ADCPersonID;
	IF a AND NOT b;
/*TITLE1 " ERROR - DATA IN ST09 NOT IN ST02 ";
PROC PRINT DATA=merge0902b;
	VAR ADCPersonID ADCStuLastName ADCStuFirstName;*/
RUN;

DATA merge0902c;
	MERGE st09downe(IN=a) st02final(IN=b); BY ADCPersonID;
	IF b AND NOT a;
/*TITLE1 " ERROR - DATA IN ST02 NOT IN ST09 ";
PROC PRINT DATA=merge0902c;
	VAR ADCPersonID ADCStuLastName ADCStuFirstName;*/
RUN;

DATA merge0902d;
	MERGE merge0902a merge0902b; BY ADCPersonID;
RUN;


* END - SECTION merge0902a - MERGES st09 AND st02 DATASETS *;


* BEGIN - SECTION st11downa - IMPORTS ST11 FLAT TEXT FILE *;

DATA st11downa (KEEP=
					ADCPersonID
					ADCStuAcadLevel
					ADCStuGRSAdmitStatus
					ADCStuFederalCohortGroup
					ADCStuCreditAttempted
					ADCStuCreditCompleted
					ADCStuCummulativeGPA
					ADCStuProgramGPA
);
INFILE "&Path00&Infile11"  LINESIZE=800 TRUNCOVER;
INPUT @1 ADCPersonID $10. @;
	SELECT;
	WHEN (ADCPersonID NE 'Student ID') DO;
		INPUT @1	ADCPersonID					$10.
			@11		ADCStuAcadLevel				$6.
			@46		ADCStuGRSAdmitStatus		$3.
			@81		ADCStuFederalCohortGroup	$8.
			@153	ADCStuCreditAttempted		8.
			@170	ADCStuCreditCompleted		8.
			@179	ADCStuCummulativeGPA		7.
			@186	ADCStuProgramGPA			8.
;
		OUTPUT st11downa;
	END;
	OTHERWISE DO;
	PUT 'Error in record ' _n_ 'as follows:' _INFILE_;
		DELETE;
	END;
END;
RUN;

* END - SECTION st11downa - IMPORTS ST11 FLAT TEXT FILE *;

/*
DATA GRSCHECK;
SET st11downb;
IF ADCStuFederalCohortGroup EQ '2011FT';
PROC SORT NODUPKEY DATA=GRSCHECK; BY ADCPersonID;
PROC FREQ DATA=GRSCHECK;
	TABLES ADCStuFederalCohortGroup;
RUN;
*/

* BEGIN - SECTION st11downb - REPEATS VARIABLE MISSING VALUES *;

*** NEED TO FIX THIS SECTION;
DATA st11downb;
SET st11downa;
	RETAIN PID;
	DROP   PID;
	RETAIN PAL;
	DROP   PAL;
	RETAIN PAS;
	DROP   PAS;
	RETAIN PFC;
	DROP   PFC;
	RETAIN PCA;
	DROP   PCA;
	RETAIN PCC;
	DROP   PCC;
	RETAIN PCG;
	DROP   PCG;
	RETAIN PPG;
	DROP   PPG;
  IF ADCPersonID EQ ' ' AND ADCStuAcadLevel EQ ' ' 
     THEN ADCStuAcadLevel=PAL;
     ELSE PAL=ADCStuAcadLevel;
  IF ADCPersonID EQ ' ' AND ADCStuGRSAdmitStatus EQ ' '
  	 THEN ADCStuGRSAdmitStatus=PAS;
	 ELSE PAS=ADCStuGRSAdmitStatus;
  IF ADCPersonID EQ ' ' AND ADCStuFederalCohortGroup EQ ' ' 
     THEN ADCStuFederalCohortGroup=PFC;
     ELSE PFC=ADCStuFederalCohortGroup;
  IF ADCPersonID EQ ' ' AND ADCStuCreditAttempted EQ ' ' 
     THEN ADCStuCreditAttempted=PCA;
     ELSE PCA=ADCStuCreditAttempted;
  IF ADCPersonID EQ ' ' AND ADCStuCreditCompleted EQ ' ' 
     THEN ADCStuCreditCompleted=PCC;
     ELSE PCC=ADCStuCreditCompleted;
  IF ADCPersonID EQ ' ' AND ADCStuCummulativeGPA EQ ' ' 
     THEN ADCStuCummulativeGPA=PCG;
     ELSE PCG=ADCStuCummulativeGPA;
  IF ADCPersonID EQ ' ' AND ADCStuProgramGPA EQ ' ' 
     THEN ADCStuProgramGPA=PPG;
     ELSE PPG=ADCStuProgramGPA;
  IF ADCPersonID EQ ' ' 
     THEN ADCPersonID=PID;
     ELSE PID=ADCPersonID;
PROC SORT DATA=st11downb; BY ADCPersonID DESCENDING ADCStuAcadLevel;
PROC SORT NODUPKEY DATA=st11downb; BY ADCPersonID;
*PROC PRINT DATA=st11downb;
RUN;

* END - SECTION st11downb - REPEATS VARIABLE MISSING VALUES *;


* BEGIN - SECTION merge090211 - MERGES st0902 AND st11 DATASETS *;

DATA merge090211a;
	MERGE merge0902d(IN=a) st11downb(IN=b); BY ADCPersonID;
	IF a*b=1;
RUN;

DATA merge090211b;
	MERGE merge0902d(IN=a) st11downb(IN=b); BY ADCPersonID;
	IF a AND NOT b;
/*TITLE1 " ERROR - DATA IN ST0902 NOT IN ST11 ";
PROC PRINT DATA=merge090211b;
	VAR ADCPersonID ADCStuLastName ADCStuFirstName ADCStuAcadLevel;*/
RUN;

DATA merge090211c;
	MERGE merge0902d(IN=a) st11downb(IN=b); BY ADCPersonID;
	IF b AND NOT a;
/*TITLE1 " ERROR - DATA IN ST11 NOT IN ST0902 ";
PROC PRINT DATA=merge090211c;
	VAR ADCPersonID ADCStuLastName ADCStuFirstName ADCStuAcadLevel;*/
RUN;


DATA merge090211d;
	MERGE merge090211a merge090211b; BY ADCPersonID;
RUN;


* END - SECTION merge090211 - MERGES st0902 AND st11 DATASETS *;


* BEGIN - SECTION st07downa - IMPORTS st07 DOWNLOAD *;

DATA st07downa (KEEP=
						ADCPersonID
						ADCStuHighSchoolCode
						ADCStuHighSchoolName
						ADCStuHighSchoolStartDate
						ADCStuHighSchoolEndDate
						ADCStuHighSchoolGraduationType
						ADCStuHighSchoolTranscriptType
						ADCStuHighSchoolTranscriptDate
						ADCStuHighSchoolTranscriptStatus
						ADCStuHighSchoolType
						ADCStuHighSchoolGPA
);
INFILE "&Path00&Infile07"  LINESIZE=800 TRUNCOVER;
INPUT @1 ADCPersonID $10. @;
	SELECT;
	WHEN (ADCPersonID NE 'Person ') DO;
		INPUT @1	ADCPersonID							$10.
			@11		ADCStuHighSchoolCode				$10.
			@22		ADCStuHighSchoolName				$25.
			@47		ADCStuHighSchoolStartDate			$10.
			@64		ADCStuHighSchoolEndDate				$10.
			@79		ADCStuHighSchoolGraduationType		$3.
			@99		ADCStuHighSchoolTranscriptType		$4.
			@120	ADCStuHighSchoolTranscriptDate		$10.
			@141	ADCStuHighSchoolTranscriptStatus	$3.
			@169	ADCStuHighSchoolType				$4.
			@174    ADCStuHighSchoolGPA                 5.3
;
		OUTPUT st07downa;
	END;
	OTHERWISE DO;
	PUT 'Error in record ' _n_ 'as follows:' _INFILE_;
		DELETE;
	END;
END;
*PROC PRINT DATA=st07downa;
RUN;

* END - SECTION st07downa - IMPORTS st07 DOWNLOAD *;

* BEGIN - SECTION st07downb - REPEATS NECESSARY VARIABLE VALUES *;

DATA st07downb;
SET st07downa;
	RETAIN PID;
	DROP   PID;
	RETAIN PSC;
	DROP   PSC;
	RETAIN PSN;
	DROP   PSN;
	RETAIN PHT;
	DROP   PHT;
  IF ADCPersonID EQ ' ' AND ADCStuHighSchoolCode EQ ' ' 
     THEN ADCStuHighSchoolCode=PSC;
     ELSE PSC=ADCStuHighSchoolCode;
  IF ADCPersonID EQ ' ' AND ADCStuHighSchoolName EQ ' ' 
     THEN ADCStuHighSchoolName=PSN;
     ELSE PSN=ADCStuHighSchoolName;
  IF ADCPersonID EQ ' ' AND ADCStuHighSchoolType EQ ' ' 
     THEN ADCStuHighSchoolType=PHT;
     ELSE PHT=ADCStuHighSchoolType;
  IF ADCPersonID EQ ' ' 
     THEN ADCPersonID=PID;
     ELSE PID=ADCPersonID;

/*PROC SORT NODUPKEY DATA=st07downb; BY ADCPersonID;*/
*PROC PRINT DATA=st07downb;
RUN;

* END - SECTION st07downb - REPEATS NECESSARY VARIABLE VALUES *;

* BEGIN - SECTION st07downc - SELECTS ONLY HIGH SCHOOL LEVEL RECORDS AND UNDUPLICATES *;

DATA st07downc;
SET st07downb;
IF (ADCStuHighSchoolType EQ 'HS'
	OR ADCStuHighSchoolType EQ 'HO'
	OR ADCStuHighSchoolType EQ 'K12'
	OR ADCStuHighSchoolGraduationType EQ 'G'
	OR ADCStuHighSchoolGraduationType EQ 'A');
PROC SORT NODUPKEY DATA=st07downc; BY ADCPersonID;
*PROC PRINT DATA=st07downc;
RUN;

* END - SECTION st07downc - SELECTS ONLY HIGH SCHOOL LEVEL RECORDS AND UNDUPLICATES *;

* BEGIN - SECTION merge0902110507 - MERGES merge09021105 AND st07 DATASETS *;

DATA merge09021107a;
	MERGE merge090211d(IN=a) st07downc(IN=b); BY ADCPersonID;
	IF a*b=1;
RUN;

DATA merge09021107b;
	MERGE merge090211d(IN=a) st07downc(IN=b); BY ADCPersonID;
	IF a AND NOT b;
/*TITLE1 " ERROR - DATA IN merge090211c NOT IN st07downc ";
PROC PRINT DATA=merge09021107b;
	VAR ADCPersonID ADCStuLastName ADCStuFirstName;*/
RUN;

DATA merge09021107c;
	MERGE merge090211d(IN=a) st07downc(IN=b); BY ADCPersonID;
	IF b AND NOT a;
/*TITLE1 " ERROR - DATA IN st07downc NOT IN merge090211c ";
PROC PRINT DATA=merge09021107c;
	VAR ADCPersonID ADCStuLastName ADCStuFirstName;*/
RUN;

DATA merge09021107d;
	MERGE merge09021107a merge09021107b; BY ADCPersonID;
RUN;

* END - SECTION merge0902110507 - MERGES merge09021105 AND st07 DATASETS *;


* BEGIN - SECTION st03downa - IMPORTS st03 DATA *;

DATA st03downa (KEEP=
						ADCPersonID
						ADCStuInmateFlag
						ADCStuEconDisAdvFlag
						ADCStuSingleParentFlag
						ADCStuHeadHouseholdFlag
						ADCStuLimitEnglishFlag
						ADCStuHighSchoolTrack
						ADCStuEduEntryLvl
						ADCStuEduLvl
						ADCStuFtrDegLvl
						ADCStuMtrDegLvl
);
INFILE "&Path00&Infile03"  LINESIZE=800 TRUNCOVER;
INPUT @1 ADCPersonID $10. @;
	SELECT;
	WHEN (ADCPersonID NE 'XNC.PERSON') DO;
		INPUT @1	ADCPersonID					$10.
			@14		ADCStuInmateFlag			$3.
			@29		ADCStuEconDisAdvFlag		$3.
			@56		ADCStuSingleParentFlag		$3.
			@78		ADCStuHeadHouseholdFlag		$3.
			@101	ADCStuLimitEnglishFlag		$3.
			@125	ADCStuHighSchoolTrack		$4.
			@155	ADCStuEduEntryLvl			$3.
			@174	ADCStuEduLvl				$3.
			@204	ADCStuFtrDegLvl				$3.
			@226	ADCStuMtrDegLvl				$3.
;
		OUTPUT st03downa;
	END;
	OTHERWISE DO;
	PUT 'Error in record ' _n_ 'as follows:' _INFILE_;
		DELETE;
	END;
END;
PROC SORT DATA=st03downa; BY ADCPersonID;
*PROC PRINT DATA=st03downa;
RUN;

* END - SECTION st03downa - IMPORTS st03 DATA *;


* BEGIN - SECTION merge090211050703 - MERGES merge0902110507 AND st03 DATASETS *;

DATA merge0902110703a;
	MERGE merge09021107d(IN=a) st03downa(IN=b); BY ADCPersonID;
	IF a*b=1;
RUN;

DATA merge0902110703b;
	MERGE merge09021107d(IN=a) st03downa(IN=b); BY ADCPersonID;
	IF a AND NOT b;
TITLE1 " ERROR - DATA IN merge09021107c NOT IN st03downc ";
/*PROC PRINT DATA=merge0902110703b;
	VAR ADCPersonID ADCStuLastName ADCStuFirstName;*/
RUN;

DATA merge0902110703c;
	MERGE merge09021107d(IN=a) st03downa(IN=b); BY ADCPersonID;
	IF b AND NOT a;
/*TITLE1 " ERROR - DATA IN st03downc NOT IN merge09021107c ";
PROC PRINT DATA=merge0902110703c;
	VAR ADCPersonID ADCStuLastName ADCStuFirstName;*/
RUN;

DATA merge0902110703d;
	MERGE merge0902110703a merge0902110703b; BY ADCPersonID;
RUN;

* END - SECTION merge090211050703 - MERGES merge0902110507 AND st03 DATASETS *;


* BEGIN - SECTION st14downa - IMPORTS st14 DATA *;

DATA st14downa (KEEP=
						ADCPersonID
						ADCStuProgAcadLevel
						ADCStuAcadPrograms
						ADCStuPrimaryProgramFlag
						ADCStuAcadProgramTitle
						ADCStuProgAdmitStatus
						ADCStuGradAllowed
						ADCStuProgCatalogYear
						ADCStuProgCurrentEndDate
						ADCStuProgCurrentStatus
						ADCStuProgCurrentStatusDate
						ADCStuProgEndDate
						ADCStuProgStartDate
						ADCStuProgStatus
						ADCStuProgStatusChgOpr
						ADCStuProgStatusChgDate
						ADCStuEdPlan
						ADCStuProgDept
);
INFILE "&Path00&Infile14"  LINESIZE=800 TRUNCOVER;
INPUT @1 ADCPersonID $10. @;
	SELECT;
	WHEN (ADCPersonID NE 'STPR.STUDE') DO;
		INPUT @1	ADCPersonID						$10.
			@13		ADCStuProgAcadLevel				$4.
			@38		ADCStuAcadPrograms				$12.
			@58		ADCStuPrimaryProgramFlag		$4.
			@68		ADCStuAcadProgramTitle			$39.
			@108	ADCStuProgAdmitStatus			$3.
			@143	ADCStuGradAllowed				$3.
			@155	ADCStuProgCatalogYear			$6.
			@190	ADCStuProgCurrentEndDate		$10.
			@206	ADCStuProgCurrentStatus			$3.
			@220	ADCStuProgCurrentStatusDate		$10.
			@231	ADCStuProgEndDate				$8.
			@239	ADCStuProgStartDate				$10.
			@249	ADCStuProgStatus				$3.
			@279	ADCStuProgStatusChgOpr			$10.
			@296	ADCStuProgStatusChgDate			$10.
			@307	ADCStuEdPlan					$6.
			@317	ADCStuProgDept					$6.
;
		OUTPUT st14downa;
	END;
	OTHERWISE DO;
	PUT 'Error in record ' _n_ 'as follows:' _INFILE_;
		DELETE;
	END;
END;
/*PROC SORT NODUPKEY DATA=st14downa; BY ADCPersonID;*/
*PROC PRINT DATA=st14downa;
RUN;

* END - SECTION st14downa - IMPORTS st14 DATA *;


DATA FIXProgramCode;
FORMAT
		PgStartDate8 $12.
		PgEndDate8 $12.
;
SET st14downa;
IF ADCPersonID IN (
					' '
					) THEN DELETE;
IF (SUBSTR(ADCStuProgEndDate,1,1)) IN (
										' '
										)
	THEN PgEndDate8=ADCStuProgEndDate;
	ELSE IF (SUBSTR(ADCStuProgEndDate,7,1)) IN (
												'6',
												'7',
												'8',
												'9'
												)
	THEN PgEndDate8='19'||(SUBSTR(ADCStuProgEndDate,7,2))||(SUBSTR(ADCStuProgEndDate,1,2))||(SUBSTR(ADCStuProgEndDate,4,2));
	ELSE PgEndDate8='20'||(SUBSTR(ADCStuProgEndDate,7,2))||(SUBSTR(ADCStuProgEndDate,1,2))||(SUBSTR(ADCStuProgEndDate,4,2));
IF (SUBSTR(ADCStuProgStartDate,1,1)) IN (
										' '
										)
	THEN PgStartDate8=ADCStuProgStartDate;
	ELSE IF (SUBSTR(ADCStuProgStartDate,7,1)) IN (
													'6',
													'7',
													'8',
													'9'
													)
	THEN PgStartDate8='19'||(SUBSTR(ADCStuProgStartDate,7,2))||(SUBSTR(ADCStuProgStartDate,1,2))||(SUBSTR(ADCStuProgStartDate,4,2));
	ELSE PgStartDate8='20'||(SUBSTR(ADCStuProgStartDate,7,2))||(SUBSTR(ADCStuProgStartDate,1,2))||(SUBSTR(ADCStuProgStartDate,4,2));
IF (PgStartDate8 LT "&EndDate")
	AND ((PgEndDate8 EQ ' ')
	OR (PgEndDate8 GT "&StartDate"));
/*IF PgEndDate8 GT "&EndDate" THEN DO*/
/*							ADCStuProgEndDate=' ';*/
/*							ADCStuProgCurrentStatus='A';*/
/*							END;*/
*IF PgEndDate8 GE "&EndDate" AND ADCStuProgStatus EQ 'G';
*IF PgEndDate8 GE "&StartDate";
/*DROP*/
/*	PgStartDate8*/
/*	PgEndDate8*/
/*;*/
/*IF ADCStuProgCurrentStatus IN ('G');*/
RUN;


* BEGIN - SECTION st14downb - SEPERATES PRIMARY CUR/CCE/BSP PROGRAM CODES INTO SEPERATE VARIABLES
								AND MERGES THEM *;
/* Added 'G's back in - C.K. 2/26/2014 */
DATA 	CURa (KEEP=	ADCPersonID
					ADCStuProgAcadLevel
					ADCStuAcadPrograms
					ADCStuAcadProgramTitle
					ADCStuProgAdmitStatus
					ADCStuProgCatalogYear
					ADCStuProgCurrentEndDate
					ADCStuProgCurrentStatus
					ADCStuProgCurrentStatusDate
					ADCStuProgEndDate
					ADCStuProgStartDate
					ADCStuProgDept
					ADCStuAcadPrograms
					ADCStuPrimaryProgramFlag
)
		CCEa (KEEP=	ADCPersonID
					ADCStuProgAcadLevel
					ADCStuAcadPrograms
					ADCStuAcadProgramTitle
					ADCStuProgAdmitStatus
					ADCStuProgCatalogYear
					ADCStuProgCurrentEndDate
					ADCStuProgCurrentStatus
					ADCStuProgCurrentStatusDate
					ADCStuProgEndDate
					ADCStuProgStartDate
					ADCStuProgDept
					ADCStuAcadPrograms
)
		BSPa (KEEP=	ADCPersonID
					ADCStuProgAcadLevel
					ADCStuAcadPrograms
					ADCStuAcadProgramTitle
					ADCStuProgAdmitStatus
					ADCStuProgCatalogYear
					ADCStuProgCurrentEndDate
					ADCStuProgCurrentStatus
					ADCStuProgCurrentStatusDate
					ADCStuProgEndDate
					ADCStuProgStartDate
					ADCStuProgDept
					ADCStuAcadPrograms
)
		UNKa (KEEP=	ADCPersonID
					ADCStuProgAcadLevel
					ADCStuAcadPrograms
					ADCStuAcadProgramTitle
					ADCStuProgAdmitStatus
					ADCStuProgCatalogYear
					ADCStuProgCurrentEndDate
					ADCStuProgCurrentStatus
					ADCStuProgCurrentStatusDate
					ADCStuProgEndDate
					ADCStuProgStartDate
					ADCStuProgDept
					ADCStuAcadPrograms
);
SET FIXProgramCode (KEEP=ADCPersonID
					ADCStuProgAcadLevel
					ADCStuAcadPrograms
					ADCStuAcadProgramTitle
					ADCStuProgAdmitStatus
					ADCStuProgCatalogYear
					ADCStuProgCurrentEndDate
					ADCStuProgCurrentStatus
					ADCStuProgCurrentStatusDate
					ADCStuProgEndDate
					ADCStuProgStartDate
					ADCStuProgDept
					ADCStuAcadPrograms
					ADCStuPrimaryProgramFlag
);
IF ADCPersonID EQ '  ' THEN DELETE;
IF ADCStuProgAcadLevel EQ 'CU'
/*	AND ADCStuProgCurrentStatus in ('A','G')*/
/*	AND ADCPersonID NE ' '*/
	THEN OUTPUT CURa;
	ELSE IF ADCStuProgAcadLevel EQ 'CE'
/*	AND ADCStuProgCurrentStatus in ('A','G')*/
/*	AND ADCPersonID NE ' '*/
	THEN OUTPUT CCEa;
	ELSE IF ADCStuProgAcadLevel EQ 'BSP'
/*	AND ADCStuProgCurrentStatus in ('A','G')*/
/*	AND ADCPersonID NE ' '*/
	THEN OUTPUT BSPa;
	ELSE OUTPUT UNKa;
RUN;

DATA CURb0 (KEEP=
					ADCPersonID
					ADCStuCURPriProgTitle
					ADCStuCURPriProgAdmitStatus
					ADCStuCURPriProgCatalogYear
					ADCStuCURPriProgCurStatus
					ADCStuCURPriProgCurStatusDate
					ADCStuCURPriProgEndDate
					ADCStuCURPriProgStartDate
					ADCStuCURPriProgDept
					ADCStuCURPriProgCode
					ADCStuPrimaryProgramFlag
					CURStartDate8
					CUREndDate8
					FlagSort
					StartDateSort
					CredSort
);
FORMAT
		CURStartDate8 $8.
		CUREndDate8 $8.
		FlagSort $5.
		StartDateSort $8.
		CredSort $5.
;
SET CURa;
ADCStuCURPriProgTitle=ADCStuAcadProgramTitle;
ADCStuCURPriProgAdmitStatus=ADCStuProgAdmitStatus;
ADCStuCURPriProgCatalogYear=ADCStuProgCatalogYear;
ADCStuCURPriProgCurStatus=ADCStuProgCurrentStatus;
ADCStuCURPriProgCurStatusDate=ADCStuProgCurrentStatusDate;
ADCStuCURPriProgEndDate=ADCStuProgEndDate;
ADCStuCURPriProgStartDate=ADCStuProgStartDate;
ADCStuCURPriProgDept=ADCStuProgDept;
ADCStuCURPriProgCode=ADCStuAcadPrograms;
IF SUBSTR(ADCStuCURPriProgCode,1,1) IN (
										'A'
										)
									THEN CredSort='1A';
	ELSE IF SUBSTR(ADCStuCURPriProgCode,1,1) IN (
												'D'
												)
									THEN CredSort='2D';
	ELSE IF SUBSTR(ADCStuCURPriProgCode,1,1) IN (
												'C'
												)
									THEN CredSort='3C';
	ELSE CredSort='4PTV';
IF (SUBSTR(ADCStuCURPriProgEndDate,1,1)) IN (
											' '
											)
									THEN CUREndDate8=ADCStuCURPriProgEndDate;
	ELSE IF (SUBSTR(ADCStuCURPriProgEndDate,7,1)) IN (
										'6',
										'7',
										'8',
										'9'
										)
	THEN CUREndDate8='19'||(SUBSTR(ADCStuCURPriProgEndDate,7,2))||(SUBSTR(ADCStuCURPriProgEndDate,1,2))||(SUBSTR(ADCStuCURPriProgEndDate,4,2));
	ELSE CUREndDate8='20'||(SUBSTR(ADCStuCURPriProgEndDate,7,2))||(SUBSTR(ADCStuCURPriProgEndDate,1,2))||(SUBSTR(ADCStuCURPriProgEndDate,4,2));
If (SUBSTR(ADCStuCURPriProgStartDate,7,1)) IN (
										'6',
										'7',
										'8',
										'9'
										)
	THEN CURStartDate8='19'||(SUBSTR(ADCStuCURPriProgStartDate,7,2))||(SUBSTR(ADCStuCURPriProgStartDate,1,2))||(SUBSTR(ADCStuCURPriProgStartDate,4,2)); 
	ELSE CURStartDate8='20'||(SUBSTR(ADCStuCURPriProgStartDate,7,2))||(SUBSTR(ADCStuCURPriProgStartDate,1,2))||(SUBSTR(ADCStuCURPriProgStartDate,4,2));

IF ADCStuPrimaryProgramFlag IN (
								'Y'
								)
							THEN FlagSort='1Y';
	ELSE IF ADCStuPrimaryProgramFlag IN (
										' '
										)
							THEN FlagSort='2 ';
	ELSE IF ADCStuPrimaryProgramFlag IN (
										'N'
										)
							THEN FlagSort='3N';
StartDateSort=CURStartDate8;
RUN;

DATA CURbActive;
SET CURb0;
PROC SORT DATA=CURbActive; BY ADCPersonID FlagSort DESCENDING StartDateSort CredSort;
RUN;

DATA CURbPrimary;
SET CURbActive;
PROC SORT NODUPKEY DATA=CURbPrimary; BY ADCPersonID;
RUN;


DATA CCEb0 (KEEP=	ADCPersonID
					ADCStuCCEPriProgTitle
					ADCStuCCEPriProgCCECurStatus
					ADCStuCCEPriProgCCECurStatusDate
					ADCStuCCEPriProgEndDate
					ADCStuCCEPriProgStartDate
					ADCStuCCEPriProgDept
					ADCStuCCEPriProgCode
					);
SET CCEa;
ADCStuCCEPriProgTitle=ADCStuAcadProgramTitle;
ADCStuCCEPriProgCCECurStatus=ADCStuProgCurrentStatus;
ADCStuCCEPriProgCCECurStatusDate=ADCStuProgCurrentStatusDate;
ADCStuCCEPriProgEndDate=ADCStuProgEndDate;
ADCStuCCEPriProgStartDate=ADCStuProgStartDate;
ADCStuCCEPriProgDept=ADCStuProgDept;
ADCStuCCEPriProgCode=ADCStuAcadPrograms;
run;

PROC SORT NODUPKEY DATA=CCEb0 out=CCEb; 
BY ADCPersonID;
RUN;

DATA BSPb (KEEP=	ADCPersonID
					ADCStuBSPPriProgTitle
					ADCStuBSPPriProgCurStatus
					ADCStuBSPPriProgCurStatusDate
					ADCStuBSPPriProgEndDate
					ADCStuBSPPriProgStartDate
					ADCStuBSPPriProgDept
					ADCStuBSPPriProgCode
);
SET BSPa;
ADCStuBSPPriProgTitle=ADCStuAcadProgramTitle;
ADCStuBSPPriProgCurStatus=ADCStuProgCurrentStatus;
ADCStuBSPPriProgCurStatusDate=ADCStuProgCurrentStatusDate;
ADCStuBSPPriProgEndDate=ADCStuProgEndDate;
ADCStuBSPPriProgStartDate=ADCStuProgStartDate;
ADCStuBSPPriProgDept=ADCStuProgDept;
ADCStuBSPPriProgCode=ADCStuAcadPrograms;
run;

PROC SORT NODUPKEY DATA=BSPb; 
BY ADCPersonID;
RUN;

***WORK***;

DATA CURCCEBSPActiveProgs01a (KEEP=
								ADCPersonID
								StuActiveProgCode
								StuActiveProgTitle
								StuActiveProgDept
								StuActiveProgCurStatus
								StuActiveProgCurStatusDate
								StuActiveProgStartDate
								StuActiveProgEndDate
								PgStartDate8
);
SET FIXProgramCode;
StuActiveProgCode=ADCStuAcadPrograms;
StuActiveProgTitle=ADCStuAcadProgramTitle;
StuActiveProgDept=ADCStuProgDept;
StuActiveProgCurStatus=ADCStuProgCurrentStatus;
StuActiveProgCurStatusDate=ADCStuProgCurrentStatusDate;
StuActiveProgStartDate=ADCStuProgStartDate;
StuActiveProgEndDate=ADCStuProgEndDate;
PROC SORT DATA=CURCCEBSPActiveProgs01a; BY ADCPersonID DESCENDING PgStartDate8;
RUN;

DATA CURCCEBSPActiveProgs01b (KEEP=
									ADCPersonID
									StuActiveProgCode&ar04b-StuActiveProgCode&ar04e
									StuActiveProgTitle&ar04b-StuActiveProgTitle&ar04e
									StuActiveProgDept&ar04b-StuActiveProgDept&ar04e
									StuActiveProgCurStatus&ar04b-StuActiveProgCurStatus&ar04e
									StuActiveProgCurStatusDate&ar04b-StuActiveProgCurStatusDate&ar04e
									StuActiveProgStartDate&ar04b-StuActiveProgStartDate&ar04e
									StuActiveProgEndDate&ar04b-StuActiveProgEndDate&ar04e
);
RETAIN
									StuActiveProgCode&ar04b-StuActiveProgCode&ar04e
									StuActiveProgTitle&ar04b-StuActiveProgTitle&ar04e
									StuActiveProgDept&ar04b-StuActiveProgDept&ar04e
									StuActiveProgCurStatus&ar04b-StuActiveProgCurStatus&ar04e
									StuActiveProgCurStatusDate&ar04b-StuActiveProgCurStatusDate&ar04e
									StuActiveProgStartDate&ar04b-StuActiveProgStartDate&ar04e
									StuActiveProgEndDate&ar04b-StuActiveProgEndDate&ar04e
;
	ARRAY pc (&ar04e) $12. StuActiveProgCode&ar04b-StuActiveProgCode&ar04e;
	ARRAY pt (&ar04e) $39. StuActiveProgTitle&ar04b-StuActiveProgTitle&ar04e;
	ARRAY pd (&ar04e) $6.  StuActiveProgDept&ar04b-StuActiveProgDept&ar04e;
	ARRAY cs (&ar04e) $3.  StuActiveProgCurStatus&ar04b-StuActiveProgCurStatus&ar04e;
	ARRAY sd (&ar04e) $10. StuActiveProgCurStatusDate&ar04b-StuActiveProgCurStatusDate&ar04e;
	ARRAY st (&ar04e) $10. StuActiveProgStartDate&ar04b-StuActiveProgStartDate&ar04e;
	ARRAY ed (&ar04e) $8.  StuActiveProgEndDate&ar04b-StuActiveProgEndDate&ar04e;
SET FIXProgramCode; BY ADCPersonID;
	IF FIRST.ADCPersonID THEN DO;
		i=&ar04b;
		DO j=&ar04b TO &ar04e;
			pc(j)=' ';
			pt(j)=' ';
			pd(j)=' ';
			cs(j)=' ';
			sd(j)=' ';
			st(j)=' ';
			ed(j)=' ';
		END;
	END;
	pc(i)=ADCStuAcadPrograms;
	pt(i)=ADCStuAcadProgramTitle;
	pd(i)=ADCStuProgDept;
	cs(i)=ADCStuProgCurrentStatus;
	sd(i)=ADCStuProgCurrentStatusDate;
	st(i)=ADCStuProgStartDate;
	ed(i)=ADCStuProgEndDate;
	IF LAST.ADCPersonID THEN OUTPUT;
	i+1;
*PROC PRINT DATA=st15APArray;
RUN;

DATA mergest14downb;
	MERGE
			CURbPrimary
			CCEb
			BSPb
			CURCCEBSPActiveProgs01b
; 
BY ADCPersonID;
RUN;

* END - SECTION st14downb - SEPERATES PRIMARY CUR/CCE/BSP PROGRAM CODES INTO SEPERATE VARIABLES
								AND MERGES THEM *;

* BEGIN - SECTION merge09021105070314a - MERGES merge090211050703c AND mergest14downb DATASETS *;

DATA merge090211070314a;
	MERGE merge0902110703d(IN=a) mergest14downb(IN=b); BY ADCPersonID;
	IF a*b=1;
RUN;

DATA merge090211070314b;
	MERGE merge0902110703d(IN=a) mergest14downb(IN=b); BY ADCPersonID;
	IF a AND NOT b;
RUN;

DATA merge090211070314c;
	MERGE merge090211070314a merge090211070314b; BY ADCPersonID;
RUN;

* END - SECTION merge09021105070314a - MERGES merge090211050703c AND mergest14downb DATASETS *;


* BEGIN - SECTION st15downa - IMPORTS st15 DATA *;

DATA st15downa (KEEP=
						ADCPersonID
						ADCStuTypes
						ADCStuMostRecentTerm
						ADCStuActivePrograms
						ADCStuProgAcadLevel
						ADCStuAllTerms
						ADCStuCurrentType
						ADCStuFirstCUProgram
						ADCStuEdGoals
						ADCStuTypes
						ADCStuTypesEndDate
);
INFILE "&Path00&Infile15"  LINESIZE=800 TRUNCOVER;
INPUT @1 ADCPersonID $10. @;
	SELECT;
	WHEN (ADCPersonID NE 'STUDENTS  ') DO;
		INPUT @1	ADCPersonID				$10.
			@11		ADCStuTypes				$6.
			@58		ADCStuMostRecentTerm	$7.
			@65		ADCStuActivePrograms	$12.
			@65		ADCStuProgAcadLevel		$5.
			@127	ADCStuAllTerms			$7.
			@162	ADCStuCurrentType		$6.
			@197	ADCStuFirstCUProgram	$12.
			@217	ADCStuEdGoals			$3.
			@247	ADCStuTypes				$6.
			@282	ADCStuTypesEndDate		$10.
;
		OUTPUT st15downa;
	END;
	OTHERWISE DO;
	PUT 'Error in record ' _n_ 'as follows:' _INFILE_;
		DELETE;
	END;
END;
/*PROC SORT NODUPKEY DATA=st15downa; BY ADCPersonID;*/
*PROC PRINT DATA=st15downa;
RUN;

* END - SECTION st15downa - IMPORTS st15 DATA *;

* BEGIN - SECTION st15downb - REPEATS NECESSARY VARIABLES VALUES FOR st15downa *;

DATA st15downb;
SET st15downa;
	RETAIN CST;
	DROP   CST;
	RETAIN FCP;
	DROP   FCP;
	RETAIN PID1;
	DROP   PID1;
  IF ADCPersonID EQ ' ' AND ADCStuCurrentType EQ ' ' 
     THEN ADCStuCurrentType=CST;
     ELSE CST=ADCStuCurrentType;
  IF ADCPersonID EQ ' ' AND ADCStuFirstCUProgram EQ ' ' 
     THEN ADCStuFirstCUProgram=FCP;
     ELSE FCP=ADCStuFirstCUProgram;
  IF ADCPersonID EQ ' ' 
     THEN ADCPersonID=PID1;
     ELSE PID1=ADCPersonID;
/*PROC SORT NODUPKEY DATA=st07downb; BY ADCPersonID;*/
*PROC PRINT DATA=st07downb;
*PROC FREQ DATA=st15downb ORDER=FREQ;
*	TABLES ADCPersonID;
RUN;

* END - SECTION st15downb - REPEATS NECESSARY VARIABLES VALUES FOR st15downa *;

* BEGIN - SECTION st15downc - REORDERS ADCStuEDGoals LATEST TO EARLIEST *;

DATA st15downc (KEEP=ADCPersonID ADCStuEdGoals ADCStuCurrentType ADCStuFirstCUProgram COUNT);
SET st15downb;
COUNT+1;
IF ADCStuEdGoals EQ '  ' THEN DELETE;
PROC SORT DATA=st15downc; BY ADCPersonID DESCENDING COUNT;
*PROC PRINT DATA=st15downc;
*PROC FREQ DATA=st15downc ORDER=FREQ;
RUN;

* END - SECTION st15downc - REORDERS ADCStuEDGoals LATEST TO EARLIEST *;

* BEGIN - SECTION st15EGArray - ARRAYS ADCStuEDGoals LATEST TO EARLIEST *;

DATA trunc25eg;
SET st15downc; BY ADCPersonID;
	IF FIRST.ADCPersonID THEN count25=0;
		count25+1;
		IF count25 LE 25 THEN OUTPUT;
RUN;

DATA st15EGArray (KEEP=
						ADCPersonID  
						ADCStuCurrentType 
						ADCStuFirstCUProgram 
						ADCStuEdGoals&ar03b-ADCStuEdGoals&ar03e
);
RETAIN					ADCStuEdGoals&ar03b-ADCStuEdGoals&ar03e;
	ARRAY	edg (&ar03e) $3.	ADCStuEdGoals&ar03b-ADCStuEdGoals&ar03e;
SET trunc25eg; BY ADCPersonID;
	IF FIRST.ADCPersonID THEN DO;
		i=1;
		DO j=1 TO &ar03e;
			edg(j)=' ';
		END;
	END;
	edg(i)=ADCStuEdGoals;
	IF LAST.ADCPersonID THEN OUTPUT;
	i+1;
/*PROC PRINT DATA=st15EGArray;
RUN;*/

* END - SECTION st15EGArray - ARRAYS ADCStuEDGoals LATEST TO EARLIEST *;

* BEGIN - SECTION st15downd - UNDUPLICATES ACTIVE PROGRAMS IN st15downb *;

DATA st15downd (KEEP=ADCPersonID ADCStuActivePrograms);
SET st15downb;
IF ADCStuActivePrograms EQ ' ' THEN DELETE;
PROC SORT NODUPKEY DATA=st15downd; BY ADCPersonID ADCStuActivePrograms;
*PROC FREQ DATA=st15downd ORDER=FREQ;
*	TABLES ADCPersonID;
RUN;

* END - SECTION st15downd - UNDUPLICATES ACTIVE PROGRAMS IN st15downb *;

* BEGIN - SECTION st15APArray - ARRAYS ADCStuActivePrograms *;

DATA st15APArray (KEEP=ADCPersonID
						ADCStuActivePrograms&ar04b-ADCStuActivePrograms&ar04e);
RETAIN ADCStuActivePrograms&ar04b-ADCStuActivePrograms&ar04e;
	ARRAY ap (&ar04e) $ ADCStuActivePrograms&ar04b-ADCStuActivePrograms&ar04e;
	SET st15downd; BY ADCPersonID;
	IF FIRST.ADCPersonID THEN DO;
		i=1;
		DO j=1 TO &ar04e;
			ap(j)=' ';
		END;
	END;
	ap(i)=ADCStuActivePrograms;
	IF LAST.ADCPersonID THEN OUTPUT;
	i+1;
*PROC PRINT DATA=st15APArray;
RUN;

* END - SECTION st15APArray - ARRAYS ADCStuActivePrograms *;

* BEGIN - SECTION st15down_TERMS - RENAMES CU TERMS CU0 CU1 CU2 CU3 THEN SELECTS LATEST 10 CU TERMS AND CE TERMS
									AND PLACES THEM INTO ARRAYS*;

DATA st15downe (KEEP=
					ADCPersonID
					ADCStuCUTerms
);
SET st15downb;
LENGTH ADCStuCUTerms $7.;
IF (SUBSTR(ADCStuAllTerms,5,2)) EQ 'CE' THEN DELETE;
*ADCStuCUTerms=ADCStuAllTerms;
year=(SUBSTR(ADCStuAllTerms,1,4));
*IF year LT "&CutOff" THEN DELETE;
IF (SUBSTR(ADCStuAllTerms,5,2)) EQ 'FA' THEN temp='CU3';
	ELSE IF (SUBSTR(ADCStuAllTerms,5,2)) EQ 'SU' THEN temp='CU2';
	ELSE IF (SUBSTR(ADCStuAllTerms,5,2)) EQ 'SP' THEN temp='CU1';
	ELSE IF (SUBSTR(ADCStuAllTerms,5,2)) EQ 'WI' THEN temp='CU0';
ADCStuCUTerms=(TRIM(LEFT(year)))||(TRIM(LEFT(temp)));
IF ADCStuCUTerms GT "&rt01b" THEN DELETE;
PROC SORT NODUPKEY DATA=st15downe; BY ADCPersonID DESCENDING ADCStuCUTerms;
/*ODS LISTING;*/
/*PROC FREQ DATA=st15downe ORDER=FREQ;*/
/*	TABLES ADCPersonID;*/
RUN;

DATA FirstCUTerm01 (KEEP=
						ADCPersonID
						FirstCUTerm
);
FORMAT
		FirstCUTerm $7.
;
SET st15downe;
FirstCUTerm=ADCStuCUTerms;
IF FirstCUTerm IN (
					' '
					) THEN DELETE;
PROC SORT DATA=FirstCUTerm01; BY ADCPersonID FirstCUTerm;
PROC SORT NODUPKEY DATA=FirstCUTerm01; BY ADCPersonID;
RUN;


DATA trunc10;
SET st15downe; BY ADCPersonID;
	IF FIRST.ADCPersonID THEN count=0;
		count+1;
		IF count LE 10 THEN OUTPUT;
RUN;

DATA st15collapseb (KEEP=
						ADCPersonID 
						ADCStuCUTerms01-ADCStuCUTerms10
);
RETAIN ADCStuCUTerms01-ADCStuCUTerms10;
	ARRAY st1 (10) $ ADCStuCUTerms01-ADCStuCUTerms10;
	SET trunc10; BY ADCPersonID;
	IF FIRST.ADCPersonID THEN DO;
		i=1;
		DO j=1 TO 10;
			st1(j)=' ';
		END;
	END;
	st1(i)=ADCStuCUTerms;
	IF LAST.ADCPersonID THEN OUTPUT;
	i+1;
*PROC PRINT DATA=st15collapseb;
RUN;

DATA st15downf (KEEP=ADCPersonID
						ADCStuCETerms);
SET st15downb;
LENGTH ADCStuCETerms $7.;
IF (SUBSTR(ADCStuAllTerms,5,2)) EQ 'CE';
ADCStuCETerms=ADCStuAllTerms;
IF ADCStuCETerms GT "&rt02b" THEN DELETE;
PROC SORT NODUPKEY DATA=st15downf; BY ADCPersonID DESCENDING ADCStuCETerms;
*PROC FREQ DATA=st15downf ORDER=FREQ;
*	TABLES ADCPersonID;
RUN;

DATA FirstCETerm01 (KEEP=
						ADCPersonID
						FirstCETerm
);
FORMAT
		FirstCETerm $7.
;
SET st15downf;
FirstCETerm=ADCStuCETerms;
IF FirstCETerm IN (
					' '
					) THEN DELETE;
PROC SORT DATA=FirstCETerm01; BY ADCPersonID FirstCETerm;
PROC SORT NODUPKEY DATA=FirstCETerm01; BY ADCPersonID;
RUN;

DATA trunc10b;
SET st15downf; BY ADCPersonID;
	IF FIRST.ADCPersonID THEN count=0;
		count+1;
		IF count LE 10 THEN OUTPUT;
RUN;


DATA st15collapsec (KEEP=ADCPersonID 
						ADCStuCETerms01-ADCStuCETerms10);
RETAIN ADCStuCETerms01-ADCStuCETerms10;
	ARRAY st1 (10) $ ADCStuCETerms01-ADCStuCETerms10;
	SET trunc10b; BY ADCPersonID;
	IF FIRST.ADCPersonID THEN DO;
		i=1;
		DO j=1 TO 10;
			st1(j)=' ';
		END;
	END;
	st1(i)=ADCStuCETerms;
	IF LAST.ADCPersonID THEN OUTPUT;
	i+1;
*PROC PRINT DATA=st15collapsec;
RUN;

* END - SECTION st15down_TERMS - RENAMES CU TERMS CU0 CU1 CU2 CU3 THEN SELECTS LATEST 10 CU TERMS AND CE TERMS
									AND PLACES THEM INTO ARRAYS*;

* BEGIN - SECTION st15downMERGE - MERGES INDIVIDUAL PARTS OF st15down DATASET *;

DATA st15collapse;
	MERGE st15EGArray st15APArray st15collapseb st15collapsec FirstCUTerm01 FirstCETerm01; BY ADCPersonID;
RUN;

* END - SECTION st15downMERGE - MERGES INDIVIDUAL PARTS OF st15down DATASET *;

* BEGIN - SECTION merge0902110507031415a - MERGES merge09021105070314c AND st15collapse DATASETS *;

DATA merge09021107031415a;
	MERGE merge090211070314c(IN=a) st15collapse(IN=b); BY ADCPersonID;
	IF a*b=1;
RUN;

DATA merge09021107031415b;
	MERGE merge090211070314c(IN=a) st15collapse(IN=b); BY ADCPersonID;
	IF a AND NOT b;
RUN;

DATA merge09021107031415c;
	MERGE merge09021107031415a merge09021107031415b; BY ADCPersonID;
RUN;

* END - SECTION merge09021107031415a - MERGES merge090211070314c AND st15collapse DATASETS *;

/* ADD IPEDS RACE FIELD */
data ipedsrace;
set merge09021107031415c;
IF ADCStuCitizenship not in ('US','USA',' ') and ADCStuVisaType not in ('PR') THEN IPEDSRace='Nonresident Alien';
ELSE IF ADCStuEthnic in ('HIS') THEN IPEDSRace='Hispanic/Latino';
ELSE IF ADCStuRaces02 NE ' '
	OR ADCStuRaces03 NE ' '
	OR ADCStuRaces04 NE ' '
	OR ADCStuRaces05 NE ' '
	OR ADCStuRaces06 NE ' '
	OR ADCStuRaces07 NE ' '
	OR ADCStuRaces08 NE ' '
	OR ADCStuRaces09 NE ' '
	OR ADCStuRaces10 NE ' '	 THEN IPEDSRace='Two or More Races';
ELSE IF ADCStuRaces01 EQ ' ' THEN IPEDSRace='Unknown';
ELSE IF ADCStuRaces01 EQ 'AS' THEN IPEDSRace='Asian';
ELSE IF ADCStuRaces01 EQ 'BL' THEN IPEDSRace='Black/African American';
ELSE IF ADCStuRaces01 EQ 'AN' THEN IPEDSRace='American Indian/Alaskan Native';
ELSE IF ADCStuRaces01 EQ 'WH' THEN IPEDSRace='White';
ELSE IF ADCStuRaces01 EQ 'HP' THEN IPEDSRace='Hawaiian/Other Pacific Islander';
ELSE IPEDSRace='Unknown';

IF ADCStuEthnic in ('HIS') THEN InstRaceEthnic='Hispanic/Latino               ';
ELSE IF ADCStuRaces02 NE ' '
	OR ADCStuRaces03 NE ' '
	OR ADCStuRaces04 NE ' '
	OR ADCStuRaces05 NE ' '
	OR ADCStuRaces06 NE ' '
	OR ADCStuRaces07 NE ' '
	OR ADCStuRaces08 NE ' '
	OR ADCStuRaces09 NE ' '
	OR ADCStuRaces10 NE ' '	 THEN InstRaceEthnic='Two or More Races';
ELSE IF ADCStuRaces01 EQ ' ' THEN InstRaceEthnic='Unknown';
ELSE IF ADCStuRaces01 EQ 'AS' THEN InstRaceEthnic='Asian';
ELSE IF ADCStuRaces01 EQ 'BL' THEN InstRaceEthnic='Black/African American';
ELSE IF ADCStuRaces01 EQ 'AN' THEN InstRaceEthnic='American Indian/Alaskan Native';
ELSE IF ADCStuRaces01 EQ 'WH' THEN InstRaceEthnic='White';
ELSE IF ADCStuRaces01 EQ 'HP' THEN InstRaceEthnic='Hawaiian/Other Pacific Islander';
ELSE InstRaceEthnic='Unknown';

Age=1*(SUBSTR(ADCStuClsTerm,1,4))-INT(BirthDate/10000);
run;


DATA STFinal (KEEP=
		InstTerm
		InstDataPoint
		ADCPersonID 
		ADCStuSSN
		ADCStuCitizenship
		ADCStuAltIDs
		ADCStuLastName
		ADCStuFirstName
		ADCStuMiddleName
		ADCStuNameSuffix
		ADCStuPreviousLastNames
		ADCStuMailAddress1
		ADCStuMailCity
		ADCStuMailState
		ADCStuMailZip
		ADCStuCounty
		ADCStuMailAddress1Type
		ADCStuPersonalPhone
		ADCStuPersonalPhoneType
		ADCStuEmergencyPhone
		ADCStuBirthDate
		BirthDate
		Age
		ADCStuEthnicOLD
		ADCStuGender
		ADCStuMailingCountry
		ADCStuResidenceCountry
		ADCStuResidenceState
		ADCStuEmploymentStatus
		ADCStuVeteranType
		ADCStuDeceasedDate
		ADCStuDriverLicenseState
		ADCStuDriverLicenseNumber
		ADCStuMaritalStatus
		ADCStuEMailAddress
		ADCStuEMailType
		ADCStuPrivacyFlag
		ADCStuVisaType
		ADCStuAddDate
		ADCStuAddOpr
		ADCStuChgDate
		ADCStuChgOpr
		IPEDSRace
		InstRaceEthnic
		ADCStuEthnic
		ADCStuRaces
		ADCStuRaces&ar02b-ADCStuRaces&ar02e
		ADCStuPrimaryEthnic
		ADCStuPrimaryRace
		ADCStuStEMailAddress 
		ADCStuPriEMailAddress 
		ADCStuCPCCEmpEMailAddress 
		ADCStuOtrEMailAddress					
		ADCStuHomePhone 
		ADCStuCellPhone 
		ADCStuBusPhone 
		ADCStuOtrPhone
		ADCStuClsTerm
		ADCStuClsReportTerm
		TotalCUCredits
		TotalCEUs
		ADCStuClsRegMethod&ar01b-ADCStuClsRegMethod&ar01e
		ADCStuClsStatus&ar01b-ADCStuClsStatus&ar01e
		ADCStuClsStatusReason&ar01b-ADCStuClsStatusReason&ar01e
		ADCStuClsStatusDate&ar01b-ADCStuClsStatusDate&ar01e
		ADCStuClsStatusTime&ar01b-ADCStuClsStatusTime&ar01e
		ADCStuClsVrfdGradeChgOpr&ar01b-ADCStuClsVrfdGradeChgOpr&ar01e
		ADCStuClsVrfdGradeDate&ar01b-ADCStuClsVrfdGradeDate&ar01e
		ADCStuClsVrfdGradeCode&ar01b-ADCStuClsVrfdGradeCode&ar01e
		Class&ar01b-Class&ar01e
		ADCClsID&ar01b-ADCClsID&ar01e
		ExitTranslation&ar01b-ExitTranslation&ar01e
		ADCStuAcadLevel
		ADCStuGRSAdmitStatus
		ADCStuFederalCohortGroup
		ADCStuCreditAttempted
		ADCStuCreditCompleted
		ADCStuCummulativeGPA
		ADCStuProgramGPA
		ADCStuHighSchoolCode
		ADCStuHighSchoolName
		ADCStuHighSchoolStartDate
		ADCStuHighSchoolEndDate
		ADCStuHighSchoolGraduationType
		ADCStuHighSchoolTranscriptType
		ADCStuHighSchoolTranscriptDate
		ADCStuHighSchoolTranscriptStatus
		ADCStuHighSchoolType
		ADCStuHighSchoolGPA
		ADCStuInmateFlag
		ADCStuEconDisAdvFlag
		ADCStuSingleParentFlag
		ADCStuHeadHouseholdFlag
		ADCStuLimitEnglishFlag
		ADCStuHighSchoolTrack
		ADCStuEduEntryLvl
		ADCStuEduLvl
		ADCStuFtrDegLvl
		ADCStuMtrDegLvl
		ADCStuPrimaryProgramCode
		ADCStuCURPriProgTitle
		ADCStuCURPriProgAdmitStatus
		ADCStuCURPriProgCatalogYear
		ADCStuCURPriProgCurStatus
		ADCStuCURPriProgCurStatusDate
		ADCStuCURPriProgEndDate
		ADCStuCURPriProgStartDate
		ADCStuCURPriProgDept
		ADCStuCURPriProgCode
		ADCStuCCEPriProgCode
		ADCStuCCEPriProgTitle
		ADCStuCCEPriProgCCECurStatus
		ADCStuCCEPriProgCCECurStatusDate
		ADCStuCCEPriProgEndDate
		ADCStuCCEPriProgStartDate
		ADCStuCCEPriProgDept
		ADCStuBSPPriProgCode
		ADCStuBSPPriProgTitle
		ADCStuBSPPriProgCurStatus
		ADCStuBSPPriProgCurStatusDate
		ADCStuBSPPriProgEndDate
		ADCStuBSPPriProgStartDate
		ADCStuBSPPriProgDept
		ADCStuCurrentType
		ADCStuFirstCUProgram
		ADCStuEdGoals&ar03b-ADCStuEdGoals&ar03e
		ADCStuActivePrograms&ar04b-ADCStuActivePrograms&ar04e
		StuActiveProgCode&ar04b-StuActiveProgCode&ar04e
		StuActiveProgTitle&ar04b-StuActiveProgTitle&ar04e
		StuActiveProgDept&ar04b-StuActiveProgDept&ar04e
		StuActiveProgCurStatus&ar04b-StuActiveProgCurStatus&ar04e
		StuActiveProgCurStatusDate&ar04b-StuActiveProgCurStatusDate&ar04e
		StuActiveProgStartDate&ar04b-StuActiveProgStartDate&ar04e
		StuActiveProgEndDate&ar04b-StuActiveProgEndDate&ar04e
		ADCStuCUTerms01-ADCStuCUTerms10
		ADCStuCETerms01-ADCStuCETerms10
		FirstCUTerm
		FirstCETerm
		InstCountry
		InstState
		InstShortName
		InstID
		InstIPEDSUnitID
		InstOPEID
		InstTerm
);
RETAIN
		InstTerm
		InstDataPoint
		ADCPersonID 
		ADCStuSSN
		ADCStuCitizenship
		ADCStuAltIDs
		ADCStuLastName
		ADCStuFirstName
		ADCStuMiddleName
		ADCStuNameSuffix
		ADCStuPreviousLastNames
		ADCStuMailAddress1
		ADCStuMailCity
		ADCStuMailState
		ADCStuMailZip
		ADCStuCounty
		ADCStuMailAddress1Type
		ADCStuPersonalPhone
		ADCStuPersonalPhoneType
		ADCStuEmergencyPhone
		ADCStuBirthDate
		BirthDate
		Age
		ADCStuEthnicOLD
		ADCStuGender
		ADCStuMailingCountry
		ADCStuResidenceCountry
		ADCStuResidenceState
		ADCStuEmploymentStatus
		ADCStuVeteranType
		ADCStuDeceasedDate
		ADCStuDriverLicenseState
		ADCStuDriverLicenseNumber
		ADCStuMaritalStatus
		ADCStuEMailAddress
		ADCStuEMailType
		ADCStuPrivacyFlag
		ADCStuVisaType
		ADCStuAddDate
		ADCStuAddOpr
		ADCStuChgDate
		ADCStuChgOpr
		IPEDSRace
		InstRaceEthnic
		ADCStuEthnic
		ADCStuRaces
		ADCStuRaces&ar02b-ADCStuRaces&ar02e
		ADCStuPrimaryEthnic
		ADCStuPrimaryRace
		ADCStuStEMailAddress 
		ADCStuPriEMailAddress 
		ADCStuCPCCEmpEMailAddress 
		ADCStuOtrEMailAddress					
		ADCStuHomePhone 
		ADCStuCellPhone 
		ADCStuBusPhone 
		ADCStuOtrPhone
		ADCStuClsTerm
		ADCStuClsReportTerm
		TotalCUCredits
		TotalCEUs
		ADCStuClsRegMethod&ar01b-ADCStuClsRegMethod&ar01e
		ADCStuClsStatus&ar01b-ADCStuClsStatus&ar01e
		ADCStuClsStatusReason&ar01b-ADCStuClsStatusReason&ar01e
		ADCStuClsStatusDate&ar01b-ADCStuClsStatusDate&ar01e
		ADCStuClsStatusTime&ar01b-ADCStuClsStatusTime&ar01e
		ADCStuClsVrfdGradeChgOpr&ar01b-ADCStuClsVrfdGradeChgOpr&ar01e
		ADCStuClsVrfdGradeDate&ar01b-ADCStuClsVrfdGradeDate&ar01e
		ADCStuClsVrfdGradeCode&ar01b-ADCStuClsVrfdGradeCode&ar01e
		Class&ar01b-Class&ar01e
		ADCClsID&ar01b-ADCClsID&ar01e
		ExitTranslation&ar01b-ExitTranslation&ar01e
		ADCStuAcadLevel
		ADCStuGRSAdmitStatus
		ADCStuFederalCohortGroup
		ADCStuCreditAttempted
		ADCStuCreditCompleted
		ADCStuCummulativeGPA
		ADCStuProgramGPA
		ADCStuHighSchoolCode
		ADCStuHighSchoolName
		ADCStuHighSchoolStartDate
		ADCStuHighSchoolEndDate
		ADCStuHighSchoolGraduationType
		ADCStuHighSchoolTranscriptType
		ADCStuHighSchoolTranscriptDate
		ADCStuHighSchoolTranscriptStatus
		ADCStuHighSchoolType
		ADCStuHighSchoolGPA
		ADCStuInmateFlag
		ADCStuEconDisAdvFlag
		ADCStuSingleParentFlag
		ADCStuHeadHouseholdFlag
		ADCStuLimitEnglishFlag
		ADCStuHighSchoolTrack
		ADCStuEduEntryLvl
		ADCStuEduLvl
		ADCStuFtrDegLvl
		ADCStuMtrDegLvl
		ADCStuPrimaryProgramCode
		ADCStuCURPriProgTitle
		ADCStuCURPriProgAdmitStatus
		ADCStuCURPriProgCatalogYear
		ADCStuCURPriProgCurStatus
		ADCStuCURPriProgCurStatusDate
		ADCStuCURPriProgEndDate
		ADCStuCURPriProgStartDate
		ADCStuCURPriProgDept
		ADCStuCURPriProgCode
		ADCStuCCEPriProgCode
		ADCStuCCEPriProgTitle
		ADCStuCCEPriProgCCECurStatus
		ADCStuCCEPriProgCCECurStatusDate
		ADCStuCCEPriProgEndDate
		ADCStuCCEPriProgStartDate
		ADCStuCCEPriProgDept
		ADCStuBSPPriProgCode
		ADCStuBSPPriProgTitle
		ADCStuBSPPriProgCurStatus
		ADCStuBSPPriProgCurStatusDate
		ADCStuBSPPriProgEndDate
		ADCStuBSPPriProgStartDate
		ADCStuBSPPriProgDept
		ADCStuCurrentType
		ADCStuFirstCUProgram
		ADCStuEdGoals&ar03b-ADCStuEdGoals&ar03e
		ADCStuActivePrograms&ar04b-ADCStuActivePrograms&ar04e
		StuActiveProgCode&ar04b-StuActiveProgCode&ar04e
		StuActiveProgTitle&ar04b-StuActiveProgTitle&ar04e
		StuActiveProgDept&ar04b-StuActiveProgDept&ar04e
		StuActiveProgCurStatus&ar04b-StuActiveProgCurStatus&ar04e
		StuActiveProgCurStatusDate&ar04b-StuActiveProgCurStatusDate&ar04e
		StuActiveProgStartDate&ar04b-StuActiveProgStartDate&ar04e
		StuActiveProgEndDate&ar04b-StuActiveProgEndDate&ar04e
		ADCStuCUTerms01-ADCStuCUTerms10
		ADCStuCETerms01-ADCStuCETerms10
		FirstCUTerm
		FirstCETerm
		InstCountry
		InstState
		InstShortName
		InstID
		InstIPEDSUnitID
		InstOPEID
		InstTerm
;
FORMAT
		InstDataPoint $10.
		InstCountry $3.
		InstState $3.
		InstID $10.
		InstShortName $10.
		InstTerm $10.
		InstIPEDSUnitID $10.
		InstOPEID $10.
;
SET ipedsrace;
InstDataPoint=UPCASE(COMPRESS("&rp01","_"));
InstCountry="&IC01";
InstState="&IS01";
InstID="&II01";
InstShortName="&IN01";
InstIPEDSUnitID="&IU01";
InstOPEID="&OI01";
InstTerm="&YT01";
DROP
		_TYPE_
		_FREQ_
		ADCStuPrimaryProgramFlag
	;
RUN;

ODS LISTING CLOSE;
ODS HTML CLOSE;
ODS MARKUP TAGSET=CHTML BODY="&PathRoot\XX_SAS_TrashBin\Report01.html";

/* find students with multiple primary program codes */
data priprog;
set CURb0;
if ADCStuPrimaryProgramFlag in (
								'Y',
								' '
								)
	AND ADCStuCURPriProgCurStatus not in (
										'G'
										);
run;

data priprog2;
set priprog;
by ADCPersonID;
if first.ADCPersonID=1 then count=1;
else count+1;
run;

proc print data=priprog2 NOOBS;
var ADCPersonID;
where count=2;
title "THESE STUDENTS HAVE MULTIPLE PROGRAMS INDICATED AS PRIMARY";
run;

ODS MARKUP TAGSET=CHTML CLOSE;


/* Output to H drive */
data &lb01 .&ds01&yt01&rp01;
set STFinal;
run;



/*
DATA &lb02 .&ds01&rp01&yt01;
SET merge090211050703141512a;
RUN;
*/

/**/
/*ODS LISTING CLOSE;*/
/*ODS HTML CLOSE;*/
/*ODS MARKUP TAGSET=CHTML BODY='P:\CPCCSASDatasets\A_XNC_Datatel\XX_SAS_TrashBin\Report01.html';*/
/*LIBNAME pge "P:\CPCCSASDatasets\A_XNC_Datatel\Downloads\SASDatasets\02_Student";*/
/*%LET lb01=pge;*/
/*%LET ds01=st_;*/
/*%LET ds02=201103;*/
/*%LET ds03=_et;*/
/*PROC CONTENTS DATA=&lb01 .&ds01&ds02&ds03;*/
/*RUN;*/
/**/
/*ODS MARKUP TAGSET=CHTML CLOSE;*/


