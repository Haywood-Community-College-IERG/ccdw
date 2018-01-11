****************************************************************************************
* CREATED BY:   Bobbie J. Frye                                                         *
* DATE CREATED: 09/30/2012                                                             *
* MODIFIED1:                                                                           *
* REQUESTOR:    IR                                                                     *
* PURPOSE:      Data For National Student Clearinghouse                                *
*               For Dataset                                                            *
*               INSTRUCTIONS: Change all variables as indicated                        *
****************************************************************************************;
OPTIONS PS=500 LS=256 NONUMBER NOCENTER;

%LET PathRoot=H:\Planning and Research FTP\CPCCSASDatasets\A_XNC_Datatel;   	/* 6 Digit Datasets */
*%LET PathRoot=H:\Planning and Research FTP\CPCCSASDatasets\DatatelColleague;	/* 3 Digit Datasets */


/* AFTER RUNNING THIS PROGRAM - LOCATE NSC SUBMISSION TEXT FILE IN -  H:\Planning and Research FTP\CPCCSASDatasets\A_XNC_Datatel\Downloads\Archive\NSC\YYYYTT_Term */
/* AND SUBMIT TO CLEARINGHOUSE FOR PROCESSING */

LIBNAME Stu6 "&PathRoot\Downloads\SASDatasets\02_Student";
LIBNAME All6 "&PathRoot\Downloads\SASDatasets\00_All";
LIBNAME NSC6 "&PathRoot\Downloads\SASDatasets\30_NSC";

%LET Pth01=&PathRoot\Downloads\Archive\NSC;

%LET lb01=All6;
%LET ds01=All_;
%LET rp01=_GRS;
%LET yt01=201703;								* CHANGE FOR EACH TERM;

%LET lb02=NSC6;
%LET ds02=NSCTermFile_;
%LET rp02=002915_;								* CHANGE FOR EACH INSTITUTION - THIS IS INSTITUTION FICE CODE;

%LET yt02=201703_Fall;							* CHANGE FOR EACH TERM;


%LET SN=Central Piedmont Community College;		* CHANGE FOR EACH INSTITUTION - THIS IS INSTITUTION NAME;

%LET FCD=20171013;         						* CHANGE DATE - THIS IS FILE CREATION DATE FORMAT=YYYYMMDD MUST BE A DATE PRIOR TO FILE SUBMISSION DATE;

%LET SBD=20170801;         						* CHANGE DATE - THIS IS SEARCH BEGIN DATE YYYYMMDD;
												/* FOR PA                                                                          */
												/* 	Fall Term use YYYY0801 Same Year as Fall Term                                  */
												/* 	Spring Term use YYYY0101 Same Year as Spring Term                              */
												/* 	Summer Term use YYYY0501 Same Year as Summer Term                              */
												/* FOR SE                                                                          */
												/* 	Fall Term use YYYY1231 Same Year as Fall Term                                  */
												/* 	Spring Term use YYYY0531 Same Year as Spring Term                              */
												/* 	Summer Term use YYYY0731 Same Year as Summer Term                              */
%LET RT=D1;
%LET SC=002915;									* CHANGE FOR EACH INSTITUTION - THIS IS INSTITUTION FICE/OPE ID;
%LET BC=00;

%LET CI=_PGE;									* UPDATE - SUBISSION FILE CREATORS INITIALS;

%LET IT=_PA;									* ENTER SEARCH TYPE - IT IS INQUIRY TYPE - SEE OPTIONS AND DESCRIPTIONS BELOW;;
												/* SE (Subsequent Enrollment for Previously Enrolled Students/Transfers Out)		*/
												/*		(Searches for attendance AFTER the Search Begin Date)						*/
												/* DA (Subsequent Enrollment for Prospective Student/Denied/Declined Admissions)	*/
												/*		(Searches for attendance AFTER the Search Begin Date)						*/
												/* PA (Prior Attendance for Pending Admissions)										*/
												/*		(Searches for attendance BEFORE the Search Begin Date)						*/
												/* SB (Sibling/Parent Enrollment)													*/
												/*		(Searches for attendance AFTER the Search Begin Date)						*/
												/* CO (Cohort Query)																*/
												/*		(Searches for cohort retention and completion rates AFTER Search Begin Date;*/
												/*			only one date can be used per file)										*/

*----------------------------------------------*;
* NO FURTHER CHANGES NECESSARY BEYOND THIS POINT;
*----------------------------------------------*;

/* BEGIN SECTION01 - SELECT STUDENTS FOR SUBMISSION TO NATIONAL STUDETN CLEARINGHOUSE */

