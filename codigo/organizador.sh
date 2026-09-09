#!/bin/bash

# Verificar que se haya recibido exactamente un argumento
if [[ $# -ne 1 ]]
then
    echo "Error: debe indicar un directorio."
    echo "Uso: $0 <directorio>"
    exit 1
fi

# Guardar el directorio recibido como argumento
destino="$1"

# Verificar que el directorio exista
if [[ ! -d "$destino" ]]
then
    echo "Error: el directorio '$destino' no existe."
    exit 1
fi

# Verificar que el directorio sea accesible
if [[ ! -r "$destino" || ! -w "$destino" || ! -x "$destino" ]]
then
    echo "Error: el directorio '$destino' no es accesible."
    exit 1
fi

# Crear las carpetas necesarias dentro del directorio destino
mkdir -p "$destino/imagenes"
mkdir -p "$destino/documentos"
mkdir -p "$destino/comprimidos"
mkdir -p "$destino/otros"

# Recorrer todos los elementos que se encuentran dentro del directorio
for archivo in "$destino"/*
do
    # Si el elemento no es un archivo normal, pasar al siguiente
    if [[ ! -f "$archivo" ]]
    then
        continue
    fi

    # Si el archivo termina en .old, cambiar su extensión a .backup
    if [[ "$archivo" == *.old ]]
    then
        nuevo_archivo="${archivo%.old}.backup"
        mv "$archivo" "$nuevo_archivo"

        # Actualizar la variable para continuar trabajando
        # con el archivo ya renombrado
        archivo="$nuevo_archivo"
    fi

    # Mover imágenes
    if [[ "$archivo" == *.jpg || "$archivo" == *.png ]]
    then
        mv "$archivo" "$destino/imagenes/"

    # Mover documentos
    elif [[ "$archivo" == *.pdf ||
            "$archivo" == *.txt ||
            "$archivo" == *.docx ]]
    then
        mv "$archivo" "$destino/documentos/"

    # Mover archivos comprimidos
    elif [[ "$archivo" == *.zip ||
            "$archivo" == *.tar.gz ||
            "$archivo" == *.rar ]]
    then
        mv "$archivo" "$destino/comprimidos/"

    # Todo lo que no coincida con las categorías anteriores
    else
        mv "$archivo" "$destino/otros/"
    fi
done

echo "Organización finalizada correctamente."
