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
* PURPOSE:      Create Class SAS Datasets                                           *
*               For Any Term/Date                                                   *
*************************************************************************************;
OPTIONS PS=5000 LS=256 NONUMBER NOCENTER;

%LET PathRoot=W:\InstitutionalResearch\A_XNC_Datatel;

LIBNAME Dld6 "&PathRoot\Downloads";
LIBNAME Cls6 "&PathRoot\Downloads\SASDatasets\01_Class";

%LET lb01=Dld6;
/*%LET pt01=G:\A_XNC_Datatel\Downloads\;*/
%LET pt01=&PathRoot\Downloads\;
%LET tx01=CL_01_XNC_SAS_COURSE_SEC_MEETING_DATA.txt;
%LET tx02=CL_02_XNC_SAS_COURSE_SECTIONS_DATA.txt;

%LET lb01=Cls6;
%LET ds01=CL_;
%LET rp01=_ET;		* CHANGE FOR EACH DATA POINT;
%LET yt01=201503;	* CHANGE FOR EACH TERM;

%LET sar01=01;
%LET ear01=40;
%LET sar02=001;
%LET ear02=150;

*------------------------------------------------*;
* NO FURTHER CHANGES NECESSARY BEYOND THIS POINT *;
*------------------------------------------------*;

%LET IC01=US;		* Country of Institution;
%LET IS01=NC;		* State of Institution;
%LET II01=882;		* state institution ID;
%LET IN01=SWCC;	* Institution Short name;
%LET IU01=199731;	* IPEDS Unit ID;
%LET OI01=008466;	* OPE ID / FICE Code;


* BEGIN - SECTION 1a - IMPORTS THE FIRST OF TWO DATATEL/COLLEAGUE FIXED LENGTH FILES *;

DATA class01 (KEEP=
			ADCClsTerm
			ADCClsPrefix
			ADCClsNumber
			ADCClsSection
			ADCClsSecMeetAddOn
			ADCClsSecMeetAddBy
			ADCClsSecMeetChgOn
			ADCClsSecMeetChgBy
			ADCClsStartDate
			ADCClsEndDate
			ADCClsMeetDays
			ADCClsStartTime
			ADCClsEndTime
			ADCClsCampus
			ADCClsBldg
			ADCClsRoom
			ADCClsIType
			ADCClsID
/*			ADCClsFacultyID*/
);
INFILE "&pt01&tx01" LINESIZE=450 TRUNCOVER;
INPUT @1 ADCClsTerm $8. @;
	SELECT;
	WHEN (ADCClsTerm NE 'Term') DO;
		INPUT @1	ADCClsTerm				$8.
			@36		ADCClsPrefix			$4.
			@76		ADCClsNumber			$10.
			@89		ADCClsSection			$6.
			@96		ADCClsSecMeetAddOn		$8.
			@104	ADCClsSecMeetAddBy		$8.
			@112	ADCClsSecMeetChgOn		$8.
			@122	ADCClsSecMeetChgBy		$8.
			@132	ADCClsStartDate			$8.
			@142	ADCClsEndDate			$8.
			@150	ADCClsMeetDays			$8.
			@165	ADCClsStartTime			$8.
			@175	ADCClsEndTime			$8.
			@183	ADCClsCampus			$8.
			@218	ADCClsBldg				$8.
			@253	ADCClsRoom				$8.
			@288	ADCClsIType				$8.
			@323	ADCClsID				$7.
/*			@323	ADCClsFacultyID			$8.*/
;
		OUTPUT class01;
	END;
	OTHERWISE DO;
	PUT 'Error in record ' _n_ 'as follows:' _INFILE_;
		DELETE;
	END;
END;
RUN;

* END - SECTION 1a - IMPORTS THE FIRST OF TWO DATATEL/COLLEAGUE FIXED LENGTH FILES *;


* BEGIN - SECTION 1b - REPEATS NECESSARY VARIABLE VALUES FOR SECTION 1a *;

DATA repeatids1a;
SET class01;
	RETAIN Previousyrtm;
	DROP   Previousyrtm;
	RETAIN Previoussub;
	DROP   Previoussub;
	RETAIN Previousnum;
	DROP   Previousnum;
	RETAIN Previoussec;
	DROP   Previoussec;
	RETAIN Previousstart;
	DROP   Previousstart;
	RETAIN Previousend;
	DROP   Previousend;
	RETAIN Previousloc;
	DROP   Previousloc;
	RETAIN Previousbldg;
	DROP   Previousbldg;
	RETAIN Previousroom;
	DROP   Previousroom;
	RETAIN Previoustype;
	DROP   Previoustype;
	RETAIN Previousaddon;
	DROP   Previousaddon;
	RETAIN Previousaddbby;
	DROP   Previousaddbby;
	RETAIN Previouschgon;
	DROP   Previouschgon;
	RETAIN Previouschgby;
	DROP   Previouschgby;
	RETAIN Previousstarton;
	DROP   Previousstarton;
	RETAIN Previousendon;
	DROP   Previousendon;
	RETAIN PreviousSecID;
	DROP   PreviousSecID;
  IF ADCClsTerm EQ ' ' 
     THEN ADCClsTerm=Previousyrtm;
     ELSE Previousyrtm=ADCClsTerm;
  IF ADCClsPrefix EQ ' ' 
     THEN ADCClsPrefix=Previoussub;
     ELSE Previoussub=ADCClsPrefix;
  IF ADCClsNumber EQ ' ' 
     THEN ADCClsNumber=Previousnum;
     ELSE Previousnum=ADCClsNumber;
  IF ADCClsSection EQ ' ' 
     THEN ADCClsSection=Previoussec;
     ELSE Previoussec=ADCClsSection;
  IF ADCClsStartTime EQ ' ' 
     THEN ADCClsStartTime=Previousstart;
     ELSE Previousstart=ADCClsStartTime;
  IF ADCClsEndTime EQ ' ' 
     THEN ADCClsEndTime=Previousend;
     ELSE Previousend=ADCClsEndTime;
  IF ADCClsCampus EQ ' ' 
     THEN ADCClsCampus=Previousloc;
     ELSE Previousloc=ADCClsCampus;
  IF ADCClsBldg EQ ' ' 
     THEN ADCClsBldg=Previousbldg;
     ELSE Previousbldg=ADCClsBldg;
  IF ADCClsRoom EQ ' ' 
     THEN ADCClsRoom=Previousroom;
     ELSE Previousroom=ADCClsRoom;
  IF ADCClsIType EQ ' ' 
     THEN ADCClsIType=Previoustype;
     ELSE Previoustype=ADCClsIType;
  IF ADCClsSecMeetAddOn EQ ' ' 
     THEN ADCClsSecMeetAddOn=Previousaddon;
     ELSE Previousaddon=ADCClsSecMeetAddOn;
  IF ADCClsSecMeetAddBy EQ ' ' 
     THEN ADCClsSecMeetAddBy=Previousaddbby;
     ELSE Previousaddbby=ADCClsSecMeetAddBy;
  IF ADCClsSecMeetChgOn EQ ' ' 
     THEN ADCClsSecMeetChgOn=Previouschgon;
     ELSE Previouschgon=ADCClsSecMeetChgOn;
  IF ADCClsSecMeetChgBy EQ ' ' 
     THEN ADCClsSecMeetChgBy=Previouschgby;
     ELSE Previouschgby=ADCClsSecMeetChgBy;
  IF ADCClsStartDate EQ ' ' 
     THEN ADCClsStartDate=Previousstarton;
     ELSE Previousstarton=ADCClsStartDate;
  IF ADCClsEndDate EQ ' ' 
     THEN ADCClsEndDate=Previousendon;
     ELSE Previousendon=ADCClsEndDate;
  IF ADCClsID EQ ' ' 
     THEN ADCClsID=PreviousSecID;
     ELSE PreviousSecID=ADCClsID;