DATA Select01 (KEEP=
					ADCPersonID
					ADCStuSSN
					ADCStuFirstName
					ADCStuMiddleName
					MI
					ADCStuLastName
					ADCStuNameSuffix
					BirthDate
					ADCClsAcadLevel
					ADCClsCurrentStatus
					ADCStuClsStatus
					ExitTranslation
);
RETAIN
		MI
;
FORMAT
		MI $1.
;
SET
&lb01 .&ds01&yt01&rp01
;
MI=(SUBSTR(ADCStuMiddleName,1,1));
/* ENTER STUDENT SELECTION CRITERIA IN THIS SECTION */
/*IF ADCStuFederalCohortGroup IN (*/
/*								"&grs01"*/
/*								);*/
IF ADCClsAcadLevel IN (
						'CU'
						);
/*IF ADCClsCurrentStatus IN (*/
/*							'A',*/
/*							'P'*/
/*							);*/
/*IF (ADCStuClsStatus IN (*/
/*						'N',*/
/*						'A'*/
/*						)*/
/*	OR ExitTranslation IN (*/
/*							'W'*/
/*							))*/
/*	AND (ExitTranslation NOT IN (*/
/*								'WN'*/
/*								));*/
/*ADCStuNameSuffix=(COMPRESS(ADCStuNameSuffix,'.'));*/
IF ADCStuLastName EQ ' ' OR ADCStuFirstName EQ ' ' THEN DELETE;
PROC SORT DATA=Select01; BY ADCPersonID;
PROC SORT NODUPKEY DATA=Select01; BY ADCPersonID;
/*ODS LISTING;*/
/*PROC FREQ DATA=Select01;*/
/*	TABLES ADCStuNameSuffix;*/
RUN;

/* END SECTION01 - SELECT STUDENTS FOR SUBMISSION TO NATIONAL STUDETN CLEARINGHOUSE */


/* BEGIN SECTION02 - CLEAN DATA TO ADDRESS DATA ENTRY ERROR(S) WHEN ENTERING SUFFIX INFORMATION */

DATA FixSuffix;
     SET Select01;
     StuLastName=(UPCASE(ADCStuLastName));
     ARRAY Names [2] $ 25 Lname Suffix;
/*     X=SCAN(StuLastName,-1,' ');*/
     IF SCAN(StuLastName,-1,' ,.') IN ('I','II','III','IV','V','JR','SR', 'PHR') THEN  
           DO i=1 to 2;
                Names[i] = SCAN(ADCStuLastName,I,' ,');
           END;
     IF Lname NE '' THEN 
           DO;
                ADCStuLastName=LName;
                ADCStuNameSuffix=COMPRESS(Suffix,'.');
           END;
     IF INDEX(ADCStuLastName,',') > 0 THEN 
           DO;
                ADCStuLastName=COMPRESS(ADCStuLastName,',');
           END;
DROP
	StuLastName
	Lname
	Suffix
/*	X*/
	i
;
/* BEGIN - CORRECTION SECTION FOR INDIVIDUAL ISSUES */
/*IF ADCPersonID EQ '3725165' THEN BirthDate='19810208';*/
/*IF ADCPersonID EQ '3761920' THEN BirthDate='19920825';*/
/*IF ADCPersonID EQ '3553058' THEN BirthDate='19881213';*/
/*IF ADCPersonID EQ '3604571' THEN BirthDate='19880729';*/
/*IF ADCPersonID EQ '1386931' THEN BirthDate='19680101';*/
/*IF ADCPersonID EQ '3734306'*/
/*		THEN DO*/
/*		Suffix='III';*/
/*		ADCStuLastName='MONTGOMERY';*/
/*		END;*/
/*IF ADCPersonID EQ '37029963'*/
/*		THEN DO*/
/*		Suffix='II';*/
/*		ADCStuLastName='COLLMAR';*/
/*		END;*/
/*IF ADCPersonID EQ '3612217'*/
/*		THEN DO*/
/*		Suffix='III';*/
/*		ADCStuLastName='HURLEY';*/
/*		END;*/


/* END - CORRECTION SECTION FOR INDIVIDUAL ISSUES */

/* BEGIN - CORRECTION SECTION FOR NON-CHARACTER ISSUES */

IF (UPCASE(ADCStuNameSuffix)) EQ 'PHR' THEN ADCStuNameSuffix=' ';

