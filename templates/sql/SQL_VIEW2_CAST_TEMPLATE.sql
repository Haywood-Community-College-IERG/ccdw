
, CAST(CASE WHEN LTRIM(RTRIM(COALESCE(CA${Counter}.Item,''))) = '' THEN NULL ELSE LTRIM(RTRIM(CA${Counter}.Item)) END ${ItemType}) AS [${ElementAssociationKey}]