
# File: CmdXManage.ps1
# Description: Manage custom commands (Add, Edit,  Remove) in a $PROFILE.

##################################################################################################
function Secure-Command {
   $expectedHash = "2AE1EF91C80C26E77201214346C2A2881BC2DFB3AE1FD93FE7F9DCD483C98599"
    $funcDef = (Get-Command Ensure-ShowHeader-Integrity).Definition
    $actualHash = (Get-FileHash -InputStream ([System.IO.MemoryStream]::new([System.Text.Encoding]::UTF8.GetBytes($funcDef))) -Algorithm SHA256).Hash
    if ($actualHash -ne $expectedHash) {
        SecuFun
        exit
        
    }
}
function Show-Menu {
    Clear-Host
function Show-Header {
    # Big block text for "COMMAND MANAGER"
    $asciiTitle = @"
  ____                 _ __  __ __  __                                   
 / ___| _ __ ___    __| |\ \/ /|  \/  |  __ _  _ __    __ _   __ _   ___ 
| |    | '_ ' _ \  / _  | \  / | |\/| | / _' || '_ \  / _' | / _' | / _ \
| |___ | | | | | || (_| | /  \ | |  | || (_| || | | || (_| || (_| ||  __/
 \____||_| |_| |_| \____|/_/\_\|_|  |_| \__,_||_| |_| \__,_| \__, | \___|
                                                             |___/          
"@

    Write-Host $asciiTitle -ForegroundColor Green

    # Subtitle
    Write-Host "@Ajay Verma ( Aarush )" -ForegroundColor red
    Write-Host ""
    Write-Host "A PowerShell script to create & manage your custom commands in Window PowerShell." -ForegroundColor Cyan
    Write-Host ""

    # Created by info
    Write-Host "Created by Aarush Chaudhary" -ForegroundColor Green

    # GitHub URLs
    Write-Host "GitHub: https://github.com/AjeyVerma" -ForegroundColor Yellow
    Write-Host "Instagram: https://instagram.com/ajayverma097" -ForegroundColor Yellow
    Write-Host "LinkedIn: https://linkedin.com/in/AjeyVerma" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "#You can visit the " -NoNewline
    Write-Host "script repo " -ForegroundColor cyan -NoNewline
    write-host "to explore more tool releated to the commands." 
    Write-Host "Script Repo: https://github.com/ajeyverma/CmdXManage" -ForegroundColor Yellow
    Write-Host ""

}
# Call header at the start
Ensure-ShowHeader-Integrity
Secure-Command
Show-Header
    Write-Host "Custom Command Manager" -ForegroundColor Cyan
    Write-Host "1. View Commands"
    Write-Host "2. Add Command"
    Write-Host "3. Edit Command"
    Write-Host "4. Remove Command"
    Write-Host "5. Settings"
    write-Host "6. Exit"    
}
function Add-Command {
     # ===============================
     # ADD COMMAND with Comparison
     # ===============================
# Step 1: Check if profile exists
if (-not (Test-Path $PROFILE)) {
    $createProfile = Read-Host "PowerShell profile not found. Do you want to create it? (Y/N)"
    if ($createProfile -match '^[Yy]$') {
        New-Item -Path $PROFILE -ItemType File -Force | Out-Null
        Write-Host "Profile created at $PROFILE" -ForegroundColor Green
    } else {
        Write-Host "Profile creation skipped. Cannot proceed without it." -ForegroundColor Red
        return
    }
} else {
    Write-Host "Profile exists: $PROFILE" -ForegroundColor Green
}

# Step 2: Check Execution Policy
$policy = Get-ExecutionPolicy -Scope CurrentUser
if ($policy -eq "Restricted") {
    Write-Host "Execution policy is Restricted. Changing to RemoteSigned..." -ForegroundColor Yellow
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Write-Host "Execution policy updated to RemoteSigned." -ForegroundColor Green
} else {
    Write-Host "Execution policy is already: $policy" -ForegroundColor Green
}

# Step 3: Get function name and validate
$funcName = Read-Host "Enter the new function name (example: vs)"
if ([string]::IsNullOrWhiteSpace($funcName)) {
    Write-Host "Error: Function name cannot be blank." -ForegroundColor Red
    break
}
if ($funcName -match '[^a-zA-Z0-9_]') {
    Write-Host "Error: Invalid function name. Use only letters, numbers, and underscores." -ForegroundColor Red
    break
}

# Step 3.1: Check if alias exists and disable if needed
### If you want get a confirmation before disabling the default system command, uncomment the block below
  if (Test-Path alias:$funcName) {
    #  $confirmtochangedefault = Read-Host "Are you sure you want to DISABLE THE DEFAULT-SYSTEM-COMMAND? (Yes/No)"
    # if ($confirmtochangedefault -notin @('Yes','yes','Y','y')) {
    #     Write-Host "Operation cancelled."
    #     break
    #            }
  
    
# Write-Host "~~Default system command/function is enabled" -ForegroundColor Red
# Write-Host "~~Default system command/function is now disabled" -ForegroundColor Green
# Write-Host "~~You can view & enable the disabled commands from the Settings" -ForegroundColor Yellow

    # Add alias removal to profile BEFORE adding the function
if (Test-Path alias:$funcName) {
    Remove-Item alias:$funcName -Force   # immediate removal
    $removeAliasBlock = @"
if (Test-Path alias:$funcName) { Remove-Item alias:$funcName -Force }
"@
    Add-Content -Path $PROFILE -Value "`n$removeAliasBlock"
}

} else {
# Write-Host "~~No default system command is enabled" -ForegroundColor Green
}
# Step 4: Refer user to website for command suggestions
Write-Host ""
Write-Host "👇 Here a list of function command suggestions" -ForegroundColor Yellow
Write-Host ""
CommandsList
write-host ""



# Step 4: Get command inside function and validate
$funcAction = Read-Host "Enter the command(s) to run inside the function"
if ([string]::IsNullOrWhiteSpace($funcAction)) {
    Write-Host "Error: Command inside function cannot be blank." -ForegroundColor Red
    break
}

# Step 5: Check if function already exists
$profileContent = Get-Content $PROFILE -Raw
$existingFunction = $null
if ($profileContent -match "(function\s+$funcName\s*\{[\s\S]*?\})") {
    $existingFunction = $matches[0]
}

# Step 6: If exists, print comparison
if ($existingFunction) {
    write-host "Fuction is already present in profile" -foregroundcolor red
    Write-Host "`nFunction:" -ForegroundColor Yellow
    Write-Host $existingFunction -ForegroundColor Red
    break
   
    }
    else {
      # Add new function
        $functionBlock = @"
function $funcName {
    $funcAction
}
"@
    Add-Content -Path $PROFILE -Value "`n$functionBlock"
    write-host ""
    write-host "New Added Function: "-nonewline -foregroundcolor cyan
    write-host "$funcName "-nonewline -foreground green
    write-host "=> " -nonewline
    write-host "$funcAction" -foregroundcolor red
    write-host ""
    Write-Host "~~Function " -nonewline
    write-host "$funcName " -nonewline -foregroundcolor green
    write-host "added to profile."
}

# Step 7: Reload profile to apply changes
. $PROFILE
Write-Host "~~Profile reloaded. You can now use the new function." -ForegroundColor Green

}
#________________________________________________________________________________________________________
function Edit-Command {
    
    # EDIT/REPLACE COMMAND
    # Step 1: Read profile content as lines
    $profileLines = Get-Content $PROFILE

    # Step 2: Extract function names
    $functionNames = @()
    for ($i=0; $i -lt $profileLines.Length; $i++) {
        if ($profileLines[$i] -match '^\s*function\s+([a-zA-Z0-9_]+)\s*\{') {
            $functionNames += $matches[1]
        }
    }

    if ($functionNames.Count -eq 0) {
        Write-Host "No functions found in your profile." -ForegroundColor Yellow
        return
    }

    Write-Host "Functions found in profile:" -ForegroundColor Cyan
    for ($idx=0; $idx -lt $functionNames.Count; $idx++) {
        Write-Host "[$($idx+1)] $($functionNames[$idx])"
    }

    # Step 3: Ask user for function to edit
    $input = Read-Host "Enter the function name or number to edit"

    # Determine if input is number or name
    if ([int]::TryParse($input, [ref]$null)) {
        $index = [int]$input - 1
        if ($index -lt 0 -or $index -ge $functionNames.Count) {
            Write-Host "Invalid number selection." -ForegroundColor Red
            return
        }
        $funcName = $functionNames[$index]
    } else {
        $funcName = $input.Trim()
        if (-not $functionNames -contains $funcName) {
            Write-Host "Function name '$funcName' not found in profile." -ForegroundColor Red
            return
        }
    }

    # Step 4: Find start and end lines of the function block
    $startIndex = -1
    for ($i=0; $i -lt $profileLines.Length; $i++) {
        if ($profileLines[$i] -match "^\s*function\s+$funcName\s*\{") {
            $startIndex = $i
            break
        }
    }

    if ($startIndex -eq -1) {
        Write-Host "Function '$funcName' not found in profile." -ForegroundColor Red
        return
    }

    # Track braces to find function end
    $braceCount = 0
    $endIndex = -1
    for ($i=$startIndex; $i -lt $profileLines.Length; $i++) {
        $line = $profileLines[$i]
        $braceCount += ($line -split '{').Length - 1
        $braceCount -= ($line -split '}').Length - 1
        if ($braceCount -eq 0) {
            $endIndex = $i
            break
        }
    }

    if ($endIndex -eq -1) {
        Write-Host "Could not find the end of the function '$funcName'." -ForegroundColor Red
        return
    }

    # Step 5: Show submenu: edit name or edit command
    Write-Host "What do you want to edit?" -ForegroundColor Cyan
    Write-Host "1. Edit function name"
    Write-Host "2. Edit function command(s)"
    Write-Host "3. Exit"
    $editChoice = Read-Host "Enter choice (1-3)"

    switch ($editChoice) {
1 {
    # Edit function name
    $newFuncName = Read-Host "Enter new function name"
    if ([string]::IsNullOrWhiteSpace($newFuncName)) {
        Write-Host "Error: Function name cannot be blank." -ForegroundColor Red
        break
    }
    if ($newFuncName -match '[^a-zA-Z0-9_]') {
        Write-Host "Error: Invalid function name. Use only letters, numbers, and underscores." -ForegroundColor Red
        break
    }
    if ($functionNames -contains $newFuncName) {
        Write-Host "Error: Function name '$newFuncName' already exists." -ForegroundColor Red
        break
    }

    # Replace function declaration line with new name
    $profileLines[$startIndex] = $profileLines[$startIndex] -replace "function\s+$funcName", "function $newFuncName"

    # --- Remove alias removal block for the OLD function name ---
    $pattern = "if\s*\(\s*Test-Path\s+alias:$funcName\s*\)\s*\{\s*Remove-Item\s+alias:$funcName\s*-Force\s*\}"
    $profileLines = $profileLines | Where-Object { $_ -notmatch $pattern }

    try {
        $profileLines | Set-Content $PROFILE
        Write-Host "Function name changed from '$funcName' to '$newFuncName'." -ForegroundColor Green

        # If the new function name is a system alias, disable it and add alias removal block
        if (Test-Path alias:$newFuncName) {
            
# Write-Host "Default system command/function is enabled for $newfuncName" -ForegroundColor Red
# Write-Host "Default system command/function is now disabled for $newfuncName" -ForegroundColor Green
# Write-Host "(You can view & enable the disabled commands from the Settings)" -ForegroundColor Yellow

            Remove-Item alias:$newFuncName -Force   # immediate removal
            $disableremoveAlias = @"
if (Test-Path alias:$newFuncName) { Remove-Item alias:$newfuncName -Force }
"@
            Add-Content -Path $PROFILE -Value "`n$disableremoveAlias"
# Write-Host "Alias removal block added for '$newFuncName'." -ForegroundColor Green
        } else {
        }

        # Reload profile
        . $PROFILE
        Write-Host "Profile reloaded." -ForegroundColor Green
    } catch {
        Write-Host "Error saving profile: $_" -ForegroundColor Red
    }
}
        2 {
            # Step 4: Refer user to website for command suggestions
            Write-Host ""
            Write-Host "👇 Here a list of function command suggestions" -ForegroundColor Yellow
            Write-Host ""
            CommandsList
            Write-Host ""

            # Edit function command(s)
            $newFuncBody = Read-Host "Enter new command(s) for function '$funcName'"

            if ([string]::IsNullOrWhiteSpace($newFuncBody)) {
                Write-Host "Error: Command inside function cannot be blank." -ForegroundColor Red
                return
            }

            # Rebuild profile lines with new function body
            $newProfileLines = @()

            # Copy lines before function (inclusive start line)
            for ($i=0; $i -le $startIndex; $i++) {
                $newProfileLines += $profileLines[$i]
            }

            # Add new function body lines (indentation preserved)
            $commands = $newFuncBody -split ';'
            foreach ($cmd in $commands) {
                $line = $cmd.Trim()
                if ($line -ne '') {
                    $newProfileLines += "    $line"
                }
            }

            # Add closing brace line
            $newProfileLines += "}"

            # Copy lines after function
            for ($i = $endIndex + 1; $i -lt $profileLines.Length; $i++) {
                $newProfileLines += $profileLines[$i]
            }
            
            try {
                $newProfileLines | Set-Content $PROFILE
                Write-Host "Function '$funcName' updated successfully." -ForegroundColor Green
                # Reload profile
                . $PROFILE
                Write-Host "Profile reloaded." -ForegroundColor Green
            } catch {
                Write-Host "Error saving profile: $_" -ForegroundColor Red
            }
        }
	3{
                break
            }
        
        default {
            Write-Host "Invalid choice. Returning to main menu." -ForegroundColor Yellow
            return
                }
   }


 
}
#________________________________________________________________________________________________________
function DisabledFunction {
$profileContent = Get-Content $PROFILE -ErrorAction SilentlyContinue

# Regex to match alias removal lines
$disabledAliases = foreach ($line in $profileContent) {
if ($line -match 'Remove-Item\s+alias:(\S+)') {
$matches[1]
}
}

if (-not $disabledAliases -or $disabledAliases.Count -eq 0) {
Write-Host "No disabled aliases found." -ForegroundColor Yellow
break
}

Write-Host "Disabled Aliases:" -ForegroundColor Cyan
for ($i = 0; $i -lt $disabledAliases.Count; $i++) {
Write-Host ("{0}. {1}" -f ($i + 1), $disabledAliases[$i]) -ForegroundColor Yellow
}

write-host "Remove Commands:" -foregroundcolor red
Write-Host "~~To remove single aliase, followed by serial number or name => 'remove aliasName'" -ForegroundColor Cyan
write-host "~~To remove multiple aliases, followed by serial numbers or names (comma-separated) => 'remove alias1,2,alias3'" -ForegroundColor Cyan
write-host "~~To remove all aliases, type 'remove all' to delete all" -ForegroundColor Cyan
write-host "--Or leave blank for no further action." -foregroundcolor yellow
$choice = Read-Host "Enter command"

if ($choice -match '^remove\s+all$') {
# Remove all alias removals
$profileContent = $profileContent | Where-Object {$_ -notmatch 'Remove-Item\s+alias:'}
# Also remove all functions with those names
foreach ($aliasName in $disabledAliases) {
$profileContent = Remove-FunctionBlockFromLines -Lines $profileContent -FuncName $aliasName
}
Write-Host "All disabled aliases and their functions have been removed." -ForegroundColor Green
}
elseif ($choice -match '^remove\s+(.+)$') {
$toRemove = $matches[1] -split '\s*,\s*'

foreach ($item in $toRemove) {
if ($item -match '^\d+$') {
# Remove by serial number
$index = [int]$item - 1
if ($index -ge 0 -and $index -lt $disabledAliases.Count) {
$aliasName = $disabledAliases[$index]
} else {
Write-Host "Invalid serial number: $item" -ForegroundColor Red
continue
}
} else {
# Remove by alias name
$aliasName = $item
}

# Remove alias removal line
$profileContent = $profileContent | Where-Object {$_ -notmatch "Remove-Item\s+alias:$aliasName"}
# Remove function block with the same name
$profileContent = Remove-FunctionBlockFromLines -Lines $profileContent -FuncName $aliasName
Write-Host "Removed disabled alias and also their function: $aliasName" -ForegroundColor Green
}
}

# Save changes if any were made
Set-Content $PROFILE $profileContent
}

function CommandsList {
    $commands = @(
        @{Cmd="Get-ChildItem -Force @args"; Desc="Lists all files and folders including hidden ones"},
        @{Cmd="Set-Location <path>"; Desc="Changes current directory to <path>"},
        @{Cmd="Set-Location $env:USERPROFILE\<path>"; Desc="Changes directory to a folder inside user profile"},
        @{Cmd="Set-Location @args"; Desc="Change your directory (like cd)"},
        @{Cmd="Clear-Host"; Desc="Clears the console screen"},
        @{Cmd="New-Item -ItemType Directory -Path <folderName>"; Desc="Creates a new directory"},
        @{Cmd="New-Item -ItemType Directory $args"; Desc="Creates a new directory (like mkdir)"},
        @{Cmd="Remove-Item @args"; Desc="Deletes files or folders"},
        @{Cmd="Get-Content @args"; Desc="Shows the content of a file"},
        @{Cmd="& 'full_path_to_executable' @args"; Desc="Runs an external program or executable"},
        @{Cmd="Copy-Item @args"; Desc="Copies files or folders"},
        @{Cmd="Move-Item @args"; Desc="Moves or renames files or folders"},
        @{Cmd="Rename-Item -Path <old> -NewName <new>"; Desc="Renames a file or folder"},
        @{Cmd="Test-Path <path>"; Desc="Checks if a file or folder exists"},
        @{Cmd="Get-Process"; Desc="Lists running processes"},
        @{Cmd="Stop-Process -Id <processId>"; Desc="Stops a running process by its ID"},
        @{Cmd="Get-Service"; Desc="Lists Windows services"},
        @{Cmd="Start-Service -Name <serviceName>"; Desc="Starts a Windows service"},
        @{Cmd="Stop-Service -Name <serviceName>"; Desc="Stops a Windows service"},
        @{Cmd="Restart-Service -Name <serviceName>"; Desc="Restarts a Windows service"},
        @{Cmd="Get-EventLog -LogName <logname>"; Desc="Views event logs"},
        @{Cmd="Get-Alias"; Desc="Lists all aliases"},
        @{Cmd="Set-Alias <aliasName> <cmdlet>"; Desc="Creates a new alias"},
        @{Cmd="Remove-Item -Path alias:<aliasName>"; Desc="Removes an alias"},
        @{Cmd="Write-Host <text>"; Desc="Prints text to the console"},
        @{Cmd="Get-Help <cmdlet>"; Desc="Shows help for a cmdlet"},
        @{Cmd="Import-Module <moduleName>"; Desc="Loads a PowerShell module"},
        @{Cmd="Export-Csv -Path <file.csv>"; Desc="Exports data to CSV file"},
        @{Cmd="Import-Csv -Path <file.csv>"; Desc="Imports data from CSV file"},
        @{Cmd="Measure-Object"; Desc="Measures properties of objects"},
        @{Cmd="Select-Object"; Desc="Selects properties of objects"},
        @{Cmd="Where-Object"; Desc="Filters objects based on condition"},
        @{Cmd="Sort-Object"; Desc="Sorts objects by property"},
        @{Cmd="Out-File -FilePath <file.txt>"; Desc="Sends output to a file"},
        @{Cmd="Start-Job -ScriptBlock { }"; Desc="Runs a background job"},
        @{Cmd="Receive-Job -Id <jobId>"; Desc="Retrieves job results"},
        @{Cmd="Wait-Job -Id <jobId>"; Desc="Waits for a job to complete"},
        @{Cmd="Get-Job"; Desc="Lists background jobs"},
        @{Cmd="Stop-Job -Id <jobId>"; Desc="Stops a background job"},
        @{Cmd="Get-History"; Desc="Shows command history"},
        @{Cmd="Invoke-History -Id <historyId>"; Desc="Runs a command from history"},
        @{Cmd="New-ItemProperty -Path <regPath> -Name <propName> -Value <value>"; Desc="Creates or sets registry property"},
        @{Cmd="Get-ItemProperty -Path <regPath>"; Desc="Gets registry property"},
        @{Cmd="Remove-ItemProperty -Path <regPath> -Name <propName>"; Desc="Removes registry property"},
        @{Cmd="Clear-Variable -Name <varName>"; Desc="Clears a variable"},
        @{Cmd="Get-Variable"; Desc="Lists variables"},
        @{Cmd="Set-Variable -Name <varName> -Value <value>"; Desc="Sets variable value"},
        @{Cmd="Read-Host -Prompt 'text'"; Desc="Prompts user for input"},
        @{Cmd="Test-Connection <hostname>"; Desc="Sends ping requests to test network"},
        @{Cmd="Get-NetIPAddress"; Desc="Displays IP configuration"},
        @{Cmd="New-Guid"; Desc="Generates a new GUID"},
        @{Cmd="Start-Process <program>"; Desc="Starts a process/application"},
        @{Cmd="Get-Location"; Desc="Shows current directory"},
        @{Cmd="Push-Location <path>"; Desc="Saves current directory and changes to new path"},
        @{Cmd="Pop-Location"; Desc="Returns to previous directory saved by Push-Location"}
    )

    # Find the longest command for alignment
    $maxLen = ($commands | ForEach-Object { $_.Cmd.Length } | Measure-Object -Maximum).Maximum + 4

    foreach ($c in $commands) {
        # Split the command into main + args
        $parts = $c.Cmd -split " ", 2
        $main = $parts[0]
        $args = if ($parts.Count -gt 1) { " " + $parts[1] } else { "" }

        # Combine for alignment (length of full command, not just main)
        $fullCmd = $main + $args
        $padding = " " * ($maxLen - $fullCmd.Length)

        # Print in colors
        Write-Host $main -ForegroundColor Yellow -NoNewline
        Write-Host $args -ForegroundColor Cyan -NoNewline
        Write-Host $padding -NoNewline
        Write-Host "- $($c.Desc)" -ForegroundColor White

    }
}

function Remove-FunctionBlockFromLines {
    param (
        [string[]]$Lines,
        [string]$FuncName
    )
    $startIndex = -1
    for ($i = 0; $i -lt $Lines.Length; $i++) {
        if ($Lines[$i] -match "^\s*function\s+$FuncName\s*\{") {
            $startIndex = $i
            break
        }
    }
    if ($startIndex -eq -1) {
        return $Lines
    }
    $braceCount = 0
    $endIndex = -1
    for ($i = $startIndex; $i -lt $Lines.Length; $i++) {
        $braceCount += ($Lines[$i] -split '{').Length - 1
        $braceCount -= ($Lines[$i] -split '}').Length - 1
        if ($braceCount -eq 0) {
            $endIndex = $i
            break
        }
    }
    if ($endIndex -eq -1) {
        return $Lines
    }
    # Remove the function block
    return $Lines[0..($startIndex-1)] + $Lines[($endIndex+1)..($Lines.Length-1)]
}
#________________________________________________________________________________________________________
function Remove-Command { 
    # REMOVE COMMAND

    # Step 1: Read profile content as lines
    $profileLines = Get-Content $PROFILE

    # Step 2: Extract function names from profile
    $functionNames = @()
    for ($i = 0; $i -lt $profileLines.Length; $i++) {
        if ($profileLines[$i] -match '^\s*function\s+([a-zA-Z0-9_]+)\s*\{') {
            $functionNames += $matches[1]
        }
    }

    if ($functionNames.Count -eq 0) {
        Write-Host "No functions found in your profile." -ForegroundColor Yellow
        return
    }

    Write-Host "Functions found in profile:" -ForegroundColor Cyan
    for ($idx = 0; $idx -lt $functionNames.Count; $idx++) {
        Write-Host "[$($idx + 1)] $($functionNames[$idx])"
    }

    # Step 3: Ask user for functions to remove (comma separated)
    $input = Read-Host "Enter function names or numbers to remove (comma separated)"

    if ([string]::IsNullOrWhiteSpace($input)) {
        Write-Host "No input provided. Operation cancelled." -ForegroundColor Yellow
        break
    }

    $inputs = $input -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne '' }

    $functionsToRemove = @()

    foreach ($item in $inputs) {
        if ([int]::TryParse($item, [ref]$null)) {
            $index = [int]$item - 1
            if ($index -ge 0 -and $index -lt $functionNames.Count) {
                $functionsToRemove += $functionNames[$index]
            } else {
                Write-Host "Invalid number selection: $item" -ForegroundColor Red
            }
        } else {
            if ($functionNames -contains $item) {
                $functionsToRemove += $item
            } else {
                Write-Host "Function name not found: $item" -ForegroundColor Red
            }
        }
    }

    if ($functionsToRemove.Count -eq 0) {
        Write-Host "No valid functions selected to remove." -ForegroundColor Yellow
        break
    }

    # Remove duplicates
    $functionsToRemove = $functionsToRemove | Select-Object -Unique

    # Step 4: Remove each function block from profile lines
    $indicesToRemove = @()
    foreach ($funcName in $functionsToRemove) {
        $startIndex = -1
        for ($i = 0; $i -lt $profileLines.Length; $i++) {
            if ($profileLines[$i] -match "^\s*function\s+$funcName\s*\{") {
                $startIndex = $i
                break
            }
        }
        if ($startIndex -eq -1) {
            Write-Host "Function '$funcName' not found in profile lines." -ForegroundColor Red
            continue
        }

        $braceCount = 0
        $endIndex = -1
        for ($i = $startIndex; $i -lt $profileLines.Length; $i++) {
            $braceCount += ($profileLines[$i] -split '{').Length - 1
            $braceCount -= ($profileLines[$i] -split '}').Length - 1
            if ($braceCount -eq 0) {
                $endIndex = $i
                break
            }
        }
        if ($endIndex -eq -1) {
            Write-Host "Could not find end of function '$funcName'." -ForegroundColor Red
            continue
        }

        # Mark lines to remove
        $indicesToRemove += ($startIndex..$endIndex)
    }

    # Remove duplicates and sort ascending
    $indicesToRemove = $indicesToRemove | Sort-Object -Unique

    # Build new array excluding the lines to remove
    $newProfileLines = @()
    for ($i = 0; $i -lt $profileLines.Length; $i++) {
        if ($indicesToRemove -notcontains $i) {
            $newProfileLines += $profileLines[$i]
        }
    }

    # --- NEW: Remove alias removal blocks for removed functions ---
    foreach ($funcName in $functionsToRemove) {
        $pattern = "if\s*\(\s*Test-Path\s+alias:$funcName\s*\)\s*\{\s*Remove-Item\s+alias:$funcName\s*-Force\s*\}"
        $newProfileLines = $newProfileLines | Where-Object { $_ -notmatch $pattern }
    }

    # Save the updated profile
    try {
        $newProfileLines | Set-Content $PROFILE
        Write-Host "Removed functions: $($functionsToRemove -join ', ')" -ForegroundColor Green
# Write-Host "Also removed disabled alias: $($functionsToRemove -join ', ')" -ForegroundColor Green
    } catch {
        Write-Host "Error saving profile: $_" -ForegroundColor Red
        break
    }

    # Reload profile
    try {
        . $PROFILE
        Write-Host "Profile reloaded." -ForegroundColor Green
    } catch {
        Write-Host "Error reloading profile: $_" -ForegroundColor Red
    }
}
function SecuFun {
     Write-Host "Warning:" -ForegroundColor Red
        Write-Host "~~ERROR: The header section has been modified!" -ForegroundColor Red
        Write-Host "~~Editing the Show-Header function is not allowed." -ForegroundColor Red
        Write-Host "~~This script will not run if the header is edited." -ForegroundColor Yellow
        Write-Host "~~Please restore the original header to continue." -ForegroundColor Yellow
        Write-Host "~~Exiting for your script reliability." -ForegroundColor red
        Exit
}
#________________________________________________________________________________________________________
function Ensure-ShowHeader-Integrity {
    $expectedHash = "58E99498F65B3E4E25F9DFED70CF7EB332B05F4C4F0024E9FC7862963D5291F0"
    $funcDef = (Get-Command Show-Header).Definition
    $actualHash = (Get-FileHash -InputStream ([System.IO.MemoryStream]::new([System.Text.Encoding]::UTF8.GetBytes($funcDef))) -Algorithm SHA256).Hash
    if ($actualHash -ne $expectedHash) {
        SecuFun
        exit
        
    }
}
while ($true) {
    Show-Menu
    $choice = Read-Host "Enter your choice (1-6)"

    switch ($choice) {

##########
1 {
$profilePath = $PROFILE

# Ensure profile exists
if (-Not (Test-Path $profilePath)) {
    New-Item -ItemType File -Path $profilePath -Force | Out-Null
    Write-Host "Profile created at $profilePath (currently empty)." -ForegroundColor Yellow
}

# Read content safely (empty file becomes empty string)
$content = Get-Content -Path $profilePath -Raw
if (-not $content) { $content = "" }

# Regex to find functions and bodies (multiline)
$functionPattern = '(?ms)function\s+(\w+)\s*\{(.*?)\}'
$matches = [regex]::Matches($content, $functionPattern)

if ($matches.Count -eq 0) {
    Write-Host "No functions found in your profile." -ForegroundColor Red
} else {
    $counter = 1
    foreach ($match in $matches) {
        $funcName = $match.Groups[1].Value

        # Clean and compress the function body to a single line string
        $funcBody = $match.Groups[2].Value -replace '\r?\n', ' '
        $funcBody = $funcBody -replace '\s+', ' '
        $funcBody = $funcBody.Trim()

        Write-Host "$counter. " -NoNewline
        Write-Host "$funcName " -NoNewline -ForegroundColor Green
        Write-Host "=> " -NoNewline
        Write-Host "$funcBody" -ForegroundColor Red
        $counter++
    }
}
    write-host "If you want to Add, Edit or Remove any command, then type 'Add', 'Edit' or 'remove'." -ForegroundColor Yellow
    $choicecmd = Read-Host "Enter command"
    if ($choicecmd -match '^(Add|add)$') {
        Add-Command
    } elseif ($choicecmd -match '^(Edit|edit)$') {
        Edit-Command
    } elseif ($choicecmd -match '^(Remove|remove)$') {
        Remove-Command
    } else {
        Write-Host "Invalid command. Returning to main menu." -ForegroundColor Red
    }
}

##########

2 { Add-Command }

##########

3 { Edit-Command }

##########

4 { Remove-Command }

##########

5 {

function Show-SettingsMenu {
    
        Clear-Host
        Write-Host "Settings Menu" -foregroundcolor red
        Write-Host ""
        Write-Host "1. Export functions"
        Write-Host "2. Import functions"
        Write-Host "3. Delete All Commands" -ForegroundColor Red
		Write-Host "4. Update Script" -ForegroundColor Yellow
# Write-Host "4. Disabled System Commands (Aliases)" -ForegroundColor cyan
        Write-Host "0. Exit"
        Write-Host ""
        Write-Host "If you want manage aliasremoval then type 'AliasManage' in Main Menu or choose 5 Here." -ForegroundColor yellow
        $choice = Read-Host "Enter your choice (0-5)"

        switch ($choice) {
            '1' {
                Export-ProfileFunctions
                Pause
            }
            '2' {
                Import-ProfileFunctions
                Pause
            }
	    '3'{
                deleteallfunctions
		Pause
	    }
        '4'{
            update
            break
        }
	    '5'{
DisabledFunction
		break
	    }
            '0' {
                break
            }
            default {
                Write-Host "Invalid choice, try again."
                break
            }
                        }
 			
    
}
function update {
    # GitHub raw link (replace with your repo link)
$githubUrl = "https://raw.githubusercontent.com/ajeyverma/CmdXManage/main/powershell.ps1"

# Local path to THIS script
$localScript = $MyInvocation.MyCommand.Path

# Only run update check if not already reloaded
if (-not $env:ScriptReloaded) {
    # Mark as reloaded (for this run)
    $env:ScriptReloaded = "1"

    # Check internet connection
    $Online = Test-Connection github.com -Count 1 -Quiet -ErrorAction SilentlyContinue

    if ($Online) {
        try {
            Write-Host "🌍 Internet available. Checking for update..."
            $remote = Invoke-WebRequest -Uri $githubUrl -UseBasicParsing
            $remoteContent = $remote.Content -join "`n"
            $localContent  = Get-Content $localScript -Raw

            if ($remoteContent -ne $localContent) {
                Write-Host "⬆️ Update found. Downloading new version..."
                $remoteContent | Out-File $localScript -Encoding UTF8
                Write-Host "✅ Update applied. Reloading script..."
                . $localScript   # Reload script in same window
                return           # Stop current instance
            }
            else {
                Write-Host "✅ Already up to date. Running local copy..."
            }
        }
        catch {
            Write-Host "⚠️ Failed to check/update from GitHub. Using local copy..."
            
        }
    }
    else {
        Write-Host "⚠️ No internet connection. Using local copy..."
        
    }
}
}

	#======delete all function=====

function deleteallfunctions {
    $profilePath = $PROFILE
    if (-Not (Test-Path $profilePath)) {
        Write-Host "Profile not found at $profilePath"
        return
    }

    $confirmation = Read-Host "Are you sure you want to REMOVE ALL FUNCTIONS from your profile? (Yes/No)"
    if ($confirmation -notin @('Yes','yes','Y','y')) {
        Write-Host "Operation cancelled."
        return
    }

    $content = Get-Content -Path $profilePath -Raw

    # Regex to remove all function blocks (simple balanced braces)
    $pattern = 'function\s+\w+\s*\{(?:[^{}]*|\{[^{}]*\})*\}'

     $matches = [regex]::Matches($content, $pattern)

    if ($matches.Count -eq 0) {
        Write-Host "No functions found in your profile." -ForegroundColor Red
        return
    }

    $newContent = [regex]::Replace($content, $pattern, '', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase -bor [System.Text.RegularExpressions.RegexOptions]::Singleline)

    # Remove extra blank lines
    $newContent = ($newContent -split "(\r?\n){2,}" | Where-Object {$_ -ne ''}) -join "`r`n"

    Set-Content -Path $profilePath -Value $newContent -Encoding UTF8

    Write-Host "All functions removed from profile: $profilePath" -foregroundcolor green

    # Removes all 'Remove-Item alias:...' lines from your PowerShell profile

    $profilePath = $PROFILE
    if (-Not (Test-Path $profilePath)) {
        Write-Host "Profile not found at $profilePath"
        return
    }
    $content = Get-Content -Path $profilePath
    $filtered = $content | Where-Object { $_ -notmatch 'Remove-Item\s+alias:' }
    Set-Content -Path $profilePath -Value $filtered -Encoding UTF8
# Write-Host "And also all alias removal lines deleted from profile." -ForegroundColor Green



}

	#======EXPORT FUNCTION======

function Export-ProfileFunctions {
    Add-Type -AssemblyName System.Windows.Forms

    $fbd = New-Object System.Windows.Forms.FolderBrowserDialog
    $fbd.Description = "Select folder to export functions & alias removals"
    $fbd.RootFolder = [Environment+SpecialFolder]::Desktop

    $result = $fbd.ShowDialog()

    if ($result -ne [System.Windows.Forms.DialogResult]::OK) {
        Write-Host "Export cancelled."
        return
    }

    $selectedFolder = $fbd.SelectedPath
    $outputFile = Join-Path -Path $selectedFolder -ChildPath "exported_profile_parts.ps1"

    $profilePath = $PROFILE
    if (-Not (Test-Path $profilePath)) {
        Write-Host "Profile not found at $profilePath"
        return
    }

    $content = Get-Content -Path $profilePath -Raw

    # Match functions
    $functionPattern = '(?ms)function\s+(\w+)\s*\{(.*?)\}'
    $functionMatches = [regex]::Matches($content, $functionPattern)

    # Match alias removals
    $aliasRemovalPattern = 'if\s*\(\s*Test-Path\s+alias:[^\)]+\)\s*\{\s*Remove-Item\s+alias:[^\}]+\}'
    $aliasMatches = [regex]::Matches($content, $aliasRemovalPattern)

    if ($functionMatches.Count -eq 0 -and $aliasMatches.Count -eq 0) {
        Write-Host "No functions or alias removals found in your profile."
        return
    }

    $exportDateTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    $header = "# Exported on $exportDateTime"

    # Build alias removal section
    $aliasText = ""
    foreach ($match in $aliasMatches) {
        $aliasText += $match.Value.Trim() + "`r`n"
    }

    # Build functions section
    $functionsText = ""
    foreach ($match in $functionMatches) {
        $functionsText += $match.Value.Trim() + "`r`n`r`n"
    }

    # Combine all into one export
    $finalExport = "$header`r`n$aliasText`r`n$functionsText"
    $finalExport | Out-File -FilePath $outputFile -Encoding UTF8

    Write-Host "Exported $($functionMatches.Count) functions and $($aliasMatches.Count) alias removals to $outputFile"
}


	#=====IMPORT FUCTION======

function Import-ProfileFunctions {
    Add-Type -AssemblyName System.Windows.Forms

    $ofd = New-Object System.Windows.Forms.OpenFileDialog
    $ofd.InitialDirectory = [Environment]::GetFolderPath("Desktop")
    $ofd.Filter = "PowerShell Scripts (*.ps1)|*.ps1|All Files (*.*)|*.*"
    $ofd.Title = "Select the functions/alias file to import"

    $result = $ofd.ShowDialog()

    if ($result -ne [System.Windows.Forms.DialogResult]::OK) {
        Write-Host "Import cancelled."
        return
    }

    $inputFile = $ofd.FileName
    $profilePath = $PROFILE

    # Ensure profile file exists
    if (-not (Test-Path $profilePath)) {
        New-Item -ItemType File -Path $profilePath -Force | Out-Null
        $profileContent = ""
    } else {
        $profileContent = Get-Content -Path $profilePath -Raw
        if (-not $profileContent) { $profileContent = "" }
    }

    if (-Not (Test-Path $inputFile)) {
        Write-Host "File not found: $inputFile"
        return
    }

    $fileContent = Get-Content -Path $inputFile -Raw

    # Match functions
    $functionPattern = '(?ms)function\s+(\w+)\s*\{.*?\}'
    $functionMatches = [regex]::Matches($fileContent, $functionPattern)

    # Match alias removals
    $aliasRemovalPattern = 'if\s*\(\s*Test-Path\s+alias:[^\)]+\)\s*\{\s*Remove-Item\s+alias:[^\}]+\}'
    $aliasMatches = [regex]::Matches($fileContent, $aliasRemovalPattern)

    if ($functionMatches.Count -eq 0 -and $aliasMatches.Count -eq 0) {
        Write-Host "No functions or alias removals found in the import file."
        return
    }

    # Remove existing functions from profile
    foreach ($match in $functionMatches) {
        $funcName = [regex]::Match($match.Value, 'function\s+(\w+)').Groups[1].Value
        if ($funcName) {
            $profileContent = [regex]::Replace($profileContent, "(?ms)function\s+$funcName\s*\{.*?\}", "")
        }
    }

    # Remove existing alias removals from profile
    foreach ($match in $aliasMatches) {
        if ($match.Value) {
            $aliasText = [regex]::Escape($match.Value)
            $profileContent = [regex]::Replace($profileContent, $aliasText, "")
        }
    }

    # Prepare new content
    $importHeader = "`r`n# Imported on $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') from $inputFile`r`n"

    $aliasTextFinal = ""
    foreach ($match in $aliasMatches) {
        $aliasTextFinal += $match.Value.Trim() + "`r`n"
    }

    $functionsTextFinal = ""
    foreach ($match in $functionMatches) {
        $functionsTextFinal += $match.Value.Trim() + "`r`n`r`n"
    }

    # Combine cleaned profile with new imports
    $finalProfile = $profileContent.Trim() + "`r`n$importHeader$aliasTextFinal`r`n$functionsTextFinal"

    # Save updated profile
    Set-Content -Path $profilePath -Value $finalProfile -Encoding UTF8

    Write-Host "Imported $($functionMatches.Count) functions and $($aliasMatches.Count) alias removals into $profilePath"
    Write-Host "Restart PowerShell or run `. `$PROFILE` to reload your profile."
}

# Start the settings menu
Show-SettingsMenu
}

##########

 6 {
            exit
        }

##########

exit {
            exit
        }

##########



##########

default {
            Write-Host "Invalid choice, please try again." -ForegroundColor Red
        }
    }

    Pause
}

