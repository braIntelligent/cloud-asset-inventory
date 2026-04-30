@echo off
chcp 65001 > nul
:: ============================================================
::  Inventario de Recursos — run.bat
::  Flujo simple: OUTPUT_PATH en .env apunta directo a OneDrive
::  IMPORTANTE: asegurarse que nadie tenga el Excel abierto
:: ============================================================

:: ── CONFIGURACION — editar esta ruta ─────────────────────────
set PROJECT_DIR=C:\inventory\vm-inventory
set VENV_PYTHON=%PROJECT_DIR%\venv\Scripts\python.exe
:: ────────────────────────────────────────────────────────────

echo.
echo IMPORTANTE: Asegurate que nadie tenga el archivo Excel abierto.
echo.
pause

cd /d "%PROJECT_DIR%"
"%VENV_PYTHON%" main.py

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: El script termino con errores.
    pause
    exit /b 1
)

echo.
echo Listo. Archivo actualizado en OneDrive.
pause
