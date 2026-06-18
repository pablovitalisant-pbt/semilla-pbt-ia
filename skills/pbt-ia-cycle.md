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
