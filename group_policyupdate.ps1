echo N | gpupdate /force

$RecoveryKeyGUID = (Get-BitLockerVolume -MountPoint $env:SystemDrive).keyprotector | where {$_.Keyprotectortype -eq 'RecoveryPassword'} | Select-Object -ExpandProperty KeyProtectorID

manage-bde -protectors -adbackup c: -id $RecoveryKeyGUID