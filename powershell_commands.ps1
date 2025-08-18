# ==========================
# Self-Updating PowerShell Script
# ==========================

# GitHub raw link (replace with your repo link)
$githubUrl = "https://raw.githubusercontent.com/ajeyverma/CmdXManage/main/powershell_commands.ps1"

# Local path to THIS script
$localScript = $MyInvocation.MyCommand.Path

# Default function to run
$FuncName = "CommandsList"

# Check internet connection
$Online = Test-Connection github.com -Count 1 -Quiet -ErrorAction SilentlyContinue

if ($Online) {
    try {
        Write-Host "🌍 Internet available. Updating powershell_commands.ps1 from GitHub..."
        Invoke-WebRequest -Uri $githubUrl -OutFile $localScript -UseBasicParsing
        Write-Host "✅ Update complete. Launching new window with updated script..."
        Start-Process powershell -ArgumentList "-NoExit", "-Command", "& { . '$localScript'; $FuncName }"
        exit
    }
    catch {
        Write-Host "⚠️ Failed to update from GitHub. Using local copy..."
    }
}
else {
    Write-Host "⚠️ No internet connection. Using local copy..."
}

# ==========================
# Functions Section
# ==========================

function CommandsList {
    Write-Host "Get-ChildItem -Force @args               - Lists all files and folders including hidden ones"
    Write-Host "Set-Location <path>                      - Changes current directory to <path>"
    Write-Host "Set-Location $env:USERPROFILE\<path>     - Changes directory to a folder inside user profile"
    Write-Host "Set-Location @args                       - Change your directory (like cd)"
    Write-Host "Clear-Host                               - Clears the console screen"
    Write-Host "New-Item -ItemType Directory -Path <folderName>  - Creates a new directory"
    Write-Host "New-Item -ItemType Directory $args       - Creates a new directory(like mkdir)"
    Write-Host "Remove-Item @args                        - Deletes files or folders"
    Write-Host "Get-Content @args                        - Shows the content of a file"
    Write-Host "& 'full_path_to_executable' @args        - Runs an external program or executable"
    Write-Host "Copy-Item @args                          - Copies files or folders"
    Write-Host "Move-Item @args                          - Moves or renames files or folders"
    Write-Host "Rename-Item -Path <old> -NewName <new>   - Renames a file or folder"
    Write-Host "Test-Path <path>                         - Checks if a file or folder exists"
    Write-Host "Get-Process                              - Lists running processes"
    Write-Host "Stop-Process -Id <processId>             - Stops a running process by its ID"
    Write-Host "Get-Service                              - Lists Windows services"
    Write-Host "Start-Service -Name <serviceName>        - Starts a Windows service"
    Write-Host "Stop-Service -Name <serviceName>         - Stops a Windows service"
    Write-Host "Restart-Service -Name <serviceName>      - Restarts a Windows service"
    Write-Host "Get-EventLog -LogName <logname>          - Views event logs"
    Write-Host "Get-Alias                                - Lists all aliases"
    Write-Host "Set-Alias <aliasName> <cmdlet>           - Creates a new alias"
    Write-Host "Remove-Item -Path alias:<aliasName>      - Removes an alias"
    Write-Host "Write-Host <text>                        - Prints text to the console"
    Write-Host "Get-Help <cmdlet>                        - Shows help for a cmdlet"
    Write-Host "Import-Module <moduleName>               - Loads a PowerShell module"
    Write-Host "Export-Csv -Path <file.csv>              - Exports data to CSV file"
    Write-Host "Import-Csv -Path <file.csv>              - Imports data from CSV file"
    Write-Host "Measure-Object                           - Measures properties of objects"
    Write-Host "Select-Object                            - Selects properties of objects"
    Write-Host "Where-Object                             - Filters objects based on condition"
    Write-Host "Sort-Object                              - Sorts objects by property"
    Write-Host "Out-File -FilePath <file.txt>            - Sends output to a file"
    Write-Host "Start-Job -ScriptBlock { }               - Runs a background job"
    Write-Host "Receive-Job -Id <jobId>                  - Retrieves job results"
    Write-Host "Wait-Job -Id <jobId>                     - Waits for a job to complete"
    Write-Host "Get-Job                                  - Lists background jobs"
    Write-Host "Stop-Job -Id <jobId>                     - Stops a background job"
    Write-Host "Get-History                              - Shows command history"
    Write-Host "Invoke-History -Id <historyId>           - Runs a command from history"
    Write-Host "New-ItemProperty -Path <regPath> -Name <propName> -Value <value> - Creates or sets registry property"
    Write-Host "Get-ItemProperty -Path <regPath>         - Gets registry property"
    Write-Host "Remove-ItemProperty -Path <regPath> -Name <propName> - Removes registry property"
    Write-Host "Clear-Variable -Name <varName>           - Clears a variable"
    Write-Host "Get-Variable                             - Lists variables"
    Write-Host "Set-Variable -Name <varName> -Value <value> - Sets variable value"
    Write-Host "Read-Host -Prompt 'text'                 - Prompts user for input"
    Write-Host "Test-Connection <hostname>               - Sends ping requests to test network"
    Write-Host "Get-NetIPAddress                         - Displays IP configuration"
    Write-Host "New-Guid                                 - Generates a new GUID"
    Write-Host "Start-Process <program>                  - Starts a process/application"
    Write-Host "Get-Location                             - Shows current directory"
    Write-Host "Push-Location <path>                     - Saves current directory and changes to new path"
    Write-Host "Pop-Location                             - Returns to previous directory saved by Push-Location"
}

# Run default function if we reach here (offline or update failed)
& $FuncName
