IF OBJECT_ID('[history].[HRPER__STATUS_DATES]', 'V') IS NOT NULL
    DROP VIEW [history].[HRPER__STATUS_DATES]
GO

CREATE VIEW [history].[HRPER__STATUS_DATES] AS  
    SELECT [HRPER.ID]

        , CAST(CASE WHEN COALESCE(LTRIM(RTRIM(CA1.Item)),'') = '' THEN NULL 
                     ELSE LTRIM(RTRIM(CA1.Item)) END AS DATE) AS [HRP.PERSTAT.START.DATE]
        , CAST(CASE WHEN COALESCE(LTRIM(RTRIM(CA2.Item)),'') = '' THEN NULL 
                     ELSE LTRIM(RTRIM(CA2.Item)) END AS DATE) AS [HRP.PERSTAT.END.DATE]

        , CA1.ItemNumber AS ItemNumber
        , EffectiveDatetime
    FROM            [history].[HRPER] 
    CROSS APPLY dbo.DelimitedSplit8K([HRP.PERSTAT.START.DATE], ', ') CA1
    CROSS APPLY dbo.DelimitedSplit8K([HRP.PERSTAT.END.DATE], ', ') CA2
    WHERE        COALESCE ([HRP.PERSTAT.START.DATE], '') != ''
    AND CA1.ItemNumber = CA2.ItemNumber
;