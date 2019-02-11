set -ve

declare -a CMAKE_PLATFORM_FLAGS
if [[ ${HOST} =~ .*darwin.* ]]
then
    if [[ ! "${CONDA_BUILD_SYSROOT}" = "" ]]
    then
        CMAKE_PLATFORM_FLAGS+=(-DCMAKE_OSX_SYSROOT="${CONDA_BUILD_SYSROOT}")
    fi
elif [[ ${HOST} =~ .*linux.* ]]
then
    CMAKE_PLATFORM_FLAGS+=(-DCMAKE_TOOLCHAIN_FILE="${RECIPE_DIR}/cross-linux.cmake")
fi

mkdir build
cd build

cmake \
  -DCMAKE_CXX_COMPILER=${CXX} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DUSE_PYTHON_INCLUDE_DIR=OFF \
  -DPYTHON_EXECUTABLE=${PREFIX}/bin/python \
  -DPYBIND11_TEST=OFF \
  ${CMAKE_PLATFORM_FLAGS[@]} \
  ..

make -j${CPU_COUNT}

set +ve