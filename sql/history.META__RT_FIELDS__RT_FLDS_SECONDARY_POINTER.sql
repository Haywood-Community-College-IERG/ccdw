IF OBJECT_ID('history.[META__RT_FIELDS__RTFLDS_SECONDARY_POINTER]', 'V') IS NOT NULL
    DROP VIEW history.[META__RT_FIELDS__RTFLDS_SECONDARY_POINTER]
GO
CREATE VIEW [history].[META__RT_FIELDS__RTFLDS_SECONDARY_POINTER] AS        
SELECT [RT.FIELDS.ID]                                                                         
     , LTRIM(RTRIM(CA1.Item)) AS [RTFLDS.SECONDARY.POINTER]
     , CA1.ItemNumber AS ItemNumber                               
     , EffectiveDatetime                                    
  FROM [history].[META__RT_FIELDS]                    
                                                         
 CROSS APPLY dbo.DelimitedSplit8K([RTFLDS.SECONDARY.POINTER],', ') CA1
 WHERE COALESCE(TRIM([RTFLDS.SECONDARY.POINTER]),'') != ''   
                                                    
GO                                                
                                             