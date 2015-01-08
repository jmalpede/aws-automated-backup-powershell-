# aws-automated-backup-powershell-
corrected some issues on when running scripts and moved email for external smtp server support.

Overview of changes
1. Enables Support of multiple environments Which allows one management server to snapshot multiple AWS environments.(QA and Prod)
2. To support multiple environments just create unique awsconfig, dailysnap and weeklysnap files that are prefixed for each environment. 
(ie. AWSQAConfig.ps1, QADailySnap.ps1, QAWeeklySnap.ps1 and AWSPRODConfig.ps1, QADailySnap.ps1, QAWeeklySnap.ps1)
3. Changed email to support an external mail server.
4. Removed WriteToEmail and replaced with WriteToLog.
5. Added a script that scans log folder and emails previous days log to recipients.

QAWeeklySnap.ps1)
Removed email functionality and set scripts to write to logs. (Another app sends logs via email)
Buids and Array of Instances based on Amazon Tag - DailySnap or WeeklySnap - Value "Yes"
Environment_Name variable moved to AWSConfig, so log files can have the Environment name as a prefix. (Mulitple environment logs in the same folder.) 
Added Poweshell Script that searches log directory and emails yesterdays logs.

AWSConfig.ps1
Removed SES Regions and email configuration
Added Environment_Name variable (Allows for multiple environment logs.)

DailySnap.ps1 and WeeklySnap.ps1
Moved Environment_Name variable to AWSConfig.ps1 (Allows for multiple environment logs.)
Removed InstanceID's from config. (Instance ID's for snaps are now determined by Amazon Tag) 
Removed WriteToEmail functionality and only write to logs.

AWSUtilites
Changed naming convention to AutoDaily and AutoWeekly for internal clarification.
Removed WriteToEmail functionality and only write to logs.
Corrected problem with log name.
Changed Snapshot Description to list Backup Type first (easier to sort)
Added Snapshot count entry to log.

AWSSnapNotifications.ps1
Script the searches log folder and emails a yesterdays logs to specified recipients.
