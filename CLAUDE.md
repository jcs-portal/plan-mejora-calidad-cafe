# Plan de Mejora de Calidad de Café

## Contexto
Programa Ubuntu Café (Codespa, San Adolfo, Huila). Ya existen dos apps que comparten el mismo backend Railway (`finanzas-cafeteros`, autenticación por código X-Code, roles `joven`/`formador`): `diagnostico-finca-cafe` (recoge datos de proceso y genera recomendaciones priorizadas contra referencias Cenicafé/FNC/SCA) y `finanzas-cafeteros` (situación económica de la finca).

Este proyecto añade la pieza que falta: convertir las recomendaciones del diagnóstico en un **plan de acción** que el caficultor controla (responsable, plazo, coste, avance), que el formador puede ver (solo lectura) y comentar a través de un canal de **mensajes** visual, más una vista de **impresión en una página apaisada**.

Detalle completo de discovery, producto, restricciones, arquitectura, equipo, pipeline y estándares en `/specs/`.

## Stack Tecnológico
- **Frontend** (este repo): un único `index.html`, React 18 vía CDN, sin build step. Mismo patrón que `diagnostico-finca-cafe`.
- **Backend**: se EXTIENDE el backend Express ya existente en `finanzas-cafeteros/app.js` (repo separado, ruta relativa `../doc comite finanzas/finanzas-cafeteros/`), añadiendo rutas nuevas (`/api/plan-accion*`, `/api/mensajes*`) sin tocar nada existente. No se crea base de datos ni backend nuevo.
- **Hosting**: GitHub Pages (frontend, nuevo repo) + Railway (backend, ya desplegado).

Detalle y ADRs en `specs/04_arquitectura.md`.

## Ownership de Archivos
| Carpeta | Propietario | Notas |
|---------|-------------|-------|
| `index.html` | Frontend | Único archivo de la app |
| `CLAUDE.md`, `.claude/`, `specs/`, `prompts/` | Arquitecto | Scaffolding y documentación |
| `../doc comite finanzas/finanzas-cafeteros/app.js` (solo rutas nuevas) | Arquitecto | **Repo externo, en producción** — solo añadir, nunca modificar lo existente |

## Convenciones Clave
- camelCase en español para variables/funciones de dominio (`pctRojos`, `cargarPlanAccion`).
- Sin ESLint/Prettier/TypeScript — mismo estilo "sin tooling" que las apps hermanas.
- Detalle completo en `specs/07_estandares.md`.

## Verificación Obligatoria
Antes de completar cualquier tarea:
- Si tocaste `app.js`: `node app.js` localmente y probar rutas viejas + nuevas (no debe romper nada existente).
- Si tocaste `index.html`: abrir en navegador (servido localmente) y recorrer a mano los flujos de `specs/02_producto.md`.
- Revisión en modo responsive/móvil antes del checkpoint humano.

## Archivos Compartidos — COORDINAR ANTES DE EDITAR
- `../doc comite finanzas/finanzas-cafeteros/app.js`: backend real en producción usado hoy por caficultores. Solo el Arquitecto lo edita, solo para añadir las rutas nuevas. **Nunca se despliega (`git push`) sin aprobación explícita del usuario.**

## Specs
Documentación completa en `/specs/` (fases 1-7). Pipeline y spawn prompts exactos en `specs/05_equipo.md` y `specs/06_pipeline.md`.
