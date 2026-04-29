@echo off
:: ============================================================
::  Inventario de Recursos — run.bat
::  1. Ejecuta el script en local (sin OneDrive)
::  2. Si termina OK, copia el Excel a la carpeta OneDrive
:: ============================================================

:: ── CONFIGURACION — editar estas rutas ──────────────────────
set PROJECT_DIR=C:\inventory\vm-inventory
set VENV_PYTHON=%PROJECT_DIR%\venv\Scripts\python.exe
set OUTPUT_LOCAL=%PROJECT_DIR%\output\vm_inventory.xlsx
set ONEDRIVE_DEST=C:\Users\usuario\OneDrive - Empresa\Inventario\vm_inventory.xlsx
:: ────────────────────────────────────────────────────────────

echo.
echo Ejecutando inventario...
echo.

cd /d "%PROJECT_DIR%"
"%VENV_PYTHON%" main.py

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: El script termino con errores. No se copio el archivo.
    pause
    exit /b 1
)

echo.
echo Copiando a OneDrive...
copy /Y "%OUTPUT_LOCAL%" "%ONEDRIVE_DEST%"

if %ERRORLEVEL% NEQ 0 (
    echo ERROR: No se pudo copiar a OneDrive. Revisar la ruta destino.
    pause
    exit /b 1
)

echo.
echo Listo. Archivo actualizado en OneDrive.
pause
