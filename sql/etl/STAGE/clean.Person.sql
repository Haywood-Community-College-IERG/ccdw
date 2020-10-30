USE CCDW_STAGE
GO

IF OBJECT_ID('clean.Person', 'V') IS NOT NULL
    DROP VIEW clean.Person
GO

CREATE VIEW clean.Person AS
WITH vals AS (
    SELECT vv.[VALCODE.ID] AS Val_ID, vv.[VAL.INTERNAL.CODE] AS Val_Code, vv.[VAL.EXTERNAL.REPRESENTATION] AS Val_Description
      FROM CCDW_HIST.history.META__CORE_VALCODES_Current v
     INNER JOIN CCDW_HIST.history.META__ALL_VALCODES__VALS vv
           ON vv.[VALCODE.ID] = v.[VALCODE.ID]
           AND vv.EffectiveDatetime = v.EffectiveDatetime 
), alien_vals AS (
    SELECT Val_Code AS Alien_Status_Code, Val_Description AS Alien_Status FROM vals
     WHERE Val_ID = 'ALIEN.STATUSES'
), directory_vals AS (
    SELECT Val_Code AS [Directory Flag Code], Val_Description AS [Directory Flag] FROM vals
     WHERE Val_ID = 'DIRECTORY.CODES'
     UNION
     SELECT 'NS', 'Not Specified'
), privacy_vals AS (
    SELECT Val_Code AS [Privacy Flag Code], Val_Description AS [Privacy Flag] FROM vals
     WHERE Val_ID = 'PRIVACY.CODES'
     UNION
     SELECT 'NS', 'Not Specified'
), veteran_vals AS (
    SELECT Val_Code AS [Veteran Code], Val_Description AS [Veteran Type] FROM vals
     WHERE Val_ID = 'VETERAN.TYPES'
     UNION
     SELECT 'NS', 'Not Specified'
), counties AS (
    SELECT c.[COUNTIES.ID] AS [County Code], c.[CNTY.DESC] AS [County Name] FROM CCDW_HIST.history.COUNTIES_Current c 
    UNION
    SELECT '998', 'Out of State - Unknown'
    UNION
    SELECT '999', 'Unknown'
), states AS (
    SELECT s.ID AS [State Code], s.[ST.DESC] AS [State Name] FROM CCDW_HIST.history.STATES_Current s
    UNION
    SELECT 'UNK', 'Unknown'
),countries AS (
    SELECT c.[COUNTRIES.ID] AS [Country Code], c.[CTRY.DESC] AS [Country Name], c.[CTRY.ISO.CODE] AS [Country ISO Code] FROM CCDW_HIST.history.COUNTRIES_Current c
    UNION
    SELECT 'UNK', 'Unknown', 'UNK'
), veteran_types AS (
    SELECT pv.ID
         , pv.EffectiveDatetime
         , STRING_AGG(pv.[VETERAN.TYPE],', ') WITHIN GROUP (ORDER BY pv.ItemNumber) AS [Veteran Type Code]
         , STRING_AGG(veteran_vals.[Veteran Type], ', ') WITHIN GROUP (ORDER BY pv.ItemNumber) AS [Veteran Type]
      FROM CCDW_HIST.history.PERSON__VETERAN_ASSOC pv 
      LEFT JOIN veteran_vals
           ON veteran_vals.[Veteran Code] = pv.[VETERAN.TYPE]
     GROUP BY pv.ID, pv.EffectiveDatetime
), Clean_Data_P AS ( 
    SELECT t.ID
        , CASE WHEN COALESCE(RTRIM(LTRIM(t.[FIRST.NAME])),'') = '' THEN NULL ELSE t.[FIRST.NAME] END AS [FIRST.NAME]
        , CASE WHEN COALESCE(RTRIM(LTRIM(t.[MIDDLE.NAME])),'') = '' THEN NULL ELSE t.[MIDDLE.NAME] END AS [MIDDLE.NAME]
        , CASE WHEN COALESCE(RTRIM(LTRIM(t.[LAST.NAME])),'') = '' THEN NULL ELSE t.[LAST.NAME] END AS [LAST.NAME]
        , CASE WHEN COALESCE(RTRIM(LTRIM(t.[SUFFIX])),'') = '' THEN NULL
               WHEN RTRIM(LTRIM(t.SUFFIX)) = 'JR' THEN 'Jr'
               WHEN RTRIM(LTRIM(t.SUFFIX)) LIKE '%.' THEN SUBSTRING(RTRIM(LTRIM(t.SUFFIX)),1,LEN(RTRIM(LTRIM(t.SUFFIX)))-1)
               ELSE RTRIM(LTRIM(t.SUFFIX)) END AS [SUFFIX]
        , COALESCE(t.[BIRTH.DATE],CAST('9999-12-31' AS DATE)) AS [BIRTH.DATE]
        , COALESCE(t.[DECEASED.DATE],CAST('9999-12-31' AS DATE)) AS [DECEASED.DATE]
        , CASE WHEN COALESCE(RTRIM(LTRIM(t.[GENDER])),'') = '' THEN '' ELSE t.[GENDER] END AS [GENDER]
        , CASE WHEN COALESCE(RTRIM(LTRIM(t.[MARITAL.STATUS])),'') = '' THEN '' ELSE t.[MARITAL.STATUS] END AS [MARITAL.STATUS]
        , CASE WHEN COALESCE(RTRIM(LTRIM(t.[PER.PRI.ETHNIC])),'') = '' THEN 'UNK' ELSE t.[PER.PRI.ETHNIC] END AS [PER.PRI.ETHNIC]
        , CASE WHEN COALESCE(RTRIM(LTRIM(t.[ETHNIC])),'') = '' THEN '6' ELSE t.[ETHNIC] END AS [ETHNIC]
        , CASE WHEN COALESCE(RTRIM(LTRIM(t.[PER.ETHNICS])),'') = '' THEN 'UNK' ELSE t.[PER.ETHNICS] END AS [PER.ETHNICS]
        , CASE WHEN COALESCE(RTRIM(LTRIM(t.[PER.PRI.RACE])),'') = '' THEN 'UNK' ELSE t.[PER.PRI.RACE] END AS [PER.PRI.RACE]
        , CASE WHEN COALESCE(RTRIM(LTRIM(t.[PER.RACES])),'') = '' THEN 'UNK' ELSE t.[PER.RACES] END AS [PER.RACES]
        , CASE WHEN COALESCE(RTRIM(LTRIM(t.[X.ETHNICS.RACES])),'') = '' THEN 'UNK' ELSE t.[X.ETHNICS.RACES] END AS [X.ETHNICS.RACES]
        , CASE WHEN COALESCE(RTRIM(LTRIM(t.[ADDRESS.LINES])),'') = '' THEN NULL ELSE t.[ADDRESS.LINES] END AS [ADDRESS.LINES]
        , CASE WHEN COALESCE(RTRIM(LTRIM(t.[ADDR.TYPE])),'') = '' THEN NULL ELSE t.[ADDR.TYPE] END AS [ADDR.TYPE]
        , CASE WHEN COALESCE(RTRIM(LTRIM(t.[CITY])),'') = '' THEN 'Unknown' ELSE t.[CITY] END AS [CITY]
        , CASE WHEN COALESCE(RTRIM(LTRIM(t.[STATE])),'') = '' THEN 'UNK' ELSE t.[STATE] END AS [STATE]
        , CASE WHEN COALESCE(RTRIM(LTRIM(t.[ZIP])),'') = '' THEN '99999' ELSE t.[ZIP] END AS ZIP
        , CASE WHEN COALESCE(RTRIM(LTRIM(t.[RESIDENCE.COUNTY])),'') = '' THEN 
                    CASE WHEN t.[STATE] IS NULL THEN '999' 
                         WHEN t.[STATE] = 'NC' THEN '000'
                         ELSE '998' END 
                ELSE t.[RESIDENCE.COUNTY] END AS [RESIDENCE.COUNTY]
        , CASE WHEN COALESCE(RTRIM(LTRIM(t.[RESIDENCE.STATE])),'') = '' THEN 
                    CASE WHEN t.[STATE] IS NULL THEN 'UNK' 
                         ELSE t.[STATE] END 
                ELSE t.[RESIDENCE.STATE] END AS [RESIDENCE.STATE]
        , CASE WHEN COALESCE(RTRIM(LTRIM(t.[RESIDENCE.COUNTRY])),'') = '' THEN 
                    CASE WHEN t.[STATE] IS NULL THEN 'UNK' 
                         WHEN t.[STATE] IN ('AB','BC','MB','NB','NS','NT','ON','PE','QC','SK','YT') THEN 'CA'
                         WHEN t.[STATE] IN ('AS','FM','GU','MH','MP','NF','PR','PW','VI') THEN t.[STATE]
                         WHEN t.[STATE] IN ('CZ','NU','OF') THEN 'UNK'
                         ELSE 'US' END
               ELSE t.[RESIDENCE.COUNTRY] END AS [RESIDENCE.COUNTRY]
        , CASE WHEN COALESCE(RTRIM(LTRIM(t.[VETERAN.TYPE])),'') = '' THEN 'NS' ELSE t.[VETERAN.TYPE] END AS [VETERAN.TYPE]
        , CASE WHEN COALESCE(RTRIM(LTRIM(t.[PERSON.EMAIL.ADDRESSES])),'') = '' THEN NULL ELSE t.[PERSON.EMAIL.ADDRESSES] END AS [PERSON.EMAIL.ADDRESSES]
        , CASE WHEN COALESCE(RTRIM(LTRIM(t.[PERSON.EMAIL.TYPES])),'') = '' THEN NULL ELSE t.[PERSON.EMAIL.TYPES] END AS [PERSON.EMAIL.TYPES]
        , CASE WHEN COALESCE(RTRIM(LTRIM(t.[PRIVACY.FLAG])),'') = '' THEN 'NS' ELSE t.[PRIVACY.FLAG] END AS [PRIVACY.FLAG]
        , CASE WHEN COALESCE(RTRIM(LTRIM(t.[DIRECTORY.FLAG])),'') = '' THEN 'NS' ELSE t.[DIRECTORY.FLAG] END AS [DIRECTORY.FLAG]
        , t.EffectiveDatetime
        , CAST(t.EffectiveDatetime AS DATE) AS EffectiveDate
        , COALESCE(t.ExpirationDatetime,CAST('9999-12-31' AS DATE)) AS ExpirationDatetime
        , COALESCE(CAST(t.ExpirationDatetime AS DATE),CAST('9999-12-31' AS DATE)) AS ExpirationDate        
        , t.CurrentFlag
    FROM CCDW_HIST.history.PERSON t 
    LEFT JOIN CCDW_HIST.history.COUNTIES_Current county
         ON county.[COUNTIES.ID] = t.[RESIDENCE.COUNTY]
    LEFT JOIN CCDW_HIST.history.COUNTRIES_Current country
         ON country.[COUNTRIES.ID] = t.[RESIDENCE.COUNTRY]
), FP AS (
    SELECT t.[FOREIGN.PERSON.ID] AS ID 
         , t.[FPER.ALIEN.STATUS]
         , t.EffectiveDatetime
         , CAST(t.EffectiveDatetime AS DATE) AS EffectiveDate
         , COALESCE(t.ExpirationDatetime,CAST('9999-12-31' AS DATE)) AS ExpirationDatetime
         , COALESCE(CAST(t.ExpirationDatetime AS DATE),CAST('9999-12-31' AS DATE)) AS ExpirationDate        
         , t.CurrentFlag
      FROM CCDW_HIST.history.FOREIGN_PERSON t
), FP_Min AS (
    SELECT ID
         , NULL AS [FPER.ALIEN.STATUS]
         , CAST('1800-01-01' AS DATETIME) AS EffectiveDatetime
         , MIN(EffectiveDatetime) OVER(PARTITION BY ID) AS ExpirationDatetime
         , 'N' AS CurrentFlag
      FROM FP
), Clean_Data_FP AS (
    SELECT t.ID 
         , t.[FPER.ALIEN.STATUS]
         , t.EffectiveDatetime
         , CAST(t.EffectiveDatetime AS DATE) AS EffectiveDate
         , COALESCE(t.ExpirationDatetime,CAST('9999-12-31' AS DATE)) AS ExpirationDatetime
         , COALESCE(CAST(t.ExpirationDatetime AS DATE),CAST('9999-12-31' AS DATE)) AS ExpirationDate        
         , t.CurrentFlag
      FROM FP_Min t
    UNION 
    SELECT *
      FROM FP
    UNION
    SELECT P.ID
         , NULL AS [FPER.ALIEN.STATUS]
         , CAST('1800-01-01' AS DATETIME) AS EffectiveDatetime
         , CAST('1800-01-01' AS DATE) AS EffectiveDate
         , CAST('9999-12-31' AS DATETIME) AS ExpirationDatetime
         , CAST('9999-12-31' AS DATE) AS ExpirationDate
         , 'Y' AS CurrentFlag
      FROM (SELECT DISTINCT ID FROM Clean_Data_P WHERE ID NOT IN (SELECT DISTINCT ID FROM FP)) P
), FP_ALIEN_STATUS AS (
    SELECT p.ID
    FROM Clean_Data_P p
    LEFT JOIN Clean_Data_FP fp 
        ON fp.ID = p.ID
)
, P AS (
    SELECT p.ID
         , CASE WHEN p.[GENDER] = 'M' THEN 'Mr.'
                WHEN p.[GENDER] = 'F' THEN 'Ms.'
                ELSE '' END AS [Prefix]
         , COALESCE(RTRIM(LTRIM(p.[FIRST.NAME])),'') AS [First Name]
         , COALESCE(RTRIM(LTRIM(p.[MIDDLE.NAME])),'') AS [Middle Name]
         , COALESCE(RTRIM(LTRIM(p.[LAST.NAME])),'') AS [Last Name]
         , COALESCE(RTRIM(LTRIM(p.[SUFFIX])),'') AS [Suffix]
         , CONCAT_WS(' ', p.[FIRST.NAME], p.[LAST.NAME]) AS [First and Last Name]
         , CONCAT_WS(' ', p.[FIRST.NAME], p.[MIDDLE.NAME], p.[LAST.NAME]) AS [First, Middle, and Last Name]
         , CONCAT_WS(' ', p.[FIRST.NAME], SUBSTRING(p.[MIDDLE.NAME],1,1), p.[LAST.NAME]) AS [First, Middle Initial, and Last Name]
         , CONCAT_WS(', ', p.[LAST.NAME], CASE WHEN CONCAT_WS(' ', p.[FIRST.NAME], p.[MIDDLE.NAME]) = '' THEN NULL ELSE CONCAT_WS(' ', p.[FIRST.NAME], p.[MIDDLE.NAME]) END) AS [Last, First, and Middle Name]
         , CONCAT_WS(', ', p.[LAST.NAME], p.[FIRST.NAME]) AS [Last and First Name]
         , CONCAT(SUBSTRING(p.[FIRST.NAME],1,1), SUBSTRING(p.[MIDDLE.NAME],1,1), SUBSTRING(p.[LAST.NAME],1,1)) AS [First, Middle, and Last Initials]
         , CONCAT(SUBSTRING(p.[LAST.NAME],1,1), SUBSTRING(p.[FIRST.NAME],1,1), SUBSTRING(p.[MIDDLE.NAME],1,1)) AS [Last, First, and Middle Initials]
         , SUBSTRING(RTRIM(LTRIM(COALESCE(p.[FIRST.NAME],''))),1,1) AS [First Initial]
         , SUBSTRING(RTRIM(LTRIM(COALESCE(p.[LAST.NAME],''))),1,1) AS [Last Initial]
         , SUBSTRING(RTRIM(LTRIM(COALESCE(p.[MIDDLE.NAME],''))),1,1) AS [Middle Initial]
         , p.[GENDER] AS [Gender]

         , p.[BIRTH.DATE] AS [Birth Date]
         , p.[DECEASED.DATE] AS [Deceased Date]

         , p.[PER.ETHNICS] AS [Ethnicity Code]
         , CASE WHEN p.[PER.ETHNICS] = 'HIS' THEN 'Hispanic/Latino'
                WHEN p.[PER.ETHNICS] = 'NHS' THEN 'Non Hispanic/Latino'
                ELSE 'Unknown' END AS Ethnicity

         , CASE WHEN CHARINDEX('AN', p.[PER.RACES]) > 0 THEN 'Yes' ELSE 'No' END AS [Race - American/Alaska Native]
         , CASE WHEN CHARINDEX('AS', p.[PER.RACES]) > 0 THEN 'Yes' ELSE 'No' END AS [Race - Asian]
         , CASE WHEN CHARINDEX('BL', p.[PER.RACES]) > 0 THEN 'Yes' ELSE 'No' END AS [Race - Black or African American]
         , CASE WHEN CHARINDEX('HP', p.[PER.RACES]) > 0 THEN 'Yes' ELSE 'No' END AS [Race - Hawaiian/Pacific Islander]
         , CASE WHEN CHARINDEX('NP', p.[PER.RACES]) > 0 THEN 'Yes' ELSE 'No' END AS [Race - Asian/Pacific Islander]
         , CASE WHEN CHARINDEX('WH', p.[PER.RACES]) > 0 THEN 'Yes' ELSE 'No' END AS [Race - White]

         , CASE WHEN CHARINDEX('AN', p.[PER.RACES]) = 0 AND
                     CHARINDEX('AS', p.[PER.RACES]) = 0 AND
                     CHARINDEX('BL', p.[PER.RACES]) = 0 AND
                     CHARINDEX('HP', p.[PER.RACES]) = 0 AND
                     CHARINDEX('NP', p.[PER.RACES]) = 0 AND
                     CHARINDEX('WH', p.[PER.RACES]) = 0 THEN 'Yes' ELSE 'No' END AS [Race - Unknown]

         , CASE WHEN CHARINDEX(',', p.[PER.RACES]) > 0 THEN 'Yes' ELSE 'No' END AS [Race - Multiracial]

         , COALESCE(fp.[FPER.ALIEN.STATUS],'') AS [Alien Status Code]
         , COALESCE(alien_vals.Alien_Status,'') AS [Alien Status]

         , CASE WHEN COALESCE(fp.[FPER.ALIEN.STATUS],'') = 'Y' THEN 'Nonresident alien'
                WHEN COALESCE(fp.[FPER.ALIEN.STATUS],'') = 'U' THEN 'Unknown race and ethnicity'
                WHEN p.[PER.ETHNICS] = 'HIS' THEN 'Hispanic'
                WHEN CHARINDEX(',', p.[PER.RACES]) > 0 THEN 'Two or more races'
                WHEN CHARINDEX('AN', p.[PER.RACES]) > 0 THEN 'American Indian or Alaska Native'
                WHEN CHARINDEX('AS', p.[PER.RACES]) > 0 THEN 'Asian'
                WHEN CHARINDEX('BL', p.[PER.RACES]) > 0 THEN 'Black or African American'
                WHEN CHARINDEX('HP', p.[PER.RACES]) > 0 THEN 'Native Hawaiian or Other Pacific Islander'
                WHEN CHARINDEX('WH', p.[PER.RACES]) > 0 THEN 'White'
                ELSE 'Unknown race and ethnicity' END as [IPEDS Race Ethnicity]

         , [CITY] AS [City] 
         , [STATE] AS [State Abbreviation]
         , [ZIP] AS [Zip Code]
         , [RESIDENCE.COUNTY] AS [Residence - County Code]
         , residence_counties.[County Name] AS [Residence - County Name]
         , [RESIDENCE.STATE] AS [Residence - State Code]
         , residence_states.[State Name] AS [Residence - State Name]
         , [RESIDENCE.COUNTRY] AS [Residence - Country Code]
         , residence_countries.[Country Name] AS [Residence - Country Name]
         , residence_countries.[Country ISO Code] AS [Residence - Country ISO Code]

         , CASE WHEN [RESIDENCE.STATE] = 'NC' OR [RESIDENCE.COUNTY] <= '100' THEN 'In-State'
                WHEN [RESIDENCE.STATE] = 'UNK' THEN 'Unknown'
                ELSE 'Out-of-State' END AS [In- or Out-of-State]

         , [VETERAN.TYPE] AS [Veteran Type Codes]
         , veteran_types.[Veteran Type] AS [Veteran Types]
         , CASE WHEN veteran_types.[Veteran Type] IS NULL THEN 'No' ELSE 'Yes' END AS [Is Veteran]

         , privacy_vals.[Privacy Flag Code]
         , privacy_vals.[Privacy Flag]
         , directory_vals.[Directory Flag Code] 
         , directory_vals.[Directory Flag]

         , CASE WHEN fp.EffectiveDate <= p.EffectiveDate THEN
                     CASE WHEN fp.ExpirationDate <= p.EffectiveDate THEN NULL
                          WHEN fp.ExpirationDate = CAST('9999-12-31' AS DATE) AND p.ExpirationDate = CAST('9999-12-31' AS DATE) THEN p.EffectiveDatetime
                          WHEN fp.ExpirationDate = p.ExpirationDate THEN p.EffectiveDatetime
                          WHEN fp.ExpirationDate > p.EffectiveDate AND fp.ExpirationDate < p.ExpirationDate THEN p.EffectiveDatetime
                          ELSE -- fp.ExpirationDate > p.ExpirationDate 
                               p.EffectiveDatetime END
                ELSE -- fp.EffectiveDatetime > p.EffectiveDatetime
                     CASE WHEN fp.EffectiveDate < p.ExpirationDate THEN fp.EffectiveDatetime
                          ELSE -- fp.EffectiveDate < p.ExpirationDate
                               NULL END 
                END AS EffectiveDatetime_AS
         , CASE WHEN fp.EffectiveDate <= p.EffectiveDate THEN
                     CASE WHEN fp.ExpirationDate <= p.EffectiveDate THEN NULL
                          WHEN fp.ExpirationDate = CAST('9999-12-31' AS DATE) AND p.ExpirationDate = CAST('9999-12-31' AS DATE) THEN p.ExpirationDatetime
                          WHEN fp.ExpirationDate = p.ExpirationDate THEN p.ExpirationDatetime
                          WHEN fp.ExpirationDate > p.EffectiveDate AND fp.ExpirationDate < p.ExpirationDate THEN fp.ExpirationDatetime
                          ELSE -- fp.ExpirationDate > p.ExpirationDate 
                               p.ExpirationDatetime END
                ELSE -- fp.EffectiveDatetime > p.EffectiveDatetime
                     CASE WHEN fp.EffectiveDate < p.ExpirationDate THEN p.ExpirationDatetime
                          ELSE -- fp.EffectiveDate < p.ExpirationDate 
                               NULL END 
                END AS ExpirationDatetime_AS


      FROM Clean_Data_P p
      LEFT JOIN Clean_Data_FP fp 
           ON fp.ID = p.ID
      LEFT JOIN alien_vals
           ON alien_vals.Alien_Status_Code = fp.[FPER.ALIEN.STATUS] 
      LEFT JOIN privacy_vals
           ON privacy_vals.[Privacy Flag Code] = p.[PRIVACY.FLAG]
      LEFT JOIN directory_vals
           ON directory_vals.[Directory Flag Code] = p.[DIRECTORY.FLAG] 
      LEFT JOIN veteran_types
           ON veteran_types.[ID] = p.[ID]
           AND veteran_types.EffectiveDatetime = p.EffectiveDatetime 
      LEFT JOIN counties residence_counties
           ON residence_counties.[County Code] = p.[RESIDENCE.COUNTY]
      LEFT JOIN states 
           ON states.[State Code] = p.[STATE]
      LEFT JOIN states residence_states 
           ON residence_states.[State Code] = p.[RESIDENCE.STATE]
      LEFT JOIN countries residence_countries
           ON residence_countries.[Country Code] = p.[RESIDENCE.COUNTRY]
)
SELECT ID
     , [Prefix]
     , [First Name]
     , [Middle Name]
     , [Last Name]
     , [Suffix]
     , [First and Last Name]
     , [First, Middle, and Last Name]
     , [First, Middle Initial, and Last Name]
     , [Last, First, and Middle Name]
     , [Last and First Name]
     , [First, Middle, and Last Initials]
     , [Last, First, and Middle Initials]
     , [First Initial]
     , [Middle Initial]
     , [Last Initial]
     , [Gender]

     , [Birth Date]
     , [Deceased Date]

     , [Ethnicity Code]
     , Ethnicity

     , [Race - American/Alaska Native]
     , [Race - Asian]
     , [Race - Black or African American]
     , [Race - Hawaiian/Pacific Islander]
     , [Race - Asian/Pacific Islander]
     , [Race - White]

     , [Race - Unknown]

     , [Race - Multiracial]

     , [Alien Status Code]
     , [Alien Status]

     , [IPEDS Race Ethnicity]

     , [City] 
     , [State Abbreviation]
     , [Zip Code]
     , [Residence - County Code]
     , [Residence - County Name]
     , [Residence - State Code]
     , [Residence - State Name]
     , [Residence - Country Code]
     , [Residence - Country Name]
     , [Residence - Country ISO Code]

     , [In- or Out-of-State]

     , [Veteran Type Codes]
     , [Veteran Types]
     , [Is Veteran]

     , [Privacy Flag Code]
     , [Privacy Flag]
     , [Directory Flag Code] 
     , [Directory Flag]

     , EffectiveDatetime_AS AS EffectiveDatetime
     , ExpirationDatetime_AS AS ExpirationDatetime
     , CASE WHEN p.ExpirationDatetime_AS = CAST('9999-12-31' AS DATETIME) THEN 'Y' ELSE 'N' END AS CurrentFlag
  FROM P
 WHERE p.EffectiveDatetime_AS IS NOT NULL

