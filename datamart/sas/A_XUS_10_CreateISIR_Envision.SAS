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
* PURPOSE:      Create Student ISIR Dataset                                         *
*               For Any Fiscal Year                                                 *
*************************************************************************************;
OPTIONS PS=32765 LS=200 NONUMBER NOCENTER;

%LET PathRoot=W:\InstitutionalResearch\A_XNC_Datatel;

LIBNAME Fai6 "&PathRoot\Downloads\SASDatasets\06_FinAidISIR";

%LET Path00=&PathRoot\Downloads\;

%LET Infile01=ISIR_DATA_01.txt;
%LET Infile02=ISIR_DATA_02.txt;
%LET Infile03=ISIR_DATA_03.txt;
%LET Infile04=ISIR_DATA_04.txt;
%LET Infile05=ISIR_DATA_05.txt;
%LET Infile06=ISIR_DATA_06.txt;

%LET lb01=Fai6;
%LET ds01=ISIR_;
%LET rp01=DATA_;

%LET yt01=20142015;	* CHANGE FOR EACH DATASET CREATION FISCAL YEAR - FOR PARTIAL YEAR ADD _Partial ;

*------------------------------------------------*;
* NO FURTHER CHANGES NECESSARY BEYOND THIS POINT *;
*------------------------------------------------*;

%LET IC01=US;		* Country of Institution;
%LET IS01=NC;		* State of Institution;
%LET II01=882;		* state institution ID;
%LET IN01=SWCC;	* Institution Short name;
%LET IU01=199731;	* IPEDS Unit ID;
%LET OI01=008466;	* OPE ID / FICE Code;



* BEGIN - SECTION ISIR01Downloadab - Imports ISIR Flat File Numer 1 Of 6 *;

DATA ISIR01Downloada (KEEP=
							ADCISIRID
							ADCISIRStuActiveDuty
							ADCISIRStuAidInterests
							ADCISIRStuAlienRegNbr
							ADCISIRStuAZE
							ADCISIRStuDOB
							ADCISIRStuBornB4Date
							ADCISIRStuCitizenship
							ADCISIRStuCorrAZE
							ADCISIRStuCorrDependency
							ADCISIRStuCorrPriEFC
							ADCISIRStuCorrRejCodes
							ADCISIRStuCorrSecEFC
							ADCISIRStuCorrSentDate
							ADCISIRStuCorrSnt
							ADCISIRStuCorrStatus
							ADCISIRStuCorrFromID
							ADCISIRStuCorrID
							ADCISIRStuCPSOverAssm01
							ADCISIRStuCPSOverAssm02
							ADCISIRStuCPSOverAssm03
							ADCISIRStuCPSOverAssm04
							ADCISIRStuCPSOverAssm05
							ADCISIRStuCPSOverAssm06
							ADCISIRStuCPSOverDepend
							ADCISIRStuCPSOverRejPrst
							ADCISIRStuCPSOverRej12
							ADCISIRStuCPSOverRej20
							ADCISIRStuCPSOverRej03
							ADCISIRStuCPSOverRej04
							ADCISIRStuCPSOverRejA
							ADCISIRStuCPSOverRejB
							ADCISIRStuCPSOverRejC
							ADCISIRStuCPSOverRejD
							ADCISIRStuCPSOverRejE
							ADCISIRStuCPSOverRejF
							ADCISIRStuCPSOverRejG
							ADCISIRStuCPSOverRejJ
							ADCISIRStuCPSOverRejK
							ADCISIRStuCPSOverRejN
							ADCISIRStuCPSOverRejP
							ADCISIRStuCPSOverRejR
							ADCISIRStuCPSOverRejS
							ADCISIRStuCPSOverRejT
							ADCISIRStuCPSOverRejW
							ADCISIRStuCurrentSSN
							ADCISIRStuDateSign
							ADCISIRStuDegOrCert
							ADCISIRStuDegreeBy
							ADCISIRStuDependChildren
							ADCISIRStuDependOverride
);
INFILE "&Path00&Infile01"  LINESIZE=600 TRUNCOVER;
INPUT @1 ADCISIRID $10. @;
	SELECT;
	WHEN (ADCISIRID NE 'ISIR.FAFSA') DO;
		INPUT @1	ADCISIRID						$10.
				@22		ADCISIRStuActiveDuty		$2.
				@33		ADCISIRStuAidInterests		$2.
				@63		ADCISIRStuAlienRegNbr		$12.
				@80		ADCISIRStuAZE				$2.
				@83		ADCISIRStuDOB				$10.
				@93		ADCISIRStuBornB4Date		$2.
				@107	ADCISIRStuCitizenship		$2.
				@127	ADCISIRStuCorrAZE			$2.
				@131	ADCISIRStuCorrDependency	$2.
				@135	ADCISIRStuCorrPriEFC		7.
				@142	ADCISIRStuCorrRejCodes		$4.
				@162	ADCISIRStuCorrSecEFC		7.
				@169	ADCISIRStuCorrSentDate		$10.
				@188	ADCISIRStuCorrSnt			$2.
				@192	ADCISIRStuCorrStatus		$2.
				@198	ADCISIRStuCorrFromID		$10.
				@220	ADCISIRStuCorrID			$10.
				@241	ADCISIRStuCPSOverAssm01		$2.
				@251	ADCISIRStuCPSOverAssm02		$2.
				@261	ADCISIRStuCPSOverAssm03		$2.
				@271	ADCISIRStuCPSOverAssm04		$2.
				@281	ADCISIRStuCPSOverAssm05		$2.
				@292	ADCISIRStuCPSOverAssm06		$2.
				@301	ADCISIRStuCPSOverDepend		$10.
				@311	ADCISIRStuCPSOverRejPrst	$22.
				@333	ADCISIRStuCPSOverRej12		$2.
				@341	ADCISIRStuCPSOverRej20		$2.
				@349	ADCISIRStuCPSOverRej03		$2.
				@357	ADCISIRStuCPSOverRej04		$2.
				@365	ADCISIRStuCPSOverRejA		$2.
				@373	ADCISIRStuCPSOverRejB		$2.
				@381	ADCISIRStuCPSOverRejC		$2.
				@389	ADCISIRStuCPSOverRejD		$2.
				@397	ADCISIRStuCPSOverRejE		$2.
				@405	ADCISIRStuCPSOverRejF		$2.
				@413	ADCISIRStuCPSOverRejG		$2.
				@421	ADCISIRStuCPSOverRejJ		$2.
				@429	ADCISIRStuCPSOverRejK		$2.
				@437	ADCISIRStuCPSOverRejN		$2.
				@445	ADCISIRStuCPSOverRejP		$2.
				@453	ADCISIRStuCPSOverRejR		$2.
				@461	ADCISIRStuCPSOverRejS		$2.
				@469	ADCISIRStuCPSOverRejT		$2.
				@477	ADCISIRStuCPSOverRejW		$2.
				@485	ADCISIRStuCurrentSSN		$10.
				@498	ADCISIRStuDateSign			$10.
				@508	ADCISIRStuDegOrCert			$2.
				@528	ADCISIRStuDegreeBy			$2.
				@534	ADCISIRStuDependChildren	$2.
				@544	ADCISIRStuDependOverride	$2.
