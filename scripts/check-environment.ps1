# Read-only environment check. No credentials, writes, installs, or network requests.
[CmdletBinding()]
param()

$ErrorActionPreference = 'Continue'
$commandNames = @('hermes', 'python', 'uv', 'agy', 'claude', 'git', 'gh', 'soffice', 'pdftoppm')
$rows = foreach ($commandName in $commandNames) {
    $found = Get-Command $commandName -ErrorAction SilentlyContinue | Select-Object -First 1
    [pscustomobject]@{
        Command = $commandName
        Available = [bool]$found
        Location = if ($found) { $found.Source } else { '(not on PATH)' }
    }
}
$rows | Format-Table -AutoSize

$pythonCommand = Get-Command python -ErrorAction SilentlyContinue | Select-Object -First 1
if ($pythonCommand) {
    & $pythonCommand.Source -c 'import sys, importlib.util; print("Python:", sys.version.split()[0]); print("python-docx available:", importlib.util.find_spec("docx") is not None)'
}

if ($env:ProgramFiles) {
    $officePath = Join-Path $env:ProgramFiles 'LibreOffice\program\soffice.exe'
    Write-Output ('LibreOffice standard location exists: ' + (Test-Path -LiteralPath $officePath))
}
Write-Output 'Availability only. Login, model inference, gateway delivery, and document rendering were not tested.'
