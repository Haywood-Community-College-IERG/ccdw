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
* PURPOSE:      Create the ALL (ByCampus) Dataset                                   *
*               For All Terms, All Data Points                                      *
*************************************************************************************;
OPTIONS PS=500 LS=256 NONUMBER NOCENTER;

%LET PathRoot=L:\IERG\Data\DataMart\A_XNC_Colleague;

LIBNAME Stu6 "&PathRoot\Downloads\SASDatasets\02_Student";
LIBNAME Cls6 "&PathRoot\Downloads\SASDatasets\01_Class";
LIBNAME All6 "&PathRoot\Downloads\SASDatasets\00_All";

%LET lb01=Stu6;
%LET ds01=ST_;

%LET lb02=Cls6;
%LET ds02=CL_;

%LET lb03=All6;
%LET ds03=ALL_;

%LET rp01=_XX;		*CHANGE FOR EACH DATASET CREATION;
%LET rp02=_XX;		*CHANGE FOR EACH DATASET CREATION;
%LET term=SPRING;	*CHANGE FOR EACH DATASET CREATION;
%LET yt01=201701;	*CHANGE FOR EACH DATASET CREATION;


*------------------------------------------------*;
* NO FURTHER CHANGES NECESSARY BEYOND THIS POINT *;
*------------------------------------------------*;

%LET ar01b=001;		* BEGINNING NUMBER OF ELEMENTS IN ST09 CLASS ARRAY;
%LET ar01e=150;		* ENDING NUMBER OF ELEMENTS IN ST09 CLASS ARRAY;

%LET ar02b=01;		* BEGINNING NUMBER OF ELEMENTS IN ST02 RACE ARRAY AND CU CE TERMS ARRAYS;
%LET ar02e=10;		* ENDING NUMBER OF ELEMENTS IN ST02 RACE ARRAY AND CU CE TERMS ARRAYS;

%LET ar03b=01;		* BEGINNING NUMBER OF ELEMENTS IN ST15 EdGoals ARRAY;
%LET ar03e=25;		* ENDING NUMBER OF ELEMENTS IN ST15 EdGoals ARRAY;

%LET ar04b=01;		* BEGINNING NUMBER OF ELEMENTS IN ST15 ActivePrograms ARRAY;
%LET ar04e=40;		* ENDING NUMBER OF ELEMENTS IN ST15 ActivePrograms ARRAY;

%LET ar05b=01;		* BEGINNING NUMBER OF ELEMENTS IN CLASS FILE ARRAYS;
%LET ar05e=40;		* ENDING NUMBER OF ELEMENTS IN CLASS FILE ARRAYS;


DATA st_&rp01&yt01;
SET &lb01 .&ds01&yt01&rp01;
LENGTH Class $20.;
LENGTH Class2 $20.;
*LENGTH ExitCode $2.;
LENGTH ExitTranslation $15.;
LENGTH ADCStuClsVrfdGradeCode $4.;
*LENGTH ADCCourseRegCred 4.2;
LENGTH ADCStuClsRegMethod $7.;
LENGTH ADCStuClsReason $4.;
LENGTH ADCStuClsStatus $4.;
LENGTH ADCStuClsStatusDate $10.;
LENGTH ADCStuClsVrfdGradeDate $10.;
LENGTH ADCStuClsStatusTime $9.;
ARRAY cls{&ar01e} $15.	Class&ar01b-Class&ar01e;
ARRAY cid{&ar01e} $7.	ADCClsID&ar01b-ADCClsID&ar01e;
*ARRAY exc{&ar01e} $2.	ExitCode&ar01b-ExitCode&ar01e;
ARRAY ect{&ar01e} $15.	ExitTranslation&ar01b-ExitTranslation&ar01e;
ARRAY vgc{&ar01e} $4.	ADCStuClsVrfdGradeCode&ar01b-ADCStuClsVrfdGradeCode&ar01e;
*ARRAY crc{&ar01e} 4.2	ADCCourseRegCred&ar01b-ADCCourseRegCred&ar01e;
ARRAY rgm{&ar01e} $7.	ADCStuClsRegMethod&ar01b-ADCStuClsRegMethod&ar01e;
ARRAY rea{&ar01e} $4.	ADCStuClsReason&ar01b-ADCStuClsReason&ar01e;
ARRAY sts{&ar01e} $4.	ADCStuClsStatus&ar01b-ADCStuClsStatus&ar01e;
ARRAY sdt{&ar01e} $10.	ADCStuClsStatusDate&ar01b-ADCStuClsStatusDate&ar01e;
ARRAY gdt{&ar01e} $10.	ADCStuClsVrfdGradeDate&ar01b-ADCStuClsVrfdGradeDate&ar01e;
ARRAY stt{&ar01e} $9.	ADCStuClsStatusTime&ar01b-ADCStuClsStatusTime&ar01e;
DO i=1 to &ar01e;
IF cls{i} NE '  ' THEN DO;
	Class=cls{i};
	ADCClsID=cid{i};
