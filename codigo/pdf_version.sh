#!/bin/bash

# Iniciales del alumno
INICIALES="BU"

# Buscar archivos PDF en el directorio actual y sus subdirectorios
find . -type f -name "*.pdf" | while read -r archivo
do
    # Obtener solamente el nombre del archivo
    nombre=$(basename "$archivo")

    # Omitir archivos que contengan "excluir" o las iniciales
    if [[ "$nombre" == *"excluir"* || "$nombre" == *"$INICIALES"* ]]; then
        continue
    fi

    # Obtener la primera línea del PDF
    primera_linea=$(head -n 1 "$archivo")

    # Verificar que la primera línea tenga el formato de un PDF
    if [[ "$primera_linea" == %PDF-* ]]; then

        # Eliminar "%PDF-" y conservar solamente la versión
        version="${primera_linea#%PDF-}"

        echo "Archivo: [$nombre] - Versión PDF: [$version]"
    else
        echo "Archivo: [$nombre] - Versión PDF: [desconocida]"
    fi
done