ADCStuLastName=TRANWRD(ADCStuLastName, "/", "-");
ADCStuLastName=TRANWRD(ADCStuLastName, "Â", "A");
ADCStuLastName=TRANWRD(ADCStuLastName, "Ä", "A");
ADCStuLastName=TRANWRD(ADCStuLastName, "Å", "A");
ADCStuLastName=TRANWRD(ADCStuLastName, "Á", "A");
ADCStuLastName=TRANWRD(ADCStuLastName, "á", "a");
ADCStuLastName=TRANWRD(ADCStuLastName, "â", "a");
ADCStuLastName=TRANWRD(ADCStuLastName, "ä", "a");
ADCStuLastName=TRANWRD(ADCStuLastName, "à", "a");
ADCStuLastName=TRANWRD(ADCStuLastName, "å", "a");
ADCStuLastName=TRANWRD(ADCStuLastName, "É", "E");
ADCStuLastName=TRANWRD(ADCStuLastName, "é", "e");
ADCStuLastName=TRANWRD(ADCStuLastName, "í", "i");
ADCStuLastName=TRANWRD(ADCStuLastName, "ó", "o");
ADCStuLastName=TRANWRD(ADCStuLastName, "ú", "u");
ADCStuLastName=TRANWRD(ADCStuLastName, "ç", "c");
ADCStuLastName=TRANWRD(ADCStuLastName, "ñ", "n");
ADCStuLastName=TRANWRD(ADCStuLastName, "Ñ", "N");
/*ADCStuLastName=TRANWRD(ADCStuLastName, ".", " ");*/
ADCStuLastName=TRANWRD(ADCStuLastName, ".", "");
ADCStuLastName=TRANWRD(ADCStuLastName, "´", "'");
ADCStuLastName=TRANWRD(ADCStuLastName, "`", " ");
ADCStuLastName=TRANWRD(ADCStuLastName, "_", "-");
ADCStuLastName=TRANWRD(ADCStuLastName, '"', "");
ADCStuLastName=TRANWRD(ADCStuLastName, "!", "");
ADCStuLastName=TRANWRD(ADCStuLastName, ":", "");
ADCStuLastName=TRANWRD(ADCStuLastName, "(", "");
ADCStuLastName=TRANWRD(ADCStuLastName, ")", "");
ADCStuLastName=TRANWRD(ADCStuLastName, '"', '');

ADCStuFirstName=TRANWRD(ADCStuFirstName, "/", "-");
ADCStuFirstName=TRANWRD(ADCStuFirstName, "Â", "A");
ADCStuFirstName=TRANWRD(ADCStuFirstName, "Ä", "A");
ADCStuFirstName=TRANWRD(ADCStuFirstName, "Å", "A");
ADCStuFirstName=TRANWRD(ADCStuFirstName, "Á", "A");
ADCStuFirstName=TRANWRD(ADCStuFirstName, "á", "a");
ADCStuFirstName=TRANWRD(ADCStuFirstName, "â", "a");
ADCStuFirstName=TRANWRD(ADCStuFirstName, "ä", "a");
ADCStuFirstName=TRANWRD(ADCStuFirstName, "à", "a");
ADCStuFirstName=TRANWRD(ADCStuFirstName, "å", "a");
ADCStuFirstName=TRANWRD(ADCStuFirstName, "É", "E");
ADCStuFirstName=TRANWRD(ADCStuFirstName, "é", "e");
ADCStuFirstName=TRANWRD(ADCStuFirstName, "í", "i");
ADCStuFirstName=TRANWRD(ADCStuFirstName, "ó", "o");
ADCStuFirstName=TRANWRD(ADCStuFirstName, "ú", "u");
ADCStuFirstName=TRANWRD(ADCStuFirstName, "ç", "c");
ADCStuFirstName=TRANWRD(ADCStuFirstName, "ñ", "n");
ADCStuFirstName=TRANWRD(ADCStuFirstName, "Ñ", "N");
/*ADCStuFirstName=TRANWRD(ADCStuFirstName, ".", " ");*/
ADCStuFirstName=TRANWRD(ADCStuFirstName, ".", "");
ADCStuFirstName=TRANWRD(ADCStuFirstName, "´", "'");
ADCStuFirstName=TRANWRD(ADCStuFirstName, "`", " ");
ADCStuFirstName=TRANWRD(ADCStuFirstName, "_", "-");
ADCStuFirstName=TRANWRD(ADCStuFirstName, '"', "");
ADCStuFirstName=TRANWRD(ADCStuFirstName, "!", "");
ADCStuFirstName=TRANWRD(ADCStuFirstName, ":", "");
ADCStuFirstName=TRANWRD(ADCStuFirstName, "(", "");
ADCStuFirstName=TRANWRD(ADCStuFirstName, ")", "");
ADCStuLastName=TRANWRD(ADCStuLastName, '"', '');

