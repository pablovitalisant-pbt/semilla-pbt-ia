# CLAUDE.md Global — PBT-IA

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
6. NUNCA ASUMIR NADA — solo trabajar con informacion 100% verificable

## Ciclo PBT-IA

Se activa con: "ciclo", "slice", "PBT-IA", "siguiente slice"

- Fase A: Contrato (BLOQUEANTE — esperar aprobacion antes de continuar)

## Revisión de impacto lateral (OBLIGATORIO antes de cerrar Fase A)

Antes de presentar el contrato final, revisar el árbol completo 
de archivos del proyecto y responder:

¿Qué archivos que YA EXISTEN necesitan cambiar para que lo que 
este slice introduce quede correctamente integrado al resto del sistema?

- Si la respuesta es "ninguno" → declararlo explícitamente con justificación.
- Si hay alguno → entra obligatoriamente en la lista de archivos del slice.
  No se difiere a "después". No se omite silenciosamente.

Esta revisión cubre sin excepción: navegación y UI, rutas e imports, 
tipos TypeScript compartidos, schema de DB y migraciones, middleware 
y permisos, variables de entorno, feature flags, tests existentes, 
y cualquier otro archivo que referencie lo que este slice toca.

- Fase B: Tests que intentan romper el slice (ver FASE-B-REFORMULADA.md)
- Fase C: Implementacion minima
- Fase D: Verificacion + Feature Flag
- Cierre: resumen y pregunta de commit

## Debugging

Protocolo completo: ~/.claude/PBT-IA-DEBUGGING.md
Se activa con: "hay un bug", "se rompio", "dejo de funcionar", "sigue pasando"
Registro de bugs resueltos: BUGS.md en la raiz de cada proyecto

## Puntos de Revision Obligatorios

Ver ~/.claude/PBT-IA-PUNTOS-REVISION.md
Se activan por senales, no por calendario:
1. Slice que toca una zona fragil conocida (BUGS.md del proyecto)
2. Mas de 5 slices sin correr ponytail audit
3. Antes de cualquier deploy a produccion

## Sesion 0

Cuando Pablo describe un proyecto nuevo, generar exactamente 4 artefactos:
PRD.md, CLAUDE.md del proyecto, CONTEXT-CLAUDE-CHAT.md, script PowerShell.
Ver actualizaciones requeridas en ~/.claude/SESION-0-ACTUALIZACIONES-DEBUGGING.md

## Herramientas disponibles

- ponytail: reduccion de complejidad — usar /ponytail audit antes de refactors
- improve: auditoria de codebase — usar /improve antes de deploys grandes
- drawio: diagramas de arquitectura — usar cada 3-4 slices o en Sesion 0
- github: gestion de issues desde Claude Code

## Stack habitual

Next.js 14/15, TypeScript, Drizzle ORM, Neon (PostgreSQL), Vercel, Tailwind CSS
