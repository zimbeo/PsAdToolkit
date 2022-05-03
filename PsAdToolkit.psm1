function New-Environment {
    param (
        [bool]$CleanUp = $false
    )

    $RunPath = "$($env:USERPROFILE)\PsAdToolkit"

    if ($CleanUp -eq $true) {
        Remove-Item -Force -Recurse -Path $RunPath\*
        return
    }

    # Evaluate if the directory exists, create it if it doesn't
    if (-Not (Test-Path -Path $RunPath)) {
        New-Item -Path $RunPath -ItemType Directory
        
        Write-Output "Created Directory for file storage"
    }
}

function New-ActiveDirectoryUser {
    Clear-Host
    Write-Output "Welcome to the User Creation Tool"
    Write-Output "...................................`n"
    
    # Endless Loop
    while ($true) {
        $name = Read-Host -Prompt "Please Enter the Name for the New User (Ex. Jane Doe)"
        $password = Read-Host -Prompt "Please Enter a Password for the New User" | ConvertTo-SecureString -AsPlainText -Force
        
        try {
            New-ADUser -Name $name -AccountPassword $password
            Write-Output "Creating User $name....."
        }
        catch {
            Write-Output -ForegroundColor Red "Something went wrong, see the below error"
            Write-Output $Error[0]
            break
        }
        
        try {
            Get-ADUser $name
            Write-Output "$name has been created...."
        }
        catch {
            Write-Output -ForegroundColor Red "Something went wrong, see the below error"
            Write-Output $Error[0]
        }
        
        # Another User?
        $again = Read-Host -Prompt "Would You Like to Create Another User? (y/n)"
        
        if ($again -eq "y") {
            continue
        }
        elseif ($again -eq "n") {
            Write-Output "Bye! Come back later"
            break
        }
        
    }
}

function Get-DistributionGroup {
    Clear-Host
    Write-Output "Welcome to the Distribution Group Auditing Tool"
    Write-Output "...................................`n"
    
    # Get all the Distro Groups
    Get-ADGroup -Filter * | Where-Object -Property groupcategory -EQ -Value "distribution" | Select-Object -ExpandProperty name > "$($env:USERPROFILE)\PsAdToolkit\allgroups.txt"

    # Get the text file with each group name to loop trough below
    $gc = Get-Content -Path "$($env:USERPROFILE)\PsAdToolkit\allgroups.txt"

    #Loop through each distro group, select member & name, store data in csv
    foreach ($group in $gc) {

        $members = Get-ADGroupMember -Identity ("${group}") | Select-Object -ExpandProperty name | Out-String

        $record = [pscustomobject]@{
            "Group" = $group
            "Users" = $members
        }

        Export-Csv -Append -InputObject $record -NoTypeInformation -Path "$($env:USERPROFILE)\PsAdToolkit\groups.csv"
    }

    Write-Output "Distribution groups exported to groups.csv in Script Folder - $($env:USERPROFILE)\PsAdToolkit\"
    Read-Host "Press enter to exit"

    # Clean up the text file
    Remove-Item -Path "$($env:USERPROFILE)\PsAdToolkit\allgroups.txt"
}

function Start-PsAdToolkit {
    # Create Script Directory for file storage during function runs
    New-Environment

    # Never Ending Menu Loop
    while ($true) {
        Clear-Host
        Write-Output "Welcome to the PsAdToolkit" -ForegroundColor Green
        Write-Output "..................................." -ForegroundColor Green

        Write-Output "`nPlease select from the following options:`n
        `r  1. Create a new AD user
        `r  2. Export Distribution Groups to CSV
        `r  3. Clean up the Script Directory
        `r  4. Exit`n"

        $user_selection = Read-Host "Option #"

        # If/elsif/else statements to evaluate user input and run respective function
        if ($user_selection -eq 1) {
            New-ActiveDirectoryUser
        }
        elseif ($user_selection -eq 2) {
            Get-DistributionGroup
        }
        elseif ($user_selection -eq 3) {
            New-Environment -CleanUp $true
        }
        elseif ($user_selection -eq 4) {
            break
        }
        else {
            Clear-Host
            Read-Host "That is not a valid selection. Press enter to continue"
            continue
        }
    }
}