*	ExitCode=exc{i};
	ExitTranslation=ect{i};
	ADCStuClsVrfdGradeCode=vgc{i};
*	ADCCourseRegCred=crc{i};
	ADCStuClsRegMethod=rgm{i};
	ADCStuClsReason=rea{i};
	ADCStuClsStatus=sts{i};
	ADCStuClsStatusDate=sdt{i};
	ADCStuClsVrfdGradeDate=gdt{i};
	ADCStuClsStatusTime=stt{i};
Class2=(TRIM(LEFT(Class)));
OUTPUT;
END;
END;
Class2=(TRIM(LEFT(Class)));
DROP i;
PROC SORT OUT=stu_sort; BY ADCClsID;
RUN;

DATA cl_&rp01&yt01;
LENGTH Class2 $15.;
SET &lb02 .&ds02&yt01&rp01;
*IF classtat EQ '1' OR classtat EQ '3';
Class2=(TRIM(LEFT(CLASS)));
PROC SORT OUT=cls_sort; BY ADCClsID;
RUN;

DATA allfile;
	MERGE stu_sort(IN=a) cls_sort(IN=b); BY ADCClsID;
	IF a*b=1;
RUN;

DATA cls_sort2;
SET cls_sort;
PROC SORT DATA=cls_sort2; BY Class;
RUN;

DATA stu_sort2;
SET stu_sort;
PROC SORT DATA=stu_sort2; BY Class;
RUN;

ODS LISTING CLOSE;
ODS HTML CLOSE;
ODS MARKUP TAGSET=CHTML BODY="&PathRoot\XX_SAS_TrashBin\Report01.html";

DATA Error01;
	MERGE stu_sort(IN=a) cls_sort(IN=b); BY ADCClsID;
	IF a AND NOT b;
TITLE1 "ERROR01 - Records In Student File Not Matched To Class File - MATCHED BY ADCClsID";
PROC PRINT DATA=Error01;
	VAR ADCPersonID Class2 ExitTranslation Class&ar01b-Class&ar01e;
RUN;

DATA Error02;
	MERGE stu_sort(IN=a) cls_sort(IN=b); BY ADCClsID;
	IF b AND NOT a;
TITLE1 "ERROR02 - Records In Class File Not Matched To Student File - MATCHED BY ADCClsID";
PROC PRINT DATA=Error02;
	WHERE ADCClsActiveStuCt > 0;
	VAR ADCClsID Class2 ADCClsActiveStuCt ADCClsCurrentStatus ADCClsStartDate ADCClsTerm; 
RUN;

DATA Error03;
	MERGE stu_sort2(IN=a) cls_sort2(IN=b); BY Class;
	IF a AND NOT b;
TITLE1 "ERROR03 - Records In Student File Not Matched To Class File - MATCHED BY Class";
PROC SORT DATA=Error03; BY ADCClsID;
PROC PRINT DATA=Error03;
	VAR ADCPersonID ADCClsID Class2 ExitTranslation Class&ar01b-Class&ar01e;
RUN;

DATA Error04;
	MERGE stu_sort2(IN=a) cls_sort2(IN=b); BY Class;
	IF b AND NOT a;
TITLE1 "ERROR04 - Records In Class File Not Matched To Student File - MATCHED BY Class";
PROC SORT DATA=Error04; BY ADCClsID;
PROC PRINT DATA=Error04;
	WHERE ADCClsActiveStuCt > 0;
	VAR ADCClsID Class2 ADCClsActiveStuCt ADCClsCurrentStatus ADCClsStartDate ADCClsTerm; 
RUN;

DATA Error05;
	MERGE Error01(IN=a) Error03(IN=b); BY ADCClsID;
	IF a AND NOT b;
TITLE1 "ERROR05 - Records In Error01 File And Not In Error03 File - MATCHED BY ADCClsID";
PROC PRINT DATA=Error05;
	VAR ADCPersonID ADCClsID Class2 ExitTranslation Class&ar01b-Class&ar01e;
RUN;

DATA Error06;
	MERGE Error01(IN=a) Error03(IN=b); BY ADCClsID;
	IF b AND NOT a;
TITLE1 "ERROR06 - Records In Error03 File And Not In Error01 File - MATCHED BY ADCClsID";
PROC PRINT DATA=Error05;
	VAR ADCPersonID ADCClsID Class2 ExitTranslation Class&ar01b-Class&ar01e;
