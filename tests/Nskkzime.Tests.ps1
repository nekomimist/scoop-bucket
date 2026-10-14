Describe 'nskkzime installation hooks' {
    BeforeAll {
        . "$env:SCOOP_HOME/lib/core.ps1"
        . "$env:SCOOP_HOME/lib/manifest.ps1"
        . "$env:SCOOP_HOME/lib/install.ps1"
        $manifest = Get-Content -LiteralPath "$PSScriptRoot/../bucket/nskkzime.json" -Raw -Encoding UTF8 | ConvertFrom-Json
        $dir = Join-Path $TestDrive 'package space'
        $package = Join-Path $dir 'package'
        New-Item -ItemType Directory -Path "$package/tools" -Force | Out-Null
        @'
param($Action, $PackageDirectory, $PowerShellPath)
if (Test-Path -LiteralPath (Join-Path $PackageDirectory 'fail')) { throw 'fixture child failed' }
Add-Content -LiteralPath (Join-Path $PackageDirectory 'calls.txt') -Value $Action
'@ | Set-Content -LiteralPath "$package/tools/scoop.ps1"
    }
    BeforeEach {
        $global = $false
        Remove-Item -LiteralPath "$package/calls.txt", "$package/fail" -ErrorAction SilentlyContinue
        Mock appdir { 'C:/fixture/pwsh' }
        Mock abort { throw $msg }
    }
    It 'preserves the registered IME during a Scoop update' {
        $cmd = 'update'
        Invoke-HookScript -HookType uninstaller -Manifest $manifest -ProcessorArchitecture 64bit
        Test-Path -LiteralPath "$package/calls.txt" | Should -BeFalse
    }
    It 'unregisters only on an explicit uninstall' {
        $cmd = 'uninstall'
        Invoke-HookScript -HookType uninstaller -Manifest $manifest -ProcessorArchitecture 64bit
        Get-Content -LiteralPath "$package/calls.txt" | Should -BeExactly 'Unregister'
    }
    It 'installs both initially and during updates' {
        foreach ($cmd in @('install', 'update')) {
            Invoke-HookScript -HookType installer -Manifest $manifest -ProcessorArchitecture 64bit
        }
        @(Get-Content -LiteralPath "$package/calls.txt") | Should -Be @('Install', 'Install')
    }
    It 'aborts when the child installer fails' {
        $cmd = 'install'
        New-Item -ItemType File -Path "$package/fail" | Out-Null
        { Invoke-HookScript -HookType installer -Manifest $manifest -ProcessorArchitecture 64bit } | Should -Throw -ExpectedMessage '*fixture child failed*'
    }
    It 'rejects a global installation before registration' {
        $global = $true
        { Invoke-HookScript -HookType pre_install -Manifest $manifest -ProcessorArchitecture 64bit } | Should -Throw -ExpectedMessage '*per-user Scoop*'
        Test-Path -LiteralPath "$package/calls.txt" | Should -BeFalse
    }
}
