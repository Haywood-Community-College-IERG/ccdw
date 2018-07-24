$filenameroot = $args[0]
$oldfieldname = $args[1]
$newfieldname = $args[2]

$RootPath = "K:\"
$BackupPath = $RootPath + "BACKUP\" + $filenameroot
$DWPath = $RootPath + "DW\" + $filenameroot + "\"


$files = Get-ChildItem -path $BackupPath -filter "*.csv"
$regex = '1s/"' + $oldfieldname + '",/"' + $newfieldname + '",/g'

ForEach ($file in $files) {
    $filename = $file.FullName
    $filenamenew = $DWPath + $file.Name
    $creationtime = (Get-ItemProperty $filename).LastWriteTime

    Write-Output "Processing [$filename] into [$filenamenew], regex = $regex, date = $creationtime"

    Copy-Item ($filename) $DWPath

    Start-Process -FilePath "L:\IERG\Programs\cmder\vendor\git-for-windows\usr\bin\sed.exe" -ArgumentList "-i", "'$regex'", $filenamenew -Wait -NoNewWindow -WorkingDirectory $DWPath

    Get-ChildItem -Path $filenamenew | 
        ForEach-Object {
            $_.CreationTime = $creationtime
            $_.LastAccessTime = $creationtime
            $_.LastWriteTime = $creationtime
        }
}
