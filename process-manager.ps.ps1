# Function to display the list of processes
function ShowProcessList {
    Write-Host "Fetching the list of processes..."
    $processList = Get-Process
    Write-Host "Here's the list of running processes: "
    $processList 
}

# Function to search for a process and terminate if needed
function FindAndTerminateProcess {
    param (
        [string]$searchTerm
    )

    $matchingProcesses = Get-Process | Where-Object { $_.Name -like "*$searchTerm*" }
    if ($matchingProcesses) {
        Write-Host "Processes found with names containing: $searchTerm"
        $matchingProcesses | Format-Table -AutoSize
        $choice = Read-Host "Would you like to terminate any of these processes? (Y/N)"
        if ($choice -eq "Y" -or $choice -eq "y") {
            $matchingProcesses | Stop-Process -Force
            Write-Host "Processes terminated successfully."
        } else {
            Write-Host "Process termination canceled."
        }
    } else {
        Write-Host "No processes found with names containing: $searchTerm"
    }
}

# Function to filter processes by parameter and save  to a CSV file
function FilterAndSaveToCSV {
    param (
        [string]$parameter
    )
    Write-Host "Filtering processes by $parameter and saving to CSV..."
    $processes = Get-Process | Select-Object Name, Id, $parameter
    $currentTime = Get-Date -Format "yyyy-MM-dd_HH-mm"
    $fileName = "FilteredProcessList_$currentTime.csv"
    $processes | Export-Csv -Path $fileName -NoTypeInformation
    Write-Host "Process list saved to file: $fileName"
}

# Function to manage files, keeping only the 5 latest
function PerformHousekeeping {
    Write-Host "Performing housekeeping..."
    $files = Get-ChildItem -Filter "FilteredProcessList_*.csv"
    if ($files.Count -gt 5) {
        $files | Sort-Object LastWriteTime | Select-Object -First ($files.Count - 5) | Remove-Item -Force
        Write-Host "Old files removed."
    } else {
        Write-Host "No housekeeping required."
    }
}

# Function to create or update a registry file
function UpdateRegistryFile {
    Write-Host "Updating registry..."
    $currentTime = Get-Date -Format "yyyy-MM-dd HH:mm"
    $registryPath = "HKCU:\Software\PowershellScriptRunTime"
    if (!(Test-Path $registryPath)) {
        New-Item -Path $registryPath -Force 
        Write-Host "Registry key created at: $registryPath"
    }
    Set-ItemProperty -Path $registryPath -Name "RunTime" -Value $currentTime
}

# Main script execution
while ($true) {
    ShowProcessList
    $processName = Read-Host "Enter a process name or part of it to search"
    FindAndTerminateProcess -searchTerm $processName 
    FilterAndSaveToCSV -parameter "VM"
    PerformHousekeeping
    UpdateRegistryFile
    Write-Host "Script execution completed."
    Start-Sleep -Seconds 30 # Wait for 30 seconds before looping again
}