PROC SORT DATA=repeatids1a; BY ADCClsPrefix ADCClsNumber ADCClsSection;
*PROC PRINT DATA=repeatids1a;
RUN;

* END - SECTION 1b - REPEATS NECESSARY VARIABLE VALUES FOR SECTION 1a *;


* BEGIN - SECTION 1c - CREATES ADDITIONAL VARIABLES VIA CALCULATION AND CONCATENATION *;

DATA Class01b;
FORMAT Course $14. Class $20.;
SET repeatids1a;
IF ADCClsTerm EQ '  ' AND ADCClsPrefix EQ '  ' THEN DELETE;
Course=(TRIM(LEFT(ADCClsPrefix)))||(TRIM(LEFT(ADCClsNumber)));

/*BEGIN CORRECTION 1 FOR 201601_R5, 201601_R4 - ERRONEOUS SECTION NUMBER for PTA13501 (IN CLASS FILE AS PTA13501111)*/
	IF ADCClsPrefix EQ "PTA" AND ADCClsNumber EQ "135" AND ADCClsSection EQ "01111" 
		THEN ADCClsSection="01";
		ELSE ADCClsSection=ADCClsSection;	
/*END   CORRECTION 1 FOR CL_201601_R5 - ERRONEOUS SECTION NUMBER for PTA13501 (IN CLASS FILE AS PTA13501111)*/

Class=(TRIM(LEFT(ADCClsPrefix)))||(TRIM(LEFT(ADCClsNumber)))||(TRIM(LEFT(ADCClsSection)));
PROC SORT DATA=Class01b; BY ADCClsID;
*PROC FREQ DATA=Class01b ORDER=FREQ;
*	TABLE Class;
RUN;


DATA TruncClass01b;
SET Class01b; BY ADCClsID;
	IF FIRST.ADCClsID THEN count=0;
		count+1;
		IF count LE &ear01 THEN OUTPUT;
RUN;


DATA collapse01;
	RETAIN
			ADCClsMeetDays&sar01-ADCClsMeetDays&ear01
			ADCClsStartTime&sar01-ADCClsStartTime&ear01
			ADCClsEndTime&sar01-ADCClsEndTime&ear01
			ADCClsCampus&sar01-ADCClsCampus&ear01 
			ADCClsBldg&sar01-ADCClsBldg&ear01 
			ADCClsRoom&sar01-ADCClsRoom&ear01 
			ADCClsIType&sar01-ADCClsIType&ear01;
	ARRAY dys (&ear01) $ ADCClsMeetDays&sar01-ADCClsMeetDays&ear01;
	ARRAY stm (&ear01) $ ADCClsStartTime&sar01-ADCClsStartTime&ear01;
	ARRAY etm (&ear01) $ ADCClsEndTime&sar01-ADCClsEndTime&ear01;
	ARRAY cmp (&ear01) $ ADCClsCampus&sar01-ADCClsCampus&ear01;
	ARRAY bld (&ear01) $ ADCClsBldg&sar01-ADCClsBldg&ear01;
	ARRAY rom (&ear01) $ ADCClsRoom&sar01-ADCClsRoom&ear01;
	ARRAY typ (&ear01) $ ADCClsIType&sar01-ADCClsIType&ear01;
	SET TruncClass01b; BY ADCClsID;
	IF FIRST.ADCClsID THEN DO;
		i=1;
		DO j=1 TO &ear01;
			dys(j)=' ';
			stm(j)=' ';
			etm(j)=' ';
			cmp(j)=' ';
			bld(j)=' ';
			rom(j)=' ';
			typ(j)=' ';
		END;
	END;
	dys(i)=ADCClsMeetDays;
	stm(i)=ADCClsStartTime;
	etm(i)=ADCClsEndTime;
	cmp(i)=ADCClsCampus;
	bld(i)=ADCClsBldg;
	rom(i)=ADCClsRoom;
	typ(i)=ADCClsIType;
	IF LAST.ADCClsID THEN OUTPUT;
	i+1;
DROP ADCClsMeetDays ADCClsStartTime ADCClsEndTime ADCClsCampus ADCClsBldg ADCClsRoom 
							ADCClsIType i j;
TITLE2 "THIS COLLAPSES MULTIVALUE FIELDS IN FIRST DATATEL CLASS FILE";
PROC SORT DATA=Collapse01; BY ADCClsID;
*PROC PRINT DATA=collapse01;
RUN;

* END - SECTION 1c - CREATES ADDITIONAL VARIABLES VIA CALCULATION AND CONCATENATION *;


* BEGIN - SECTION 2a - IMPORTS THE SECOND OF TWO DATATEL/COLLEAGUE FIXED LENGTH FILES *;

DATA class02 (KEEP=
			ADCClsTerm
			ADCClsPrefix
			ADCClsNumber
			ADCClsSection
			ADCClsShortTitle
			ADCClsDepts
			ADCClsAcadLevel
			ADCClsCourseLevel
			ADCClsFundSources
			ADCClsSecAddOn
			ADCClsSecAddBy
			ADCClsSecChgOn
			ADCClsSecChgBy
			ADCClsCensusDates
			ADCClsContactMeasures
			ADCClsContactHrs
			ADCClsCuCredits
			ADCClsCEUnits
			ADCClsCapacity
			ADCClsActiveStuCt
/*			ADCClsAvailSeats*/
			ADCClsCourseTypes
			ADCClsCredType
			ADCClsCurrentStatus
			ADCClsFacultyIDs
			ADCClsLocalIDs
			ADCClsSynonym
			ADCClsIMethod
			ADCClsTotalFTE
			ADCClsFTEContactHrs
			ADCClsFTEStuCt
			ADCClsAcctMethod
			ADCClsPriFacLName
			ADCClsPriFacFName
			ADCClsPriFacMName
			ADCClsAllFacLName
			ADCClsID
			ADCClsPrimaryFlag
			ADCClsPrimarySection
			Term2
);
INFILE "&pt01&tx02" LINESIZE=800 TRUNCOVER;
INPUT @1 ADCClsTerm $8. @;
	SELECT;
	WHEN (ADCClsTerm NE 'Term') DO;
		INPUT @1	ADCClsTerm				$8.
			@36		ADCClsPrefix			$4.
			@76		ADCClsNumber			$10.
			@89		ADCClsSection			$6.
			@96		ADCClsShortTitle		$30.
			@126	ADCClsDepts				$8.
			@166	ADCClsAcadLevel			$4.
			@201	ADCClsCourseLevel		$8.
			@231	ADCClsFundSources		$30.
			@261	ADCClsSecAddOn			$8.
			@269	ADCClsSecAddBy			$8.
			@277	ADCClsSecChgOn			$8.
			@287	ADCClsSecChgBy			$8.
			@297	ADCClsCensusDates		$8.
			@309	ADCClsContactMeasures	$30.
			@339	ADCClsContactHrs		10.2
			@352	ADCClsCuCredits			8.2
			@360	ADCClsCEUnits			6.2
			@366	ADCClsCapacity			COMMA8.
			@374	ADCClsActiveStuCt		COMMA7.
			@381	ADCClsCourseTypes		$8.
			@411	ADCClsCredType			$8.
			@446	ADCClsCurrentStatus		$3.
			@460	ADCClsFacultyIDs		$8.
			@472	ADCClsLocalIDs			$10.
			@487	ADCClsSynonym			$7.
			@498	ADCClsIMethod			$8.
			@518	ADCClsTotalFTE			COMMA9.2
			@527	ADCClsFTEContactHrs		COMMA9.2
			@538	ADCClsFTEStuCt			9.
			@547	ADCClsAcctMethod		$1.
			@577	ADCClsPriFacLName		$20.
			@634	ADCClsPriFacFName		$20.
			@664	ADCClsPriFacMName		$1.
			@694	ADCClsAllFacLName		$20.
			@751	ADCClsID				$7.
			@772    ADCClsPrimaryFlag		$1.
			@773    ADCClsPrimarySection    $7.
			@795	Term2					$8.
