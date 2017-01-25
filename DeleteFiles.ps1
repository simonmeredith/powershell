
# Created Simon Meredith September 2016

#Had to grant permissions first using the following:
#$w = Get-SPWebApplication -Identity https://*************************
#$w.GrantAccessToProcessIdentity("domain\username")

[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint")
if((Get-PSSnapin | Where {$_.Name -eq "Microsoft.SharePoint.PowerShell"}) -eq $null) {
     Add-PSSnapin Microsoft.SharePoint.PowerShell;
 }

#Site Collection where you want to delete files
$siteCollUrl = "https://******************************************"

#Document Library from which you want to delete the file
$libraryName = "Rotation Grids"

#Get the site collection object
$Web = Get-SPWeb $siteCollUrl;

#Get the list object
$spList = $Web.Lists[$libraryName];

#Check destination list exists
if($spList -eq $null)
{
    Write-Host "The Library $libraryName could not be found."
    return;
}

$choice = ""
while ($choice -notmatch"[y/n]")
{
$choice = read-host "Are you sure you want to delete all files in $($libraryName)? (Enter Y/N)"
}

if ($choice -eq "y")
{

$files = $spList.Items | where {$_.FileSystemObjectType -eq "File"}
foreach ($file in $files)
    {
        Write-Output "Deleting file $($file.name)..."
        $file.Delete()
    }
}
else {write-host "Aborting delete script"}

