# actualizar-semilla-pbt-ia.ps1
# Actualiza el repo semilla-pbt-ia con los cambios de debugging PBT-IA
# Ejecutar desde dentro de la carpeta semilla-pbt-ia clonada

$repo = Split-Path $MyInvocation.MyCommand.Path
$skills = "$repo\skills"

# Crear carpeta skills si no existe
New-Item -ItemType Directory -Force -Path $skills | Out-Null

# ============================================================
# 1. CLAUDE.md global actualizado
# ============================================================
$claudeMd = @'
# Configuracion Global PBT-IA

Este archivo es la semilla global de todos los proyectos de Pablo (Servicios Digitales PBT).
Claude Code lo lee automaticamente al iniciar cualquier sesion.

---

## Metodologia

El desarrollo sigue la metodologia PBT-IA. Los roles son:
- Product Owner (Pablo): decide que se construye, ejecuta comandos, aprueba commits
- Director Tecnico (Claude chat): arquitectura y decisiones tecnicas
- Programador (Claude Code): ejecuta ciclos PBT-IA, escribe todo el codigo

## Reglas de Oro

1. Todo el codigo lo escribe Claude Code en ciclos PBT-IA
2. Cada slice: maximo 200 lineas
3. Los cambios se entregan como DIFF unificado por archivo
4. No se modifican archivos fuera del alcance sin autorizacion
5. No se hacen commits sin aprobacion explicita de Pablo
6. NUNCA ASUMIR NADA: solo trabajar con informacion 100% verificable
7. Toda feature nueva queda bajo feature flag en false

---

## Ciclo PBT-IA

Se activa con: "ciclo", "slice", "PBT-IA", "siguiente slice"

- Fase A: Contrato (BLOQUEANTE, esperar aprobacion antes de continuar)
- Fase B: Tests que intentan romper el slice (ver skill pbt-ia-cycle)
- Fase C: Implementacion minima
- Fase D: Verificacion + Feature Flag
- Cierre: resumen y pregunta de commit

---

## Debugging

Protocolo completo: skill pbt-ia-debugging
Se activa con: "hay un bug", "se rompio", "dejo de funcionar", "sigue pasando"
Registro de bugs resueltos: BUGS.md en la raiz de cada proyecto

---

## Puntos de Revision Obligatorios

Ver skill pbt-ia-puntos-revision
Se activan por senales, no por calendario:
1. Slice que toca una zona fragil conocida (BUGS.md del proyecto)
2. Mas de 5 slices sin correr ponytail audit
3. Antes de cualquier deploy a produccion

---

## Sesion 0

Cuando Pablo describe un proyecto nuevo, generar exactamente 4 artefactos:
PRD.md, CLAUDE.md del proyecto, CONTEXT-CLAUDE-CHAT.md, script PowerShell.

El script PowerShell debe:
- Buscar los 3 archivos en la misma carpeta que el script
- Verificar que existen antes de continuar
- No usar && para encadenar comandos
- No incluir caracteres especiales fuera de ASCII en here-strings
- Crear BUGS.md vacio en la raiz del proyecto
- Agregar seccion "Zonas de riesgo conocidas" al PRD.md
- Agregar referencia al protocolo de debugging en el CLAUDE.md del proyecto

---

## Herramientas disponibles

- ponytail: reduccion de complejidad, usar /ponytail audit antes de refactors
- improve: auditoria de codebase, usar /improve antes de deploys grandes
- drawio: diagramas de arquitectura, usar cada 3-4 slices o en Sesion 0
- github: gestion de issues desde Claude Code

---

## Stack habitual

Next.js 14/15, TypeScript, Drizzle ORM, Neon (PostgreSQL), Vercel, Tailwind CSS
'@

# ============================================================
# 2. skill pbt-ia-cycle.md actualizado (Fase B reformulada)
# ============================================================
$skillCiclo = @'
---
name: pbt-ia-cycle
description: Ejecuta un ciclo completo PBT-IA. Activar cuando Pablo diga "ciclo", "slice", "siguiente slice", "PBT-IA", "tests rojos", o "contratos primero".
---

# Skill: Ciclo PBT-IA

## Inputs minimos requeridos antes de implementar
- PRD.md o descripcion del slice
- Stack del proyecto (leer CLAUDE.md del proyecto)
- Files-to-touch (obligatorio antes de Fase C)
- Comandos de verificacion disponibles