RUN;

DATA Error07;
	MERGE Error02(IN=a) Error04(IN=b); BY ADCClsID;
	IF a AND NOT b;
TITLE1 "ERROR07 - Records In Error02 File And Not In Error04 File - MATCHED BY ADCClsID";
PROC PRINT DATA=Error07;
	VAR ADCPersonID ADCClsID Class2 ADCClsActiveStuCt ADCClsCurrentStatus ADCClsStartDate ADCClsTerm; 
RUN;

DATA Error08;
	MERGE Error02(IN=a) Error04(IN=b); BY ADCClsID;
	IF b AND NOT a;
TITLE1 "ERROR08 - Records In Error04 File And Not In Error02 File - MATCHED BY ADCClsID";
PROC PRINT DATA=Error08;
	VAR ADCClsID Class2 ADCClsActiveStuCt ADCClsCurrentStatus ADCClsStartDate ADCClsTerm; 
RUN;


/* delete unneeded variables */
/* add IPEDS race variable */
*DATA &lb03 .&ds03&yt01&rp01;
data final;
SET allfile;
drop adcstuclsregmethod001-adcstuclsregmethod150 
     adcstuclsstatus001-adcstuclsstatus150 
     adcstuclsstatusdate001-adcstuclsstatusdate150 
     adcstuclsstatustime001-adcstuclsstatustime150
	 adcstuclsvrfdgradechgopr001-adcstuclsvrfdgradechgopr150
	 adcstuclsvrfdgradedate001-adcstuclsvrfdgradedate150
	 adcstuclsvrfdgradecode001-adcstuclsvrfdgradecode150
	 class001-class150
	 exittranslation001-exittranslation150
	 adcclsid001-adcclsid150;
IF ADCStuCitizenship not in ('US','USA',' ') and ADCStuVisaType not in ('PR') THEN IPEDSRace='Nonresident Alien               ';
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
Age=1*(SUBSTR(InstTerm,1,4))-INT(BirthDate/10000);
PROC SORT DATA=FINAL; BY CLass;
RUN;

proc sort data=final nodupkey out=checks;
by adcpersonid;
run;

TITLE1 "LISTING OF CURRENT CURRICULUM STUDENTS BY IPEDS FIRST-TIME STUDENT COHORTS";
TITLE2 "   FOR &yt01";
proc freq data=checks;
tables ADCStuFederalCohortGroup;
run;

title "INVALID AGE - CHECK";
title2 "Send Curriculum to Clyanne Hyde.  Send CCE/CE to Melissa Medlin.  Send LIT/BSP to Loretta Carr.";
proc print data=checks noobs;
var adcpersonid adcstulastname adcstufirstname adcstuacadlevel birthdate age;
where age < 14 or age > 99;
run;

title "INVALID GENDER - CHECK";

proc print data=checks noobs;
var instterm adcpersonid adcstulastname adcstufirstname adcstuacadlevel adcstugender;
where adcstugender not in ('M','F');
run;

