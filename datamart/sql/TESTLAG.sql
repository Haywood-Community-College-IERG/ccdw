WITH p1 AS (
    SELECT per.[ID]
          ,per.[GENDER]
          ,per_email.[PERSON.EMAIL.ADDRESSES]
          ,per_email.[PERSON.EMAIL.TYPES]
	  FROM   [history].[PERSON] per
	  LEFT JOIN history.PERSON__NAMEHIST per_name
		   ON (per_name.[ID] = per.[ID]
		      and per_name.EffectiveDatetime = per.EffectiveDatetime)
	  LEFT JOIN history.PERSON__PEOPLE_EMAIL per_email
           ON (per_email.[ID] = per.[ID]
               AND per_email.EffectiveDatetime = per.EffectiveDatetime)
      WHERE per.[EffectiveDatetime] <= '02/23/2018'
	    AND (per.[ExpirationDatetime] is null
	     OR [ExpirationDatetime] > '02/23/2018')

 ), p2 AS (
    SELECT p1.*, 
           LAG([ID]) OVER (ORDER BY [ID]) AS ID_LAG
      FROM p1
) 

        SELECT LEFT(CASE WHEN p2.ID <> p2.ID_LAG THEN p2.ID ELSE '' END + REPLICATE(' ',10), 10) +
               LEFT(CASE WHEN p2.ID <> p2.ID_LAG THEN p2.GENDER ELSE '' END + REPLICATE(' ',6), 6) +
               LEFT(COALESCE(p2.[PERSON.EMAIL.ADDRESSES],'') + REPLICATE(' ',50), 50) +
               LEFT(COALESCE(p2.[PERSON.EMAIL.TYPES],'') + REPLICATE(' ',11), 11)
        FROM p2 
