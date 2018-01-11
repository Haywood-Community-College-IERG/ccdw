*************************************************************************************
* CREATED BY:	Catherine Kurilla 													*
* DATE CREATED: 10-01-2013                                                          *
* MODIFIED1:    10-06-2017 By Paul G. Earls                                         *
* REQUESTOR:                                                                        *
* PURPOSE:      IPEDS Fall Enrollment - CREATING GRS COHORT                         *
*               For Any Fall Term													*
*               Adding in Dually Enrolled Students to the Cohort                    *
*************************************************************************************
* NOTE - BEFORE RUNNING THIS:                                                       *
*		PULL CLEARINGHOUSE SUBMITTAL FILE FOR GRS (PA)                              *
*		SUBMIT TO CLEARINGHOUSE AND CREATE DATASET FROM RETURN FILE (PA_GRS)        *
*		PULL TRANSFER CREDITS PARTIAL FILE FOR CURRENT YEAR AND CREATE DATASET (GRS)*	
*                                                                                   *
*       ONCE THIS PROGRAM IS COMPLETE - NEED TO RE-RUN CREATE ALL PROGRAM FOR       *
*        SAME DATA POINT (GRS)  A_XNC_04_CreateAll_NewRace_Datatel_MODYYYYMMDD.sas  *
*************************************************************************************;

%LET PathRoot=H:\Planning and Research FTP\CPCCSASDatasets\A_XNC_Datatel;

LIBNAME All6 "&PathRoot\Downloads\SASDatasets\00_All";
LIBNAME Stu6 "&PathRoot\Downloads\SASDatasets\02_Student";
LIBNAME Xfr6 "&PathRoot\Downloads\SASDatasets\04_TransferCredits";
LIBNAME NSC6 "&PathRoot\Downloads\SASDatasets\30_NSC";

%LET lb01=All6;
%LET ds01=All_;
%LET rp01=_GRS;

%LET lb02=Stu6;
%LET ds02=Stu_;
%LET rp02=_8W;
%LET rp02b=8 Week;

%LET yt01=201703;		/* Fall term being reported on */
%LET ytnext=201701;		/* Spring term following Fall term being reported on */

%LET fyt01=2017CU3;		/* Fall term being reported on */
%LET fyt02=2017CU2;		/* Summer preceeding Fall term being reported on */

%LET lb03=NSC6;
%LET ds03=NSC_;
%LET rp03=_PA_GRS;

%LET lb04=Stu6;
%LET ds04=Sti_;
%LET rp04=_GRS;
%LET rp04b=GRS;

%LET lb05=Xfr6;
%LET ds05=XfrCred_;
%LET rp05=_GRS;
%LET rp05b=Transfer Credits;
%LET yr01=2017;				/* CHANGE FOR EACH REPORTING YEAR */

%LET lb06=Stu6;
%LET ds06=ST_;
%LET rp06=_GRS;
%LET rp06b=GRS;

%LET Pth01=&PathRoot\SASPrograms\09_IPEDS\;
%LET Pth02=2017-2018;		/* CHANGE FOR EACH REPORTING YEAR */
%LET Pth03=\2017_03_Fall;	/* CHANGE FOR EACH REPORTING TERM */
%LET Pth04=\05_FallCohorts;

%LET yt03=201603;	/* Prior Fall term */
%LET yt04=201701;	/* Prior Spring term */
%LET yt05=201702;	/* Prior Summer term */
%LET yt06=201703;	/* Current Fall term */
%LET yt06b=Fall 2017;	/* Current Fall term */

%LET FTFT=2017FT;	/* First-Time Full-Time Cohort Designation */
%LET FTPT=2017PT;	/* First-Time Part-Time Cohort Designation */
%LET TRFT=2017TF;	/* Transfer Full-Time Cohort Designation */
%LET TRPT=2017TP;	/* Transfer Part-Time Cohort Designation */

%LET OPE=002915-00;	/* UPDATE TO YOUR FICE/OPE CODE AND BRANCH */

