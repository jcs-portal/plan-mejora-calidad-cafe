# Especificación de Producto: Plan de Mejora de Calidad de Café

## Alcance del MVP

### Funcionalidades Core
| ID | Funcionalidad | Descripción | Prioridad |
|----|---------------|-------------|-----------|
| F1 | Login con código existente | Reutiliza el código y backend de `finanzas-cafeteros`/`diagnostico-finca-cafe` (`X-Code`, roles `joven`/`formador`). Sin alta de usuarios nueva. | Must Have |
| F2 | Ver mi diagnóstico y recomendaciones | Lee el diagnóstico ya guardado (`/api/diagnostico`) y muestra las recomendaciones priorizadas (misma lógica que hoy calcula `diagnostico-finca-cafe` en el cliente). | Must Have |
| F3 | Generar plan de acción a partir de recomendaciones | Cada recomendación con prioridad alta/media se convierte en un ítem de plan editable: responsable, plazo, coste estimado. No duplica ítems ya creados si se repite el diagnóstico. | Must Have |
| F4 | Marcar avance de cada acción | El caficultor cambia estado (pendiente → en progreso → completada), con fecha real y coste real opcional. | Must Have |
| F5 | Vista del formador (solo lectura) | El formador ve el plan de cada caficultor de su comunidad y un resumen agregado (cuántos planes activos, cuántas acciones completadas/pendientes). Mismo patrón que `/api/admin/diagnostico`. | Must Have |
| F6 | Imprimir / exportar el plan en una página apaisada | Vista de impresión de una sola página en horizontal (landscape) con el plan completo del caficultor (diagnóstico resumido + acciones + estado), pensada para imprimir en papel o guardar como PDF desde el navegador. | Must Have |
| F7 | Comparar indicadores entre diagnósticos (antes/después) | Si existe un diagnóstico anterior guardado, mostrar variación de los indicadores clave (merma trilla, % pasilla, puntaje SCA) junto al plan. | Should Have (entra si el tiempo de las 2-3 semanas lo permite) |
| F8 | Mensajes del formador al caficultor | El formador envía comentarios y/o enlaces a documentación (PDF, video, imagen) dirigidos a un caficultor concreto o a toda la comunidad. El caficultor los ve como tarjetas visuales (icono + título + texto corto + botón "Ver documento" si hay enlace) al entrar a la app — pensado para pantalla de móvil, sin texto largo. | Must Have |

### Funcionalidades Diferidas
- Panel agregado avanzado con gráficas/tendencias del grupo a lo largo de varias cosechas.
- Notificaciones/recordatorios automáticos (WhatsApp, email) de acciones próximas a vencer.
- Cruce con datos financieros de `finanzas-cafeteros` (ej. costo real de cada acción vs. presupuesto familiar).
- Ficha de plan de acción descargable en Word/PDF generada en servidor (reutilizando la librería `docx` que ya usa el backend) — la v1 usa impresión desde el navegador, que no añade dependencias nuevas.
- Histórico completo de todos los diagnósticos (la v1 solo compara el actual contra el inmediatamente anterior).

### Alcance Negativo
- No sustituye el diagnóstico: el caficultor no vuelve a introducir los datos de proceso, solo los lee desde `diagnostico-finca-cafe`.
- No es un CRM de comité ni gestiona codes/comunidades (eso ya lo hace `finanzas-cafeteros` vía `/api/admin/codigo`).
- No genera reportes financieros (eso es responsabilidad de `finanzas-cafeteros`).

## Plataformas
Web móvil, una sola página HTML+JS servida como estática (mismo patrón que `diagnostico-finca-cafe`: un único `index.html` con React vía CDN, sin build step), consumiendo el backend Express existente. Sin apps nativas — coherente con conectividad limitada y bajo presupuesto.

## Requisitos No Funcionales
- **Rendimiento**: carga rápida en 3G/4G rural; un solo archivo HTML ligero, sin frameworks pesados.
- **Disponibilidad**: depende del mismo servicio Railway que ya corre `finanzas-cafeteros`; sin SLA formal (proyecto social).
- **Seguridad**: mismo esquema de autenticación por código que las otras dos apps (`X-Code` header, sin contraseñas). El acceso de "formador" a planes ajenos usa el rol `formador` ya existente — no se crea un tercer rol.
- **Impresión**: la vista de impresión debe forzar orientación horizontal (`@page { size: landscape; }`) y caber en una sola página A4.
- **Escalabilidad**: grupo pequeño (decenas de caficultores de San Adolfo); no se diseña para volumen.

## Integraciones
| Sistema | Tipo | Prioridad | Complejidad |
|---------|------|-----------|-------------|
| Backend Railway `finanzas-cafeteros` (extendido) | Nuevos endpoints REST en el mismo `app.js` (`/api/plan-accion`, `/api/admin/plan-accion`) | Alta | Baja — reutiliza `auth`/`formador` middleware y el patrón de `diagnostico` |
| Lógica de recomendaciones de `diagnostico-finca-cafe` | Se reutiliza la función que calcula recomendaciones a partir de los indicadores (hoy vive en el cliente de esa app) | Alta | Media — decidir si se duplica en este cliente o se extrae a un módulo compartido (ver Fase 4) |

## Flujos Principales

### Flujo caficultor
1. Login con código → `GET /api/whoami` (ya existe).
2. `GET /api/diagnostico` → calcular/mostrar recomendaciones.
3. `GET /api/plan-accion` → si no existe, generar ítems desde las recomendaciones actuales; si existe, fusionar (no duplicar) con recomendaciones nuevas.
4. Caficultor edita responsable/plazo/coste y marca avance → `PUT /api/plan-accion`.
5. `GET /api/mensajes` → ve tarjetas de comentarios/documentos enviados por su formador (sección visible desde el inicio, no escondida en un menú).
6. Botón "Imprimir" → abre vista landscape de una página → `window.print()`.

### Flujo formador
1. Login con código de formador.
2. `GET /api/admin/plan-accion` → lista de caficultores de su comunidad con resumen (igual patrón que `/api/admin/diagnostico`).
3. Entra al detalle de un caficultor → mismo componente de plan, en modo solo lectura.
4. Envía un comentario o enlace a documentación a un caficultor concreto (o a toda la comunidad) → `POST /api/admin/mensaje`.

### Flujo de mensajería (formador → caficultor)
El formador escribe un título corto + texto breve, y opcionalmente pega un enlace (a un PDF, video o imagen ya alojado en otro sitio — este proyecto no almacena archivos binarios). El caficultor ve el mensaje como una tarjeta grande con icono según tipo (📄 documento, 🔗 enlace, 💬 comentario), pensada para leerse de un vistazo en pantalla pequeña, sin scroll de texto largo.

### Flujo de sincronización plan ↔ diagnóstico
Cuando el diagnóstico cambia (nueva cosecha), al abrir el plan se comparan los indicadores nuevos contra los guardados en el plan anterior; las recomendaciones que ya no aplican se marcan como "resueltas", las nuevas se añaden como ítems pendientes.
