
# Created Simon Meredith June 2016

#Had to grant permissions first using the following:
#$w = Get-SPWebApplication -Identity https://*******************
#$w.GrantAccessToProcessIdentity("domain\username")

[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint")
if((Get-PSSnapin | Where {$_.Name -eq "Microsoft.SharePoint.PowerShell"}) -eq $null) {
     Add-PSSnapin Microsoft.SharePoint.PowerShell;
 }

#Site Collection where you want to upload files
$siteCollUrl = "https://****************************"
#Document Library where you want to upload files
$libraryName = "Rotation Grids"
$SourceFolderName = "RotationGrids"
#Get the site collection destination
$spDestWeb = Get-SPWeb $siteCollUrl;
#Get the destination list
$spDestList = $spDestWeb.Lists[$libraryName];
#Check destination list exists
if($spDestList -eq $null)
{
    Write-Host "The Library $libraryName could not be found."
    return;
}

#Get the list of trusts - text file with each trust on a different line
$content = Get-Content D:\scripts\trustlist.txt
#Loop through each trust
foreach ($line in $content)
{
    #Set source location of the files
    $reportFilesLocation = "D:\RotationGrids\" + $line
    #Get the files

    $files = ([System.IO.DirectoryInfo] (Get-Item $reportFilesLocation)).GetFiles()
    #Loop through each file and add to the SharePoint doc library
    foreach ($file in $files)
        {
             $fileStream = ([System.IO.FileInfo] (Get-Item $file.FullName)).OpenRead()
            
             $folder =  $spDestWeb.getfolder($SourceFolderName) 

             $spFile = $folder.Files.Add($folder.Url + "/" + $line + "/" + $file.Name, [System.IO.Stream]$fileStream, $true)
             write-host "File added to "$folder/$line
        }
        $fileStream.Close();
}

$spDestWeb.dispose();
Write-Host "Files have been uploaded to" $libraryName