;
		OUTPUT ISIR01Downloada;
	END;
	OTHERWISE DO;
	PUT 'Error in record ' _n_ 'as follows:' _INFILE_;
		DELETE;
	END;
END;
RUN;

DATA ISIR01Downloadb;
SET ISIR01Downloada;
IF ADCISIRID EQ ' ' THEN DELETE;
PROC SORT DATA=ISIR01Downloadb; BY ADCISIRID;
*PROC PRINT DATA=ISIR01Downloadb;
RUN;

* END - SECTION ISIR01Downloadab - Imports ISIR Flat File Numer 1 Of 6 *;


* BEGIN - SECTION ISIR02Downloadab - Imports ISIR Flat File Numer 2 Of 6 *;

DATA ISIR02Downloada (KEEP=
							ADCISIRID
							ADCISIRStuDependency
							ADCISIRStuDrugConvict
							ADCISIRStuEmancipatedMinor
							ADCISIRStuEnrlStatus
							ADCISIRStuFaaAdj
							ADCISIRFtrDOB
							ADCISIRFtrFName
							ADCISIRFtrGradeLvl
							ADCISIRFtrLName
							ADCISIRFtrSSN
							ADCISIRStuFileName
							ADCISIRStuFName
							ADCISIRStuGradeProf
							ADCISIRStuHasGrad
							ADCISIRStuHomelessAtRisk
							ADCISIRStuHomelessByHUD
							ADCISIRStuHomlessBySchool
							ADCISIRStuHousing01
							ADCISIRStuHousing02
							ADCISIRStuHousing03
							ADCISIRStuHousing04
							ADCISIRStuHousing05
							ADCISIRStuHousing06
							ADCISIRStuHousing07
							ADCISIRStuHousing08
							ADCISIRStuHousing09
							ADCISIRStuHousing10
							ADCISIRStuHSGradType08
							ADCISIRStuImportYr
							ADCISIRStuInterestCWS
							ADCISIRStuInterestLoan
							ADCISIRStuISIRType
							ADCISIRStuJobID
							ADCISIRStuLName
							ADCISIRStuLegalGuardianship
							ADCISIRStuMale
							ADCISIRStuMaleFemale
							ADCISIRStuMarried
							ADCISIRMtrDOB
							ADCISIRMtrFName
							ADCISIRMtrGradeLvl
							ADCISIRMtrLName
							ADCISIRMtrSSN
							ADCISIRStuNSLDSID
							ADCISIRStuOrphanWard
							ADCISIRStuOtrDepend
							ADCISIRParAGI
							ADCISIRParAllowanceAdj
							ADCISIRParBusNetWrth
							ADCISIRParCash
							ADCISIRParChildSuppRecv
							ADCISIRParChildSuppPd
							ADCISIRParCoOpEarnings
							ADCISIRParCombatPay
							ADCISIRParDependCareExp
							ADCISIRParDislocatedWorker
);
INFILE "&Path00&Infile02"  LINESIZE=975;
INPUT @1 ADCISIRID $10. @;
	SELECT;
	WHEN (ADCISIRID NE 'ISIR.FAFSA') DO;
		INPUT @1	ADCISIRID					$10.
			@22		ADCISIRStuDependency		$2.
			@25		ADCISIRStuDrugConvict		$2.
			@45		ADCISIRStuEmancipatedMinor	$2.
			@53		ADCISIRStuEnrlStatus		$2.
			@73		ADCISIRStuFaaAdj			$2.
			@85		ADCISIRFtrDOB				$11.
			@100	ADCISIRFtrFName				$17.
			@117	ADCISIRFtrGradeLvl			$2.
			@137	ADCISIRFtrLName				$16.
			@153	ADCISIRFtrSSN				$10.
			@164	ADCISIRStuFileName			$40.
			@204	ADCISIRStuFName				$25.
			@229	ADCISIRStuGradeProf			$2.
			@238	ADCISIRStuHasGrad			$2.
			@251	ADCISIRStuHomelessAtRisk	$2.
			@272	ADCISIRStuHomelessByHUD		$2.
			@292	ADCISIRStuHomlessBySchool	$2.
			@315	ADCISIRStuHousing01			$2.
			@335	ADCISIRStuHousing02			$2.
			@355	ADCISIRStuHousing03			$2.
			@375	ADCISIRStuHousing04			$2.
			@395	ADCISIRStuHousing05			$2.
			@415	ADCISIRStuHousing06			$2.
			@435	ADCISIRStuHousing07			$2.
			@455	ADCISIRStuHousing08			$2.
			@475	ADCISIRStuHousing09			$2.
			@495	ADCISIRStuHousing10			$2.
			@515	ADCISIRStuHSGradType08		$2.
			@535	ADCISIRStuImportYr			$4.
			@539	ADCISIRStuInterestCWS		$2.
			@546	ADCISIRStuInterestLoan		$2.
			@555	ADCISIRStuISIRType			$5.
			@560	ADCISIRStuJobID				$10.
			@590	ADCISIRStuLName				$30.
			@620	ADCISIRStuLegalGuardianship	$2.
			@631	ADCISIRStuMale				$2.
			@640	ADCISIRStuMaleFemale		$2.
			@565	ADCISIRStuMarried			$2.
			@663	ADCISIRMtrDOB				$11.
			@678	ADCISIRMtrFName				$17.
			@695	ADCISIRMtrGradeLvl			$2.
			@715	ADCISIRMtrLName				$16.
			@731	ADCISIRMtrSSN				$10.
			@742	ADCISIRStuNSLDSID			$10.
			@763	ADCISIRStuOrphanWard		$2.
			@774	ADCISIRStuOtrDepend			$2.
			@784	ADCISIRParAGI				$8.
			@792	ADCISIRParAllowanceAdj		$8.
			@801	ADCISIRParBusNetWrth		$8.
			@821	ADCISIRParCash				$8.
			@832	ADCISIRParChildSuppRecv		$8.
			@853	ADCISIRParChildSuppPd		$8.
			@876	ADCISIRParCoOpEarnings		$8.
			@897	ADCISIRParCombatPay			$8.
			@914	ADCISIRParDependCareExp		$8.
			@922	ADCISIRParDislocatedWorker	$4.
