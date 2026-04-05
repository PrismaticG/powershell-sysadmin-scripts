# PowerShell Process Manager

A Windows sysadmin script for monitoring, filtering, and managing 
running processes with automatic housekeeping and registry logging.

## Features
- List all running processes in real time
- Search for a process by name (partial match supported)
- Terminate matching processes interactively
- Filter processes by parameter and export to timestamped CSV file
- Auto-housekeeping: keeps only the 5 most recent CSV exports
- Logs last script run time to Windows Registry

## How it works
The script runs in a continuous loop (every 30 seconds):
1. Displays all running processes
2. Prompts user to search for a specific process
3. Offers option to terminate found processes
4. Exports filtered process list to CSV
5. Removes old CSV files (keeps latest 5)
6. Updates registry key `HKCU:\Software\PowershellScriptRunTime`

## Usage
```powershell
.\process-manager.ps1
```
If execution policy blocks the script:
```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
```

## Tech
- PowerShell 5.1+
- Windows OS
- No external dependencies

## Notes
Built as part of OS & Security coursework at Vilnius University (2024).
Covers: Get-Process, Stop-Process, Export-Csv, Registry manipulation,
TextWatcher-style loop, error handling.