;
		OUTPUT class02;
	END;
	OTHERWISE DO;
	PUT 'Error in record ' _n_ 'as follows:' _INFILE_;
		DELETE;
	END;
END;
RUN;

* END - SECTION 2a - IMPORTS THE SECOND OF TWO DATATEL/COLLEAGUE FIXED LENGTH FILES *;


* BEGIN - SECTION 2b - REPEATS NECESSARY VARIABLE VALUES FOR SECTION 2a *;

DATA repeatids2a;
SET class02;
	RETAIN Previousyrtm;
	DROP   Previousyrtm;
	RETAIN Previoussub;
	DROP   Previoussub;
	RETAIN Previousnum;
	DROP   Previousnum;
	RETAIN Previoussec;
	DROP   Previoussec;
	RETAIN Previoustitle;
	DROP   Previoustitle;
	RETAIN Previousdept;
	DROP   Previousdept;
	RETAIN Previousacdlvl;
	DROP   Previousacdlvl;
	RETAIN Previousfund;
	DROP   Previousfund;
	RETAIN Previousaddon;
	DROP   Previousaddon;
	RETAIN Previousaddbby;
	DROP   Previousaddbby;
	RETAIN Previouschgon;
	DROP   Previouschgon;
	RETAIN Previouschgby;
	DROP   Previouschgby;
	RETAIN Previouscdat;
	DROP   Previouscdat;
	RETAIN Previouscmeas;
	DROP   Previouscmeas;
	RETAIN Previouscap;
	DROP   Previouscap;
	RETAIN Previousstuct;
	DROP   Previousstuct;
	RETAIN Previousctype;
	DROP   Previousctype;
	RETAIN Previouscstatus;
	DROP   Previouscstatus;
	RETAIN Previouslids;
	DROP   Previouslids;
	RETAIN Previoussyn;
	DROP   Previoussyn;
	RETAIN Previousim;
	DROP   Previousim;
	RETAIN Previoustfte;
	DROP   Previoustfte;
	RETAIN Previousftec;
	DROP   Previousftec;
	RETAIN Previousftect;
	DROP   Previousftect;
	RETAIN Previouscuc;
	DROP   Previouscuc;
	RETAIN Previousceu;
	DROP   Previousceu;
	RETAIN Previousfln;
	DROP   Previousfln;
	RETAIN Previousffn;
	DROP   Previousffn;
	RETAIN Previousfmn;
	DROP   Previousfmn;
	RETAIN Item99;
	DROP   Item99;
	RETAIN Previouspflag;
	DROP   Previouspflag;
	RETAIN Previouspsec;
	DROP   Previouspsec;
  IF ADCClsTerm EQ ' ' 
     THEN ADCClsTerm=Previousyrtm;
     ELSE Previousyrtm=ADCClsTerm;
  IF ADCClsPrefix EQ ' ' 
     THEN ADCClsPrefix=Previoussub;
     ELSE Previoussub=ADCClsPrefix;
  IF ADCClsNumber EQ ' ' 
     THEN ADCClsNumber=Previousnum;
     ELSE Previousnum=ADCClsNumber;
  IF ADCClsSection EQ ' ' 
     THEN ADCClsSection=Previoussec;
     ELSE Previoussec=ADCClsSection;
  IF ADCClsShortTitle EQ ' ' 
     THEN ADCClsShortTitle=Previoustitle;
     ELSE Previoustitle=ADCClsShortTitle;
  IF ADCClsDepts EQ ' ' 
     THEN ADCClsDepts=Previousdept;
     ELSE Previousdept=ADCClsDepts;
  IF ADCClsAcadLevel EQ ' ' 
     THEN ADCClsAcadLevel=Previousacdlvl;
     ELSE Previousacdlvl=ADCClsAcadLevel;
  IF ADCClsFundSources EQ ' ' AND Term2 EQ ' '
     THEN ADCClsFundSources=Previousfund;
     ELSE Previousfund=ADCClsFundSources;
    IF ADCClsSecAddOn EQ ' ' 
     THEN ADCClsSecAddOn=Previousaddon;
     ELSE Previousaddon=ADCClsSecAddOn;
  IF ADCClsSecAddBy EQ ' ' 
     THEN ADCClsSecAddBy=Previousaddbby;
     ELSE Previousaddbby=ADCClsSecAddBy;
  IF ADCClsSecChgOn EQ ' ' 
     THEN ADCClsSecChgOn=Previouschgon;
     ELSE Previouschgon=ADCClsSecChgOn;
  IF ADCClsSecChgBy EQ ' ' 
     THEN ADCClsSecChgBy=Previouschgby;
     ELSE Previouschgby=ADCClsSecChgBy;
  IF ADCClsCensusDates EQ ' ' 
     THEN ADCClsCensusDates=Previouscdat;
     ELSE Previouscdat=ADCClsCensusDates;
  IF ADCClsContactMeasures EQ ' ' 
     THEN ADCClsContactMeasures=Previouscmeas;
     ELSE Previouscmeas=ADCClsContactMeasures;
  IF ADCClsCapacity EQ . 
     THEN ADCClsCapacity=Previouscap;
     ELSE Previouscap=ADCClsCapacity;
  IF ADCClsActiveStuCt EQ .
     THEN ADCClsActiveStuCt=Previousstuct;
     ELSE Previousstuct=ADCClsActiveStuCt;
  IF ADCClsCredType EQ ' ' 
     THEN ADCClsCredType=Previousctype;
     ELSE Previousctype=ADCClsCredType;
  IF ADCClsCurrentStatus EQ ' ' 
     THEN ADCClsCurrentStatus=Previouscstatus;
     ELSE Previouscstatus=ADCClsCurrentStatus;
  IF ADCClsLocalIDs EQ ' ' 
     THEN ADCClsLocalIDs=Previouslids;
     ELSE Previouslids=ADCClsLocalIDs;
  IF ADCClsSynonym EQ ' ' 
     THEN ADCClsSynonym=Previoussyn;
     ELSE Previoussyn=ADCClsSynonym;
  IF ADCClsIMethod EQ ' ' 
     THEN ADCClsIMethod=Previousim;
     ELSE Previousim=ADCClsIMethod;
  IF ADCClsTotalFTE EQ .
     THEN ADCClsTotalFTE=Previoustfte;
     ELSE Previoustfte=ADCClsTotalFTE;
  IF ADCClsFTEContactHrs EQ .
     THEN ADCClsFTEContactHrs=Previousftec;
     ELSE Previousftec=ADCClsFTEContactHrs;
  IF ADCClsFTEStuCt EQ .
     THEN ADCClsFTEStuCt=Previousftect;
     ELSE Previousftect=ADCClsFTEStuCt;
  IF ADCClsAcadLevel EQ 'CU' AND ADCClsCUCredits EQ .
     THEN ADCClsCUCredits=Previouscuc;
     ELSE IF ADCClsAcadLevel EQ 'CU' THEN Previouscuc=ADCClsCUCredits;
  IF (ADCClsAcadLevel EQ 'CE' OR ADCClsAcadLevel EQ 'BSP') AND ADCClsCEUnits EQ .
     THEN ADCClsCEUnits=Previousceu;
     ELSE IF (ADCClsAcadLevel EQ 'CE' OR ADCClsAcadLevel EQ 'BSP') THEN Previousceu=ADCClsCEUnits;
  IF ADCClsFacultyIDs NE ' ' AND ADCClsPriFacLName EQ ' ' 
     THEN ADCClsPriFacLName=Previousfln;
     ELSE Previousfln=ADCClsPriFacLName;
  IF ADCClsFacultyIDs NE ' ' AND ADCClsPriFacFName EQ ' ' 
     THEN ADCClsPriFacFName=Previousffn;
     ELSE Previousffn=ADCClsPriFacFName;
  IF ADCClsFacultyIDs NE ' ' AND ADCClsPriFacMName EQ ' ' 
     THEN ADCClsPriFacMName=Previousfmn;
     ELSE Previousfmn=ADCClsPriFacMName;
  IF ADCClsID EQ ' ' 
     THEN ADCClsID=Item99;
     ELSE Item99=ADCClsID;
  IF ADCClsPrimaryFlag=' ' AND Term2 EQ ' '
  	 THEN ADCClsPrimaryFlag=Previouspflag;
	 ELSE Previouspflag=ADCClsPrimaryFlag;
  IF ADCClsPrimarySection=' ' AND Term2 EQ ' '
  	 THEN ADCClsPrimarySection=Previouspsec;
	 ELSE Previouspsec=ADCClsPrimarySection;
