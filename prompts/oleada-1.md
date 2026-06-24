# Prompt — Oleada 1: Construcción

Copia y pega esto en la sesión lead de Claude Code (con delegate mode activo, Shift+Tab),
abierta en `plan-mejora-calidad-cafe/` **con acceso también a la carpeta hermana**
`../doc comite finanzas/finanzas-cafeteros/` (ambas deben estar accesibles en la misma sesión).

```
Crea un equipo para la Oleada 1: Construcción del proyecto Plan de Mejora de Calidad de Café.
Activa delegate mode (Shift+Tab) — tú coordinas, no implementas.

Lanza los siguientes teammates en paralelo:

1. Arquitecto: "Eres el teammate Arquitecto del proyecto Plan de Mejora de Calidad de Café.
   Tu scope exclusivo: plan-mejora-calidad-cafe/ (CLAUDE.md, .claude/, specs/, prompts/,
   configuraciones raíz) y SOLO las rutas nuevas en
   '../doc comite finanzas/finanzas-cafeteros/app.js' (/api/plan-accion*, /api/mensajes*,
   helpers y carpetas data/plan-accion/, data/mensajes/). NO modifiques nada existente
   de ese archivo. El contrato de datos está en specs/02_producto.md y
   specs/04_arquitectura.md (ADR-001 a ADR-005). Replica el patrón exacto de
   /api/diagnostico y /api/admin/diagnostico (auth por X-Code, roles joven/formador).
   Prueba con `node app.js` local que las rutas viejas y nuevas responden bien.
   No hagas git push ni despliegues — eso lo decide el usuario."

2. Frontend: "Eres el teammate Frontend del proyecto Plan de Mejora de Calidad de Café.
   Tu scope exclusivo: plan-mejora-calidad-cafe/index.html. Replica el patrón de
   diagnostico-finca-cafe/index.html (React 18 vía CDN, un solo archivo, login con
   código en localStorage, fetch con header X-Code). Implementa los flujos de
   specs/02_producto.md (F1-F8): diagnóstico + plan de acción editable, vista de
   formador de solo lectura, mensajes visuales del formador (tarjetas grandes para
   móvil), e impresión en una página apaisada (@page { size: landscape }). Coordínate
   con el Arquitecto si necesitas un campo de API que no esté documentado."

Coordina que el Arquitecto NUNCA toque código existente de finanzas-cafeteros/app.js,
solo añada. Cuando ambos terminen, presenta resumen de lo creado y el diff exacto de
app.js para que el usuario lo revise antes de cualquier despliegue.
```

## Después de esta oleada
1. Checkpoint humano: revisar el diff de `app.js` y probar `index.html` en local.
2. Si todo está bien: desplegar backend (`git push` en `finanzas-cafeteros`) y publicar
   el frontend en GitHub Pages.
3. Checkpoint humano final: probar el flujo completo en producción con un código de prueba.

Detalle completo en `specs/06_pipeline.md`.
