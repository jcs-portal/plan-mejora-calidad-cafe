# Plan de Mejora de Calidad de Café

Proyecto generado siguiendo la metodología de `proyecto-agent-teams`. Convierte las
recomendaciones de `diagnostico-finca-cafe` en un plan de acción con seguimiento, y
añade un canal de mensajes visual del formador hacia el caficultor.

## Antes de empezar
Este proyecto edita dos carpetas distintas:
- `plan-mejora-calidad-cafe/` (este repo — frontend nuevo).
- `../doc comite finanzas/finanzas-cafeteros/` (repo existente, en producción — solo
  se le añaden rutas nuevas, nunca se modifica lo existente).

Abre Claude Code en una sesión que tenga acceso a ambas carpetas (en VS Code / Claude
Code esto se logra añadiendo ambas como "additional working directories" o abriendo el
workspace que las contiene a ambas).

## Activar Agent Teams
1. Verifica que `.claude/settings.local.json` (ya incluido) tiene
   `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS: "1"`.
2. Da permisos a los hooks (ya hecho, pero por si los copias a otro entorno):
   ```bash
   chmod +x .claude/hooks/*.sh
   ```
3. Arranca Claude Code en `plan-mejora-calidad-cafe/` y activa delegate mode (Shift+Tab).
4. Copia el prompt de `prompts/oleada-1.md` y lánzalo.

## Después de la oleada
1. Revisa el diff de `finanzas-cafeteros/app.js` (debe ser solo adiciones).
2. Prueba `index.html` en local contra el backend local (`node app.js`).
3. Si todo está bien, despliega el backend (push a Railway) y publica el frontend en
   GitHub Pages (mismo patrón que `https://jcs-portal.github.io/diagnostico-finca-cafe/`).
4. Prueba el flujo completo en producción antes de avisar a los caficultores.

## Documentación
Todo el detalle de planificación (problema, MVP, restricciones, arquitectura con ADRs,
equipo, pipeline y estándares) está en `/specs/`.
