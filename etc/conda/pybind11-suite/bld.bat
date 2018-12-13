echo ON

mkdir build
if errorlevel 1 exit 1
cd build
if errorlevel 1 exit 1

set BUILD_CONFIG=Release

cmake -G "Visual Studio 15 2017 Win64" ^
      -DCMAKE_INSTALL_PREFIX=%PREFIX% ^
      -DUSE_PYTHON_INCLUDE_DIR=OFF ^
      -DPYBIND11_TEST=OFF ^
      --config Release ^
      ..
if errorlevel 1 exit 1

cmake --build . --config "%BUILD_CONFIG%"
if errorlevel 1 exit 1

echo OFF