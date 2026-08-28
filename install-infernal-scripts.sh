#!/bin/bash

# Infernal scripts MIME installer - Instala el tipo MIME para scripts .inf
# Copyright (C) 2026 David Baña Szymaniak
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.

# Como root:
#   Instalación para todo el sistema.
#
# Como usuario:
#   Instalación únicamente para el usuario actual.
#
# Requiere:
#   infernal-script.svg en el directorio actual.

set -e

SOURCE="infernal-script.svg"
ICON_NAME="text-x-infernal.svg"
MIME_TYPE="text/x-infernal"

# Detectar directorios según el usuario
if [ "$EUID" -eq 0 ]; then
    echo "==> Ejecutando como root: instalación para todo el sistema."

    MIME_DIR="/usr/share/mime/packages"
    ICON_DIR="/usr/share/icons/breeze/mimetypes"
    MIME_DATABASE="/usr/share/mime"

    mkdir -p "$ICON_DIR/64"
    mkdir -p "$ICON_DIR/scalable"

else
    echo "==> Ejecutando como usuario: instalación local."

    DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

    MIME_DIR="$DATA_HOME/mime/packages"
    ICON_DIR="$DATA_HOME/icons/breeze/mimetypes"
    MIME_DATABASE="$DATA_HOME/mime"

    mkdir -p "$ICON_DIR/64"
    mkdir -p "$ICON_DIR/scalable"
    mkdir -p "$MIME_DIR"
fi

# Comprobar icono fuente
if [ ! -f "$SOURCE" ]; then
    echo "Error: no se encontró '$SOURCE'."
    exit 1
fi

# Comprobar herramientas necesarias
if ! command -v update-mime-database >/dev/null 2>&1; then
    echo "Error: no se encontró 'update-mime-database'."
    exit 1
fi

if ! command -v kbuildsycoca6 >/dev/null 2>&1; then
    echo "Error: no se encontró 'kbuildsycoca6'."
    exit 1
fi

echo "==> Creando definición MIME..."

cat > "$MIME_DIR/infernal.xml" <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
    <mime-type type="text/x-infernal">
        <comment>Script de Infernal</comment>
        <glob pattern="*.inf" weight="80"/>
        <glob pattern="*.infernal" weight="80"/>
    </mime-type>
</mime-info>
EOF

echo "    $MIME_DIR/infernal.xml"

echo "==> Instalando icono..."

cp "$SOURCE" "$ICON_DIR/64/$ICON_NAME"
cp "$SOURCE" "$ICON_DIR/scalable/$ICON_NAME"

echo "    $ICON_DIR/64/$ICON_NAME"
echo "    $ICON_DIR/scalable/$ICON_NAME"

echo "==> Actualizando base de datos MIME..."

update-mime-database "$MIME_DATABASE"

echo "==> Actualizando caché de KDE..."

kbuildsycoca6 --noincremental

echo "==> Comprobando MIME..."

TEST_FILE=$(mktemp --suffix=.inf)
echo "# Infernal" > "$TEST_FILE"

MIME_RESULT=$(xdg-mime query filetype "$TEST_FILE" 2>/dev/null || true)

rm -f "$TEST_FILE"

if [ "$MIME_RESULT" = "$MIME_TYPE" ]; then
    echo "OK: *.inf -> $MIME_TYPE"
else
    echo "AVISO: MIME detectado: $MIME_RESULT"
fi

echo
echo "========================================"
echo "  Infernal MIME instalado correctamente"
echo "========================================"
echo
echo "Extensión: *.inf y .infernal"
echo "MIME:      $MIME_TYPE"
echo "Icono:     $ICON_NAME"
echo
