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
