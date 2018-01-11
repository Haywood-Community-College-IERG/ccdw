*************************************************************************************
* CREATED BY:   Paul G. Earls                                                       *
* DATE CREATED: 12-11-2003                                                          *
* MODIFIED1:                                                                        *
* REQUESTOR:    IPEDS                                                               *
* PURPOSE:      Program to select data for IPEDS Fall 12 Month Enrollment Report    *
*               Part A                                                              *
*     ( Data is Summer, Fall, Spring, Summer - 12 month from July 1 To June 30 )    *
*                                                                                   *
*************************************************************************************;
OPTIONS PS=10000 LS=150 NOCENTER NONUMBER;

%LET PathRoot=H:\Planning and Research FTP\CPCCSASDatasets\A_XNC_Datatel; /* CHANGE TO YOU DATA MART LOCATION PATH */

LIBNAME All6 "&PathRoot\Downloads\SASDatasets\00_All";

%LET lb01=All6;
%LET ds01=All_;
%LET rp01=_ET;

/* Summer, Fall, Spring, Summer */
%LET yt01=201602;	* CHANGE FOR EACH TERM;
%LET yt02=201603;	* CHANGE FOR EACH TERM;
%LET yt03=201701;	* CHANGE FOR EACH TERM;
%LET yt04=201702;	* CHANGE FOR EACH TERM;

%LET stdt01=20160701; * CHANGE FOR EACH YEAR;

%LET year1=2016;	* CHANGE FOR EACH YEAR;
%LET year2=2016;	* CHANGE FOR EACH YEAR;
%LET year3=2017;	* CHANGE FOR EACH YEAR;
%LET year4=2017;	* CHANGE FOR EACH YEAR;

%LET term1=Summer;
%LET term2=Fall;
%LET term3=Spring;
%LET term4=Summer;

/***********************************************/
/* NO FURTHER CHANGES NEEDED BEYOND THIS POINT */
/***********************************************/


*************************************************************************************
* Part A                                                                            *
*************************************************************************************;
DATA IPEDSA01 (KEEP=
					InstTerm
					ADCPersonID
					ADCStuGender
					ADCStuPrimaryEthnic
					ADCStuRaces01-ADCStuRaces10
					ADCStuCitizenship
					ADCStuVisaType
					ADCClsAcadLevel
					ADCClsCurrentStatus
					ADCStuClsStatus
					ExitTranslation
					ADCStuClsVrfdGradeDate
					ExitDate
					ADCClsCUCredits
);
FORMAT ExitDate $10.;
SET	&lb01 .&ds01&yt01&rp01  /* all_201202_et (Summer) */
	&lb01 .&ds01&yt02&rp01  /* all_201203_et (Fall)   */
	&lb01 .&ds01&yt03&rp01  /* all_201301_et (Spring) */
	&lb01 .&ds01&yt04&rp01; /* all_201302_et (Summer) */
IF ADCClsAcadLevel EQ 'CU';
IF ADCClsCurrentStatus EQ 'A' OR ADCClsCurrentStatus EQ 'P';
IF (ADCStuClsStatus EQ 'N'
	OR ADCStuClsStatus EQ 'A'
	OR ExitTranslation IN (
							'W',
							'WI'
							))
	AND (ExitTranslation NOT IN (
								'WN',
								'NA'
								));
ExitDate='20'||(SUBSTR(ADCStuClsVrfdGradeDate,7,2))||(SUBSTR(ADCStuClsVrfdGradeDate,1,2))||(SUBSTR(ADCStuClsVrfdGradeDate,4,2));
RUN;


DATA IPEDSA02;
SET IPEDSA01;
IF InstTerm EQ "&yt01"
	AND ExitDate LT "&stdt01"
	THEN DELETE;
RUN;

DATA IPEDSA03;
RETAIN
		Gender
		RaceEthnicity;
FORMAT
		Gender $10.
		RaceEthnicity $45.;
SET IPEDSA02;
IF ADCStuGender EQ ' ' THEN Gender='2 Women  ';
	ELSE IF ADCStuGender EQ 'F' THEN Gender='2 Women  ';
	ELSE IF ADCStuGender EQ 'M' THEN Gender='1 Men    ';
	ELSE Gender='3 Unknown';
