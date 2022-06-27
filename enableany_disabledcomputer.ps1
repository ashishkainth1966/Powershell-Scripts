[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null

$computerID = [Microsoft.VisualBasic.Interaction]::InputBox("Enter the name of the computer you wish to enable")

$compDescription = Get-ADComputer -Identity $computerID -Properties Description

$output = Out-String -InputObject $compDescription.Description

$NewCompDescription = [Microsoft.VisualBasic.Interaction]::InputBox("Enter the description you want or verify the current description","Description",$output)

echo $NewCompDescription

Set-ADComputer -Identity $computerID$ -Description $NewCompDescription

Enable-ADAccount -Identity $computerID$

$string = $computerID.substring(0,3)

echo $string

$string = 'OU="' + $string + '",' + 'OU="Windows 8+",OU="Computers",OU="Onside",DC=ONSIDE,DC=CA'

echo $string

Move-ADObject $(Get-ADComputer -Identity $computerID$) -TargetPath $string -Confirm:$false
