$ErrorActionPreference = 'Continue'

function Test-Command {
    param([Parameter(Mandatory = $true)][string]$Name)

    return $null -ne (Get-Command -Name $Name -ErrorAction SilentlyContinue)
}

function Add-PathEntry {
    param([Parameter(Mandatory = $true)][string]$Path)

    if ([string]::IsNullOrWhiteSpace($Path)) {
        return
    }

    $expanded = [Environment]::ExpandEnvironmentVariables($Path)
    if (-not (Test-Path -LiteralPath $expanded)) {
        return
    }

    $currentEntries = @($env:PATH -split [IO.Path]::PathSeparator)
    if ($currentEntries -contains $expanded) {
        return
    }

    $env:PATH = '{0}{1}{2}' -f $expanded, [IO.Path]::PathSeparator, $env:PATH
}

function Invoke-IfCommand {
    param(
        [Parameter(Mandatory = $true)][string]$Name,
        [Parameter(Mandatory = $true)][scriptblock]$ScriptBlock
    )

    if (Test-Command $Name) {
        & $ScriptBlock
    }
}

function backup {
    param([Parameter(Mandatory = $true, Position = 0)][string]$Path)

    Copy-Item -LiteralPath $Path -Destination "$Path.bak"
}

function copy {
    param(
        [Parameter(Mandatory = $true, Position = 0)][string]$Source,
        [Parameter(Mandatory = $true, Position = 1)][string]$Destination
    )

    if (Test-Path -LiteralPath $Source -PathType Container) {
        Copy-Item -LiteralPath $Source -Destination $Destination -Recurse
        return
    }

    Copy-Item -LiteralPath $Source -Destination $Destination
}

function mkcd {
    param([Parameter(Mandatory = $true, Position = 0)][string]$Path)

    $null = New-Item -ItemType Directory -Path $Path -Force
    Set-Location -LiteralPath $Path
}

function extract {
    param([Parameter(Mandatory = $true, Position = 0)][string]$Archive)

    switch -Regex ($Archive) {
        '\.(tar\.gz|tgz)$' { tar -xvzf $Archive; break }
        '\.tar\.xz$' { tar -xvJf $Archive; break }
        '\.zip$' { Expand-Archive -LiteralPath $Archive -DestinationPath (Get-Location); break }
        '\.rar$' {
            if (Test-Command 'unrar') {
                unrar x $Archive
            } else {
                Write-Host 'unrar is not installed.'
            }
            break
        }
        default { Write-Host 'Unsupported archive' }
    }
}

function history {
    Get-History |
        Select-Object Id, StartExecutionTime, CommandLine
}

function .. { Set-Location .. }
function ... { Set-Location ../.. }
function .... { Set-Location ../../.. }
function ..... { Set-Location ../../../.. }

function g { git @args }
function gs { git status @args }
function ga { git add @args }
function gc { git commit @args }
function gp { git push @args }
function gl { git log --oneline --graph --decorate @args }

function v { nvim @args }
function c { Clear-Host }
function ff { fastfetch @args }
function tm { tmux @args }
function tma { tmux attach @args }
function tmn { tmux new-session @args }

function wget {
    if (Test-Command 'wget.exe') {
        & wget.exe -c @args
        return
    }

    & wget -c @args
}
function tarnow { tar -acf @args }
function untar { tar -zxvf @args }

if (Test-Command 'eza') {
    function ls { eza -al --icons=always --group-directories-first @args }
    function la { eza -a --icons=always --group-directories-first @args }
    function ll { eza -lg --icons=always --group-directories-first @args }
    function lt { eza -aT --icons=always --group-directories-first @args }
}

function cp {
    Copy-Item @args -Confirm
}

function mv {
    Move-Item @args -Confirm
}

function rm {
    Remove-Item @args -Confirm
}

$env:EDITOR = 'nvim'
$env:VISUAL = 'nvim'
$env:TERMINAL = 'wezterm'
$env:BROWSER = 'helium'
$env:MANROFFOPT = '-c'

if (Test-Command 'bat') {
    $env:MANPAGER = "sh -c 'col -bx | bat -l man -p'"
}

$homeEntries = @(
    (Join-Path $HOME '.local\bin'),
    (Join-Path $HOME '.scripts'),
    (Join-Path $HOME '.cargo\bin'),
    (Join-Path $HOME 'Applications\depot_tools'),
    (Join-Path $HOME 'root\.dotnet\tools'),
    (Join-Path $HOME '.dotnet\tools')
)

foreach ($entry in $homeEntries) {
    Add-PathEntry $entry
}

if ($Host.Name -eq 'ConsoleHost' -and (Get-Variable -Name IsWindows -ErrorAction SilentlyContinue)) {
    try {
        Import-Module PSReadLine -ErrorAction Stop
        Set-PSReadLineOption -PredictionSource History
        Set-PSReadLineOption -HistorySearchCursorMovesToEnd
        Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
        Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
    } catch {
    }
}

Invoke-IfCommand 'zoxide' {
    Invoke-Expression (& zoxide init powershell | Out-String)
}

Invoke-IfCommand 'direnv' {
    Invoke-Expression (& direnv hook pwsh | Out-String)
}

Invoke-IfCommand 'starship' {
    Invoke-Expression (& starship init powershell)
}
