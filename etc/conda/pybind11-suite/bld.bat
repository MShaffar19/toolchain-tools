echo ON

rem %PYTHON% %RECIPE_DIR%\\filter.py --src=%PREFIX%\\Library --dst=filtered.pkl
rem if errorlevel 1 exit 1

mkdir build
if errorlevel 1 exit 1
cd build
if errorlevel 1 exit 1

cmake -G "NMake Makefiles" ^
      -DCMAKE_INSTALL_PREFIX=%PREFIX% ^
      -DUSE_PYTHON_INCLUDE_DIR=ON ^
      -DPYBIND11_TEST=OFF ^
      ..
if errorlevel 1 exit 1

nmake
if errorlevel 1 exit 1

rem %PYTHON% %RECIPE_DIR%\\move.py --src=%PREFIX%\\Include --dst=%SRC_DIR%\\Library\\include --filtered=filtered.pkl
rem %PYTHON% %RECIPE_DIR%\\move.py --src=%PREFIX%\\Lib --dst=%SRC_DIR%\\Library\\Lib --filtered=filtered.pkl

echo OFF