*************************************************************************************
* CREATED BY:   Paul G. Earls                                                       *
* DATE CREATED: 02-09-2007                                                          *
* MODIFIED1:    01-21-2011 For Spring 2010                                          *
* REQUESTOR:    Planning and Research                                               *
* PURPOSE:      Curriculum ICR Dataset Creation                                     *
*               For All Terms                                                       *
*  NOTE: ICR NAME SHOULD BE ICR_CUR_YYYYTT_CCC WHERE YYYY is YEAR TT is 2 digit term*
*                           and CCC is 3 digit school code                          * 
*  NOTE:  I.T. PUTS THE ICR FILES ON THE H DRIVE IN THE ICR FOLDER - MAKE A COPY OF *
*  THESE IN THE DOWNLOADS FOLDER                                                    *
*************************************************************************************;
OPTIONS PS=5000 LS=256 NONUMBER NOCENTER;

%LET PathRoot=H:\Planning and Research FTP\CPCCSASDatasets\A_XNC_Datatel;

LIBNAME pge6 "&PathRoot\Downloads\Archive\ICR\201702\";		* CHANGE THIS TO MATCH PATH TO ICR FILE;
LIBNAME pge7 "H:\Planning and Research FTP\ICR\Datatel\"; 	* CHANGE THIS PATH TO LOCATION FOR EXCEL FILE OUTPUT;
*LIBNAME pge8 'H:\Planning and Research FTP\CPCCSASDatasets\DatatelColleague\ICR\';
LIBNAME pge9 "&PathRoot\Downloads\SASDatasets\20_ICR\";

%LET lb01=pge6;
%LET pt01=&PathRoot\Downloads\Archive\ICR\201702\;			* CHANGE THIS TO MATCH PATH TO ICR FILE;
%LET ds01=ICR_;
%LET rp01=CUR_;
%LET yt01=201702; 		* CHANGE YEARTERM VARIABLE;
%LET in01=_818;   		* CHANGE SCHOOL CODE, CPCC=818;

%LET lb02=pge6;
%LET ds02=C_;
%LET rp02=FTE;
%LET yt02=172;			* CHANGE TERM VARIABLE;

*%LET lb02b=pge8;
*%LET ds02b=C_;
*%LET rp02b=FTE;
*%LET yt02b=143; 		* CHANGE TERM VARIABLE;

%LET lb03=pge7;
%LET pt03=H:\Planning and Research FTP\ICR\Datatel\;		* CHANGE THIS PATH TO LOCATION FOR EXCEL FILE OUTPUT;
%LET ds03=C_;
%LET rp03=FTE_;
%LET yt03=SUM17; 		* CHANGE TERM VARIABLE;

* NO FURTHER CHANGES NEEDED BELOW THIS COMMENT STATMENT;

%LET pf01=ZZZ;
%LET pf02=SSS;

DATA classrec (KEEP=
			ADCInst
			ADCRptTerm
			ADCPrefix
			ADCNumber
			ADCSection
			ADCSpFundCode
			ADCImmureCodes
			ADCOn_Off
			ADCCounty
			ADCProg
			ADCSchedHrs
			ADCStuCt
			ADCTotHrs
			ADCHrType
			ADCAgency
			ADCCensus
			ADCSSup
			ADCType
			ADCFaculty
			ADCMethod
			ADCCampus
			ADCHSStuCode
)
	zzz__rec (KEEP=
			ADCInst
			ADCRptTerm
			ADCPrefix
			ADCNumber
			ADCProg
			ADCTotHrs
			ADCSSup
			ADCFaculty
			ADCCampus
			ADCHSStuCode
)
	sss__rec (KEEP=
			ADCInst
			ADCRptTerm
			ADCPrefix
			ADCNumber
			ADCProg
			ADCTotHrs
			ADCFaculty
			ADCHSStuCode
);
FORMAT ADCTotHrs_TEMP2 $6.
		ADCTotHrs 8.;
INFILE "&pt01&ds01&rp01&yt01&in01" TRUNCOVER;
INPUT @10 ADCPrefix $3. @4 ADCRptTerm $6. @;
	SELECT;
	WHEN (ADCRptTerm EQ "&yt01" 
			AND (ADCPrefix NE "&pf01" AND ADCPrefix NE "&pf02")) DO;
		INPUT 
			@1		ADCInst			$3.
			@4		ADCRptTerm		$6.
			@10		ADCPrefix		$3.
			@13		ADCNumber		$5.
			@18		ADCSection		$6.
			@24		ADCSpFundCode	$1.
			@25		ADCImmureCodes	$1.
			@26		ADCOn_Off		$1.
			@27		ADCCounty		$3.
			@30		ADCProg			$6.
			@36		ADCSchedHrs		 4.1
			@40 	ADCStuCt		 3.
			@43		ADCTotHrs		 5.
			@48		ADCHrType		$2.
			@50		ADCAgency		$1.
			@51		ADCCensus		$3.
			@54		ADCSSup			$1.
			@55		ADCType			$3.
			@58		ADCFaculty		$9.
			@67		ADCMethod		$2.
			@69		ADCCampus		$4.
			@73		ADCHSStuCode	$4.
;
		OUTPUT classrec;
	END;
	WHEN (ADCRptTerm EQ "&yt01" AND (ADCPrefix EQ "&pf01")) DO;
		INPUT 
			@1		ADCInst			$3.
			@4		ADCRptTerm		$6.
			@10		ADCPrefix		$3.
			@13		ADCNumber		$5.
			@30		ADCProg			$6.
			@40		ADCTotHrs_TEMP1	$5.
			@51		ADCSSup			$1.
			@55		ADCFaculty		$9.
			@66		ADCCampus		$4.
			@70		ADCHSStuCode	$4.
