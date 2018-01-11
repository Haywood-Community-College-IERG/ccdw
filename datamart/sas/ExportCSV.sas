* PROC EXPORT DATA= TMP2.Grad201303
*             OUTFILE= "L:\IERG\Data\DataMart\A_XNC_Colleague\Downloads\SASDatasets\03_Graduate\grad201303.csv" 
*             DBMS=CSV REPLACE;
*      PUTNAMES=YES;
* RUN;



LIBNAME DAT01 "L:\IERG\Data\DataMart\Sample\SAS Data Mart Training - CCPRO 2017\A_XNC_Datatel\Downloads\SASDatasets\00_All";
LIBNAME DAT02 "L:\IERG\Data\DataMart\Sample\SAS Data Mart Training - CCPRO 2017\A_XNC_Datatel\Downloads\SASDatasets\01_Class";
LIBNAME DAT03 "L:\IERG\Data\DataMart\Sample\SAS Data Mart Training - CCPRO 2017\A_XNC_Datatel\Downloads\SASDatasets\02_Student";
LIBNAME DAT04 "L:\IERG\Data\DataMart\Sample\SAS Data Mart Training - CCPRO 2017\A_XNC_Datatel\Downloads\SASDatasets\03_Graduate";
LIBNAME DAT05 "L:\IERG\Data\DataMart\Sample\SAS Data Mart Training - CCPRO 2017\A_XNC_Datatel\Downloads\SASDatasets\04_TransferCredits";
LIBNAME DAT06 "L:\IERG\Data\DataMart\Sample\SAS Data Mart Training - CCPRO 2017\A_XNC_Datatel\Downloads\SASDatasets\06_FinAidISIR";
LIBNAME DAT07 "L:\IERG\Data\DataMart\Sample\SAS Data Mart Training - CCPRO 2017\A_XNC_Datatel\Downloads\SASDatasets\07_FinAidDisbursement";
LIBNAME DAT08 "L:\IERG\Data\DataMart\Sample\SAS Data Mart Training - CCPRO 2017\A_XNC_Datatel\Downloads\SASDatasets\08_FinAidSponsorship";
LIBNAME DAT09 "L:\IERG\Data\DataMart\Sample\SAS Data Mart Training - CCPRO 2017\A_XNC_Datatel\Downloads\SASDatasets\10_HR";
LIBNAME DAT10 "L:\IERG\Data\DataMart\Sample\SAS Data Mart Training - CCPRO 2017\A_XNC_Datatel\Downloads\SASDatasets\15_Cohort";
LIBNAME DAT11 "L:\IERG\Data\DataMart\Sample\SAS Data Mart Training - CCPRO 2017\A_XNC_Datatel\Downloads\SASDatasets\99_Crosswalks";

%macro export(inlib,intbl,outpath,outfile);
    %LOG("Processing &outfile...")
    PROC EXPORT DATA=&inlib..&intbl
                OUTFILE="&outpath\&outfile..csv" 
                DBMS=CSV LABEL REPLACE;
         PUTNAMES=YES;
    RUN;
%mend;

%LET outpath=L:\IERG\Data\DataMart\Sample\SAS Data Mart Training - CCPRO 2017\A_XNC_Datatel\Downloads\CSVs;
data _null_;
  set sashelp.vstable (where=(libname LIKE 'DAT%'));

  length cmd $ 1000;
  cmd=cats('%export(',libname,',',memname,',','&outpath',',',memname,')');
  call execute(cmd);
run;
