echo ON

cd build
if errorlevel 1 exit 1

set BUILD_CONFIG=Release

cmake --build . --config "%BUILD_CONFIG%" --target install
if errorlevel 1 exit 1

echo OFF