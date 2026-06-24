# Estándares: Plan de Mejora de Calidad de Café

## Convenciones de Código

Se siguen las mismas convenciones que `diagnostico-finca-cafe` y `finanzas-cafeteros`, para que cualquiera que ya conozca esas apps pueda leer esta sin aprender un estilo nuevo:

| Elemento | Convención | Ejemplo |
|----------|------------|---------|
| Variables y campos de dominio | camelCase, en español | `pctRojos`, `costoEstimado`, `formadorCodigo` |
| Funciones | camelCase, en español cuando son de dominio | `cargarPlanAccion()`, `generarRecomendaciones()` |
| Componentes React | PascalCase | `PlanAccion`, `TarjetaMensaje` |
| Archivos | el código de la app vive en un único `index.html` (sin build); helpers de servidor en `app.js` | — |
| Rutas API | kebab-case en inglés/español mixto, igual que las existentes | `/api/plan-accion`, `/api/admin/mensaje` |

### Formato de Commits
```
tipo(alcance): descripción breve

Tipos: feat, fix, docs, style, refactor, chore
```

## Estructura con Ownership

```
plan-mejora-calidad-cafe/
├── CLAUDE.md                  ← Arquitecto
├── .claude/                   ← Arquitecto
├── specs/                     ← Arquitecto (copia de las fases 1-7)
├── prompts/                   ← Arquitecto
├── index.html                 ← Frontend
└── README.md                  ← Arquitecto

finanzas-cafeteros/             (repo existente, NO scaffolding nuevo)
└── app.js                      ← Arquitecto, SOLO las rutas /api/plan-accion* y /api/mensajes*
```

## Reglas por Teammate

**Arquitecto**: documenta cada ruta nueva con un comentario igual de breve que las existentes (`// ── API: Plan de Acción`). No reescribe ni reordena código existente de `app.js`, solo añade. No despliega.

**Frontend**: un solo archivo, sin dependencias de build. Componentes pequeños dentro del mismo archivo (funciones, no clases). No hardcodea la URL del backend más de una vez (una sola constante `API_BASE`, igual que en `diagnostico-finca-cafe`).

## Comandos de Verificación

| Teammate | Comando / Acción | Cuándo |
|----------|----------------------|--------|
| Arquitecto | `node app.js` (local) y probar con `curl`/`fetch` al menos una ruta vieja y todas las nuevas | Antes de marcar la tarea como completa |
| Frontend | Abrir `index.html` (servido localmente, ej. `npx serve .`) y recorrer a mano los 3 flujos de `specs/02_producto.md` | Antes de marcar la tarea como completa |
| Ambos | Revisión visual en una pantalla de móvil (DevTools en modo responsive como mínimo) | Antes del checkpoint humano |

## Definición de Hecho (antes de decir "listo" o "desplegado")

Este proyecto no tiene compilador, tipos ni tests automáticos — esa red de seguridad
que detecta errores sola en otros proyectos, aquí no existe. Por eso, antes de afirmar
que algo está listo, hay que verificar explícitamente cada punto (y decir cuál no se
pudo verificar, en vez de omitirlo):

1. **Camino feliz probado de verdad**, no solo sintaxis: ejecutar el flujo en un
   entorno donde el JS realmente corre (navegador real o headless), no solo balance de
   llaves o lectura del código.
2. **Camino infeliz probado a propósito**: ¿qué pasa si una ruta del backend no existe
   todavía? ¿si la red falla? ¿si el dato viene vacío o null? Esto fue exactamente lo
   que falló la primera vez (un `.catch(() => {})` silencioso dejó `diagnostico` en
   `null` y el render explotó).
3. **Ningún `.catch` vacío**: todo fallo de `fetch`/`apiGet`/`apiPut`/`apiPost` debe
   terminar en algo visible para el usuario (mensaje + botón "Reintentar"), nunca en
   una pantalla que se queda a medias en silencio.
4. **Ningún acceso a propiedades de un estado que puede ser `null`** sin guard previo
   (`if (!x) return <Cargando/>` o `if (error) return <Error/>` antes de usar `x.campo`).
5. Si algo de los puntos 1-4 no se pudo verificar (ej. no había navegador disponible),
   decirlo explícitamente como "no verificado visualmente" — nunca afirmar "listo" o
   "Oleada completa" dando por hecho que pasó algo que no se comprobó.

## Configuraciones
No se introducen ESLint/Prettier/TypeScript nuevos — el proyecto sigue deliberadamente el mismo estilo "sin tooling" que sus dos apps hermanas (ver ADR-001 a ADR-005 en `04_arquitectura.md`). Si el proyecto crece más allá del MVP, revisar si esto sigue siendo razonable.