---

## Fase A: Contrato (BLOQUEANTE)

1. Leer PRD.md y el CLAUDE.md del proyecto
2. Identificar el siguiente slice no completado del backlog
3. Proponer contrato ejecutable segun el stack del proyecto
4. Entregar:
   - Lista de endpoints/funciones/eventos cubiertos
   - Ejemplos de inputs/outputs
5. Esperar aprobacion. No avanzar sin ella.

---

## Fase B: Tests que intentan romper el slice

### Paso 1: Analisis de riesgos (BLOQUEANTE)

Antes de escribir un solo test, completar esta lista para el slice especifico.
Los items marcados definen que tests se escriben.

- [ ] Renderizado condicional segun estado/rol/auth
      riesgo: hydration error (SSR vs client mismatch)
- [ ] INSERT o UPDATE a DB
      riesgo: duplicados, verificar si existe unique constraint
- [ ] Query con mas de un JOIN
      riesgo: row explosion, validar COUNT antes de renderizar
- [ ] Llamada a API externa
      riesgo: timeout, error 429, cambio de schema, hay fallback?
- [ ] Mas de un evento asincrono simultaneo posible
      riesgo: race condition, hay loading state que bloquee doble accion?
- [ ] Variable de entorno requerida
      riesgo: funciona en dev, rompe en prod, se valida al arrancar?
- [ ] Modificacion de estado compartido entre componentes
      riesgo: efecto secundario no esperado en otro modulo

Si no hay ningun riesgo marcado: igual se escribe el smoke E2E y se documenta
por que no hay otros tests. No hay riesgos es una decision consciente, no un olvido.

### Paso 2: Tests escritos para fallar, no para confirmar

La pregunta generadora:
- ANTES (prohibido): que hace este codigo? -> test que confirma que lo hace
- AHORA: bajo que condicion este codigo falla? -> test que fuerza esa condicion

Ejemplo:

// MAL: test de confianza
it('renderiza el dashboard', () => {
  render(<Dashboard />)
  expect(screen.getByText('Inicio')).toBeInTheDocument()
})

// BIEN: test que intenta romper
it('no explota en hidratacion cuando userRol llega undefined', () => {
  render(<DashboardShell userRol={undefined} />)
  expect(screen.getByRole('main')).toBeInTheDocument()
})

### Paso 3: Minimo exigible

- 1 test por cada riesgo marcado en el analisis
- 1 smoke E2E del flujo principal (sin excepcion)
- Entregados en DIFF antes de cualquier implementacion
- Comandos exactos para ejecutar, no afirmar "esta rojo" sin evidencia

---

## Fase C: Implementacion Minima

1. Confirmar files-to-touch
2. Estimar lineas antes de escribir: si excede 200 proponer sub-slices
3. Implementar solo lo necesario para pasar los tests
4. Entregar en DIFF unificado por archivo

---

## Fase D: Verificacion + Feature Flag

1. Dar comandos exactos de lint/typecheck/tests
2. Esperar outputs de Pablo
3. Confirmar verde con evidencia
4. Agregar entry en config/feature-flags.json con flag en false
5. Entregar en DIFF

---

## Cierre

1. Resumen:
   - Que se agrego
   - Contrato implementado
   - Tests que cubren (incluyendo riesgos cubiertos)
   - Nombre del flag
2. Preguntar: "Hacemos commit o ajustamos algo?"

---

## Guardrails

- DIFF unificado por archivo, siempre
- Maximo 200 lineas totales por ciclo
- Sin modificar archivos fuera del scope sin permiso
- Sin commits sin aprobacion explicita
- Sin inventar rutas o comandos
- Toda feature nueva bajo feature flag en false
'@

# ============================================================
# 3. skill pbt-ia-debugging.md
# ============================================================
$skillDebugging = @'
---
name: pbt-ia-debugging
description: Protocolo de resolucion de bugs. Activar cuando Pablo diga "hay un bug", "se rompio", "dejo de funcionar", "sigue pasando", o cualquier variante de reporte de error.
---

# Skill: PBT-IA Debugging

## Principio central

Un bug no se toca hasta tener evidencia de su causa raiz.
No existe "intentemos esto a ver si funciona".
Cada intento de fix es un experimento con hipotesis previa y criterio de exito definido.

---

