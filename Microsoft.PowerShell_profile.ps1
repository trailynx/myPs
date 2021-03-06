$MaximumHistoryCount = 10KB

if (!(Test-Path ~\PowerShell -PathType Container))
{   New-Item ~\PowerShell -ItemType Directory
}

function bye 
{   Get-History -Count 1KB |Export-CSV ~\PowerShell\history.csv
    exit
}

if (Test-path ~\PowerShell\History.csv)
{   Import-CSV ~\PowerShell\History.csv |Add-History
}

function SetBackground($bckgrnd)
{
    $Host.UI.RawUI.BackgroundColor = $bckgrnd
    $Host.UI.RawUI.ForegroundColor = 'White'
    $Host.PrivateData.ErrorForegroundColor = 'Red'
    $Host.PrivateData.ErrorBackgroundColor = $bckgrnd
    $Host.PrivateData.WarningForegroundColor = 'Magenta'
    $Host.PrivateData.WarningBackgroundColor = $bckgrnd
    $Host.PrivateData.DebugForegroundColor = 'Yellow'
    $Host.PrivateData.DebugBackgroundColor = $bckgrnd
    $Host.PrivateData.VerboseForegroundColor = 'Green'
    $Host.PrivateData.VerboseBackgroundColor = $bckgrnd
    $Host.PrivateData.ProgressForegroundColor = 'Cyan'
    $Host.PrivateData.ProgressBackgroundColor = $bckgrnd
    Clear-Host
}

 if ($host.UI.RawUI.WindowTitle -match "Administrator") {SetBackground("DarkRed")}
 if ($host.UI.RawUI.WindowTitle -match "Workheld-WebClient") {SetBackground("DarkGreen")}

function SetWebBackground()
{
    SetBackground("DarkCyan")
}
Set-Alias bgWeb SetWebBackground

function SetStandardbackground()
{
    SetBackground("DarkMagenta")
}
Set-Alias bgStd SetStandardbackground


############ profile related stuff ############

function Profile 
{ 
	PowerShell_ISE $profile 
}
Set-Alias pro Profile

# function for version control of ps-files
function GitPushProfile ($Message)
{
	cd {$env:UserProfile}\Documents\WindowsPowerShell
    GitPfusch($Message)
	.$Profile
}

############ windows related stuff ############

function FindLockingProcessForDLL ($lockedFilePath)
{
 Get-Process | foreach{$processVar = $_;$_.Modules | foreach{if($_.FileName -eq $LockedFilePath){$processVar.Name + " PID:" + $processVar.id}}}
} 

function TestFileLock {
    ## Attempts to open a file and trap the resulting error if the file is already open/locked
    param ([string]$filePath )
    $filelocked = $false
    $fileInfo = New-Object System.IO.FileInfo $filePath
    trap {
        Set-Variable -name filelocked -value $true -scope 1
        continue
    }
    $fileStream = $fileInfo.Open( [System.IO.FileMode]::OpenOrCreate,[System.IO.FileAccess]::ReadWrite, [System.IO.FileShare]::None )
    if ($fileStream) {
        $fileStream.Close()
    }
    $obj = New-Object Object
    $obj | Add-Member Noteproperty FilePath -value $filePath
    $obj | Add-Member Noteproperty IsLocked -value $filelocked
    $obj
} 

function KillProcess ($Name)
{
	#gps | where {$_.Name -eq $Name} | kill	
	Get-Process | Where-Object {$_.Name -eq $Name} | Stop-Process	
}
Set-Alias killp KillProcess

function UninstallApp ($Name)
{
	$app = get-wmiobject -class win32_product | where-object { 
		$_.name -match $name
	}
	# $app = Get-WmiObject -Class Win32_Product `
                     # -Filter "Name = $Name"
	
	$app.Uninstall()
}

function UninstallMVC2
{
	UninstallApp("Microsoft ASP.NET MVC 2")
}
Set-Alias uninstMvc2 UninstallMVC2

# IIS PID to app-pool
function IisPidToAppPool
{
	C:\windows\system32\inetsrv\appcmd list wp
}
Set-Alias iispid IisPidToAppPool

# To install PsGet you run this script (feel free to vet it):
# (new-object Net.WebClient).DownloadString("http://psget.net/GetPsGet.ps1") | iex

# loading of PSGet Module PSReadline
if ($host.Name -eq 'ConsoleHost')
{
    Import-Module PSReadline
}

function ZipThisFolder
{
    Param(
	[string]$destinationPath,
	[switch]$force
	)
	if(-not($destinationPath))
    {
        $destinationPath=(Resolve-Path .\).Path
    }
    if($force)
    {
        Compress-Archive -Path * -DestinationPath $destinationPath -Force
    }
    else
    {
        Compress-Archive -Path * -DestinationPath $destinationPath
    }
}
Set-Alias zipdir ZipThisFolder
Set-Alias zipthis ZipThisFolder

############ git ############

# set aliases for git
function GitAddI
{
    git add -i
}
Set-Alias gitai GitAddI
function GitStatus
{
    git status
}
Set-Alias gits GitStatus

