*************************************************************************************
* CREATED BY:   Paul G. Earls                                                       *
* DATE CREATED: 12-11-2003                                                          *
* MODIFIED1:                                                                        *
* REQUESTOR:    IPEDS                                                               *
* PURPOSE:      Program to select data for IPEDS Any Fall data collection for       *
*               Part B Actual FTE                                                   *
*                 (Data is Fall, Spring Summer)                                     *
*                                                                                   *
*************************************************************************************;
OPTIONS PS=63 LS=80 NOCENTER NONUMBER;

*LIBNAME pge1 'g:\ADatatel\Student';
*LIBNAME pge2 'g:\ADatatel\ByCampus';
LIBNAME pge3 'P:\CPCCSASDatasets\A_XNC_Datatel\Downloads\SASDatasets\20_ICR';   /*'g:\AICR\Datatel';*/

/* Fall, Spring, Summer */
%LET yt01=153;
%LET yt02=161;
%LET yt03=162;

%LET term1=Fall;
%LET term2=Spring;
%LET term3=Summer;

%LET year1=2015;
%LET year2=2016;
%LET year3=2016;

*************************************************************************************
* Part B                                                                            *
*************************************************************************************;
* USES TOTAL FTE FALL, SPRING, SUMMER                 *
*******************************************************;

*ODS markup tagset=chtml BODY='IPEDS_B.html';

DATA fte01 (KEEP=ADCCampus Campus ADCPrefix ADCMethod ADCTotHrs cccfte);
SET pge3.C_FTE&yt01
	pge3.C_FTE&yt02
	pge3.C_FTE&yt03;
IF ADCMethod EQ 'DL'
	OR ADCMethod EQ 'DM'
	OR ADCMethod EQ 'IH'
	OR ADCMethod EQ 'IN'
	OR ADCMethod EQ 'MB'
	OR ADCMethod EQ 'HY'
	OR ADCMethod EQ 'OT'
	OR ADCMethod EQ 'TV'
	OR ADCMethod EQ 'TW'
	THEN Campus='9-Virtual ';
	ELSE IF ADCCampus EQ '1013' THEN Campus='1-Central';
	ELSE IF ADCCampus EQ '2005' THEN Campus='2-North  ';
	ELSE IF ADCCampus EQ '2007' THEN Campus='4-Levine ';
	ELSE IF ADCCampus EQ '2008' THEN Campus='5-Harper ';
	ELSE IF ADCCampus EQ '2009' THEN Campus='6-West   ';
	ELSE IF ADCCampus EQ '2006' THEN Campus='3-Cato   ';
	ELSE IF ADCCampus EQ '5020' THEN Campus='7-CityView';
	ELSE IF ADCCampus EQ '9000' THEN Campus='8-OffCamp';
	ELSE IF ADCCampus EQ '4530' THEN Campus='8-OffCamp';
	ELSE IF ADCCampus EQ '4535' THEN Campus='8-OffCamp';
	ELSE IF ADCCampus EQ 'J005' THEN Campus='8-OffCamp';
	ELSE IF ADCCampus EQ '    ' AND ADCPrefix EQ 'SSS' THEN Campus='99-Shared ';
	ELSE Campus='X-Unknown';
cccfte=ADCTotHrs/512;
run;

TITLE1 "IPEDS Part B - Actual FTE";
TITLE2 " - Choose Yes To Report More Accurate FTE";
TITLE3 "For &term1 &year1 &term2 &year2 &term3 &year3";
PROC SORT DATA=fte01; 
	BY Campus;
run;

PROC SUMMARY DATA=fte01; 
	BY Campus;
    VAR cccfte;
	OUTPUT OUT=fte01out SUM=cccfte;
run;

PROC PRINT DATA=fte01out; SUM CCCFTE;
*PROC PRINT DATA=fte01;
*       VAR ADCCampus Campus ADCPrefix ADCMethod ADCTotHrs cccfte;
RUN;

*ODS markup tagset=chtml CLOSE;



