IF OBJECT_ID('[history].[META__CF_VALCODES__VALS]', 'V') IS NOT NULL
    DROP VIEW [history].[META__CF_VALCODES__VALS]
GO

CREATE VIEW [history].[META__CF_VALCODES__VALS] AS  
    SELECT [VALCODE.ID]

        , CASE WHEN COALESCE (LTRIM(RTRIM(CA1.Item)), '') = '' THEN NULL ELSE LTRIM(RTRIM(CA1.Item)) END AS [VAL.INTERNAL.CODE]
        , CASE WHEN COALESCE (LTRIM(RTRIM(CA2.Item)), '') = '' THEN NULL ELSE LTRIM(RTRIM(CA2.Item)) END AS [VAL.EXTERNAL.REPRESENTATION]
        , CASE WHEN COALESCE (LTRIM(RTRIM(CA3.Item)), '') = '' THEN NULL ELSE LTRIM(RTRIM(CA3.Item)) END AS [VAL.MINIMUM.INPUT.STRING]

        , CASE WHEN COALESCE (LTRIM(RTRIM(CA4.Item)), '') = '' THEN NULL ELSE LTRIM(RTRIM(CA4.Item)) END AS [VAL.ACTION.CODE.1]
        , CASE WHEN COALESCE (LTRIM(RTRIM(CA5.Item)), '') = '' THEN NULL ELSE LTRIM(RTRIM(CA5.Item)) END AS [VAL.ACTION.CODE.2]
        , CASE WHEN COALESCE (LTRIM(RTRIM(CA6.Item)), '') = '' THEN NULL ELSE LTRIM(RTRIM(CA6.Item)) END AS [VAL.ACTION.CODE.3]
        , CASE WHEN COALESCE (LTRIM(RTRIM(CA7.Item)), '') = '' THEN NULL ELSE LTRIM(RTRIM(CA7.Item)) END AS [VAL.ACTION.CODE.4]

        , CA1.ItemNumber AS ItemNumber
        , EffectiveDatetime
    FROM            [history].[META__CF_VALCODES] 
    CROSS APPLY dbo.DelimitedSplit8K([VAL.INTERNAL.CODE], ', ') CA1
    CROSS APPLY dbo.DelimitedSplit8K([VAL.EXTERNAL.REPRESENTATION], ', ') CA2
    CROSS APPLY dbo.DelimitedSplit8K([VAL.MINIMUM.INPUT.STRING], ', ') CA3

    CROSS APPLY dbo.DelimitedSplit8K([VAL.ACTION.CODE.1], ', ') CA4
    CROSS APPLY dbo.DelimitedSplit8K([VAL.ACTION.CODE.2], ', ') CA5 
    CROSS APPLY dbo.DelimitedSplit8K([VAL.ACTION.CODE.3], ', ') CA6 
    CROSS APPLY dbo.DelimitedSplit8K([VAL.ACTION.CODE.4], ', ') CA7
    WHERE        COALESCE ([VAL.INTERNAL.CODE], '') != '' 
    AND CA1.ItemNumber = CA2.ItemNumber
    AND CA1.ItemNumber = CA3.ItemNumber

    AND (CASE WHEN COALESCE(CA4.Item,'')='' THEN 1 
             ELSE (CASE WHEN CA1.ItemNumber = CA4.ItemNumber THEN 1 
                        ELSE 0 END) END) = 1
    AND (CASE WHEN COALESCE(CA5.Item,'')='' THEN 1 
             ELSE (CASE WHEN CA1.ItemNumber = CA5.ItemNumber THEN 1 
                        ELSE 0 END) END) = 1
    AND (CASE WHEN COALESCE(CA6.Item,'')='' THEN 1 
             ELSE (CASE WHEN CA1.ItemNumber = CA6.ItemNumber THEN 1 
                        ELSE 0 END) END) = 1
    AND (CASE WHEN COALESCE(CA7.Item,'')='' THEN 1 
             ELSE (CASE WHEN CA1.ItemNumber = CA7.ItemNumber THEN 1 
                        ELSE 0 END) END) = 1
    ;