# Equipo de Teammates: Plan de Mejora de Calidad de Café

## Teammates Seleccionados

| Teammate | Incluido | Scope Exclusivo | Justificación |
|----------|----------|-------------------|----------------|
| Arquitecto | Sí | `plan-mejora-calidad-cafe/CLAUDE.md`, `.claude/`, `specs/`, `prompts/`, configuraciones raíz; **y** las rutas nuevas (`/api/plan-accion*`, `/api/mensajes*`) en `finanzas-cafeteros/app.js` + carpetas `data/plan-accion/`, `data/mensajes/` | Es el único cambio de backend, pequeño y acotado; tiene sentido que lo haga quien ya define la arquitectura y conoce el patrón existente (`/api/diagnostico`). |
| Frontend | Sí | `plan-mejora-calidad-cafe/index.html` (toda la app: login, diagnóstico, plan, mensajes, impresión) | Es el único entregable visible al usuario final; un solo archivo, un solo propietario. |
| Testing | No (para este MVP) | — | Proyecto de 1 archivo de frontend + 4 rutas de backend, 2-3 semanas, un solo desarrollador supervisando. Una suite de tests automatizada sería desproporcionada; se sustituye por un checklist manual de verificación (ver `07_estandares.md`) que ejecuta el propio Frontend/Arquitecto antes del checkpoint humano. |
| DevOps | No | — | Despliegue manual a GitHub Pages (frontend) y Railway (backend, ya configurado); no hay pipeline que automatizar a esta escala. |
| Documentación | No (la hace el Arquitecto) | — | Un solo README es parte natural del scaffolding inicial, no justifica un teammate dedicado. |

**Regla crítica aplicada**: el único archivo con riesgo de solapamiento es `finanzas-cafeteros/app.js` (backend en producción). Por eso tiene un solo propietario (Arquitecto) y un checkpoint humano explícito antes de desplegar (ver `06_pipeline.md`).

## Archivos Compartidos

| Archivo/Carpeta | Teammates | Regla de coordinación |
|-------------------|-----------|---------------------------|
| `finanzas-cafeteros/app.js` | Arquitecto (único editor) | Nadie más lo toca. Antes de desplegar a Railway, el usuario revisa el diff explícitamente. |
| Contrato de API (`/api/plan-accion`, `/api/mensajes`) | Arquitecto define, Frontend consume | Ya documentado en `02_producto.md`/`04_arquitectura.md`; si Frontend necesita un campo nuevo, lo pide al Arquitecto en vez de inventar la forma del JSON. |

## Spawn Prompts por Teammate

### Teammate: Arquitecto
```
Eres el teammate Arquitecto del proyecto "Plan de Mejora de Calidad de Café".
Tu scope exclusivo:
- plan-mejora-calidad-cafe/ (CLAUDE.md, .claude/, specs/, prompts/, configuraciones raíz)
- finanzas-cafeteros/app.js — SOLO puedes añadir código nuevo (rutas /api/plan-accion* y
  /api/mensajes*, helpers asociados, carpetas data/plan-accion/ y data/mensajes/).
  NO modifiques ninguna ruta, función o lógica existente de ese archivo.

Contexto: finanzas-cafeteros ya tiene un patrón idéntico para /api/diagnostico y
/api/admin/diagnostico (auth por código X-Code, roles joven/formador, almacenamiento en
JSON bajo data/). Replica exactamente ese patrón para plan-accion y mensajes. El contrato
de datos está en specs/02_producto.md y specs/04_arquitectura.md (ADR-001, ADR-005).

Tarea concreta:
1. Crear plan-mejora-calidad-cafe/CLAUDE.md, .claude/settings.local.json + hooks,
   prompts/oleada-1.md, copiando specs/ existentes.
2. Añadir a finanzas-cafeteros/app.js (sin tocar nada más):
   - GET/PUT /api/plan-accion (rol joven, su propio código)
   - GET /api/admin/plan-accion (rol formador, su comunidad — solo lectura)
   - GET /api/mensajes (rol joven, mensajes dirigidos a su código o a "todos" de su comunidad)
   - POST /api/admin/mensaje y DELETE /api/admin/mensaje/:id (rol formador)
3. Probar localmente (node app.js) que las rutas existentes siguen funcionando igual
   y que las nuevas responden correctamente con un código de prueba.

Archivos compartidos — coordina antes de editar: finanzas-cafeteros/app.js (ver regla arriba).

Antes de completar, ejecuta: arrancar `node app.js` localmente y probar con curl/fetch
las rutas nuevas y al menos una ruta existente (ej. GET /api/whoami) para confirmar que
no se rompió nada.

Criterios de aceptación:
- Rutas existentes de finanzas-cafeteros responden igual que antes del cambio.
- Las 6 rutas nuevas existen, respetan los roles joven/formador y siguen el formato
  JSON acordado.
- NO se ha hecho `git push` ni desplegado a Railway — eso requiere aprobación humana explícita.
```

