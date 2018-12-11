echo ON

:: %PYTHON% %RECIPE_DIR%\\filter.py --src=%PREFIX%\\Library --dst=filtered.pkl
:: if errorlevel 1 exit 1

mkdir build
if errorlevel 1 exit 1
cd build
if errorlevel 1 exit 1

set BUILD_CONFIG=Release

cmake -G "Visual Studio 15 2017 Win64" ^
      -DCMAKE_INSTALL_PREFIX=%PREFIX% ^
      -DUSE_PYTHON_INCLUDE_DIR=ON ^
      -DPYBIND11_TEST=OFF ^
      --config Release ^
      ..
if errorlevel 1 exit 1

cmake --build . --config "%BUILD_CONFIG%"
if errorlevel 1 exit 1

cmake --build . --config "%BUILD_CONFIG%" --target install
if errorlevel 1 exit 1

:: %PYTHON% %RECIPE_DIR%\\move.py --src=%PREFIX%\\Include --dst=%SRC_DIR%\\Library\\include --filtered=filtered.pkl
:: %PYTHON% %RECIPE_DIR%\\move.py --src=%PREFIX%\\Lib --dst=%SRC_DIR%\\Library\\Lib --filtered=filtered.pkl

echo OFF