# Sistema PBT-IA — Desarrollo de Software con IA

Construye software de forma controlada usando Claude como tu equipo de desarrollo.
Sin saber programar. Sin perder el control. Sin sorpresas.

---

## Qué es esto

PBT-IA es un sistema de trabajo para construir software usando Inteligencia Artificial.
La idea es simple: tú decides qué se construye, la IA lo construye, y tú validas
cada paso antes de continuar.

No es "vibe coding" donde le pides algo y rezas para que funcione.
Es desarrollo controlado en ciclos pequeños donde nada avanza sin tu aprobación.

---

## Cómo funciona en una frase

Claude chat planifica. Claude Code construye. Tú apruebas cada paso.

---

## Lo que necesitas instalar (una sola vez)

1. **Node.js** — https://nodejs.org (versión 18 o superior)
2. **Claude Code** — abre PowerShell y ejecuta:
   ```powershell
   npm install -g @anthropic/claude-code
   ```
3. **Git** — https://git-scm.com
4. **Cuenta en Claude** — https://claude.ai (plan Pro recomendado)

---

## Instalación de la semilla (una sola vez por máquina)

La semilla es el archivo que le enseña a Claude Code cómo trabajar contigo.
Sin ella, Claude Code es un programador genérico. Con ella, sabe exactamente
qué hacer, cómo hacerlo y cuándo detenerse a esperarte.

**Paso 1** — Descarga `instalar-semilla.ps1` de este repositorio.

**Paso 2** — Abre PowerShell en la carpeta donde lo descargaste y ejecuta:

```powershell
powershell -ExecutionPolicy Bypass -File .\instalar-semilla.ps1
```

**Paso 3** — Verifica que quedó instalado:

```powershell
Get-ChildItem "$HOME\.claude\"
```