MI=TRANWRD(MI, "-", " ");
MI=TRANWRD(MI, ",", " ");
/*MI=TRANWRD(MI, ".", " ");*/
MI=TRANWRD(MI, ".", "");
MI=TRANWRD(MI, "'", " ");
MI=TRANWRD(MI, "`", " ");
MI=TRANWRD(MI, "`", " ");
MI=TRANWRD(MI, "_", " ");
/*MI=TRANWRD(MI, "(", " ");*/
/*MI=TRANWRD(MI, ")", " ");*/
MI=TRANWRD(MI, ":", " ");
MI=TRANWRD(MI, "0", " ");
MI=TRANWRD(MI, "1", " ");
MI=TRANWRD(MI, "2", " ");
MI=TRANWRD(MI, "3", " ");
MI=TRANWRD(MI, "4", " ");
MI=TRANWRD(MI, "5", " ");
MI=TRANWRD(MI, "6", " ");
MI=TRANWRD(MI, "7", " ");
MI=TRANWRD(MI, "8", " ");
MI=TRANWRD(MI, "9", " ");
MI=TRANWRD(MI, "(", "");
MI=TRANWRD(MI, ")", "");
MI=TRANWRD(MI, '"', '');
/* END - CORRECTION SECTION FOR NON-CHARACTER ISSUES */
RUN;  

/* END SECTION02 - CLEAN DATA TO ADDRESS DATA ENTRY ERROR(S) WHEN ENTERING SUFFIX INFORMATION */



DATA NSC01;
RETAIN
		BadBirthDate
;
FORMAT
		BadBirthDate $5.
;
SET
	FixSuffix
;
IF (SUBSTR(BirthDate,1,1)) EQ ' '
	OR (SUBSTR(BirthDate,2,1)) EQ ' '
	OR (SUBSTR(BirthDate,3,1)) EQ ' '
	OR (SUBSTR(BirthDate,4,1)) EQ ' '
	OR (SUBSTR(BirthDate,5,1)) EQ ' '
	OR (SUBSTR(BirthDate,6,1)) EQ ' '
	OR (SUBSTR(BirthDate,7,1)) EQ ' '
	OR (SUBSTR(BirthDate,8,1)) EQ ' '
	THEN BadBirthDate='Yes';
	ELSE BadBirthDate='No';
RUN;


DATA FinalNSC (KEEP=
				ADCPersonID
				RecordType
				SSN
				ADCStuFirstName
				MI
				ADCStuLastName
				Suffix
				Birthdate
				SBDate
				Space
				SchoolCode
				BranchCode
				UniqueID
				InquiryType
);
SET NSC01;
RecordType="&RT";
SBDate="&SBD";
Space=' ';
SchoolCode="&SC";
BranchCode="&BC";
Suffix=(SUBSTR(ADCStuNameSuffix,1,5));
Suffix=(COMPRESS(ADCStuNameSuffix,'.'));
/*MI=substr(ADCStuMiddleName,1,1);*/
UniqueID=ADCPersonID;
SSN='        ';
InquiryType=(COMPRESS("&IT",'_'));
PROC SORT DATA=FinalNSC; BY UniqueID;
RUN;


DATA Final;
RETAIN
		RecordType
		SSN
		ADCStuFirstName
		MI
		ADCStuLastName
		Suffix
		Birthdate
		SBDate
		Space
		SchoolCode
		BranchCode
		UniqueID
		InquiryType
;
SET FinalNSC;
RUN;


DATA _NULL_;
SET  /*input sas file*/
 Final end=IsLast ;
 FILE "&pth01\&yt02\&ds02&rp02&yt02&IT&CI..txt";
IF _N_=1 THEN
PUT
 @1 'H1'
 @3 "&SC"
@9 "&BC"
@11 "&SN"
@51 "&FCD"
@59 InquiryType
@61 'I'
;


PUT
@1 RecordType :$2.
@3 SSN :$9.
@12 ADCStuFirstName :$20.
@32 MI :$1.
@33 ADCStuLastName :$20.
@53 Suffix :$5.
@58 Birthdate :$8.
@66 SBDate :$8.
@74 Space :$1.
@75 SchoolCode :$6.
@81 BranchCode :$2.
@83 UniqueID :$50.
;
IF IsLast=1 THEN DO;
CT=_n_+2;
PUT @1'T1'
@3 CT ;
END;
RUN;



/* BEGIN - THIS GENERATES LIST OF STUDENTS WITH NAME SUFFIX IN LAST NAME FIELD */

ODS LISTING CLOSE;
ODS HTML CLOSE;
ODS MARKUP TAGSET=CHTML BODY="&PathRoot\XX_SAS_TrashBin\Report01PGE2.html";

