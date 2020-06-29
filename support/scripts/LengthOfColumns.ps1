$filename = $args[0]

$dirpath = [System.IO.Path]::GetDirectoryName($filename)
$dirname = [System.IO.Path]::GetFileName($dirpath) + '.txt'

# Grab an arbitrary csv file 
$csv = Import-Csv $filename 
 
# create an empty hash for column lengths 
$colLen=@{} 
 
# Process each column by name 
foreach ($colName in $( ($csv | Get-Member -MemberType NoteProperty).name ) ) 
{ 
    $colLen[$colName ]=($csv.$colName  | Measure-Object -Maximum -Property length).maximum 
} 

# Display the final hash table 
$colLen.GetEnumerator() | Sort-Object -Property Name | Tee-Object $dirname