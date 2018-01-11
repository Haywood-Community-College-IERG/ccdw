*************************************************************************************
* CREATED BY:   Paul G. Earls                                                       *
*               Institutional Research                                              *
*               Central Piedmont Community College                                  *
*               P. O. Box 35009                                                     *
*               Charlotte, NC 28235-5009                                            *
*               Phone: 704-330-6399                                                 *
*               FAX:   704-330-6013                                                 *
*               EMail: paul.earls@cpcc.edu                                          *
* CREATED DATE: 10-15-2009                                                          *
* MODIFIED1:                                                                        *
* MOD1 DATE:                                                                        *
* MODIFIED2:                                                                        *
* MOD2 DATE:                                                                        *
* REQUESTOR:    North Carolina Community College System                             *
* PURPOSE:      Create Student Institutions Attended SAS Datasets                   *
*               For Any Term/Date                                                   *
*************************************************************************************;
OPTIONS PS=32765 LS=100 NONUMBER NOCENTER;

%LET PathRoot=H:\Planning and Research FTP\CPCCSASDatasets\A_XNC_Datatel;

LIBNAME stu6 "&PathRoot\Downloads\SASDatasets\02_Student";

%LET Path00=&PathRoot\Downloads\;

%LET Infile07=ST_07_XNC_ST_SAS_INSTITUTIONS_ATTENDED_DATA.txt;

%LET lb01=stu6;
%LET ds01=STI_;
%LET rp01=_8W;				/* CHANGE FOR EACH REPORTING POINTS DATASET CREATION */

%LET yt01=201703;			/* CHANGE FOR EACH TERMS DATASET CREATIONS 01-SPRING, 02-SUMMER, 03-FALL */



*-----------------------------------;
*NO CHANGES NEEDED BEYOND THIS POINT;
*-----------------------------------;

%LET IC01=US;		* Country of Institution;
%LET IS01=NC;		* State of Institution;
%LET II01=818;		* state institution ID;
%LET IN01=CPCC;		* Institution Short name;
%LET IU01=198260;	* IPEDS Unit ID;
%LET OI01=002915;	* OPE ID / FICE Code;



* BEGIN - SECTION st07downa - IMPORTS st07 DOWNLOAD *;

DATA st07downa (KEEP=
						ADCPersonID
						ADCStuInstitutionCode
						ADCStuInstitutionName
						ADCStuInstitutionStartDate
						ADCStuInstitutionEndDate
						ADCStuInstitutionGraduationType
						ADCStuInstitutionTranscriptType
						ADCStuInstitutionTranscriptDate
						ADCStuInstitutionTrnscrptStatus
						ADCStuInstitutionType
						ADCStuInstitutionGPA
);
INFILE "&Path00&Infile07"  LINESIZE=800 TRUNCOVER;
INPUT @1 ADCPersonID $10. @;
	SELECT;
	WHEN (ADCPersonID NE 'Person ') DO;
		INPUT @1	ADCPersonID							$10.
			@11		ADCStuInstitutionCode				$10.
			@22		ADCStuInstitutionName				$25.
			@47		ADCStuInstitutionStartDate			$10.
			@64		ADCStuInstitutionEndDate			$10.
			@79		ADCStuInstitutionGraduationType		$3.
			@99		ADCStuInstitutionTranscriptType		$4.
			@120	ADCStuInstitutionTranscriptDate		$10.
			@141	ADCStuInstitutionTrnscrptStatus		$3.
			@169	ADCStuInstitutionType				$4.
			@174    ADCStuInstitutionGPA                 5.3
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
	RETAIN
			VAR01
			VAR02
			VAR03
			VAR04
			VAR05
			VAR06
			VAR07
			VAR08
			VAR09
;
	DROP
			VAR01
			VAR02
			VAR03
			VAR04
			VAR05
			VAR06
			VAR07
			VAR08
			VAR09
;
  IF ADCPersonID EQ ' ' AND ADCStuInstitutionCode EQ ' '
     THEN ADCStuInstitutionCode=VAR01;
     ELSE VAR01=ADCStuInstitutionCode;
  IF ADCPersonID EQ ' ' AND ADCStuInstitutionName EQ ' '
     THEN ADCStuInstitutionName=VAR02;
     ELSE VAR02=ADCStuInstitutionName;
  IF ADCPersonID EQ ' ' AND ADCStuInstitutionGraduationType EQ ' '
     THEN ADCStuInstitutionGraduationType=VAR03;
     ELSE VAR03=ADCStuInstitutionGraduationType;
  IF ADCPersonID EQ ' ' AND ADCStuInstitutionTranscriptType EQ ' '
     THEN ADCStuInstitutionTranscriptType=VAR04;
     ELSE VAR04=ADCStuInstitutionTranscriptType;
  IF ADCPersonID EQ ' ' AND ADCStuInstitutionTranscriptDate EQ ' '
     THEN ADCStuInstitutionTranscriptDate=VAR05;
     ELSE VAR05=ADCStuInstitutionTranscriptDate;
  IF ADCPersonID EQ ' ' AND ADCStuInstitutionTrnscrptStatus EQ ' '
     THEN ADCStuInstitutionTrnscrptStatus=VAR06;
     ELSE VAR06=ADCStuInstitutionTrnscrptStatus;
  IF ADCPersonID EQ ' ' AND ADCStuInstitutionType EQ ' '
     THEN ADCStuInstitutionType=VAR07;
     ELSE VAR07=ADCStuInstitutionType;
  IF ADCPersonID EQ ' ' AND ADCStuInstitutionGPA EQ ' '
     THEN ADCStuInstitutionGPA=VAR09;
     ELSE VAR09=ADCStuInstitutionGPA;
  IF ADCPersonID EQ ' ' 
     THEN ADCPersonID=VAR08;
     ELSE VAR08=ADCPersonID;
