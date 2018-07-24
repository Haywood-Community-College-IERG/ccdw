$filename = $args[0]

# Grab an arbitrary csv file 
$csv = Import-Csv $filename 
 
# create an empty hash for column lengths 
$colLen=@{} 
 
# Process each column by name 
foreach ($colName in $( ($csv | gm -MemberType NoteProperty).name ) ) 
{ 
    $colLen[$colName ]=($csv.$colName  | Measure-Object -Maximum -Property length).maximum 
} 

# Display the final hash table 
$colLen.GetEnumerator() | sort -Property Name