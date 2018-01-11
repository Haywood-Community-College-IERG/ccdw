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
* PURPOSE:      Create Student Test Scores SAS Datasets                             *
*               For Any Term/Date                                                   *
*************************************************************************************;
OPTIONS PS=32765 LS=200 NONUMBER NOCENTER;

%LET PathRoot=W:\InstitutionalResearch\A_XNC_Datatel;

LIBNAME Stu6 "&PathRoot\Downloads\SASDatasets\02_Student";

%LET Path00=&PathRoot\Downloads\;

%LET Infile05=ST_05_XNC_ST_SAS_NON_COURSE_DATA.txt;

%LET lb01=Stu6;
%LET ds01=TS_;
%LET rp01=_ET;		* CHANGE FOR EACH DATASET CREATION DATA POINT;

%LET yt01=201403;	* CHANGE FOR EACH DATASET CREATION TERM;

* NO CHANGES REQUIRED AFTER THIS POINT;
*-----------------------------------*;

%LET IC01=US;		* Country of Institution;
%LET IS01=NC;		* State of Institution;
%LET II01=882;		* state institution ID;
%LET IN01=SWCC;	* Institution Short name;
%LET IU01=199731;	* IPEDS Unit ID;
%LET OI01=008466;	* OPE ID / FICE Code;

* BEGIN - SECTION st05downa - IMPORTS st05 FLAT TEXT FILE *;

DATA st05downa (KEEP=
					ADCPersonID
					ADCStuNonCourseType
					ADCStuNonCourseSource
					ADCStuNonCourseCategory
					ADCStuNonCourseCatTrans
					ADCStuNonCourseStartDate
					ADCStuNonCourseEndDate
					ADCStuNonCourseStatus
					ADCStuNonCourseStatusDate
					ADCStuNonCourseCode
					ADCStuNonCourseTitle
					ADCStuNonCourseScoreX
					ADCStuNonCourseGrade
					ADCStuNonCourseGradeScheme
);
INFILE "&Path00&Infile05"  LINESIZE=800;
INPUT @1 ADCPersonID $10. @;
	SELECT;
	WHEN (ADCPersonID NE 'Person ID') DO;
		INPUT @1	ADCPersonID							$10.
			@11		ADCStuNonCourseType					$6.
			@41		ADCStuNonCourseSource				$4.
			@71		ADCStuNonCourseCategory				$3.
			@96		ADCStuNonCourseCatTrans				$15.
			@121	ADCStuNonCourseStartDate			$10.
			@131	ADCStuNonCourseEndDate				$8.
			@139	ADCStuNonCourseStatus				$6.
			@169	ADCStuNonCourseStatusDate			$10.
			@180	ADCStuNonCourseCode					$10.
			@190	ADCStuNonCourseTitle				$30.
			@220	ADCStuNonCourseScoreX				$5.
			@225    ADCStuNonCourseGrade                $5. 
			@230    ADCStuNonCourseGradeScheme          $7.
;
		OUTPUT st05downa;
	END;
	OTHERWISE DO;
	PUT 'Error in record ' _n_ 'as follows:' _INFILE_;
		DELETE;
	END;
END;
PROC SORT DATA=st05downa; BY ADCPersonID ADCStuNonCourseCode;
*PROC PRINT DATA=st05downa;
RUN;

* END - SECTION st05downa - IMPORTS st05 FLAT TEXT FILE *;


DATA st05downb (KEEP=
					YearTerm
					ADCPersonID
					ADCStuNonCourseCode
					ADCStuNonCourseTitle
					ADCStuNonCourseScoreX
					ADCStuNonCourseScore
					ADCStuNonCourseStatus
					ADCStuNonCourseType
					ADCStuNonCourseSource
					ADCStuNonCourseCategory
					ADCStuNonCourseCatTrans
					ADCStuNonCourseStartDate
					ADCStuNonCourseEndDate
					ADCStuNonCourseStatusDate
					ADCStuNonCourseGrade
					ADCStuNonCourseGradeScheme
					StartDate8
					EndDate8
					StatusDate8
);
RETAIN
					YearTerm
					ADCPersonID
					ADCStuNonCourseCode
					ADCStuNonCourseTitle
					ADCStuNonCourseScore
					ADCStuNonCourseStatus
					ADCStuNonCourseType
					ADCStuNonCourseSource
					ADCStuNonCourseCategory
					ADCStuNonCourseCatTrans
					ADCStuNonCourseStartDate
					ADCStuNonCourseEndDate
					ADCStuNonCourseStatusDate
					ADCStuNonCourseGrade
					ADCStuNonCourseGradeScheme
					StartDate8
					EndDate8
					StatusDate8
;
FORMAT 	StartDate8	$8.
		EndDate8	$8.
		StatusDate8	$8.
		YearTerm	$6.
		ADCStuNonCourseScore 5.
