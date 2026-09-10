#!/bin/bash

## Legajo del alumno
LEGAJO="8488"

## Rutas que utilizará el script
BASE="$(dirname "$0")/.."
CODIGO="$BASE/codigo"
LOGS="$BASE/logs"
TEMP="/tmp/backup_${LEGAJO}"
LOCK="/var/lock/backup_${LEGAJO}.lock"

## Obtener la fecha y hora para el nombre del backup
FECHA=$(date +"%Y%m%d_%H%M%S")

## Nombre final del archivo comprimido
ARCHIVO_BACKUP="$LOGS/backup_${LEGAJO}_${FECHA}.tar.gz"

## Intentar crear el directorio de bloqueo
mkdir "$LOCK" 2>/dev/null

## Si mkdir falla, significa que ya existe un bloqueo
if [[ $? -ne 0 ]]
then
    echo "Error: ya existe una ejecución del backup."
    exit 9
fi

## Eliminar el directorio de bloqueo al terminar el script
trap 'rmdir "/var/lock/backup_8488.lock"' EXIT

## Crear la carpeta logs si todavía no existe
mkdir -p "$LOGS"

## Eliminar un respaldo temporal anterior si existe
rm -rf "$TEMP"

## Crear nuevamente el directorio temporal
mkdir -p "$TEMP"

## Entrar al directorio donde se encuentran los scripts
cd "$CODIGO"

## Buscar archivos modificados durante las últimas 24 horas
## y copiarlos al directorio temporal
find . -mtime -1 -type f | while read -r archivo
do
    cp "$archivo" "$TEMP/"
done

## Crear el archivo tar.gz dentro de logs
tar -czf "$ARCHIVO_BACKUP" -C /tmp "backup_${LEGAJO}"

echo "Backup realizado correctamente."
echo "Archivo creado: $ARCHIVO_BACKUP"
