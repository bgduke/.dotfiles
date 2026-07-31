$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)

$links = @(
    @{
        Name = 'nvim'
        Source = Join-Path $repoRoot 'nvim\.config\nvim'
        Target = Join-Path $HOME 'AppData\Local\nvim'
    },
    @{
        Name = 'psmux'
        Source = Join-Path $repoRoot 'psmux\.psmux.conf'
        Target = Join-Path $HOME '.psmux.conf'
    },
    @{
        Name = 'powershell'
        Source = Join-Path $repoRoot 'powershell\Documents\PowerShell\Microsoft.PowerShell_profile.ps1'
        Target = Join-Path $HOME 'Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1'
    },
    @{
        Name = 'pwsh'
        Source = Join-Path $repoRoot 'powershell\Documents\PowerShell\Microsoft.PowerShell_profile.ps1'
        Target = Join-Path $HOME 'Documents\PowerShell\Microsoft.PowerShell_profile.ps1'
    },
    @{
        Name = 'glazewm'
        Source = Join-Path $repoRoot 'glazewm\.glzr'
        Target = Join-Path $HOME '.glzr'
    },
    @{
        Name = 'yasb'
        Source = Join-Path $repoRoot 'yasb\.config\yasb'
        Target = Join-Path $HOME '.config\yasb'
    },
    @{
        Name = 'starship'
        Source = Join-Path $repoRoot 'starship\.config\starship.toml'
        Target = Join-Path $HOME '.config\starship.toml'
    },
    @{
        Name = 'wezterm'
        Source = Join-Path $repoRoot 'wezterm\.config\wezterm'
        Target = Join-Path $HOME '.config\wezterm'
    },
    @{
        Name = 'vsvim'
        Source = Join-Path $repoRoot 'vsvim\.vsvimrc'
        Target = Join-Path $HOME '.vsvimrc'
    # },
    # @{
    #     Name = 'ideavim'
    #     Source = Join-Path $repoRoot 'ideavim\.ideavimrc'
    #     Target = Join-Path $HOME '.ideavimrc'
    # },
    # @{
    #     Name = 'fastfetch'
    #     Source = Join-Path $repoRoot 'fastfetch\.config\fastfetch'
    #     Target = Join-Path $HOME '.config\fastfetch'
    # # },
    # @{
    #     Name = 'komorebi'
    #     Source = Join-Path $repoRoot 'komorebi\komorebi.json'
    #     Target = Join-Path $HOME 'komorebi.json'
    # },
    # @{
    #     Name = 'komorebi-applications'
    #     Source = Join-Path $repoRoot 'komorebi\applications.json'
    #     Target = Join-Path $HOME 'applications.json'
    # },
    # @{
    #     Name = 'komorebi-whkd'
    #     Source = Join-Path $repoRoot 'komorebi\.config\whkdrc'
    #     Target = Join-Path $HOME '.config\whkdrc'
    }
)

function Remove-ExistingTarget {
    param([Parameter(Mandatory = $true)][string]$Path)

    if (-not (Test-Path -LiteralPath $Path)) {
        return
    }

    $item = Get-Item -LiteralPath $Path -Force
    if ($item.PSIsContainer) {
        Remove-Item -LiteralPath $Path -Recurse -Force
        return
    }

    Remove-Item -LiteralPath $Path -Force
}

function New-Link {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Target,
        [Parameter(Mandatory = $true)][bool]$IsDirectory
    )

    try {
        New-Item -ItemType SymbolicLink -Path $Path -Target $Target -Force | Out-Null
        return
    } catch {
        if (-not $IsDirectory) {
            throw
        }
    }

    New-Item -ItemType Junction -Path $Path -Target $Target -Force | Out-Null
}

foreach ($link in $links) {
    if (-not (Test-Path -LiteralPath $link.Source)) {
        Write-Warning ("Skipping {0}: source not found at {1}" -f $link.Name, $link.Source)
        continue
    }

    $targetParent = Split-Path -Parent $link.Target
    if (-not [string]::IsNullOrWhiteSpace($targetParent)) {
        $null = New-Item -ItemType Directory -Path $targetParent -Force
    }

    Remove-ExistingTarget -Path $link.Target

    $sourceItem = Get-Item -LiteralPath $link.Source -Force
    New-Link -Path $link.Target -Target $link.Source -IsDirectory $sourceItem.PSIsContainer
    Write-Host ("Linked {0}: {1} -> {2}" -f $link.Name, $link.Target, $link.Source)
}

Write-Host "Script finished."
Read-Host "Press Enter to exit"
