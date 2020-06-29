# From https://github.com/MrPowerScripts/PowerScripts/blob/master/Outlook/SendEmailFromOutlook.ps1

$OL = New-Object -ComObject outlook.application

Start-Sleep 5

<#
olAppointmentItem
olContactItem
olDistributionListItem
olJournalItem
olMailItem
olNoteItem
olPostItem
olTaskItem
#>

#Create Item
$mItem = $OL.CreateItem("olMailItem")

$mItem.To = "PlayingWithPowershell@gmail.com"
$mItem.Subject = "PowerMail"
$mItem.Body = "SENT FROM POWERSHELL"

$mItem.Send()
