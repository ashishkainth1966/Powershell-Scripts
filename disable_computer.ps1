[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null

$lastName = [Microsoft.VisualBasic.Interaction]::InputBox("Enter the last name of the employee")

Get-ADComputer -Filter "*" -Properties Description,Name | Where-Object {$_.Description -like "*$lastName*"} | Select-Object -Property Description,Name

$computerID = [Microsoft.VisualBasic.Interaction]::InputBox("Enter the name of the computer you wish to disable")

$compDescription = Get-ADComputer -Identity $computerID -Properties Description

$NewCompDescription = Get-Date -Format "yyyy-MM-dd"
$NewCompDescription = $NewCompDescription + " [] " + $compDescription.Description 
echo $NewCompDescription

Set-ADComputer -Identity $computerID$ -Description $NewCompDescription

Disable-ADAccount -Identity $computerID$

Move-ADObject $(Get-ADComputer -Identity $computerID$) -TargetPath 'OU="Disabled Computers",OU="Computers",OU="Onside",DC=ONSIDE,DC=CA' -Confirm:$false