Debes ver `CLAUDE.md` y la carpeta `skills\` en el listado. Listo.

---

## Configuración de Claude chat (una sola vez)

Claude chat es donde planificas proyectos nuevos. Para que sepa cómo trabajar
contigo, necesitas configurarlo una vez:

1. Abre https://claude.ai
2. Ve a **Settings → Profile → Instrucciones personalizadas**
3. Pega el contenido del archivo `instrucciones-claude-chat.md` de este repositorio
4. Guarda

A partir de ese momento, cada conversación nueva en Claude chat ya sabe
que eres el Product Owner, cómo es la metodología PBT-IA, y qué generar
cuando inicias un proyecto nuevo.

---

## Cómo iniciar un proyecto nuevo

### Paso 1 — Sesión 0 en Claude chat

Abre una conversación nueva en https://claude.ai y escribe:

```
Sesión 0
```

Claude chat te pedirá que completes 7 campos sobre tu proyecto:

- Qué hace el software
- Quiénes lo usan
- Qué debe tener el MVP (mínimo viable)
- Qué NO es parte del MVP
- Integraciones externas necesarias
- Restricciones técnicas
- Escala esperada

Claude chat te propondrá un stack tecnológico. Cuando lo apruebes, generará
automáticamente 4 archivos:

- **PRD.md** — descripción del proyecto y backlog priorizado
- **CLAUDE.md** — configuración del proyecto para Claude Code
- **CONTEXT-CLAUDE-CHAT.md** — contexto para futuras conversaciones de arquitectura
- **crear-proyecto-[nombre].ps1** — script que crea todo en tu máquina

### Paso 2 — Crear la carpeta del proyecto

Descarga los 4 archivos en la misma carpeta y ejecuta:

```powershell
powershell -ExecutionPolicy Bypass -File .\crear-proyecto-[nombre].ps1
```

El script crea la carpeta del proyecto con toda la estructura adentro
e inicializa git automáticamente.

### Paso 3 — Abrir Claude Code

```powershell
cd [nombre-del-proyecto]
claude .
```

Claude Code lee automáticamente la semilla global y el CLAUDE.md del proyecto.
Ya sabe todo lo que necesita. No le explicas nada.

### Paso 4 — Construir

Escríbele a Claude Code:

```
siguiente slice
```

Claude Code ejecuta un ciclo completo de desarrollo:

1. **Contrato** — te dice exactamente qué va a construir. Espera tu aprobación.
2. **Tests rojos** — crea las pruebas primero. Te da los comandos para ejecutarlas.
3. **Implementación** — construye solo lo necesario para pasar las pruebas.
4. **Verde** — verifica que todo funciona. Te da los comandos para confirmarlo.
5. **Feature flag** — la nueva funcionalidad queda desactivada hasta que tú la actives.
6. **Cierre** — te pregunta si hacer commit o ajustar algo.

Tú escribes "go" para continuar, o corriges si algo no está bien.

### Paso 5 — Repetir

```
siguiente slice
```

Repite hasta que el MVP esté completo.

---

## Retomar un proyecto después de cerrar Claude Code

Claude Code no recuerda conversaciones anteriores, pero sí lee los archivos
del proyecto cada vez que lo abres. Solo entra a la carpeta y ejecuta:

```powershell
cd [nombre-del-proyecto]
claude .
```

Todo el contexto está en los archivos. Continúa donde lo dejaste.

---

## Retomar con Claude chat para decisiones de arquitectura

Si necesitas hablar con Claude chat sobre un proyecto específico — cambiar
la arquitectura, resolver un problema complejo, tomar una decisión técnica —
abre una conversación nueva y pega el contenido de `CONTEXT-CLAUDE-CHAT.md`
del proyecto al inicio.

Claude chat retoma como Director Técnico sin que tengas que explicar nada.

Actualiza el campo "Último slice completado" en ese archivo a medida que avanzas.

---

## Trabajar en proyectos existentes

Si tienes un proyecto ya desarrollado y quieres hacerle fixes, updates o
agregar features, no necesitas Sesión 0. Solo abre Claude Code en la carpeta:

```powershell
cd [tu-proyecto]
claude .
```

Y dile lo que necesitas:

```
Tengo este bug: [descripción]. Analiza el código y propón el fix.
```

```
Quiero agregar [feature]. Analiza el código existente y propón el slice.
```

Claude Code aplica la metodología PBT-IA igual — contrato, tests, implementación,
validación — porque la semilla está instalada globalmente.

---

## Reglas del sistema

- **Máximo 200 líneas por ciclo** — si algo es más grande, Claude Code lo divide solo.
- **Sin commits automáticos** — nada se guarda en git sin tu aprobación explícita.
- **Sin tocar archivos fuera del plan** — Claude Code pide permiso antes de modificar
  algo que no estaba en el contrato.
- **Toda feature nueva nace desactivada** — en `config/feature-flags.json` con valor
  `false`. Tú la activas cuando la validas.

---

## Archivos de este repositorio

| Archivo | Para qué sirve |
|---|---|
| `instalar-semilla.ps1` | Instalar la semilla en una máquina nueva — ejecutar una sola vez |
| `instrucciones-claude-chat.md` | Pegar en Settings → Profile de claude.ai — configurar una sola vez |

---

## Preguntas frecuentes

**¿Necesito saber programar?**
No. Tú describes qué quieres construir y validas los resultados. Claude Code programa.
Lo que sí ayuda es entender a grandes rasgos qué hace tu software.

**¿Qué pasa si Claude Code comete un error?**
Cada ciclo es pequeño — máximo 200 líneas. Si algo falla, el daño está contenido
y revertir es trivial con git. Por eso los ciclos son pequeños.

**¿Funciona en Mac o Linux?**
La semilla sí. El script PowerShell de creación de proyectos requiere PowerShell,
que está disponible en Mac y Linux. Instálalo desde:
https://learn.microsoft.com/powershell/scripting/install/installing-powershell

**¿Puedo usar modelos de IA distintos a Claude?**
El sistema está diseñado específicamente para Claude Code con Claude como modelo.
Cambiarlo requeriría adaptar la semilla.

**¿Qué es una feature flag?**
Un interruptor en `config/feature-flags.json`. Cuando Claude Code construye
algo nuevo lo deja en `false` (apagado). Tú lo cambias a `true` cuando lo
revisaste y aprobaste. Así el código nuevo nunca llega a producción sin que
tú lo hayas visto.

**¿Y si quiero cambiar de máquina?**
Descarga `instalar-semilla.ps1` del repositorio, ejecútalo en la máquina nueva,
y configura las instrucciones personalizadas en Claude chat. Listo.