%LET ini01=0051658;		/* INCLUDE - THESE ARE FOREIGN POST SECONDARY INSTITUTION CODES */
%LET ini02=0051659;		/* INCLUDE - THESE ARE FOREIGN POST SECONDARY INSTITUTION CODES */
%LET ini03=3567606;		/* INCLUDE - THESE ARE FOREIGN POST SECONDARY INSTITUTION CODES */
%LET ini04=3568553;		/* INCLUDE - THESE ARE FOREIGN POST SECONDARY INSTITUTION CODES */
%LET ini05=3573785;		/* INCLUDE - THESE ARE FOREIGN POST SECONDARY INSTITUTION CODES */
%LET ini06=3604453;		/* INCLUDE - THESE ARE FOREIGN POST SECONDARY INSTITUTION CODES */
%LET ini07=3609303;		/* INCLUDE - THESE ARE FOREIGN POST SECONDARY INSTITUTION CODES */
%LET ini08=;		/* INCLUDE - THESE ARE FOREIGN POST SECONDARY INSTITUTION CODES */
%LET ini09=;		/* INCLUDE - THESE ARE FOREIGN POST SECONDARY INSTITUTION CODES */
%LET ini10=;		/* INCLUDE - THESE ARE FOREIGN POST SECONDARY INSTITUTION CODES */

%LET sti01=0019768;		/* EXCLUDE - THESE ARE HOME INSTITUTION CODES */
%LET sti02=0081118;		/* EXCLUDE - THESE ARE HOME INSTITUTION CODES */
%LET sti03=;		/* EXCLUDE - THESE ARE HOME INSTITUTION CODES */
%LET sti04=;		/* EXCLUDE - THESE ARE HOME INSTITUTION CODES */
%LET sti05=;		/* EXCLUDE - THESE ARE HOME INSTITUTION CODES */



*----------------------------------------------*;
* NO FURTHER CHANGES NECESSARY BEYOND THIS POINT;
*----------------------------------------------*;


/* ALL students in Fall */
/* Curriculum only */
/* Active and Pending courses */
DATA Fall01a (KEEP=
					InstTerm
					InstDataPoint
					ADCPersonID
					ADCStuLastName
					ADCStuFirstName
					ADCStuMiddleName
					ADCStuNameSuffix
					ADCStuBirthDate
					BirthDate
					ADCStuGender
					ADCStuEthnic
					ADCStuRaces01-ADCStuRaces10
					ADCStuCitizenship
					ADCStuResidenceState
					ADCStuVisaType
					TotalCUCredits
					ExitTranslation
					ADCStuFederalCohortGroup
					ADCStuHighSchoolGraduationType
					ADCStuHighSchoolTranscriptType
					ADCStuHighSchoolEndDate
					ADCStuCURPriProgAdmitStatus
					ADCStuCURPriProgCode
					ADCStuCUTerms01-ADCStuCUTerms10
					ADCStuCETerms01-ADCStuCETerms10
					ADCStuClsStatus
					ADCClsAcadLevel
					ADCClsCurrentStatus
					adcclsImethod
					adcclsprefix
					adcclsnumber
					class
					adcclssection
					adcstuedgoals01-adcstuedgoals10
					adcclscucredits
					ADCStuGRSAdmitStatus
					ADCStuCurrentType
					FirstCUTerm
);
SET &lb01 .&ds01&yt01&rp01;
PROC SORT DATA=Fall01a; BY ADCPersonID;
RUN;

DATA Fall01b;
RETAIN
		GRSCollegeTermAdmitStatus_F_T
;
FORMAT
		GRSCollegeTermAdmitStatus_F_T $10.
;
SET Fall01a;
GRSCollegeTermAdmitStatus_F_T='Missing';
/* REMARK OUT OF PRODUCTION VERSION */
*IF ADCStuGRSAdmitStatus EQ ' ' THEN ADCStuGRSAdmitStatus='Unk'; /* REMARK OUT OF PRODUCTION VERSION */
/* REMARK OUT OF PRODUCTION VERSION */
PROC SORT NODUPKEY DATA=Fall01b; BY ADCPersonID;
RUN;


DATA NSC01;
SET &lb03 .&ds03&yt06&rp03;
IF NSC_College_Code_Branch EQ "&OPE" THEN DELETE;
IF NSC_Record_Found_Y_N EQ 'N' THEN DELETE;
PROC SORT NODUPKEY DATA=NSC01; BY ADCPersonID;
RUN;


DATA MergeNSC01a;
	MERGE Fall01b (IN=a) NSC01 (IN=b); BY ADCPersonID;
	IF a*b=1;
GRSCollegeTermAdmitStatus_F_T='T';
RUN;

DATA MergeNSC01b;
	MERGE Fall01b (IN=a) NSC01 (IN=b); BY ADCPersonID;
	IF a AND NOT b;