;
			IF (SUBSTR(ADCSchedHrsAZ,1,1)) EQ 'M'
				OR (SUBSTR(ADCSchedHrsAZ,1,1)) EQ ' '
				THEN ADCSchedHrsNum=0;
				ELSE ADCSchedHrsNum=INPUT(ADCSchedHrsAZ,4.);
			IF (SUBSTR(ADCTotHrs_TEMP1,5,1)) EQ 'J'
				THEN ADCTotHrs_TEMP2='-'||(SUBSTR(ADCTotHrs_TEMP1,1,4))||'1';
			ELSE IF (SUBSTR(ADCTotHrs_TEMP1,5,1)) EQ 'K'
				THEN ADCTotHrs_TEMP2='-'||(SUBSTR(ADCTotHrs_TEMP1,1,4))||'2';
			ELSE IF (SUBSTR(ADCTotHrs_TEMP1,5,1)) EQ 'L'
				THEN ADCTotHrs_TEMP2='-'||(SUBSTR(ADCTotHrs_TEMP1,1,4))||'3';
			ELSE IF (SUBSTR(ADCTotHrs_TEMP1,5,1)) EQ 'M'
				THEN ADCTotHrs_TEMP2='-'||(SUBSTR(ADCTotHrs_TEMP1,1,4))||'4';
			ELSE IF (SUBSTR(ADCTotHrs_TEMP1,5,1)) EQ 'N'
				THEN ADCTotHrs_TEMP2='-'||(SUBSTR(ADCTotHrs_TEMP1,1,4))||'5';
			ELSE IF (SUBSTR(ADCTotHrs_TEMP1,5,1)) EQ 'O'
				THEN ADCTotHrs_TEMP2='-'||(SUBSTR(ADCTotHrs_TEMP1,1,4))||'6';
			ELSE IF (SUBSTR(ADCTotHrs_TEMP1,5,1)) EQ 'P'
				THEN ADCTotHrs_TEMP2='-'||(SUBSTR(ADCTotHrs_TEMP1,1,4))||'7';
			ELSE IF (SUBSTR(ADCTotHrs_TEMP1,5,1)) EQ 'Q'
				THEN ADCTotHrs_TEMP2='-'||(SUBSTR(ADCTotHrs_TEMP1,1,4))||'8';
			ELSE IF (SUBSTR(ADCTotHrs_TEMP1,5,1)) EQ 'R'
				THEN ADCTotHrs_TEMP2='-'||(SUBSTR(ADCTotHrs_TEMP1,1,4))||'9';
			ELSE IF (SUBSTR(ADCTotHrs_TEMP1,5,1)) EQ '}'
				THEN ADCTotHrs_TEMP2='-'||(SUBSTR(ADCTotHrs_TEMP1,1,4))||'0';
			ELSE ADCTotHrs_TEMP2='0'||(SUBSTR(ADCTotHrs_TEMP1,1,5));
			ADCTotHrs=INPUT(ADCTotHrs_TEMP2,6.);
DROP 	ADCTotHrs_TEMP1
		ADCTotHrs_TEMP2;
		OUTPUT zzz__rec;
	END;
***;	WHEN (ADCRptTerm EQ "&yt01" AND (ADCPrefix EQ "&pf02")) DO;
		INPUT 
			@1		ADCInst			$3.
			@4		ADCRptTerm		$6.
			@10		ADCPrefix		$3.
			@13		ADCNumber		$5.
			@30		ADCProg			$6.
			@40		ADCTotHrs		 5.
			@55		ADCFaculty		$9.
			@64		ADCHSStuCode	$4.
;
			IF (SUBSTR(ADCSchedHrsAZ,1,1)) EQ 'M'
				OR (SUBSTR(ADCSchedHrsAZ,1,1)) EQ ' '
				THEN ADCSchedHrsNum=0;
				ELSE ADCSchedHrsNum=INPUT(ADCSchedHrsAZ,4.);
		OUTPUT sss__rec;
	END;
	OTHERWISE DO;
	PUT 'Error in record ' _n_ 'as follows:' _INFILE_;
		DELETE;
	END;
END;
RUN;

DATA finalcuricr;
RETAIN
		ADCInst
		ADCRptTerm
		ADCPrefix
		ADCNumber
		ADCSection
		ADCStuCt
		ADCTotHrs
		ADCProg
		ADCMethod
		ADCCampus
		ADCHSStuCode
		ADCSpFundCode
		ADCImmureCodes
		ADCOn_Off
		ADCCounty
		ADCSchedHrs
		ADCHrType
		ADCAgency
		ADCCensus
		ADCSSup
		ADCType
		ADCFaculty
;
SET classrec 
	sss__rec
	zzz__rec;
TITLE1 "Curriculum ICR Dataset";
TITLE2 "For &yt01";
PROC PRINT DATA=finalcuricr;
RUN;


DATA pge9 .&ds02&rp02&yt02;
SET finalcuricr;
RUN;


*DATA &lb02b .&ds02b&rp02b&yt02b;
*SET finalcuricr;
*RUN;

PROC EXPORT DATA= WORK.FINALCURICR 
            OUTFILE= "&pt03&ds03&rp03&yt03 .csv" 
            DBMS=CSV REPLACE;
RUN;