## Los 4 antipatrones prohibidos

1. Sintoma -> fix inmediato sin ver el codigo real
2. Fix encima de fix sin revertir el intento fallido
3. Declarar "resuelto" sin criterio verificable
4. Tocar archivos fuera del scope mientras se arregla el bug

---

## Fase 0: FREEZE (BLOQUEANTE)

Antes de cualquier otra cosa:

  git stash
  git log --oneline -5

Sin punto de retorno garantizado, no se avanza.

---

## Fase 0.5: CLASIFICACION DEL BUG

Identificar el tipo antes de pedir evidencia:

  A) Visual / renderizado  -> evidencia: error en consola del browser
  B) Datos incorrectos DB  -> evidencia: query de diagnostico directa en DB
  C) Integracion externa   -> evidencia: status code + response body HTTP
  D) Intermitente / timing -> evidencia: secuencia exacta que lo dispara
  E) Solo en produccion    -> evidencia: diff de env vars entre entornos
  F) Performance           -> evidencia: tiempo de respuesta medido
  G) Regresion             -> evidencia: git log para encontrar commit culpable

Regla tipo D: si no es reproducible al 100%, no se escribe codigo.
Primero agregar logging para capturar evidencia cuando ocurra naturalmente.

---

## Fase 1: REPRODUCCION

Entregable obligatorio antes de cualquier hipotesis:

  Tipo de bug: [letra]
  Precondicion: [estado inicial exacto]
  Pasos:
    1. [accion exacta]
    2. [accion exacta]
  Resultado actual: [texto exacto del error]
  Resultado esperado: [comportamiento correcto]
  Reproducible 100%: [si / no / bajo que condicion]

---

## Fase 2: EVIDENCIA

Base obligatoria para todos los tipos:
- Error textual completo (no descripcion, el texto exacto)
- Archivo exacto donde ocurre (path real, no "en el dashboard")
- Ultimo commit donde el bug NO existia

Evidencia extendida tipo B (datos DB):
  SELECT codigo, COUNT(*) FROM tabla GROUP BY codigo HAVING COUNT(*) > 1;
  \d public.tabla

Evidencia extendida tipo G (regresion):
  git bisect start
  git bisect bad HEAD
  git bisect good [hash-limpio]

---

## Fase 3: HIPOTESIS (Pablo aprueba antes de codear)

  Hipotesis: el bug ocurre porque [causa especifica]
  Evidencia que la sostiene: [linea / query / log]
  Archivos afectados: [lista exacta]
  Archivos que NO se tocan: [lista explicita]
  Como confirmo que el fix funciono: [criterio verificable]
  Como confirmo que no rompi nada mas: [comando exacto]

Una hipotesis a la vez.

---

## Fase 4: FIX MINIMO

- Maximo 50 lineas modificadas
- Cero cambios fuera de los archivos declarados en Fase 3
- DIFF unificado por archivo
- Si el fix requiere cambio en DB Y en codigo: dos commits separados, DB primero

---

## Fase 5: VERIFICACION CON EVIDENCIA

No se declara "resuelto" sin evidencia. Checklist:

  [ ] El guion de reproduccion ya no produce el error
  [ ] npm run build pasa sin errores
  [ ] El comportamiento esperado se cumple
  [ ] Ningun otro flujo conocido se rompio (smoke test)

Si alguno falla: revert inmediato al commit de Fase 0, volver a Fase 2.

---

## Fase 6: COMMIT + REGISTRO

Formato de commit:
  fix: [descripcion] causa raiz: [X]

Entrada obligatoria en BUGS.md del proyecto:
  ## [fecha] - [sintoma]
  - Tipo: [letra]
  - Causa raiz: [descripcion tecnica]
  - Fix aplicado: [que se cambio y donde]
  - Zona fragil: [que no tocar sin revisar esto]
  - Commit: [hash]

---

## Regla de los 2 intentos fallidos

Si dos hipotesis consecutivas fallan: PARAR.
El modelo mental del sistema es incorrecto.
Siguiente paso: diagnostico mas profundo antes del tercer intento.
Considerar correr ponytail audit si el codigo alrededor es complejo.
'@

# ============================================================
# 4. skill pbt-ia-puntos-revision.md
# ============================================================
$skillRevision = @'
---
name: pbt-ia-puntos-revision
description: Puntos de revision obligatorios basados en senales durante el desarrollo. Activar cuando Pablo diga "punto de revision", "audit", o cuando se detecte alguna de las 3 senales descritas.
---

