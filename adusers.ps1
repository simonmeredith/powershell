#Set output file location
$strFileName = "C:\powershell\output.txt"

# Check to see if output file already exists and delete if it does
If (test-path $strFileName)
	{
		Remove-Item $strFileName
	}

# Add header row to output file
$strHeader = 'Username,Enabled,Groups'
$strHeader | out-file $strFileName -append

# Get the AD groups that are relevant
$AllowedGroups = import-csv C:\powershell\AllowedGroups.csv

# Get the users who are in the Portal Rotation Grids Useers AD group
$userlist = Get-ADGroupMember -identity "Portal Rotation Grids Users" -Recursive | Get-AdUser -Property DisplayName | Select Name,SAMAccountName,Enabled

# Loop through each user and get their AD group membership
ForEach ($user in $userlist) 
	{
		# Initialise output string
		$Output = ""

		# Get the groups
		$Groups = Get-ADuser -Identity $user.SamAccountName -Properties MemberOf | Select-Object -ExpandProperty MemberOf | Get-ADGroup -Properties name|Where {$_.GroupCategory -eq "Security"} | sort |select-object name

		# Add data to the first two columns: Name of user and whether enabled/disabled account in AD
		$Output += '"' + $user.Name + '",' + $user.enabled + ',"'

		# Check if the user is in any of the relevant AD groups and add to the third output column
		ForEach ($Group in $Groups) 
			{
				If ($AllowedGroups -match $Group.name) {$Output += $Group.name + ","}
			}
	
		# Remove trailing comma
		$len = $output.length - 1 
		$output = $output.substring(0,$len)

		# Add final double-quotes to the end of the row
		$output += '"'

		# Add row to the output file
		$output | out-file $strFileName -append
	}