IF ADCStuCitizenship NE 'US'
	AND ADCStuCitizenship NE 'USA'
	AND ADCStuCitizenship NE '   '
	AND ADCStuVisaType NE 'PR'
	THEN RaceEthnicity='1 Non Resident Alien';
	ELSE IF ADCStuPrimaryEthnic EQ 'HIS'
		THEN RaceEthnicity='Hispanic/Latino';
	ELSE IF (ADCStuPrimaryEthnic EQ 'NHS'
		OR ADCStuPrimaryEthnic EQ ' ')
		AND (ADCStuRaces02 NE ' ')
			THEN RaceEthnicity='2 or More Races';
	ELSE IF (ADCStuPrimaryEthnic EQ 'NHS'
		OR ADCStuPrimaryEthnic EQ ' ')
		AND (ADCStuRaces01 EQ 'AN')
			THEN RaceEthnicity='American/Alaskan Native';
	ELSE IF (ADCStuPrimaryEthnic EQ 'NHS'
		OR ADCStuPrimaryEthnic EQ ' ')
		AND (ADCStuRaces01 EQ 'AS')
			THEN RaceEthnicity='Asian';
	ELSE IF (ADCStuPrimaryEthnic EQ 'NHS'
		OR ADCStuPrimaryEthnic EQ ' ')
		AND (ADCStuRaces01 EQ 'BL')
			THEN RaceEthnicity='Black or African American';
	ELSE IF (ADCStuPrimaryEthnic EQ 'NHS'
		OR ADCStuPrimaryEthnic EQ ' ')
		AND (ADCStuRaces01 EQ 'HP')
			THEN RaceEthnicity='Hawaiian/Pacific Islander';
	ELSE IF (ADCStuPrimaryEthnic EQ 'NHS'
		OR ADCStuPrimaryEthnic EQ ' ')
		AND (ADCStuRaces01 EQ 'WH')
			THEN RaceEthnicity='White';
	ELSE RaceEthnicity='Unknown';

/**/
/**/
/*ELSE IF ADCStuPrimaryEthnic EQ '   ' */
/*	AND ADCStuRaces01='   '*/
/*	AND ADCStuRaces02='   '*/
/*	AND ADCStuRaces03='   '*/
/*	AND ADCStuRaces04='   '*/
/*	AND ADCStuRaces05='   '*/
/*	AND ADCStuRaces06='   '*/
/*	AND ADCStuRaces07='   '*/
/*	AND ADCStuRaces08='   '*/
/*	AND ADCStuRaces09='   '*/
/*	AND ADCStuRaces10='   '*/
/*	THEN RaceEthnicity='9 Race and Ethnicity Unknown';*/
/*	ELSE IF ADCStuPrimaryEthnic EQ 'NHS' */
/*	AND ADCStuRaces01='  '*/
/*	AND ADCStuRaces02='  '*/
/*	AND ADCStuRaces03='  '*/
/*	AND ADCStuRaces04='  '*/
/*	AND ADCStuRaces05='  '*/
/*	AND ADCStuRaces06='  '*/
/*	AND ADCStuRaces07='  '*/
/*	AND ADCStuRaces08='   '*/
/*	AND ADCStuRaces09='   '*/
/*	AND ADCStuRaces10='   '*/
/*	THEN RaceEthnicity='9 Race and Ethnicity Unknown';*/
/*	ELSE IF ADCStuPrimaryEthnic EQ 'HIS' THEN RaceEthnicity='2 Hispanic';*/
/*	ELSE IF ADCStuRaces01 EQ 'AN'*/
/*	AND ADCStuRaces02='  '*/
/*	AND ADCStuRaces03='  '*/
/*	AND ADCStuRaces04='  '*/
/*	AND ADCStuRaces05='  '*/
/*	AND ADCStuRaces06='  '*/
/*	AND ADCStuRaces07='  '*/
/*	AND ADCStuRaces08='   '*/
/*	AND ADCStuRaces09='   '*/
/*	AND ADCStuRaces10='   '*/
/*	THEN RaceEthnicity='3 American Indian or Alaskan Native';*/
/*	ELSE IF ADCStuRaces01 EQ 'AS'*/
/*	AND ADCStuRaces02='  '*/
/*	AND ADCStuRaces03='  '*/
/*	AND ADCStuRaces04='  '*/
/*	AND ADCStuRaces05='  '*/
/*	AND ADCStuRaces06='  '*/
/*	AND ADCStuRaces07='  '*/
/*	AND ADCStuRaces08='   '*/
/*	AND ADCStuRaces09='   '*/
/*	AND ADCStuRaces10='   '*/
/*	THEN RaceEthnicity='4 Asian';*/
/*	ELSE IF ADCStuRaces01 EQ 'BL'*/
/*	AND ADCStuRaces02='  '*/
/*	AND ADCStuRaces03='  '*/
/*	AND ADCStuRaces04='  '*/
/*	AND ADCStuRaces05='  '*/
/*	AND ADCStuRaces06='  '*/
/*	AND ADCStuRaces07='  '*/
/*	AND ADCStuRaces08='   '*/
/*	AND ADCStuRaces09='   '*/
/*	AND ADCStuRaces10='   '*/
/*	THEN RaceEthnicity='5 Black or African American';*/
/*	ELSE IF ADCStuRaces01 EQ 'HP'*/
/*	AND ADCStuRaces02='  '*/
/*	AND ADCStuRaces03='  '*/
/*	AND ADCStuRaces04='  '*/
/*	AND ADCStuRaces05='  '*/
/*	AND ADCStuRaces06='  '*/
/*	AND ADCStuRaces07='  '*/
/*	AND ADCStuRaces08='   '*/
/*	AND ADCStuRaces09='   '*/
/*	AND ADCStuRaces10='   '*/
/*	THEN RaceEthnicity='6 Native Hawaiian or Other Pacific Islander';*/
/*	ELSE IF ADCStuRaces01 EQ 'WH'*/
/*	AND ADCStuRaces02='  '*/
/*	AND ADCStuRaces03='  '*/
/*	AND ADCStuRaces04='  '*/
/*	AND ADCStuRaces05='  '*/
/*	AND ADCStuRaces06='  '*/
/*	AND ADCStuRaces07='  '*/
/*	AND ADCStuRaces08='   '*/
/*	AND ADCStuRaces09='   '*/
/*	AND ADCStuRaces10='   '*/
/*	THEN RaceEthnicity='7 White';*/
/*	ELSE RaceEthnicity='8 Two or More Races';*/
RUN;

