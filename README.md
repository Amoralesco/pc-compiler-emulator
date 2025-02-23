# pc-compiler-emulator

Este proyecto simula un compilador y emulador de PC. A continuación se explica cómo compilar y ejecutar el proyecto.

## Requisitos
- Python 3.x instalado.
- Módulo Tkinter (generalmente incluido en Python). Si no está instalado, instálalo en Linux ejecutando:
    - Para distribuciones basadas en Debian/Ubuntu:
      ```
      sudo apt-get install python3-tk
      ```
- Los ejecutables: `preprocesador`, `emsablador`, `soluter` y `procesador` deben estar compilados y disponibles en el directorio raíz o en el PATH.

- si no los tiene compilados los puede compilar con los siguientes comandos: 

    preprocesador
    ```
    flex preprocesador.l
    gcc lex.yy.c -o preprocesador -lfl
    ```
    emsamblador
    ```
    flex emsamblador.l
    gcc lex.yy.c -o emsamblador -lfl
    ```
    soluter
    ```
    flex solucionador.l
    gcc lex.yy.c -o soluter -lfl
    ```
    enlazador
    ```
    flex enlazador-cargador.l
    gcc lex.yy.c -o enlazador -lfl
    ```


## Compilación y Ejecución
1. Asegúrate de tener todos los archivos fuente (`draw.py`, `gincami.py`, etc.) y los ejecutables mencionados.
2. Ejecuta la interfaz principal con:
    ```
    python3 draw.py
    ```
3. La aplicación abrirá una ventana con editores para el preprocesador, procesador, ensamblador y enlazador. Utiliza los botones correspondientes para generar cada etapa del proceso.

## Notas Adicionales
- Verifica que los ejecutables necesarios tengan permisos de ejecución.
- Si se presentan errores, revisa los mensajes en consola y asegúrate de que las dependencias están correctamente instaladas y configuradas.

