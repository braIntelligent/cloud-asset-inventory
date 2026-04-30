@echo off
chcp 65001 > nul
:: ============================================================
::  Inventario de Recursos — run.bat
::  1. Ejecuta el script en local (sin OneDrive)
::  2. Si termina OK, copia el Excel a la carpeta OneDrive
:: ============================================================

:: ── CONFIGURACION — editar estas rutas ──────────────────────
set PROJECT_DIR=C:\inventory\vm-inventory
set VENV_PYTHON=%PROJECT_DIR%\venv\Scripts\python.exe
set OUTPUT_LOCAL=%PROJECT_DIR%\output\vm_inventory.xlsx
set ONEDRIVE_SUBDIR=Inventario\vm_inventory.xlsx
:: ────────────────────────────────────────────────────────────

:: detectar carpeta OneDrive automaticamente (cuenta empresa o personal)
if defined OneDriveCommercial (
    set ONEDRIVE_DEST=%OneDriveCommercial%\%ONEDRIVE_SUBDIR%
) else if defined OneDrive (
    set ONEDRIVE_DEST=%OneDrive%\%ONEDRIVE_SUBDIR%
) else (
    echo ERROR: No se encontro OneDrive en este equipo.
    pause
    exit /b 1
)

echo.
echo OneDrive detectado: %ONEDRIVE_DEST%
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

:: verificar que la carpeta destino existe antes de copiar
for %%F in ("%ONEDRIVE_DEST%") do set ONEDRIVE_DIR=%%~dpF
if not exist "%ONEDRIVE_DIR%" (
    echo ERROR: La carpeta destino no existe: %ONEDRIVE_DIR%
    echo Creala manualmente en OneDrive y vuelve a ejecutar el bat.
    pause
    exit /b 1
)

copy /Y "%OUTPUT_LOCAL%" "%ONEDRIVE_DEST%"

if %ERRORLEVEL% NEQ 0 (
    echo ERROR: No se pudo copiar a OneDrive. Ruta: %ONEDRIVE_DEST%
    pause
    exit /b 1
)

echo.
echo Listo. Archivo actualizado en: %ONEDRIVE_DEST%
pause
