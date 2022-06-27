## User Termination script
## Usage: copy the entire text of this file into a PowerShell window (run as Administrator)
##        you will be prompted for the user account name (without the @onside.ca), Office365 license type,
##        and to verify/edit the updated Description line for the user
##        Script will change the password, disable the account, remove any expiry date from the account,
##        set the Description line  (eg. 2020-01-01 - Island (F1) ), and move the user to the GraveYard/Terminated OU


## Below line is only required ONCE per PowerShell session, it's used to allow interaction with graphic dialog boxes 
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null

$userID = [Microsoft.VisualBasic.Interaction]::InputBox(“Enter the AD account of the user you wish Terminate”, "Account name", "FLastname")

$user = Get-ADUser -Identity $userID -Properties Description,CanonicalName

Set-ADAccountPassword -Identity $userID -Reset -NewPassword (ConvertTo-SecureString -AsPlainText "apple.3141592654" -Force)

Disable-ADAccount -Identity $userID

Clear-ADAccountExpiration -Identity $userID

$output = $user.Name
$output = $output + "'s account has been disabled, expiry date cleared, and password reset"
echo $output

## This block to build string that shows Canonical name (OU path in AD) and get input for text to append
$output = Out-String -InputObject $user.CanonicalName
$output = $output + "`r`n`nEnter the Office365 license this user currently has"
$DescriptionAppendText = [Microsoft.VisualBasic.Interaction]::InputBox($output, "Office365 License", "F3")


## This block builds the new Description date and prepends the date using current date
$NewUserDescription = Get-Date -Format "yyyy-MM-dd"
$NewUserDescription = $NewUserDescription + " - " + $user.Description + " ($DescriptionAppendText)"
echo $NewUserDescription


$NewUserDescription = [Microsoft.VisualBasic.Interaction]::InputBox("Is this the correct Description replacement?`r`n`nChange to suit your needs:", "New User Description", $NewUserDescription)
Set-ADUser -Identity $user.SamAccountName -Description $NewUserDescription


## Move the user's AD object to the correct OU
Move-ADObject $(Get-ADUser -Identity $userID) -TargetPath 'OU="Terminated",OU="GraveYard",DC=ONSIDE,DC=CA' -Confirm:$false

$lastName = $user.surname
echo $user.surname

Get-ADComputer -Filter "*" -Properties Description,Name | Where-Object {$_.Description -like "*$lastName*"} | Select-Object -Property Description,Name

$computerID = [Microsoft.VisualBasic.Interaction]::InputBox("Enter the name of the computer you wish to disable")

$compDescription = Get-ADComputer -Identity $computerID -Properties Description

$NewCompDescription = Get-Date -Format "yyyy-MM-dd"
$NewCompDescription = $NewCompDescription + " [] " + $compDescription.Description 
echo $NewCompDescription

Set-ADComputer -Identity $computerID$ -Description $NewCompDescription

Disable-ADAccount -Identity $computerID$

Move-ADObject $(Get-ADComputer -Identity $computerID$) -TargetPath 'OU="Disabled Computers",OU="Computers",OU="Onside",DC=ONSIDE,DC=CA' -Confirm:$false