PROC SORT DATA=repeatids2a; BY ADCClsPrefix ADCClsNumber ADCClsSection;
*PROC PRINT DATA=repeatids2a;
RUN;

* END - SECTION 2b - REPEATS NECESSARY VARIABLE VALUES FOR SECTION 2a *;


* BEGIN - SECTION 2c - CREATES ADDITIONAL VARIABLES VIA CALCULATION AND CONCATENATION *;

DATA Class02b;
FORMAT Course $14. 
		Class $20. 
		ClsAvailSeats 8.
		ClsPriFacLFMName $40.;
SET repeatids2a;
IF ADCClsTerm EQ '  ' AND ADCClsPrefix EQ '  ' THEN DELETE;
Course=(TRIM(LEFT(ADCClsPrefix)))||(TRIM(LEFT(ADCClsNumber)));

/*BEGIN CORRECTION 2 FOR 201601_R5, 201601_R4 - ERRONEOUS SECTION NUMBER for PTA13501 (IN CLASS FILE AS PTA13501111)*/
	IF ADCClsTerm EQ '2016SP' AND ADCClsPrefix EQ "PTA" AND ADCClsNumber EQ "135" AND ADCClsSection EQ "01111" 
		THEN ADCClsSection="01";
		ELSE ADCClsSection=ADCClsSection;	
/*END   CORRECTION 2 FOR CL_201601_R5 - ERRONEOUS SECTION NUMBER for PTA13501 (IN CLASS FILE AS PTA13501111)*/

Class=(TRIM(LEFT(ADCClsPrefix)))||(TRIM(LEFT(ADCClsNumber)))||(TRIM(LEFT(ADCClsSection)));
ClsAvailSeats=ADCClsCapacity-ADCClsActiveStuCt;
IF ADCClsPriFacLName NE ' '
	THEN ClsPriFacLFMName=(TRIM(LEFT(ADCClsPriFacLName)))||', '||(TRIM(LEFT(ADCClsPriFacFName)))||' '||(TRIM(LEFT(ADCClsPriFacMName)));
PROC SORT DATA=Class02b; BY ADCClsID;
RUN;

DATA collapse02;
	RETAIN ADCClsCourseLevel&sar02-ADCClsCourseLevel&ear02 			 
			ADCClsContactHrs&sar02-ADCClsContactHrs&ear02
			ADCClsCourseTypes&sar02-ADCClsCourseTypes&ear02
			ADCClsFacultyIDs&sar02-ADCClsFacultyIDs&ear02
			ADCClsAllFacLName&sar02-ADCClsAllFacLName&ear02;
	ARRAY clv (&ear02) $ ADCClsCourseLevel&sar02-ADCClsCourseLevel&ear02;
	ARRAY chr (&ear02)   ADCClsContactHrs&sar02-ADCClsContactHrs&ear02;
	ARRAY cty (&ear02) $ ADCClsCourseTypes&sar02-ADCClsCourseTypes&ear02;
	ARRAY fid (&ear02) $ ADCClsFacultyIDs&sar02-ADCClsFacultyIDs&ear02;
	ARRAY fln (&ear02) $ ADCClsAllFacLName&sar02-ADCClsAllFacLName&ear02;
	SET Class02b; BY ADCClsID;
	IF FIRST.ADCClsID THEN DO;
		i=1;
		DO j=1 TO &ear02;
			clv(j)=' ';
			chr(j)= . ;
			cty(j)=' ';
			fid(j)=' ';
			fln(j)=' ';
		END;
	END;
	clv(i)=ADCClsCourseLevel;
	chr(i)=ADCClsContactHrs;
	cty(i)=ADCClsCourseTypes;
	fid(i)=ADCClsFacultyIDs;
	fln(i)=ADCClsAllFacLName;
	IF LAST.ADCClsID THEN OUTPUT;
	i+1;
DROP ADCClsCourseLevel 
		ADCClsContactHrs 
		ADCClsCourseTypes 
		ADCClsFacultyIDs 
		ADCClsAllFacLName
		i 
		j;
TITLE2 "THIS COLLAPSES MULTIVALUE FIELDS IN FIRST DATATEL CLASS FILE";
PROC SORT DATA=Collapse02; BY ADCClsID;
*PROC PRINT DATA=collapse02;
RUN;

* END - SECTION 2c - CREATES ADDITIONAL VARIABLES VIA CALCULATION AND CONCATENATION *;

***WORK***;

* BEGIN - SECTION 3 - THIS MERGES THE TWO DATATEL CLASS FILES INTO ONE DATASET *;

DATA classmerge;
/*FORMAT InstDataPoint $10.;*/
	MERGE collapse01 collapse02; BY ADCClsID;
/*InstDataPoint=COMPRESS("&rp02","_");*/
TITLE2 "THIS MERGES THE TWO DATATEL CLASS FILES INTO ONE DATASET";
*PROC PRINT DATA=classmerge;
*	VAR Course ADCDepts01-ADCDepts20;
*PROC FREQ DATA=classmerge;
*	TABLES ADCLocation01;
RUN;

/* ADD NCCC FUNDING TIERS: FY 2013-14 - UPDATE AS NEEDED */
DATA fundtier;
FORMAT ClsFTETier $20.;
SET classmerge;
/****** CURRICULUM TIERS ******/
/*********** Tier 1A ***********/
IF ADCClsAcadLevel IN ('CU')
		AND ADCClsPrefix IN (
							'AER',
							'AET',
							'AHR',
							'ALT',
							'ARC',
							'ARS',
							'ASM',
							'ATR',
							'ATT',
							'AUB',
							'AUC',
							'AUT',
							'AVI',
							'BAT',
							'BMS',
							'BMT',
							'BPM',
							'BPR',
							'BTB',
							'BTC',
							'CAR',
							'CAT',
							'CEG',
							'CET',
							'CIT',
							'CIV',
							'CMT',
							'CST',
							'CTR',
							'CVS',
							'DDF',
							'DEN',
							'DFT',
							'DLT',
							'DOS',
							'EGR',
							'ELC',
							'ELN',
							'ELT',
							'EPP',
							'EUS',
							'FMW',
							'HEO',
							'HET',
							'HTO',
							'ICT',
							'ICV',
							'IMG',
							'ISC',
							'LDD',
							'LEO',
							'MAC',
							'MAM',
							'MCM',
							'MEC',
							'MNT',
							'MPS',
							'MRI',
							'MRN',
							'MSC',
							'MSP',
							'NAN',
							'NCT',
							'NDE',
							'NMT',
							'NUC',
							'NUR',
							'OTA',
							'PCI',
							'PET',
							'PFT',
							'PLA',
							'PLU',
							'PME',
							'PTA',
							'PTC',
							'RAD',
							'RCP',
							'RCT',
							'REF',
							'RTT',
							'RVM',
							'SON',
							'SRV',
							'SST',
							'STP',
							'SUR',
							'TCT',
							'TDP',
							'TEL',
							'TNE',
							'TRN',
							'TRP',
							'WAT',
							'WLD'
)  
	THEN ClsFTETier='01 - Tier One A   ';