GRSCollegeTermAdmitStatus_F_T=GRSCollegeTermAdmitStatus_F_T;
RUN;


DATA InstitutionsAttended01a (KEEP=
								ADCPersonID
								ADCStuInstitutionCode
								ADCStuInstitutionName
								ADCStuInstitutionType
								ADCStuInstitutionStartDate
								ADCStuInstitutionEndDate
);
SET &lb04 .&ds04&yt01&rp04;
RUN;

DATA InstitutionsAttended01b;
SET InstitutionsAttended01a;
IF (ADCStuInstitutionType IN (			/* INCLUDE - THESE ARE ALL POST SECONDARY INSTITUTION CODES */
							'CC',
							'UN',
							'CO',
							'VT',
							'PF'
							)
	OR ADCStuInstitutionCode IN (		/* INCLUDE - THESE ARE FOREIGN POST SECONDARY INSTITUTION CODES */
							"&ini01",
							"&ini02",
							"&ini03",
							"&ini04",
							"&ini05",
							"&ini06",
							"&ini07",
							"&ini08",
							"&ini09",
							"&ini10"
							))
	AND ADCStuInstitutionCode NOT IN (	/* EXCLUDE - THESE ARE HOME INSITUTION CODES */
							"&ine01",
							"&ine02",
							"&ine03",
							"&ine04",
							"&ine05"
							);
PROC SORT NODUPKEY DATA=InstitutionsAttended01b; BY ADCPersonID;
RUN;

DATA MergeSti01a;
	MERGE MergeNSC01b (IN=a) InstitutionsAttended01b (IN=b); BY ADCPersonID;
	IF a*b=1;
GRSCollegeTermAdmitStatus_F_T='T';
RUN;


DATA MergeSti01b;
	MERGE MergeNSC01b (IN=a) InstitutionsAttended01b (IN=b); BY ADCPersonID;
	IF a AND NOT b;
GRSCollegeTermAdmitStatus_F_T=GRSCollegeTermAdmitStatus_F_T;
RUN;


DATA XfrCredits01a;
SET &lb05 .&ds05&yr01&rp05;
IF ADCXfrAcadLvl IN (
					'CU'
					);
PROC SORT NODUPKEY DATA=XfrCredits01a; BY ADCPersonID;
RUN;

DATA MergeXfr01a;
	MERGE MergeSti01b (IN=p) XfrCredits01a (IN=q); BY ADCPersonID;
	IF p*q=1;
GRSCollegeTermAdmitStatus_F_T='T';
RUN;

DATA MergeXfr01b;
	MERGE MergeSti01b (IN=p) XfrCredits01a (IN=q); BY ADCPersonID;
	IF p AND NOT q;;
GRSCollegeTermAdmitStatus_F_T=GRSCollegeTermAdmitStatus_F_T;
RUN;

DATA MergeAllTransfers;
SET
	MergeNSC01a
	MergeSti01a
	MergeXfr01a
	MergeXfr01b
;
IF GRSCollegeTermAdmitStatus_F_T IN (
								'Missing'
								)
		AND ADCStuGRSAdmitStatus IN (
								'T'
								)
		THEN GRSCollegeTermAdmitStatus_F_T='T';
ELSE IF GRSCollegeTermAdmitStatus_F_T IN (
								'Missing'
								)
		AND ADCStuGRSAdmitStatus IN (
								'F'
								)
		THEN GRSCollegeTermAdmitStatus_F_T='F';
ELSE IF GRSCollegeTermAdmitStatus_F_T IN (
								'Missing'
								)
/* REMARK BACK INTO PRODUCTION VERSION */
		AND ADCStuGRSAdmitStatus IN (
								' '
								)
/* REMARK BACK INTO PRODUCTION VERSION */
/* REMARK OUT OF PRODUCTION VERSION */
/*		AND ADCStuGRSAdmitStatus IN (*/
/*								'Unk'*/
/*								)*/
/* REMARK OUT OF PRODUCTION VERSION */
		THEN GRSCollegeTermAdmitStatus_F_T='Missing';
PROC SORT DATA=MergeAllTransfers; BY ADCPersonID;
RUN;


DATA Fall03;
	MERGE Fall01b (IN=c) MergeAllTransfers (IN=d); BY ADCPersonID;
	IF c;
RUN;