# Skill: Puntos de Revision PBT-IA

## Principio

No son calendarizados. Se activan por senales especificas.
Cuando se activa cualquiera, el desarrollo se pausa antes del siguiente slice.

---

## Senal 1: Slice que toca una zona fragil conocida

Condicion: el slice siguiente modifica un archivo o modulo que tiene
entrada en BUGS.md o en la tabla "Zonas de riesgo conocidas" del PRD.md.

Accion antes de Fase A del slice:
  1. Leer la entrada de BUGS.md de esa zona
  2. Confirmar que el fix anterior sigue intacto
  3. Agregar al contrato del slice: "este slice no modifica [X]"
     o si si lo modifica: "este slice toca zona fragil, revisar [entrada BUGS.md]"

---

## Senal 2: Mas de 5 slices sin audit

Condicion: el contador de slices desde el ultimo ponytail audit supera 5.

Accion antes del slice N+6:
  1. Correr: ponytail audit
  2. Revisar output, identificar archivos con complejidad acumulada
  3. Decidir: hacemos un slice de limpieza antes de continuar?
     - Si hay items criticos: si, slice de limpieza primero
     - Si todo esta verde: documentar en CONTEXT-CLAUDE-CHAT.md y continuar

El slice de limpieza no agrega funcionalidad. Solo reduce complejidad.
Commit separado con mensaje: refactor: limpieza post-audit slice N

Llevar contador en CONTEXT-CLAUDE-CHAT.md:
  ## Contador Ponytail
  Ultimo audit: slice [N] - [fecha]
  Slices desde ultimo audit: [X]

---

## Senal 3: Antes del primer deploy a produccion

Condicion: cualquier slice marcado como listo para produccion,
o cuando Pablo diga "vamos a deployar".

Accion obligatoria antes del deploy:
  1. ponytail audit: debe estar verde o con plan para items criticos
  2. Smoke E2E completo de todos los flujos principales
  3. Revisar tabla "Zonas de riesgo conocidas" del PRD.md:
     confirmar que cada zona fragil tiene test que la cubre
  4. Verificar variables de entorno prod vs dev
  5. npm run build en modo produccion: cero errores, cero warnings

Si alguno falla: no se deploya. Abrir protocolo pbt-ia-debugging.

---

## Flujo de decision antes de cada slice

  Slice siguiente
       |
       v
  Toca zona fragil de BUGS.md?  --si--> Revision Senal 1 -> continuar
       |no
       v
  Mas de 5 slices sin audit?    --si--> Revision Senal 2 -> continuar
       |no
       v
  Es deploy a produccion?       --si--> Revision Senal 3 -> deployar
       |no
       v
  Ejecutar slice normal
'@

# ============================================================
# 5. instalar-semilla.ps1 actualizado
# ============================================================
$installerScript = @'
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
'@

# ============================================================
# Escribir todos los archivos
# ============================================================
Set-Content -Path "$repo\CLAUDE.md"                                  -Value $claudeMd        -Encoding UTF8
Set-Content -Path "$skills\pbt-ia-cycle.md"                          -Value $skillCiclo      -Encoding UTF8
Set-Content -Path "$skills\pbt-ia-debugging.md"                      -Value $skillDebugging  -Encoding UTF8
Set-Content -Path "$skills\pbt-ia-puntos-revision.md"                -Value $skillRevision   -Encoding UTF8
Set-Content -Path "$repo\instalar-semilla.ps1"                       -Value $installerScript -Encoding UTF8

Write-Host ""
Write-Host "Archivos actualizados:" -ForegroundColor Cyan
Write-Host "  OK: CLAUDE.md"
Write-Host "  OK: skills\pbt-ia-cycle.md"
Write-Host "  OK: skills\pbt-ia-debugging.md"
Write-Host "  OK: skills\pbt-ia-puntos-revision.md"
Write-Host "  OK: instalar-semilla.ps1"
Write-Host ""

# ============================================================
# Git commit y push
# ============================================================
Set-Location $repo

git add .
git commit -m "feat: protocolo debugging, Fase B reformulada, puntos de revision"
git push

Write-Host ""
Write-Host "Repo actualizado y publicado." -ForegroundColor Green
