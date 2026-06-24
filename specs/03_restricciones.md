# Restricciones y Recursos: Plan de Mejora de Calidad de Café

## Presupuesto
Proyecto social (Ubuntu Café / Codespa), sin presupuesto de desarrollo comercial. Coste objetivo: ~0 adicional — se reutiliza el mismo hosting (GitHub Pages para el frontend, Railway ya pagado para el backend) que las otras dos apps. Único coste nuevo posible: tokens de Claude Code para construirlo.

## Timeline
Sin fecha límite dura. **Objetivo confirmado por el usuario**: una propuesta inicial usable en 2-3 semanas, "hecha bien desde el inicio" — no es un prototipo descartable. Esto significa: el MVP reduce alcance funcional (ver `02_producto.md`), pero no calidad de base (estructura, convenciones, verificación).

## Supervisión
- Responsable: el propio usuario (Juan Carlos), que ya supervisa y opera `diagnostico-finca-cafe` y `finanzas-cafeteros`.
- Nivel técnico: alto — entiende el código de ambas apps existentes y su despliegue en Railway/GitHub Pages.
- Disponibilidad: la suficiente para checkpoints entre oleadas (proyecto pequeño, una sola persona supervisando).

## Preferencias Tecnológicas
- **Confirmado**: mantener el mismo patrón que las apps existentes — frontend single-file HTML+React (sin build step), backend Express ya desplegado, almacenamiento en archivos JSON (sin base de datos nueva).
- Evitar introducir dependencias nuevas si el patrón existente ya resuelve el problema (ej. impresión vía CSS `@media print`, no una librería de PDF).

## Normativa
| Regulación | Aplica | Implicaciones |
|------------|--------|----------------|
| Protección de datos personales (datos de pequeños productores) | Sí, de forma informal | Mismo nivel de cuidado que las apps existentes: acceso solo por código, sin recolectar datos sensibles adicionales a los que ya pide el diagnóstico/finanzas. |
| Normativa específica de café/SCA/Cenicafé | No aplica como regulación legal | Se usan como referencias técnicas de calidad, no como obligación normativa. |

## Punto de Atención Especial
Extender el backend de `finanzas-cafeteros` implica **modificar una aplicación ya desplegada en producción** (Railway) que usan caficultores reales hoy. Cualquier cambio al `app.js` existente debe:
- Limitarse a añadir rutas nuevas (`/api/plan-accion`, `/api/admin/plan-accion`) sin tocar las rutas ni la lógica existentes.
- Probarse localmente antes de desplegar.
- Pasar por un checkpoint humano explícito antes de aplicarse (ver `06_pipeline.md`) — no se despliega sin revisión y aprobación directa del usuario.