DATA Fall04;
	MERGE Fall01a (IN=c) MergeAllTransfers (IN=d); BY ADCPersonID;
	IF c;
PROC SORT DATA=Fall04; BY ADCPersonID;
RUN;


/* Get previous year's dually enrolled students */
DATA CCPP (KEEP=ADCPersonID CCPP);
SET &lb01 .&ds01&yt03&rp02 (KEEP=ADCPersonID ADCStuCurrentType)
    &lb01 .&ds01&yt04&rp02 (KEEP=ADCPersonID ADCStuCurrentType);
WHERE ADCStuCurrentType IN (
							'CCPP'
							'MCOL'
							'HSPS'
							);
CCPP=1;
/* unduplicate dually enrolled students */
PROC SORT NODUPKEY DATA=CCPP; BY ADCPersonID;
RUN;


/* merge previously dual enrolled with current Fall */
DATA Fall02;
	MERGE Fall04 (IN=x) ccpp; BY ADCPersonID;
	IF x;
RUN;


/* Current Fall GRS + Previously Dual Enrolled */
/* Use terms array to find first time at CPCC */
/* Add dually enrolled from last year */
/* Include students in an A, D, or C program code, excluding CONED and AHS */
/* Exclude currently dual enrolled students */
/* Include students with an admit status of 'F' */
/* Include students whose goal is to either graduate or transfer */

DATA GRS;
SET Fall02;
FORMAT GRSAdmitStatus $10.;
IF ADCClsAcadLevel IN (
						'CU'
						);
IF ADCClsCurrentStatus IN (
							'A',
							'P'
							);
IF ADCStuCLsStatus IN (
						'N',
						'A'
						)
	AND ExitTranslation NOT IN (
								'W',
								'WN'
								);
IF TotalCUCredits GT 0;
IF (FirstCUTerm IN (
					"&fyt01",
					"&fyt02"
					))
				OR ccpp=1;
IF ADCStuFederalCohortGroup IN (
								' '
								)
		AND GRSCollegeTermAdmitStatus_F_T NOT IN (
												'Missing'
												);
IF SUBSTR(ADCStuCURPriProgCode,1,1) IN (
										'A',
										'D',
										'C'
										)
		AND ADCStuCURPriProgCode NOT IN (
										'CONED',
										'AHS'
										)
		AND (SUBSTR(ADCStuCURPriProgCode,1,6)) NOT IN (
														'A55280'
														);
IF ADCStuCurrentType NOT IN (
							'CCPP'
							'MCOL'
							'HSPS'
							);
IF GRSCollegeTermAdmitStatus_F_T IN (
							'F'
							)
			THEN GRSAdmitStatus='FirstTime';
	ELSE IF GRSCollegeTermAdmitStatus_F_T IN (
										'T'
										)
			THEN GRSAdmitStatus='Transfer';
ARRAY SearchEdGoals [10] $ ADCStuEdGoals01-ADCStuEdGoals10;
     IF "GR" IN SearchEdGoals
	OR "TR" IN SearchEdGoals;
IF TotalCUCredits >= 12 THEN FTPT='Full-Time';
ELSE FTPT='Part-Time';
IF ADCStuGRSAdmitStatus EQ ' ' THEN ADCStuGRSAdmitStatus='Unk';
PROC SORT DATA=GRS NODUPKEY OUT=GRSUnDup; BY ADCPersonID;
RUN;


/* EXPORT FALL ENROLLMENT COHORTS TO EXCEL */

DATA ftgrs0 (KEEP=
				InstTerm
				InstDataPoint
				ADCFederalCohortGroup
				ADCPersonID
				ADCPersonIDSLEDCHGA
);
SET grsundup;
WHERE ftpt="Full-Time" AND GRSAdmitStatus='FirstTime';
ADCFederalCohortGroup="&FTFT";
ADCPersonIDSLEDCHGA=(TRIM(LEFT(ADCPersonID)))||'*CU';
RUN;

DATA ftgrs (KEEP=
				ADCPersonID
);
SET ftgrs0;
RUN;

DATA ptgrs0 (KEEP=
				InstTerm
				InstDataPoint
				ADCFederalCohortGroup
				ADCPersonID
				ADCPersonIDSLEDCHGA
);
SET grsundup;
WHERE ftpt="Part-Time" AND GRSAdmitStatus='FirstTime';
ADCFederalCohortGroup="&FTPT";
ADCPersonIDSLEDCHGA=(TRIM(LEFT(ADCPersonID)))||'*CU';
RUN;

