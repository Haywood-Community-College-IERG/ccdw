IF OBJECT_ID('local.StudentCreditsAndStatus', 'V') IS NOT NULL
    DROP VIEW local.StudentCreditsAndStatus
GO

CREATE VIEW local.StudentCreditsAndStatus AS
WITH creds AS (
    SELECT [STC.PERSON.ID] 
         , [STC.TERM]
         , SUM(CAST([X.808.DEV.CRED] AS DECIMAL(5,2))) AS [Developmental Credits]
         , SUM([STC.CRED]) AS Credits
         , SUM([STC.CMPL.CRED]) AS [Completed Credits]
      FROM history.STUDENT_ACAD_CRED_Current
     WHERE [STC.STATUS] IN ('A', 'N', 'W')
    GROUP BY [STC.PERSON.ID], [STC.TERM]
)
SELECT [STC.PERSON.ID] AS Student_ID
     , [STC.TERM] AS Term_ID
     , [Developmental Credits]
     , Credits
     , [Completed Credits]
     , CASE WHEN Credits >= 12 THEN 'Full-Time'
            WHEN Credits >   0 THEN 'Part-Time'
            ELSE 'Not Enrolled' END AS [Enrollment Status - Census]
     , CASE WHEN [Completed Credits] >= 12 THEN 'Full-Time'
            WHEN [Completed Credits] >   0 THEN 'Part-Time'
            ELSE 'Not Enrolled' END AS [Enrollment Status - EOT]
  FROM creds