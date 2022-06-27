[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null

$computerID = [Microsoft.VisualBasic.Interaction]::InputBox("Enter the computer name","VAN-TBXXXX")

$compDescription = [Microsoft.VisualBasic.Interaction]::InputBox("Enter the computer description","Flastname [] Model")

echo $compDescription

Set-ADComputer -Identity $computerID$ -Description $compDescription

$string = $computerID.substring(0,3)

echo $string

$string = 'OU="' + $string + '",' + 'OU="Windows 8+",OU="Computers",OU="Onside",DC=ONSIDE,DC=CA'

echo $string

Move-ADObject $(Get-ADComputer -Identity $computerID$) -TargetPath $string -Confirm:$false
