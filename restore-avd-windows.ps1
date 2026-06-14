<#
restore-avd-windows.ps1
Restaurar AVDs (Windows PowerShell)

Uso:
  .\restore-avd-windows.ps1 -ArchivePath "E:\Android\avd-backups\Pixel_3a_API_28_Lite_2_backup_20240613-123456.zip"
  .\restore-avd-windows.ps1                        # usa arquivo mais recente em E:\Android\avd-backups
  .\restore-avd-windows.ps1 -ArchivePath "..." -Force  # sobrescreve sem perguntar

O script extrai o zip para uma pasta temporária e copia os arquivos (.avd + .ini)
para %USERPROFILE%\.android\avd. Se já existir, pede confirmação salvo -Force.
#>
param(
    [string]$ArchivePath = "",
    [switch]$Force = $false,
    [string]$BackupDir = "E:\Android\avd-backups"
)

$avdRoot = Join-Path $env:USERPROFILE ".android\avd"
if (-not (Test-Path $avdRoot)) { New-Item -ItemType Directory -Path $avdRoot -Force | Out-Null }

if ([string]::IsNullOrWhiteSpace($ArchivePath)) {
    if (-not (Test-Path $BackupDir)) { Write-Error "Backup dir not found: $BackupDir"; exit 2 }
    $latest = Get-ChildItem -Path $BackupDir -Filter '*.zip' | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if (-not $latest) { Write-Error "Nenhum arquivo .zip encontrado em $BackupDir"; exit 3 }
    $ArchivePath = $latest.FullName
}

if (-not (Test-Path $ArchivePath)) { Write-Error "Arquivo de backup não encontrado: $ArchivePath"; exit 4 }

# Verify checksum if present
$shaFile = $ArchivePath + '.sha256'
if (Test-Path $shaFile) {
    try {
        $expectedLine = Get-Content -Path $shaFile -ErrorAction Stop | Select-Object -First 1
        $expectedHash = ($expectedLine -split '\s+')[0]
        $actualHash = (Get-FileHash -Algorithm SHA256 -Path $ArchivePath).Hash
        if ($expectedHash -ne $actualHash) {
            Write-Error "Checksum mismatch: $shaFile does not match $ArchivePath"; Remove-Item -LiteralPath $temp -Recurse -Force -ErrorAction SilentlyContinue; exit 5
        } else {
            Write-Host "Checksum OK: $shaFile" -ForegroundColor Green
        }
    } catch {
        Write-Warning "Falha ao verificar checksum: $_"
    }
}

$timestamp = (Get-Date).ToString('yyyyMMdd-HHmmss')
$temp = Join-Path $env:TEMP ("avd_restore_$timestamp")
New-Item -ItemType Directory -Path $temp -Force | Out-Null

Write-Host "Extraindo $ArchivePath para $temp..."
try {
    Expand-Archive -Path $ArchivePath -DestinationPath $temp -Force
} catch {
    Write-Error "Falha ao extrair o arquivo: $_"; Remove-Item -LiteralPath $temp -Recurse -Force -ErrorAction SilentlyContinue; exit 5
}

# Find .avd folders and .ini files in temp
$items = Get-ChildItem -Path $temp -Force
if (-not $items) { Write-Error "Arquivo extraído vazio?"; Remove-Item -LiteralPath $temp -Recurse -Force -ErrorAction SilentlyContinue; exit 6 }

foreach ($entry in $items) {
    if ($entry.PSIsContainer -and $entry.Name -like '*.avd') {
        $dest = Join-Path $avdRoot $entry.Name
        if ((Test-Path $dest) -and (-not $Force.IsPresent)) {
            $ans = Read-Host "AVD '$($entry.Name)' já existe em $avdRoot. Sobrescrever? (y/N)"
            if ($ans -notin @('y','Y')) { Write-Host "Pulando $($entry.Name)"; continue }
        }
        if (Test-Path $dest) { Remove-Item -LiteralPath $dest -Recurse -Force -ErrorAction SilentlyContinue }
        Write-Host "Copiando $($entry.Name) -> $dest"
        Copy-Item -LiteralPath $entry.FullName -Destination $dest -Recurse -Force
    } elseif ($entry.PSIsContainer -eq $false -and $entry.Name -like '*.ini') {
        $destIni = Join-Path $avdRoot $entry.Name
        if ((Test-Path $destIni) -and (-not $Force.IsPresent)) {
            $ans = Read-Host "Arquivo ini '$($entry.Name)' já existe. Sobrescrever? (y/N)"
            if ($ans -notin @('y','Y')) { Write-Host "Pulando $($entry.Name)"; continue }
        }
        Copy-Item -LiteralPath $entry.FullName -Destination $destIni -Force
        Write-Host "Restaurado $($entry.Name) -> $destIni"
    }
}

# Cleanup
Remove-Item -LiteralPath $temp -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "Restauração concluída. Abra o AVD Manager no Android Studio ou rode 'emulator -list-avds' para verificar." -ForegroundColor Green
exit 0