;
		OUTPUT ISIR02Downloada;
	END;
	OTHERWISE DO;
	PUT 'Error in record ' _n_ 'as follows:' _INFILE_;
		DELETE;
	END;
END;
RUN;

DATA ISIR02Downloadb;
SET ISIR02Downloada;
PROC SORT DATA=ISIR02Downloadb; BY ADCISIRID;
*PROC PRINT DATA=ISIR02Downloadb;
RUN;

* END - SECTION ISIR02Downloadab - Imports ISIR Flat File Numer 2 Of 6 *;


* BEGIN - SECTION ISIR03Downloadab - Imports ISIR Flat File Numer 3 Of 6 *;

DATA ISIR03Downloada (KEEP=
							ADCISIRID
							ADCISIRParExpFaInc
							ADCISIRParExpMoInc
							ADCISIRParExpNtxInc
							ADCISIRParExpOtrTaxInc
							ADCISIRParExpTaxPd
							ADCISIRParEduCredit
							ADCISIRParElig1040A
							ADCISIRParFaWrkInc
							ADCISIRParFoodStamps
							ADCISIRParGrantScholAid
							ADCISIRParHomeWrthAdj
							ADCISIRParHomeDebt
							ADCISIRParHomeValue
							ADCISIRParIncAdj
							ADCISIRParInterestInc
							ADCISIRParInvNetWrth
							ADCISIRParIRADistrib
							ADCISIRParIRAPmts
							ADCISIRParLegalRes
							ADCISIRParLegalResB4
							ADCISIRParLegalResMo
							ADCISIRParLegalResYr
							ADCISIRParLunchBenefits
							ADCISIRParMarMo
							ADCISIRParMarState
							ADCISIRParMarYr
							ADCISIRParMedDenExp
							ADCISIRParMilClergyAllowed
							ADCISIRParMoWrkInc
							ADCISIRParNbrInFamily
							ADCISIRParNeedBasedEmp
							ADCISIRParNbrInColl
							ADCISIRParNbrExemptions
							ADCISIRParOtrNtxInc
							ADCISIRParPensionPmts
							ADCISIRParSSIBenefits
							ADCISIRParTANF
							ADCISIRParTaxFrmSigned
							ADCISIRParTaxFrmType
							ADCISIRParTaxReturnFiled
							ADCISIRParTotWrkshtA
							ADCISIRParTotWrkshtB
							ADCISIRParTotWrkshtC
							ADCISIRParTuitPdAmt
							ADCISIRParTuitPdNbr
							ADCISIRParNtxPensions
							ADCISIRParUSTaxPd
							ADCISIRParVetNonEdBenefits
							ADCISIRParWIC
);
INFILE "&Path00&Infile03"  LINESIZE=975;
INPUT @1 ADCISIRID $10. @;
	SELECT;
	WHEN (ADCISIRID NE 'ISIR.FAFSA') DO;
		INPUT 	@1		ADCISIRID					$10.
				@22		ADCISIRParExpFaInc			8.
				@30		ADCISIRParExpMoInc			8.
				@38		ADCISIRParExpNtxInc			8.
				@49		ADCISIRParExpOtrTaxInc		8.
				@62		ADCISIRParExpTaxPd			8.
				@73		ADCISIRParEduCredit			4.
				@90		ADCISIRParElig1040A			$2.
				@111	ADCISIRParFaWrkInc			8.
				@119	ADCISIRParFoodStamps		$2.
				@129	ADCISIRParGrantScholAid		$4.
				@151	ADCISIRParHomeWrthAdj		8.
				@161	ADCISIRParHomeDebt			8.
				@170	ADCISIRParHomeValue			8.
				@180	ADCISIRParIncAdj			8.
				@187	ADCISIRParInterestInc		8.
				@209	ADCISIRParInvNetWrth		8.
				@229	ADCISIRParIRADistrib		8.
				@247	ADCISIRParIRAPmts			8.
				@264	ADCISIRParLegalRes			$3.
				@284	ADCISIRParLegalResB4		$2.
				@303	ADCISIRParLegalResMo		$3.
				@313	ADCISIRParLegalResYr		$5.
				@332	ADCISIRParLunchBenefits		$2.
				@341	ADCISIRParMarMo				$3.
				@351	ADCISIRParMarState			$3.
				@371	ADCISIRParMarYr				$5.
				@383	ADCISIRParMedDenExp			8.
				@391	ADCISIRParMilClergyAllowed	$2.
				@419	ADCISIRParMoWrkInc			8.
				@427	ADCISIRParNbrInFamily		8.
				@438	ADCISIRParNeedBasedEmp		$4.
				@459	ADCISIRParNbrInColl			8.
				@470	ADCISIRParNbrExemptions		8.
				@480	ADCISIRParOtrNtxInc			8.
				@504	ADCISIRParPensionPmts		8.
				@525	ADCISIRParSSIBenefits		$2.
				@533	ADCISIRParTANF				$2.
				@541	ADCISIRParTaxFrmSigned		$2.
				@563	ADCISIRParTaxFrmType		$2.
				@583	ADCISIRParTaxReturnFiled	$2.
				@606	ADCISIRParTotWrkshtA		8.
				@625	ADCISIRParTotWrkshtB		8.
				@638	ADCISIRParTotWrkshtC		8.
				@651	ADCISIRParTuitPdAmt			8.
				@658	ADCISIRParTuitPdNbr			8.
				@665	ADCISIRParNtxPensions		8.
				@688	ADCISIRParUSTaxPd			8.
				@698	ADCISIRParVetNonEdBenefits	8.
				@718	ADCISIRParWIC				$2.
