#!/bin/sh
# Arranque del contenedor. data/, models/ y reports/ son carpetas de tu equipo (volúmenes).
# Si Docker las creó como root (pasa en Linux y en un VPS), el usuario "bot" no podría
# escribir en ellas: se corrige el dueño y luego el bot corre sin privilegios.
set -e
if [ "$(id -u)" = "0" ]; then
  find /app/data /app/models /app/reports ! -user bot -exec chown bot:bot {} +
  export HOME=/home/bot
  exec setpriv --reuid=bot --regid=bot --init-groups "$@"
fi
exec "$@"
