# Write-Log PowerShell Function

A comprehensive PowerShell logging function that provides centralized, color-coded logging to both console and file with multiple severity levels and formatting options.

## Description

The `Write-Log` function is a robust logging solution designed to standardize log output across PowerShell scripts and modules. It combines console output with file logging, providing real-time feedback while maintaining persistent log records. The function supports multiple log levels with distinct color coding, automatic timestamping, indentation for hierarchical logging, and flexible file path management.

This function is particularly useful for:
- Script debugging and troubleshooting
- Production monitoring and auditing
- User feedback during long-running operations
- Creating structured log files for later analysis
- Maintaining consistent logging standards across multiple scripts

## Features

- **Dual Output**: Simultaneous console and file logging
- **Color-Coded Console Output**: Visual distinction between log levels
- **Multiple Log Levels**: Info, Success, Warning, Error, and Debug
- **Automatic Timestamping**: Consistent datetime formatting for all entries
- **Hierarchical Indentation**: Support for nested operation logging (0-10 levels)
- **Flexible File Paths**: Custom log file locations or automatic naming
- **Directory Auto-Creation**: Automatically creates log directories if they don't exist
- **Pipeline Support**: Accepts input from PowerShell pipeline
- **Console Suppression**: Option to log only to file without console output
- **UTF-8 Encoding**: Proper character encoding for international characters
- **Error Resilience**: Continues operation even if file writing fails

## Prerequisites

- **PowerShell version**: `5.1` or higher (compatible with PowerShell Core 6.0+)
- **Required modules**: None (uses built-in PowerShell cmdlets only)
- **Permissions**:
  - Write access to the specified log directory (or current directory if using default)
  - No administrator rights required unless writing to system directories

## Parameters

| Parameter | Type | Mandatory | Default | Description |
|-----------|------|-----------|---------|-------------|
| `Message` | String | Yes | - | The message to be logged. Accepts pipeline input. |
| `Level` | String | No | "Info" | Log level: Info, Success, Warning, Error, or Debug |
| `LogPath` | String | No | Auto-generated | Custom path for log file. If not specified, creates `PowerShell-YYYY-MM-DD.log` in current directory |
| `IndentLevel` | Integer | No | 0 | Indentation level (0-10). Each level adds 2 spaces to the message |
| `NoConsoleOutput` | Switch | No | False | Suppresses console output, writes only to log file |

### Log Level Color Mapping
- **Info**: Cyan
- **Success**: Green
- **Warning**: Yellow
- **Error**: Red
- **Debug**: Magenta

## Usage

### Basic Examples

```powershell
# Simple info message
Write-Log -Message "Application started successfully"

# Success message with custom log path
Write-Log -Message "Database backup completed" -Level Success -LogPath "C:\Logs\backup.log"

# Warning with indentation
Write-Log -Message "Configuration file not found, using defaults" -Level Warning -IndentLevel 1

# Error logging
Write-Log -Message "Failed to connect to remote server" -Level Error

# Debug information
Write-Log -Message "Variable value: $($MyVariable)" -Level Debug

# Silent logging (file only)
Write-Log -Message "Background process completed" -Level Success -NoConsoleOutput
```

### Advanced Usage Scenarios

```powershell
# Structured logging for a process
Write-Log -Message "Starting user authentication process" -Level Info
Write-Log -Message "Validating credentials" -Level Info -IndentLevel 1
Write-Log -Message "Credentials validated successfully" -Level Success -IndentLevel 1
Write-Log -Message "Loading user profile" -Level Info -IndentLevel 1
Write-Log -Message "User authentication completed" -Level Success

# Pipeline usage
"Processing file 1", "Processing file 2", "Processing file 3" | Write-Log -Level Info

# Error handling with logging
try {
    # Some risky operation
    Get-Content "nonexistent-file.txt"
}
catch {
    Write-Log -Message "File operation failed: $($_.Exception.Message)" -Level Error
}

# Custom log file with date/time
$LogFile = "C:\Logs\MyScript-$(Get-Date -Format 'yyyyMMdd-HHmmss').log"
Write-Log -Message "Script execution started" -Level Info -LogPath $LogFile
```

## Output

### Console Output Format
```
[2025-01-20 14:30:15] [INFO   ] Application started successfully
[2025-01-20 14:30:16] [SUCCESS] Database connection established
[2025-01-20 14:30:17] [WARNING]   Configuration file missing
[2025-01-20 14:30:18] [ERROR  ] Failed to load user data
[2025-01-20 14:30:19] [DEBUG  ]     Variable dump: $var = 'test'
```

### Log File Output
The log file contains identical formatting to console output but without color codes:
- **Location**: Default is `PowerShell-YYYY-MM-DD.log` in current directory
- **Encoding**: UTF-8 for proper character support
- **Format**: `[Timestamp] [Level] [Indentation]Message`
- **Append Mode**: New messages are added to existing log files

### Return Values
The function does not return any objects. All output is directed to console and/or log file.

## Error Handling and Logging

The `Write-Log` function implements comprehensive error handling:

### Directory Creation
- Automatically creates log directories if they don't exist
- Provides warning messages if directory creation fails
- Continues execution even if directory creation fails

### File Writing Errors
- Catches and reports file writing failures
- Continues with console output even if file logging fails
- Uses `Write-Warning` for non-critical error reporting

### Parameter Validation
- Validates log levels using `ValidateSet`
- Validates indent levels using `ValidateRange` (0-10)
- Provides meaningful error messages for invalid parameters

### Verbose Output
Use `-Verbose` parameter to see additional diagnostic information:
```powershell
Write-Log -Message "Test message" -Verbose
```

## Integration Examples

### In Scripts
```powershell
# At the beginning of your script
$LogPath = "C:\Logs\MyScript-$(Get-Date -Format 'yyyyMMdd').log"

Write-Log -Message "Script started" -Level Info -LogPath $LogPath
# Your script logic here
Write-Log -Message "Script completed successfully" -Level Success -LogPath $LogPath
```

### In Functions
```powershell
function Process-Data {
    param($Data)

    Write-Log -Message "Processing data set with $($Data.Count) items" -Level Info
    foreach ($item in $Data) {
        Write-Log -Message "Processing item: $($item.Name)" -Level Info -IndentLevel 1
        # Processing logic here
    }
    Write-Log -Message "Data processing completed" -Level Success
}
```

## Version History

| Version | Date       | Description                      |
| ------- | ---------- | -------------------------------- |
| 1.0     | 2025-06-25 | Initial release with core logging functionality |

## Author

- **Name:** Lucas Hadberg
- **Website:** [hadberg.eu](https://hadberg.eu/)
- **LinkedIn:** [Lucas Hadberg](https://www.linkedin.com/in/lucashadberg)
- **GitHub:** [LucasHadberg](https://github.com/LucasHadberg)
- **Twitter/X:** [@Lucas_Hadberg](https://x.com/Lucas_Hadberg)

---

*This function is part of a larger PowerShell utilities collection designed to improve script reliability and maintainability.*
