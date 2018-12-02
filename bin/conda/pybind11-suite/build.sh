set -ve

${PYTHON} ${RECIPE_DIR}/filter.py --src=${PREFIX} --dst=filtered.pkl

mkdir build
cd build

cmake \
  -DCMAKE_CXX_COMPILER=${CXX} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DUSE_PYTHON_INCLUDE_DIR=ON \
  -DPYTHON_EXECUTABLE=${PREFIX}/bin/python \
  -DPYBIND11_TEST=OFF \
  ..

make -j${CPU_COUNT}
make install

export PYBIND11_USE_CMAKE=1
cd ..
${PYTHON} setup.py install --single-version-externally-managed --record record.txt

${PYTHON} ${RECIPE_DIR}/move.py --src=${PREFIX}/include --dst=${SRC_DIR}/Library/include --filtered=filtered.pkl
${PYTHON} ${RECIPE_DIR}/move.py --src=${PREFIX}/lib --dst=${SRC_DIR}/Library/lib --filtered=filtered.pkl

set +ve