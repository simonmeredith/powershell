
#Had to grant permissions first using the following:
#$w = Get-SPWebApplication -Identity https://***************
#$w.GrantAccessToProcessIdentity("domain\username")

[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint")
if((Get-PSSnapin | Where {$_.Name -eq "Microsoft.SharePoint.PowerShell"}) -eq $null) {
     Add-PSSnapin Microsoft.SharePoint.PowerShell;
 }

#Site Collection where you want to upload files
$siteCollUrl = "https://*******************************"
#Document Library where you want to upload files
$libraryName = "RotationGrids"
$spSourceWeb = Get-SPWeb $siteCollUrl;
$spSourceList = $spSourceWeb.Lists[$libraryName];

if($spSourceList -eq $null)
{
    Write-Host "The Library $libraryName could not be found."
    return;
}


$content = Get-Content D:\scripts\trustlist1.txt

foreach ($line in $content)
{

    $reportFilesLocation = "D:\RotationGrids\" + $line
    $files = ([System.IO.DirectoryInfo] (Get-Item $reportFilesLocation)).GetFiles()

    foreach ($file in $files)
    {
        $fileStream = ([System.IO.FileInfo] (Get-Item $file.FullName)).OpenRead()
        $folder =  $spSourceWeb.getfolder($libraryName) 
        $spFile = $folder.Files.Add($folder.Url + "/" + $line + "/" + $file.Name, [System.IO.Stream]$fileStream, $true)
        
        #write-host $folder.Url"/"$line"/"$file
        
        $fileStream.Close();
    }
}

$spSourceWeb.dispose();
Write-Host "Files have been uploaded to" $libraryName


