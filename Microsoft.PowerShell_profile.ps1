#############################################################################
# Enviroment
#############################################################################
$ENV:FZF_DEFAULT_OPTS = "--layout=reverse --inline-info --height=12"
$ENV:STARSHIP_CONFIG = "$HOME\dev\winconfig\config\starship.toml"

#############################################################################
# Option
#############################################################################
Set-PSReadlineOption -HistoryNoDuplicates
Set-PSReadlineOption -AddToHistoryHandler {
    param ($command)
    switch -regex ($command) {
        "^[a-z]$" { return $false }
        "exit" { return $false }
        "ls" { return $false }
        "ll" { return $false }
        "la" { return $false }
        "dev" { return $false }
    }
    return $true
}
# emacs like cursor move.
Set-PSReadLineOption -EditMode Emacs
# zsh like complete.
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

# Bell off
Set-PSReadlineOption -BellStyle None

#############################################################################
# Alias
#############################################################################
# util (like unix)
Set-Alias which Get-Command
Set-Alias touch New-Item

# enviroment
function Get-EnvironmentVariables {
    [Environment]::GetEnvironmentVariables().GetEnumerator() | Sort-Object -Property Key
}
Set-Alias env Get-EnvironmentVariables

function  Get-Path {
    Write-Output $ENV:Path.Split(";")
}
Set-Alias path Get-Path

# eza
function Get-Items-With-eza-l {
    eza -l -I "NTUSER*|ntuser*" -s name --time-style long-iso
}
function Get-Items-With-eza-a {
    eza -la -I "NTUSER*|ntuser*" -s name --time-style long-iso
}

if (Get-Command eza -ErrorAction SilentlyContinue) {
    Set-Alias ls eza
    Set-Alias ll Get-Items-With-eza-l
    Set-Alias la Get-Items-With-eza-a
}

# bat
if (Get-Command bat -ErrorAction SilentlyContinue) {
    Set-Alias cat bat
}

# fzf
function Get-FzfRepo {
    $repo = $(ghq list | fzf --layout=reverse --inline-info --height=12)
    Set-Location ( Join-Path $(ghq root) $repo)
}
Set-PSReadLineKeyHandler -Chord Ctrl+g -ScriptBlock {
    Get-FzfRepo
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}
Set-Alias dev Get-FzfRepo

function Get-FzfHistory {
    $histf = (Get-PSReadlineOption).HistorySavePath
    $out = $((Get-Content $histf) | fzf --tac)
    $out | Invoke-Expression
}
Set-Alias h Get-FzfHistory

#############################################################################
# Prompt
#############################################################################
function prompt {
    $date = Get-Date -UFormat "%Y/%m/%d %H:%M:%S"
    Write-Host "`r`n[" -NoNewLine
    Write-Host $date -NoNewLine
    Write-Host "]" -NoNewLine
    Write-Host " $pwd"

    $suc = $?;
    if (!$suc) {
        Write-Host "$" -NoNewLine -ForegroundColor Red;
    }
    else {
        Write-Host "$" -NoNewLine -ForegroundColor Green;
    }

    return " ";

}

if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (&starship init powershell)
}