;
		OUTPUT ISIR03Downloada;
	END;
	OTHERWISE DO;
	PUT 'Error in record ' _n_ 'as follows:' _INFILE_;
		DELETE;
	END;
END;
RUN;

DATA ISIR03Downloadb;
SET ISIR03Downloada;
PROC SORT DATA=ISIR03Downloadb; BY ADCISIRID;
*PROC PRINT DATA=ISIR03Downloadb;
RUN;

* END - SECTION ISIR03Downloadab - Imports ISIR Flat File Numer 3 Of 6 *;


* BEGIN - SECTION ISIR04Downloadab - Imports ISIR Flat File Numer 4 Of 6 *;

DATA ISIR04Downloada (KEEP=
							ADCISIRID
							ADCISIRStuTxPrepEIN
							ADCISIRStuTxPrepSigned
							ADCISIRStuTxPrepSSN
							ADCISIRStuPrevActTrans
							ADCISIRStuPriEFC
							ADCISIRStuReadyToSend
							ADCISIRStuVetBenRecvd
							ADCISIRStuReceiptDt
							ADCISIRStuRejectCodes
							ADCISIRStuAGI
							ADCISIRStuAllowanceAdj
							ADCISIRStuBusNetWrth
							ADCISIRStuCash
							ADCISIRStuChildSuppRecv
							ADCISIRStuChildSuppPd
							ADCISIRStuCoOpEarnings
							ADCISIRStuCombatPay
							ADCISIRStuDepCareExp
							ADCISIRStuDislocatedWorker
							ADCISIRStuNtxInc
							ADCISIRStuSpoExpInc
							ADCISIRStuExpInc
							ADCISIRStuExpOtrTaxInc
							ADCISIRStuExpTaxPd
							ADCISIRStuEduCredit
							ADCISIRStuEligible1040A
							ADCISIRStuFoodStamps
							ADCISIRStuGrantScholAid
							ADCISIRStuHomeAdj
							ADCISIRStuHomeD
							ADCISIRStuHomeV
							ADCISIRStuIncomeAdj
							ADCISIRStuInterestIncome
							ADCISIRStuInvestNetWorth
							ADCISIRStuIRADistrib
							ADCISIRStuIRAPayments
							ADCISIRStuLegalRes
							ADCISIRStuLegalResB4
							ADCISIRStuLegalResMo
							ADCISIRStuLegalResYr
							ADCISIRStuLunchBen
							ADCISIRStuMaritalMo
							ADCISIRStuMaritalSt
							ADCISIRStuMaritalYr
							ADCISIRStuMedDen
							ADCISIRStuMilClergyAllow
							ADCISIRStuNeedBasedEmp
);
INFILE "&Path00&Infile04"  LINESIZE=975;
INPUT @1 ADCISIRID $10. @;
	SELECT;
	WHEN (ADCISIRID NE 'ISIR.FAFSA') DO;
		INPUT 	@1		ADCISIRID					$10.
				@22		ADCISIRStuTxPrepEIN			$10.
				@32		ADCISIRStuTxPrepSigned		$2.
				@40		ADCISIRStuTxPrepSSN			$10.
				@54		ADCISIRStuPrevActTrans		$10.
				@68		ADCISIRStuPriEFC			8.
				@76		ADCISIRStuReadyToSend		$2.
				@89		ADCISIRStuVetBenRecvd		$2.
				@101	ADCISIRStuReceiptDt			$8.
				@109	ADCISIRStuRejectCodes		$4.
				@131	ADCISIRStuAGI				8.
				@138	ADCISIRStuAllowanceAdj		8.
				@147	ADCISIRStuBusNetWrth		8.
				@167	ADCISIRStuCash				8.
				@179	ADCISIRStuChildSuppRecv		8.
				@200	ADCISIRStuChildSuppPd		8.
				@223	ADCISIRStuCoOpEarnings		8.
				@144	ADCISIRStuCombatPay			8.
				@261	ADCISIRStuDepCareExp		8.
				@269	ADCISIRStuDislocatedWorker	$2.
				@291	ADCISIRStuNtxInc			8.
				@301	ADCISIRStuSpoExpInc			8.
				@309	ADCISIRStuExpInc			8.
				@317	ADCISIRStuExpOtrTaxInc		8.
				@326	ADCISIRStuExpTaxPd			8.
				@336	ADCISIRStuEduCredit			$4.
				@353	ADCISIRStuEligible1040A		$2.
				@373	ADCISIRStuFoodStamps		$2.
				@384	ADCISIRStuGrantScholAid		$4.
				@406	ADCISIRStuHomeAdj			$4.
				@416	ADCISIRStuHomeD				$4.
				@425	ADCISIRStuHomeV				$4.
				@435	ADCISIRStuIncomeAdj			7.
				@442	ADCISIRStuInterestIncome	8.
				@464	ADCISIRStuInvestNetWorth	8.
				@488	ADCISIRStuIRADistrib		8.
				@506	ADCISIRStuIRAPayments		8.
				@523	ADCISIRStuLegalRes			$3.
				@543	ADCISIRStuLegalResB4		$2.
				@562	ADCISIRStuLegalResMo		$3.
				@575	ADCISIRStuLegalResYr		$5.
				@583	ADCISIRStuLunchBen			$2.
				@592	ADCISIRStuMaritalMo			$3.
				@602	ADCISIRStuMaritalSt			$2.
				@622	ADCISIRStuMaritalYr			$5.
				@634	ADCISIRStuMedDen			$4.
				@641	ADCISIRStuMilClergyAllow	$4.
				@669	ADCISIRStuNeedBasedEmp		$4.
