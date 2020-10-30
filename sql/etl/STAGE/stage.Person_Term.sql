/* *
USE CCDW_STAGE
GO

--
-- Need to create tables in stage for each of these
--

IF OBJECT_ID('stage.Person', 'V') IS NOT NULL
    DROP VIEW stage.Person_Term_Start
GO

CREATE VIEW stage.Person_Term_Start AS
-- */
WITH Terms AS (
    SELECT Term_ID
         , Term_Start_Date
      FROM CCDW_HIST.dw_dim.Term
), Person_TS AS (
    SELECT p.*, t.Term_ID
      FROM CCDW_STAGE.clean.Person p
      LEFT JOIN Terms t
           ON t.Term_Start_Date >= p.EffectiveDatetime
           AND t.Term_Start_Date <= p.ExpirationDatetime
)
SELECT *
  FROM Person_TS
GO

/* *
IF OBJECT_ID('stage.Person_Term_Census', 'V') IS NOT NULL
    DROP VIEW stage.Person_Term_Census
GO

CREATE VIEW stage.Person_Term_Census AS
-- */
WITH Terms AS (
    SELECT Term_ID
         , Term_Census_Date
      FROM CCDW_HIST.dw_dim.Term
), Person_TC AS (
    SELECT p.*, t.Term_ID
      FROM CCDW_STAGE.clean.Person p
      LEFT JOIN Terms t
           ON t.Term_Census_Date >= p.EffectiveDatetime
           AND t.Term_Census_Date <= p.ExpirationDatetime
)
SELECT *
  FROM Person_TC
GO

/* *
IF OBJECT_ID('stage.Person_Term_End_Date', 'V') IS NOT NULL
    DROP VIEW stage.Person_Term_End_Date
GO

CREATE VIEW stage.Person_Term_End_Date AS
-- */
WITH Terms AS (
    SELECT Term_ID
         , Term_End_Date
      FROM CCDW_HIST.dw_dim.Term
), Person_TE AS (
    SELECT p.*, t.Term_ID
      FROM CCDW_STAGE.clean.Person p
      LEFT JOIN Terms t
           ON t.Term_End_Date >= p.EffectiveDatetime
           AND t.Term_End_Date <= p.ExpirationDatetime
)
SELECT *
  FROM Person_TE
GO

/* *
IF OBJECT_ID('stage.Person_Current', 'V') IS NOT NULL
    DROP VIEW stage.Person_Current
GO

CREATE VIEW stage.Person_Current AS
-- */
SELECT p.*
  FROM CCDW_STAGE.clean.Person p
 WHERE p.CurrentFlag = 'Y'
GO
