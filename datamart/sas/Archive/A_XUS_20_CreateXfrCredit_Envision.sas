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
* PURPOSE:      Create Transfer Credit SAS Datasets                                 *
*               For Any Year                                                        *
*************************************************************************************;
OPTIONS PS=5000 LS=256 NONUMBER NOCENTER;

%LET PathRoot=W:\InstitutionalResearch\A_XNC_Datatel;

LIBNAME Dld6 "&PathRoot\Downloads";
LIBNAME Xfr6 "&PathRoot\Downloads\SASDatasets\04_TransferCredits\";

%LET lb01=Dld6;
%LET pt01=&PathRoot\Downloads\;
%LET tx01=TRCredits.txt;

%LET lb02=Xfr6;
%LET ds02=XfrCred_;
%LET rp02=_ET;		* CHANGE FOR EACH DATA POINT;
%LET yt02=2014;		* CHANGE FOR EACH YEAR;



*------------------------------------------------*;
* NO FURTHER CHANGES NECESSARY BEYOND THIS POINT *;
*------------------------------------------------*;

%LET IC01=US;		* Country of Institution;
%LET IS01=NC;		* State of Institution;
%LET II01=882;		* state institution ID;
%LET IN01=SWCC;	* Institution Short name;
%LET IU01=199731;	* IPEDS Unit ID;
%LET OI01=008466;	* OPE ID / FICE Code;



* BEGIN - SECTION 1a - IMPORTS THE TRANSFER CREDIT DATATEL/COLLEAGUE FIXED LENGTH FILE *;

DATA Xfr01 (KEEP=
					ADCXfrID
					ADCPersonID
					ADCXfrCrsNo
					ADCXfrAcadLvl
					ADCXfrCompletedCEUs
					ADCXfrCompletedCredits
					ADCXfrComments
					ADCXfrStateCrsNo
					ADCXfrCrsLvl
					ADCXfrCourse
					ADCXfrCredType
					ADCXfrCurrentResidency
					ADCXfrDepts
					ADCXfrEndDate
					ADCXfrStuFirstName
					ADCXfrStuLastName
					ADCXfrStuMiddleName
					ADCXfrStartDate
					ADCXfrStatus
					ADCXfrStatusDate
					ADCXfrStuEquivEval
					ADCXfrCrsPrefix
					ADCXfrCrsTitle
);
INFILE "&pt01&tx01" LINESIZE=550 TRUNCOVER;
INPUT @1 ADCXfrID $10. @;
	SELECT;
	WHEN (ADCXfrID NE 'STUDENT.AC') DO;
		INPUT 
				@1		ADCXfrID				$10.
				@18		ADCPersonID				$10.
				@28		ADCXfrCrsNo				$9.
				@37		ADCXfrAcadLvl			$6.
				@72		ADCXfrCompletedCEUs		8.
				@81		ADCXfrCompletedCredits	8.
				@90		ADCXfrComments			$65.
				@155	ADCXfrStateCrsNo		$14.
				@170	ADCXfrCrsLvl			$10.
				@200	ADCXfrCourse			$14.
				@215	ADCXfrCredType			$4.
				@264	ADCXfrCurrentResidency	$4.
				@274	ADCXfrDepts				$8.
				@313	ADCXfrEndDate			$8.
				@321	ADCXfrStuFirstName		$25.
				@346	ADCXfrStuLastName		$25.
				@371	ADCXfrStuMiddleName		$25.
				@396	ADCXfrStartDate			$8.
				@406	ADCXfrStatus			$4.
				@421	ADCXfrStatusDate		$8.
				@432	ADCXfrStuEquivEval		$10.
				@450	ADCXfrCrsPrefix			$6.
				@490	ADCXfrCrsTitle			$30.
;			OUTPUT Xfr01;
	END;
	OTHERWISE DO;
	PUT 'Error in record ' _n_ 'as follows:' _INFILE_;
		DELETE;
	END;
END;
RUN;

* END - SECTION 1a - IMPORTS THE FIRST OF TWO DATATEL/COLLEAGUE FIXED LENGTH FILES *;

DATA Xfr02;
SET Xfr01;
IF ADCPersonID EQ ' ' THEN DELETE;
PROC SORT DATA=Xfr02; BY ADCPersonID;
RUN;


DATA FINAL;
RETAIN				
					InstYear
					ADCXfrID
					ADCPersonID
					ADCXfrStuLastName
					ADCXfrStuFirstName
					ADCXfrStuMiddleName
					ADCXfrCourse
					ADCXfrCrsPrefix
					ADCXfrCrsNo
					ADCXfrCrsTitle
					ADCXfrAcadLvl
					ADCXfrCrsLvl
					ADCXfrDepts
					ADCXfrCompletedCredits
					ADCXfrCompletedCEUs
					ADCXfrCredType
					ADCXfrStatus
					ADCXfrStatusDate
					ADCXfrStartDate
					ADCXfrEndDate
					ADCXfrStuEquivEval
					ADCXfrCurrentResidency
					ADCXfrStateCrsNo
					ADCXfrComments
					InstCountry
					InstState
					InstShortName
					InstID
					InstIPEDSUnitID
					InstOPEID
;
FORMAT
		InstCountry $3.
		InstState $3.
		InstID $10.
		InstShortName $10.
		InstYear $10.
		InstIPEDSUnitID $10.
		InstOPEID $10.
;
SET Xfr02;
InstCountry="&IC01";
InstState="&IS01";
InstID="&II01";
InstShortName="&IN01";
InstIPEDSUnitID="&IU01";
InstOPEID="&OI01";
InstYear="&YT02";
PROC SORT DATA=FINAL; BY ADCPersonID;
RUN;


* BEGIN - SECTION 5a - THIS SAVES THE DATA AS A SAS DATASET *;

DATA &lb02 .&ds02&yt02&rp02;
SET FINAL;
TITLE2 "THIS SAVES THE DATA AS A SAS DATASET";
RUN;

* END - SECTION 5a - THIS SAVES THE DATA AS A SAS DATASET *;


* BEGIN - SECTION 5b - THIS SAVES THE DATA AS A CSV FILE *;
/*
PROC EXPORT DATA= WORK.classmerge 
            OUTFILE= "&pt03&ds03&yt02&rp02" 
            DBMS=CSV REPLACE;
RUN;
*/
* END - SECTION 5b - THIS SAVES THE DATA AS A CSV FILE *;


* BEGIN - SECTION 5c - THIS SAVES THE DATA AS A TAB DELIMITED TEXT FILE *;
/*
PROC EXPORT DATA= WORK.classmerge 
            OUTFILE= "&pt03&ds03&yt02&rp02" 
            DBMS=TAB REPLACE;
RUN;
*/
* END - SECTION 5c - THIS SAVES THE DATA AS A TAB DELIMITED TEXT FILE *;

* END SAS PROGRAM TO CREATE CLASS DATASETS *;

/*
ODS LISTING CLOSE;
ODS markup tagset=chtml BODY='MCCS2.html';

PROC PRINT DATA=classmerge;
RUN;

ODS markup tagset=chtml CLOSE;
*/

/*
PROC CONTENTS DATA=&lb02 .&ds02&yt02&rp02;
RUN;
*/
