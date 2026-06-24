# Visión del Proyecto: Plan de Mejora de Calidad de Café (Ubuntu Café / San Adolfo)

## Resumen Ejecutivo
El programa Ubuntu Café (Codespa, San Adolfo, Huila) ya tiene en banco de pruebas dos apps que comparten el mismo backend (Railway, `doc-comite-finanzas-production.up.railway.app/api`, autenticación por código de caficultor): **Diagnóstico Finca Café** (datos de proceso: cosecha, beneficio, secado, trilla, comparados contra referencias Cenicafé/FNC/SCA, con recomendaciones priorizadas) y **Finanzas Cafeteros** (situación económica de la finca).

Falta la pieza que conecta diagnóstico con acción: hoy las recomendaciones se muestran en pantalla pero no se convierten en un plan de acción con responsable, plazo y coste, ni se verifica si se ejecutaron ni si mejoraron los indicadores en la siguiente cosecha. Este proyecto construye esa pieza.

## Problema

### Situación Actual
El caficultor completa el diagnóstico y ve recomendaciones (prioridad alta/media, categoría, descripción, impacto esperado), pero ahí termina el flujo. El seguimiento de qué se hace con esas recomendaciones ocurre hoy de forma manual: WhatsApp, docx, reuniones de comité de producción (Victor/Davindson y líderes).

### Pain Points
- Las recomendaciones del diagnóstico no quedan registradas como plan de acción (sin responsable, sin plazo, sin coste estimado).
- No hay comparación "antes/después": no se puede verificar si una acción (p.ej. clasificación previa al despulpado) realmente bajó la merma en trilla o subió el puntaje SCA en la siguiente cosecha.
- El comité de producción no tiene un panel agregado del grupo: cuántos caficultores tienen plan activo, qué acciones predominan, qué brecha de calidad/merma sigue abierta.
- Decisiones de inversión del comité (capacitación de cata, secaderos, equipo) no tienen un criterio objetivo basado en datos reales de finca agregados.

### Coste del Problema
Según el análisis de referencia (Cenicafé/FNC/SCA) ya recopilado para el programa: el manejo (no la variedad) es lo que impide pasar de <80 a 82-86 puntos SCA, lo cual vale ~0,20-0,50 USD/lb adicionales. Las mermas evitables en beneficio húmedo y trilla (varios puntos porcentuales) tienen el mismo origen. Sin un proceso repetible de plan→ejecución→verificación, esas mejoras dependen de memoria y buena voluntad, no de sistema.

## Solución Propuesta

### Visión
Una app ligera, mobile-first (como las dos existentes), que:
1. Muestra al caficultor (o al facilitador junto con él) sus diagnósticos de proceso y financiero ya capturados.
2. Convierte las recomendaciones del diagnóstico en un plan de acción priorizado y editable (responsable, plazo, coste estimado).
3. Permite marcar acciones como en progreso/completadas con fecha y coste real.
4. En el siguiente ciclo de diagnóstico, compara indicadores antes/después por finca (¿bajó la merma? ¿subió el SCA?).
5. Da al comité de producción un panel agregado del grupo: planes activos, acciones más comunes, % de mejora.

### Propuesta de Valor
Cierra el ciclo diagnóstico → acción → verificación que hoy no existe, reutilizando los datos que el caficultor ya introduce (sin doble captura) y dando al comité un criterio objetivo de priorización de inversión.

## Usuarios Objetivo

### Perfil Principal
Caficultor joven de San Adolfo, participante del proyecto Ubuntu/Codespa. **Es quien controla y actualiza su propio plan de acción** (marca avance, fechas, costes reales) desde su móvil, con el mismo código que usa en el diagnóstico. Alfabetización digital variable, conectividad de campo limitada.

### Perfiles Secundarios
**Formador/consultor**: tiene acceso de **solo lectura** transversal — puede ver el plan y el avance de cada caficultor (y agregado del grupo) para dar seguimiento y decidir apoyos, pero no edita el plan en su lugar. (Confirmado con el usuario: "el caficultor debe controlar el desarrollo de las actividades de su plan y el formador/consultor tener acceso para ver qué está pasando".)

## Contexto de Mercado

### Competencia
Ninguna herramienta específica para este grupo; la alternativa actual es manual (WhatsApp, Excel/docx, reuniones de comité).

### Diferenciación
Integración directa con los datos que ya genera `diagnostico-finca-cafe` y `finanzas-cafeteros` (mismo backend), evitando que el caficultor vuelva a introducir información que ya dio.

## Restricciones Identificadas
- Conectividad limitada en campo → debe funcionar bien en móvil, ligero, idealmente con guardado tolerante a conexión intermitente (igual que las apps existentes).
- Proyecto social, sin presupuesto de desarrollo comercial → favorecer stack simple y barato de operar.
- **Confirmado**: se extiende el mismo backend Railway que ya usan `diagnostico-finca-cafe` y `finanzas-cafeteros` (nuevos endpoints, ej. `/plan-accion`), reutilizando autenticación por código y datos de diagnóstico ya guardados. No se duplica infraestructura.
- **Confirmado**: el caficultor controla su propio plan (alta/edición/marcar avance); el formador/consultor tiene acceso de solo lectura transversal (individual y agregado).
- **Confirmado sobre plazos**: sin fecha límite dura, pero se quiere una propuesta inicial usable en 2-3 semanas. Prioridad explícita del usuario: "hacerlo bien desde el inicio" — no es un prototipo descartable, así que el MVP debe construirse sobre las bases correctas (mismo patrón de calidad que el proyecto final), aunque el alcance funcional sea reducido.

## Criterios de Éxito (preliminares)
- % de caficultores con plan de acción activo tras su primer diagnóstico.
- Reducción medible de mermas (beneficio húmedo, trilla) y/o aumento del puntaje SCA promedio del grupo entre dos cosechas.
- El comité de producción usa el panel agregado para decidir inversiones, en lugar de hacerlo ad-hoc.

## Fuentes Usadas para este Borrador
- `doc comite produccion/Enfoque programa mejora calidad cafe.docx` (mismo día, contiene el brief completo de mermas, puntaje SCA, cata, IA de clasificación y el llamado a "evaluar/definir/lanzar acciones de mejora").
- Código fuente de `diagnostico-finca-cafe` (indicadores, lógica de recomendaciones, backend compartido).
- `manifest.json` de `diagnostico-finca-cafe` (contexto: San Adolfo, Huila, Ubuntu Café).