function GitDiff
{
    git diff
}
Set-Alias gitd GitDiff

function GitCommitM ($Message)
{
    git commit -m $Message
}
Set-Alias gitcm GitCommitM
function GitCommitAM ($Message)
{
    git commit -am $Message
}
Set-Alias gitcam GitCommitAM

function GitPullPush ($Message)
{
	git pull
    git push
}
Set-Alias gitpp GitPullPush

function GitGetMyLogByDate ()
{
	Param(
	[string]$dateFrom = {Get-Date -Format dd.MM.yyyy},
	[string]$dateTo,
	[string]$author
	)
	# if(-not($DateFrom)) {$DateFrom= Get-Date -Format dd.MM.yyyy}
	if(-not($dateTo)) {$dateTo=$dateFrom}
	if(-not($author)) {$author="trailynx"}
	# "from " + $DateFrom
	# "to "+$DateTo
	# "a "+$author
	git log --all --author=$author --after="$dateFrom 00:00" --before="$dateTo 23:59" --pretty=format:"%ad : %-an :%Cred%d%Creset: %h : %Cgreen%B" --regexp-ignore-case
}
Set-Alias gitl GitGetMyLogByDate

function GitLogFilter ()
{
	Param([string]$filter,
	[string]$params)
	[Environment]::NewLine
	git log --pretty=format:"%Creset %h - %Cgreen %s %Creset %ad : %Cred %-an" --regexp-ignore-case --grep=$filter $params
	[Environment]::NewLine
}
Set-Alias gitlf GitLogFilter

function GitGetMyRefLogByDate ()
{
	Param(
	[string]$dateFrom = {Get-Date -Format dd.MM.yyyy},
	[string]$dateTo,
	[string]$author,
	[string]$params
	)
	# if(-not($DateFrom)) {$DateFrom= Get-Date -Format dd.MM.yyyy}
	if(-not($dateTo)) {$dateTo=$dateFrom}
	if(-not($author)) {$author="trailynx"}
	# "from " + $DateFrom
	# "to "+$DateTo
	# "a "+$author
	git reflog --author=$author --after="$dateFrom 00:00" --before="$dateTo 23:59" --all --pretty='%cd %h %Cred %gd %Cgreen%gs' $params
}
Set-Alias gitrl GitGetMyRefLogByDate

function GitLogLast ()
{
	
	# if(-not($DateFrom)) {$DateFrom= Get-Date -Format dd.MM.yyyy}
	$DateTo= Get-Date -Format dd.MM.yyyy
	$DateFrom= "14.8."
	$author="trailynx"
	 "from " + $DateFrom
	 "to "+$DateTo
	 "a "+$author
	git log --author=$author --after="$dateFrom 00:00" --before="$dateTo 23:59" --all --stat --reverse --pretty=format:"%ad : %-an :%Cred%d%Creset: %h : %Cgreen%B" --regexp-ignore-case
	
}
Set-Alias gitll GitLogLast

# http://gitready.com/intermediate/2009/01/22/count-your-commits.html
function GitNumberOfCommitsByAuthor()
{
	# The -s option squashes all of the commit messages into the number of commits, and the -n option sorts the list by number of commits.
	git shortlog -s -n
}
Set-Alias gitNumbers GitNumberOfCommitsByAuthor

function GitPfusch ($Message)
{
	$appendText = "; (fast commit)"
	git commit -am "$Message $appendText"
	git pull
    git push
}
Set-Alias git-pfusch GitPfusch

function GitDeleteLocalBranches ($branches)
{
# function to delete multiple branches at once
# example usage: 
# first save all branches to textfile: "git branch --list > branches.txt"
# then manuall edit the textfile to only contain branches you want to delete
# read the textfile again: "$l = Get-Content branches.txt"
# and pass it into the function: GitDeleteLocalBranches $l

    write-host 'This will delete all LOCAL branches that are provided in the input parameter, press enter to procceed'
    pause

    # param([string[]]$arr)
    Foreach($branch in $branches)
    {
        write-host 'deleting ' $branch
        git branch -d $branch
    }
}

function GitDeleteRemoteBranches ($branches)
{
# function to delete multiple branches at once
# example usage: 
# first save all branches to textfile: "git branch -r > branches-r.txt"
# then manuall edit the textfile to only contain branches you want to delete
# read the textfile again: "$r = Get-Content branches-r.txt"
# and pass it into the function: GitDeleteRemoteBranches $r

    write-host 'This will delete all branches REMOTE that are provided in the input parameter, press enter to procceed'
    pause

    # param([string[]]$arr)
    Foreach($branch in $branches)
    {
        write-host 'deleting ' $branch
        git branch -d $branch
    }
}