DATA ptgrs (KEEP=
				ADCPersonID
);
SET ptgrs0;
RUN;

DATA ftxfrgrs0 (KEEP=
				InstTerm
				InstDataPoint
				ADCFederalCohortGroup
				ADCPersonID
				ADCPersonIDSLEDCHGA
);
SET grsundup;
WHERE ftpt="Full-Time" AND (GRSAdmitStatus='Transfer');
ADCFederalCohortGroup="&TRFT";
ADCPersonIDSLEDCHGA=(TRIM(LEFT(ADCPersonID)))||'*CU';
RUN;

DATA ftxfrgrs (KEEP=
				ADCPersonID
);
SET ftxfrgrs0;
RUN;

DATA ptxfrgrs0 (KEEP=
				InstTerm
				InstDataPoint
				ADCFederalCohortGroup
				ADCPersonID
				ADCPersonIDSLEDCHGA
);
SET grsundup;
WHERE ftpt="Part-Time" AND (GRSAdmitStatus='Transfer');
ADCFederalCohortGroup="&TRPT";
ADCPersonIDSLEDCHGA=(TRIM(LEFT(ADCPersonID)))||'*CU';
RUN;


DATA ptxfrgrs (KEEP=
				ADCPersonID
);
SET ptxfrgrs0;
RUN;


proc export data=ftgrs0
outfile="&Pth01&Pth02&Pth03&Pth04\FTGRS&yt01..csv"
dbms=csv replace;
putnames=yes;
run;

proc export data=ptgrs0
outfile="&Pth01&Pth02&Pth03&Pth04\PTGRS&yt01..csv"
dbms=csv replace;
putnames=yes;
run;

proc export data=ftxfrgrs0
outfile="&Pth01&Pth02&Pth03&Pth04\TFGRS&yt01..csv"
dbms=csv replace;
putnames=yes;
run;

proc export data=ptxfrgrs0
outfile="&Pth01&Pth02&Pth03&Pth04\TPGRS&yt01..csv"
dbms=csv replace;
putnames=yes;
run;


/* add GRS cohorts to Student dataset */

DATA stu;
SET &lb06 .&ds06&yt06&rp06;
PROC SORT DATA=stu; BY ADCPersonID;
RUN;

data stuftgrs;
merge stu (in=x) ftgrs (in=y);
by adcpersonid;
IF x*y=1;
ADCStuFederalCohortGroup="&yr01.FT";
run;

data stuptgrs;
merge stu (in=x) ptgrs (in=y);
by adcpersonid;
IF x*y=1;
ADCStuFederalCohortGroup="&yr01.PT";
run;

data stutfgrs;
merge stu (in=x) ftxfrgrs (in=y);
by adcpersonid;
IF x*y=1;
ADCStuFederalCohortGroup="&yr01.TF";
run;

data stutpgrs;
merge stu (in=x) ptxfrgrs (in=y);
by adcpersonid;
IF x*y=1;
ADCStuFederalCohortGroup="&yr01.TP";
run;

DATA AllCohorts;
SET
	stuftgrs
	stuptgrs
	stutfgrs
	stutpgrs
;
PROC SORT DATA=AllCohorts; BY ADCPersonID;
RUN;
	
DATA StuRemaining;
	MERGE stu (in=a) AllCohorts (IN=b); BY ADCPersoniD;
	IF a AND NOT b;
RUN;


DATA StuFinalCohorts;
SET
	AllCohorts
	StuRemaining
;
PROC SORT DATA=StuFinalCohorts; BY ADCPersonID;
RUN;

/* export student dataset that includes added GRS */

DATA &lb06 .&ds06&yt06&rp06;
SET StuFinalCohorts;
RUN;



ODS LISTING CLOSE;
ODS HTML CLOSE;
ODS MARKUP TAGSET=CHTML BODY="&Pth01&Pth02&Pth03&Pth04\IPEDS_FederalCohortGroups.html";

DATA FinalReport;
SET StuFinalCohorts;
TITLE1 " LIST OF CURRENT FEDERAL COHORT GROUPS IN YOUR FALL DATA ";
TITLE2 " FOR &yt06b At &rp06b Data Point ";
PROC FREQ DATA=FinalReport;
	TABLES ADCStuFederalCohortGroup;
RUN;

ODS MARKUP TAGSET=CHTML CLOSE;
