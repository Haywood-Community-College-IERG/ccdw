UPDATE [${Audit_Schema}].[${Audit_Table_Name}] 
   SET Records_Modified = ${Records_Modified}
     , Load_End_Datetime = ${Load_End_Datetime}
     , Load_Error_Indicator = '${Load_Error_Indicator}'
 WHERE Audit_Key = ${Audit_Key}