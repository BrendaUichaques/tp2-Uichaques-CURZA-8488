#!/bin/bash

## Legajo del alumno para personalizar el mensaje de salida
LEGAJO="8488"

## Mensaje que mostrará select para pedir una opción
PS3="Seleccione una opción (1-4): "

## Crear el menú interactivo
select opcion in \
    "Monitorear memoria RAM" \
    "Buscar archivos grandes" \
    "Espacio en particiones" \
    "Salir"
do
    ## Evaluar la opción elegida por el usuario
    case "$opcion" in

        "Monitorear memoria RAM")
            echo "=== USO DE MEMORIA RAM ==="

            ## Mostrar memoria total, usada y libre en megabytes
            free -m
            ;;

        "Buscar archivos grandes")
            echo "=== 5 ARCHIVOS MAYORES A 10 MB EN $HOME ==="

            ## Buscar archivos mayores a 10 MB,
            ## ordenarlos de mayor a menor y mostrar solamente los 5 primeros
            find "$HOME" -type f -size +10M -exec du -h {} \; 2>/dev/null |
            sort -hr |
            head -n 5
            ;;

        "Espacio en particiones")
            echo "=== ESPACIO EN PARTICIONES MONTADAS ==="

            ## Mostrar el uso de disco y filtrar los sistemas de archivos
            ## que corresponden a dispositivos montados en /dev/
            df -h | grep '^/dev/'
            ;;

        "Salir")
            ## Mostrar saludo personalizado y terminar el menú
            echo "Hasta luego. Legajo: $LEGAJO"
            break
            ;;

        *)
            ## Se ejecuta si el usuario ingresa una opción no válida
            echo "Opción inválida. Seleccione una opción entre 1 y 4."
            ;;

    esac

    echo ""
done
