# Install SJP.PL's Hunspell data separately from the application and its updates.
[CmdletBinding()]
param(
    [string]$Destination = (Join-Path $env:LOCALAPPDATA 'WordCraft/dictionaries'),
    [string]$ArchivePath
)
$ErrorActionPreference = 'Stop'
$url = 'https://sjp.pl/sl/ort/sjp-hunspell-pl-20261101.zip'
$sha256 = 'a29b40d80a2501ba1ad84fa17f7d177e2ebe313082f74f837a77b3135c05340c'
$downloaded = -not $ArchivePath
if ($downloaded) {
    $ArchivePath = Join-Path ([IO.Path]::GetTempPath()) ([IO.Path]::GetRandomFileName())
}
try {
    if ($downloaded) { Invoke-WebRequest -Uri $url -OutFile $ArchivePath -UseBasicParsing }
    if ((Get-FileHash -LiteralPath $ArchivePath -Algorithm SHA256).Hash.ToLowerInvariant() -ne $sha256) {
        throw 'SJP.PL archive checksum mismatch; no dictionary files were installed.'
    }
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    $outer = [IO.Compression.ZipFile]::OpenRead((Resolve-Path -LiteralPath $ArchivePath).Path)
    try {
        $nested = $outer.GetEntry('pl_PL.zip')
        if ($null -eq $nested) { throw 'Missing pl_PL.zip in the SJP.PL archive.' }
        $stream = $nested.Open()
        try {
            $inner = New-Object IO.Compression.ZipArchive($stream, [IO.Compression.ZipArchiveMode]::Read)
            try {
                $names = @('pl_PL.aff', 'pl_PL.dic', 'README_pl_PL.txt')
                foreach ($name in $names) {
                    if ($null -eq $inner.GetEntry($name)) { throw "Missing dictionary file: $name" }
                }
                New-Item -ItemType Directory -Path $Destination -Force | Out-Null
                foreach ($name in $names) {
                    [IO.Compression.ZipFileExtensions]::ExtractToFile($inner.GetEntry($name), (Join-Path $Destination $name), $true)
                }
            } finally { $inner.Dispose() }
        } finally { $stream.Dispose() }
    } finally { $outer.Dispose() }
    Write-Output "Polish Hunspell dictionary installed in $Destination (SJP.PL 2026-11-01, Apache-2.0). Restart WordCraft to reload proofing data."
} finally {
    if ($downloaded -and (Test-Path -LiteralPath $ArchivePath)) { Remove-Item -LiteralPath $ArchivePath -Force }
}