;
SET st05downa;
IF ADCStuNonCourseScoreX EQ 'Score' THEN DELETE;
IF ADCStuNonCourseScoreX EQ '0 (Bl' THEN ADCStuNonCourseScoreX='0';
IF ADCStuNonCourseGrade EQ 'ank)' THEN ADCStuNonCourseGrade=' ';
ADCStuNonCourseScore=INPUT(ADCStuNonCourseScoreX,5.);
YearTerm="&yt01";
IF ((ADCPersonID EQ . 
	OR ADCPersonID EQ ' ' 
	OR ADCPersonID EQ '.')
	AND ADCStuNonCourseType EQ ' '
	AND ADCStuNonCourseSource EQ ' '
	AND	ADCStuNonCourseCategory EQ ' '
	AND	ADCStuNonCourseCatTrans EQ ' '
	AND	ADCStuNonCourseStartDate EQ ' '
	AND	ADCStuNonCourseEndDate EQ ' '
	AND	ADCStuNonCourseStatus EQ ' '
	AND	ADCStuNonCourseStatusDate EQ ' '
	AND	ADCStuNonCourseCode EQ ' '
	AND	ADCStuNonCourseTitle EQ ' '
	AND ADCStuNonCourseScore EQ ' ') THEN DELETE;
IF ADCStuNonCourseStartDate EQ ' '
	THEN StartDate8=' ';
	ELSE IF (SUBSTR(ADCStuNonCourseStartDate,7,1)) EQ '8'
	OR (SUBSTR(ADCStuNonCourseStartDate,7,1)) EQ '9'
	THEN StartDate8='19'||(SUBSTR(ADCStuNonCourseStartDate,7,2))||(SUBSTR(ADCStuNonCourseStartDate,1,2))||(SUBSTR(ADCStuNonCourseStartDate,4,2));
	ELSE StartDate8='20'||(SUBSTR(ADCStuNonCourseStartDate,7,2))||(SUBSTR(ADCStuNonCourseStartDate,1,2))||(SUBSTR(ADCStuNonCourseStartDate,4,2));
IF ADCStuNonCourseEndDate EQ ' '
	THEN EndDate8=' ';
	ELSE IF (SUBSTR(ADCStuNonCourseEndDate,7,1)) EQ '8'
	OR (SUBSTR(ADCStuNonCourseEndDate,7,1)) EQ '9'
	THEN EndDate8='19'||(SUBSTR(ADCStuNonCourseEndDate,7,2))||(SUBSTR(ADCStuNonCourseEndDate,1,2))||(SUBSTR(ADCStuNonCourseEndDate,4,2));
	ELSE EndDate8='20'||(SUBSTR(ADCStuNonCourseEndDate,7,2))||(SUBSTR(ADCStuNonCourseEndDate,1,2))||(SUBSTR(ADCStuNonCourseEndDate,4,2));
IF ADCStuNonCourseStatusDate EQ ' '
	THEN StatusDate8=' ';
	ELSE IF (SUBSTR(ADCStuNonCourseStatusDate,7,1)) EQ '8'
	OR (SUBSTR(ADCStuNonCourseStatusDate,7,1)) EQ '9'
	THEN StatusDate8='19'||(SUBSTR(ADCStuNonCourseStatusDate,7,2))||(SUBSTR(ADCStuNonCourseStatusDate,1,2))||(SUBSTR(ADCStuNonCourseStatusDate,4,2));
	ELSE StatusDate8='20'||(SUBSTR(ADCStuNonCourseStatusDate,7,2))||(SUBSTR(ADCStuNonCourseStatusDate,1,2))||(SUBSTR(ADCStuNonCourseStatusDate,4,2));
run;

/*PROC PRINT DATA=st05downb;
RUN;*/

/* output to H drive */
DATA &lb01 .&ds01&yt01&rp01 (KEEP=
					YearTerm
					InstTerm
					INSTDataPoint
					ADCPersonID
					ADCStuNonCourseCode
					ADCStuNonCourseTitle
					ADCStuNonCourseScore
					ADCStuNonCourseGrade
					ADCStuNonCourseGradeScheme
					ADCStuNonCourseStatus
					ADCStuNonCourseType
					ADCStuNonCourseSource
					ADCStuNonCourseCategory
					ADCStuNonCourseCatTrans
					ADCStuNonCourseStartDate
					ADCStuNonCourseEndDate
					ADCStuNonCourseStatusDate
					StartDate8
					EndDate8
					StatusDate8
					InstCountry
					InstState
					InstShortName
					InstID
					InstIPEDSUnitID
					InstOPEID
);
RETAIN
					YearTerm
					InstTerm
					INSTDataPoint
					ADCPersonID
					ADCStuNonCourseCode
					ADCStuNonCourseTitle
					ADCStuNonCourseScore
					ADCStuNonCourseGrade
					ADCStuNonCourseGradeScheme
					ADCStuNonCourseStatus
					ADCStuNonCourseType
					ADCStuNonCourseSource
					ADCStuNonCourseCategory
					ADCStuNonCourseCatTrans
					ADCStuNonCourseStartDate
					ADCStuNonCourseEndDate
					ADCStuNonCourseStatusDate
					StartDate8
					EndDate8
					StatusDate8
					InstCountry
					InstState
					InstShortName
					InstID
					InstIPEDSUnitID
					InstOPEID
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
SET st05downb;
InstDataPoint=UPCASE(COMPRESS("&rp01","_"));
InstCountry="&IC01";
InstState="&IS01";
InstID="&II01";
InstShortName="&IN01";
InstIPEDSUnitID="&IU01";
InstOPEID="&OI01";
InstTerm="&YT01";
RUN;


/*
DATA &lb02 .&ds01&yt01&rp01;
SET merge090211050703141512a;
RUN;
*/


