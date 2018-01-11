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
* PURPOSE:      Create AR.PAYMENTS Dataset For Sponsorship Data                     *
*               For Any Term                                                        *
*************************************************************************************;
OPTIONS PS=5000 LS=256 NONUMBER NOCENTER;

%LET PathRoot=W:\InstitutionalResearch\A_XNC_Datatel;

LIBNAME Dld6 "&PathRoot\Downloads";
LIBNAME Fas6 "&PathRoot\Downloads\SASDatasets\08_FinAidSponsorship";

%LET lb01=Dld6;
%LET pt01=&PathRoot\Downloads\;
%LET tx01=AR_PAYMENTS.txt;

%LET lb03=Fas6;
%LET ds03=AR_;
%LET rp03=PAYMENTS_;
%LET yt03=201403;		* CHANGE FOR EACH TERM;

*------------------------------------------------*;
* NO FURTHER CHANGES NECESSARY BEYOND THIS POINT *;
*------------------------------------------------*;

%LET IC01=US;		* Country of Institution;
%LET IS01=NC;		* State of Institution;
%LET II01=882;		* state institution ID;
%LET IN01=SWCC;	* Institution Short name;
%LET IU01=199731;	* IPEDS Unit ID;
%LET OI01=008466;	* OPE ID / FICE Code;

* BEGIN - SECTION ARPay01 - IMPORTS THE DATATEL/COLLEAGUE FIXED LENGTH FILE FOR AR.PAYMENTS FOR SPONSORSHIPS *;

DATA ARPay01;
INFILE "&pt01&tx01" LINESIZE=450 TRUNCOVER;
INPUT 		@1 ADCPersonID $10. @;
	SELECT;
	WHEN (ADCPersonID NE 'ID        ') DO;
		INPUT 
				@1		ADCPersonID				$10.
				@11		ADCARPPaymentsID		$11.
				@22		ADCARPAmount			COMMA8.2
				@34		ADCARPAcctsID			$15.
				@49		ADCARPPostedFlag		$2.
				@58		ADCARPType				$4.
				@93		ADCARPDate				$8.
				@101	ADCARPStuFirstName		$30.
				@131	ADCARPStuLastName		$30.
				@188	ADCARPStuMiddleName		$16.
				@204	ADCARPOnArAccts			$3.
				@219	ADCARPPaymentItems		$10.
				@232	ADCARPStuTypeTerm		$20.
				@255	ADCARPReportingTerm		$10.
				@269	ADCARPReversedAmt		COMMA8.2
				@281	ADCARPSponPersonIndex	$20.
				@301	ADCARPSponsorInvoice	$10.
				@316	ADCARPSponsoredPerson	$10.
				@332	ADCARPSponsorshipIndex	$12.
				@351	ADCARPTerm				$10.
				@386	ADCARPTermXferFlag		$3.
				@390	ADCARPQBSEC				$3.
/*				@395	ADCARPCount				8.*/
				@395	ADCARPNetAmt			COMMA8.2
/*				@415	ADCARPSource			$6.*/
;
		OUTPUT ARPay01;
	END;
	OTHERWISE DO;
	PUT 'Error in record ' _n_ 'as follows:' _INFILE_;
		DELETE;
	END;
END;
RUN;

* END - SECTION ARPay01 - IMPORTS THE DATATEL/COLLEAGUE FIXED LENGTH FILE FOR SPONSORSHIPS *;

* BEGIN - SECTION Repeat01 - REPEATS VALUES FOR NON-MULTIVALUE VARIABLES *;

DATA Repeat01;
SET ARPay01;
	RETAIN Item01;
	DROP   Item01;
  IF ADCPersonID EQ ' ' 
     THEN ADCPersonID=Item01;
     ELSE Item01=ADCPersonID;
IF ADCARPSponsorshipIndex EQ ' ' THEN DELETE;
RUN;

* END - SECTION Repeat01 - REPEATS VALUES FOR NON-MULTIVALUE VARIABLES *;


* BEGIN - SECTION 2 - THIS SAVES THE DATA AS A SAS DATASET - TO LOCAL G: *;
/*
DATA &lb02 .&ds02&rp02&yt02;
RETAIN
		ADCPersonID
		ADCARPStuLastName
		ADCARPStuFirstName
		ADCARPStuMiddleName
		ADCARPSource
		ADCARPReportingTerm
		ADCARPTerm
		ADCARPDate
		ADCARPAmount
		ADCARPReversedAmt
		ADCARPNetAmt
		ADCARPSponsorshipIndex
		ADCARPSponPersonIndex
		ADCARPCount
		ADCARPQBSEC
		ADCARPPaymentItems
		ADCARPPaymentsID
		ADCARPAcctsID
		ADCARPOnArAccts
		ADCARPSponsorInvoice
		ADCARPSponsoredPerson
		ADCARPPostedFlag
		ADCARPType
		ADCARPStuTypeTerm
		ADCARPTermXferFlag
;
SET Repeat01;
TITLE2 "THIS SAVES THE DATA AS A SAS DATASET";
RUN;
*/

* END - SECTION 2 - THIS SAVES THE DATA AS A SAS DATASET *;

* BEGIN - SECTION 2 - THIS SAVES THE DATA AS A SAS DATASET - TO C: *;

DATA &lb03 .&ds03&rp03&yt03;
RETAIN
		InstTerm
		ADCPersonID
		ADCARPStuLastName
		ADCARPStuFirstName
		ADCARPStuMiddleName
/*		ADCARPSource*/
		ADCARPReportingTerm
		ADCARPTerm
		ADCARPDate
		ADCARPAmount
		ADCARPReversedAmt
		ADCARPNetAmt
		ADCARPSponsorshipIndex
		ADCARPSponPersonIndex
/*		ADCARPCount*/
		ADCARPQBSEC
		ADCARPPaymentItems
		ADCARPPaymentsID
		ADCARPAcctsID
		ADCARPOnArAccts
		ADCARPSponsorInvoice
		ADCARPSponsoredPerson
		ADCARPPostedFlag
		ADCARPType
		ADCARPStuTypeTerm
		ADCARPTermXferFlag
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
		InstTerm $10.
		InstIPEDSUnitID $10.
		InstOPEID $10.
;
SET Repeat01;
InstCountry="&IC01";
InstState="&IS01";
InstID="&II01";
InstShortName="&IN01";
InstIPEDSUnitID="&IU01";
InstOPEID="&OI01";
InstTerm="&YT03";
TITLE2 "THIS SAVES THE DATA AS A SAS DATASET";
RUN;

* END - SECTION 2 - THIS SAVES THE DATA AS A SAS DATASET *;

