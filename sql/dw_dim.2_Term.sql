IF OBJECT_ID('dw_dim.Term', 'V') IS NOT NULL
    DROP VIEW dw_dim.Term
GO

CREATE VIEW dw_dim.Term AS
SELECT [Term_ID]
      ,[Term_ID_Numeric]
      ,[Term_Abbreviation]
      ,[Term_Type]
      ,[Term_Index]
      ,[Term_Sort]
      ,[Term_Start_Date]
      ,[Term_Start_Date_Key]
      ,[Term_End_Date]
      ,[Term_End_Date_Key]
      ,[Term_Name]
      ,[Academic_Year]
      ,[Academic_Year_Start_Date]
      ,[Academic_Year_Start_Date_Key]
      ,[Academic_Year_End_Date]
      ,[Academic_Year_End_Date_Key]
      ,[Reporting_Academic_Year]                 /* 2018-07-31 DMO A */
      ,[Reporting_Academic_Year_Start_Date]      /* 2018-07-31 DMO A */
      ,[Reporting_Academic_Year_Start_Date_Key]  /* 2018-07-31 DMO A */
      ,[Reporting_Academic_Year_End_Date]        /* 2018-07-31 DMO A */
      ,[Reporting_Academic_Year_End_Date_Key]    /* 2018-07-31 DMO A */
      ,[Reporting_Academic_Year_FSS]                 /* 2019-09-12 DMO A */
      ,[Reporting_Academic_Year_FSS_Start_Date]      /* 2019-09-12 DMO A */
      ,[Reporting_Academic_Year_FSS_Start_Date_Key]  /* 2019-09-12 DMO A */
      ,[Reporting_Academic_Year_FSS_End_Date]        /* 2019-09-12 DMO A */
      ,[Reporting_Academic_Year_FSS_End_Date_Key]    /* 2019-09-12 DMO A */
      ,[Fiscal_Academic_Year]
      ,[YYYY]
      ,[Year_Num]
	  ,[Reporting_Year]                          /* 2018-07-31 DMO A */
	  ,[Reporting_Year_FSS]                      /* 2019-09-12 DMO A */
      ,[Semester]
      ,[Term_Census_Date]
      ,[Term_Census_Date_Key]
      ,[Term_Census_Date_Calculated]
      ,[Previous_Term_ID]
      ,[Previous_Term_Start_Date]
      ,[Previous_Term_Start_Date_Key]
      ,[Previous_Term_End_Date]
      ,[Previous_Term_End_Date_Key]
      ,[Previous_Regular_Term_ID]
      ,[Previous_Summer_Term_ID]
      ,[Next_Term_ID]
      ,[Next_Term_Start_Date]
      ,[Next_Term_Start_Date_Key]
      ,[Next_Term_End_Date]
      ,[Next_Term_End_Date_Key]
      ,[Next_Regular_Term_ID]
      ,[Next_Summer_Term_ID]
      ,[Same_Term_ID_Last_Year]
      ,[Same_Term_ID_Next_Year]
      ,[Corresponding_Term]
      ,[Term_Index_2]
  FROM dw_dim.Term_CU
UNION
SELECT [Term_ID]
      ,[Term_ID_Numeric]
      ,[Term_Abbreviation]
      ,[Term_Type]
      ,[Term_Index]
      ,[Term_Sort]
      ,[Term_Start_Date]
      ,[Term_Start_Date_Key]
      ,[Term_End_Date]
      ,[Term_End_Date_Key]
      ,[Term_Name]
      ,[Academic_Year]
      ,[Academic_Year_Start_Date]
      ,[Academic_Year_Start_Date_Key]
      ,[Academic_Year_End_Date]
      ,[Academic_Year_End_Date_Key]
      ,[Reporting_Academic_Year]                 /* 2018-07-31 DMO A */
      ,[Reporting_Academic_Year_Start_Date]      /* 2018-07-31 DMO A */
      ,[Reporting_Academic_Year_Start_Date_Key]  /* 2018-07-31 DMO A */
      ,[Reporting_Academic_Year_End_Date]        /* 2018-07-31 DMO A */
      ,[Reporting_Academic_Year_End_Date_Key]    /* 2018-07-31 DMO A */
      ,[Reporting_Academic_Year_FSS]                 /* 2019-09-12 DMO A */
      ,[Reporting_Academic_Year_FSS_Start_Date]      /* 2019-09-12 DMO A */
      ,[Reporting_Academic_Year_FSS_Start_Date_Key]  /* 2019-09-12 DMO A */
      ,[Reporting_Academic_Year_FSS_End_Date]        /* 2019-09-12 DMO A */
      ,[Reporting_Academic_Year_FSS_End_Date_Key]    /* 2019-09-12 DMO A */
	  ,[Fiscal_Academic_Year]                    /* 2018-07-31 DMO U */
      ,[YYYY]
      ,[Year_Num]
	  ,[Reporting_Year]                          /* 2018-07-31 DMO A */
	  ,[Reporting_Year_FSS]                      /* 2019-09-12 DMO A */
      ,[Semester]
      ,[Term_Census_Date]
      ,[Term_Census_Date_Key]
      ,[Term_Census_Date_Calculated]
      ,[Previous_Term_ID]
      ,[Previous_Term_Start_Date]
      ,[Previous_Term_Start_Date_Key]
      ,[Previous_Term_End_Date]
      ,[Previous_Term_End_Date_Key]
      ,[Previous_Regular_Term_ID]
      ,[Previous_Summer_Term_ID]
      ,[Next_Term_ID]
      ,[Next_Term_Start_Date]
      ,[Next_Term_Start_Date_Key]
      ,[Next_Term_End_Date]
      ,[Next_Term_End_Date_Key]
      ,[Next_Regular_Term_ID]
      ,[Next_Summer_Term_ID]
      ,[Same_Term_ID_Last_Year]
      ,[Same_Term_ID_Next_Year]
      ,[Corresponding_Term]
      ,[Term_Index_2]
  FROM dw_dim.Term_CE