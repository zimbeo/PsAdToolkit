$ModuleName = "PsAdToolkit"

# Make sure one or multiple versions of the module are not loaded
Get-Module -Name $ModuleName | Remove-Module

# Find the Manifest file
$ManifestFile = "$(Split-Path (Split-Path -Parent -Path $MyInvocation.MyCommand.Definition))\$ModuleName.psd1"

# Import the module and store the information about the module
$ModuleInformation = Import-Module -Name $ManifestFile -PassThru

It 'should validate the module manifest' {
	{ Test-ModuleManifest -Path $ManifestFile -ErrorAction Stop } | Should -Not throw
}

Describe 'PSScriptAnalyzer tests' {

	It 'should pass all analyzer rules' {

		$excludedRules = @(
			'PSUseShouldProcessForStateChangingFunctions',
			'PSUseToExportFieldsInManifest',
			'PSAvoidInvokingEmptyMembers',
			'PSUsePSCredentialType',
			'PSAvoidUsingPlainTextForPassword'
			'PSAvoidUsingConvertToSecureStringWithPlainText'
		)

		Invoke-ScriptAnalyzer -Path $PSScriptRoot -ExcludeRule $excludedRules -Severity Error | Select-Object -ExpandProperty RuleName | Should -BeNullOrEmpty
	}
}