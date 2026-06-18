# instalar-semilla.ps1
# Instala la semilla PBT-IA en ~/.claude/
# Ejecutar una sola vez por maquina.

$destino = "$HOME\.claude"
$skills  = "$HOME\.claude\skills"

New-Item -ItemType Directory -Force -Path $destino | Out-Null
New-Item -ItemType Directory -Force -Path $skills  | Out-Null

$repo = Split-Path $MyInvocation.MyCommand.Path

# Archivos a copiar
$archivos = @(
    @{ origen = "$repo\CLAUDE.md";                          destino = "$destino\CLAUDE.md" },
    @{ origen = "$repo\skills\pbt-ia-cycle.md";             destino = "$skills\pbt-ia-cycle.md" },
    @{ origen = "$repo\skills\new-project.md";              destino = "$skills\new-project.md" },
    @{ origen = "$repo\skills\pbt-ia-debugging.md";         destino = "$skills\pbt-ia-debugging.md" },
    @{ origen = "$repo\skills\pbt-ia-puntos-revision.md";   destino = "$skills\pbt-ia-puntos-revision.md" }
)

# Verificar que todos los archivos origen existen
$faltantes = 0
foreach ($a in $archivos) {
    if (-not (Test-Path $a.origen)) {
        Write-Host "FALTA: $($a.origen)" -ForegroundColor Red
        $faltantes++
    }
}
if ($faltantes -gt 0) {
    Write-Host "Abortando: $faltantes archivo(s) faltante(s)." -ForegroundColor Red
    exit 1
}

# Advertir si ya existe CLAUDE.md
if (Test-Path "$destino\CLAUDE.md") {
    Write-Host "ADVERTENCIA: Ya existe $destino\CLAUDE.md" -ForegroundColor Yellow
    $resp = Read-Host "Sobreescribir? (s/n)"
    if ($resp -ne "s") {
        Write-Host "Cancelado." -ForegroundColor Red
        exit 1
    }
}

# Copiar todos los archivos
foreach ($a in $archivos) {
    Copy-Item -Path $a.origen -Destination $a.destino -Force
    Write-Host "OK: $($a.destino)" -ForegroundColor Green
}

Write-Host ""
Write-Host "Semilla PBT-IA instalada correctamente." -ForegroundColor Cyan
Write-Host "Abre cualquier proyecto con: claude ."
