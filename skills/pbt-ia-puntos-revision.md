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
