#!/usr/bin/env bash
# Este proyecto no tiene linter/test runner (mismo patrón "sin tooling" que las apps
# hermanas). Verificamos lo mínimo imprescindible: que el backend externo que se está
# extendiendo siga siendo JS válido, y que el frontend no tenga marcadores de conflicto.

APP_JS="../doc comite finanzas/finanzas-cafeteros/app.js"

if [ -f "$APP_JS" ]; then
  if ! node --check "$APP_JS" > /tmp/verify-app-js-error 2>&1; then
    echo "finanzas-cafeteros/app.js tiene un error de sintaxis. Corrígelo antes de completar:"
    cat /tmp/verify-app-js-error
    exit 2
  fi
fi

if [ -f "index.html" ] && grep -q "<<<<<<<" index.html; then
  echo "index.html tiene marcadores de conflicto sin resolver."
  exit 2
fi

exit 0
