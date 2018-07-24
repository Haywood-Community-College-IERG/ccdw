# $csvin = Import-Csv -Path $fullpath -Header f1,f2,f3,f4,f5
# $csvin |%{$_.f4=$_.f4.replace(',',' ')}
# $csvin |ConvertTo-Csv -NoTypeInformation |Select-Object -Skip 1 |Set-Content -Path $fullpath
#
# ---  or  ---

filename = $args[0]

$data = Import-Csv $filename
$attrs = Get-Item $filename
$lastwrite = $attrs.LastWriteTime

$ColumnsToFix = @('INVI.CHARGE.AMT','INVI.CR.AMT','INVI.EXT.CR.AMT','INVI.GL.CR.AMTS','INVI.GL.DR.AMTS')
$columns = $data | Get-Member | where MemberType -eq NoteProperty | where Name -match ($ColumnsToFix -join '|') | % Name
$newdata = $data | %{
  foreach ($c in $columns) {
    $_.$c = $_.$c -replace ',',''
  }
}
$newdata | Export-Csv -Encoding UTF8 T/$filename
$attrs = Get-Item T/$filename
$attrs.LastWriteTime = $lastwrite