/*********** Tier 1B ***********/
ELSE IF ADCClsAcadLevel IN ('CU')
		AND ADCClsPrefix IN (
							'ANS',
							'BDF',
							'BIO',
							'BPA',
							'CAB',
							'CHM',
							'CIM',
							'CPT',
							'CSC',
							'CTC',
							'CTI',
							'CTS',
							'CUL',
							'CYT',
							'DEA',
							'DET',
							'DIA',
							'DME',
							'EDT',
							'EMS',
							'FUR',
							'GIS',
							'HBI',
							'HIT',
							'HPC',
							'HPT',
							'HTO',
							'LBT',
							'LID',
							'MAS',
							'MED',
							'MLT',
							'MSM',
							'MTH',
							'NAS',
							'NET',
							'NOS',
							'OPH',
							'PBT',
							'PHM',
							'PHY',
							'PPM',
							'PPT',
							'PSG',
							'REH',
							'SEC',
							'SGD',
							'SGR',
							'SLP',
							'UPH',
							'VEN',
							'VET',
							'WPP'
)  
		OR (ADCClsPrefix IN ('MAT') 
		AND SUBSTR(Course,4,1) NOT IN ('0'))
	THEN ClsFTETier='01 - Tier One B   ';
/*********** Tier 2 ***********/
ELSE IF ADCClsAcadLevel IN ('CU') 
		AND ADCClsPrefix IN (
'AAI',
'ACA',
'ACC',
'ACM',
'AGR',
'AIB',
'ANT',
'APS',
'AQU',
'ARA',
'ART',
'ASL',
'AST',
'AUM',
'BAF',
'BAR',
'BAS',
'BPT',
'BUS',
'CCT',
'CHI',
'CIS',
'CJC',
'COE',
'COM',
'COS',
'CRT',
'CSV',
'DAN',
'DBA',
'DDT',
'DES',
'DMA',
'DMS',
'DRA',
'DRE',
'ECM',
'ECO',
'EDU',
'EFL',
'EHS',
'ENG',
'ENT',
'EPT',
'EQU',
'ETR',
'FBG',
'FIP',
'FLO',
'FOR',
'FPR',
'FRE',
'FSD',
'FSE',
'FST',
'FVP',
'FWL',
'GAM',
'GCM',
'GEL',
'GEO',
'GER',
'GRA',
'GRD',
'GRO',
'HCI',
'HCT',
'HEA',
'HIS',
'HMT',
'HOR',
'HRM',
'HSC',
'HSE',
'HUC',
'HUM',
'IEC',
'ILT',
'IMS',
'INS',
'INT',
'IPP',
'ITA',
'ITN',
'IVS',
'JOU',
'JPN',
'LAR',
'LAT',
'LEX',
'LIB',
'LOG',
'LSG',
'MEG',
'MHA',
'MIT',
'MKT',
'MLG',
'MSI',
'MUS',
'NPO',
'NUT',
'ODL',
'OMT',
'OSS',
'OST',
'PAD',
'PCC',
'PCD',
'PCF',
'PCJ',
'PCR',
'PCS',
'PCW',
'PED',
'PFN',
'PHI',
'PHO',
'PHS',
'PKG',
'PMT',
'POL',
'POR',
'POS',
'PRN',
'PSF',
'PSY',
'REA',
'REC',
'RED',
'REL',
'RLS',
'RSM',
'RUS',
'SAB',
'SCI',
'SOC',
'SPA',
'SPI',
'SSM',
'SWK',
'TAT',
'TEX',
'TRE',
'TRF',
'TXY',
'VWR',
'WBL',
'WEB',
'WOL',
'WWK',
'ZAS'
)
		OR (ADCClsPrefix IN ('MAT') 
		AND SUBSTR(Course,4,1) IN ('0'))
	THEN ClsFTETier='02 - Tier Two';
