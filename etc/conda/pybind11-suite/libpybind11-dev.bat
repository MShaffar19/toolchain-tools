echo ON

rem python %RECIPE_DIR%\\move.py --src=%SRC_DIR%\\Library\\include --dst=%PREFIX%\\include

cd build
if errorlevel 1 exit 1

nmake install
if errorlevel 1 exit 1

echo OFF