;
		OUTPUT ISIR04Downloada;
	END;
	OTHERWISE DO;
	PUT 'Error in record ' _n_ 'as follows:' _INFILE_;
		DELETE;
	END;
END;
RUN;

DATA ISIR04Downloadb;
SET ISIR04Downloada;
IF ADCISIRID EQ ' ' THEN DELETE;
PROC SORT DATA=ISIR04Downloadb; BY ADCISIRID;
*PROC PRINT DATA=ISIR04Downloadb;
RUN;

* END - SECTION ISIR04Downloadab - Imports ISIR Flat File Numer 4 Of 6 *;


* BEGIN - SECTION ISIR05Downloadab - Imports ISIR Flat File Numer 5 Of 6 *;

DATA ISIR05Downloada (KEEP=
							ADCISIRID
							ADCISIRStuNoColl
							ADCISIRStuNoExempt
							ADCISIRStuNoFamily
							ADCISIRStuOtrNonRptMoney
							ADCISIRStuOtrNtxInc
							ADCISIRStuPensionPmts
							ADCISIRStuSSIBen
							ADCISIRStuInc
							ADCISIRStuTANF
							ADCISIRStuTxFormSigned
							ADCISIRStuTxFormType
							ADCISIRStuTxReturnFiled
							ADCISIRStuTotWrkstA
							ADCISIRStuTotWrkstB
							ADCISIRStuTotWrkstC
							ADCISIRStuTuitPdAmt
							ADCISIRStuTuitPdNbr
							ADCISIRStuNtxPensions
							ADCISIRStuUSTxPd
							ADCISIRStuVetAmt
							ADCISIRStuVetMo
							ADCISIRStuVetNonEdBen
							ADCISIRStuWIC
							ADCISIRStuSecEFC
							ADCISIRStuSelSvcReg
							ADCISIRStuSndDemoChgs
							ADCISIRStuSignFlag
							ADCISIRStuSnt
							ADCISIRStuSpoDOB
							ADCISIRStuSpoFName
							ADCISIRStuSpoInc
							ADCISIRStuSpoLName
							ADCISIRStuSpoSSN
							ADCISIRStuID
							ADCISIRStuSuppAze
							ADCISIRStuSuppDependency
							ADCISIRStuSuppID
							ADCISIRStuSuppPriEFC
							ADCISIRStuSuppSecEFC
							ADCISIRStuSuppSnt
							ADCISIRStuTeachElig
);
INFILE "&Path00&Infile05"  LINESIZE=650;
INPUT @1 ADCISIRID $10. @;
	SELECT;
	WHEN (ADCISIRID NE 'ISIR.FAFSA') DO;
		INPUT @1	ADCISIRID						$10.
				@22		ADCISIRStuNoColl			3.
				@30		ADCISIRStuNoExempt			3.
				@40		ADCISIRStuNoFamily			3.
				@52		ADCISIRStuOtrNonRptMoney	8.
				@78		ADCISIRStuOtrNtxInc			8.
				@102	ADCISIRStuPensionPmts		8.
				@123	ADCISIRStuSSIBen			$2.
				@130	ADCISIRStuInc				7.
				@137	ADCISIRStuTANF				$2.
				@145	ADCISIRStuTxFormSigned		$2.
				@167	ADCISIRStuTxFormType		$2.
				@187	ADCISIRStuTxReturnFiled		$2.
				@207	ADCISIRStuTotWrkstA			8.
				@226	ADCISIRStuTotWrkstB			8.
				@240	ADCISIRStuTotWrkstC			8.
				@253	ADCISIRStuTuitPdAmt			7.
				@260	ADCISIRStuTuitPdNbr			7.
				@267	ADCISIRStuNtxPensions		8.
				@290	ADCISIRStuUSTxPd			8.
				@300	ADCISIRStuVetAmt			8.
				@308	ADCISIRStuVetMo				$3.
				@315	ADCISIRStuVetNonEdBen		8.
				@336	ADCISIRStuWIC				$2.
				@343	ADCISIRStuSecEFC			8.
				@351	ADCISIRStuSelSvcReg			$2.
				@362	ADCISIRStuSndDemoChgs		$2.
				@371	ADCISIRStuSignFlag			$2.
				@389	ADCISIRStuSnt				$2.
				@392	ADCISIRStuSpoDOB			$11.
				@404	ADCISIRStuSpoFName			$12.
				@416	ADCISIRStuSpoInc			8.
				@424	ADCISIRStuSpoLName			$16.
				@440	ADCISIRStuSpoSSN			$10.
				@451	ADCISIRStuID				$10.
				@461	ADCISIRStuSuppAze			$2.
				@464	ADCISIRStuSuppDependency	$2.
				@467	ADCISIRStuSuppID			$10.
				@493	ADCISIRStuSuppPriEFC		$7.
				@500	ADCISIRStuSuppSecEFC		$7.
				@507	ADCISIRStuSuppSnt			$2.
				@510	ADCISIRStuTeachElig			$2.
