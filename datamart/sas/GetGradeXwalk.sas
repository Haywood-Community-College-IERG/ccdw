PROC IMPORT OUT= STU6.GRADESCHEMAXWALK 
            DATAFILE= "L:\IERG\Data\DataMart\A_XNC_Colleague\Downloa
ds\GradeSchemeCrosswalk.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;
