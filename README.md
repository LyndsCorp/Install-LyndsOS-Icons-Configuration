# Install-LyndsOS-Icons-Configuration

Herramientas para instalar y configurar las asociaciones MIME e iconos utilizados por LyndsOS.

## ¿Qué incluye?

* Icono MIME para scripts de **Infernal** (`.inf`).
* Asociación MIME `text/x-infernal`.
* Icono MIME para paquetes **Casata** (`.casata`).
* Asociación MIME `application/x-casata`.
* Instalación global mediante `root`.
* Instalación únicamente para el usuario actual cuando se ejecuta sin `root`.

## Licencias

Los componentes del repositorio utilizan distintas licencias:

| Archivo                       | Licencia          |
| ----------------------------- | ----------------- |
| `infernal-script.svg`         | LGPL-3.0-or-later |
| `install-infernal-scripts.sh` | GPL-3.0-or-later  |
| `install-casata-packages.sh`  | GPL-3.0-or-later  |

Las licencias completas se encuentran en `LICENSE_GPL-v3` y `LICENSE_LGPL-v3`.

## Atribuciones

`infernal-script.svg` está basado en el icono de script de **Breeze Icon Theme** y contiene modificaciones para representar scripts de Infernal.

Las atribuciones y la información de copyright correspondiente se encuentran en [`ATTRIBUTIONS.md`](ATTRIBUTIONS.md).

## Uso

Ejecuta el instalador correspondiente:

```bash
bash install-infernal-scripts.sh
```

o para instalar que los archivos .casata se vean bien:

```bash
bash install-casata-packages.sh
```

Si se ejecuta como `root`, la configuración se instala globalmente. Si se ejecuta como usuario normal, se instala únicamente para ese usuario.

## Proyecto

Parte de la infraestructura de LyndsOS y de los proyectos de Lynds Corp.