/*PROC SORT NODUPKEY DATA=st07downb; BY ADCPersonID;*/
*PROC PRINT DATA=st07downb;
RUN;

* END - SECTION st07downb - REPEATS NECESSARY VARIABLE VALUES *;


/*
DATA Check01;
SET st07downb;
*IF ADCStuInstitutionGPA NE .;
RUN;

DATA
		NoDups
		Dups
;
SET Check01;
PROC SORT NODUPKEY DATA=NoDups
	OUT=NoDups
	DupOut=Dups;
	BY _ALL_; *ADCPersonID ADCStuInstitutionCode;
RUN;
*/


* BEGIN - SECTION STFinal - ORDERS VARIABLES AND ADDS INSTITUTION INFORMATION *;

DATA STFinal (KEEP=
		InstTerm
		InstDataPoint
		ADCPersonID 
		ADCStuInstitutionCode
		ADCStuInstitutionName
		ADCStuInstitutionStartDate
		ADCStuInstitutionEndDate
		ADCStuInstitutionGraduationType
		ADCStuInstitutionTranscriptType
		ADCStuInstitutionTranscriptDate
		ADCStuInstitutionTrnscrptStatus
		ADCStuInstitutionType
		ADCStuInstitutionGPA
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
		ADCStuInstitutionCode
		ADCStuInstitutionName
		ADCStuInstitutionStartDate
		ADCStuInstitutionEndDate
		ADCStuInstitutionGraduationType
		ADCStuInstitutionTranscriptType
		ADCStuInstitutionTranscriptDate
		ADCStuInstitutionTrnscrptStatus
		ADCStuInstitutionType
		ADCStuInstitutionGPA
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
		InstShortName $10.
		InstTerm $10.
		InstIPEDSUnitID $10.
		InstOPEID $10.
;
SET st07downb;
InstDataPoint=UPCASE(COMPRESS("&rp01","_"));
InstCountry="&IC01";
InstState="&IS01";
InstID="&II01";
InstShortName="&IN01";
InstIPEDSUnitID="&IU01";
InstOPEID="&OI01";
InstTerm="&YT01";
/*DROP*/
/*		_TYPE_*/
/*		_FREQ_*/
/*		ADCStuPrimaryProgramFlag*/
/*;*/
/*PROC SORT DATA=STFinal; BY ADCPersonID;*/
IF (SUBSTR(ADCStuInstitutionCode,2,1)) EQ ' '
	THEN ADCStuInstitutionCode='000000'||(SUBSTR(ADCStuInstitutionCode,1,1));
	ELSE IF (SUBSTR(ADCStuInstitutionCode,3,1)) EQ ' '
	THEN ADCStuInstitutionCode='00000'||(SUBSTR(ADCStuInstitutionCode,1,2));
	ELSE IF (SUBSTR(ADCStuInstitutionCode,4,1)) EQ ' '
	THEN ADCStuInstitutionCode='0000'||(SUBSTR(ADCStuInstitutionCode,1,3));
	ELSE IF (SUBSTR(ADCStuInstitutionCode,5,1)) EQ ' '
	THEN ADCStuInstitutionCode='000'||(SUBSTR(ADCStuInstitutionCode,1,4));
	ELSE IF (SUBSTR(ADCStuInstitutionCode,6,1)) EQ ' '
	THEN ADCStuInstitutionCode='00'||(SUBSTR(ADCStuInstitutionCode,1,5));
	ELSE IF (SUBSTR(ADCStuInstitutionCode,7,1)) EQ ' '
	THEN ADCStuInstitutionCode='0'||(SUBSTR(ADCStuInstitutionCode,1,6));
RUN;


* END - SECTION STFinal - ORDERS VARIABLES AND ADDS INSTITUTION INFORMATION *;

ODS LISTING CLOSE;
ODS HTML CLOSE;
ODS MARKUP TAGSET=CHTML BODY="&PathRoot\XX_SAS_TrashBin\Report01.html";


DATA SampleResults;
SET STFinal;
PROC SORT DATA=SampleResults; BY ADCPersonID;
TITLE1 "DISPLAY OF FIRST 200 OBSERVATIONS";
TITLE2 " FOR STUDENTS' INSTITUTIONS ATTENDED";
PROC PRINT DATA=SampleResults (OBS=200);
RUN;


ODS MARKUP TAGSET=CHTML CLOSE;


/* Output to H drive */



data &lb01 .&ds01&yt01&rp01;
set STFinal;
run;