function GitDeleteLocalBranchesInteractive ($fromFile)
{
    Write-host "`nThis is a method to delete several branches at once (locally, won't push). If you fuck up you can try to get them from remote again, or try to use git reflog."
    pause
    if($fromFile)
    {
        # use the provided file        
        write-host "`nUsing provided file $fromFile with branchnames for deleting"

    }
    else
    {    
        write-host "`nInitializing delte list with ALL local branch names"
        $fromFile = "branches2delete.txt"
        git branch --list > $fromFile
    }
    write-host "Please edit the file with branch names to delete"
    write-host "The ones that you leave in the file $fromFile will get deleted!! " -ForegroundColor Yellow -BackgroundColor DarkRed
    write-host "When you are done save it and then press enter`nEach line must exactly match with the branch name to delete (no leading or trailing whitespace)`n"

    ii .\$fromFile
    
    pause

    $branches = Get-Content .\$fromFile


    write-host "`nThis will delete all branches that are provided in the branches.txt file, `nonly press enter to procceed if you are sure that the file only contains branches you want to delete`n`n"
    
    
    write-host "Branches to delete: " -ForegroundColor Yellow -BackgroundColor DarkRed
    Foreach($branch in $branches)
    {
        write-host $branch -ForegroundColor Red -BackgroundColor Black
    }
        
    Write-Host "`n-------------------------------------------------`nAre you really sure to delete all these branches?`n-------------------------------------------------`n" -ForegroundColor Yellow -BackgroundColor DarkRed

    write-host "`nPress 'CTRL + C, CTRL + C' to exit..."
    pause

    # param([string[]]$arr)
    Foreach($branch in $branches)
    {
        write-host 'deleting ' $branch
        git branch -d $branch
    }
}


############ other useful ############

function OpenServus ()
{
	Start-Process -FilePath "http://servusimbiss.at.st"
}
Set-Alias servus OpenServus

function OpenHof ()
{
	Start-Process -FilePath "https://www.facebook.com/imhofinderalpenmilchzentrale"
}
Set-Alias hof OpenHof

function OpenGoldegg ()
{
	Start-Process -FilePath "www.facebook.com/cafegoldegg"
}
Set-Alias goldegg OpenGoldegg


function OpenSperl ()
{
	Start-Process -FilePath "http://www.restaurant-sperl.at/wp-content/uploads/menueplan.pdf"
}
Set-Alias sperl OpenSperl

function ToLowerCopy($String)
{
	$String.ToLower() | clip
}
Set-Alias tlc ToLowerCopy

function ToUpperCopy($String)
{
	$String.ToUpper() | clip
}
Set-Alias tuc ToUpperCopy


function OpenReblaus ()
{
	Start-Process -FilePath "http://www.zurreblaus.at/woche-aktuell.html"
}
Set-Alias reblaus OpenReblaus

function OpenBrotzeit ()
{
	Start-Process -FilePath "http://www.brotzeit.at/diegourmetkantine/index.php/menueplan-brotzeit-die-gourmetkantine"
}
Set-Alias brotzeit OpenBrotzeit


function CreateBatteryReport ()
{
	$CurrentDate = Get-Date
	$CurrentDate = $CurrentDate.ToString('MM-dd-yyyy_hh-mm-ss')
	$TargetDir = "C:\battery_reports"
	if(!(Test-Path -Path $TargetDir ))
	{
    	New-Item -ItemType directory -Path $TargetDir
	}
	$FilePath = $TargetDir + "\battery_report_$CurrentDate.html"
	powercfg /batteryreport /output "$FilePath "

	Start-Process -FilePath $FilePath 
}
Set-Alias batteryReport CreateBatteryReport

# work related stuff
function Workheldconfig ()
{ 
    $workheldConfigPath = "$env:LOCALAPPDATA\Packages\TabletSolutionsGmbH.WorkHeld_3dccz84925sdp\LocalState\config.json"
    Get-Content $workheldConfigPath
}
Set-Alias whconfig Workheldconfig

function WorkHeldDeleteDbs ()
{
	Remove-Item "$env:LOCALAPPDATA\Packages\TabletSolutionsGmbH.WorkHeld_3dccz84925sdp\LocalState\*" -include *.db
}
Set-Alias whrmdb WorkHeldDeleteDbs

function WorkHeldPath ()
{
	"$env:LOCALAPPDATA\Packages\TabletSolutionsGmbH.WorkHeld_3dccz84925sdp\LocalState\"
}
Set-Alias whPath WorkHeldPath 

# $excludeList = @("stuff","bin","obj*")
# Get-ChildItem -Recurse | % {
    # $pathParts = $_.FullName.substring($pwd.path.Length + 1).split("\");
    # if ( ! ($excludeList | where { $pathParts -like $_ } ) ) { $_ }
# }


# # Load posh-git example profile
# . 'D:\dev\Tools\posh-git\profile.example.ps1'


# # Load posh-git example profile
# . 'C:\Projects\_misc\posh-git\profile.example.ps1'

#$global:GitPromptSettings.WorkingForegroundColor    = [ConsoleColor]::Yellow 
# $global:GitPromptSettings.UntrackedForegroundColor  = [ConsoleColor]::Yellow

# git config --global color.status.changed "cyan normal bold" 
# git config --global color.status.untracked "cyan normal bold"

# normal
# black
# red
# green
# yellow
# blue
# magenta
# cyan
# white


# Load posh-git example profile
Import-Module posh-git

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
