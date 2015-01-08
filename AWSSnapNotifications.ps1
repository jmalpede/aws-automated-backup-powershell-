#Connection Details
$smtpServer = “IP or smtp.somedomain.com”
$msg = new-object Net.Mail.MailMessage

#Change port number for SSL to 587
$smtp = New-Object Net.Mail.SmtpClient($SmtpServer, 25) 

#Uncomment Next line for SSL  
#$smtp.EnableSsl = $true

#Uncomment Next line for authentication
#$smtp.Credentials = New-Object System.Net.NetworkCredential( $username, $password )

#From Address
$msg.From = "user@somedomain.com"
#To Address, Copy the below line for multiple recipients
$msg.To.Add("user@somedomain.com")


#Path of Snapshot Log Files
$path = "c:\AWS\Logs\"

#Date of yesterdays log files
$lgdate = (get-date).AddDays(-1).ToString("yyyyMMdd")

#Message Body
$msg.Body="AWS Snapshot log notification for snapshots created on $lgdate"

#Message Subject
$msg.Subject = "AWS Snapshot Logs for $lgdate"

#your file location
$files=Get-ChildItem $Path -recurse -include @("*.txt*") | Where-Object { $_.Name -like ("AWS*" + $lgdate + ".txt") }

Foreach($file in $files)
{
Write-Host “Attaching File :- ” $file
$attachment = New-Object System.Net.Mail.Attachment –ArgumentList $file
$msg.Attachments.Add($attachment)

}
$smtp.Send($msg)
$attachment.Dispose();
$msg.Dispose();