ODS LISTING CLOSE;
ODS HTML CLOSE;
ODS MARKUP TAGSET=CHTML BODY="&PathRoot\XX_SAS_TrashBin\Report01IPEDSPGE.html";

DATA IPEDSFinalA;
SET IPEDSA03;
TITLE1 "IPEDS Part A - 12 Month Unduplicated Count By Race/Sex";
TITLE2 "For &term1 &year1 &term2 &year2 &term3 &year3 &term4 &year4";
PROC SORT DATA=IPEDSFinalA; BY ADCPersonID RaceEthnicity;
PROC SORT NODUPKEY DATA=IPEDSFinalA; BY ADCPersonID;
PROC SORT DATA=IPEDSFinalA; BY Gender;
PROC FREQ DATA=IPEDSFinalA; BY Gender;
        TABLES RaceEthnicity / NOCOL NOPERCENT NOROW;
RUN;

*ODS markup tagset=chtml CLOSE;


*************************************************************************************
* Part B                                                                            *
*************************************************************************************;
* USES TOTAL FTE CREDITS SUMMER, FALL, SPRING, SUMMER *
*******************************************************;


DATA Credits01;
SET IPEDSA02;
TITLE1 "IPEDS Part B - Credits";
TITLE2 " - Choose Credit Hours In Screening Questions And Enter Total Credit Hours";
TITLE3 "For &term1 &year1 &term2 &year2 &term3 &year3 &term4 &year4";
PROC SORT DATA=Credits01; BY InstTerm;
PROC SUMMARY DATA=Credits01; BY InstTerm;
        VAR ADCClsCUCredits;
OUTPUT OUT=cred01out SUM=ADCClsCUCredits;
PROC PRINT DATA=cred01out; SUM ADCClsCUCredits;
*PROC PRINT DATA=fte01;
*       VAR ADCCampus Campus ADCPrefix ADCMethod ADCTotHrs cccfte;
RUN;

ODS MARKUP TAGSET=CHTML CLOSE;



