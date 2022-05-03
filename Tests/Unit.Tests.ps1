$ModuleName = "PsAdToolkit"

# Make sure one or multiple versions of the module are not loaded
Get-Module -Name $ModuleName | Remove-Module

# Find the Manifest file
$ManifestFile = "$(Split-Path (Split-Path -Parent -Path $MyInvocation.MyCommand.Definition))\$ModuleName.psd1"

# Import the module and store the information about the module
$ModuleInformation = Import-Module -Name $ManifestFile -PassThru

Describe "$ModuleName Module - Testing Manifest File (.psd1)" {
	Context "Manifest" {
		It "Should contains RootModule" {
			$ModuleInformation.RootModule | Should not BeNullOrEmpty
		}

		It "Should contains Author" {
			$ModuleInformation.Author | Should not BeNullOrEmpty
		}

		It "Should contains Company Name" {
			$ModuleInformation.CompanyName | Should not BeNullOrEmpty
		}

		It "Should contains Description" {
			$ModuleInformation.Description | Should not BeNullOrEmpty
		}

		It "Should contains Copyright" {
			$ModuleInformation.Copyright | Should not BeNullOrEmpty
		}

		It "Should contains a Project Link" {
			$ModuleInformation.ProjectURI | Should not BeNullOrEmpty
		}

		It "Should contains a Tags (For the PSGallery)"{
            $ModuleInformation.Tags.count | Should not BeNullOrEmpty
        }
	}	
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