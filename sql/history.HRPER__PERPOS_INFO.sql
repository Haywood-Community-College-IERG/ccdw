IF OBJECT_ID('[history].[HRPER__PERPOS_INFO]', 'V') IS NOT NULL
    DROP VIEW [history].[HRPER__PERPOS_INFO]
GO

CREATE VIEW [history].[HRPER__PERPOS_INFO] AS  
    SELECT [HRPER.ID]

        , CAST(CASE WHEN COALESCE(LTRIM(RTRIM(CA1.Item)),'') = '' THEN NULL 
                     ELSE LTRIM(RTRIM(CA1.Item)) END AS DATE) AS [HRP.PERPOS.END.DATE]
        , CAST(CASE WHEN COALESCE(LTRIM(RTRIM(CA2.Item)),'') = '' THEN NULL 
                     ELSE LTRIM(RTRIM(CA2.Item)) END AS DATE) AS [HRP.PERPOS.LAST.PAY.DATE]
        , CAST(CASE WHEN COALESCE(LTRIM(RTRIM(CA3.Item)),'') = '' THEN NULL 
                     ELSE LTRIM(RTRIM(CA3.Item)) END AS DATE) AS [HRP.PERPOS.START.DATE]

        , CA1.ItemNumber AS ItemNumber
        , EffectiveDatetime
    FROM            [history].[HRPER] 
    CROSS APPLY dbo.DelimitedSplit8K([HRP.PERPOS.END.DATE], ', ') CA1
    CROSS APPLY dbo.DelimitedSplit8K([HRP.PERPOS.LAST.PAY.DATE], ', ') CA2
    CROSS APPLY dbo.DelimitedSplit8K([HRP.PERPOS.START.DATE], ', ') CA3
    WHERE        COALESCE ([HRP.PERPOS.START.DATE], '') != ''
    AND CA1.ItemNumber = CA2.ItemNumber
    AND CA1.ItemNumber = CA3.ItemNumber
