[![Build status](https://ci.appveyor.com/api/projects/status/github/zimbeo/PsAdToolkit?svg=true)](https://ci.appveyor.com/project/zimbeo/psadtoolkit)

# PsAdToolkit
PsAdToolkit Module provides tooling to manage, upkeep, or audit a Windows Active Directory Environment. Tools are to be added as they are created.
## Requirements
- ActiveDirectory PowerShell Module
  - The simplest way to install the module is by following the instructions at this [link](https://docs.microsoft.com/en-us/archive/blogs/ashleymcglone/install-the-active-directory-powershell-module-on-windows-10)

## Installation from Psgallery
``Install-Module -Name PsAdToolkit -RequiredVersion 1.0``

## Usage
- Import the module
``Import-Module PsAdToolkit``
- Run the tool
``Start-PsAdToolkit``