/* output to H drive */
data &lb03 .&ds03&yt01&rp01 (KEEP=
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
					ADCClsTerm
					Class
					ADCClsID
					Course
					ADCClsShortTitle
					ADCClsPrefix
					ADCClsNumber
					ADCClsSection
					ExitTranslation
					ADCStuClsStatus
					ADCStuClsReason
					ADCStuClsStatusDate
					ADCStuClsStatusTime
					ADCClsAcadLevel
					ADCStuClsRegMethod	
					ADCStuClsVrfdGradeCode
					ADCStuClsVrfdGradeDate
					ADCClsStartDate
					ADCClsEndDate
					ADCClsCurrentStatus
					ADCClsIMethod
					ADCClsPrimaryFlag
					ADCClsPrimarySection
					ADCClsCUCredits
					ADCClsCEUnits
					ADCClsCapacity
					ADCClsActiveStuCt
					ClsAvailSeats
					ADCClsSecAddOn
					ADCClsSecAddBy
					ADCClsSecChgOn
					ADCClsSecChgBy
					ADCClsSecMeetAddOn
					ADCClsSecMeetAddBy
					ADCClsSecMeetChgOn
					ADCClsSecMeetChgBy
					ADCClsCredType
					ADCClsDepts
					ADCClsFTEContactHrs
					ADCClsFTEStuCt
					ADCClsTotalFTE
					ADCClsFundSources
					ADCClsLocalIDs
					ADCClsSynonym
					ADCClsCensusDates
					ADCClsContactMeasures
					ADCClsAcctMethod
					ADCClsPriFacLName
					ADCClsPriFacFName
					ADCClsPriFacMName
					ClsPriFacLFMName
					ADCClsCourseLevel&ar01b-ADCClsCourseLevel&ar01e 			 
					ADCClsContactHrs&ar01b-ADCClsContactHrs&ar01e
					ADCClsCourseTypes&ar01b-ADCClsCourseTypes&ar01e
					ADCClsFacultyIDs&ar01b-ADCClsFacultyIDs&ar01e
					ADCClsAllFacLName&ar01b-ADCClsAllFacLName&ar01e
					ADCClsMeetDays&ar05b-ADCClsMeetDays&ar05e
					ADCClsStartTime&ar05b-ADCClsStartTime&ar05e
					ADCClsEndTime&ar05b-ADCClsEndTime&ar05e
					ADCClsCampus&ar05b-ADCClsCampus&ar05e
					ADCClsBldg&ar05b-ADCClsBldg&ar05e
					ADCClsRoom&ar05b-ADCClsRoom&ar05e
					ADCClsIType&ar05b-ADCClsIType&ar05e
					ClsFTETier
					InstCountry
					InstState
					InstShortName
					InstID
					InstIPEDSUnitID
					InstOPEID
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
					ADCClsTerm
					Class
					ADCClsID
					Course
					ADCClsShortTitle
					ADCClsPrefix
					ADCClsNumber
					ADCClsSection
					ExitTranslation
					ADCStuClsStatus
					ADCStuClsReason
					ADCStuClsStatusDate
					ADCStuClsStatusTime
					ADCClsAcadLevel
					ADCStuClsRegMethod	
					ADCStuClsVrfdGradeCode
					ADCStuClsVrfdGradeDate
					ADCClsStartDate
					ADCClsEndDate
					ADCClsCurrentStatus
					ADCClsIMethod
					ADCClsPrimaryFlag
					ADCClsPrimarySection
					ADCClsCUCredits
					ADCClsCEUnits
					ADCClsCapacity
					ADCClsActiveStuCt
					ClsAvailSeats
					ADCClsSecAddOn
					ADCClsSecAddBy
					ADCClsSecChgOn
					ADCClsSecChgBy
					ADCClsSecMeetAddOn
					ADCClsSecMeetAddBy
					ADCClsSecMeetChgOn
					ADCClsSecMeetChgBy
					ADCClsCredType
					ADCClsDepts
					ADCClsFTEContactHrs
					ADCClsFTEStuCt
					ADCClsTotalFTE
					ADCClsFundSources
					ADCClsLocalIDs
					ADCClsSynonym
					ADCClsCensusDates
					ADCClsContactMeasures
					ADCClsAcctMethod
					ADCClsPriFacLName
					ADCClsPriFacFName
					ADCClsPriFacMName
					ClsPriFacLFMName
					ADCClsCourseLevel&ar01b-ADCClsCourseLevel&ar01e 			 
					ADCClsContactHrs&ar01b-ADCClsContactHrs&ar01e
					ADCClsCourseTypes&ar01b-ADCClsCourseTypes&ar01e
					ADCClsFacultyIDs&ar01b-ADCClsFacultyIDs&ar01e
					ADCClsAllFacLName&ar01b-ADCClsAllFacLName&ar01e
					ADCClsMeetDays&ar05b-ADCClsMeetDays&ar05e
					ADCClsStartTime&ar05b-ADCClsStartTime&ar05e
					ADCClsEndTime&ar05b-ADCClsEndTime&ar05e
					ADCClsCampus&ar05b-ADCClsCampus&ar05e
					ADCClsBldg&ar05b-ADCClsBldg&ar05e
					ADCClsRoom&ar05b-ADCClsRoom&ar05e
					ADCClsIType&ar05b-ADCClsIType&ar05e
					ClsFTETier
					InstCountry
					InstState
					InstShortName
					InstID
					InstIPEDSUnitID
					InstOPEID
;
SET final;
RUN;

ODS MARKUP TAGSET=CHTML CLOSE;

/* send email notifying IR of new datasets */
/*
%macro notify(emailaddress);
filename mymail1 email "&emailaddress"
 TYPE = "TEXT/PLAIN" 
 SUBJECT = "new datasets on H"; 
data _null_; 
 file mymail1; 
 put 'Hello,';
 put;
 put "The &term &yt01 &rp02 datasets (Class, Student, Test Scores, All) are now available on the H drive."; 
 put 'Please let me know if you have any questions.';
 put;
 put 'This is an email sent from SAS';
 run; 
%mend;
%notify(paul.earls@cpcc.edu);
%notify(bobbie.frye@cpcc.edu);
%notify(jason.temples@cpcc.edu);
%notify(courtnee.bonds@cpcc.edu);
%notify(krys.swartz@cpcc.edu);
%notify(mary.heuser@cpcc.edu);
*/