;	
		OUTPUT ISIR05Downloada;
	END;
	OTHERWISE DO;
	PUT 'Error in record ' _n_ 'as follows:' _INFILE_;
		DELETE;
	END;
END;
RUN;

DATA ISIR05Downloadb;
RETAIN ADCPersonID;
SET ISIR05Downloada;
ADCPersonID=ADCISIRStuID;
PROC SORT DATA=ISIR05Downloadb; BY ADCISIRID;
*PROC PRINT DATA=ISIR05Downloadb;
RUN;

* END - SECTION ISIR05Downloadab - Imports ISIR Flat File Numer 5 Of 6 *;


* BEGIN - SECTION ISIR06Downloadab - Imports ISIR Flat File Numer 6 Of 6 *;

DATA ISIR06Downloada (KEEP=
							ADCISIRID
							ADCISIRStuTitleIV01
							ADCISIRStuTitleIV02
							ADCISIRStuTitleIV03
							ADCISIRStuTitleIV04
							ADCISIRStuTitleIV05
							ADCISIRStuTitleIV06
							ADCISIRStuTitleIV07
							ADCISIRStuTitleIV08
							ADCISIRStuTitleIV09
							ADCISIRStuTitleIV10
							ADCISIRTransNbr
							ADCISIRStuTransProcDt
							ADCISIRStuTransRcptDt
							ADCISIRStuVetBenType
							ADCISIRStuVeteran
							ADCISIRStuIFAFYr
							ADCISIRStuYrInCollege
							ADCISIRStuFAFSAAddDt
							ADCISIRStuFAFSAAddOpr
							ADCISIRStuFAFSAChgDt
							ADCISIRStuFAFSAChgOpr
);
INFILE "&Path00&Infile06"  LINESIZE=350;
INPUT @1 ADCISIRID $10. @;
	SELECT;
	WHEN (ADCISIRID NE 'ISIR.FAFSA') DO;
		INPUT 	@1		ADCISIRID				$10.
				@22		ADCISIRStuTitleIV01		$7.
				@31		ADCISIRStuTitleIV02		$7.
				@41		ADCISIRStuTitleIV03		$7.
				@51		ADCISIRStuTitleIV04		$7.
				@61		ADCISIRStuTitleIV05		$7.
				@71		ADCISIRStuTitleIV06		$7.
				@81		ADCISIRStuTitleIV07		$7.
				@90		ADCISIRStuTitleIV08		$7.
				@99		ADCISIRStuTitleIV09		$7.
				@108	ADCISIRStuTitleIV10		$7.
				@118	ADCISIRTransNbr			$3.
				@122	ADCISIRStuTransProcDt	$10.
				@142	ADCISIRStuTransRcptDt	$11.
				@159	ADCISIRStuVetBenType	$4.
				@179	ADCISIRStuVeteran		$2.
				@186	ADCISIRStuIFAFYr		$3.
				@190	ADCISIRStuYrInCollege	$2.
				@210	ADCISIRStuFAFSAAddDt	$8.
				@218	ADCISIRStuFAFSAAddOpr	$10.
				@238	ADCISIRStuFAFSAChgDt	$8.
				@248	ADCISIRStuFAFSAChgOpr	$10.
;	
		OUTPUT ISIR06Downloada;
	END;
	OTHERWISE DO;
	PUT 'Error in record ' _n_ 'as follows:' _INFILE_;
		DELETE;
	END;
END;
RUN;

DATA ISIR06Downloadb;
SET ISIR06Downloada;
PROC SORT DATA=ISIR06Downloadb; BY ADCISIRID;
*PROC PRINT DATA=ISIR06Downloadb;
RUN;

* END - SECTION ISIR06Downloadab - Imports ISIR Flat File Numer 6 Of 6 *;


DATA Merge010203040506;
	MERGE 
			ISIR01Downloadb
			ISIR02Downloadb 
			ISIR03Downloadb 
			ISIR04Downloadb 
			ISIR05Downloadb
			ISIR06Downloadb
