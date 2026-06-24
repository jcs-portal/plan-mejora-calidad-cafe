#!/usr/bin/env bash
REMAINING=$(grep -r "TODO\|FIXME\|HACK" index.html 2>/dev/null | wc -l)

if [ "$REMAINING" -gt 0 ]; then
  echo "Hay $REMAINING TODOs/FIXMEs pendientes en index.html. Revisa si puedes resolver alguno dentro de tu scope."
  exit 2
fi

exit 0
