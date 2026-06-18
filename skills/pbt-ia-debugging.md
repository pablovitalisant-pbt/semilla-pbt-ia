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