ELSE IF ADCClsAcadLevel IN ('CU') THEN ClsFTETier='02 - Tier Two';
/*********** BASIC SKILLS TIER ***********/
/*********** Tier 2 ***********/
ELSE IF ADCClsAcadLevel IN ('BSP') THEN ClsFTETier='02 - Tier Two';
/****** OE TIERS ******/
/******* Tier 1A *******/
ELSE IF ADCClsAcadLevel IN ('CE')
	AND ADCClsLocalIDs IN (
'AER-3211',
'AET-3122',
'AET-3124',
'AET-3130',
'AET-3224',
'AVI-3009',
'AVI-3010',
'AVI-3011',
'AVI-3012',
'ELS-3018',
'ISC-3200',
'RAD-2100',
'TRA-3607'
)
THEN ClsFTETier='01 - Tier One A';
/******* Tier 1B *******/
ELSE IF ADCClsAcadLevel IN ('CE')
	AND ADCClsLocalIDs IN (
'AHR-3030',
'AHR-3131',
'APP-3200',
'APP-3500',
'APP-3601',
'APP-3607',
'APP-3608',
'APP-3612',
'APP-3618',
'APP-3701',
'AUT-3109',
'AUT-3137',
'CAR-3108',
'CAR-3112',
'CAR-3124',
'CAR-3200',
'CAT-3100',
'EDT-3100',
'EGY-2002',
'EGY-3001',
'EGY-3002',
'EGY-3003',
'EGY-3004',
'EGY-4005',
'ELC-3014',
'ELC-3119',
'ELN-3025',
'FSD-3100',
'HEO-3100',
'ISC-3138',
'MEC-3010',
'MNT-3065',
'MNT-3111',
'MNT-3200',
'NUR-3354',
'PLU-3020',
'PLU-3024',
'REF-3100',
'TCT-3102',
'TCT-3105',
'WLD-3106'
)
THEN ClsFTETier='01 - Tier One B';
/******* Tier 2 *******/
ELSE IF ADCClsAcadLevel IN ('CE')
	AND ADCClsLocalIDs IN (
'AUT-3200',
'CAB-3100',
'CAS-3000',
'CJC-3938',
'CJC-3941',
'CJC-4004',
'CJC-5001',
'CJC-5055',
'CJC-5060',
'COM-3800',
'COM-3801',
'COS-3101',
'COS-3102',
'COS-3201',
'COS-3206',
'DIA-3100',
'ELN-3006',
'EMS-3027',
'EMS-3029',
'EMS-3031',
'EMS-3044',
'EMS-3045',
'FIP-3001',
'FIP-3003',
'FIP-3004',
'FIP-3005',
'FIP-3006',
'FIP-3007',
'FIP-3008',
'FIP-3009',
'FIP-3010',
'FIP-3011',
'FIP-3012',
'FIP-3013',
'FIP-3014',
'FIP-3016',
'FIP-3017',
'FIP-3018',
'FIP-3019',
'FIP-3021',
'FIP-3022',
'FIP-3024',
'FIP-3025',
'FIP-3026',
'FIP-3103',
'FIP-3104',
'FIP-3105',
'FIP-3106',
'FIP-3107',
'FIP-3108',
'FIP-3109',
'FIP-3110',
'FIP-3111',
'FIP-3113',
'FIP-3114',
'FIP-3115',
'FIP-3116',
'FIP-3117',
'FIP-3118',
'FIP-3119',
'FIP-3121',
'FIP-3123',
'FIP-3124',
'FIP-3125',
'FIP-3203',
'FIP-3204',
'FIP-3205',
'FIP-3207',
'FIP-3208',
'FIP-3209',
'FIP-3210',
'FIP-3211',
'FIP-3212',
'FIP-3213',
'FIP-3215',
'FIP-3216',
'FIP-3223',
'FIP-3225',
'FIP-3303',
'FIP-3304',
'FIP-3305',
'FIP-3306',
'FIP-3307',
'FIP-3308',
'FIP-3309',
'FIP-3310',
'FIP-3311',
'FIP-3312',
'FIP-3313',
'FIP-3314',
'FIP-3315',
'FIP-3316',
'FIP-3317',
'FIP-3318',
'FIP-3319',
'FIP-3321',
'FIP-3322',
'FIP-3323',
'FIP-3325',
'FIP-3351',
'FIP-3402',
'FIP-3404',
'FIP-3411',
'HEA-3009',
'HEA-3021',
'HIT-3700',
'HOS-4040',
'HSE-3300',
'ICT-3100',
'LOG-3400',
'MAS-3002',
'MED-3002',
'MED-3004',
'MED-3200',
'MED-3300',
'MLA-3022',
'MNT-3066',
'MNT-3067',
'NUR-3218',
'NUR-3240',
'NUR-3241',
'NUR-3252',
'OPT-3020',
'OSC-3608',
'PHM-3250',
'PSF-3100',
'UPH-3100',
'UPH-3101',
'UPH-3102',
'UPH-3106',
'UPH-3107',
'UPH-3108',
'UPH-3110',
'UPH-3161'
)
THEN ClsFTETier='02 - Tier Two';
/******* Tier 3 *******/
ELSE IF ADCClsAcadLevel IN ('CE')
	AND ADCClsLocalIDs IN (
'ACC-3104',
'ACC-3107',
'ACC-3118',
'ACC-3121',
'AER-3101',
'AER-3103',
'AER-3105',
'AET-3120',
'AET-3126',
'AET-3132',
'AET-3210',
'AET-3212',
'AET-3214',
'AET-3216',
'AET-3218',
'AET-3220',
'AET-3222',
'AET-3226',
'AET-3228',
'AGR-3001',
'AHR-3123',
'AHR-3128',
'ANS-3011',
'ANS-3100',
'ANS-3411',
'ANS-3500',
'APP-3300',
'AQU-3100',
'AUT-3001',
'AUT-3002',
'AUT-3003',
'AUT-3004',
'AUT-3110',
'AUT-3129',
'AUT-3139',
'AUT-3151',
'AUT-3400',
'BAF-3100',
'BAF-3200',
'BAF-3215',
'BAF-3216',
'BAF-3249',
'BAF-3261',
'BAF-3272',
'BAF-5010',
'BPR-3011',
'BTC-3300',
'BTC-3400',
'BTC-3401',
'BTC-3500',
'BTC-3501',
'BTC-3502',
'BTC-3503',
'BTC-3504',
'BTC-3600',
'BTC-3700',
'BTC-3900',
'BUS-3000',
'CAR-3005',
'CAR-3008',
'CAR-3031',
'CAR-3114',
'CAR-3118',
'CAR-3123',
'CAR-3129',
'CAS-3010',
'CAS-3020',
'CAS-3030',
'CAS-3040',
'CAS-3050',
'CAS-3060',
'CAS-3070',
'CAS-3080',
'CAS-3090',
'CAS-3100',
'CAS-3120',
'CHM-3001',
'CJC-3924',
'CJC-3925',
'CJC-3926',
'CJC-3928',
'CJC-3929',
'CJC-3933',
'CJC-3934',
'CJC-3935',
'CJC-3936',
'CJC-3937',
'CJC-3942',
'CJC-3950',
'CJC-3952',
'CJC-5000',
'CJC-5005',
'CJC-5010',
'CJC-5015',
'CJC-5020',
'CJC-5025',
'CJC-5030',
'CJC-5035',
'CJC-5040',
'CJC-5045',
'CJC-5050',
'CJC-5065',
'CJC-5070',
'COD-3101',
'COD-3104',
'COD-3105',
'COD-3106',
'COD-3107',
'COD-3110',
'COD-3111',
'COD-3120',
'COD-3121',
'COD-3122',
'COD-3130',
'COD-3131',
'COD-3132',
'COD-3140',
'COD-3141',
'COD-3142',
'COD-3199',
'COM-3709',
'COM-3711',
'COM-3724',
'COM-3725',
'COM-3727',
'COM-3729',
'COS-3103',
'COS-3205',
'CSC-3110',
'CTR-3100',
'DEN-3000',
'DEN-3018',
'DEN-3020',
'DEN-3100',
'DEN-3200',
'DES-3000',
'DFT-3099',
'DFT-3100',
'DIE-3011',
'EDU-3000',
'EDU-3001',
'EDU-3002',
'EDU-3003',
'EDU-3005',
'EDU-3009',
'EDU-3010',
'EDU-3200',
'EGY-2000',
'EGY-2001',
'EGY-2003',
'EGY-2004',
'EGY-3000',
'EGY-4000',
'EGY-4001',
'EGY-4002',
'EGY-4003',
'EGY-4004',
'ELC-3016',
'ELC-3100',
'ELC-3130',
'ELN-3113',
'EMS-3000',
'EMS-3001',
'EMS-3025',
'EMS-3041',
'EMS-3042',
'EMS-3046',
'EMS-3048',
'EMS-3050',
'EMS-3051',
'EMS-3055',
'EMS-3060',
'EMS-3061',
'EMS-3066',
'EMS-3067',
'EMS-3074',
'EMS-3075',
'EMS-3077',
'EMS-3079',
'EMS-3080',
'EMS-3081',
'EMS-3091',
'EMS-3092',
'EMS-3095',
'EMS-3096',
'EMS-3104',
'EMS-3105',
'EMS-3106',
'EMS-3200',
'EMS-4000',
'ENV-3200',
'EPT-3500',
'EPT-3600',
'EPT-4100',
'EPT-4200',
'EPT-4300',
'EPT-4400',
'EPT-4800',
'EPT-4900',
'EPT-4901',
'EPT-4950',
'EPT-4952',
'EPT-4954',
'EPT-4960',
'EPT-4962',
'EPT-4964',
'EPT-4965',
'EPT-4967',
'EPT-4970',
'EPT-4971',
'EPT-4975',
'EPT-4976',
'EPT-4977',
'EPT-4978',
'EPT-4979',
'EPT-5100',
'EPT-5101',
'EPT-5102',
'EPT-5103',
'EPT-5104',
'EPT-5105',
'EPT-5106',
'EPT-5200',
'EPT-5201',
'EPT-5202',
'EPT-5203',
'EPT-5204',
'EPT-5205',
'EPT-5206',
'EPT-5300',
'EPT-5301',
'EPT-5302',
'EPT-5303',
'EPT-5304',
'EPT-5305',
'EPT-5306',
'EPT-5307',
'EPT-5308',
'EPT-5309',
'EPT-5310',
'EPT-5311',
'EPT-5400',
'EPT-5401',
'EPT-5402',
'EPT-5403',
'EPT-5404',
'EPT-5405',
'EPT-5500',
'EPT-5501',
'EPT-5502',
'EPT-5503',
'EPT-5504',
'EPT-5505',
'EPT-5700',
'EPT-5701',
'EPT-5801',
'FIP-3352',
'FIP-3353',
'FIP-3354',
'FIP-3401',
'FIP-3500',
'FIP-3601',
'FIP-3610',
'FIP-3611',
'FIP-3612',
'FIP-3613',
'FIP-3614',
'FIP-3615',
'FIP-3616',
'FIP-3617',
'FIP-3618',
'FIP-3619',
'FIP-3620',
'FIP-3621',
'FIP-3700',
'FIP-3710',
'FIP-3711',
'FIP-3712',
'FIP-3713',
'FIP-3714',
'FIP-3805',
'FIP-3806',
'FIP-3807',
'FIP-3808',
'FIP-3903',
'FIP-4000',
'FIP-4001',
'FIP-4004',
'FIP-4106',
'FIP-4112',
'FIP-4113',
'FIP-4115',
'FIP-4116',
'FIP-4117',
'FIP-4123',
'FIP-4124',
'FIP-4132',
'FIP-4209',
'FIP-4214',
'FIP-4215',
'FIP-4533',
'FIP-4535',
'FIP-4551',
'FIP-4610',
'FIP-4611',
'FIP-4612',
'FIP-4613',
'FIP-4614',
'FIP-4615',
'FIP-4616',
'FIP-4617',
'FIP-4618',
'FIP-4701',
'FIP-4705',
'FIP-4711',
'FIP-4714',
'FIP-4715',
'FIP-4716',
'FIP-4717',
'FIP-4725',
'FIP-4727',
'FIP-4728',
'FIP-4729',
'FIP-4828',
'FIP-4831',
'FIP-4863',
'FIP-4901',
'FIP-4902',
'FIP-4903',
'FIP-4904',
'FIP-4905',
'FIP-4906',
'FIP-5520',
'FIP-5570',
'FIP-5580',
'FIP-5581',
'FIP-5582',
'FIP-5583',
'FIP-5584',
'FIP-5585',
'FIP-5600',
'FIP-5601',
'FIP-5602',
'FIP-5603',
'FIP-5604',
'FIP-5605',
'FIP-5606',
'FIP-5607',
'FIP-5700',
'FIP-5701',
'FIP-5702',
'FIP-5703',
'FIP-5704',
'FIP-5705',
'FIP-5800',
'FIP-5801',
'FIP-5802',
'FIP-5803',
'FIP-5804',
'FIP-5805',
'FIP-5806',
'FIP-5807',
'FIP-5900',
'FIP-5901',
'FIP-5902',
'FIP-5903',
'FIP-5904',
'FIP-6100',
'FIP-6101',
'FIP-6102',
'FIP-6103',
'FIP-6104',
'FIP-6105',
'FIP-6200',
'FIP-6201',
'FIP-6202',
'FIP-6203',
'FIP-6204',
'FIP-6205',
'FIP-6206',
'FIP-6300',
'FIP-6301',
'FIP-6302',
'FIP-6303',
'FIP-6304',
'FIP-6400',
'FIP-6401',
'FIP-6402',
'FIP-6403',
'FIP-6404',
'FIP-6405',
'FIP-6406',
'FIP-6407',
'FIP-6408',
'FIS-3106',
'FIS-3108',
'FIS-3109',
'FLI-3700',
'FLI-3701',
'FLI-3712',
'FLI-3714',
'FLI-3715',
'FLI-3717',
'FLI-3718',
'FLI-3719',
'FLI-3720',
'FSE-3025',
'FUR-3300',
'FVP-3020',
'FVP-3100',
'GAM-3001',
'GRD-3000',
'GSM-3010',
'HAZ-3061',
'HAZ-3062',
'HAZ-3063',
'HAZ-3064',
'HAZ-3065',
'HAZ-3068',
'HAZ-3070',
'HCT-90001',
'HCT-90002',
'HEA-3002',
'HEA-3003',
'HEA-3010',
'HEA-3029',
'HEA-3100',
'HEC-3107',
'HEC-3109',
'HEC-3141',
'HEC-3164',
'HEC-3300',
'HEO-3002',
'HEO-3200',
'HIT-3100',
'HIT-3200',
'HIT-3300',
'HIT-3400',
'HIT-3500',
'HIT-3600',
'HMT-3000',
'HOR-3307',
'HOR-3311',
'HOR-3313',
'HOR-3314',
'HOS-3007',
'HOS-3036',
'HOS-3041',
'HOS-3043',
'HOS-3058',
'HOS-3060',
'HOS-3067',
'HOS-3070',
'HOS-3072',
'HOS-3075',
'HOS-3090',
'HOS-4010',
'HOS-4020',
'HOS-4030',
'HPT-3100',
'HRD-3001',
'HRD-3002',
'HRD-3003',
'HRD-3004',
'HRD-3005',
'HRD-3006',
'HRD-3008',
'HSE-3264',
'HSE-3266',
'HYD-3607',
'INS-3310',
'INS-3385',
'ISC-3001',
'ISC-3036',
'ISC-3102',
'ISC-3111',
'ISC-3119',
'ISC-3400',
'ISC-3401',
'ISC-3500',
'ISC-3600',
'ITN-3000',
'LBT-2100',
'LBT-3100',
'LEX-3010',
'LEX-3875',
'LEX-4000',
'LEX-5000',
'MAT-3713',
'MEC-3005',
'MEC-4000',
'MED-3006',
'MED-3008',
'MED-3030',
'MHT-3100',
'MKT-3093',
'MKT-3101',
'MKT-3405',
'MKT-3419',
'MKT-3429',
'MKT-3438',
'MLS-3000',
'MLS-3010',
'MLS-3012',
'MLS-3224',
'MLS-3230',
'MLS-3710',
'MLS-3808',
'MLS-3809',
'MLS-3810',
'MLS-3812',
'MLS-3814',
'MLS-3856',
'MLS-3859',
'MLS-3871',
'MLS-3874',
'MLS-3880',
'MLS-3883',
'MLS-3886',
'MLS-3917',
'MLS-3927',
'MLS-3931',
'MNT-3000',
'MNT-3103',
'NUR-3001',
'NUR-3100',
'NUR-3101',
'NUR-3216',
'NUR-3235',
'NUR-3236',
'NUR-3242',
'NUR-3247',
'NUR-3262',
'NUR-3267',
'NUR-3268',
'NUR-3268',
'NUR-3268',
'NUR-3271',
'NUR-3279',
'NUR-3290',
'NUR-3320',
'NUR-3350',
'NUR-3353',
'NUR-3355',
'NUR-3500',
'OPT-3019',
'OSC-3602',
'OSC-3609',
'OSC-3636',
'OSH-3001',
'OSH-3003',
'OSH-3012',
'OSH-3013',
'OSH-3015',
'OSH-3050',
'OSH-3051',
'OSH-3100',
'OSH-3300',
'OSH-3400',
'OSH-3801',
'OSH-3980',
'OSH-8000',
'PHM-4100',
'PHM-4900',
'PHO-3001',
'PLU-3021',
'PLU-3023',
'PLU-3027',
'PLU-3100',
'POS-3000',
'PRC-3104',
'PRN-3004',
'PTH-3000',
'REA-3801',
'REA-3802',
'REA-3803',
'REA-3804',
'REA-3805',
'REA-3806',
'REA-3807',
'REA-3808',
'REA-3809',
'REA-3810',
'RLS-3500',
'RLS-3511',
'RLS-3512',
'RLS-3700',
'RLS-3701',
'RLS-3702',
'RLS-3703',
'RLS-3704',
'RLS-3705',
'SAF-3002',
'SAF-3014',
'SAF-3016',
'SAF-3017',
'SAF-3020',
'SAF-3023',
'SAF-3025',
'SAF-3026',
'SAF-3027',
'SAF-3032',
'SAF-3033',
'SAF-3035',
'SAF-3036',
'SAF-4000',
'SGD-3200',
'SON-3100',
'SRV-3115',
'SRV-3130',
'SUR-3100',
'TCT-3101',
'TCT-3103',
'TCT-3104',
'TEX-3101',
'TEX-3103',
'TEX-3117',
'TEX-3200',
'TRA-3602',
'TRA-3605',
'TRA-3611',
'TRA-3700',
'TXY-3407',
'WAT-3000',
'WAT-3100',
'WAT-3116',
'WAT-3117',
'WAT-3118',
'WAT-3119',
'WAT-3122',
'WAT-3123',
'WAT-3124',
'WAT-3125',
'WAT-3127',
'WAT-3130',
'WAT-3133',
'WAT-3200',
'WLD-3115',
'WLF-2101',
'WLF-2102',
'WLF-2103',
'WLF-2104',
'WLF-2200',
'WLF-2201',
'WLF-2202',
'WLF-2203',
'WLF-2204',
'WLF-2205',
'WLF-2206',
'WLF-2207',
'WLF-2301',
'WLF-2302',
'WLF-2303',
'WPP-3001',
'WPP-3100'
)
THEN ClsFTETier='03 - Tier Three';
ELSE IF ADCClsAcadLevel IN ('CE')
	AND ADCClsFundSources IN (
'FINT',
'NOSS',
'OESS',
'SBCT'
)
THEN ClsFTETier='04 - Self Supporting';
RUN;

