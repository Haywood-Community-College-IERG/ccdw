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
* PURPOSE:      Create Financial Aid Disbursement Datasets                          *
*               For Any Fiscal Year                                                 *
*************************************************************************************;
OPTIONS PS=5000 LS=256 NONUMBER NOCENTER;

%LET PathRoot=W:\InstitutionalResearch\A_XNC_Datatel;


LIBNAME Dld6 "&PathRoot\Downloads\";
LIBNAME Fad6 "&PathRoot\Downloads\SASDatasets\07_FinAidDisbursement\";

%LET pt01=&pathroot\Downloads\;
%LET tx01=FAAwardDisb01.txt;

%LET lb01=Fad6;
%LET ds01=FADisb_;
%LET rp01=;			/* THIS IS USED TO DESIGNATE _Partial DATASETS */
%LET yt01=20142015; /* CHANGGES FOR EACH FISCAL YEAR */

*------------------------------------------------*;
* NO FURTHER CHANGES NECESSARY BEYOND THIS POINT *;
*------------------------------------------------*;

%LET IC01=US;		* Country of Institution;
%LET IS01=NC;		* State of Institution;
%LET II01=882;		* state institution ID;
%LET IN01=SWCC;	* Institution Short name;
%LET IU01=199731;	* IPEDS Unit ID;
%LET OI01=008466;	* OPE ID / FICE Code;

* BEGIN - SECTION Disb01 - IMPORTS THE DATATEL/COLLEAGUE FIXED LENGTH FILE FOR FINANCIAL AID SIDBURSMENTS *;

DATA disb01;
INFILE "&pt01&tx01" LINESIZE=401 TRUNCOVER;
INPUT 		@1 ADCDisbKey $21. @;
	SELECT;
	WHEN (ADCDisbKey NE 'TA.ACYR') DO;
		INPUT 
			@25		ADCPersonID 			 $10.
			@38		ADCDisbLastName			$16.
			@54		ADCDisbFirstName		$16.
			@70		ADCDisbTerm				 $7.
			@77		ADCDisbAwardID			 $6.
			@85 	ADCDisbTermAmount		  8.
			@96 	ADCDisbTermXmitAmt		  8.
			@104 	ADCDisbTermUnXmitAmt	  8.
			@114 	ADCDisbTermXmitDate		$11.
			@127	ADCDisbEFC				  8.

/*			@46		ADCDisbAwardCat			$8.
			@78		ADCDisbAwardPeriod		$6.*/
			
;
		OUTPUT disb01;
	END;
	OTHERWISE DO;
	PUT 'Error in record ' _n_ 'as follows:' _INFILE_;
		DELETE;
	END;
END;
RUN;

* END - SECTION Disb01 - IMPORTS THE DATATEL/COLLEAGUE FIXED LENGTH FILE FOR FINANCIAL AID SIDBURSMENTS *;

* BEGIN - SECTION 2 - THIS SAVES THE DATA AS A SAS DATASET TO OTHER THAN H: DRIVE *;
/*
DATA &lb01 .&ds01&yt01&rp01;
*RETAIN;
SET disb01;
TITLE2 "THIS SAVES THE DATA AS A SAS DATASET";
RUN;
*/
* END - SECTION 2 - THIS SAVES THE DATA AS A SAS DATASET TO OTHER THAN H: DRIVE *;

* BEGIN - SECTION 2 - THIS SAVES THE DATA AS A SAS DATASET TO H: DRIVE*;
DATA DisbFinal (KEEP=
					InstFiscalYear
					ADCPersonID
					ADCDisbLastName
					ADCDisbFirstName
					ADCDisbTerm
					ADCDisbAwardID
					ADCDisbTermAmount
					ADCDisbTermXmitAmt
					ADCDisbTermUnXmitAmt
					ADCDisbTermXmitDate
					ADCDisbEFC
					InstCountry
					InstState
					InstShortName
					InstID
					InstIPEDSUnitID
					InstOPEID
);
RETAIN
					InstFiscalYear
					ADCPersonID
					ADCDisbLastName
					ADCDisbFirstName
					ADCDisbTerm
					ADCDisbAwardID
					ADCDisbTermAmount
					ADCDisbTermXmitAmt
					ADCDisbTermUnXmitAmt
					ADCDisbTermXmitDate
					ADCDisbEFC
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
		InstShortName $10.
		InstFiscalYear $10.
		InstIPEDSUnitID $10.
		InstOPEID $10.
;
SET Disb01;
InstCountry="&IC01";
InstState="&IS01";
InstID="&II01";
InstShortName="&IN01";
InstIPEDSUnitID="&IU01";
InstOPEID="&OI01";
InstFiscalYear="&YT01";
RUN;


DATA &lb01 .&ds01&yt01&rp01;
*RETAIN;
SET DisbFinal;
TITLE2 "THIS SAVES THE DATA AS A SAS DATASET";
RUN;

* END - SECTION 2 - THIS SAVES THE DATA AS A SAS DATASET TO H: DRIVE*;



/*
ODS LISTING CLOSE;
ODS markup tagset=chtml BODY='General01.html';

DATA PRINT01;
SET disb01;
PROC SORT NODUPKEY DATA=PRINT01; BY ADCDisbAwardID;
PROC PRINT DATA=PRINT01;
VAR ADCDisbAwardID;
RUN;

ODS markup tagset=chtml CLOSE;


*/
