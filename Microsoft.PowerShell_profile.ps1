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

# IIS PID to app-pool
function IisPidToAppPool
{
	C:\windows\system32\inetsrv\appcmd list wp
}
Set-Alias iispid IisPidToAppPool

function Profile 
{ 
	notepad++ $profile 
}
Set-Alias pro Profile

# functions for version control of ps-files
function GitPushProfile ($Message)
{
	cd {$env:UserProfile}\Documents\WindowsPowerShell
    GitPfusch($Message)
	.$Profile
}

function KillProcess ($Name)
{
	#gps | where {$_.Name -eq $Name} | kill	
	Get-Process | Where-Object {$_.Name -eq $Name} | Stop-Process	
}
Set-Alias killp KillProcess

# To install PsGet you run this script (feel free to vet it):
# (new-object Net.WebClient).DownloadString("http://psget.net/GetPsGet.ps1") | iex

# loading of PSGet Module PSReadline
if ($host.Name -eq 'ConsoleHost')
{
    Import-Module PSReadline
}

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
	if(-not($author)) {$author="heidegger"}
	# "from " + $DateFrom
	# "to "+$DateTo
	# "a "+$author
	git log --author=$author --after="$dateFrom 00:00" --before="$dateTo 23:59" --all --reverse --pretty=format:"%ad : %-an :%Cred%d%Creset: %h : %Cgreen%B" --regexp-ignore-case
}
Set-Alias gitl GitGetMyLogByDate

function GitGetMyRefLogByDate ()
{
	Param(
	[string]$dateFrom = {Get-Date -Format dd.MM.yyyy},
	[string]$dateTo,
	[string]$author
	)
	# if(-not($DateFrom)) {$DateFrom= Get-Date -Format dd.MM.yyyy}
	if(-not($dateTo)) {$dateTo=$dateFrom}
	if(-not($author)) {$author="heidegger"}
	# "from " + $DateFrom
	# "to "+$DateTo
	# "a "+$author
	git reflog --author=$author --after="$dateFrom 00:00" --before="$dateTo 23:59" --all --pretty='%cd %h %Cred %gd %Cgreen%gs'
}
Set-Alias gitrl GitGetMyRefLogByDate

function GitLogLast ()
{
	
	# if(-not($DateFrom)) {$DateFrom= Get-Date -Format dd.MM.yyyy}
	$DateTo= Get-Date -Format dd.MM.yyyy
	$DateFrom= "14.8."
	$author="peter"
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

# other useful
function OpenServus ()
{
	Start-Process -FilePath "http://servusimbiss.at.st"
}
Set-Alias servus OpenServus

function OpenGoldegg ()
{
	Start-Process -FilePath "www.facebook.com/cafegoldegg"
}
Set-Alias goldegg OpenGoldegg
Set-Alias ge goldegg


# Load posh-git example profile
. 'D:\dev\Tools\posh-git\profile.example.ps1'


# Load posh-git example profile
. 'C:\Projects\_misc\posh-git\profile.example.ps1'

