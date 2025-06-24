<#
.SYNOPSIS
    Writes formatted log messages to both console and file with color-coded output.

.DESCRIPTION
    This function provides a centralized logging mechanism that writes timestamped,
    formatted messages to both the console (with colors) and a log file. Supports
    different log levels, indentation, and automatic log file creation.

.PARAMETER Message
    The message to be logged.

.PARAMETER Level
    The log level (Info, Success, Warning, Error, Debug). Default is Info.

.PARAMETER LogPath
    Custom path for the log file. If not specified, creates a timestamped log in current directory.

.PARAMETER IndentLevel
    Number of indentation levels (0-10). Each level adds 2 spaces.

.PARAMETER NoConsoleOutput
    Suppresses console output, only writes to log file.

.EXAMPLE
    Write-Log -Message "Database connection established" -Level Success

.EXAMPLE
    Write-Log -Message "Processing user authentication" -Level Info -IndentLevel 1

.EXAMPLE
    Write-Log -Message "Invalid credentials provided" -Level Warning -LogPath "/Users/admin/logs/auth.log"

.EXAMPLE
    Write-Log -Message "System backup completed successfully" -Level Success -NoConsoleOutput

.NOTES
    Version: 1.0
    Author: Lucas Hadberg
    Creation Date: 25-06-2025

.LINK
    https://hadberg.eu
#>
function Write-Log {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$Message,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Info", "Success", "Warning", "Error", "Debug")]
        [string]$Level = "Info",

        [Parameter(Mandatory = $false)]
        [string]$LogPath,

        [Parameter(Mandatory = $false)]
        [ValidateRange(0, 10)]
        [int]$IndentLevel = 0,

        [Parameter(Mandatory = $false)]
        [switch]$NoConsoleOutput
    )

    begin {
        # Set default log path if not provided
        if (-not $LogPath) {
            $LogPath = Join-Path -Path $PWD -ChildPath "PowerShell-$(Get-Date -Format 'yyyy-MM-dd').log"
        }

        # Ensure log directory exists
        $LogDirectory = Split-Path -Path $LogPath -Parent
        if ($LogDirectory -and -not (Test-Path -Path $LogDirectory)) {
            try {
                New-Item -Path $LogDirectory -ItemType Directory -Force -ErrorAction Stop | Out-Null
                Write-Verbose "Created log directory: $LogDirectory"
            }
            catch {
                Write-Warning "Failed to create log directory '$LogDirectory': $($_.Exception.Message)"
                return
            }
        }
    }

    process {
        try {
            # Generate timestamp
            $TimeStamp = Get-Date -Format '[yyyy-MM-dd HH:mm:ss]'

            # Format log level with consistent width
            $LevelFormatted = switch ($Level) {
                "Info" { "[INFO   ]" }
                "Success" { "[SUCCESS]" }
                "Warning" { "[WARNING]" }
                "Error" { "[ERROR  ]" }
                "Debug" { "[DEBUG  ]" }
            }

            # Create indentation (2 spaces per level)
            $Indent = "  " * $IndentLevel

            # Build the complete log message
            $FormattedMessage = "$TimeStamp $LevelFormatted $Indent$Message"

            # Write to log file
            try {
                $FormattedMessage | Out-File -FilePath $LogPath -Append -Encoding UTF8 -ErrorAction Stop
                Write-Verbose "Log message written to: $LogPath"
            }
            catch {
                Write-Warning "Failed to write to log file '$LogPath': $($_.Exception.Message)"
                # Continue execution to still show console output
            }

            # Write to console with colors (unless suppressed)
            if (-not $NoConsoleOutput) {
                $ConsoleColor = switch ($Level) {
                    "Info" { "Cyan" }
                    "Success" { "Green" }
                    "Warning" { "Yellow" }
                    "Error" { "Red" }
                    "Debug" { "Magenta" }
                }
                Write-Host $FormattedMessage -ForegroundColor $ConsoleColor
            }
        }
        catch {
            Write-Error "Failed to process log message: $($_.Exception.Message)" -ErrorAction Continue
        }
    }
}