* END - SECTION 3 - THIS MERGES THE TWO DATATEL CLASS FILES INTO ONE DATASET *;

DATA FINAL (KEEP=
					InstTerm
					ADCClsTerm
					InstDataPoint
					Class
					ADCClsID
					Course
					ADCClsShortTitle
					ADCClsPrefix
					ADCClsNumber
					ADCClsSection
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
					ADCClsAcadLevel
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
					ADCClsCourseLevel&sar02-ADCClsCourseLevel&ear02 			 
					ADCClsContactHrs&sar02-ADCClsContactHrs&ear02
					ADCClsCourseTypes&sar02-ADCClsCourseTypes&ear02
					ADCClsFacultyIDs&sar02-ADCClsFacultyIDs&ear02
					ADCClsAllFacLName&sar02-ADCClsAllFacLName&ear02
					ADCClsMeetDays&sar01-ADCClsMeetDays&ear01
					ADCClsStartTime&sar01-ADCClsStartTime&ear01
					ADCClsEndTime&sar01-ADCClsEndTime&ear01
					ADCClsCampus&sar01-ADCClsCampus&ear01 
					ADCClsBldg&sar01-ADCClsBldg&ear01 
					ADCClsRoom&sar01-ADCClsRoom&ear01 
					ADCClsIType&sar01-ADCClsIType&ear01
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
					ADCClsTerm
					InstDataPoint
					Class
					ADCClsID
					Course
					ADCClsShortTitle
					ADCClsPrefix
					ADCClsNumber
					ADCClsSection
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
					ADCClsAcadLevel
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
					ADCClsCourseLevel&sar02-ADCClsCourseLevel&ear02 			 
					ADCClsContactHrs&sar02-ADCClsContactHrs&ear02
					ADCClsCourseTypes&sar02-ADCClsCourseTypes&ear02
					ADCClsFacultyIDs&sar02-ADCClsFacultyIDs&ear02
					ADCClsAllFacLName&sar02-ADCClsAllFacLName&ear02
					ADCClsMeetDays&sar01-ADCClsMeetDays&ear01
					ADCClsStartTime&sar01-ADCClsStartTime&ear01
					ADCClsEndTime&sar01-ADCClsEndTime&ear01
					ADCClsCampus&sar01-ADCClsCampus&ear01 
					ADCClsBldg&sar01-ADCClsBldg&ear01 
					ADCClsRoom&sar01-ADCClsRoom&ear01 
					ADCClsIType&sar01-ADCClsIType&ear01
					ClsFTETier
					InstCountry
					InstState
					InstShortName
					InstID
					InstIPEDSUnitID
					InstOPEID
;
FORMAT
		InstDataPoint $10.
		InstCountry $3.
		InstState $3.
		InstID $10.
		InstShortName $10.
		InstTerm $10.
		InstIPEDSUnitID $10.
		InstOPEID $10.
;
SET fundtier;
InstDataPoint=UPCASE(COMPRESS("&rp01","_"));
InstCountry="&IC01";
InstState="&IS01";
InstID="&II01";
InstShortName="&IN01";
InstIPEDSUnitID="&IU01";
InstOPEID="&OI01";
InstTerm="&YT01";
Class=UPCASE(Class);
DROP count;
PROC SORT DATA=FINAL; BY ADCClsID;
RUN;

* BEGIN - SECTION 4a - THIS CHECKS FOR DISCREPANCIES IN THE TWO DATATEL CLASS FILES *;

ODS LISTING CLOSE;
ODS HTML CLOSE;
ODS MARKUP TAGSET=CHTML BODY="&PathRoot\XX_SAS_TrashBin\Report01.html";

DATA mergechk1;
	MERGE collapse01(IN=a) collapse02(IN=b); BY ADCClsID;
	IF a AND not b;
TITLE2 "ERROR - THIS CHECKS FOR DISCREPANCIES IN THE TWO DATATEL CLASS FILES";
TITLE3 "ERROR - THESE CLASSES ARE IN CLASS FILE 01 BUT NOT IN CLASS FILE 02";
PROC PRINT DATA=mergechk1;
	VAR ADCClsTerm Class ADCClsCurrentStatus ADCClsActiveStuCt;
RUN;

* END - SECTION 4a - THIS CHECKS FOR DISCREPANCIES IN THE TWO DATATEL CLASS FILES *;


* BEGIN - SECTION 4b - THIS CHECKS FOR DISCREPANCIES IN THE TWO DATATEL CLASS FILES *;

DATA mergechk2;
	MERGE collapse01(IN=a) collapse02(IN=b); BY ADCClsID;
	IF b AND not a;
TITLE2 "ERROR - THIS CHECKS FOR DISCREPANCIES IN THE TWO DATATEL CLASS FILES";
TITLE3 "ERROR - THESE CLASSES ARE IN CLASS FILE 02 BUT NOT IN CLASS FILE 01";
TITLE4 "CHECK TO MAKE SURE THESE CLASSES APPEAR IN FINAL CLASS FILE";
PROC PRINT DATA=mergechk2;
	VAR ADCClsTerm Class ADCClsCurrentStatus ADCClsActiveStuCt;
RUN;

* END - SECTION 4b - THIS CHECKS FOR DISCREPANCIES IN THE TWO DATATEL CLASS FILES *;

* BEGIN - SECTION 5a - THIS SAVES THE DATA AS A SAS DATASET *;

/*DATA &lb02 .&ds02&yt02&rp02;
SET FINAL;
TITLE2 "THIS SAVES THE DATA AS A SAS DATASET";
RUN;*/

proc freq data=final;
tables ADCClsAcadLevel*ClsFTETier;
TITLE1 "Funding Tier Check";
run;

ODS MARKUP TAGSET=CHTML CLOSE;

/*
DATA NOTier;
SET Final;
IF ClsFTETier EQ ' ';
RUN;
*/



/*
DATA TierCheck;
SET final;
IF ClsFTETier NE ' ';
TITLE1 "Funding Tier Check 2";
PROC SORT NODUPKEY DATA=TierCheck; BY Course;
PROC PRINT data=TierCheck;
	VAR Course ADCClsAcadLevel ADCClsFundSources ClsFTETier;
PROC FREQ DATA=TierCheck;
	TABLES ADCClsFundSources;
run;
*/

/* this saves dataset to the H drive */
data &lb01 .&ds01&yt01&rp01;
set final;
run;

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

PROC PRINT DATA=Final; Where ClsFTETier EQ ' ';
RUN;

ODS markup tagset=chtml CLOSE;
*/

/*
PROC CONTENTS DATA=&lb02 .&ds02&yt02&rp02;
RUN;
*/
