@echo off
chcp 65001 > nul
:: ============================================================
::  Inventario de Recursos — run.bat
::  1. Baja el Excel de OneDrive a local (trae ediciones del equipo)
::  2. Corre el script en local
::  3. Si termina OK, sube el Excel de local a OneDrive
:: ============================================================

:: ── CONFIGURACION — editar estas rutas ──────────────────────
set PROJECT_DIR=C:\inventory\vm-inventory
set VENV_PYTHON=%PROJECT_DIR%\venv\Scripts\python.exe
set OUTPUT_LOCAL=%PROJECT_DIR%\output\vm_inventory.xlsx
set ONEDRIVE_SUBDIR=Inventario\vm_inventory.xlsx
:: ────────────────────────────────────────────────────────────

:: detectar carpeta OneDrive automaticamente (cuenta empresa o personal)
if defined OneDriveCommercial (
    set ONEDRIVE_FILE=%OneDriveCommercial%\%ONEDRIVE_SUBDIR%
) else if defined OneDrive (
    set ONEDRIVE_FILE=%OneDrive%\%ONEDRIVE_SUBDIR%
) else (
    echo ERROR: No se encontro OneDrive en este equipo.
    pause
    exit /b 1
)

:: verificar que la carpeta destino existe
for %%F in ("%ONEDRIVE_FILE%") do set ONEDRIVE_DIR=%%~dpF
if not exist "%ONEDRIVE_DIR%" (
    echo ERROR: La carpeta destino no existe: %ONEDRIVE_DIR%
    echo Creala manualmente en OneDrive y vuelve a ejecutar el bat.
    pause
    exit /b 1
)

echo.
echo OneDrive: %ONEDRIVE_FILE%
echo.

:: paso 1 — bajar Excel de OneDrive a local (trae ediciones del equipo)
if exist "%ONEDRIVE_FILE%" (
    echo Bajando Excel de OneDrive...
    copy /Y "%ONEDRIVE_FILE%" "%OUTPUT_LOCAL%"
    if %ERRORLEVEL% NEQ 0 (
        echo ERROR: No se pudo leer el archivo de OneDrive.
        echo Asegurate que nadie lo tenga abierto e intenta de nuevo.
        pause
        exit /b 1
    )
) else (
    echo Primera ejecucion — no hay archivo previo en OneDrive.
)

:: paso 2 — correr el script en local
echo.
echo Ejecutando inventario...
echo.
cd /d "%PROJECT_DIR%"
"%VENV_PYTHON%" main.py

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: El script termino con errores. No se subio el archivo.
    pause
    exit /b 1
)

:: paso 3 — subir Excel de local a OneDrive
echo.
echo Subiendo Excel a OneDrive...
copy /Y "%OUTPUT_LOCAL%" "%ONEDRIVE_FILE%"

if %ERRORLEVEL% NEQ 0 (
    echo ERROR: No se pudo copiar a OneDrive. Ruta: %ONEDRIVE_FILE%
    pause
    exit /b 1
)

echo.
echo Listo. Archivo actualizado en: %ONEDRIVE_FILE%
pause
