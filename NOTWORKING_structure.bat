@echo off
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

:: ------------------------------
:: First argument: root directory
:: ------------------------------
set "ROOT_DIR=%~1"
if "%ROOT_DIR%"=="" set "ROOT_DIR=%CD%\new_experiment_dir"

:: ------------------------------
:: Remaining arguments: tags
:: ------------------------------
shift
if "%*"=="" (
    set "TAGS=default"
) else (
    set "TAGS=%*"
)

:: ------------------------------
:: Create py_touch.py once (outside loops)
:: ------------------------------
if not exist "%ROOT_DIR%\scripts" mkdir "%ROOT_DIR%\scripts" 2>nul
echo import sys > "%ROOT_DIR%\scripts\py_touch.py"
echo from pathlib import Path >> "%ROOT_DIR%\scripts\py_touch.py"
echo for f in sys.argv[1:]: >> "%ROOT_DIR%\scripts\py_touch.py"
echo     path = Path(f) >> "%ROOT_DIR%\scripts\py_touch.py"
echo     path.parent.mkdir(parents=True, exist_ok=True) >> "%ROOT_DIR%\scripts\py_touch.py"
echo     path.touch(exist_ok=True) >> "%ROOT_DIR%\scripts\py_touch.py"
echo. >> "%ROOT_DIR%\scripts\py_touch.py"

:: ------------------------------
:: Files to create
:: ------------------------------
set FILES=README.md ^
    notebooks\00_data_exploration.ipynb ^
    notebooks\01_model_build.ipynb ^
    notebooks\02_training.ipynb ^
    notebooks\03_inference_quick_explore.ipynb ^
    scripts\py_build_model.py ^
    scripts\build_model.cmd ^
    scripts\py_train_model.py ^
    scripts\train_model.cmd ^
    scripts\py_inference.py ^
    scripts\inference.cmd ^
    scripts\py_utils.py

:: ------------------------------
:: Loop through tags
:: ------------------------------
for %%T in (%TAGS%) do (
    set "TAG_DIR=%ROOT_DIR%\%%T"

    :: Create main directories
    mkdir "!TAG_DIR!" 2>nul
    mkdir "!TAG_DIR!\notebooks" "!TAG_DIR!\datasets" "!TAG_DIR!\models" "!TAG_DIR!\logs" "!TAG_DIR!\scripts" "!TAG_DIR!\visualizations" "!TAG_DIR!\outputs" 2>nul
    mkdir "!TAG_DIR!\outputs\csv_logs" "!TAG_DIR!\outputs\gradcam_images" 2>nul

    :: Loop through files and create each with tag appended to stem
    for %%F in (%FILES%) do (
        set "NAME=%%~nF"
        set "EXT=%%~xF"
        call python "%ROOT_DIR%\scripts\py_touch.py" "!TAG_DIR!\!NAME!_%%T!EXT!"
    )
)

echo Project scaffolding with tags and subdirectories created at "%ROOT_DIR%"
ENDLOCAL
