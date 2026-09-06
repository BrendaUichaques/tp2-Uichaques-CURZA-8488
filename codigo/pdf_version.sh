#!/bin/bash
#Iniciales del alumno
INICIALES="BU"
#Variable para saber si se encontró al menos un PDF válido
encontrado=0
#Buscar archivos PDF en el directorio actual y sus subdirectorios
while IFS= read -r -d '' archivo
do
    # Obtener solamente el nombre del archivo
    nombre=$(basename "$archivo")
# Convertir nombre e iniciales a minúsculas para comparar
nombre_minusculas=$(echo "$nombre" | tr '[:upper:]' '[:lower:]')
iniciales_minusculas=$(echo "$INICIALES" | tr '[:upper:]' '[:lower:]')

# Omitir archivos que contengan "excluir" o las iniciales
if [[ "$nombre_minusculas" == *"excluir"* ]] ||
   [[ "$nombre_minusculas" == *"$iniciales_minusculas"* ]]
then
    continue
fi

# Obtener la primera línea del PDF
primera_linea=$(head -n 1 "$archivo" 2>/dev/null)

# Verificar que tenga el formato esperado: %PDF-1.X
if [[ "$primera_linea" =~ ^%PDF-([0-9]+\.[0-9]+) ]]
then
    version="${BASH_REMATCH[1]}"

    echo "Archivo: [$nombre] - Versión PDF: [$version]"
    encontrado=1
else
    echo "Archivo: [$nombre] - Versión PDF: [desconocida]"
    encontrado=1
fi
done < <(find . -type f -iname "*.pdf" -print0 2>/dev/null)
#Si no se encontraron archivos PDF válidos
if [[ $encontrado -eq 0 ]]
then
    echo "No se encontraron archivos PDF válidos para mostrar."
fi