; 
	BY ADCISIRID;
IF ADCISIRID EQ ' ' THEN DELETE;
RUN;


DATA &lb01 .&ds01&rp01&yt01;
RETAIN
							InstFiscalYear
							ADCPersonID
							ADCISIRID
							ADCISIRStuID
							ADCISIRStuDOB
							ADCISIRStuLName
							ADCISIRStuFName
							ADCISIRStuFileName
							ADCISIRStuCurrentSSN
							ADCISIRTransNbr
							ADCISIRStuActiveDuty
							ADCISIRStuAidInterests
							ADCISIRStuAlienRegNbr
							ADCISIRStuAZE
							ADCISIRStuBornB4Date
							ADCISIRStuCitizenship
							ADCISIRStuCorrAZE
							ADCISIRStuCorrDependency
							ADCISIRStuCorrPriEFC
							ADCISIRStuCorrRejCodes
							ADCISIRStuCorrSecEFC
							ADCISIRStuCorrSentDate
							ADCISIRStuCorrSnt
							ADCISIRStuCorrStatus
							ADCISIRStuCorrFromID
							ADCISIRStuCorrID
							ADCISIRStuCPSOverAssm01
							ADCISIRStuCPSOverAssm02
							ADCISIRStuCPSOverAssm03
							ADCISIRStuCPSOverAssm04
							ADCISIRStuCPSOverAssm05
							ADCISIRStuCPSOverAssm06
							ADCISIRStuCPSOverDepend
							ADCISIRStuCPSOverRejPrst
							ADCISIRStuCPSOverRej12
							ADCISIRStuCPSOverRej20
							ADCISIRStuCPSOverRej03
							ADCISIRStuCPSOverRej04
							ADCISIRStuCPSOverRejA
							ADCISIRStuCPSOverRejB
							ADCISIRStuCPSOverRejC
							ADCISIRStuCPSOverRejD
							ADCISIRStuCPSOverRejE
							ADCISIRStuCPSOverRejF
							ADCISIRStuCPSOverRejG
							ADCISIRStuCPSOverRejJ
							ADCISIRStuCPSOverRejK
							ADCISIRStuCPSOverRejN
							ADCISIRStuCPSOverRejP
							ADCISIRStuCPSOverRejR
							ADCISIRStuCPSOverRejS
							ADCISIRStuCPSOverRejT
							ADCISIRStuCPSOverRejW
							ADCISIRStuDateSign
							ADCISIRStuDegOrCert
							ADCISIRStuDegreeBy
							ADCISIRStuDependChildren
							ADCISIRStuDependOverride
							ADCISIRStuDependency
							ADCISIRStuDrugConvict
							ADCISIRStuEmancipatedMinor
							ADCISIRStuEnrlStatus
							ADCISIRStuFaaAdj
							ADCISIRFtrDOB
							ADCISIRFtrFName
							ADCISIRFtrGradeLvl
							ADCISIRFtrLName
							ADCISIRFtrSSN
							ADCISIRStuGradeProf
							ADCISIRStuHasGrad
							ADCISIRStuHomelessAtRisk
							ADCISIRStuHomelessByHUD
							ADCISIRStuHomlessBySchool
							ADCISIRStuHousing01
							ADCISIRStuHousing02
							ADCISIRStuHousing03
							ADCISIRStuHousing04
							ADCISIRStuHousing05
							ADCISIRStuHousing06
							ADCISIRStuHousing07
							ADCISIRStuHousing08
							ADCISIRStuHousing09
							ADCISIRStuHousing10
							ADCISIRStuHSGradType08
							ADCISIRStuImportYr
							ADCISIRStuInterestCWS
							ADCISIRStuInterestLoan
							ADCISIRStuISIRType
							ADCISIRStuJobID
							ADCISIRStuLegalGuardianship
							ADCISIRStuMale
							ADCISIRStuMaleFemale
							ADCISIRStuMarried
							ADCISIRMtrDOB
							ADCISIRMtrFName
							ADCISIRMtrGradeLvl
							ADCISIRMtrLName
							ADCISIRMtrSSN
							ADCISIRStuNSLDSID
							ADCISIRStuOrphanWard
							ADCISIRStuOtrDepend
							ADCISIRParAGI
							ADCISIRParAllowanceAdj
							ADCISIRParBusNetWrth
							ADCISIRParCash
							ADCISIRParChildSuppRecv
							ADCISIRParChildSuppPd
							ADCISIRParCoOpEarnings
							ADCISIRParCombatPay
							ADCISIRParDependCareExp
							ADCISIRParDislocatedWorker
							ADCISIRParExpFaInc
							ADCISIRParExpMoInc
							ADCISIRParExpNtxInc
							ADCISIRParExpOtrTaxInc
							ADCISIRParExpTaxPd
							ADCISIRParEduCredit
							ADCISIRParElig1040A
							ADCISIRParFaWrkInc
							ADCISIRParFoodStamps
							ADCISIRParGrantScholAid
							ADCISIRParHomeWrthAdj
							ADCISIRParHomeDebt
							ADCISIRParHomeValue
							ADCISIRParIncAdj
							ADCISIRParInterestInc
							ADCISIRParInvNetWrth
							ADCISIRParIRADistrib
							ADCISIRParIRAPmts
							ADCISIRParLegalRes
							ADCISIRParLegalResB4
							ADCISIRParLegalResMo
							ADCISIRParLegalResYr
							ADCISIRParLunchBenefits
							ADCISIRParMarMo
							ADCISIRParMarState
							ADCISIRParMarYr
							ADCISIRParMedDenExp
							ADCISIRParMilClergyAllowed
							ADCISIRParMoWrkInc
							ADCISIRParNbrInFamily
							ADCISIRParNeedBasedEmp
							ADCISIRParNbrInColl
							ADCISIRParNbrExemptions
							ADCISIRParOtrNtxInc
							ADCISIRParPensionPmts
							ADCISIRParSSIBenefits
							ADCISIRParTANF
							ADCISIRParTaxFrmSigned
							ADCISIRParTaxFrmType
							ADCISIRParTaxReturnFiled
							ADCISIRParTotWrkshtA
							ADCISIRParTotWrkshtB
							ADCISIRParTotWrkshtC
							ADCISIRParTuitPdAmt
							ADCISIRParTuitPdNbr
							ADCISIRParNtxPensions
							ADCISIRParUSTaxPd
							ADCISIRParVetNonEdBenefits
							ADCISIRParWIC
							ADCISIRStuTxPrepEIN
							ADCISIRStuTxPrepSigned
							ADCISIRStuTxPrepSSN
							ADCISIRStuPrevActTrans
							ADCISIRStuPriEFC
							ADCISIRStuReadyToSend
							ADCISIRStuVetBenRecvd
							ADCISIRStuReceiptDt
							ADCISIRStuRejectCodes
							ADCISIRStuAGI
							ADCISIRStuAllowanceAdj
							ADCISIRStuBusNetWrth
							ADCISIRStuCash
							ADCISIRStuChildSuppRecv
							ADCISIRStuChildSuppPd
							ADCISIRStuCoOpEarnings
							ADCISIRStuCombatPay
							ADCISIRStuDepCareExp
							ADCISIRStuDislocatedWorker
							ADCISIRStuNtxInc
							ADCISIRStuSpoExpInc
							ADCISIRStuExpInc
							ADCISIRStuExpOtrTaxInc
							ADCISIRStuExpTaxPd
							ADCISIRStuEduCredit
							ADCISIRStuEligible1040A
							ADCISIRStuFoodStamps
							ADCISIRStuGrantScholAid
							ADCISIRStuHomeAdj
							ADCISIRStuHomeD
							ADCISIRStuHomeV
							ADCISIRStuIncomeAdj
							ADCISIRStuInterestIncome
							ADCISIRStuInvestNetWorth
							ADCISIRStuIRADistrib
							ADCISIRStuIRAPayments
							ADCISIRStuLegalRes
							ADCISIRStuLegalResB4
							ADCISIRStuLegalResMo
							ADCISIRStuLegalResYr
							ADCISIRStuLunchBen
							ADCISIRStuMaritalMo
							ADCISIRStuMaritalSt
							ADCISIRStuMaritalYr
							ADCISIRStuMedDen
							ADCISIRStuMilClergyAllow
							ADCISIRStuNeedBasedEmp
							ADCISIRStuNoColl
							ADCISIRStuNoExempt
							ADCISIRStuNoFamily
							ADCISIRStuOtrNonRptMoney
							ADCISIRStuOtrNtxInc
							ADCISIRStuPensionPmts
							ADCISIRStuSSIBen
							ADCISIRStuInc
							ADCISIRStuTANF
							ADCISIRStuTxFormSigned
							ADCISIRStuTxFormType
							ADCISIRStuTxReturnFiled
							ADCISIRStuTotWrkstA
							ADCISIRStuTotWrkstB
							ADCISIRStuTotWrkstC
							ADCISIRStuTuitPdAmt
							ADCISIRStuTuitPdNbr
							ADCISIRStuNtxPensions
							ADCISIRStuUSTxPd
							ADCISIRStuVetAmt
							ADCISIRStuVetMo
							ADCISIRStuVetNonEdBen
							ADCISIRStuWIC
							ADCISIRStuSecEFC
							ADCISIRStuSelSvcReg
							ADCISIRStuSndDemoChgs
							ADCISIRStuSignFlag
							ADCISIRStuSnt
							ADCISIRStuSpoDOB
							ADCISIRStuSpoFName
							ADCISIRStuSpoInc
							ADCISIRStuSpoLName
							ADCISIRStuSpoSSN
							ADCISIRStuSuppAze
							ADCISIRStuSuppDependency
							ADCISIRStuSuppID
							ADCISIRStuSuppPriEFC
							ADCISIRStuSuppSecEFC
							ADCISIRStuSuppSnt
							ADCISIRStuTeachElig
							ADCISIRStuTitleIV01
							ADCISIRStuTitleIV02
							ADCISIRStuTitleIV03
							ADCISIRStuTitleIV04
							ADCISIRStuTitleIV05
							ADCISIRStuTitleIV06
							ADCISIRStuTitleIV07
							ADCISIRStuTitleIV08
							ADCISIRStuTitleIV09
							ADCISIRStuTitleIV10
							ADCISIRStuTransProcDt
							ADCISIRStuTransRcptDt
							ADCISIRStuVetBenType
							ADCISIRStuVeteran
							ADCISIRStuIFAFYr
							ADCISIRStuYrInCollege
							ADCISIRStuFAFSAAddDt
							ADCISIRStuFAFSAAddOpr
							ADCISIRStuFAFSAChgDt
							ADCISIRStuFAFSAChgOpr
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
		InstFiscalYear $10.
		InstIPEDSUnitID $10.
		InstOPEID $10.
;
SET Merge010203040506;
InstCountry="&IC01";
InstState="&IS01";
InstID="&II01";
InstShortName="&IN01";
InstIPEDSUnitID="&IU01";
InstOPEID="&OI01";
InstFiscalYear="&YT01";
RUN;


