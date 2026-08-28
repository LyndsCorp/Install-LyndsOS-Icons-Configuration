#!/bin/bash

set -e

MIME_TYPE="application/x-casata"
ICON_NAME="package-x-casata"
SOURCE_ICON="/usr/share/icons/breeze-dark/mimetypes/64/application-x-rar.svg"

if [ ! -f "$SOURCE_ICON" ]; then
    echo "Error: no existe el icono original:"
    echo "$SOURCE_ICON"
    exit 1
fi

if [ "$(id -u)" -eq 0 ]; then
    # =========================
    # INSTALACIÓN GLOBAL
    # =========================

    for THEME in breeze breeze-dark; do
        ICON_DIR="/usr/share/icons/$THEME/mimetypes/64"
        mkdir -p "$ICON_DIR"

        ln -sf "$SOURCE_ICON" \
            "$ICON_DIR/$ICON_NAME.svg"
    done

    MIME_DIR="/usr/share/mime/packages"
    mkdir -p "$MIME_DIR"

    cat > "$MIME_DIR/casata.xml" <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
    <mime-type type="application/x-casata">
        <comment>Paquete Casata</comment>
        <icon name="package-x-casata"/>
        <glob pattern="*.casata" weight="80"/>
    </mime-type>
</mime-info>
EOF

    update-mime-database /usr/share/mime
    kbuildsycoca6 --noincremental

    echo "MIME de Casata instalado globalmente."
    echo "Icono: package-x-casata.svg"
    echo "MIME: application/x-casata"

else
    # =========================
    # INSTALACIÓN DEL USUARIO
    # =========================

    for THEME in breeze breeze-dark; do
        ICON_DIR="$HOME/.local/share/icons/$THEME/mimetypes/64"
        mkdir -p "$ICON_DIR"

        ln -sf "$SOURCE_ICON" \
            "$ICON_DIR/$ICON_NAME.svg"
    done

    MIME_DIR="$HOME/.local/share/mime/packages"
    mkdir -p "$MIME_DIR"

    cat > "$MIME_DIR/casata.xml" <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
    <mime-type type="application/x-casata">
        <comment>Paquete Casata</comment>
        <icon name="package-x-casata"/>
        <glob pattern="*.casata" weight="80"/>
    </mime-type>
</mime-info>
EOF

    update-mime-database "$HOME/.local/share/mime"
    kbuildsycoca6 --noincremental

    echo "MIME de Casata instalado para $USER."
    echo "Icono: $ICON_NAME.svg"
    echo "MIME: $MIME_TYPE"
fi
