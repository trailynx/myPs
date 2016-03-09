
# function BvUpdateDatabase()
# { 
	# Update-Database -ProjectName "BV.Core" -ConfigurationTypeName "DataContextMigrationConfiguration"
# }
# Set-Alias bvud BvUpdateDatabase

function BvAddMigration($name)
{
	if($name)
	{
		Add-Migration $name -ProjectName "BV.Core" -ConfigurationTypeName "DataContextMigrationConfiguration" 
	}
	else 
	{
		Write-Host  "Please specify the migration-name as parameter" -BackgroundColor "Red" -ForegroundColor "White" 
	}	
}
Set-Alias bvam BvAddMigration


function BvUpdateDatabase([string]$migrationName)
{
	if($migrationName)
	{
		Update-Database -ProjectName "BV.Core" -ConfigurationTypeName "DataContextMigrationConfiguration" -TargetMigration $migrationName -Force
	}
	else 
	{
		Update-Database -ProjectName "BV.Core" -ConfigurationTypeName "DataContextMigrationConfiguration"
		# Write-Host  "Please specify the target migration name as parameter" -BackgroundColor "Red" -ForegroundColor "White" 
	}	
}
Set-Alias bvud BvUpdateDatabase