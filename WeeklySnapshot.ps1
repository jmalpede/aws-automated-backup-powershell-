############## C O N F I G ##############
."C:\AWS\AWSConfig.ps1"

#Environment
$ENVIRONMENT_TYPE = "Production"
$BACKUP_TYPE = "AutoWeekly"

############## F U N C T I O N S ##############
."C:\AWS\AWSUtilities.ps1"

############## M A I N ##############

try
{
    $start = Get-Date
    WriteToLog "$ENVIRONMENT_NAME $ENVIRONMENT_TYPE $BACKUP_TYPE Snapshots Starting" -excludeTimeStamp $true
    
###  Builds an Array of Instance ID's that have the tag "WeeklySnap" with value "Yes"
      $ProdInstanceIDs = GetAllInstances | Select-Object InstanceId, @{Name='SnapEnable'; Expression={($_.Tags |% {if ($_.Key -eq "WeeklySnap"){ $_.Value}})}} | Where-Object { $_.SnapEnable -eq "Yes" } |% { $_.InstanceID }

###  Creates Snapshots from the Array.
###  Cleans up Snapshots older that 4 Weeks that contain "AutoWeekly" in description.	
	
	
    StopInstances $ProdInstanceIDs
    CreateSnapshotsForInstances $ProdInstanceIDs
    StartInstances $ProdInstanceIDs

    CleanupWeeklySnapshots

    WriteToLog "$ENVIRONMENT_NAME $ENVIRONMENT_TYPE $BACKUP_TYPE Snapshots Complete" -excludeTimeStamp $true   

    $end = Get-Date
    $timespan = New-TimeSpan $start $end
    $hours=$timespan.Hours
    $minutes=$timespan.Minutes    
	WriteToLog "Snapshots took $hours hr(s), $minutes min(s) and $seconds sec(s)"
    
}
catch
{
    WriteToLog "Snapshots Failed after $hours hr(s), $minutes min(s) and $seconds sec(s)"
}