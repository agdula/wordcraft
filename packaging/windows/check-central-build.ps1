# Personalized installers must contain the exact centrally reviewed build.
[CmdletBinding()]
param([Parameter(Mandatory=$true)][string]$App,
      [Parameter(Mandatory=$true)][string]$Root,
      [Parameter(Mandatory=$true)][string]$Bin)
$ErrorActionPreference = 'Stop'
$manifestPath = $env:CRAFT_CENTRAL_BUILD_MANIFEST
if (-not $manifestPath -or -not (Test-Path -LiteralPath $manifestPath)) {
    throw 'Use the central packaging workflow and its verified build manifest. Unverified executables may restore update popups.'
}
$manifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
$record = $manifest.$App
$head = (git -C $Root rev-parse HEAD).Trim()
if ($LASTEXITCODE -ne 0 -or $record.exit_code -ne 0 -or $record.revision -ne $head -or $record.build_label -notlike 'personal.centralupdates.*') {
    throw "No successful central build for the current $App revision."
}
foreach ($name in @("$App.exe", "$App-cli.exe")) {
    $expected = $record.binaries.$name.sha256
    if (-not $expected -or (Get-FileHash -LiteralPath (Join-Path $Bin $name) -Algorithm SHA256).Hash.ToLowerInvariant() -ne $expected) {
        throw "Refusing to package an unverified binary: $name"
    }
}
$status = git -C $Root status --porcelain
if ($LASTEXITCODE -ne 0 -or $status) { throw 'Commit reviewed source changes before packaging a central build.' }
Write-Output "$App central build hashes verified"
