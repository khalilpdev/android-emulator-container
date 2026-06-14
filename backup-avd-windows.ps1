<#
backup-avd-windows.ps1
Backup de AVDs (Windows PowerShell)

Uso:
  - Executar sem parâmetros para fazer backup de todo %USERPROFILE%\.android\avd
    .\backup-avd-windows.ps1

  - Especificar o nome do AVD para backup só desse AVD:
    .\backup-avd-windows.ps1 -AvdName "Pixel_3a_API_28_Lite_2"

  - Especificar pasta de destino (ex: E:\Android\avd-backups):
    .\backup-avd-windows.ps1 -BackupDir "E:\Backups\avd"

O script cria um .zip com timestamp contendo a pasta .avd e o arquivo .ini correspondente.
#>
param(
    [string]$AvdName = "",
    [string]$BackupDir = "E:\Android\avd-backups"
)

$avdRoot = Join-Path $env:USERPROFILE ".android\avd"
if (-not (Test-Path $avdRoot)) {
    Write-Error "AVD root not found: $avdRoot"
    exit 1
}

# Ensure backup dir exists
if (-not (Test-Path $BackupDir)) { New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null }

$timestamp = (Get-Date).ToString('yyyyMMdd-HHmmss')
if ([string]::IsNullOrEmpty($AvdName)) {
    $archiveName = "avd-backup-$timestamp.zip"
    $source = $avdRoot
    Write-Host "Backing up entire AVD folder: $source -> $BackupDir\$archiveName"
    Compress-Archive -Path (Join-Path $source '*') -DestinationPath (Join-Path $BackupDir $archiveName) -Force
    if ($?) { Write-Host "Backup criado: $BackupDir\$archiveName" -ForegroundColor Green } else { Write-Error "Falha ao criar backup" }
    exit 0
}

# Specific AVD
$avdFolder = Join-Path $avdRoot ("$AvdName.avd")
$avdIni = Join-Path $avdRoot ("$AvdName.ini")
if (-not (Test-Path $avdFolder) -and -not (Test-Path $avdIni)) {
    Write-Error "Nenhum AVD encontrado com o nome '$AvdName' em $avdRoot"
    exit 2
}

$archiveName = "${AvdName}_backup_$timestamp.zip"
$tempDir = Join-Path $env:TEMP ("avd_backup_$timestamp")
New-Item -ItemType Directory -Path $tempDir -Force | Out-Null

# Copy files to temp and archive to avoid including parent folders
if (Test-Path $avdFolder) { Copy-Item -LiteralPath $avdFolder -Destination $tempDir -Recurse -Force }
if (Test-Path $avdIni) { Copy-Item -LiteralPath $avdIni -Destination $tempDir -Force }

$destArchive = Join-Path $BackupDir $archiveName
Compress-Archive -Path (Join-Path $tempDir '*') -DestinationPath $destArchive -Force

# Generate SHA256 checksum next to the archive
try {
    $hash = (Get-FileHash -Algorithm SHA256 -Path $destArchive).Hash
    $fileNameOnly = Split-Path -Leaf $destArchive
    "$hash  $fileNameOnly" | Out-File -FilePath ($destArchive + '.sha256') -Encoding ASCII
    Write-Host "Backup criado: $destArchive" -ForegroundColor Green
    Write-Host "Checksum criado: $($destArchive + '.sha256')" -ForegroundColor Green
} catch {
    Write-Warning "Backup gerado, mas falha ao criar checksum: $_"
}

# Cleanup
Remove-Item -LiteralPath $tempDir -Recurse -Force -ErrorAction SilentlyContinue

exit 0
