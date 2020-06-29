
#UPDATE DATA IN EXCEL FILES
#THEN CREATE PDF FILE
[string]$path = "C:\Source Path\"  #Path to Excel spreadsheets to save to PDF
[string]$savepath = "C:\Destination Path\"
[string]$dToday = Get-Date -Format "yyyyMMdd"

$xlFixedFormat = "Microsoft.Office.Interop.Excel.xlFixedFormatType" -as [type] 
$excelFiles = Get-ChildItem -Path $path -include *.xls, *.xlsx -recurse 

# Create the Excel application object
$objExcel = New-Object -ComObject excel.application 
$objExcel.visible = $false   #Do not open individual windows

foreach($wb in $excelFiles) 
{ 
    # Path to new PDF with date 
    $filepath = Join-Path -Path $savepath -ChildPath ($wb.BaseName + "_" + $dtoday + ".pdf") 
    # Open workbook - 3 refreshes links
    $workbook = $objExcel.workbooks.open($wb.fullname, 3)
    $worksheet = $objExcel.worksheets.item(1) #SK
    $workbook.RefreshAll()

    # Give delay to save
    Start-Sleep -s 5

    # Save Workbook
    $workbook.Saved = $true 
    "saving $filepath" 
    #Export as PDF
    $worksheet.ExportAsFixedFormat($xlFixedFormat::xlTypePDF, $filepath) #SK
    $objExcel.Workbooks.close() 
} 
$objExcel.Quit()