echo ON

rem python %RECIPE_DIR%\\move.py --src=%SRC_DIR%\\Library\\Lib --dst=%PREFIX%\\Lib

set PYBIND11_USE_CMAKE=1
if errorlevel 1 exit 1

%PYTHON% setup.py install --single-version-externally-managed --record record.txt
if errorlevel 1 exit 1


echo OFF