DATA Compress01;
SET NSC01;
/*FName=ADCStuFirstName;*/
/*MName=MI;*/
LName=COMPRESS(ADCStuLastName,"ABCDEFGHIJKLMNOPQRSTUVWXYZ-'abcdefghijklmnopqrstuvwxyz");
FName=COMPRESS(ADCStuFirstName,"ABCDEFGHIJKLMNOPQRSTUVWXYZ-'abcdefghijklmnopqrstuvwxyz");
MName=COMPRESS(MI,"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz");
IF LName NE ' '
	OR FName NE ' '
	OR Mname NE ' '
;
TITLE1 "Students With Special Character Issues in Name Fields - For &yt01";
TITLE2 " THESE HAVE NOT BEEN FIXED IN THE NSC UPLOAD FILE";
PROC SORT NODUPKEY DATA=Compress01; BY ADCPersonID;
PROC PRINT DATA=Compress01;
RUN;

DATA LastNameIssue01;
     SET Select01;
     StuLastName=(UPCASE(ADCStuLastName));
     X=INDEX(StuLastName,',');
     IF SCAN(StuLastName,-1,' ,.') IN ('I','II','III','IV','V','JR','SR') THEN OUTPUT LastNameIssue01; 
     IF X>0 THEN OUTPUT LastNameIssue01;
RUN;

DATA LastNameIssue02;
SET LastNameIssue01;
TITLE1 "Students With Name Suffix In Last Name Field - For &yt02";
TITLE2 " THESE HAVE BEEN FIXED IN THE NSC UPLOAD FILE";
PROC SORT DATA=LastNameIssue02; BY ADCPersonID;
PROC PRINT DATA=LastNameIssue02;
	VAR
		ADCPersonID
		ADCStuLastName
		ADCStuFirstName
		ADCStuMiddleName
		ADCStuNameSuffix
		;
RUN;



DATA SpecialCharacterIssue01;
     SET Select01;
/*     StuLastName=(UPCASE(ADCStuLastName));*/
     X=INDEXC(ADCStuLastName,'/Âáéíóúçñ.´`_ÄÅÁÑâäàåÉÑ"!:()');
     Y=INDEXC(ADCStuFirstName,'/Âáéíóúçñ.´`_ÄÅÁÑâäàåÉÑ"!:()');
     Z=INDEXC(MI,'-,.´`_0123456789:()/"');
/*     IF SCAN(ADCStuLastName,2,' ,.') IN ('I','II','III','IV','V','JR','SR') THEN OUTPUT LastNameIssue01; */
     IF X>0 OR Y>0 OR Z>0 THEN OUTPUT SpecialCharacterIssue01;
RUN;

DATA SpecialCharacterIssue02;
SET SpecialCharacterIssue01;
TITLE1 "Students With Special Character Issues in Name Fields - For &yt02";
TITLE2 " THESE HAVE BEEN FIXED IN THE NSC UPLOAD FILE";
PROC SORT DATA=SpecialCharacterIssue02; BY ADCPersonID;
PROC PRINT DATA=SpecialCharacterIssue02;
	VAR
		ADCPersonID
		ADCStuLastName
		ADCStuFirstName
		ADCStuMiddleName
		ADCStuNameSuffix
		;
RUN;

DATA BadBirthDate01;;
SET NSC01;
IF BadBirthDate EQ 'Yes';
TITLE1 "Students With Bad BirthDate Issues - For &yt02";
PROC SORT NODUPKEY DATA=BadBirthDate01; BY ADCPersonID;
PROC PRINT DATA=BadBirthDate01;
	VAR
		ADCPersonID
		BirthDate
		ADCStuLastName
		ADCStuFirstName
		ADCStuMiddleName
		ADCStuNameSuffix
		;
RUN;


DATA MissingNames01;;
SET Select01;
IF ADCStuLastName EQ ' ' OR ADCStuFirstName EQ ' ';
TITLE1 "Students With Missing First or Last names - For &yt02";
TITLE2 " THESE HAVE BEEN REMOVED FROM THE NSC UPLOAD FILE";
PROC SORT NODUPKEY DATA=MissingNames01; BY ADCPersonID;
PROC PRINT DATA=MissingNames01;
	VAR
		ADCPersonID
		BirthDate
		ADCStuLastName
		ADCStuFirstName
		ADCStuMiddleName
		ADCStuNameSuffix
		;
RUN;

ODS MARKUP TAGSET=CHTML CLOSE;


/* END - THIS GENERATES LIST OF STUDENTS WITH NAME SUFFIX IN LAST NAME FIELD */