### Teammate: Frontend
```
Eres el teammate Frontend del proyecto "Plan de Mejora de Calidad de Café".
Tu scope exclusivo: plan-mejora-calidad-cafe/index.html (puedes crear archivos de apoyo
dentro de plan-mejora-calidad-cafe/ si lo necesitas, ej. manifest.json, pero el código
de la app vive en index.html).

Contexto: Replica el patrón de diagnostico-finca-cafe/index.html (React 18 vía CDN, un
solo archivo, login con código guardado en localStorage, fetch directo al backend con
header X-Code). El backend ya expone (o expondrá, coordínate con el Arquitecto si una
ruta no existe todavía): GET/PUT /api/diagnostico, GET/PUT /api/plan-accion,
GET /api/admin/plan-accion, GET /api/mensajes, POST /api/admin/mensaje.
Las funcionalidades exactas están en specs/02_producto.md (F1-F8).

Tarea concreta:
1. Pantalla de login (mismo código que diagnostico-finca-cafe/finanzas-cafeteros).
2. Pantalla principal del caficultor: diagnóstico resumido + plan de acción editable
   (responsable, plazo, coste, estado) + sección de mensajes del formador (tarjetas
   visuales grandes, con icono según tipo, pensadas para móvil).
3. Vista de formador (solo lectura del plan de cada caficultor + formulario simple para
   enviar un mensaje).
4. Vista de impresión: una sola página en horizontal (CSS `@page { size: landscape; }`,
   `@media print`) con el resumen del plan, accionada con un botón "Imprimir".

Archivos compartidos: ninguno (el contrato de API ya está fijado; si necesitas un campo
que no existe, pídelo al Arquitecto en vez de inventarlo).

Antes de completar, ejecuta: abrir index.html en el navegador (servido localmente, ej.
`npx serve` o similar) y probar manualmente el flujo completo de login → ver plan →
marcar una acción → imprimir, contra el backend local del Arquitecto.

Criterios de aceptación:
- Los 3 flujos de specs/02_producto.md (caficultor, formador, mensajería) funcionan
  contra el backend real.
- La vista de impresión cabe en una página apaisada sin cortarse.
- El archivo sigue el mismo estilo sin build-step que diagnostico-finca-cafe.
```

## Puntos de Intervención Humana

| Momento | Qué revisar | Criterio de avance |
|---------|--------------|------------------------|
| Tras Oleada 1 (Arquitecto + Frontend en paralelo) | Diff de finanzas-cafeteros/app.js (solo adiciones, nada existente roto); index.html funcionando contra el backend local | Ambos criterios de aceptación cumplidos antes de tocar producción |
| Antes de desplegar el backend a Railway | Mismo diff, ya probado en local | Aprobación explícita del usuario — **no se despliega sin esto** |
| Antes de publicar el frontend en GitHub Pages | App probada de punta a punta contra el backend ya desplegado | Aprobación explícita del usuario |
