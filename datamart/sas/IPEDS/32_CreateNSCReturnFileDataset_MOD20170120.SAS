*************************************************************************************
* CREATED BY:   Paul G. Earls                                                       *
* DATE CREATED: 02-05-2016                                                          *
* MODIFIED1:                                                                        *
* REQUESTOR:    Institutional Research                                              *
* PURPOSE:      Create SAS Dataset From NSC Return File                             *
*               For Any Term                                                        *
*************************************************************************************;
OPTIONS PS=500 LS=256 NONUMBER NOCENTER;

%LET PathRoot=H:\Planning and Research FTP\CPCCSASDatasets\A_XNC_Datatel;   /* 6 Digit Datasets */

LIBNAME NSC6 "&PathRoot\Downloads\SASDatasets\30_NSC";

%LET Pth01=&PathRoot\Downloads\;											/* NO NEED TO UPDATE - PATH TO CLEARINGHOUSE FILES */

%LET CSV01=002915st_293270_DETLRPT_PA_10062017130021_nsctermfile_002915_201703_fall_pa_grs_kds.csv;	/* UPDATE - NAME OF CLEARINGHOUSE RETURN FILE */

%LET lb01=NSC6;			/* NO NEED TO UPDATE - PATH TO CLEARINGHOUSE DATASETS */
%LET ds01=NSC_;			/* NO NEED TO UPDATE - FIRST NAME OF  CLEARINGHOUSE DATASETS */
%LET rp01=_PA;			/* UPDATE - TYPE OF RETURN FILE - SEE BELOW FOR NAME OF CLEARINGHOUSE DATASETS */
												/* SE (Subsequent Enrollment for Previously Enrolled Students/Transfers Out)		*/
												/* DA (Subsequent Enrollment for Prospective Student/Denied/Declined Admissions)	*/
												/* PA (Prior Attendance for Pending Admissions)										*/
												/* SB (Sibling/Parent Enrollment)													*/
												/* CO (Cohort Query)																*/

%LET yt01=201703;		/* UPDATE - TERM NAME OF NSC DATASET */
%LET yt01b=Fall 2017;	/* UPDATE - TERM LABEL OF NSC DATASET */


*----------------------------------------------*;
* NO FURTHER CHANGES NECESSARY BEYOND THIS POINT;
*----------------------------------------------*;


/* BEGIN - BRING IN CLEARINGHOUSE FILE */

DATA WORK.NSC01;
      %LET _EFIERR_ = 0; /* set the ERROR detection macro variable */
      INFILE "&Pth01&&CSV01" DELIMITER = ',' MISSOVER DSD LRECL=32767 FIRSTOBS=2;
			INPUT
          			NSC_Your_Unique_Identifier		:$1.
          			NSC_First_Name					:$14.
          			NSC_Middle_Initial				:$1.
          			NSC_Last_Name					:$17.
          			NSC_Name_Suffix					:$10.
          			NSC_Requester_Return_Field		:$10.
          			NSC_Record_Found_Y_N			:$1.
          			NSC_Search_Date					:$10.
          			NSC_College_Code_Branch			:$9.
          			NSC_College_Name				:$50.
          			NSC_College_State				:$2.
          			NSC__2_Year_4_Year				:$3.
          			NSC_Public_Private				:$7.
          			NSC_Enrollment_Begin			:$10.
          			NSC_Enrollment_End				:$10.
          			NSC_Enrollment_Status			:$1.
          			NSC_Class_Level					:$1.
          			NSC_Enrollment_Major_1			:$1.
          			NSC_Enrollment_CIP_1			:$1.
          			NSC_Enrollment_Major_2			:$1.
          			NSC_Enrollment_CIP_2			:$1.
          			NSC_Graduated					:$1.
          			NSC_Graduation_Date				:$10.
          			NSC_Degree_Title				:$30.
          			NSC_Degree_Major_1				:$30.
          			NSC_Degree_CIP_1				:$10.
          			NSC_Degree_Major_2				:$1.
          			NSC_Degree_CIP_2				:$1.
          			NSC_Degree_Major_3				:$1.
          			NSC_Degree_CIP_3				:$1.
          			NSC_Degree_Major_4				:$1.
          			NSC_Degree_CIP_4				:$1.
          			NSC_College_Sequence			:$3.
					;
				FORMAT
          			NSC_Your_Unique_Identifier		$1.
          			NSC_First_Name					$14.
          			NSC_Middle_Initial				$1.
          			NSC_Last_Name					$17.
          			NSC_Name_Suffix					$10.
          			NSC_Requester_Return_Field		$10.
          			NSC_Record_Found_Y_N			$1.
          			NSC_Search_Date					$10.
          			NSC_College_Code_Branch			$9.
          			NSC_College_Name				$50.
          			NSC_College_State				$2.
          			NSC__2_Year_4_Year				$3.
          			NSC_Public_Private				$7.
          			NSC_Enrollment_Begin			$10.
          			NSC_Enrollment_End				$10.
          			NSC_Enrollment_Status			$1.
          			NSC_Class_Level					$1.
          			NSC_Enrollment_Major_1			$1.
          			NSC_Enrollment_CIP_1			$1.
          			NSC_Enrollment_Major_2			$1.
          			NSC_Enrollment_CIP_2			$1.
          			NSC_Graduated					$1.
          			NSC_Graduation_Date				$10.
          			NSC_Degree_Title				$30.
          			NSC_Degree_Major_1				$30.
          			NSC_Degree_CIP_1				$10.
          			NSC_Degree_Major_2				$1.
          			NSC_Degree_CIP_2				$1.
          			NSC_Degree_Major_3				$1.
          			NSC_Degree_CIP_3				$1.
          			NSC_Degree_Major_4				$1.
          			NSC_Degree_CIP_4				$1.
          			NSC_College_Sequence			$3.
      ;
      IF _ERROR_ THEN CALL symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
RUN;

/* END - BRING IN CLEARINGHOUSE FILE */


DATA NSC02;
RETAIN
		ADCPersonID
;
FORMAT
		ADCPersonID $10.
;
SET NSC01;
ADCPersonID=(COMPRESS(NSC_Requester_Return_Field,'_'));
PROC SORT DATA=NSC02; BY ADCPersonID;
RUN;

DATA &lb01 .&ds01&yt01&rp01;
SET
	NSC02;
;
RUN;

/*
ODS LISTING CLOSE;
ODS HTML CLOSE;
ODS MARKUP TAGSET=CHTML BODY="&PathRoot\A_XNC_Datatel\XX_SAS_TrashBin\Report01PGE.html";



ODS MARKUP TAGSET=CHTML CLOSE;
*/
