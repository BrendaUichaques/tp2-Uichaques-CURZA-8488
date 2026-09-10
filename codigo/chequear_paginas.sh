#!/bin/bash

## Legajo del alumno
LEGAJO="8488"

## Rutas de los archivos que utiliza el script
BASE="$(dirname "$0")/.."
ARCHIVO_SITIOS="$BASE/sitios_${LEGAJO}.txt"
LOG="$BASE/logs/chequeo_${LEGAJO}.log"

## Colores para mostrar los resultados en la terminal
VERDE="\033[32m"
AMARILLO="\033[33m"
ROJO="\033[31m"
NORMAL="\033[0m"

## Crear la carpeta logs si no existe
mkdir -p "$BASE/logs"

## Vaciar el archivo de log antes de comenzar un nuevo chequeo
> "$LOG"

## Si se recibieron URLs como argumentos
if [[ $# -gt 0 ]]
then
    ## Recorrer todas las URLs recibidas
    for url in "$@"
    do
        ## Obtener solamente el código de estado HTTP
        codigo=$(curl -s -o /dev/null -w "%{http_code}" "$url")

        ## Mostrar el resultado según el código HTTP
        if [[ "$codigo" == "200" ]]
        then
            echo -e "${VERDE}$url - Código HTTP: $codigo${NORMAL}"

        elif [[ "$codigo" == 3* ]]
        then
            echo -e "${AMARILLO}$url - Código HTTP: $codigo${NORMAL}"

        elif [[ "$codigo" == 4* || "$codigo" == 5* ]]
        then
            echo -e "${ROJO}$url - Código HTTP: $codigo${NORMAL}"

        else
            echo -e "${ROJO}$url - Código HTTP: $codigo${NORMAL}"
        fi

        ## Guardar el resultado sin colores en el archivo de log
        echo "$url - Código HTTP: $codigo" >> "$LOG"
    done

## Si no se recibieron URLs como argumentos
else
    ## Verificar que exista el archivo con las URLs
    if [[ ! -f "$ARCHIVO_SITIOS" ]]
    then
        echo "Error: no existe el archivo sitios_${LEGAJO}.txt"
        exit 1
    fi

    ## Leer las URLs desde el archivo
    while read -r url
    do
        ## Ignorar líneas vacías
        if [[ -z "$url" ]]
        then
            continue
        fi

        ## Obtener solamente el código de estado HTTP
        codigo=$(curl -s -o /dev/null -w "%{http_code}" "$url")

        ## Mostrar el resultado según el código HTTP
        if [[ "$codigo" == "200" ]]
        then
            echo -e "${VERDE}$url - Código HTTP: $codigo${NORMAL}"

        elif [[ "$codigo" == 3* ]]
        then
            echo -e "${AMARILLO}$url - Código HTTP: $codigo${NORMAL}"

        elif [[ "$codigo" == 4* || "$codigo" == 5* ]]
        then
            echo -e "${ROJO}$url - Código HTTP: $codigo${NORMAL}"

        else
            echo -e "${ROJO}$url - Código HTTP: $codigo${NORMAL}"
        fi

        ## Guardar el resultado sin colores en el archivo de log
        echo "$url - Código HTTP: $codigo" >> "$LOG"

    done < "$ARCHIVO_SITIOS"
fi

echo "Reporte guardado en logs/chequeo_${LEGAJO}.log"
