set -ve

mkdir build
cd build


cmake \
  -DCMAKE_CXX_COMPILER=${CXX} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DUSE_PYTHON_INCLUDE_DIR=OFF \
  -DPYTHON_EXECUTABLE=${PREFIX}/bin/python \
  -DPYBIND11_TEST=OFF \
  ..

make -j${CPU_COUNT}

set +ve