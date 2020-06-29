# Be sure you create a Desktop folder at the two locations below:
#     C:\Windows\System32\config\systemprofile\ 
#     C:\Windows\SysWOW64\config\systemprofile\

#Set the file path (can be a network location)
$filePath = "<file path>\spreadsheet.xlsx"

#Create the Excel Object
$excelObj = New-Object -Com Excel.Application

#Wait for 10 seconds then update the spreadsheet
Start-Sleep -s 10

#Make Excel visible. Set to $false if you want this done in the background
$excelObj.Visible = $true
$excelObj.DisplayAlerts = $false

#Open the workbook
$workBook = $excelObj.Workbooks.Open($filePath)

#Wait for 10 seconds then update the spreadsheet
Start-Sleep -s 10

#Focus on the top row of the "Data" worksheet
#Note: This is only for visibility, it does not affect the data refresh
$workSheet = $workBook.Sheets.Item("Sheet1")
$workSheet.Select()

#Refresh all data in this workbook
$workBook.RefreshAll()

Start-Sleep -s 10

#Save any changes done by the refresh
$workBook.Save()
$workBook.Close()

#Uncomment this line if you want Excel to close on its own
$excelObj.Quit()
$excelObj = $null
write-host "Finished updating the spreadsheet" -foregroundcolor "green"
Start-Sleep -s 5