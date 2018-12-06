echo ON

rem %PYTHON% %RECIPE_DIR%\\filter.py --src=%PREFIX%\\Library --dst=filtered.pkl
rem if errorlevel 1 exit 1

mkdir build
if errorlevel 1 exit 1
cd build
if errorlevel 1 exit 1

set PATH="c:\Program Files (x86)\Windows Kits\10\bin\10.0.16299.0\x64\";%PATH%
if errorlevel 1 exit 1

cmake -G "NMake Makefiles" ^
      -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON ^
      -D CMAKE_INSTALL_PREFIX=%PREFIX% ^
      -D USE_PYTHON_INCLUDE_DIR=ON ^
      -D PYBIND11_TEST=OFF ^
      ..
if errorlevel 1 exit 1

nmake
if errorlevel 1 exit 1

rem %PYTHON% %RECIPE_DIR%\\move.py --src=%PREFIX%\\Include --dst=%SRC_DIR%\\Library\\include --filtered=filtered.pkl
rem %PYTHON% %RECIPE_DIR%\\move.py --src=%PREFIX%\\Lib --dst=%SRC_DIR%\\Library\\Lib --filtered=filtered.pkl

echo OFF