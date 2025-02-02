# winconfig

My Windows config.

## Setup

### Powershell

{CLONE_DIR} is equal folder cloned this repository.

```powershell
New-Item -ItemType SymbolicLink -Path $PROFILE -Target "{CLONE_DIR}\Microsoft.PowerShell_profile.ps1"
```

### Scoop

[Scoop](https://scoop.sh/)


```powershell
scoop install git ghq fzf
scoop install eza bat ripgrep

scoop bucket add versions
scoop install neovim-nightly
scoop install lua-language-server
```

### ghq

```powershell
git config --global ghq.root '~/dev'
```
