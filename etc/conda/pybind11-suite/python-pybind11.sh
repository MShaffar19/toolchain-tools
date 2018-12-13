set -ve

export PYBIND11_USE_CMAKE=1

${PYTHON} setup.py install --single-version-externally-managed --record record.txt

set +ve