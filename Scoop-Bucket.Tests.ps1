if (!$env:SCOOP_HOME) { $env:SCOOP_HOME = (Resolve-Path (scoop prefix scoop)).Path }
. "$env:SCOOP_HOME/test/Import-Bucket-Tests.ps1"
